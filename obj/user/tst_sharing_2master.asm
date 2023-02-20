
obj/user/tst_sharing_2master:     file format elf32-i386


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
  800031:	e8 35 03 00 00       	call   80036b <libmain>
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
  80004c:	a1 20 40 80 00       	mov    0x804020,%eax
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
  800075:	a1 20 40 80 00       	mov    0x804020,%eax
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
  80008d:	68 a0 35 80 00       	push   $0x8035a0
  800092:	6a 13                	push   $0x13
  800094:	68 bc 35 80 00       	push   $0x8035bc
  800099:	e8 09 04 00 00       	call   8004a7 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	6a 00                	push   $0x0
  8000a3:	e8 03 16 00 00       	call   8016ab <malloc>
  8000a8:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	uint32 *x, *y, *z ;

	//x: Readonly
	int freeFrames = sys_calculate_free_frames() ;
  8000ab:	e8 5f 1a 00 00       	call   801b0f <sys_calculate_free_frames>
  8000b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	x = smalloc("x", 4, 0);
  8000b3:	83 ec 04             	sub    $0x4,%esp
  8000b6:	6a 00                	push   $0x0
  8000b8:	6a 04                	push   $0x4
  8000ba:	68 d7 35 80 00       	push   $0x8035d7
  8000bf:	e8 48 17 00 00       	call   80180c <smalloc>
  8000c4:	83 c4 10             	add    $0x10,%esp
  8000c7:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if (x != (uint32*)USER_HEAP_START) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8000ca:	81 7d e8 00 00 00 80 	cmpl   $0x80000000,-0x18(%ebp)
  8000d1:	74 14                	je     8000e7 <_main+0xaf>
  8000d3:	83 ec 04             	sub    $0x4,%esp
  8000d6:	68 dc 35 80 00       	push   $0x8035dc
  8000db:	6a 1e                	push   $0x1e
  8000dd:	68 bc 35 80 00       	push   $0x8035bc
  8000e2:	e8 c0 03 00 00       	call   8004a7 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8000e7:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000ea:	e8 20 1a 00 00       	call   801b0f <sys_calculate_free_frames>
  8000ef:	29 c3                	sub    %eax,%ebx
  8000f1:	89 d8                	mov    %ebx,%eax
  8000f3:	83 f8 04             	cmp    $0x4,%eax
  8000f6:	74 14                	je     80010c <_main+0xd4>
  8000f8:	83 ec 04             	sub    $0x4,%esp
  8000fb:	68 40 36 80 00       	push   $0x803640
  800100:	6a 1f                	push   $0x1f
  800102:	68 bc 35 80 00       	push   $0x8035bc
  800107:	e8 9b 03 00 00       	call   8004a7 <_panic>

	//y: Readonly
	freeFrames = sys_calculate_free_frames() ;
  80010c:	e8 fe 19 00 00       	call   801b0f <sys_calculate_free_frames>
  800111:	89 45 ec             	mov    %eax,-0x14(%ebp)
	y = smalloc("y", 4, 0);
  800114:	83 ec 04             	sub    $0x4,%esp
  800117:	6a 00                	push   $0x0
  800119:	6a 04                	push   $0x4
  80011b:	68 c8 36 80 00       	push   $0x8036c8
  800120:	e8 e7 16 00 00       	call   80180c <smalloc>
  800125:	83 c4 10             	add    $0x10,%esp
  800128:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (y != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  80012b:	81 7d e4 00 10 00 80 	cmpl   $0x80001000,-0x1c(%ebp)
  800132:	74 14                	je     800148 <_main+0x110>
  800134:	83 ec 04             	sub    $0x4,%esp
  800137:	68 dc 35 80 00       	push   $0x8035dc
  80013c:	6a 24                	push   $0x24
  80013e:	68 bc 35 80 00       	push   $0x8035bc
  800143:	e8 5f 03 00 00       	call   8004a7 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800148:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  80014b:	e8 bf 19 00 00       	call   801b0f <sys_calculate_free_frames>
  800150:	29 c3                	sub    %eax,%ebx
  800152:	89 d8                	mov    %ebx,%eax
  800154:	83 f8 03             	cmp    $0x3,%eax
  800157:	74 14                	je     80016d <_main+0x135>
  800159:	83 ec 04             	sub    $0x4,%esp
  80015c:	68 40 36 80 00       	push   $0x803640
  800161:	6a 25                	push   $0x25
  800163:	68 bc 35 80 00       	push   $0x8035bc
  800168:	e8 3a 03 00 00       	call   8004a7 <_panic>

	//z: Writable
	freeFrames = sys_calculate_free_frames() ;
  80016d:	e8 9d 19 00 00       	call   801b0f <sys_calculate_free_frames>
  800172:	89 45 ec             	mov    %eax,-0x14(%ebp)
	z = smalloc("z", 4, 1);
  800175:	83 ec 04             	sub    $0x4,%esp
  800178:	6a 01                	push   $0x1
  80017a:	6a 04                	push   $0x4
  80017c:	68 ca 36 80 00       	push   $0x8036ca
  800181:	e8 86 16 00 00       	call   80180c <smalloc>
  800186:	83 c4 10             	add    $0x10,%esp
  800189:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (z != (uint32*)(USER_HEAP_START + 2 * PAGE_SIZE)) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  80018c:	81 7d e0 00 20 00 80 	cmpl   $0x80002000,-0x20(%ebp)
  800193:	74 14                	je     8001a9 <_main+0x171>
  800195:	83 ec 04             	sub    $0x4,%esp
  800198:	68 dc 35 80 00       	push   $0x8035dc
  80019d:	6a 2a                	push   $0x2a
  80019f:	68 bc 35 80 00       	push   $0x8035bc
  8001a4:	e8 fe 02 00 00       	call   8004a7 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8001a9:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8001ac:	e8 5e 19 00 00       	call   801b0f <sys_calculate_free_frames>
  8001b1:	29 c3                	sub    %eax,%ebx
  8001b3:	89 d8                	mov    %ebx,%eax
  8001b5:	83 f8 03             	cmp    $0x3,%eax
  8001b8:	74 14                	je     8001ce <_main+0x196>
  8001ba:	83 ec 04             	sub    $0x4,%esp
  8001bd:	68 40 36 80 00       	push   $0x803640
  8001c2:	6a 2b                	push   $0x2b
  8001c4:	68 bc 35 80 00       	push   $0x8035bc
  8001c9:	e8 d9 02 00 00       	call   8004a7 <_panic>

	*x = 10 ;
  8001ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001d1:	c7 00 0a 00 00 00    	movl   $0xa,(%eax)
	*y = 20 ;
  8001d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001da:	c7 00 14 00 00 00    	movl   $0x14,(%eax)

	int id1, id2, id3;
	id1 = sys_create_env("shr2Slave1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8001e0:	a1 20 40 80 00       	mov    0x804020,%eax
  8001e5:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8001eb:	a1 20 40 80 00       	mov    0x804020,%eax
  8001f0:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8001f6:	89 c1                	mov    %eax,%ecx
  8001f8:	a1 20 40 80 00       	mov    0x804020,%eax
  8001fd:	8b 40 74             	mov    0x74(%eax),%eax
  800200:	52                   	push   %edx
  800201:	51                   	push   %ecx
  800202:	50                   	push   %eax
  800203:	68 cc 36 80 00       	push   $0x8036cc
  800208:	e8 74 1b 00 00       	call   801d81 <sys_create_env>
  80020d:	83 c4 10             	add    $0x10,%esp
  800210:	89 45 dc             	mov    %eax,-0x24(%ebp)
	id2 = sys_create_env("shr2Slave1", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800213:	a1 20 40 80 00       	mov    0x804020,%eax
  800218:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  80021e:	a1 20 40 80 00       	mov    0x804020,%eax
  800223:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800229:	89 c1                	mov    %eax,%ecx
  80022b:	a1 20 40 80 00       	mov    0x804020,%eax
  800230:	8b 40 74             	mov    0x74(%eax),%eax
  800233:	52                   	push   %edx
  800234:	51                   	push   %ecx
  800235:	50                   	push   %eax
  800236:	68 cc 36 80 00       	push   $0x8036cc
  80023b:	e8 41 1b 00 00       	call   801d81 <sys_create_env>
  800240:	83 c4 10             	add    $0x10,%esp
  800243:	89 45 d8             	mov    %eax,-0x28(%ebp)
	id3 = sys_create_env("shr2Slave1", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800246:	a1 20 40 80 00       	mov    0x804020,%eax
  80024b:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800251:	a1 20 40 80 00       	mov    0x804020,%eax
  800256:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80025c:	89 c1                	mov    %eax,%ecx
  80025e:	a1 20 40 80 00       	mov    0x804020,%eax
  800263:	8b 40 74             	mov    0x74(%eax),%eax
  800266:	52                   	push   %edx
  800267:	51                   	push   %ecx
  800268:	50                   	push   %eax
  800269:	68 cc 36 80 00       	push   $0x8036cc
  80026e:	e8 0e 1b 00 00       	call   801d81 <sys_create_env>
  800273:	83 c4 10             	add    $0x10,%esp
  800276:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	//to check that the slave environments completed successfully
	rsttst();
  800279:	e8 4f 1c 00 00       	call   801ecd <rsttst>

	sys_run_env(id1);
  80027e:	83 ec 0c             	sub    $0xc,%esp
  800281:	ff 75 dc             	pushl  -0x24(%ebp)
  800284:	e8 16 1b 00 00       	call   801d9f <sys_run_env>
  800289:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id2);
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	ff 75 d8             	pushl  -0x28(%ebp)
  800292:	e8 08 1b 00 00       	call   801d9f <sys_run_env>
  800297:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id3);
  80029a:	83 ec 0c             	sub    $0xc,%esp
  80029d:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002a0:	e8 fa 1a 00 00       	call   801d9f <sys_run_env>
  8002a5:	83 c4 10             	add    $0x10,%esp

	env_sleep(12000) ;
  8002a8:	83 ec 0c             	sub    $0xc,%esp
  8002ab:	68 e0 2e 00 00       	push   $0x2ee0
  8002b0:	e8 c7 2f 00 00       	call   80327c <env_sleep>
  8002b5:	83 c4 10             	add    $0x10,%esp

	//to ensure that the slave environments completed successfully
	if (gettst()!=3) panic("test failed");
  8002b8:	e8 8a 1c 00 00       	call   801f47 <gettst>
  8002bd:	83 f8 03             	cmp    $0x3,%eax
  8002c0:	74 14                	je     8002d6 <_main+0x29e>
  8002c2:	83 ec 04             	sub    $0x4,%esp
  8002c5:	68 d7 36 80 00       	push   $0x8036d7
  8002ca:	6a 3f                	push   $0x3f
  8002cc:	68 bc 35 80 00       	push   $0x8035bc
  8002d1:	e8 d1 01 00 00       	call   8004a7 <_panic>


	if (*z != 30)
  8002d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002d9:	8b 00                	mov    (%eax),%eax
  8002db:	83 f8 1e             	cmp    $0x1e,%eax
  8002de:	74 14                	je     8002f4 <_main+0x2bc>
		panic("Error!! Please check the creation (or the getting) of shared variables!!\n\n\n");
  8002e0:	83 ec 04             	sub    $0x4,%esp
  8002e3:	68 e4 36 80 00       	push   $0x8036e4
  8002e8:	6a 43                	push   $0x43
  8002ea:	68 bc 35 80 00       	push   $0x8035bc
  8002ef:	e8 b3 01 00 00       	call   8004a7 <_panic>
	else
		cprintf("Congratulations!! Test of Shared Variables [Create & Get] [2] completed successfully!!\n\n\n");
  8002f4:	83 ec 0c             	sub    $0xc,%esp
  8002f7:	68 30 37 80 00       	push   $0x803730
  8002fc:	e8 5a 04 00 00       	call   80075b <cprintf>
  800301:	83 c4 10             	add    $0x10,%esp

	cprintf("Now, ILLEGAL MEM ACCESS should be occur, due to attempting to write a ReadOnly variable\n\n\n");
  800304:	83 ec 0c             	sub    $0xc,%esp
  800307:	68 8c 37 80 00       	push   $0x80378c
  80030c:	e8 4a 04 00 00       	call   80075b <cprintf>
  800311:	83 c4 10             	add    $0x10,%esp

	id1 = sys_create_env("shr2Slave2", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800314:	a1 20 40 80 00       	mov    0x804020,%eax
  800319:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  80031f:	a1 20 40 80 00       	mov    0x804020,%eax
  800324:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80032a:	89 c1                	mov    %eax,%ecx
  80032c:	a1 20 40 80 00       	mov    0x804020,%eax
  800331:	8b 40 74             	mov    0x74(%eax),%eax
  800334:	52                   	push   %edx
  800335:	51                   	push   %ecx
  800336:	50                   	push   %eax
  800337:	68 e7 37 80 00       	push   $0x8037e7
  80033c:	e8 40 1a 00 00       	call   801d81 <sys_create_env>
  800341:	83 c4 10             	add    $0x10,%esp
  800344:	89 45 dc             	mov    %eax,-0x24(%ebp)

	env_sleep(3000) ;
  800347:	83 ec 0c             	sub    $0xc,%esp
  80034a:	68 b8 0b 00 00       	push   $0xbb8
  80034f:	e8 28 2f 00 00       	call   80327c <env_sleep>
  800354:	83 c4 10             	add    $0x10,%esp

	sys_run_env(id1);
  800357:	83 ec 0c             	sub    $0xc,%esp
  80035a:	ff 75 dc             	pushl  -0x24(%ebp)
  80035d:	e8 3d 1a 00 00       	call   801d9f <sys_run_env>
  800362:	83 c4 10             	add    $0x10,%esp

	return;
  800365:	90                   	nop
}
  800366:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800369:	c9                   	leave  
  80036a:	c3                   	ret    

0080036b <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80036b:	55                   	push   %ebp
  80036c:	89 e5                	mov    %esp,%ebp
  80036e:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800371:	e8 79 1a 00 00       	call   801def <sys_getenvindex>
  800376:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800379:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80037c:	89 d0                	mov    %edx,%eax
  80037e:	c1 e0 03             	shl    $0x3,%eax
  800381:	01 d0                	add    %edx,%eax
  800383:	01 c0                	add    %eax,%eax
  800385:	01 d0                	add    %edx,%eax
  800387:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80038e:	01 d0                	add    %edx,%eax
  800390:	c1 e0 04             	shl    $0x4,%eax
  800393:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800398:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80039d:	a1 20 40 80 00       	mov    0x804020,%eax
  8003a2:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8003a8:	84 c0                	test   %al,%al
  8003aa:	74 0f                	je     8003bb <libmain+0x50>
		binaryname = myEnv->prog_name;
  8003ac:	a1 20 40 80 00       	mov    0x804020,%eax
  8003b1:	05 5c 05 00 00       	add    $0x55c,%eax
  8003b6:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003bb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8003bf:	7e 0a                	jle    8003cb <libmain+0x60>
		binaryname = argv[0];
  8003c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003c4:	8b 00                	mov    (%eax),%eax
  8003c6:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8003cb:	83 ec 08             	sub    $0x8,%esp
  8003ce:	ff 75 0c             	pushl  0xc(%ebp)
  8003d1:	ff 75 08             	pushl  0x8(%ebp)
  8003d4:	e8 5f fc ff ff       	call   800038 <_main>
  8003d9:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8003dc:	e8 1b 18 00 00       	call   801bfc <sys_disable_interrupt>
	cprintf("**************************************\n");
  8003e1:	83 ec 0c             	sub    $0xc,%esp
  8003e4:	68 0c 38 80 00       	push   $0x80380c
  8003e9:	e8 6d 03 00 00       	call   80075b <cprintf>
  8003ee:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8003f1:	a1 20 40 80 00       	mov    0x804020,%eax
  8003f6:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8003fc:	a1 20 40 80 00       	mov    0x804020,%eax
  800401:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800407:	83 ec 04             	sub    $0x4,%esp
  80040a:	52                   	push   %edx
  80040b:	50                   	push   %eax
  80040c:	68 34 38 80 00       	push   $0x803834
  800411:	e8 45 03 00 00       	call   80075b <cprintf>
  800416:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800419:	a1 20 40 80 00       	mov    0x804020,%eax
  80041e:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800424:	a1 20 40 80 00       	mov    0x804020,%eax
  800429:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80042f:	a1 20 40 80 00       	mov    0x804020,%eax
  800434:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80043a:	51                   	push   %ecx
  80043b:	52                   	push   %edx
  80043c:	50                   	push   %eax
  80043d:	68 5c 38 80 00       	push   $0x80385c
  800442:	e8 14 03 00 00       	call   80075b <cprintf>
  800447:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80044a:	a1 20 40 80 00       	mov    0x804020,%eax
  80044f:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800455:	83 ec 08             	sub    $0x8,%esp
  800458:	50                   	push   %eax
  800459:	68 b4 38 80 00       	push   $0x8038b4
  80045e:	e8 f8 02 00 00       	call   80075b <cprintf>
  800463:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800466:	83 ec 0c             	sub    $0xc,%esp
  800469:	68 0c 38 80 00       	push   $0x80380c
  80046e:	e8 e8 02 00 00       	call   80075b <cprintf>
  800473:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800476:	e8 9b 17 00 00       	call   801c16 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80047b:	e8 19 00 00 00       	call   800499 <exit>
}
  800480:	90                   	nop
  800481:	c9                   	leave  
  800482:	c3                   	ret    

00800483 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800483:	55                   	push   %ebp
  800484:	89 e5                	mov    %esp,%ebp
  800486:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800489:	83 ec 0c             	sub    $0xc,%esp
  80048c:	6a 00                	push   $0x0
  80048e:	e8 28 19 00 00       	call   801dbb <sys_destroy_env>
  800493:	83 c4 10             	add    $0x10,%esp
}
  800496:	90                   	nop
  800497:	c9                   	leave  
  800498:	c3                   	ret    

00800499 <exit>:

void
exit(void)
{
  800499:	55                   	push   %ebp
  80049a:	89 e5                	mov    %esp,%ebp
  80049c:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80049f:	e8 7d 19 00 00       	call   801e21 <sys_exit_env>
}
  8004a4:	90                   	nop
  8004a5:	c9                   	leave  
  8004a6:	c3                   	ret    

008004a7 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8004a7:	55                   	push   %ebp
  8004a8:	89 e5                	mov    %esp,%ebp
  8004aa:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8004ad:	8d 45 10             	lea    0x10(%ebp),%eax
  8004b0:	83 c0 04             	add    $0x4,%eax
  8004b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8004b6:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8004bb:	85 c0                	test   %eax,%eax
  8004bd:	74 16                	je     8004d5 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8004bf:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8004c4:	83 ec 08             	sub    $0x8,%esp
  8004c7:	50                   	push   %eax
  8004c8:	68 c8 38 80 00       	push   $0x8038c8
  8004cd:	e8 89 02 00 00       	call   80075b <cprintf>
  8004d2:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8004d5:	a1 00 40 80 00       	mov    0x804000,%eax
  8004da:	ff 75 0c             	pushl  0xc(%ebp)
  8004dd:	ff 75 08             	pushl  0x8(%ebp)
  8004e0:	50                   	push   %eax
  8004e1:	68 cd 38 80 00       	push   $0x8038cd
  8004e6:	e8 70 02 00 00       	call   80075b <cprintf>
  8004eb:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8004ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8004f1:	83 ec 08             	sub    $0x8,%esp
  8004f4:	ff 75 f4             	pushl  -0xc(%ebp)
  8004f7:	50                   	push   %eax
  8004f8:	e8 f3 01 00 00       	call   8006f0 <vcprintf>
  8004fd:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800500:	83 ec 08             	sub    $0x8,%esp
  800503:	6a 00                	push   $0x0
  800505:	68 e9 38 80 00       	push   $0x8038e9
  80050a:	e8 e1 01 00 00       	call   8006f0 <vcprintf>
  80050f:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800512:	e8 82 ff ff ff       	call   800499 <exit>

	// should not return here
	while (1) ;
  800517:	eb fe                	jmp    800517 <_panic+0x70>

00800519 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800519:	55                   	push   %ebp
  80051a:	89 e5                	mov    %esp,%ebp
  80051c:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80051f:	a1 20 40 80 00       	mov    0x804020,%eax
  800524:	8b 50 74             	mov    0x74(%eax),%edx
  800527:	8b 45 0c             	mov    0xc(%ebp),%eax
  80052a:	39 c2                	cmp    %eax,%edx
  80052c:	74 14                	je     800542 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80052e:	83 ec 04             	sub    $0x4,%esp
  800531:	68 ec 38 80 00       	push   $0x8038ec
  800536:	6a 26                	push   $0x26
  800538:	68 38 39 80 00       	push   $0x803938
  80053d:	e8 65 ff ff ff       	call   8004a7 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800542:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800549:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800550:	e9 c2 00 00 00       	jmp    800617 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800555:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800558:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80055f:	8b 45 08             	mov    0x8(%ebp),%eax
  800562:	01 d0                	add    %edx,%eax
  800564:	8b 00                	mov    (%eax),%eax
  800566:	85 c0                	test   %eax,%eax
  800568:	75 08                	jne    800572 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80056a:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80056d:	e9 a2 00 00 00       	jmp    800614 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800572:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800579:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800580:	eb 69                	jmp    8005eb <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800582:	a1 20 40 80 00       	mov    0x804020,%eax
  800587:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80058d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800590:	89 d0                	mov    %edx,%eax
  800592:	01 c0                	add    %eax,%eax
  800594:	01 d0                	add    %edx,%eax
  800596:	c1 e0 03             	shl    $0x3,%eax
  800599:	01 c8                	add    %ecx,%eax
  80059b:	8a 40 04             	mov    0x4(%eax),%al
  80059e:	84 c0                	test   %al,%al
  8005a0:	75 46                	jne    8005e8 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005a2:	a1 20 40 80 00       	mov    0x804020,%eax
  8005a7:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8005ad:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005b0:	89 d0                	mov    %edx,%eax
  8005b2:	01 c0                	add    %eax,%eax
  8005b4:	01 d0                	add    %edx,%eax
  8005b6:	c1 e0 03             	shl    $0x3,%eax
  8005b9:	01 c8                	add    %ecx,%eax
  8005bb:	8b 00                	mov    (%eax),%eax
  8005bd:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005c0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005c3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005c8:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8005ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005cd:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d7:	01 c8                	add    %ecx,%eax
  8005d9:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005db:	39 c2                	cmp    %eax,%edx
  8005dd:	75 09                	jne    8005e8 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8005df:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8005e6:	eb 12                	jmp    8005fa <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005e8:	ff 45 e8             	incl   -0x18(%ebp)
  8005eb:	a1 20 40 80 00       	mov    0x804020,%eax
  8005f0:	8b 50 74             	mov    0x74(%eax),%edx
  8005f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005f6:	39 c2                	cmp    %eax,%edx
  8005f8:	77 88                	ja     800582 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8005fa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8005fe:	75 14                	jne    800614 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800600:	83 ec 04             	sub    $0x4,%esp
  800603:	68 44 39 80 00       	push   $0x803944
  800608:	6a 3a                	push   $0x3a
  80060a:	68 38 39 80 00       	push   $0x803938
  80060f:	e8 93 fe ff ff       	call   8004a7 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800614:	ff 45 f0             	incl   -0x10(%ebp)
  800617:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80061a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80061d:	0f 8c 32 ff ff ff    	jl     800555 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800623:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80062a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800631:	eb 26                	jmp    800659 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800633:	a1 20 40 80 00       	mov    0x804020,%eax
  800638:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80063e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800641:	89 d0                	mov    %edx,%eax
  800643:	01 c0                	add    %eax,%eax
  800645:	01 d0                	add    %edx,%eax
  800647:	c1 e0 03             	shl    $0x3,%eax
  80064a:	01 c8                	add    %ecx,%eax
  80064c:	8a 40 04             	mov    0x4(%eax),%al
  80064f:	3c 01                	cmp    $0x1,%al
  800651:	75 03                	jne    800656 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800653:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800656:	ff 45 e0             	incl   -0x20(%ebp)
  800659:	a1 20 40 80 00       	mov    0x804020,%eax
  80065e:	8b 50 74             	mov    0x74(%eax),%edx
  800661:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800664:	39 c2                	cmp    %eax,%edx
  800666:	77 cb                	ja     800633 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800668:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80066b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80066e:	74 14                	je     800684 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800670:	83 ec 04             	sub    $0x4,%esp
  800673:	68 98 39 80 00       	push   $0x803998
  800678:	6a 44                	push   $0x44
  80067a:	68 38 39 80 00       	push   $0x803938
  80067f:	e8 23 fe ff ff       	call   8004a7 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800684:	90                   	nop
  800685:	c9                   	leave  
  800686:	c3                   	ret    

00800687 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800687:	55                   	push   %ebp
  800688:	89 e5                	mov    %esp,%ebp
  80068a:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80068d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800690:	8b 00                	mov    (%eax),%eax
  800692:	8d 48 01             	lea    0x1(%eax),%ecx
  800695:	8b 55 0c             	mov    0xc(%ebp),%edx
  800698:	89 0a                	mov    %ecx,(%edx)
  80069a:	8b 55 08             	mov    0x8(%ebp),%edx
  80069d:	88 d1                	mov    %dl,%cl
  80069f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006a2:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8006a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006a9:	8b 00                	mov    (%eax),%eax
  8006ab:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006b0:	75 2c                	jne    8006de <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8006b2:	a0 24 40 80 00       	mov    0x804024,%al
  8006b7:	0f b6 c0             	movzbl %al,%eax
  8006ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006bd:	8b 12                	mov    (%edx),%edx
  8006bf:	89 d1                	mov    %edx,%ecx
  8006c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006c4:	83 c2 08             	add    $0x8,%edx
  8006c7:	83 ec 04             	sub    $0x4,%esp
  8006ca:	50                   	push   %eax
  8006cb:	51                   	push   %ecx
  8006cc:	52                   	push   %edx
  8006cd:	e8 7c 13 00 00       	call   801a4e <sys_cputs>
  8006d2:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006e1:	8b 40 04             	mov    0x4(%eax),%eax
  8006e4:	8d 50 01             	lea    0x1(%eax),%edx
  8006e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ea:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006ed:	90                   	nop
  8006ee:	c9                   	leave  
  8006ef:	c3                   	ret    

008006f0 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006f0:	55                   	push   %ebp
  8006f1:	89 e5                	mov    %esp,%ebp
  8006f3:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006f9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800700:	00 00 00 
	b.cnt = 0;
  800703:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80070a:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80070d:	ff 75 0c             	pushl  0xc(%ebp)
  800710:	ff 75 08             	pushl  0x8(%ebp)
  800713:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800719:	50                   	push   %eax
  80071a:	68 87 06 80 00       	push   $0x800687
  80071f:	e8 11 02 00 00       	call   800935 <vprintfmt>
  800724:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800727:	a0 24 40 80 00       	mov    0x804024,%al
  80072c:	0f b6 c0             	movzbl %al,%eax
  80072f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800735:	83 ec 04             	sub    $0x4,%esp
  800738:	50                   	push   %eax
  800739:	52                   	push   %edx
  80073a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800740:	83 c0 08             	add    $0x8,%eax
  800743:	50                   	push   %eax
  800744:	e8 05 13 00 00       	call   801a4e <sys_cputs>
  800749:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80074c:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800753:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800759:	c9                   	leave  
  80075a:	c3                   	ret    

0080075b <cprintf>:

int cprintf(const char *fmt, ...) {
  80075b:	55                   	push   %ebp
  80075c:	89 e5                	mov    %esp,%ebp
  80075e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800761:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800768:	8d 45 0c             	lea    0xc(%ebp),%eax
  80076b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80076e:	8b 45 08             	mov    0x8(%ebp),%eax
  800771:	83 ec 08             	sub    $0x8,%esp
  800774:	ff 75 f4             	pushl  -0xc(%ebp)
  800777:	50                   	push   %eax
  800778:	e8 73 ff ff ff       	call   8006f0 <vcprintf>
  80077d:	83 c4 10             	add    $0x10,%esp
  800780:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800783:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800786:	c9                   	leave  
  800787:	c3                   	ret    

00800788 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800788:	55                   	push   %ebp
  800789:	89 e5                	mov    %esp,%ebp
  80078b:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80078e:	e8 69 14 00 00       	call   801bfc <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800793:	8d 45 0c             	lea    0xc(%ebp),%eax
  800796:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800799:	8b 45 08             	mov    0x8(%ebp),%eax
  80079c:	83 ec 08             	sub    $0x8,%esp
  80079f:	ff 75 f4             	pushl  -0xc(%ebp)
  8007a2:	50                   	push   %eax
  8007a3:	e8 48 ff ff ff       	call   8006f0 <vcprintf>
  8007a8:	83 c4 10             	add    $0x10,%esp
  8007ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8007ae:	e8 63 14 00 00       	call   801c16 <sys_enable_interrupt>
	return cnt;
  8007b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007b6:	c9                   	leave  
  8007b7:	c3                   	ret    

008007b8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007b8:	55                   	push   %ebp
  8007b9:	89 e5                	mov    %esp,%ebp
  8007bb:	53                   	push   %ebx
  8007bc:	83 ec 14             	sub    $0x14,%esp
  8007bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8007c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007cb:	8b 45 18             	mov    0x18(%ebp),%eax
  8007ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8007d3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007d6:	77 55                	ja     80082d <printnum+0x75>
  8007d8:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007db:	72 05                	jb     8007e2 <printnum+0x2a>
  8007dd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8007e0:	77 4b                	ja     80082d <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007e2:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8007e5:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8007e8:	8b 45 18             	mov    0x18(%ebp),%eax
  8007eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8007f0:	52                   	push   %edx
  8007f1:	50                   	push   %eax
  8007f2:	ff 75 f4             	pushl  -0xc(%ebp)
  8007f5:	ff 75 f0             	pushl  -0x10(%ebp)
  8007f8:	e8 33 2b 00 00       	call   803330 <__udivdi3>
  8007fd:	83 c4 10             	add    $0x10,%esp
  800800:	83 ec 04             	sub    $0x4,%esp
  800803:	ff 75 20             	pushl  0x20(%ebp)
  800806:	53                   	push   %ebx
  800807:	ff 75 18             	pushl  0x18(%ebp)
  80080a:	52                   	push   %edx
  80080b:	50                   	push   %eax
  80080c:	ff 75 0c             	pushl  0xc(%ebp)
  80080f:	ff 75 08             	pushl  0x8(%ebp)
  800812:	e8 a1 ff ff ff       	call   8007b8 <printnum>
  800817:	83 c4 20             	add    $0x20,%esp
  80081a:	eb 1a                	jmp    800836 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80081c:	83 ec 08             	sub    $0x8,%esp
  80081f:	ff 75 0c             	pushl  0xc(%ebp)
  800822:	ff 75 20             	pushl  0x20(%ebp)
  800825:	8b 45 08             	mov    0x8(%ebp),%eax
  800828:	ff d0                	call   *%eax
  80082a:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80082d:	ff 4d 1c             	decl   0x1c(%ebp)
  800830:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800834:	7f e6                	jg     80081c <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800836:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800839:	bb 00 00 00 00       	mov    $0x0,%ebx
  80083e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800841:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800844:	53                   	push   %ebx
  800845:	51                   	push   %ecx
  800846:	52                   	push   %edx
  800847:	50                   	push   %eax
  800848:	e8 f3 2b 00 00       	call   803440 <__umoddi3>
  80084d:	83 c4 10             	add    $0x10,%esp
  800850:	05 14 3c 80 00       	add    $0x803c14,%eax
  800855:	8a 00                	mov    (%eax),%al
  800857:	0f be c0             	movsbl %al,%eax
  80085a:	83 ec 08             	sub    $0x8,%esp
  80085d:	ff 75 0c             	pushl  0xc(%ebp)
  800860:	50                   	push   %eax
  800861:	8b 45 08             	mov    0x8(%ebp),%eax
  800864:	ff d0                	call   *%eax
  800866:	83 c4 10             	add    $0x10,%esp
}
  800869:	90                   	nop
  80086a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80086d:	c9                   	leave  
  80086e:	c3                   	ret    

0080086f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80086f:	55                   	push   %ebp
  800870:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800872:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800876:	7e 1c                	jle    800894 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800878:	8b 45 08             	mov    0x8(%ebp),%eax
  80087b:	8b 00                	mov    (%eax),%eax
  80087d:	8d 50 08             	lea    0x8(%eax),%edx
  800880:	8b 45 08             	mov    0x8(%ebp),%eax
  800883:	89 10                	mov    %edx,(%eax)
  800885:	8b 45 08             	mov    0x8(%ebp),%eax
  800888:	8b 00                	mov    (%eax),%eax
  80088a:	83 e8 08             	sub    $0x8,%eax
  80088d:	8b 50 04             	mov    0x4(%eax),%edx
  800890:	8b 00                	mov    (%eax),%eax
  800892:	eb 40                	jmp    8008d4 <getuint+0x65>
	else if (lflag)
  800894:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800898:	74 1e                	je     8008b8 <getuint+0x49>
		return va_arg(*ap, unsigned long);
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
  8008b6:	eb 1c                	jmp    8008d4 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bb:	8b 00                	mov    (%eax),%eax
  8008bd:	8d 50 04             	lea    0x4(%eax),%edx
  8008c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c3:	89 10                	mov    %edx,(%eax)
  8008c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c8:	8b 00                	mov    (%eax),%eax
  8008ca:	83 e8 04             	sub    $0x4,%eax
  8008cd:	8b 00                	mov    (%eax),%eax
  8008cf:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8008d4:	5d                   	pop    %ebp
  8008d5:	c3                   	ret    

008008d6 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008d6:	55                   	push   %ebp
  8008d7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008d9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008dd:	7e 1c                	jle    8008fb <getint+0x25>
		return va_arg(*ap, long long);
  8008df:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e2:	8b 00                	mov    (%eax),%eax
  8008e4:	8d 50 08             	lea    0x8(%eax),%edx
  8008e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ea:	89 10                	mov    %edx,(%eax)
  8008ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ef:	8b 00                	mov    (%eax),%eax
  8008f1:	83 e8 08             	sub    $0x8,%eax
  8008f4:	8b 50 04             	mov    0x4(%eax),%edx
  8008f7:	8b 00                	mov    (%eax),%eax
  8008f9:	eb 38                	jmp    800933 <getint+0x5d>
	else if (lflag)
  8008fb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008ff:	74 1a                	je     80091b <getint+0x45>
		return va_arg(*ap, long);
  800901:	8b 45 08             	mov    0x8(%ebp),%eax
  800904:	8b 00                	mov    (%eax),%eax
  800906:	8d 50 04             	lea    0x4(%eax),%edx
  800909:	8b 45 08             	mov    0x8(%ebp),%eax
  80090c:	89 10                	mov    %edx,(%eax)
  80090e:	8b 45 08             	mov    0x8(%ebp),%eax
  800911:	8b 00                	mov    (%eax),%eax
  800913:	83 e8 04             	sub    $0x4,%eax
  800916:	8b 00                	mov    (%eax),%eax
  800918:	99                   	cltd   
  800919:	eb 18                	jmp    800933 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80091b:	8b 45 08             	mov    0x8(%ebp),%eax
  80091e:	8b 00                	mov    (%eax),%eax
  800920:	8d 50 04             	lea    0x4(%eax),%edx
  800923:	8b 45 08             	mov    0x8(%ebp),%eax
  800926:	89 10                	mov    %edx,(%eax)
  800928:	8b 45 08             	mov    0x8(%ebp),%eax
  80092b:	8b 00                	mov    (%eax),%eax
  80092d:	83 e8 04             	sub    $0x4,%eax
  800930:	8b 00                	mov    (%eax),%eax
  800932:	99                   	cltd   
}
  800933:	5d                   	pop    %ebp
  800934:	c3                   	ret    

00800935 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800935:	55                   	push   %ebp
  800936:	89 e5                	mov    %esp,%ebp
  800938:	56                   	push   %esi
  800939:	53                   	push   %ebx
  80093a:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80093d:	eb 17                	jmp    800956 <vprintfmt+0x21>
			if (ch == '\0')
  80093f:	85 db                	test   %ebx,%ebx
  800941:	0f 84 af 03 00 00    	je     800cf6 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800947:	83 ec 08             	sub    $0x8,%esp
  80094a:	ff 75 0c             	pushl  0xc(%ebp)
  80094d:	53                   	push   %ebx
  80094e:	8b 45 08             	mov    0x8(%ebp),%eax
  800951:	ff d0                	call   *%eax
  800953:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800956:	8b 45 10             	mov    0x10(%ebp),%eax
  800959:	8d 50 01             	lea    0x1(%eax),%edx
  80095c:	89 55 10             	mov    %edx,0x10(%ebp)
  80095f:	8a 00                	mov    (%eax),%al
  800961:	0f b6 d8             	movzbl %al,%ebx
  800964:	83 fb 25             	cmp    $0x25,%ebx
  800967:	75 d6                	jne    80093f <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800969:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80096d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800974:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80097b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800982:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800989:	8b 45 10             	mov    0x10(%ebp),%eax
  80098c:	8d 50 01             	lea    0x1(%eax),%edx
  80098f:	89 55 10             	mov    %edx,0x10(%ebp)
  800992:	8a 00                	mov    (%eax),%al
  800994:	0f b6 d8             	movzbl %al,%ebx
  800997:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80099a:	83 f8 55             	cmp    $0x55,%eax
  80099d:	0f 87 2b 03 00 00    	ja     800cce <vprintfmt+0x399>
  8009a3:	8b 04 85 38 3c 80 00 	mov    0x803c38(,%eax,4),%eax
  8009aa:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009ac:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009b0:	eb d7                	jmp    800989 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009b2:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009b6:	eb d1                	jmp    800989 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009b8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009bf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009c2:	89 d0                	mov    %edx,%eax
  8009c4:	c1 e0 02             	shl    $0x2,%eax
  8009c7:	01 d0                	add    %edx,%eax
  8009c9:	01 c0                	add    %eax,%eax
  8009cb:	01 d8                	add    %ebx,%eax
  8009cd:	83 e8 30             	sub    $0x30,%eax
  8009d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8009d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8009d6:	8a 00                	mov    (%eax),%al
  8009d8:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009db:	83 fb 2f             	cmp    $0x2f,%ebx
  8009de:	7e 3e                	jle    800a1e <vprintfmt+0xe9>
  8009e0:	83 fb 39             	cmp    $0x39,%ebx
  8009e3:	7f 39                	jg     800a1e <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009e5:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009e8:	eb d5                	jmp    8009bf <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8009ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ed:	83 c0 04             	add    $0x4,%eax
  8009f0:	89 45 14             	mov    %eax,0x14(%ebp)
  8009f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f6:	83 e8 04             	sub    $0x4,%eax
  8009f9:	8b 00                	mov    (%eax),%eax
  8009fb:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8009fe:	eb 1f                	jmp    800a1f <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a00:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a04:	79 83                	jns    800989 <vprintfmt+0x54>
				width = 0;
  800a06:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a0d:	e9 77 ff ff ff       	jmp    800989 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a12:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a19:	e9 6b ff ff ff       	jmp    800989 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a1e:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a1f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a23:	0f 89 60 ff ff ff    	jns    800989 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a29:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a2c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a2f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a36:	e9 4e ff ff ff       	jmp    800989 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a3b:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a3e:	e9 46 ff ff ff       	jmp    800989 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a43:	8b 45 14             	mov    0x14(%ebp),%eax
  800a46:	83 c0 04             	add    $0x4,%eax
  800a49:	89 45 14             	mov    %eax,0x14(%ebp)
  800a4c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a4f:	83 e8 04             	sub    $0x4,%eax
  800a52:	8b 00                	mov    (%eax),%eax
  800a54:	83 ec 08             	sub    $0x8,%esp
  800a57:	ff 75 0c             	pushl  0xc(%ebp)
  800a5a:	50                   	push   %eax
  800a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5e:	ff d0                	call   *%eax
  800a60:	83 c4 10             	add    $0x10,%esp
			break;
  800a63:	e9 89 02 00 00       	jmp    800cf1 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a68:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6b:	83 c0 04             	add    $0x4,%eax
  800a6e:	89 45 14             	mov    %eax,0x14(%ebp)
  800a71:	8b 45 14             	mov    0x14(%ebp),%eax
  800a74:	83 e8 04             	sub    $0x4,%eax
  800a77:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a79:	85 db                	test   %ebx,%ebx
  800a7b:	79 02                	jns    800a7f <vprintfmt+0x14a>
				err = -err;
  800a7d:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a7f:	83 fb 64             	cmp    $0x64,%ebx
  800a82:	7f 0b                	jg     800a8f <vprintfmt+0x15a>
  800a84:	8b 34 9d 80 3a 80 00 	mov    0x803a80(,%ebx,4),%esi
  800a8b:	85 f6                	test   %esi,%esi
  800a8d:	75 19                	jne    800aa8 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a8f:	53                   	push   %ebx
  800a90:	68 25 3c 80 00       	push   $0x803c25
  800a95:	ff 75 0c             	pushl  0xc(%ebp)
  800a98:	ff 75 08             	pushl  0x8(%ebp)
  800a9b:	e8 5e 02 00 00       	call   800cfe <printfmt>
  800aa0:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800aa3:	e9 49 02 00 00       	jmp    800cf1 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800aa8:	56                   	push   %esi
  800aa9:	68 2e 3c 80 00       	push   $0x803c2e
  800aae:	ff 75 0c             	pushl  0xc(%ebp)
  800ab1:	ff 75 08             	pushl  0x8(%ebp)
  800ab4:	e8 45 02 00 00       	call   800cfe <printfmt>
  800ab9:	83 c4 10             	add    $0x10,%esp
			break;
  800abc:	e9 30 02 00 00       	jmp    800cf1 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ac1:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac4:	83 c0 04             	add    $0x4,%eax
  800ac7:	89 45 14             	mov    %eax,0x14(%ebp)
  800aca:	8b 45 14             	mov    0x14(%ebp),%eax
  800acd:	83 e8 04             	sub    $0x4,%eax
  800ad0:	8b 30                	mov    (%eax),%esi
  800ad2:	85 f6                	test   %esi,%esi
  800ad4:	75 05                	jne    800adb <vprintfmt+0x1a6>
				p = "(null)";
  800ad6:	be 31 3c 80 00       	mov    $0x803c31,%esi
			if (width > 0 && padc != '-')
  800adb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800adf:	7e 6d                	jle    800b4e <vprintfmt+0x219>
  800ae1:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800ae5:	74 67                	je     800b4e <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ae7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800aea:	83 ec 08             	sub    $0x8,%esp
  800aed:	50                   	push   %eax
  800aee:	56                   	push   %esi
  800aef:	e8 0c 03 00 00       	call   800e00 <strnlen>
  800af4:	83 c4 10             	add    $0x10,%esp
  800af7:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800afa:	eb 16                	jmp    800b12 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800afc:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b00:	83 ec 08             	sub    $0x8,%esp
  800b03:	ff 75 0c             	pushl  0xc(%ebp)
  800b06:	50                   	push   %eax
  800b07:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0a:	ff d0                	call   *%eax
  800b0c:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b0f:	ff 4d e4             	decl   -0x1c(%ebp)
  800b12:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b16:	7f e4                	jg     800afc <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b18:	eb 34                	jmp    800b4e <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b1a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b1e:	74 1c                	je     800b3c <vprintfmt+0x207>
  800b20:	83 fb 1f             	cmp    $0x1f,%ebx
  800b23:	7e 05                	jle    800b2a <vprintfmt+0x1f5>
  800b25:	83 fb 7e             	cmp    $0x7e,%ebx
  800b28:	7e 12                	jle    800b3c <vprintfmt+0x207>
					putch('?', putdat);
  800b2a:	83 ec 08             	sub    $0x8,%esp
  800b2d:	ff 75 0c             	pushl  0xc(%ebp)
  800b30:	6a 3f                	push   $0x3f
  800b32:	8b 45 08             	mov    0x8(%ebp),%eax
  800b35:	ff d0                	call   *%eax
  800b37:	83 c4 10             	add    $0x10,%esp
  800b3a:	eb 0f                	jmp    800b4b <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b3c:	83 ec 08             	sub    $0x8,%esp
  800b3f:	ff 75 0c             	pushl  0xc(%ebp)
  800b42:	53                   	push   %ebx
  800b43:	8b 45 08             	mov    0x8(%ebp),%eax
  800b46:	ff d0                	call   *%eax
  800b48:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b4b:	ff 4d e4             	decl   -0x1c(%ebp)
  800b4e:	89 f0                	mov    %esi,%eax
  800b50:	8d 70 01             	lea    0x1(%eax),%esi
  800b53:	8a 00                	mov    (%eax),%al
  800b55:	0f be d8             	movsbl %al,%ebx
  800b58:	85 db                	test   %ebx,%ebx
  800b5a:	74 24                	je     800b80 <vprintfmt+0x24b>
  800b5c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b60:	78 b8                	js     800b1a <vprintfmt+0x1e5>
  800b62:	ff 4d e0             	decl   -0x20(%ebp)
  800b65:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b69:	79 af                	jns    800b1a <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b6b:	eb 13                	jmp    800b80 <vprintfmt+0x24b>
				putch(' ', putdat);
  800b6d:	83 ec 08             	sub    $0x8,%esp
  800b70:	ff 75 0c             	pushl  0xc(%ebp)
  800b73:	6a 20                	push   $0x20
  800b75:	8b 45 08             	mov    0x8(%ebp),%eax
  800b78:	ff d0                	call   *%eax
  800b7a:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b7d:	ff 4d e4             	decl   -0x1c(%ebp)
  800b80:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b84:	7f e7                	jg     800b6d <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b86:	e9 66 01 00 00       	jmp    800cf1 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b8b:	83 ec 08             	sub    $0x8,%esp
  800b8e:	ff 75 e8             	pushl  -0x18(%ebp)
  800b91:	8d 45 14             	lea    0x14(%ebp),%eax
  800b94:	50                   	push   %eax
  800b95:	e8 3c fd ff ff       	call   8008d6 <getint>
  800b9a:	83 c4 10             	add    $0x10,%esp
  800b9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ba0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800ba3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ba6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ba9:	85 d2                	test   %edx,%edx
  800bab:	79 23                	jns    800bd0 <vprintfmt+0x29b>
				putch('-', putdat);
  800bad:	83 ec 08             	sub    $0x8,%esp
  800bb0:	ff 75 0c             	pushl  0xc(%ebp)
  800bb3:	6a 2d                	push   $0x2d
  800bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb8:	ff d0                	call   *%eax
  800bba:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800bbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bc0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bc3:	f7 d8                	neg    %eax
  800bc5:	83 d2 00             	adc    $0x0,%edx
  800bc8:	f7 da                	neg    %edx
  800bca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bcd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800bd0:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bd7:	e9 bc 00 00 00       	jmp    800c98 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800bdc:	83 ec 08             	sub    $0x8,%esp
  800bdf:	ff 75 e8             	pushl  -0x18(%ebp)
  800be2:	8d 45 14             	lea    0x14(%ebp),%eax
  800be5:	50                   	push   %eax
  800be6:	e8 84 fc ff ff       	call   80086f <getuint>
  800beb:	83 c4 10             	add    $0x10,%esp
  800bee:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bf1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800bf4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bfb:	e9 98 00 00 00       	jmp    800c98 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c00:	83 ec 08             	sub    $0x8,%esp
  800c03:	ff 75 0c             	pushl  0xc(%ebp)
  800c06:	6a 58                	push   $0x58
  800c08:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0b:	ff d0                	call   *%eax
  800c0d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c10:	83 ec 08             	sub    $0x8,%esp
  800c13:	ff 75 0c             	pushl  0xc(%ebp)
  800c16:	6a 58                	push   $0x58
  800c18:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1b:	ff d0                	call   *%eax
  800c1d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c20:	83 ec 08             	sub    $0x8,%esp
  800c23:	ff 75 0c             	pushl  0xc(%ebp)
  800c26:	6a 58                	push   $0x58
  800c28:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2b:	ff d0                	call   *%eax
  800c2d:	83 c4 10             	add    $0x10,%esp
			break;
  800c30:	e9 bc 00 00 00       	jmp    800cf1 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800c35:	83 ec 08             	sub    $0x8,%esp
  800c38:	ff 75 0c             	pushl  0xc(%ebp)
  800c3b:	6a 30                	push   $0x30
  800c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c40:	ff d0                	call   *%eax
  800c42:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c45:	83 ec 08             	sub    $0x8,%esp
  800c48:	ff 75 0c             	pushl  0xc(%ebp)
  800c4b:	6a 78                	push   $0x78
  800c4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c50:	ff d0                	call   *%eax
  800c52:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c55:	8b 45 14             	mov    0x14(%ebp),%eax
  800c58:	83 c0 04             	add    $0x4,%eax
  800c5b:	89 45 14             	mov    %eax,0x14(%ebp)
  800c5e:	8b 45 14             	mov    0x14(%ebp),%eax
  800c61:	83 e8 04             	sub    $0x4,%eax
  800c64:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c66:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c69:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c70:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c77:	eb 1f                	jmp    800c98 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c79:	83 ec 08             	sub    $0x8,%esp
  800c7c:	ff 75 e8             	pushl  -0x18(%ebp)
  800c7f:	8d 45 14             	lea    0x14(%ebp),%eax
  800c82:	50                   	push   %eax
  800c83:	e8 e7 fb ff ff       	call   80086f <getuint>
  800c88:	83 c4 10             	add    $0x10,%esp
  800c8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c8e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800c91:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c98:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800c9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c9f:	83 ec 04             	sub    $0x4,%esp
  800ca2:	52                   	push   %edx
  800ca3:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ca6:	50                   	push   %eax
  800ca7:	ff 75 f4             	pushl  -0xc(%ebp)
  800caa:	ff 75 f0             	pushl  -0x10(%ebp)
  800cad:	ff 75 0c             	pushl  0xc(%ebp)
  800cb0:	ff 75 08             	pushl  0x8(%ebp)
  800cb3:	e8 00 fb ff ff       	call   8007b8 <printnum>
  800cb8:	83 c4 20             	add    $0x20,%esp
			break;
  800cbb:	eb 34                	jmp    800cf1 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cbd:	83 ec 08             	sub    $0x8,%esp
  800cc0:	ff 75 0c             	pushl  0xc(%ebp)
  800cc3:	53                   	push   %ebx
  800cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc7:	ff d0                	call   *%eax
  800cc9:	83 c4 10             	add    $0x10,%esp
			break;
  800ccc:	eb 23                	jmp    800cf1 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800cce:	83 ec 08             	sub    $0x8,%esp
  800cd1:	ff 75 0c             	pushl  0xc(%ebp)
  800cd4:	6a 25                	push   $0x25
  800cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd9:	ff d0                	call   *%eax
  800cdb:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800cde:	ff 4d 10             	decl   0x10(%ebp)
  800ce1:	eb 03                	jmp    800ce6 <vprintfmt+0x3b1>
  800ce3:	ff 4d 10             	decl   0x10(%ebp)
  800ce6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ce9:	48                   	dec    %eax
  800cea:	8a 00                	mov    (%eax),%al
  800cec:	3c 25                	cmp    $0x25,%al
  800cee:	75 f3                	jne    800ce3 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800cf0:	90                   	nop
		}
	}
  800cf1:	e9 47 fc ff ff       	jmp    80093d <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800cf6:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800cf7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800cfa:	5b                   	pop    %ebx
  800cfb:	5e                   	pop    %esi
  800cfc:	5d                   	pop    %ebp
  800cfd:	c3                   	ret    

00800cfe <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800cfe:	55                   	push   %ebp
  800cff:	89 e5                	mov    %esp,%ebp
  800d01:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d04:	8d 45 10             	lea    0x10(%ebp),%eax
  800d07:	83 c0 04             	add    $0x4,%eax
  800d0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d0d:	8b 45 10             	mov    0x10(%ebp),%eax
  800d10:	ff 75 f4             	pushl  -0xc(%ebp)
  800d13:	50                   	push   %eax
  800d14:	ff 75 0c             	pushl  0xc(%ebp)
  800d17:	ff 75 08             	pushl  0x8(%ebp)
  800d1a:	e8 16 fc ff ff       	call   800935 <vprintfmt>
  800d1f:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d22:	90                   	nop
  800d23:	c9                   	leave  
  800d24:	c3                   	ret    

00800d25 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d25:	55                   	push   %ebp
  800d26:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2b:	8b 40 08             	mov    0x8(%eax),%eax
  800d2e:	8d 50 01             	lea    0x1(%eax),%edx
  800d31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d34:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3a:	8b 10                	mov    (%eax),%edx
  800d3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3f:	8b 40 04             	mov    0x4(%eax),%eax
  800d42:	39 c2                	cmp    %eax,%edx
  800d44:	73 12                	jae    800d58 <sprintputch+0x33>
		*b->buf++ = ch;
  800d46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d49:	8b 00                	mov    (%eax),%eax
  800d4b:	8d 48 01             	lea    0x1(%eax),%ecx
  800d4e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d51:	89 0a                	mov    %ecx,(%edx)
  800d53:	8b 55 08             	mov    0x8(%ebp),%edx
  800d56:	88 10                	mov    %dl,(%eax)
}
  800d58:	90                   	nop
  800d59:	5d                   	pop    %ebp
  800d5a:	c3                   	ret    

00800d5b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d5b:	55                   	push   %ebp
  800d5c:	89 e5                	mov    %esp,%ebp
  800d5e:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d61:	8b 45 08             	mov    0x8(%ebp),%eax
  800d64:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d67:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d70:	01 d0                	add    %edx,%eax
  800d72:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d75:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d7c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d80:	74 06                	je     800d88 <vsnprintf+0x2d>
  800d82:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d86:	7f 07                	jg     800d8f <vsnprintf+0x34>
		return -E_INVAL;
  800d88:	b8 03 00 00 00       	mov    $0x3,%eax
  800d8d:	eb 20                	jmp    800daf <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d8f:	ff 75 14             	pushl  0x14(%ebp)
  800d92:	ff 75 10             	pushl  0x10(%ebp)
  800d95:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d98:	50                   	push   %eax
  800d99:	68 25 0d 80 00       	push   $0x800d25
  800d9e:	e8 92 fb ff ff       	call   800935 <vprintfmt>
  800da3:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800da6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800da9:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800dac:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800daf:	c9                   	leave  
  800db0:	c3                   	ret    

00800db1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800db1:	55                   	push   %ebp
  800db2:	89 e5                	mov    %esp,%ebp
  800db4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800db7:	8d 45 10             	lea    0x10(%ebp),%eax
  800dba:	83 c0 04             	add    $0x4,%eax
  800dbd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800dc0:	8b 45 10             	mov    0x10(%ebp),%eax
  800dc3:	ff 75 f4             	pushl  -0xc(%ebp)
  800dc6:	50                   	push   %eax
  800dc7:	ff 75 0c             	pushl  0xc(%ebp)
  800dca:	ff 75 08             	pushl  0x8(%ebp)
  800dcd:	e8 89 ff ff ff       	call   800d5b <vsnprintf>
  800dd2:	83 c4 10             	add    $0x10,%esp
  800dd5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800dd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ddb:	c9                   	leave  
  800ddc:	c3                   	ret    

00800ddd <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800ddd:	55                   	push   %ebp
  800dde:	89 e5                	mov    %esp,%ebp
  800de0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800de3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dea:	eb 06                	jmp    800df2 <strlen+0x15>
		n++;
  800dec:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800def:	ff 45 08             	incl   0x8(%ebp)
  800df2:	8b 45 08             	mov    0x8(%ebp),%eax
  800df5:	8a 00                	mov    (%eax),%al
  800df7:	84 c0                	test   %al,%al
  800df9:	75 f1                	jne    800dec <strlen+0xf>
		n++;
	return n;
  800dfb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800dfe:	c9                   	leave  
  800dff:	c3                   	ret    

00800e00 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e00:	55                   	push   %ebp
  800e01:	89 e5                	mov    %esp,%ebp
  800e03:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e06:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e0d:	eb 09                	jmp    800e18 <strnlen+0x18>
		n++;
  800e0f:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e12:	ff 45 08             	incl   0x8(%ebp)
  800e15:	ff 4d 0c             	decl   0xc(%ebp)
  800e18:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e1c:	74 09                	je     800e27 <strnlen+0x27>
  800e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e21:	8a 00                	mov    (%eax),%al
  800e23:	84 c0                	test   %al,%al
  800e25:	75 e8                	jne    800e0f <strnlen+0xf>
		n++;
	return n;
  800e27:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e2a:	c9                   	leave  
  800e2b:	c3                   	ret    

00800e2c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e2c:	55                   	push   %ebp
  800e2d:	89 e5                	mov    %esp,%ebp
  800e2f:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e32:	8b 45 08             	mov    0x8(%ebp),%eax
  800e35:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e38:	90                   	nop
  800e39:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3c:	8d 50 01             	lea    0x1(%eax),%edx
  800e3f:	89 55 08             	mov    %edx,0x8(%ebp)
  800e42:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e45:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e48:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e4b:	8a 12                	mov    (%edx),%dl
  800e4d:	88 10                	mov    %dl,(%eax)
  800e4f:	8a 00                	mov    (%eax),%al
  800e51:	84 c0                	test   %al,%al
  800e53:	75 e4                	jne    800e39 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e55:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e58:	c9                   	leave  
  800e59:	c3                   	ret    

00800e5a <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e5a:	55                   	push   %ebp
  800e5b:	89 e5                	mov    %esp,%ebp
  800e5d:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e60:	8b 45 08             	mov    0x8(%ebp),%eax
  800e63:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e66:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e6d:	eb 1f                	jmp    800e8e <strncpy+0x34>
		*dst++ = *src;
  800e6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e72:	8d 50 01             	lea    0x1(%eax),%edx
  800e75:	89 55 08             	mov    %edx,0x8(%ebp)
  800e78:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e7b:	8a 12                	mov    (%edx),%dl
  800e7d:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800e7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e82:	8a 00                	mov    (%eax),%al
  800e84:	84 c0                	test   %al,%al
  800e86:	74 03                	je     800e8b <strncpy+0x31>
			src++;
  800e88:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e8b:	ff 45 fc             	incl   -0x4(%ebp)
  800e8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e91:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e94:	72 d9                	jb     800e6f <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800e96:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e99:	c9                   	leave  
  800e9a:	c3                   	ret    

00800e9b <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800e9b:	55                   	push   %ebp
  800e9c:	89 e5                	mov    %esp,%ebp
  800e9e:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ea7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eab:	74 30                	je     800edd <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ead:	eb 16                	jmp    800ec5 <strlcpy+0x2a>
			*dst++ = *src++;
  800eaf:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb2:	8d 50 01             	lea    0x1(%eax),%edx
  800eb5:	89 55 08             	mov    %edx,0x8(%ebp)
  800eb8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ebb:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ebe:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ec1:	8a 12                	mov    (%edx),%dl
  800ec3:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ec5:	ff 4d 10             	decl   0x10(%ebp)
  800ec8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ecc:	74 09                	je     800ed7 <strlcpy+0x3c>
  800ece:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed1:	8a 00                	mov    (%eax),%al
  800ed3:	84 c0                	test   %al,%al
  800ed5:	75 d8                	jne    800eaf <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ed7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eda:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800edd:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee3:	29 c2                	sub    %eax,%edx
  800ee5:	89 d0                	mov    %edx,%eax
}
  800ee7:	c9                   	leave  
  800ee8:	c3                   	ret    

00800ee9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ee9:	55                   	push   %ebp
  800eea:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800eec:	eb 06                	jmp    800ef4 <strcmp+0xb>
		p++, q++;
  800eee:	ff 45 08             	incl   0x8(%ebp)
  800ef1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ef4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef7:	8a 00                	mov    (%eax),%al
  800ef9:	84 c0                	test   %al,%al
  800efb:	74 0e                	je     800f0b <strcmp+0x22>
  800efd:	8b 45 08             	mov    0x8(%ebp),%eax
  800f00:	8a 10                	mov    (%eax),%dl
  800f02:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f05:	8a 00                	mov    (%eax),%al
  800f07:	38 c2                	cmp    %al,%dl
  800f09:	74 e3                	je     800eee <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0e:	8a 00                	mov    (%eax),%al
  800f10:	0f b6 d0             	movzbl %al,%edx
  800f13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f16:	8a 00                	mov    (%eax),%al
  800f18:	0f b6 c0             	movzbl %al,%eax
  800f1b:	29 c2                	sub    %eax,%edx
  800f1d:	89 d0                	mov    %edx,%eax
}
  800f1f:	5d                   	pop    %ebp
  800f20:	c3                   	ret    

00800f21 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f21:	55                   	push   %ebp
  800f22:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f24:	eb 09                	jmp    800f2f <strncmp+0xe>
		n--, p++, q++;
  800f26:	ff 4d 10             	decl   0x10(%ebp)
  800f29:	ff 45 08             	incl   0x8(%ebp)
  800f2c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f2f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f33:	74 17                	je     800f4c <strncmp+0x2b>
  800f35:	8b 45 08             	mov    0x8(%ebp),%eax
  800f38:	8a 00                	mov    (%eax),%al
  800f3a:	84 c0                	test   %al,%al
  800f3c:	74 0e                	je     800f4c <strncmp+0x2b>
  800f3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f41:	8a 10                	mov    (%eax),%dl
  800f43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f46:	8a 00                	mov    (%eax),%al
  800f48:	38 c2                	cmp    %al,%dl
  800f4a:	74 da                	je     800f26 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f4c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f50:	75 07                	jne    800f59 <strncmp+0x38>
		return 0;
  800f52:	b8 00 00 00 00       	mov    $0x0,%eax
  800f57:	eb 14                	jmp    800f6d <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f59:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5c:	8a 00                	mov    (%eax),%al
  800f5e:	0f b6 d0             	movzbl %al,%edx
  800f61:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f64:	8a 00                	mov    (%eax),%al
  800f66:	0f b6 c0             	movzbl %al,%eax
  800f69:	29 c2                	sub    %eax,%edx
  800f6b:	89 d0                	mov    %edx,%eax
}
  800f6d:	5d                   	pop    %ebp
  800f6e:	c3                   	ret    

00800f6f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f6f:	55                   	push   %ebp
  800f70:	89 e5                	mov    %esp,%ebp
  800f72:	83 ec 04             	sub    $0x4,%esp
  800f75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f78:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f7b:	eb 12                	jmp    800f8f <strchr+0x20>
		if (*s == c)
  800f7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f80:	8a 00                	mov    (%eax),%al
  800f82:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f85:	75 05                	jne    800f8c <strchr+0x1d>
			return (char *) s;
  800f87:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8a:	eb 11                	jmp    800f9d <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800f8c:	ff 45 08             	incl   0x8(%ebp)
  800f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f92:	8a 00                	mov    (%eax),%al
  800f94:	84 c0                	test   %al,%al
  800f96:	75 e5                	jne    800f7d <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800f98:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f9d:	c9                   	leave  
  800f9e:	c3                   	ret    

00800f9f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f9f:	55                   	push   %ebp
  800fa0:	89 e5                	mov    %esp,%ebp
  800fa2:	83 ec 04             	sub    $0x4,%esp
  800fa5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa8:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fab:	eb 0d                	jmp    800fba <strfind+0x1b>
		if (*s == c)
  800fad:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb0:	8a 00                	mov    (%eax),%al
  800fb2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fb5:	74 0e                	je     800fc5 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800fb7:	ff 45 08             	incl   0x8(%ebp)
  800fba:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbd:	8a 00                	mov    (%eax),%al
  800fbf:	84 c0                	test   %al,%al
  800fc1:	75 ea                	jne    800fad <strfind+0xe>
  800fc3:	eb 01                	jmp    800fc6 <strfind+0x27>
		if (*s == c)
			break;
  800fc5:	90                   	nop
	return (char *) s;
  800fc6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fc9:	c9                   	leave  
  800fca:	c3                   	ret    

00800fcb <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800fcb:	55                   	push   %ebp
  800fcc:	89 e5                	mov    %esp,%ebp
  800fce:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800fd7:	8b 45 10             	mov    0x10(%ebp),%eax
  800fda:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800fdd:	eb 0e                	jmp    800fed <memset+0x22>
		*p++ = c;
  800fdf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fe2:	8d 50 01             	lea    0x1(%eax),%edx
  800fe5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800fe8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800feb:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800fed:	ff 4d f8             	decl   -0x8(%ebp)
  800ff0:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800ff4:	79 e9                	jns    800fdf <memset+0x14>
		*p++ = c;

	return v;
  800ff6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ff9:	c9                   	leave  
  800ffa:	c3                   	ret    

00800ffb <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800ffb:	55                   	push   %ebp
  800ffc:	89 e5                	mov    %esp,%ebp
  800ffe:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801001:	8b 45 0c             	mov    0xc(%ebp),%eax
  801004:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801007:	8b 45 08             	mov    0x8(%ebp),%eax
  80100a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80100d:	eb 16                	jmp    801025 <memcpy+0x2a>
		*d++ = *s++;
  80100f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801012:	8d 50 01             	lea    0x1(%eax),%edx
  801015:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801018:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80101b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80101e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801021:	8a 12                	mov    (%edx),%dl
  801023:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801025:	8b 45 10             	mov    0x10(%ebp),%eax
  801028:	8d 50 ff             	lea    -0x1(%eax),%edx
  80102b:	89 55 10             	mov    %edx,0x10(%ebp)
  80102e:	85 c0                	test   %eax,%eax
  801030:	75 dd                	jne    80100f <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801032:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801035:	c9                   	leave  
  801036:	c3                   	ret    

00801037 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801037:	55                   	push   %ebp
  801038:	89 e5                	mov    %esp,%ebp
  80103a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80103d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801040:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801043:	8b 45 08             	mov    0x8(%ebp),%eax
  801046:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801049:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80104c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80104f:	73 50                	jae    8010a1 <memmove+0x6a>
  801051:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801054:	8b 45 10             	mov    0x10(%ebp),%eax
  801057:	01 d0                	add    %edx,%eax
  801059:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80105c:	76 43                	jbe    8010a1 <memmove+0x6a>
		s += n;
  80105e:	8b 45 10             	mov    0x10(%ebp),%eax
  801061:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801064:	8b 45 10             	mov    0x10(%ebp),%eax
  801067:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80106a:	eb 10                	jmp    80107c <memmove+0x45>
			*--d = *--s;
  80106c:	ff 4d f8             	decl   -0x8(%ebp)
  80106f:	ff 4d fc             	decl   -0x4(%ebp)
  801072:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801075:	8a 10                	mov    (%eax),%dl
  801077:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80107a:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80107c:	8b 45 10             	mov    0x10(%ebp),%eax
  80107f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801082:	89 55 10             	mov    %edx,0x10(%ebp)
  801085:	85 c0                	test   %eax,%eax
  801087:	75 e3                	jne    80106c <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801089:	eb 23                	jmp    8010ae <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80108b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80108e:	8d 50 01             	lea    0x1(%eax),%edx
  801091:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801094:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801097:	8d 4a 01             	lea    0x1(%edx),%ecx
  80109a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80109d:	8a 12                	mov    (%edx),%dl
  80109f:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8010a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8010a4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010a7:	89 55 10             	mov    %edx,0x10(%ebp)
  8010aa:	85 c0                	test   %eax,%eax
  8010ac:	75 dd                	jne    80108b <memmove+0x54>
			*d++ = *s++;

	return dst;
  8010ae:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010b1:	c9                   	leave  
  8010b2:	c3                   	ret    

008010b3 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8010b3:	55                   	push   %ebp
  8010b4:	89 e5                	mov    %esp,%ebp
  8010b6:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8010b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8010bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c2:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8010c5:	eb 2a                	jmp    8010f1 <memcmp+0x3e>
		if (*s1 != *s2)
  8010c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ca:	8a 10                	mov    (%eax),%dl
  8010cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010cf:	8a 00                	mov    (%eax),%al
  8010d1:	38 c2                	cmp    %al,%dl
  8010d3:	74 16                	je     8010eb <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8010d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010d8:	8a 00                	mov    (%eax),%al
  8010da:	0f b6 d0             	movzbl %al,%edx
  8010dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e0:	8a 00                	mov    (%eax),%al
  8010e2:	0f b6 c0             	movzbl %al,%eax
  8010e5:	29 c2                	sub    %eax,%edx
  8010e7:	89 d0                	mov    %edx,%eax
  8010e9:	eb 18                	jmp    801103 <memcmp+0x50>
		s1++, s2++;
  8010eb:	ff 45 fc             	incl   -0x4(%ebp)
  8010ee:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8010f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010f7:	89 55 10             	mov    %edx,0x10(%ebp)
  8010fa:	85 c0                	test   %eax,%eax
  8010fc:	75 c9                	jne    8010c7 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8010fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801103:	c9                   	leave  
  801104:	c3                   	ret    

00801105 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801105:	55                   	push   %ebp
  801106:	89 e5                	mov    %esp,%ebp
  801108:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80110b:	8b 55 08             	mov    0x8(%ebp),%edx
  80110e:	8b 45 10             	mov    0x10(%ebp),%eax
  801111:	01 d0                	add    %edx,%eax
  801113:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801116:	eb 15                	jmp    80112d <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801118:	8b 45 08             	mov    0x8(%ebp),%eax
  80111b:	8a 00                	mov    (%eax),%al
  80111d:	0f b6 d0             	movzbl %al,%edx
  801120:	8b 45 0c             	mov    0xc(%ebp),%eax
  801123:	0f b6 c0             	movzbl %al,%eax
  801126:	39 c2                	cmp    %eax,%edx
  801128:	74 0d                	je     801137 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80112a:	ff 45 08             	incl   0x8(%ebp)
  80112d:	8b 45 08             	mov    0x8(%ebp),%eax
  801130:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801133:	72 e3                	jb     801118 <memfind+0x13>
  801135:	eb 01                	jmp    801138 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801137:	90                   	nop
	return (void *) s;
  801138:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80113b:	c9                   	leave  
  80113c:	c3                   	ret    

0080113d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80113d:	55                   	push   %ebp
  80113e:	89 e5                	mov    %esp,%ebp
  801140:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801143:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80114a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801151:	eb 03                	jmp    801156 <strtol+0x19>
		s++;
  801153:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801156:	8b 45 08             	mov    0x8(%ebp),%eax
  801159:	8a 00                	mov    (%eax),%al
  80115b:	3c 20                	cmp    $0x20,%al
  80115d:	74 f4                	je     801153 <strtol+0x16>
  80115f:	8b 45 08             	mov    0x8(%ebp),%eax
  801162:	8a 00                	mov    (%eax),%al
  801164:	3c 09                	cmp    $0x9,%al
  801166:	74 eb                	je     801153 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801168:	8b 45 08             	mov    0x8(%ebp),%eax
  80116b:	8a 00                	mov    (%eax),%al
  80116d:	3c 2b                	cmp    $0x2b,%al
  80116f:	75 05                	jne    801176 <strtol+0x39>
		s++;
  801171:	ff 45 08             	incl   0x8(%ebp)
  801174:	eb 13                	jmp    801189 <strtol+0x4c>
	else if (*s == '-')
  801176:	8b 45 08             	mov    0x8(%ebp),%eax
  801179:	8a 00                	mov    (%eax),%al
  80117b:	3c 2d                	cmp    $0x2d,%al
  80117d:	75 0a                	jne    801189 <strtol+0x4c>
		s++, neg = 1;
  80117f:	ff 45 08             	incl   0x8(%ebp)
  801182:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801189:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80118d:	74 06                	je     801195 <strtol+0x58>
  80118f:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801193:	75 20                	jne    8011b5 <strtol+0x78>
  801195:	8b 45 08             	mov    0x8(%ebp),%eax
  801198:	8a 00                	mov    (%eax),%al
  80119a:	3c 30                	cmp    $0x30,%al
  80119c:	75 17                	jne    8011b5 <strtol+0x78>
  80119e:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a1:	40                   	inc    %eax
  8011a2:	8a 00                	mov    (%eax),%al
  8011a4:	3c 78                	cmp    $0x78,%al
  8011a6:	75 0d                	jne    8011b5 <strtol+0x78>
		s += 2, base = 16;
  8011a8:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8011ac:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8011b3:	eb 28                	jmp    8011dd <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8011b5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011b9:	75 15                	jne    8011d0 <strtol+0x93>
  8011bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011be:	8a 00                	mov    (%eax),%al
  8011c0:	3c 30                	cmp    $0x30,%al
  8011c2:	75 0c                	jne    8011d0 <strtol+0x93>
		s++, base = 8;
  8011c4:	ff 45 08             	incl   0x8(%ebp)
  8011c7:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8011ce:	eb 0d                	jmp    8011dd <strtol+0xa0>
	else if (base == 0)
  8011d0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011d4:	75 07                	jne    8011dd <strtol+0xa0>
		base = 10;
  8011d6:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8011dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e0:	8a 00                	mov    (%eax),%al
  8011e2:	3c 2f                	cmp    $0x2f,%al
  8011e4:	7e 19                	jle    8011ff <strtol+0xc2>
  8011e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e9:	8a 00                	mov    (%eax),%al
  8011eb:	3c 39                	cmp    $0x39,%al
  8011ed:	7f 10                	jg     8011ff <strtol+0xc2>
			dig = *s - '0';
  8011ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f2:	8a 00                	mov    (%eax),%al
  8011f4:	0f be c0             	movsbl %al,%eax
  8011f7:	83 e8 30             	sub    $0x30,%eax
  8011fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011fd:	eb 42                	jmp    801241 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8011ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801202:	8a 00                	mov    (%eax),%al
  801204:	3c 60                	cmp    $0x60,%al
  801206:	7e 19                	jle    801221 <strtol+0xe4>
  801208:	8b 45 08             	mov    0x8(%ebp),%eax
  80120b:	8a 00                	mov    (%eax),%al
  80120d:	3c 7a                	cmp    $0x7a,%al
  80120f:	7f 10                	jg     801221 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801211:	8b 45 08             	mov    0x8(%ebp),%eax
  801214:	8a 00                	mov    (%eax),%al
  801216:	0f be c0             	movsbl %al,%eax
  801219:	83 e8 57             	sub    $0x57,%eax
  80121c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80121f:	eb 20                	jmp    801241 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801221:	8b 45 08             	mov    0x8(%ebp),%eax
  801224:	8a 00                	mov    (%eax),%al
  801226:	3c 40                	cmp    $0x40,%al
  801228:	7e 39                	jle    801263 <strtol+0x126>
  80122a:	8b 45 08             	mov    0x8(%ebp),%eax
  80122d:	8a 00                	mov    (%eax),%al
  80122f:	3c 5a                	cmp    $0x5a,%al
  801231:	7f 30                	jg     801263 <strtol+0x126>
			dig = *s - 'A' + 10;
  801233:	8b 45 08             	mov    0x8(%ebp),%eax
  801236:	8a 00                	mov    (%eax),%al
  801238:	0f be c0             	movsbl %al,%eax
  80123b:	83 e8 37             	sub    $0x37,%eax
  80123e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801241:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801244:	3b 45 10             	cmp    0x10(%ebp),%eax
  801247:	7d 19                	jge    801262 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801249:	ff 45 08             	incl   0x8(%ebp)
  80124c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80124f:	0f af 45 10          	imul   0x10(%ebp),%eax
  801253:	89 c2                	mov    %eax,%edx
  801255:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801258:	01 d0                	add    %edx,%eax
  80125a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80125d:	e9 7b ff ff ff       	jmp    8011dd <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801262:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801263:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801267:	74 08                	je     801271 <strtol+0x134>
		*endptr = (char *) s;
  801269:	8b 45 0c             	mov    0xc(%ebp),%eax
  80126c:	8b 55 08             	mov    0x8(%ebp),%edx
  80126f:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801271:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801275:	74 07                	je     80127e <strtol+0x141>
  801277:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80127a:	f7 d8                	neg    %eax
  80127c:	eb 03                	jmp    801281 <strtol+0x144>
  80127e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801281:	c9                   	leave  
  801282:	c3                   	ret    

00801283 <ltostr>:

void
ltostr(long value, char *str)
{
  801283:	55                   	push   %ebp
  801284:	89 e5                	mov    %esp,%ebp
  801286:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801289:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801290:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801297:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80129b:	79 13                	jns    8012b0 <ltostr+0x2d>
	{
		neg = 1;
  80129d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8012a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a7:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8012aa:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8012ad:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8012b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b3:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8012b8:	99                   	cltd   
  8012b9:	f7 f9                	idiv   %ecx
  8012bb:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8012be:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012c1:	8d 50 01             	lea    0x1(%eax),%edx
  8012c4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012c7:	89 c2                	mov    %eax,%edx
  8012c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012cc:	01 d0                	add    %edx,%eax
  8012ce:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012d1:	83 c2 30             	add    $0x30,%edx
  8012d4:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8012d6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012d9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012de:	f7 e9                	imul   %ecx
  8012e0:	c1 fa 02             	sar    $0x2,%edx
  8012e3:	89 c8                	mov    %ecx,%eax
  8012e5:	c1 f8 1f             	sar    $0x1f,%eax
  8012e8:	29 c2                	sub    %eax,%edx
  8012ea:	89 d0                	mov    %edx,%eax
  8012ec:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8012ef:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012f2:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012f7:	f7 e9                	imul   %ecx
  8012f9:	c1 fa 02             	sar    $0x2,%edx
  8012fc:	89 c8                	mov    %ecx,%eax
  8012fe:	c1 f8 1f             	sar    $0x1f,%eax
  801301:	29 c2                	sub    %eax,%edx
  801303:	89 d0                	mov    %edx,%eax
  801305:	c1 e0 02             	shl    $0x2,%eax
  801308:	01 d0                	add    %edx,%eax
  80130a:	01 c0                	add    %eax,%eax
  80130c:	29 c1                	sub    %eax,%ecx
  80130e:	89 ca                	mov    %ecx,%edx
  801310:	85 d2                	test   %edx,%edx
  801312:	75 9c                	jne    8012b0 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801314:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80131b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80131e:	48                   	dec    %eax
  80131f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801322:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801326:	74 3d                	je     801365 <ltostr+0xe2>
		start = 1 ;
  801328:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80132f:	eb 34                	jmp    801365 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801331:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801334:	8b 45 0c             	mov    0xc(%ebp),%eax
  801337:	01 d0                	add    %edx,%eax
  801339:	8a 00                	mov    (%eax),%al
  80133b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80133e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801341:	8b 45 0c             	mov    0xc(%ebp),%eax
  801344:	01 c2                	add    %eax,%edx
  801346:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801349:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134c:	01 c8                	add    %ecx,%eax
  80134e:	8a 00                	mov    (%eax),%al
  801350:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801352:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801355:	8b 45 0c             	mov    0xc(%ebp),%eax
  801358:	01 c2                	add    %eax,%edx
  80135a:	8a 45 eb             	mov    -0x15(%ebp),%al
  80135d:	88 02                	mov    %al,(%edx)
		start++ ;
  80135f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801362:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801365:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801368:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80136b:	7c c4                	jl     801331 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80136d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801370:	8b 45 0c             	mov    0xc(%ebp),%eax
  801373:	01 d0                	add    %edx,%eax
  801375:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801378:	90                   	nop
  801379:	c9                   	leave  
  80137a:	c3                   	ret    

0080137b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80137b:	55                   	push   %ebp
  80137c:	89 e5                	mov    %esp,%ebp
  80137e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801381:	ff 75 08             	pushl  0x8(%ebp)
  801384:	e8 54 fa ff ff       	call   800ddd <strlen>
  801389:	83 c4 04             	add    $0x4,%esp
  80138c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80138f:	ff 75 0c             	pushl  0xc(%ebp)
  801392:	e8 46 fa ff ff       	call   800ddd <strlen>
  801397:	83 c4 04             	add    $0x4,%esp
  80139a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80139d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8013a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013ab:	eb 17                	jmp    8013c4 <strcconcat+0x49>
		final[s] = str1[s] ;
  8013ad:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8013b3:	01 c2                	add    %eax,%edx
  8013b5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bb:	01 c8                	add    %ecx,%eax
  8013bd:	8a 00                	mov    (%eax),%al
  8013bf:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8013c1:	ff 45 fc             	incl   -0x4(%ebp)
  8013c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013c7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8013ca:	7c e1                	jl     8013ad <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8013cc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8013d3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8013da:	eb 1f                	jmp    8013fb <strcconcat+0x80>
		final[s++] = str2[i] ;
  8013dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013df:	8d 50 01             	lea    0x1(%eax),%edx
  8013e2:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8013e5:	89 c2                	mov    %eax,%edx
  8013e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8013ea:	01 c2                	add    %eax,%edx
  8013ec:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8013ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f2:	01 c8                	add    %ecx,%eax
  8013f4:	8a 00                	mov    (%eax),%al
  8013f6:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8013f8:	ff 45 f8             	incl   -0x8(%ebp)
  8013fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013fe:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801401:	7c d9                	jl     8013dc <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801403:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801406:	8b 45 10             	mov    0x10(%ebp),%eax
  801409:	01 d0                	add    %edx,%eax
  80140b:	c6 00 00             	movb   $0x0,(%eax)
}
  80140e:	90                   	nop
  80140f:	c9                   	leave  
  801410:	c3                   	ret    

00801411 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801411:	55                   	push   %ebp
  801412:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801414:	8b 45 14             	mov    0x14(%ebp),%eax
  801417:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80141d:	8b 45 14             	mov    0x14(%ebp),%eax
  801420:	8b 00                	mov    (%eax),%eax
  801422:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801429:	8b 45 10             	mov    0x10(%ebp),%eax
  80142c:	01 d0                	add    %edx,%eax
  80142e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801434:	eb 0c                	jmp    801442 <strsplit+0x31>
			*string++ = 0;
  801436:	8b 45 08             	mov    0x8(%ebp),%eax
  801439:	8d 50 01             	lea    0x1(%eax),%edx
  80143c:	89 55 08             	mov    %edx,0x8(%ebp)
  80143f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801442:	8b 45 08             	mov    0x8(%ebp),%eax
  801445:	8a 00                	mov    (%eax),%al
  801447:	84 c0                	test   %al,%al
  801449:	74 18                	je     801463 <strsplit+0x52>
  80144b:	8b 45 08             	mov    0x8(%ebp),%eax
  80144e:	8a 00                	mov    (%eax),%al
  801450:	0f be c0             	movsbl %al,%eax
  801453:	50                   	push   %eax
  801454:	ff 75 0c             	pushl  0xc(%ebp)
  801457:	e8 13 fb ff ff       	call   800f6f <strchr>
  80145c:	83 c4 08             	add    $0x8,%esp
  80145f:	85 c0                	test   %eax,%eax
  801461:	75 d3                	jne    801436 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801463:	8b 45 08             	mov    0x8(%ebp),%eax
  801466:	8a 00                	mov    (%eax),%al
  801468:	84 c0                	test   %al,%al
  80146a:	74 5a                	je     8014c6 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80146c:	8b 45 14             	mov    0x14(%ebp),%eax
  80146f:	8b 00                	mov    (%eax),%eax
  801471:	83 f8 0f             	cmp    $0xf,%eax
  801474:	75 07                	jne    80147d <strsplit+0x6c>
		{
			return 0;
  801476:	b8 00 00 00 00       	mov    $0x0,%eax
  80147b:	eb 66                	jmp    8014e3 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80147d:	8b 45 14             	mov    0x14(%ebp),%eax
  801480:	8b 00                	mov    (%eax),%eax
  801482:	8d 48 01             	lea    0x1(%eax),%ecx
  801485:	8b 55 14             	mov    0x14(%ebp),%edx
  801488:	89 0a                	mov    %ecx,(%edx)
  80148a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801491:	8b 45 10             	mov    0x10(%ebp),%eax
  801494:	01 c2                	add    %eax,%edx
  801496:	8b 45 08             	mov    0x8(%ebp),%eax
  801499:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80149b:	eb 03                	jmp    8014a0 <strsplit+0x8f>
			string++;
  80149d:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a3:	8a 00                	mov    (%eax),%al
  8014a5:	84 c0                	test   %al,%al
  8014a7:	74 8b                	je     801434 <strsplit+0x23>
  8014a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ac:	8a 00                	mov    (%eax),%al
  8014ae:	0f be c0             	movsbl %al,%eax
  8014b1:	50                   	push   %eax
  8014b2:	ff 75 0c             	pushl  0xc(%ebp)
  8014b5:	e8 b5 fa ff ff       	call   800f6f <strchr>
  8014ba:	83 c4 08             	add    $0x8,%esp
  8014bd:	85 c0                	test   %eax,%eax
  8014bf:	74 dc                	je     80149d <strsplit+0x8c>
			string++;
	}
  8014c1:	e9 6e ff ff ff       	jmp    801434 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8014c6:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8014c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8014ca:	8b 00                	mov    (%eax),%eax
  8014cc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8014d6:	01 d0                	add    %edx,%eax
  8014d8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8014de:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8014e3:	c9                   	leave  
  8014e4:	c3                   	ret    

008014e5 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8014e5:	55                   	push   %ebp
  8014e6:	89 e5                	mov    %esp,%ebp
  8014e8:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8014eb:	a1 04 40 80 00       	mov    0x804004,%eax
  8014f0:	85 c0                	test   %eax,%eax
  8014f2:	74 1f                	je     801513 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8014f4:	e8 1d 00 00 00       	call   801516 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8014f9:	83 ec 0c             	sub    $0xc,%esp
  8014fc:	68 90 3d 80 00       	push   $0x803d90
  801501:	e8 55 f2 ff ff       	call   80075b <cprintf>
  801506:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801509:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  801510:	00 00 00 
	}
}
  801513:	90                   	nop
  801514:	c9                   	leave  
  801515:	c3                   	ret    

00801516 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801516:	55                   	push   %ebp
  801517:	89 e5                	mov    %esp,%ebp
  801519:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");
LIST_INIT(&AllocMemBlocksList);
  80151c:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801523:	00 00 00 
  801526:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80152d:	00 00 00 
  801530:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801537:	00 00 00 
LIST_INIT(&FreeMemBlocksList);
  80153a:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801541:	00 00 00 
  801544:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  80154b:	00 00 00 
  80154e:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801555:	00 00 00 
MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  801558:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  80155f:	00 02 00 
uint32 requiredSpace=sizeof(struct MemBlock)*NUM_OF_UHEAP_PAGES;
  801562:	c7 45 f4 00 00 20 00 	movl   $0x200000,-0xc(%ebp)
		MemBlockNodes=(struct MemBlock*)USER_DYN_BLKS_ARRAY;
  801569:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801570:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801573:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801578:	2d 00 10 00 00       	sub    $0x1000,%eax
  80157d:	a3 50 40 80 00       	mov    %eax,0x804050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,requiredSpace,PERM_WRITEABLE|PERM_USER);
  801582:	c7 45 ec 00 00 e0 7f 	movl   $0x7fe00000,-0x14(%ebp)
  801589:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80158c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801591:	2d 00 10 00 00       	sub    $0x1000,%eax
  801596:	83 ec 04             	sub    $0x4,%esp
  801599:	6a 06                	push   $0x6
  80159b:	ff 75 f4             	pushl  -0xc(%ebp)
  80159e:	50                   	push   %eax
  80159f:	e8 ee 05 00 00       	call   801b92 <sys_allocate_chunk>
  8015a4:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8015a7:	a1 20 41 80 00       	mov    0x804120,%eax
  8015ac:	83 ec 0c             	sub    $0xc,%esp
  8015af:	50                   	push   %eax
  8015b0:	e8 63 0c 00 00       	call   802218 <initialize_MemBlocksList>
  8015b5:	83 c4 10             	add    $0x10,%esp
			struct MemBlock *freeSva=AvailableMemBlocksList.lh_last;
  8015b8:	a1 4c 41 80 00       	mov    0x80414c,%eax
  8015bd:	89 45 e8             	mov    %eax,-0x18(%ebp)
			freeSva->size=USER_HEAP_MAX-USER_HEAP_START;
  8015c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015c3:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
			freeSva->size=ROUNDDOWN(freeSva->size,PAGE_SIZE);
  8015ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015cd:	8b 40 0c             	mov    0xc(%eax),%eax
  8015d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8015d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015d6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015db:	89 c2                	mov    %eax,%edx
  8015dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015e0:	89 50 0c             	mov    %edx,0xc(%eax)

			freeSva->sva=USER_HEAP_START;
  8015e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015e6:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
			freeSva->sva=ROUNDUP(freeSva->sva,PAGE_SIZE);
  8015ed:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8015f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015f7:	8b 50 08             	mov    0x8(%eax),%edx
  8015fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015fd:	01 d0                	add    %edx,%eax
  8015ff:	48                   	dec    %eax
  801600:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801603:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801606:	ba 00 00 00 00       	mov    $0x0,%edx
  80160b:	f7 75 e0             	divl   -0x20(%ebp)
  80160e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801611:	29 d0                	sub    %edx,%eax
  801613:	89 c2                	mov    %eax,%edx
  801615:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801618:	89 50 08             	mov    %edx,0x8(%eax)




			LIST_REMOVE(&AvailableMemBlocksList,freeSva);
  80161b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80161f:	75 14                	jne    801635 <initialize_dyn_block_system+0x11f>
  801621:	83 ec 04             	sub    $0x4,%esp
  801624:	68 b5 3d 80 00       	push   $0x803db5
  801629:	6a 34                	push   $0x34
  80162b:	68 d3 3d 80 00       	push   $0x803dd3
  801630:	e8 72 ee ff ff       	call   8004a7 <_panic>
  801635:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801638:	8b 00                	mov    (%eax),%eax
  80163a:	85 c0                	test   %eax,%eax
  80163c:	74 10                	je     80164e <initialize_dyn_block_system+0x138>
  80163e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801641:	8b 00                	mov    (%eax),%eax
  801643:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801646:	8b 52 04             	mov    0x4(%edx),%edx
  801649:	89 50 04             	mov    %edx,0x4(%eax)
  80164c:	eb 0b                	jmp    801659 <initialize_dyn_block_system+0x143>
  80164e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801651:	8b 40 04             	mov    0x4(%eax),%eax
  801654:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801659:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80165c:	8b 40 04             	mov    0x4(%eax),%eax
  80165f:	85 c0                	test   %eax,%eax
  801661:	74 0f                	je     801672 <initialize_dyn_block_system+0x15c>
  801663:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801666:	8b 40 04             	mov    0x4(%eax),%eax
  801669:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80166c:	8b 12                	mov    (%edx),%edx
  80166e:	89 10                	mov    %edx,(%eax)
  801670:	eb 0a                	jmp    80167c <initialize_dyn_block_system+0x166>
  801672:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801675:	8b 00                	mov    (%eax),%eax
  801677:	a3 48 41 80 00       	mov    %eax,0x804148
  80167c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80167f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801685:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801688:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80168f:	a1 54 41 80 00       	mov    0x804154,%eax
  801694:	48                   	dec    %eax
  801695:	a3 54 41 80 00       	mov    %eax,0x804154
			insert_sorted_with_merge_freeList(freeSva);
  80169a:	83 ec 0c             	sub    $0xc,%esp
  80169d:	ff 75 e8             	pushl  -0x18(%ebp)
  8016a0:	e8 c4 13 00 00       	call   802a69 <insert_sorted_with_merge_freeList>
  8016a5:	83 c4 10             	add    $0x10,%esp
//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  8016a8:	90                   	nop
  8016a9:	c9                   	leave  
  8016aa:	c3                   	ret    

008016ab <malloc>:
//=================================



void* malloc(uint32 size)
{
  8016ab:	55                   	push   %ebp
  8016ac:	89 e5                	mov    %esp,%ebp
  8016ae:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016b1:	e8 2f fe ff ff       	call   8014e5 <InitializeUHeap>
	if (size == 0) return NULL ;
  8016b6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8016ba:	75 07                	jne    8016c3 <malloc+0x18>
  8016bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8016c1:	eb 71                	jmp    801734 <malloc+0x89>
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");
if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  8016c3:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  8016ca:	76 07                	jbe    8016d3 <malloc+0x28>
	return NULL;
  8016cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8016d1:	eb 61                	jmp    801734 <malloc+0x89>

	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8016d3:	e8 88 08 00 00       	call   801f60 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016d8:	85 c0                	test   %eax,%eax
  8016da:	74 53                	je     80172f <malloc+0x84>
	        {
		struct MemBlock *returned_block;
		uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  8016dc:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8016e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8016e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016e9:	01 d0                	add    %edx,%eax
  8016eb:	48                   	dec    %eax
  8016ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8016f7:	f7 75 f4             	divl   -0xc(%ebp)
  8016fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016fd:	29 d0                	sub    %edx,%eax
  8016ff:	89 45 ec             	mov    %eax,-0x14(%ebp)
   returned_block=alloc_block_FF(newSize);
  801702:	83 ec 0c             	sub    $0xc,%esp
  801705:	ff 75 ec             	pushl  -0x14(%ebp)
  801708:	e8 d2 0d 00 00       	call   8024df <alloc_block_FF>
  80170d:	83 c4 10             	add    $0x10,%esp
  801710:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(returned_block!=NULL)
  801713:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801717:	74 16                	je     80172f <malloc+0x84>
    {
    	insert_sorted_allocList(returned_block);
  801719:	83 ec 0c             	sub    $0xc,%esp
  80171c:	ff 75 e8             	pushl  -0x18(%ebp)
  80171f:	e8 0c 0c 00 00       	call   802330 <insert_sorted_allocList>
  801724:	83 c4 10             	add    $0x10,%esp
	return(void*) returned_block->sva;
  801727:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80172a:	8b 40 08             	mov    0x8(%eax),%eax
  80172d:	eb 05                	jmp    801734 <malloc+0x89>
    }

			}


	return NULL;
  80172f:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801734:	c9                   	leave  
  801735:	c3                   	ret    

00801736 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801736:	55                   	push   %ebp
  801737:	89 e5                	mov    %esp,%ebp
  801739:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//you should get the size of the given allocation using its address
	uint32 va=ROUNDDOWN((uint32)virtual_address,PAGE_SIZE);
  80173c:	8b 45 08             	mov    0x8(%ebp),%eax
  80173f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801742:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801745:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80174a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *returned_block=find_block(&AllocMemBlocksList,va);
  80174d:	83 ec 08             	sub    $0x8,%esp
  801750:	ff 75 f0             	pushl  -0x10(%ebp)
  801753:	68 40 40 80 00       	push   $0x804040
  801758:	e8 a0 0b 00 00       	call   8022fd <find_block>
  80175d:	83 c4 10             	add    $0x10,%esp
  801760:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_free_user_mem((uint32)virtual_address,returned_block->size);
  801763:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801766:	8b 50 0c             	mov    0xc(%eax),%edx
  801769:	8b 45 08             	mov    0x8(%ebp),%eax
  80176c:	83 ec 08             	sub    $0x8,%esp
  80176f:	52                   	push   %edx
  801770:	50                   	push   %eax
  801771:	e8 e4 03 00 00       	call   801b5a <sys_free_user_mem>
  801776:	83 c4 10             	add    $0x10,%esp

    LIST_REMOVE(&AllocMemBlocksList,returned_block);
  801779:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80177d:	75 17                	jne    801796 <free+0x60>
  80177f:	83 ec 04             	sub    $0x4,%esp
  801782:	68 b5 3d 80 00       	push   $0x803db5
  801787:	68 84 00 00 00       	push   $0x84
  80178c:	68 d3 3d 80 00       	push   $0x803dd3
  801791:	e8 11 ed ff ff       	call   8004a7 <_panic>
  801796:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801799:	8b 00                	mov    (%eax),%eax
  80179b:	85 c0                	test   %eax,%eax
  80179d:	74 10                	je     8017af <free+0x79>
  80179f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017a2:	8b 00                	mov    (%eax),%eax
  8017a4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8017a7:	8b 52 04             	mov    0x4(%edx),%edx
  8017aa:	89 50 04             	mov    %edx,0x4(%eax)
  8017ad:	eb 0b                	jmp    8017ba <free+0x84>
  8017af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017b2:	8b 40 04             	mov    0x4(%eax),%eax
  8017b5:	a3 44 40 80 00       	mov    %eax,0x804044
  8017ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017bd:	8b 40 04             	mov    0x4(%eax),%eax
  8017c0:	85 c0                	test   %eax,%eax
  8017c2:	74 0f                	je     8017d3 <free+0x9d>
  8017c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017c7:	8b 40 04             	mov    0x4(%eax),%eax
  8017ca:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8017cd:	8b 12                	mov    (%edx),%edx
  8017cf:	89 10                	mov    %edx,(%eax)
  8017d1:	eb 0a                	jmp    8017dd <free+0xa7>
  8017d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017d6:	8b 00                	mov    (%eax),%eax
  8017d8:	a3 40 40 80 00       	mov    %eax,0x804040
  8017dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8017e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017e9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8017f0:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8017f5:	48                   	dec    %eax
  8017f6:	a3 4c 40 80 00       	mov    %eax,0x80404c
	insert_sorted_with_merge_freeList(returned_block);
  8017fb:	83 ec 0c             	sub    $0xc,%esp
  8017fe:	ff 75 ec             	pushl  -0x14(%ebp)
  801801:	e8 63 12 00 00       	call   802a69 <insert_sorted_with_merge_freeList>
  801806:	83 c4 10             	add    $0x10,%esp

	//you need to call sys_free_user_mem()
}
  801809:	90                   	nop
  80180a:	c9                   	leave  
  80180b:	c3                   	ret    

0080180c <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80180c:	55                   	push   %ebp
  80180d:	89 e5                	mov    %esp,%ebp
  80180f:	83 ec 38             	sub    $0x38,%esp
  801812:	8b 45 10             	mov    0x10(%ebp),%eax
  801815:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801818:	e8 c8 fc ff ff       	call   8014e5 <InitializeUHeap>
	if (size == 0) return NULL ;
  80181d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801821:	75 0a                	jne    80182d <smalloc+0x21>
  801823:	b8 00 00 00 00       	mov    $0x0,%eax
  801828:	e9 a0 00 00 00       	jmp    8018cd <smalloc+0xc1>
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	// Steps:
	//	1) Implement FIRST FIT strategy to search the heap for suitable space
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  80182d:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  801834:	76 0a                	jbe    801840 <smalloc+0x34>
		return NULL;
  801836:	b8 00 00 00 00       	mov    $0x0,%eax
  80183b:	e9 8d 00 00 00       	jmp    8018cd <smalloc+0xc1>

		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801840:	e8 1b 07 00 00       	call   801f60 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801845:	85 c0                	test   %eax,%eax
  801847:	74 7f                	je     8018c8 <smalloc+0xbc>
		        {
			struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801849:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801850:	8b 55 0c             	mov    0xc(%ebp),%edx
  801853:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801856:	01 d0                	add    %edx,%eax
  801858:	48                   	dec    %eax
  801859:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80185c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80185f:	ba 00 00 00 00       	mov    $0x0,%edx
  801864:	f7 75 f4             	divl   -0xc(%ebp)
  801867:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80186a:	29 d0                	sub    %edx,%eax
  80186c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	   returned_block=alloc_block_FF(newSize);
  80186f:	83 ec 0c             	sub    $0xc,%esp
  801872:	ff 75 ec             	pushl  -0x14(%ebp)
  801875:	e8 65 0c 00 00       	call   8024df <alloc_block_FF>
  80187a:	83 c4 10             	add    $0x10,%esp
  80187d:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   if(returned_block!=NULL)
  801880:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801884:	74 42                	je     8018c8 <smalloc+0xbc>
	      {
	      	   insert_sorted_allocList(returned_block);
  801886:	83 ec 0c             	sub    $0xc,%esp
  801889:	ff 75 e8             	pushl  -0x18(%ebp)
  80188c:	e8 9f 0a 00 00       	call   802330 <insert_sorted_allocList>
  801891:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_createSharedObject(sharedVarName,size,isWritable,(void*)returned_block->sva);
  801894:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801897:	8b 40 08             	mov    0x8(%eax),%eax
  80189a:	89 c2                	mov    %eax,%edx
  80189c:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8018a0:	52                   	push   %edx
  8018a1:	50                   	push   %eax
  8018a2:	ff 75 0c             	pushl  0xc(%ebp)
  8018a5:	ff 75 08             	pushl  0x8(%ebp)
  8018a8:	e8 38 04 00 00       	call   801ce5 <sys_createSharedObject>
  8018ad:	83 c4 10             	add    $0x10,%esp
  8018b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    	     if(ID<0)
  8018b3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8018b7:	79 07                	jns    8018c0 <smalloc+0xb4>
	    		  return NULL;
  8018b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8018be:	eb 0d                	jmp    8018cd <smalloc+0xc1>
	  	return(void*) returned_block->sva;
  8018c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018c3:	8b 40 08             	mov    0x8(%eax),%eax
  8018c6:	eb 05                	jmp    8018cd <smalloc+0xc1>


				}


		return NULL;
  8018c8:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8018cd:	c9                   	leave  
  8018ce:	c3                   	ret    

008018cf <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8018cf:	55                   	push   %ebp
  8018d0:	89 e5                	mov    %esp,%ebp
  8018d2:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8018d5:	e8 0b fc ff ff       	call   8014e5 <InitializeUHeap>
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	// Steps:
	//	1) Get the size of the shared variable (use sys_getSizeOfSharedObject())
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  8018da:	e8 81 06 00 00       	call   801f60 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8018df:	85 c0                	test   %eax,%eax
  8018e1:	0f 84 9f 00 00 00    	je     801986 <sget+0xb7>
	int size=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8018e7:	83 ec 08             	sub    $0x8,%esp
  8018ea:	ff 75 0c             	pushl  0xc(%ebp)
  8018ed:	ff 75 08             	pushl  0x8(%ebp)
  8018f0:	e8 1a 04 00 00       	call   801d0f <sys_getSizeOfSharedObject>
  8018f5:	83 c4 10             	add    $0x10,%esp
  8018f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size<0)
  8018fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8018ff:	79 0a                	jns    80190b <sget+0x3c>
		return NULL;
  801901:	b8 00 00 00 00       	mov    $0x0,%eax
  801906:	e9 80 00 00 00       	jmp    80198b <sget+0xbc>
	struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  80190b:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801912:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801915:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801918:	01 d0                	add    %edx,%eax
  80191a:	48                   	dec    %eax
  80191b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80191e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801921:	ba 00 00 00 00       	mov    $0x0,%edx
  801926:	f7 75 f0             	divl   -0x10(%ebp)
  801929:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80192c:	29 d0                	sub    %edx,%eax
  80192e:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   returned_block=alloc_block_FF(newSize);
  801931:	83 ec 0c             	sub    $0xc,%esp
  801934:	ff 75 e8             	pushl  -0x18(%ebp)
  801937:	e8 a3 0b 00 00       	call   8024df <alloc_block_FF>
  80193c:	83 c4 10             	add    $0x10,%esp
  80193f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	   if(returned_block!=NULL)
  801942:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801946:	74 3e                	je     801986 <sget+0xb7>
	      {
	      	   insert_sorted_allocList(returned_block);
  801948:	83 ec 0c             	sub    $0xc,%esp
  80194b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80194e:	e8 dd 09 00 00       	call   802330 <insert_sorted_allocList>
  801953:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)returned_block->sva);
  801956:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801959:	8b 40 08             	mov    0x8(%eax),%eax
  80195c:	83 ec 04             	sub    $0x4,%esp
  80195f:	50                   	push   %eax
  801960:	ff 75 0c             	pushl  0xc(%ebp)
  801963:	ff 75 08             	pushl  0x8(%ebp)
  801966:	e8 c1 03 00 00       	call   801d2c <sys_getSharedObject>
  80196b:	83 c4 10             	add    $0x10,%esp
  80196e:	89 45 e0             	mov    %eax,-0x20(%ebp)
	    	     if(ID<0)
  801971:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801975:	79 07                	jns    80197e <sget+0xaf>
	    		  return NULL;
  801977:	b8 00 00 00 00       	mov    $0x0,%eax
  80197c:	eb 0d                	jmp    80198b <sget+0xbc>
	  	return(void*) returned_block->sva;
  80197e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801981:	8b 40 08             	mov    0x8(%eax),%eax
  801984:	eb 05                	jmp    80198b <sget+0xbc>
	      }
	}
	   return NULL;
  801986:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80198b:	c9                   	leave  
  80198c:	c3                   	ret    

0080198d <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80198d:	55                   	push   %ebp
  80198e:	89 e5                	mov    %esp,%ebp
  801990:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801993:	e8 4d fb ff ff       	call   8014e5 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801998:	83 ec 04             	sub    $0x4,%esp
  80199b:	68 e0 3d 80 00       	push   $0x803de0
  8019a0:	68 12 01 00 00       	push   $0x112
  8019a5:	68 d3 3d 80 00       	push   $0x803dd3
  8019aa:	e8 f8 ea ff ff       	call   8004a7 <_panic>

008019af <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8019af:	55                   	push   %ebp
  8019b0:	89 e5                	mov    %esp,%ebp
  8019b2:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8019b5:	83 ec 04             	sub    $0x4,%esp
  8019b8:	68 08 3e 80 00       	push   $0x803e08
  8019bd:	68 26 01 00 00       	push   $0x126
  8019c2:	68 d3 3d 80 00       	push   $0x803dd3
  8019c7:	e8 db ea ff ff       	call   8004a7 <_panic>

008019cc <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8019cc:	55                   	push   %ebp
  8019cd:	89 e5                	mov    %esp,%ebp
  8019cf:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019d2:	83 ec 04             	sub    $0x4,%esp
  8019d5:	68 2c 3e 80 00       	push   $0x803e2c
  8019da:	68 31 01 00 00       	push   $0x131
  8019df:	68 d3 3d 80 00       	push   $0x803dd3
  8019e4:	e8 be ea ff ff       	call   8004a7 <_panic>

008019e9 <shrink>:

}
void shrink(uint32 newSize)
{
  8019e9:	55                   	push   %ebp
  8019ea:	89 e5                	mov    %esp,%ebp
  8019ec:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019ef:	83 ec 04             	sub    $0x4,%esp
  8019f2:	68 2c 3e 80 00       	push   $0x803e2c
  8019f7:	68 36 01 00 00       	push   $0x136
  8019fc:	68 d3 3d 80 00       	push   $0x803dd3
  801a01:	e8 a1 ea ff ff       	call   8004a7 <_panic>

00801a06 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801a06:	55                   	push   %ebp
  801a07:	89 e5                	mov    %esp,%ebp
  801a09:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a0c:	83 ec 04             	sub    $0x4,%esp
  801a0f:	68 2c 3e 80 00       	push   $0x803e2c
  801a14:	68 3b 01 00 00       	push   $0x13b
  801a19:	68 d3 3d 80 00       	push   $0x803dd3
  801a1e:	e8 84 ea ff ff       	call   8004a7 <_panic>

00801a23 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801a23:	55                   	push   %ebp
  801a24:	89 e5                	mov    %esp,%ebp
  801a26:	57                   	push   %edi
  801a27:	56                   	push   %esi
  801a28:	53                   	push   %ebx
  801a29:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a32:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a35:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a38:	8b 7d 18             	mov    0x18(%ebp),%edi
  801a3b:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801a3e:	cd 30                	int    $0x30
  801a40:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801a43:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801a46:	83 c4 10             	add    $0x10,%esp
  801a49:	5b                   	pop    %ebx
  801a4a:	5e                   	pop    %esi
  801a4b:	5f                   	pop    %edi
  801a4c:	5d                   	pop    %ebp
  801a4d:	c3                   	ret    

00801a4e <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801a4e:	55                   	push   %ebp
  801a4f:	89 e5                	mov    %esp,%ebp
  801a51:	83 ec 04             	sub    $0x4,%esp
  801a54:	8b 45 10             	mov    0x10(%ebp),%eax
  801a57:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801a5a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a61:	6a 00                	push   $0x0
  801a63:	6a 00                	push   $0x0
  801a65:	52                   	push   %edx
  801a66:	ff 75 0c             	pushl  0xc(%ebp)
  801a69:	50                   	push   %eax
  801a6a:	6a 00                	push   $0x0
  801a6c:	e8 b2 ff ff ff       	call   801a23 <syscall>
  801a71:	83 c4 18             	add    $0x18,%esp
}
  801a74:	90                   	nop
  801a75:	c9                   	leave  
  801a76:	c3                   	ret    

00801a77 <sys_cgetc>:

int
sys_cgetc(void)
{
  801a77:	55                   	push   %ebp
  801a78:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801a7a:	6a 00                	push   $0x0
  801a7c:	6a 00                	push   $0x0
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	6a 00                	push   $0x0
  801a84:	6a 01                	push   $0x1
  801a86:	e8 98 ff ff ff       	call   801a23 <syscall>
  801a8b:	83 c4 18             	add    $0x18,%esp
}
  801a8e:	c9                   	leave  
  801a8f:	c3                   	ret    

00801a90 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801a90:	55                   	push   %ebp
  801a91:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801a93:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a96:	8b 45 08             	mov    0x8(%ebp),%eax
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 00                	push   $0x0
  801a9d:	6a 00                	push   $0x0
  801a9f:	52                   	push   %edx
  801aa0:	50                   	push   %eax
  801aa1:	6a 05                	push   $0x5
  801aa3:	e8 7b ff ff ff       	call   801a23 <syscall>
  801aa8:	83 c4 18             	add    $0x18,%esp
}
  801aab:	c9                   	leave  
  801aac:	c3                   	ret    

00801aad <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801aad:	55                   	push   %ebp
  801aae:	89 e5                	mov    %esp,%ebp
  801ab0:	56                   	push   %esi
  801ab1:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801ab2:	8b 75 18             	mov    0x18(%ebp),%esi
  801ab5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ab8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801abb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801abe:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac1:	56                   	push   %esi
  801ac2:	53                   	push   %ebx
  801ac3:	51                   	push   %ecx
  801ac4:	52                   	push   %edx
  801ac5:	50                   	push   %eax
  801ac6:	6a 06                	push   $0x6
  801ac8:	e8 56 ff ff ff       	call   801a23 <syscall>
  801acd:	83 c4 18             	add    $0x18,%esp
}
  801ad0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ad3:	5b                   	pop    %ebx
  801ad4:	5e                   	pop    %esi
  801ad5:	5d                   	pop    %ebp
  801ad6:	c3                   	ret    

00801ad7 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801ad7:	55                   	push   %ebp
  801ad8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801ada:	8b 55 0c             	mov    0xc(%ebp),%edx
  801add:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 00                	push   $0x0
  801ae4:	6a 00                	push   $0x0
  801ae6:	52                   	push   %edx
  801ae7:	50                   	push   %eax
  801ae8:	6a 07                	push   $0x7
  801aea:	e8 34 ff ff ff       	call   801a23 <syscall>
  801aef:	83 c4 18             	add    $0x18,%esp
}
  801af2:	c9                   	leave  
  801af3:	c3                   	ret    

00801af4 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801af4:	55                   	push   %ebp
  801af5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	6a 00                	push   $0x0
  801afd:	ff 75 0c             	pushl  0xc(%ebp)
  801b00:	ff 75 08             	pushl  0x8(%ebp)
  801b03:	6a 08                	push   $0x8
  801b05:	e8 19 ff ff ff       	call   801a23 <syscall>
  801b0a:	83 c4 18             	add    $0x18,%esp
}
  801b0d:	c9                   	leave  
  801b0e:	c3                   	ret    

00801b0f <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801b0f:	55                   	push   %ebp
  801b10:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801b12:	6a 00                	push   $0x0
  801b14:	6a 00                	push   $0x0
  801b16:	6a 00                	push   $0x0
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 00                	push   $0x0
  801b1c:	6a 09                	push   $0x9
  801b1e:	e8 00 ff ff ff       	call   801a23 <syscall>
  801b23:	83 c4 18             	add    $0x18,%esp
}
  801b26:	c9                   	leave  
  801b27:	c3                   	ret    

00801b28 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801b28:	55                   	push   %ebp
  801b29:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 00                	push   $0x0
  801b33:	6a 00                	push   $0x0
  801b35:	6a 0a                	push   $0xa
  801b37:	e8 e7 fe ff ff       	call   801a23 <syscall>
  801b3c:	83 c4 18             	add    $0x18,%esp
}
  801b3f:	c9                   	leave  
  801b40:	c3                   	ret    

00801b41 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801b41:	55                   	push   %ebp
  801b42:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801b44:	6a 00                	push   $0x0
  801b46:	6a 00                	push   $0x0
  801b48:	6a 00                	push   $0x0
  801b4a:	6a 00                	push   $0x0
  801b4c:	6a 00                	push   $0x0
  801b4e:	6a 0b                	push   $0xb
  801b50:	e8 ce fe ff ff       	call   801a23 <syscall>
  801b55:	83 c4 18             	add    $0x18,%esp
}
  801b58:	c9                   	leave  
  801b59:	c3                   	ret    

00801b5a <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b5a:	55                   	push   %ebp
  801b5b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801b5d:	6a 00                	push   $0x0
  801b5f:	6a 00                	push   $0x0
  801b61:	6a 00                	push   $0x0
  801b63:	ff 75 0c             	pushl  0xc(%ebp)
  801b66:	ff 75 08             	pushl  0x8(%ebp)
  801b69:	6a 0f                	push   $0xf
  801b6b:	e8 b3 fe ff ff       	call   801a23 <syscall>
  801b70:	83 c4 18             	add    $0x18,%esp
	return;
  801b73:	90                   	nop
}
  801b74:	c9                   	leave  
  801b75:	c3                   	ret    

00801b76 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801b76:	55                   	push   %ebp
  801b77:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801b79:	6a 00                	push   $0x0
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 00                	push   $0x0
  801b7f:	ff 75 0c             	pushl  0xc(%ebp)
  801b82:	ff 75 08             	pushl  0x8(%ebp)
  801b85:	6a 10                	push   $0x10
  801b87:	e8 97 fe ff ff       	call   801a23 <syscall>
  801b8c:	83 c4 18             	add    $0x18,%esp
	return ;
  801b8f:	90                   	nop
}
  801b90:	c9                   	leave  
  801b91:	c3                   	ret    

00801b92 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b92:	55                   	push   %ebp
  801b93:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b95:	6a 00                	push   $0x0
  801b97:	6a 00                	push   $0x0
  801b99:	ff 75 10             	pushl  0x10(%ebp)
  801b9c:	ff 75 0c             	pushl  0xc(%ebp)
  801b9f:	ff 75 08             	pushl  0x8(%ebp)
  801ba2:	6a 11                	push   $0x11
  801ba4:	e8 7a fe ff ff       	call   801a23 <syscall>
  801ba9:	83 c4 18             	add    $0x18,%esp
	return ;
  801bac:	90                   	nop
}
  801bad:	c9                   	leave  
  801bae:	c3                   	ret    

00801baf <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801baf:	55                   	push   %ebp
  801bb0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801bb2:	6a 00                	push   $0x0
  801bb4:	6a 00                	push   $0x0
  801bb6:	6a 00                	push   $0x0
  801bb8:	6a 00                	push   $0x0
  801bba:	6a 00                	push   $0x0
  801bbc:	6a 0c                	push   $0xc
  801bbe:	e8 60 fe ff ff       	call   801a23 <syscall>
  801bc3:	83 c4 18             	add    $0x18,%esp
}
  801bc6:	c9                   	leave  
  801bc7:	c3                   	ret    

00801bc8 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801bc8:	55                   	push   %ebp
  801bc9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801bcb:	6a 00                	push   $0x0
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 00                	push   $0x0
  801bd1:	6a 00                	push   $0x0
  801bd3:	ff 75 08             	pushl  0x8(%ebp)
  801bd6:	6a 0d                	push   $0xd
  801bd8:	e8 46 fe ff ff       	call   801a23 <syscall>
  801bdd:	83 c4 18             	add    $0x18,%esp
}
  801be0:	c9                   	leave  
  801be1:	c3                   	ret    

00801be2 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801be2:	55                   	push   %ebp
  801be3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801be5:	6a 00                	push   $0x0
  801be7:	6a 00                	push   $0x0
  801be9:	6a 00                	push   $0x0
  801beb:	6a 00                	push   $0x0
  801bed:	6a 00                	push   $0x0
  801bef:	6a 0e                	push   $0xe
  801bf1:	e8 2d fe ff ff       	call   801a23 <syscall>
  801bf6:	83 c4 18             	add    $0x18,%esp
}
  801bf9:	90                   	nop
  801bfa:	c9                   	leave  
  801bfb:	c3                   	ret    

00801bfc <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801bfc:	55                   	push   %ebp
  801bfd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801bff:	6a 00                	push   $0x0
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	6a 00                	push   $0x0
  801c09:	6a 13                	push   $0x13
  801c0b:	e8 13 fe ff ff       	call   801a23 <syscall>
  801c10:	83 c4 18             	add    $0x18,%esp
}
  801c13:	90                   	nop
  801c14:	c9                   	leave  
  801c15:	c3                   	ret    

00801c16 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801c16:	55                   	push   %ebp
  801c17:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	6a 14                	push   $0x14
  801c25:	e8 f9 fd ff ff       	call   801a23 <syscall>
  801c2a:	83 c4 18             	add    $0x18,%esp
}
  801c2d:	90                   	nop
  801c2e:	c9                   	leave  
  801c2f:	c3                   	ret    

00801c30 <sys_cputc>:


void
sys_cputc(const char c)
{
  801c30:	55                   	push   %ebp
  801c31:	89 e5                	mov    %esp,%ebp
  801c33:	83 ec 04             	sub    $0x4,%esp
  801c36:	8b 45 08             	mov    0x8(%ebp),%eax
  801c39:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801c3c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c40:	6a 00                	push   $0x0
  801c42:	6a 00                	push   $0x0
  801c44:	6a 00                	push   $0x0
  801c46:	6a 00                	push   $0x0
  801c48:	50                   	push   %eax
  801c49:	6a 15                	push   $0x15
  801c4b:	e8 d3 fd ff ff       	call   801a23 <syscall>
  801c50:	83 c4 18             	add    $0x18,%esp
}
  801c53:	90                   	nop
  801c54:	c9                   	leave  
  801c55:	c3                   	ret    

00801c56 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801c56:	55                   	push   %ebp
  801c57:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801c59:	6a 00                	push   $0x0
  801c5b:	6a 00                	push   $0x0
  801c5d:	6a 00                	push   $0x0
  801c5f:	6a 00                	push   $0x0
  801c61:	6a 00                	push   $0x0
  801c63:	6a 16                	push   $0x16
  801c65:	e8 b9 fd ff ff       	call   801a23 <syscall>
  801c6a:	83 c4 18             	add    $0x18,%esp
}
  801c6d:	90                   	nop
  801c6e:	c9                   	leave  
  801c6f:	c3                   	ret    

00801c70 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801c70:	55                   	push   %ebp
  801c71:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801c73:	8b 45 08             	mov    0x8(%ebp),%eax
  801c76:	6a 00                	push   $0x0
  801c78:	6a 00                	push   $0x0
  801c7a:	6a 00                	push   $0x0
  801c7c:	ff 75 0c             	pushl  0xc(%ebp)
  801c7f:	50                   	push   %eax
  801c80:	6a 17                	push   $0x17
  801c82:	e8 9c fd ff ff       	call   801a23 <syscall>
  801c87:	83 c4 18             	add    $0x18,%esp
}
  801c8a:	c9                   	leave  
  801c8b:	c3                   	ret    

00801c8c <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801c8c:	55                   	push   %ebp
  801c8d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c92:	8b 45 08             	mov    0x8(%ebp),%eax
  801c95:	6a 00                	push   $0x0
  801c97:	6a 00                	push   $0x0
  801c99:	6a 00                	push   $0x0
  801c9b:	52                   	push   %edx
  801c9c:	50                   	push   %eax
  801c9d:	6a 1a                	push   $0x1a
  801c9f:	e8 7f fd ff ff       	call   801a23 <syscall>
  801ca4:	83 c4 18             	add    $0x18,%esp
}
  801ca7:	c9                   	leave  
  801ca8:	c3                   	ret    

00801ca9 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ca9:	55                   	push   %ebp
  801caa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801cac:	8b 55 0c             	mov    0xc(%ebp),%edx
  801caf:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 00                	push   $0x0
  801cb6:	6a 00                	push   $0x0
  801cb8:	52                   	push   %edx
  801cb9:	50                   	push   %eax
  801cba:	6a 18                	push   $0x18
  801cbc:	e8 62 fd ff ff       	call   801a23 <syscall>
  801cc1:	83 c4 18             	add    $0x18,%esp
}
  801cc4:	90                   	nop
  801cc5:	c9                   	leave  
  801cc6:	c3                   	ret    

00801cc7 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801cc7:	55                   	push   %ebp
  801cc8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801cca:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd0:	6a 00                	push   $0x0
  801cd2:	6a 00                	push   $0x0
  801cd4:	6a 00                	push   $0x0
  801cd6:	52                   	push   %edx
  801cd7:	50                   	push   %eax
  801cd8:	6a 19                	push   $0x19
  801cda:	e8 44 fd ff ff       	call   801a23 <syscall>
  801cdf:	83 c4 18             	add    $0x18,%esp
}
  801ce2:	90                   	nop
  801ce3:	c9                   	leave  
  801ce4:	c3                   	ret    

00801ce5 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801ce5:	55                   	push   %ebp
  801ce6:	89 e5                	mov    %esp,%ebp
  801ce8:	83 ec 04             	sub    $0x4,%esp
  801ceb:	8b 45 10             	mov    0x10(%ebp),%eax
  801cee:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801cf1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801cf4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfb:	6a 00                	push   $0x0
  801cfd:	51                   	push   %ecx
  801cfe:	52                   	push   %edx
  801cff:	ff 75 0c             	pushl  0xc(%ebp)
  801d02:	50                   	push   %eax
  801d03:	6a 1b                	push   $0x1b
  801d05:	e8 19 fd ff ff       	call   801a23 <syscall>
  801d0a:	83 c4 18             	add    $0x18,%esp
}
  801d0d:	c9                   	leave  
  801d0e:	c3                   	ret    

00801d0f <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801d0f:	55                   	push   %ebp
  801d10:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801d12:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d15:	8b 45 08             	mov    0x8(%ebp),%eax
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 00                	push   $0x0
  801d1e:	52                   	push   %edx
  801d1f:	50                   	push   %eax
  801d20:	6a 1c                	push   $0x1c
  801d22:	e8 fc fc ff ff       	call   801a23 <syscall>
  801d27:	83 c4 18             	add    $0x18,%esp
}
  801d2a:	c9                   	leave  
  801d2b:	c3                   	ret    

00801d2c <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801d2c:	55                   	push   %ebp
  801d2d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801d2f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d32:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d35:	8b 45 08             	mov    0x8(%ebp),%eax
  801d38:	6a 00                	push   $0x0
  801d3a:	6a 00                	push   $0x0
  801d3c:	51                   	push   %ecx
  801d3d:	52                   	push   %edx
  801d3e:	50                   	push   %eax
  801d3f:	6a 1d                	push   $0x1d
  801d41:	e8 dd fc ff ff       	call   801a23 <syscall>
  801d46:	83 c4 18             	add    $0x18,%esp
}
  801d49:	c9                   	leave  
  801d4a:	c3                   	ret    

00801d4b <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801d4b:	55                   	push   %ebp
  801d4c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801d4e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d51:	8b 45 08             	mov    0x8(%ebp),%eax
  801d54:	6a 00                	push   $0x0
  801d56:	6a 00                	push   $0x0
  801d58:	6a 00                	push   $0x0
  801d5a:	52                   	push   %edx
  801d5b:	50                   	push   %eax
  801d5c:	6a 1e                	push   $0x1e
  801d5e:	e8 c0 fc ff ff       	call   801a23 <syscall>
  801d63:	83 c4 18             	add    $0x18,%esp
}
  801d66:	c9                   	leave  
  801d67:	c3                   	ret    

00801d68 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801d68:	55                   	push   %ebp
  801d69:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801d6b:	6a 00                	push   $0x0
  801d6d:	6a 00                	push   $0x0
  801d6f:	6a 00                	push   $0x0
  801d71:	6a 00                	push   $0x0
  801d73:	6a 00                	push   $0x0
  801d75:	6a 1f                	push   $0x1f
  801d77:	e8 a7 fc ff ff       	call   801a23 <syscall>
  801d7c:	83 c4 18             	add    $0x18,%esp
}
  801d7f:	c9                   	leave  
  801d80:	c3                   	ret    

00801d81 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801d81:	55                   	push   %ebp
  801d82:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801d84:	8b 45 08             	mov    0x8(%ebp),%eax
  801d87:	6a 00                	push   $0x0
  801d89:	ff 75 14             	pushl  0x14(%ebp)
  801d8c:	ff 75 10             	pushl  0x10(%ebp)
  801d8f:	ff 75 0c             	pushl  0xc(%ebp)
  801d92:	50                   	push   %eax
  801d93:	6a 20                	push   $0x20
  801d95:	e8 89 fc ff ff       	call   801a23 <syscall>
  801d9a:	83 c4 18             	add    $0x18,%esp
}
  801d9d:	c9                   	leave  
  801d9e:	c3                   	ret    

00801d9f <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801d9f:	55                   	push   %ebp
  801da0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801da2:	8b 45 08             	mov    0x8(%ebp),%eax
  801da5:	6a 00                	push   $0x0
  801da7:	6a 00                	push   $0x0
  801da9:	6a 00                	push   $0x0
  801dab:	6a 00                	push   $0x0
  801dad:	50                   	push   %eax
  801dae:	6a 21                	push   $0x21
  801db0:	e8 6e fc ff ff       	call   801a23 <syscall>
  801db5:	83 c4 18             	add    $0x18,%esp
}
  801db8:	90                   	nop
  801db9:	c9                   	leave  
  801dba:	c3                   	ret    

00801dbb <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801dbb:	55                   	push   %ebp
  801dbc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc1:	6a 00                	push   $0x0
  801dc3:	6a 00                	push   $0x0
  801dc5:	6a 00                	push   $0x0
  801dc7:	6a 00                	push   $0x0
  801dc9:	50                   	push   %eax
  801dca:	6a 22                	push   $0x22
  801dcc:	e8 52 fc ff ff       	call   801a23 <syscall>
  801dd1:	83 c4 18             	add    $0x18,%esp
}
  801dd4:	c9                   	leave  
  801dd5:	c3                   	ret    

00801dd6 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801dd6:	55                   	push   %ebp
  801dd7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801dd9:	6a 00                	push   $0x0
  801ddb:	6a 00                	push   $0x0
  801ddd:	6a 00                	push   $0x0
  801ddf:	6a 00                	push   $0x0
  801de1:	6a 00                	push   $0x0
  801de3:	6a 02                	push   $0x2
  801de5:	e8 39 fc ff ff       	call   801a23 <syscall>
  801dea:	83 c4 18             	add    $0x18,%esp
}
  801ded:	c9                   	leave  
  801dee:	c3                   	ret    

00801def <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801def:	55                   	push   %ebp
  801df0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801df2:	6a 00                	push   $0x0
  801df4:	6a 00                	push   $0x0
  801df6:	6a 00                	push   $0x0
  801df8:	6a 00                	push   $0x0
  801dfa:	6a 00                	push   $0x0
  801dfc:	6a 03                	push   $0x3
  801dfe:	e8 20 fc ff ff       	call   801a23 <syscall>
  801e03:	83 c4 18             	add    $0x18,%esp
}
  801e06:	c9                   	leave  
  801e07:	c3                   	ret    

00801e08 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801e08:	55                   	push   %ebp
  801e09:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801e0b:	6a 00                	push   $0x0
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 00                	push   $0x0
  801e13:	6a 00                	push   $0x0
  801e15:	6a 04                	push   $0x4
  801e17:	e8 07 fc ff ff       	call   801a23 <syscall>
  801e1c:	83 c4 18             	add    $0x18,%esp
}
  801e1f:	c9                   	leave  
  801e20:	c3                   	ret    

00801e21 <sys_exit_env>:


void sys_exit_env(void)
{
  801e21:	55                   	push   %ebp
  801e22:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801e24:	6a 00                	push   $0x0
  801e26:	6a 00                	push   $0x0
  801e28:	6a 00                	push   $0x0
  801e2a:	6a 00                	push   $0x0
  801e2c:	6a 00                	push   $0x0
  801e2e:	6a 23                	push   $0x23
  801e30:	e8 ee fb ff ff       	call   801a23 <syscall>
  801e35:	83 c4 18             	add    $0x18,%esp
}
  801e38:	90                   	nop
  801e39:	c9                   	leave  
  801e3a:	c3                   	ret    

00801e3b <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801e3b:	55                   	push   %ebp
  801e3c:	89 e5                	mov    %esp,%ebp
  801e3e:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801e41:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e44:	8d 50 04             	lea    0x4(%eax),%edx
  801e47:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e4a:	6a 00                	push   $0x0
  801e4c:	6a 00                	push   $0x0
  801e4e:	6a 00                	push   $0x0
  801e50:	52                   	push   %edx
  801e51:	50                   	push   %eax
  801e52:	6a 24                	push   $0x24
  801e54:	e8 ca fb ff ff       	call   801a23 <syscall>
  801e59:	83 c4 18             	add    $0x18,%esp
	return result;
  801e5c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e5f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e62:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e65:	89 01                	mov    %eax,(%ecx)
  801e67:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801e6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6d:	c9                   	leave  
  801e6e:	c2 04 00             	ret    $0x4

00801e71 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801e71:	55                   	push   %ebp
  801e72:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801e74:	6a 00                	push   $0x0
  801e76:	6a 00                	push   $0x0
  801e78:	ff 75 10             	pushl  0x10(%ebp)
  801e7b:	ff 75 0c             	pushl  0xc(%ebp)
  801e7e:	ff 75 08             	pushl  0x8(%ebp)
  801e81:	6a 12                	push   $0x12
  801e83:	e8 9b fb ff ff       	call   801a23 <syscall>
  801e88:	83 c4 18             	add    $0x18,%esp
	return ;
  801e8b:	90                   	nop
}
  801e8c:	c9                   	leave  
  801e8d:	c3                   	ret    

00801e8e <sys_rcr2>:
uint32 sys_rcr2()
{
  801e8e:	55                   	push   %ebp
  801e8f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801e91:	6a 00                	push   $0x0
  801e93:	6a 00                	push   $0x0
  801e95:	6a 00                	push   $0x0
  801e97:	6a 00                	push   $0x0
  801e99:	6a 00                	push   $0x0
  801e9b:	6a 25                	push   $0x25
  801e9d:	e8 81 fb ff ff       	call   801a23 <syscall>
  801ea2:	83 c4 18             	add    $0x18,%esp
}
  801ea5:	c9                   	leave  
  801ea6:	c3                   	ret    

00801ea7 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801ea7:	55                   	push   %ebp
  801ea8:	89 e5                	mov    %esp,%ebp
  801eaa:	83 ec 04             	sub    $0x4,%esp
  801ead:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801eb3:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801eb7:	6a 00                	push   $0x0
  801eb9:	6a 00                	push   $0x0
  801ebb:	6a 00                	push   $0x0
  801ebd:	6a 00                	push   $0x0
  801ebf:	50                   	push   %eax
  801ec0:	6a 26                	push   $0x26
  801ec2:	e8 5c fb ff ff       	call   801a23 <syscall>
  801ec7:	83 c4 18             	add    $0x18,%esp
	return ;
  801eca:	90                   	nop
}
  801ecb:	c9                   	leave  
  801ecc:	c3                   	ret    

00801ecd <rsttst>:
void rsttst()
{
  801ecd:	55                   	push   %ebp
  801ece:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ed0:	6a 00                	push   $0x0
  801ed2:	6a 00                	push   $0x0
  801ed4:	6a 00                	push   $0x0
  801ed6:	6a 00                	push   $0x0
  801ed8:	6a 00                	push   $0x0
  801eda:	6a 28                	push   $0x28
  801edc:	e8 42 fb ff ff       	call   801a23 <syscall>
  801ee1:	83 c4 18             	add    $0x18,%esp
	return ;
  801ee4:	90                   	nop
}
  801ee5:	c9                   	leave  
  801ee6:	c3                   	ret    

00801ee7 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801ee7:	55                   	push   %ebp
  801ee8:	89 e5                	mov    %esp,%ebp
  801eea:	83 ec 04             	sub    $0x4,%esp
  801eed:	8b 45 14             	mov    0x14(%ebp),%eax
  801ef0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ef3:	8b 55 18             	mov    0x18(%ebp),%edx
  801ef6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801efa:	52                   	push   %edx
  801efb:	50                   	push   %eax
  801efc:	ff 75 10             	pushl  0x10(%ebp)
  801eff:	ff 75 0c             	pushl  0xc(%ebp)
  801f02:	ff 75 08             	pushl  0x8(%ebp)
  801f05:	6a 27                	push   $0x27
  801f07:	e8 17 fb ff ff       	call   801a23 <syscall>
  801f0c:	83 c4 18             	add    $0x18,%esp
	return ;
  801f0f:	90                   	nop
}
  801f10:	c9                   	leave  
  801f11:	c3                   	ret    

00801f12 <chktst>:
void chktst(uint32 n)
{
  801f12:	55                   	push   %ebp
  801f13:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801f15:	6a 00                	push   $0x0
  801f17:	6a 00                	push   $0x0
  801f19:	6a 00                	push   $0x0
  801f1b:	6a 00                	push   $0x0
  801f1d:	ff 75 08             	pushl  0x8(%ebp)
  801f20:	6a 29                	push   $0x29
  801f22:	e8 fc fa ff ff       	call   801a23 <syscall>
  801f27:	83 c4 18             	add    $0x18,%esp
	return ;
  801f2a:	90                   	nop
}
  801f2b:	c9                   	leave  
  801f2c:	c3                   	ret    

00801f2d <inctst>:

void inctst()
{
  801f2d:	55                   	push   %ebp
  801f2e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801f30:	6a 00                	push   $0x0
  801f32:	6a 00                	push   $0x0
  801f34:	6a 00                	push   $0x0
  801f36:	6a 00                	push   $0x0
  801f38:	6a 00                	push   $0x0
  801f3a:	6a 2a                	push   $0x2a
  801f3c:	e8 e2 fa ff ff       	call   801a23 <syscall>
  801f41:	83 c4 18             	add    $0x18,%esp
	return ;
  801f44:	90                   	nop
}
  801f45:	c9                   	leave  
  801f46:	c3                   	ret    

00801f47 <gettst>:
uint32 gettst()
{
  801f47:	55                   	push   %ebp
  801f48:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801f4a:	6a 00                	push   $0x0
  801f4c:	6a 00                	push   $0x0
  801f4e:	6a 00                	push   $0x0
  801f50:	6a 00                	push   $0x0
  801f52:	6a 00                	push   $0x0
  801f54:	6a 2b                	push   $0x2b
  801f56:	e8 c8 fa ff ff       	call   801a23 <syscall>
  801f5b:	83 c4 18             	add    $0x18,%esp
}
  801f5e:	c9                   	leave  
  801f5f:	c3                   	ret    

00801f60 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801f60:	55                   	push   %ebp
  801f61:	89 e5                	mov    %esp,%ebp
  801f63:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f66:	6a 00                	push   $0x0
  801f68:	6a 00                	push   $0x0
  801f6a:	6a 00                	push   $0x0
  801f6c:	6a 00                	push   $0x0
  801f6e:	6a 00                	push   $0x0
  801f70:	6a 2c                	push   $0x2c
  801f72:	e8 ac fa ff ff       	call   801a23 <syscall>
  801f77:	83 c4 18             	add    $0x18,%esp
  801f7a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801f7d:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801f81:	75 07                	jne    801f8a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801f83:	b8 01 00 00 00       	mov    $0x1,%eax
  801f88:	eb 05                	jmp    801f8f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801f8a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f8f:	c9                   	leave  
  801f90:	c3                   	ret    

00801f91 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801f91:	55                   	push   %ebp
  801f92:	89 e5                	mov    %esp,%ebp
  801f94:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f97:	6a 00                	push   $0x0
  801f99:	6a 00                	push   $0x0
  801f9b:	6a 00                	push   $0x0
  801f9d:	6a 00                	push   $0x0
  801f9f:	6a 00                	push   $0x0
  801fa1:	6a 2c                	push   $0x2c
  801fa3:	e8 7b fa ff ff       	call   801a23 <syscall>
  801fa8:	83 c4 18             	add    $0x18,%esp
  801fab:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801fae:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801fb2:	75 07                	jne    801fbb <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801fb4:	b8 01 00 00 00       	mov    $0x1,%eax
  801fb9:	eb 05                	jmp    801fc0 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801fbb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fc0:	c9                   	leave  
  801fc1:	c3                   	ret    

00801fc2 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801fc2:	55                   	push   %ebp
  801fc3:	89 e5                	mov    %esp,%ebp
  801fc5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fc8:	6a 00                	push   $0x0
  801fca:	6a 00                	push   $0x0
  801fcc:	6a 00                	push   $0x0
  801fce:	6a 00                	push   $0x0
  801fd0:	6a 00                	push   $0x0
  801fd2:	6a 2c                	push   $0x2c
  801fd4:	e8 4a fa ff ff       	call   801a23 <syscall>
  801fd9:	83 c4 18             	add    $0x18,%esp
  801fdc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801fdf:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801fe3:	75 07                	jne    801fec <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801fe5:	b8 01 00 00 00       	mov    $0x1,%eax
  801fea:	eb 05                	jmp    801ff1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801fec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ff1:	c9                   	leave  
  801ff2:	c3                   	ret    

00801ff3 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801ff3:	55                   	push   %ebp
  801ff4:	89 e5                	mov    %esp,%ebp
  801ff6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ff9:	6a 00                	push   $0x0
  801ffb:	6a 00                	push   $0x0
  801ffd:	6a 00                	push   $0x0
  801fff:	6a 00                	push   $0x0
  802001:	6a 00                	push   $0x0
  802003:	6a 2c                	push   $0x2c
  802005:	e8 19 fa ff ff       	call   801a23 <syscall>
  80200a:	83 c4 18             	add    $0x18,%esp
  80200d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802010:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802014:	75 07                	jne    80201d <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802016:	b8 01 00 00 00       	mov    $0x1,%eax
  80201b:	eb 05                	jmp    802022 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80201d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802022:	c9                   	leave  
  802023:	c3                   	ret    

00802024 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802024:	55                   	push   %ebp
  802025:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802027:	6a 00                	push   $0x0
  802029:	6a 00                	push   $0x0
  80202b:	6a 00                	push   $0x0
  80202d:	6a 00                	push   $0x0
  80202f:	ff 75 08             	pushl  0x8(%ebp)
  802032:	6a 2d                	push   $0x2d
  802034:	e8 ea f9 ff ff       	call   801a23 <syscall>
  802039:	83 c4 18             	add    $0x18,%esp
	return ;
  80203c:	90                   	nop
}
  80203d:	c9                   	leave  
  80203e:	c3                   	ret    

0080203f <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80203f:	55                   	push   %ebp
  802040:	89 e5                	mov    %esp,%ebp
  802042:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802043:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802046:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802049:	8b 55 0c             	mov    0xc(%ebp),%edx
  80204c:	8b 45 08             	mov    0x8(%ebp),%eax
  80204f:	6a 00                	push   $0x0
  802051:	53                   	push   %ebx
  802052:	51                   	push   %ecx
  802053:	52                   	push   %edx
  802054:	50                   	push   %eax
  802055:	6a 2e                	push   $0x2e
  802057:	e8 c7 f9 ff ff       	call   801a23 <syscall>
  80205c:	83 c4 18             	add    $0x18,%esp
}
  80205f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802062:	c9                   	leave  
  802063:	c3                   	ret    

00802064 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802064:	55                   	push   %ebp
  802065:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802067:	8b 55 0c             	mov    0xc(%ebp),%edx
  80206a:	8b 45 08             	mov    0x8(%ebp),%eax
  80206d:	6a 00                	push   $0x0
  80206f:	6a 00                	push   $0x0
  802071:	6a 00                	push   $0x0
  802073:	52                   	push   %edx
  802074:	50                   	push   %eax
  802075:	6a 2f                	push   $0x2f
  802077:	e8 a7 f9 ff ff       	call   801a23 <syscall>
  80207c:	83 c4 18             	add    $0x18,%esp
}
  80207f:	c9                   	leave  
  802080:	c3                   	ret    

00802081 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802081:	55                   	push   %ebp
  802082:	89 e5                	mov    %esp,%ebp
  802084:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802087:	83 ec 0c             	sub    $0xc,%esp
  80208a:	68 3c 3e 80 00       	push   $0x803e3c
  80208f:	e8 c7 e6 ff ff       	call   80075b <cprintf>
  802094:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802097:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  80209e:	83 ec 0c             	sub    $0xc,%esp
  8020a1:	68 68 3e 80 00       	push   $0x803e68
  8020a6:	e8 b0 e6 ff ff       	call   80075b <cprintf>
  8020ab:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8020ae:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8020b2:	a1 38 41 80 00       	mov    0x804138,%eax
  8020b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020ba:	eb 56                	jmp    802112 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8020bc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020c0:	74 1c                	je     8020de <print_mem_block_lists+0x5d>
  8020c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c5:	8b 50 08             	mov    0x8(%eax),%edx
  8020c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020cb:	8b 48 08             	mov    0x8(%eax),%ecx
  8020ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020d1:	8b 40 0c             	mov    0xc(%eax),%eax
  8020d4:	01 c8                	add    %ecx,%eax
  8020d6:	39 c2                	cmp    %eax,%edx
  8020d8:	73 04                	jae    8020de <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8020da:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8020de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e1:	8b 50 08             	mov    0x8(%eax),%edx
  8020e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e7:	8b 40 0c             	mov    0xc(%eax),%eax
  8020ea:	01 c2                	add    %eax,%edx
  8020ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ef:	8b 40 08             	mov    0x8(%eax),%eax
  8020f2:	83 ec 04             	sub    $0x4,%esp
  8020f5:	52                   	push   %edx
  8020f6:	50                   	push   %eax
  8020f7:	68 7d 3e 80 00       	push   $0x803e7d
  8020fc:	e8 5a e6 ff ff       	call   80075b <cprintf>
  802101:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802104:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802107:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80210a:	a1 40 41 80 00       	mov    0x804140,%eax
  80210f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802112:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802116:	74 07                	je     80211f <print_mem_block_lists+0x9e>
  802118:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211b:	8b 00                	mov    (%eax),%eax
  80211d:	eb 05                	jmp    802124 <print_mem_block_lists+0xa3>
  80211f:	b8 00 00 00 00       	mov    $0x0,%eax
  802124:	a3 40 41 80 00       	mov    %eax,0x804140
  802129:	a1 40 41 80 00       	mov    0x804140,%eax
  80212e:	85 c0                	test   %eax,%eax
  802130:	75 8a                	jne    8020bc <print_mem_block_lists+0x3b>
  802132:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802136:	75 84                	jne    8020bc <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802138:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80213c:	75 10                	jne    80214e <print_mem_block_lists+0xcd>
  80213e:	83 ec 0c             	sub    $0xc,%esp
  802141:	68 8c 3e 80 00       	push   $0x803e8c
  802146:	e8 10 e6 ff ff       	call   80075b <cprintf>
  80214b:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80214e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802155:	83 ec 0c             	sub    $0xc,%esp
  802158:	68 b0 3e 80 00       	push   $0x803eb0
  80215d:	e8 f9 e5 ff ff       	call   80075b <cprintf>
  802162:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802165:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802169:	a1 40 40 80 00       	mov    0x804040,%eax
  80216e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802171:	eb 56                	jmp    8021c9 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802173:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802177:	74 1c                	je     802195 <print_mem_block_lists+0x114>
  802179:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80217c:	8b 50 08             	mov    0x8(%eax),%edx
  80217f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802182:	8b 48 08             	mov    0x8(%eax),%ecx
  802185:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802188:	8b 40 0c             	mov    0xc(%eax),%eax
  80218b:	01 c8                	add    %ecx,%eax
  80218d:	39 c2                	cmp    %eax,%edx
  80218f:	73 04                	jae    802195 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802191:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802195:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802198:	8b 50 08             	mov    0x8(%eax),%edx
  80219b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219e:	8b 40 0c             	mov    0xc(%eax),%eax
  8021a1:	01 c2                	add    %eax,%edx
  8021a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a6:	8b 40 08             	mov    0x8(%eax),%eax
  8021a9:	83 ec 04             	sub    $0x4,%esp
  8021ac:	52                   	push   %edx
  8021ad:	50                   	push   %eax
  8021ae:	68 7d 3e 80 00       	push   $0x803e7d
  8021b3:	e8 a3 e5 ff ff       	call   80075b <cprintf>
  8021b8:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8021bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021be:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8021c1:	a1 48 40 80 00       	mov    0x804048,%eax
  8021c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021cd:	74 07                	je     8021d6 <print_mem_block_lists+0x155>
  8021cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d2:	8b 00                	mov    (%eax),%eax
  8021d4:	eb 05                	jmp    8021db <print_mem_block_lists+0x15a>
  8021d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8021db:	a3 48 40 80 00       	mov    %eax,0x804048
  8021e0:	a1 48 40 80 00       	mov    0x804048,%eax
  8021e5:	85 c0                	test   %eax,%eax
  8021e7:	75 8a                	jne    802173 <print_mem_block_lists+0xf2>
  8021e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021ed:	75 84                	jne    802173 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8021ef:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8021f3:	75 10                	jne    802205 <print_mem_block_lists+0x184>
  8021f5:	83 ec 0c             	sub    $0xc,%esp
  8021f8:	68 c8 3e 80 00       	push   $0x803ec8
  8021fd:	e8 59 e5 ff ff       	call   80075b <cprintf>
  802202:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802205:	83 ec 0c             	sub    $0xc,%esp
  802208:	68 3c 3e 80 00       	push   $0x803e3c
  80220d:	e8 49 e5 ff ff       	call   80075b <cprintf>
  802212:	83 c4 10             	add    $0x10,%esp

}
  802215:	90                   	nop
  802216:	c9                   	leave  
  802217:	c3                   	ret    

00802218 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802218:	55                   	push   %ebp
  802219:	89 e5                	mov    %esp,%ebp
  80221b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);
  80221e:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  802225:	00 00 00 
  802228:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  80222f:	00 00 00 
  802232:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  802239:	00 00 00 

		struct MemBlock *tmp=MemBlockNodes;
  80223c:	a1 50 40 80 00       	mov    0x804050,%eax
  802241:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (int i=0;i<numOfBlocks;i++)
  802244:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80224b:	e9 9e 00 00 00       	jmp    8022ee <initialize_MemBlocksList+0xd6>
		{

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  802250:	a1 50 40 80 00       	mov    0x804050,%eax
  802255:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802258:	c1 e2 04             	shl    $0x4,%edx
  80225b:	01 d0                	add    %edx,%eax
  80225d:	85 c0                	test   %eax,%eax
  80225f:	75 14                	jne    802275 <initialize_MemBlocksList+0x5d>
  802261:	83 ec 04             	sub    $0x4,%esp
  802264:	68 f0 3e 80 00       	push   $0x803ef0
  802269:	6a 48                	push   $0x48
  80226b:	68 13 3f 80 00       	push   $0x803f13
  802270:	e8 32 e2 ff ff       	call   8004a7 <_panic>
  802275:	a1 50 40 80 00       	mov    0x804050,%eax
  80227a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80227d:	c1 e2 04             	shl    $0x4,%edx
  802280:	01 d0                	add    %edx,%eax
  802282:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802288:	89 10                	mov    %edx,(%eax)
  80228a:	8b 00                	mov    (%eax),%eax
  80228c:	85 c0                	test   %eax,%eax
  80228e:	74 18                	je     8022a8 <initialize_MemBlocksList+0x90>
  802290:	a1 48 41 80 00       	mov    0x804148,%eax
  802295:	8b 15 50 40 80 00    	mov    0x804050,%edx
  80229b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80229e:	c1 e1 04             	shl    $0x4,%ecx
  8022a1:	01 ca                	add    %ecx,%edx
  8022a3:	89 50 04             	mov    %edx,0x4(%eax)
  8022a6:	eb 12                	jmp    8022ba <initialize_MemBlocksList+0xa2>
  8022a8:	a1 50 40 80 00       	mov    0x804050,%eax
  8022ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022b0:	c1 e2 04             	shl    $0x4,%edx
  8022b3:	01 d0                	add    %edx,%eax
  8022b5:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8022ba:	a1 50 40 80 00       	mov    0x804050,%eax
  8022bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022c2:	c1 e2 04             	shl    $0x4,%edx
  8022c5:	01 d0                	add    %edx,%eax
  8022c7:	a3 48 41 80 00       	mov    %eax,0x804148
  8022cc:	a1 50 40 80 00       	mov    0x804050,%eax
  8022d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022d4:	c1 e2 04             	shl    $0x4,%edx
  8022d7:	01 d0                	add    %edx,%eax
  8022d9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022e0:	a1 54 41 80 00       	mov    0x804154,%eax
  8022e5:	40                   	inc    %eax
  8022e6:	a3 54 41 80 00       	mov    %eax,0x804154
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);

		struct MemBlock *tmp=MemBlockNodes;
		for (int i=0;i<numOfBlocks;i++)
  8022eb:	ff 45 f4             	incl   -0xc(%ebp)
  8022ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022f4:	0f 82 56 ff ff ff    	jb     802250 <initialize_MemBlocksList+0x38>

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
		}


}
  8022fa:	90                   	nop
  8022fb:	c9                   	leave  
  8022fc:	c3                   	ret    

008022fd <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8022fd:	55                   	push   %ebp
  8022fe:	89 e5                	mov    %esp,%ebp
  802300:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;
  802303:	8b 45 08             	mov    0x8(%ebp),%eax
  802306:	8b 00                	mov    (%eax),%eax
  802308:	89 45 fc             	mov    %eax,-0x4(%ebp)

	while(tmp!=NULL)
  80230b:	eb 18                	jmp    802325 <find_block+0x28>
		{
			if(tmp->sva==va)
  80230d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802310:	8b 40 08             	mov    0x8(%eax),%eax
  802313:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802316:	75 05                	jne    80231d <find_block+0x20>
			{
				return tmp;
  802318:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80231b:	eb 11                	jmp    80232e <find_block+0x31>

			}
		tmp=tmp->prev_next_info.le_next;
  80231d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802320:	8b 00                	mov    (%eax),%eax
  802322:	89 45 fc             	mov    %eax,-0x4(%ebp)
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;

	while(tmp!=NULL)
  802325:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802329:	75 e2                	jne    80230d <find_block+0x10>
				return tmp;

			}
		tmp=tmp->prev_next_info.le_next;
		}
		return tmp;
  80232b:	8b 45 fc             	mov    -0x4(%ebp),%eax
//
//		}
//
//		}
//			return tmp;
}
  80232e:	c9                   	leave  
  80232f:	c3                   	ret    

00802330 <insert_sorted_allocList>:
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================


void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802330:	55                   	push   %ebp
  802331:	89 e5                	mov    %esp,%ebp
  802333:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code

	if(AllocMemBlocksList.lh_first==NULL)
  802336:	a1 40 40 80 00       	mov    0x804040,%eax
  80233b:	85 c0                	test   %eax,%eax
  80233d:	0f 85 83 00 00 00    	jne    8023c6 <insert_sorted_allocList+0x96>
	{
		LIST_INIT(&AllocMemBlocksList);
  802343:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  80234a:	00 00 00 
  80234d:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  802354:	00 00 00 
  802357:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  80235e:	00 00 00 
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802361:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802365:	75 14                	jne    80237b <insert_sorted_allocList+0x4b>
  802367:	83 ec 04             	sub    $0x4,%esp
  80236a:	68 f0 3e 80 00       	push   $0x803ef0
  80236f:	6a 7f                	push   $0x7f
  802371:	68 13 3f 80 00       	push   $0x803f13
  802376:	e8 2c e1 ff ff       	call   8004a7 <_panic>
  80237b:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802381:	8b 45 08             	mov    0x8(%ebp),%eax
  802384:	89 10                	mov    %edx,(%eax)
  802386:	8b 45 08             	mov    0x8(%ebp),%eax
  802389:	8b 00                	mov    (%eax),%eax
  80238b:	85 c0                	test   %eax,%eax
  80238d:	74 0d                	je     80239c <insert_sorted_allocList+0x6c>
  80238f:	a1 40 40 80 00       	mov    0x804040,%eax
  802394:	8b 55 08             	mov    0x8(%ebp),%edx
  802397:	89 50 04             	mov    %edx,0x4(%eax)
  80239a:	eb 08                	jmp    8023a4 <insert_sorted_allocList+0x74>
  80239c:	8b 45 08             	mov    0x8(%ebp),%eax
  80239f:	a3 44 40 80 00       	mov    %eax,0x804044
  8023a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a7:	a3 40 40 80 00       	mov    %eax,0x804040
  8023ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8023af:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023b6:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8023bb:	40                   	inc    %eax
  8023bc:	a3 4c 40 80 00       	mov    %eax,0x80404c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8023c1:	e9 16 01 00 00       	jmp    8024dc <insert_sorted_allocList+0x1ac>
		LIST_INIT(&AllocMemBlocksList);
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}


	else if(blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  8023c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c9:	8b 50 08             	mov    0x8(%eax),%edx
  8023cc:	a1 44 40 80 00       	mov    0x804044,%eax
  8023d1:	8b 40 08             	mov    0x8(%eax),%eax
  8023d4:	39 c2                	cmp    %eax,%edx
  8023d6:	76 68                	jbe    802440 <insert_sorted_allocList+0x110>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
  8023d8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023dc:	75 17                	jne    8023f5 <insert_sorted_allocList+0xc5>
  8023de:	83 ec 04             	sub    $0x4,%esp
  8023e1:	68 2c 3f 80 00       	push   $0x803f2c
  8023e6:	68 85 00 00 00       	push   $0x85
  8023eb:	68 13 3f 80 00       	push   $0x803f13
  8023f0:	e8 b2 e0 ff ff       	call   8004a7 <_panic>
  8023f5:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8023fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fe:	89 50 04             	mov    %edx,0x4(%eax)
  802401:	8b 45 08             	mov    0x8(%ebp),%eax
  802404:	8b 40 04             	mov    0x4(%eax),%eax
  802407:	85 c0                	test   %eax,%eax
  802409:	74 0c                	je     802417 <insert_sorted_allocList+0xe7>
  80240b:	a1 44 40 80 00       	mov    0x804044,%eax
  802410:	8b 55 08             	mov    0x8(%ebp),%edx
  802413:	89 10                	mov    %edx,(%eax)
  802415:	eb 08                	jmp    80241f <insert_sorted_allocList+0xef>
  802417:	8b 45 08             	mov    0x8(%ebp),%eax
  80241a:	a3 40 40 80 00       	mov    %eax,0x804040
  80241f:	8b 45 08             	mov    0x8(%ebp),%eax
  802422:	a3 44 40 80 00       	mov    %eax,0x804044
  802427:	8b 45 08             	mov    0x8(%ebp),%eax
  80242a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802430:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802435:	40                   	inc    %eax
  802436:	a3 4c 40 80 00       	mov    %eax,0x80404c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  80243b:	e9 9c 00 00 00       	jmp    8024dc <insert_sorted_allocList+0x1ac>
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
  802440:	a1 40 40 80 00       	mov    0x804040,%eax
  802445:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  802448:	e9 85 00 00 00       	jmp    8024d2 <insert_sorted_allocList+0x1a2>
		{
			if(blockToInsert->sva<tmp->sva)
  80244d:	8b 45 08             	mov    0x8(%ebp),%eax
  802450:	8b 50 08             	mov    0x8(%eax),%edx
  802453:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802456:	8b 40 08             	mov    0x8(%eax),%eax
  802459:	39 c2                	cmp    %eax,%edx
  80245b:	73 6d                	jae    8024ca <insert_sorted_allocList+0x19a>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
  80245d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802461:	74 06                	je     802469 <insert_sorted_allocList+0x139>
  802463:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802467:	75 17                	jne    802480 <insert_sorted_allocList+0x150>
  802469:	83 ec 04             	sub    $0x4,%esp
  80246c:	68 50 3f 80 00       	push   $0x803f50
  802471:	68 90 00 00 00       	push   $0x90
  802476:	68 13 3f 80 00       	push   $0x803f13
  80247b:	e8 27 e0 ff ff       	call   8004a7 <_panic>
  802480:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802483:	8b 50 04             	mov    0x4(%eax),%edx
  802486:	8b 45 08             	mov    0x8(%ebp),%eax
  802489:	89 50 04             	mov    %edx,0x4(%eax)
  80248c:	8b 45 08             	mov    0x8(%ebp),%eax
  80248f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802492:	89 10                	mov    %edx,(%eax)
  802494:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802497:	8b 40 04             	mov    0x4(%eax),%eax
  80249a:	85 c0                	test   %eax,%eax
  80249c:	74 0d                	je     8024ab <insert_sorted_allocList+0x17b>
  80249e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a1:	8b 40 04             	mov    0x4(%eax),%eax
  8024a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8024a7:	89 10                	mov    %edx,(%eax)
  8024a9:	eb 08                	jmp    8024b3 <insert_sorted_allocList+0x183>
  8024ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ae:	a3 40 40 80 00       	mov    %eax,0x804040
  8024b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8024b9:	89 50 04             	mov    %edx,0x4(%eax)
  8024bc:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8024c1:	40                   	inc    %eax
  8024c2:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  8024c7:	90                   	nop
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8024c8:	eb 12                	jmp    8024dc <insert_sorted_allocList+0x1ac>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
				break;
			}
			tmp=tmp->prev_next_info.le_next;
  8024ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cd:	8b 00                	mov    (%eax),%eax
  8024cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
		while(tmp!=NULL)
  8024d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024d6:	0f 85 71 ff ff ff    	jne    80244d <insert_sorted_allocList+0x11d>
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8024dc:	90                   	nop
  8024dd:	c9                   	leave  
  8024de:	c3                   	ret    

008024df <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

struct MemBlock *alloc_block_FF(uint32 size)
{
  8024df:	55                   	push   %ebp
  8024e0:	89 e5                	mov    %esp,%ebp
  8024e2:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  8024e5:	a1 38 41 80 00       	mov    0x804138,%eax
  8024ea:	89 45 f4             	mov    %eax,-0xc(%ebp)

	while(tmp!=NULL)
  8024ed:	e9 76 01 00 00       	jmp    802668 <alloc_block_FF+0x189>
	{
		if(size==(tmp->size))
  8024f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f5:	8b 40 0c             	mov    0xc(%eax),%eax
  8024f8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024fb:	0f 85 8a 00 00 00    	jne    80258b <alloc_block_FF+0xac>
		{

			LIST_REMOVE(&FreeMemBlocksList,tmp);
  802501:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802505:	75 17                	jne    80251e <alloc_block_FF+0x3f>
  802507:	83 ec 04             	sub    $0x4,%esp
  80250a:	68 85 3f 80 00       	push   $0x803f85
  80250f:	68 a8 00 00 00       	push   $0xa8
  802514:	68 13 3f 80 00       	push   $0x803f13
  802519:	e8 89 df ff ff       	call   8004a7 <_panic>
  80251e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802521:	8b 00                	mov    (%eax),%eax
  802523:	85 c0                	test   %eax,%eax
  802525:	74 10                	je     802537 <alloc_block_FF+0x58>
  802527:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252a:	8b 00                	mov    (%eax),%eax
  80252c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80252f:	8b 52 04             	mov    0x4(%edx),%edx
  802532:	89 50 04             	mov    %edx,0x4(%eax)
  802535:	eb 0b                	jmp    802542 <alloc_block_FF+0x63>
  802537:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253a:	8b 40 04             	mov    0x4(%eax),%eax
  80253d:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802542:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802545:	8b 40 04             	mov    0x4(%eax),%eax
  802548:	85 c0                	test   %eax,%eax
  80254a:	74 0f                	je     80255b <alloc_block_FF+0x7c>
  80254c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254f:	8b 40 04             	mov    0x4(%eax),%eax
  802552:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802555:	8b 12                	mov    (%edx),%edx
  802557:	89 10                	mov    %edx,(%eax)
  802559:	eb 0a                	jmp    802565 <alloc_block_FF+0x86>
  80255b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255e:	8b 00                	mov    (%eax),%eax
  802560:	a3 38 41 80 00       	mov    %eax,0x804138
  802565:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802568:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80256e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802571:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802578:	a1 44 41 80 00       	mov    0x804144,%eax
  80257d:	48                   	dec    %eax
  80257e:	a3 44 41 80 00       	mov    %eax,0x804144

			return tmp;
  802583:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802586:	e9 ea 00 00 00       	jmp    802675 <alloc_block_FF+0x196>

		}
		else if(size<tmp->size)
  80258b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258e:	8b 40 0c             	mov    0xc(%eax),%eax
  802591:	3b 45 08             	cmp    0x8(%ebp),%eax
  802594:	0f 86 c6 00 00 00    	jbe    802660 <alloc_block_FF+0x181>
		{

			 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  80259a:	a1 48 41 80 00       	mov    0x804148,%eax
  80259f:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 newBlock->size=size;
  8025a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8025a8:	89 50 0c             	mov    %edx,0xc(%eax)
			 newBlock->sva=tmp->sva;
  8025ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ae:	8b 50 08             	mov    0x8(%eax),%edx
  8025b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025b4:	89 50 08             	mov    %edx,0x8(%eax)
			 tmp->size=tmp->size-size;
  8025b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8025bd:	2b 45 08             	sub    0x8(%ebp),%eax
  8025c0:	89 c2                	mov    %eax,%edx
  8025c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c5:	89 50 0c             	mov    %edx,0xc(%eax)
			 tmp->sva=tmp->sva+size;
  8025c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cb:	8b 50 08             	mov    0x8(%eax),%edx
  8025ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d1:	01 c2                	add    %eax,%edx
  8025d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d6:	89 50 08             	mov    %edx,0x8(%eax)

			 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  8025d9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025dd:	75 17                	jne    8025f6 <alloc_block_FF+0x117>
  8025df:	83 ec 04             	sub    $0x4,%esp
  8025e2:	68 85 3f 80 00       	push   $0x803f85
  8025e7:	68 b6 00 00 00       	push   $0xb6
  8025ec:	68 13 3f 80 00       	push   $0x803f13
  8025f1:	e8 b1 de ff ff       	call   8004a7 <_panic>
  8025f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025f9:	8b 00                	mov    (%eax),%eax
  8025fb:	85 c0                	test   %eax,%eax
  8025fd:	74 10                	je     80260f <alloc_block_FF+0x130>
  8025ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802602:	8b 00                	mov    (%eax),%eax
  802604:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802607:	8b 52 04             	mov    0x4(%edx),%edx
  80260a:	89 50 04             	mov    %edx,0x4(%eax)
  80260d:	eb 0b                	jmp    80261a <alloc_block_FF+0x13b>
  80260f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802612:	8b 40 04             	mov    0x4(%eax),%eax
  802615:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80261a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80261d:	8b 40 04             	mov    0x4(%eax),%eax
  802620:	85 c0                	test   %eax,%eax
  802622:	74 0f                	je     802633 <alloc_block_FF+0x154>
  802624:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802627:	8b 40 04             	mov    0x4(%eax),%eax
  80262a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80262d:	8b 12                	mov    (%edx),%edx
  80262f:	89 10                	mov    %edx,(%eax)
  802631:	eb 0a                	jmp    80263d <alloc_block_FF+0x15e>
  802633:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802636:	8b 00                	mov    (%eax),%eax
  802638:	a3 48 41 80 00       	mov    %eax,0x804148
  80263d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802640:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802646:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802649:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802650:	a1 54 41 80 00       	mov    0x804154,%eax
  802655:	48                   	dec    %eax
  802656:	a3 54 41 80 00       	mov    %eax,0x804154
			 return newBlock;
  80265b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80265e:	eb 15                	jmp    802675 <alloc_block_FF+0x196>

		}
		tmp=tmp->prev_next_info.le_next;
  802660:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802663:	8b 00                	mov    (%eax),%eax
  802665:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;

	while(tmp!=NULL)
  802668:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80266c:	0f 85 80 fe ff ff    	jne    8024f2 <alloc_block_FF+0x13>
			 return newBlock;

		}
		tmp=tmp->prev_next_info.le_next;
	}
	return tmp;
  802672:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802675:	c9                   	leave  
  802676:	c3                   	ret    

00802677 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802677:	55                   	push   %ebp
  802678:	89 e5                	mov    %esp,%ebp
  80267a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  80267d:	a1 38 41 80 00       	mov    0x804138,%eax
  802682:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 newSize=UINT_MAX;
  802685:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)


		while(tmp!=NULL)
  80268c:	e9 c0 00 00 00       	jmp    802751 <alloc_block_BF+0xda>
		{
			if(size==(tmp->size))
  802691:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802694:	8b 40 0c             	mov    0xc(%eax),%eax
  802697:	3b 45 08             	cmp    0x8(%ebp),%eax
  80269a:	0f 85 8a 00 00 00    	jne    80272a <alloc_block_BF+0xb3>
			{
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  8026a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026a4:	75 17                	jne    8026bd <alloc_block_BF+0x46>
  8026a6:	83 ec 04             	sub    $0x4,%esp
  8026a9:	68 85 3f 80 00       	push   $0x803f85
  8026ae:	68 cf 00 00 00       	push   $0xcf
  8026b3:	68 13 3f 80 00       	push   $0x803f13
  8026b8:	e8 ea dd ff ff       	call   8004a7 <_panic>
  8026bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c0:	8b 00                	mov    (%eax),%eax
  8026c2:	85 c0                	test   %eax,%eax
  8026c4:	74 10                	je     8026d6 <alloc_block_BF+0x5f>
  8026c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c9:	8b 00                	mov    (%eax),%eax
  8026cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026ce:	8b 52 04             	mov    0x4(%edx),%edx
  8026d1:	89 50 04             	mov    %edx,0x4(%eax)
  8026d4:	eb 0b                	jmp    8026e1 <alloc_block_BF+0x6a>
  8026d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d9:	8b 40 04             	mov    0x4(%eax),%eax
  8026dc:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8026e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e4:	8b 40 04             	mov    0x4(%eax),%eax
  8026e7:	85 c0                	test   %eax,%eax
  8026e9:	74 0f                	je     8026fa <alloc_block_BF+0x83>
  8026eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ee:	8b 40 04             	mov    0x4(%eax),%eax
  8026f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026f4:	8b 12                	mov    (%edx),%edx
  8026f6:	89 10                	mov    %edx,(%eax)
  8026f8:	eb 0a                	jmp    802704 <alloc_block_BF+0x8d>
  8026fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fd:	8b 00                	mov    (%eax),%eax
  8026ff:	a3 38 41 80 00       	mov    %eax,0x804138
  802704:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802707:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80270d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802710:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802717:	a1 44 41 80 00       	mov    0x804144,%eax
  80271c:	48                   	dec    %eax
  80271d:	a3 44 41 80 00       	mov    %eax,0x804144
				return tmp;
  802722:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802725:	e9 2a 01 00 00       	jmp    802854 <alloc_block_BF+0x1dd>

			}
			else if (tmp->size<newSize&&tmp->size>size)
  80272a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272d:	8b 40 0c             	mov    0xc(%eax),%eax
  802730:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802733:	73 14                	jae    802749 <alloc_block_BF+0xd2>
  802735:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802738:	8b 40 0c             	mov    0xc(%eax),%eax
  80273b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80273e:	76 09                	jbe    802749 <alloc_block_BF+0xd2>
			{
				newSize=tmp->size;
  802740:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802743:	8b 40 0c             	mov    0xc(%eax),%eax
  802746:	89 45 f0             	mov    %eax,-0x10(%ebp)


			}
			tmp=tmp->prev_next_info.le_next;
  802749:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274c:	8b 00                	mov    (%eax),%eax
  80274e:	89 45 f4             	mov    %eax,-0xc(%ebp)

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
	uint32 newSize=UINT_MAX;


		while(tmp!=NULL)
  802751:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802755:	0f 85 36 ff ff ff    	jne    802691 <alloc_block_BF+0x1a>
		}//tmp=NULL




			tmp =FreeMemBlocksList.lh_first;
  80275b:	a1 38 41 80 00       	mov    0x804138,%eax
  802760:	89 45 f4             	mov    %eax,-0xc(%ebp)
			while(tmp!=NULL)
  802763:	e9 dd 00 00 00       	jmp    802845 <alloc_block_BF+0x1ce>
			{
				if(tmp->size==newSize)
  802768:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276b:	8b 40 0c             	mov    0xc(%eax),%eax
  80276e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802771:	0f 85 c6 00 00 00    	jne    80283d <alloc_block_BF+0x1c6>
					{
					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802777:	a1 48 41 80 00       	mov    0x804148,%eax
  80277c:	89 45 ec             	mov    %eax,-0x14(%ebp)

								 newBlock->sva=tmp->sva;     //newBlock.sva=tmp.sva
  80277f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802782:	8b 50 08             	mov    0x8(%eax),%edx
  802785:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802788:	89 50 08             	mov    %edx,0x8(%eax)
								 newBlock->size=size;
  80278b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80278e:	8b 55 08             	mov    0x8(%ebp),%edx
  802791:	89 50 0c             	mov    %edx,0xc(%eax)

											 tmp->sva+=size;
  802794:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802797:	8b 50 08             	mov    0x8(%eax),%edx
  80279a:	8b 45 08             	mov    0x8(%ebp),%eax
  80279d:	01 c2                	add    %eax,%edx
  80279f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a2:	89 50 08             	mov    %edx,0x8(%eax)
											 tmp->size-=size;
  8027a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a8:	8b 40 0c             	mov    0xc(%eax),%eax
  8027ab:	2b 45 08             	sub    0x8(%ebp),%eax
  8027ae:	89 c2                	mov    %eax,%edx
  8027b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b3:	89 50 0c             	mov    %edx,0xc(%eax)
											 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  8027b6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8027ba:	75 17                	jne    8027d3 <alloc_block_BF+0x15c>
  8027bc:	83 ec 04             	sub    $0x4,%esp
  8027bf:	68 85 3f 80 00       	push   $0x803f85
  8027c4:	68 eb 00 00 00       	push   $0xeb
  8027c9:	68 13 3f 80 00       	push   $0x803f13
  8027ce:	e8 d4 dc ff ff       	call   8004a7 <_panic>
  8027d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027d6:	8b 00                	mov    (%eax),%eax
  8027d8:	85 c0                	test   %eax,%eax
  8027da:	74 10                	je     8027ec <alloc_block_BF+0x175>
  8027dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027df:	8b 00                	mov    (%eax),%eax
  8027e1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027e4:	8b 52 04             	mov    0x4(%edx),%edx
  8027e7:	89 50 04             	mov    %edx,0x4(%eax)
  8027ea:	eb 0b                	jmp    8027f7 <alloc_block_BF+0x180>
  8027ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027ef:	8b 40 04             	mov    0x4(%eax),%eax
  8027f2:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8027f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027fa:	8b 40 04             	mov    0x4(%eax),%eax
  8027fd:	85 c0                	test   %eax,%eax
  8027ff:	74 0f                	je     802810 <alloc_block_BF+0x199>
  802801:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802804:	8b 40 04             	mov    0x4(%eax),%eax
  802807:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80280a:	8b 12                	mov    (%edx),%edx
  80280c:	89 10                	mov    %edx,(%eax)
  80280e:	eb 0a                	jmp    80281a <alloc_block_BF+0x1a3>
  802810:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802813:	8b 00                	mov    (%eax),%eax
  802815:	a3 48 41 80 00       	mov    %eax,0x804148
  80281a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80281d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802823:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802826:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80282d:	a1 54 41 80 00       	mov    0x804154,%eax
  802832:	48                   	dec    %eax
  802833:	a3 54 41 80 00       	mov    %eax,0x804154
											 return newBlock;
  802838:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80283b:	eb 17                	jmp    802854 <alloc_block_BF+0x1dd>

					}
				tmp=tmp->prev_next_info.le_next;
  80283d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802840:	8b 00                	mov    (%eax),%eax
  802842:	89 45 f4             	mov    %eax,-0xc(%ebp)




			tmp =FreeMemBlocksList.lh_first;
			while(tmp!=NULL)
  802845:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802849:	0f 85 19 ff ff ff    	jne    802768 <alloc_block_BF+0xf1>
			//tmp ->  block newSize,Sva




		return NULL; //return NULL
  80284f:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802854:	c9                   	leave  
  802855:	c3                   	ret    

00802856 <alloc_block_NF>:
//=========================================



struct MemBlock *alloc_block_NF(uint32 size)
{
  802856:	55                   	push   %ebp
  802857:	89 e5                	mov    %esp,%ebp
  802859:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp1;
	uint32 currentSva;
	if(AllocMemBlocksList.lh_first==NULL)
  80285c:	a1 40 40 80 00       	mov    0x804040,%eax
  802861:	85 c0                	test   %eax,%eax
  802863:	75 19                	jne    80287e <alloc_block_NF+0x28>
	{
		tmp1=alloc_block_FF(size);
  802865:	83 ec 0c             	sub    $0xc,%esp
  802868:	ff 75 08             	pushl  0x8(%ebp)
  80286b:	e8 6f fc ff ff       	call   8024df <alloc_block_FF>
  802870:	83 c4 10             	add    $0x10,%esp
  802873:	89 45 f4             	mov    %eax,-0xc(%ebp)
		return tmp1;
  802876:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802879:	e9 e9 01 00 00       	jmp    802a67 <alloc_block_NF+0x211>
	}

			else
			{
            currentSva=AllocMemBlocksList.lh_last->sva;
  80287e:	a1 44 40 80 00       	mov    0x804044,%eax
  802883:	8b 40 08             	mov    0x8(%eax),%eax
  802886:	89 45 f0             	mov    %eax,-0x10(%ebp)
			tmp1=find_block(&FreeMemBlocksList,AllocMemBlocksList.lh_last->size+AllocMemBlocksList.lh_last->sva);
  802889:	a1 44 40 80 00       	mov    0x804044,%eax
  80288e:	8b 50 0c             	mov    0xc(%eax),%edx
  802891:	a1 44 40 80 00       	mov    0x804044,%eax
  802896:	8b 40 08             	mov    0x8(%eax),%eax
  802899:	01 d0                	add    %edx,%eax
  80289b:	83 ec 08             	sub    $0x8,%esp
  80289e:	50                   	push   %eax
  80289f:	68 38 41 80 00       	push   $0x804138
  8028a4:	e8 54 fa ff ff       	call   8022fd <find_block>
  8028a9:	83 c4 10             	add    $0x10,%esp
  8028ac:	89 45 f4             	mov    %eax,-0xc(%ebp)


do
	{

		if(size==(tmp1->size))
  8028af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b2:	8b 40 0c             	mov    0xc(%eax),%eax
  8028b5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028b8:	0f 85 9b 00 00 00    	jne    802959 <alloc_block_NF+0x103>
				{
			currentSva=tmp1->size+tmp1->sva;
  8028be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c1:	8b 50 0c             	mov    0xc(%eax),%edx
  8028c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c7:	8b 40 08             	mov    0x8(%eax),%eax
  8028ca:	01 d0                	add    %edx,%eax
  8028cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,tmp1);
  8028cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028d3:	75 17                	jne    8028ec <alloc_block_NF+0x96>
  8028d5:	83 ec 04             	sub    $0x4,%esp
  8028d8:	68 85 3f 80 00       	push   $0x803f85
  8028dd:	68 1a 01 00 00       	push   $0x11a
  8028e2:	68 13 3f 80 00       	push   $0x803f13
  8028e7:	e8 bb db ff ff       	call   8004a7 <_panic>
  8028ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ef:	8b 00                	mov    (%eax),%eax
  8028f1:	85 c0                	test   %eax,%eax
  8028f3:	74 10                	je     802905 <alloc_block_NF+0xaf>
  8028f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f8:	8b 00                	mov    (%eax),%eax
  8028fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028fd:	8b 52 04             	mov    0x4(%edx),%edx
  802900:	89 50 04             	mov    %edx,0x4(%eax)
  802903:	eb 0b                	jmp    802910 <alloc_block_NF+0xba>
  802905:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802908:	8b 40 04             	mov    0x4(%eax),%eax
  80290b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802910:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802913:	8b 40 04             	mov    0x4(%eax),%eax
  802916:	85 c0                	test   %eax,%eax
  802918:	74 0f                	je     802929 <alloc_block_NF+0xd3>
  80291a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291d:	8b 40 04             	mov    0x4(%eax),%eax
  802920:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802923:	8b 12                	mov    (%edx),%edx
  802925:	89 10                	mov    %edx,(%eax)
  802927:	eb 0a                	jmp    802933 <alloc_block_NF+0xdd>
  802929:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292c:	8b 00                	mov    (%eax),%eax
  80292e:	a3 38 41 80 00       	mov    %eax,0x804138
  802933:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802936:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80293c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802946:	a1 44 41 80 00       	mov    0x804144,%eax
  80294b:	48                   	dec    %eax
  80294c:	a3 44 41 80 00       	mov    %eax,0x804144
					return tmp1;
  802951:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802954:	e9 0e 01 00 00       	jmp    802a67 <alloc_block_NF+0x211>

				}
				else if(size<tmp1->size)
  802959:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295c:	8b 40 0c             	mov    0xc(%eax),%eax
  80295f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802962:	0f 86 cf 00 00 00    	jbe    802a37 <alloc_block_NF+0x1e1>
				{

					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802968:	a1 48 41 80 00       	mov    0x804148,%eax
  80296d:	89 45 ec             	mov    %eax,-0x14(%ebp)
					 newBlock->size=size;
  802970:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802973:	8b 55 08             	mov    0x8(%ebp),%edx
  802976:	89 50 0c             	mov    %edx,0xc(%eax)
					 newBlock->sva=tmp1->sva;
  802979:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297c:	8b 50 08             	mov    0x8(%eax),%edx
  80297f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802982:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->sva+=size;
  802985:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802988:	8b 50 08             	mov    0x8(%eax),%edx
  80298b:	8b 45 08             	mov    0x8(%ebp),%eax
  80298e:	01 c2                	add    %eax,%edx
  802990:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802993:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->size-=size;
  802996:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802999:	8b 40 0c             	mov    0xc(%eax),%eax
  80299c:	2b 45 08             	sub    0x8(%ebp),%eax
  80299f:	89 c2                	mov    %eax,%edx
  8029a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a4:	89 50 0c             	mov    %edx,0xc(%eax)
                     currentSva=tmp1->sva;
  8029a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029aa:	8b 40 08             	mov    0x8(%eax),%eax
  8029ad:	89 45 f0             	mov    %eax,-0x10(%ebp)

					 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  8029b0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8029b4:	75 17                	jne    8029cd <alloc_block_NF+0x177>
  8029b6:	83 ec 04             	sub    $0x4,%esp
  8029b9:	68 85 3f 80 00       	push   $0x803f85
  8029be:	68 28 01 00 00       	push   $0x128
  8029c3:	68 13 3f 80 00       	push   $0x803f13
  8029c8:	e8 da da ff ff       	call   8004a7 <_panic>
  8029cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029d0:	8b 00                	mov    (%eax),%eax
  8029d2:	85 c0                	test   %eax,%eax
  8029d4:	74 10                	je     8029e6 <alloc_block_NF+0x190>
  8029d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029d9:	8b 00                	mov    (%eax),%eax
  8029db:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029de:	8b 52 04             	mov    0x4(%edx),%edx
  8029e1:	89 50 04             	mov    %edx,0x4(%eax)
  8029e4:	eb 0b                	jmp    8029f1 <alloc_block_NF+0x19b>
  8029e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029e9:	8b 40 04             	mov    0x4(%eax),%eax
  8029ec:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8029f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029f4:	8b 40 04             	mov    0x4(%eax),%eax
  8029f7:	85 c0                	test   %eax,%eax
  8029f9:	74 0f                	je     802a0a <alloc_block_NF+0x1b4>
  8029fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029fe:	8b 40 04             	mov    0x4(%eax),%eax
  802a01:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a04:	8b 12                	mov    (%edx),%edx
  802a06:	89 10                	mov    %edx,(%eax)
  802a08:	eb 0a                	jmp    802a14 <alloc_block_NF+0x1be>
  802a0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a0d:	8b 00                	mov    (%eax),%eax
  802a0f:	a3 48 41 80 00       	mov    %eax,0x804148
  802a14:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a17:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a20:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a27:	a1 54 41 80 00       	mov    0x804154,%eax
  802a2c:	48                   	dec    %eax
  802a2d:	a3 54 41 80 00       	mov    %eax,0x804154
					 return newBlock;
  802a32:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a35:	eb 30                	jmp    802a67 <alloc_block_NF+0x211>

				}
		if(tmp1==FreeMemBlocksList.lh_last)
  802a37:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a3c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802a3f:	75 0a                	jne    802a4b <alloc_block_NF+0x1f5>
			tmp1=FreeMemBlocksList.lh_first;
  802a41:	a1 38 41 80 00       	mov    0x804138,%eax
  802a46:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a49:	eb 08                	jmp    802a53 <alloc_block_NF+0x1fd>
		else
				tmp1=tmp1->prev_next_info.le_next;
  802a4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4e:	8b 00                	mov    (%eax),%eax
  802a50:	89 45 f4             	mov    %eax,-0xc(%ebp)


			}
while(tmp1->sva!=currentSva);
  802a53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a56:	8b 40 08             	mov    0x8(%eax),%eax
  802a59:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802a5c:	0f 85 4d fe ff ff    	jne    8028af <alloc_block_NF+0x59>

			return NULL;
  802a62:	b8 00 00 00 00       	mov    $0x0,%eax

	}
  802a67:	c9                   	leave  
  802a68:	c3                   	ret    

00802a69 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802a69:	55                   	push   %ebp
  802a6a:	89 e5                	mov    %esp,%ebp
  802a6c:	53                   	push   %ebx
  802a6d:	83 ec 14             	sub    $0x14,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	if(FreeMemBlocksList.lh_first==NULL)
  802a70:	a1 38 41 80 00       	mov    0x804138,%eax
  802a75:	85 c0                	test   %eax,%eax
  802a77:	0f 85 86 00 00 00    	jne    802b03 <insert_sorted_with_merge_freeList+0x9a>
	{
		LIST_INIT(&FreeMemBlocksList);
  802a7d:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  802a84:	00 00 00 
  802a87:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  802a8e:	00 00 00 
  802a91:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  802a98:	00 00 00 
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802a9b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a9f:	75 17                	jne    802ab8 <insert_sorted_with_merge_freeList+0x4f>
  802aa1:	83 ec 04             	sub    $0x4,%esp
  802aa4:	68 f0 3e 80 00       	push   $0x803ef0
  802aa9:	68 48 01 00 00       	push   $0x148
  802aae:	68 13 3f 80 00       	push   $0x803f13
  802ab3:	e8 ef d9 ff ff       	call   8004a7 <_panic>
  802ab8:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802abe:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac1:	89 10                	mov    %edx,(%eax)
  802ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac6:	8b 00                	mov    (%eax),%eax
  802ac8:	85 c0                	test   %eax,%eax
  802aca:	74 0d                	je     802ad9 <insert_sorted_with_merge_freeList+0x70>
  802acc:	a1 38 41 80 00       	mov    0x804138,%eax
  802ad1:	8b 55 08             	mov    0x8(%ebp),%edx
  802ad4:	89 50 04             	mov    %edx,0x4(%eax)
  802ad7:	eb 08                	jmp    802ae1 <insert_sorted_with_merge_freeList+0x78>
  802ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  802adc:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae4:	a3 38 41 80 00       	mov    %eax,0x804138
  802ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  802aec:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802af3:	a1 44 41 80 00       	mov    0x804144,%eax
  802af8:	40                   	inc    %eax
  802af9:	a3 44 41 80 00       	mov    %eax,0x804144
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  802afe:	e9 73 07 00 00       	jmp    803276 <insert_sorted_with_merge_freeList+0x80d>
	if(FreeMemBlocksList.lh_first==NULL)
	{
		LIST_INIT(&FreeMemBlocksList);
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva!=(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  802b03:	8b 45 08             	mov    0x8(%ebp),%eax
  802b06:	8b 50 08             	mov    0x8(%eax),%edx
  802b09:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b0e:	8b 40 08             	mov    0x8(%eax),%eax
  802b11:	39 c2                	cmp    %eax,%edx
  802b13:	0f 86 84 00 00 00    	jbe    802b9d <insert_sorted_with_merge_freeList+0x134>
  802b19:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1c:	8b 50 08             	mov    0x8(%eax),%edx
  802b1f:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b24:	8b 48 0c             	mov    0xc(%eax),%ecx
  802b27:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b2c:	8b 40 08             	mov    0x8(%eax),%eax
  802b2f:	01 c8                	add    %ecx,%eax
  802b31:	39 c2                	cmp    %eax,%edx
  802b33:	74 68                	je     802b9d <insert_sorted_with_merge_freeList+0x134>
	{
		LIST_INSERT_TAIL(&FreeMemBlocksList,blockToInsert);
  802b35:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b39:	75 17                	jne    802b52 <insert_sorted_with_merge_freeList+0xe9>
  802b3b:	83 ec 04             	sub    $0x4,%esp
  802b3e:	68 2c 3f 80 00       	push   $0x803f2c
  802b43:	68 4c 01 00 00       	push   $0x14c
  802b48:	68 13 3f 80 00       	push   $0x803f13
  802b4d:	e8 55 d9 ff ff       	call   8004a7 <_panic>
  802b52:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802b58:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5b:	89 50 04             	mov    %edx,0x4(%eax)
  802b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b61:	8b 40 04             	mov    0x4(%eax),%eax
  802b64:	85 c0                	test   %eax,%eax
  802b66:	74 0c                	je     802b74 <insert_sorted_with_merge_freeList+0x10b>
  802b68:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b6d:	8b 55 08             	mov    0x8(%ebp),%edx
  802b70:	89 10                	mov    %edx,(%eax)
  802b72:	eb 08                	jmp    802b7c <insert_sorted_with_merge_freeList+0x113>
  802b74:	8b 45 08             	mov    0x8(%ebp),%eax
  802b77:	a3 38 41 80 00       	mov    %eax,0x804138
  802b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7f:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b84:	8b 45 08             	mov    0x8(%ebp),%eax
  802b87:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b8d:	a1 44 41 80 00       	mov    0x804144,%eax
  802b92:	40                   	inc    %eax
  802b93:	a3 44 41 80 00       	mov    %eax,0x804144
  802b98:	e9 d9 06 00 00       	jmp    803276 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva==(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  802b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba0:	8b 50 08             	mov    0x8(%eax),%edx
  802ba3:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802ba8:	8b 40 08             	mov    0x8(%eax),%eax
  802bab:	39 c2                	cmp    %eax,%edx
  802bad:	0f 86 b5 00 00 00    	jbe    802c68 <insert_sorted_with_merge_freeList+0x1ff>
  802bb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb6:	8b 50 08             	mov    0x8(%eax),%edx
  802bb9:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802bbe:	8b 48 0c             	mov    0xc(%eax),%ecx
  802bc1:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802bc6:	8b 40 08             	mov    0x8(%eax),%eax
  802bc9:	01 c8                	add    %ecx,%eax
  802bcb:	39 c2                	cmp    %eax,%edx
  802bcd:	0f 85 95 00 00 00    	jne    802c68 <insert_sorted_with_merge_freeList+0x1ff>

	{
		FreeMemBlocksList.lh_last->size+=blockToInsert->size;
  802bd3:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802bd8:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802bde:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802be1:	8b 55 08             	mov    0x8(%ebp),%edx
  802be4:	8b 52 0c             	mov    0xc(%edx),%edx
  802be7:	01 ca                	add    %ecx,%edx
  802be9:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802bec:	8b 45 08             	mov    0x8(%ebp),%eax
  802bef:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802c00:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c04:	75 17                	jne    802c1d <insert_sorted_with_merge_freeList+0x1b4>
  802c06:	83 ec 04             	sub    $0x4,%esp
  802c09:	68 f0 3e 80 00       	push   $0x803ef0
  802c0e:	68 54 01 00 00       	push   $0x154
  802c13:	68 13 3f 80 00       	push   $0x803f13
  802c18:	e8 8a d8 ff ff       	call   8004a7 <_panic>
  802c1d:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c23:	8b 45 08             	mov    0x8(%ebp),%eax
  802c26:	89 10                	mov    %edx,(%eax)
  802c28:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2b:	8b 00                	mov    (%eax),%eax
  802c2d:	85 c0                	test   %eax,%eax
  802c2f:	74 0d                	je     802c3e <insert_sorted_with_merge_freeList+0x1d5>
  802c31:	a1 48 41 80 00       	mov    0x804148,%eax
  802c36:	8b 55 08             	mov    0x8(%ebp),%edx
  802c39:	89 50 04             	mov    %edx,0x4(%eax)
  802c3c:	eb 08                	jmp    802c46 <insert_sorted_with_merge_freeList+0x1dd>
  802c3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c41:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c46:	8b 45 08             	mov    0x8(%ebp),%eax
  802c49:	a3 48 41 80 00       	mov    %eax,0x804148
  802c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c51:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c58:	a1 54 41 80 00       	mov    0x804154,%eax
  802c5d:	40                   	inc    %eax
  802c5e:	a3 54 41 80 00       	mov    %eax,0x804154
  802c63:	e9 0e 06 00 00       	jmp    803276 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva==(blockToInsert->sva+blockToInsert->size))
  802c68:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6b:	8b 50 08             	mov    0x8(%eax),%edx
  802c6e:	a1 38 41 80 00       	mov    0x804138,%eax
  802c73:	8b 40 08             	mov    0x8(%eax),%eax
  802c76:	39 c2                	cmp    %eax,%edx
  802c78:	0f 83 c1 00 00 00    	jae    802d3f <insert_sorted_with_merge_freeList+0x2d6>
  802c7e:	a1 38 41 80 00       	mov    0x804138,%eax
  802c83:	8b 50 08             	mov    0x8(%eax),%edx
  802c86:	8b 45 08             	mov    0x8(%ebp),%eax
  802c89:	8b 48 08             	mov    0x8(%eax),%ecx
  802c8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8f:	8b 40 0c             	mov    0xc(%eax),%eax
  802c92:	01 c8                	add    %ecx,%eax
  802c94:	39 c2                	cmp    %eax,%edx
  802c96:	0f 85 a3 00 00 00    	jne    802d3f <insert_sorted_with_merge_freeList+0x2d6>
	{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  802c9c:	a1 38 41 80 00       	mov    0x804138,%eax
  802ca1:	8b 55 08             	mov    0x8(%ebp),%edx
  802ca4:	8b 52 08             	mov    0x8(%edx),%edx
  802ca7:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size+=blockToInsert->size;
  802caa:	a1 38 41 80 00       	mov    0x804138,%eax
  802caf:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802cb5:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802cb8:	8b 55 08             	mov    0x8(%ebp),%edx
  802cbb:	8b 52 0c             	mov    0xc(%edx),%edx
  802cbe:	01 ca                	add    %ecx,%edx
  802cc0:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->sva=0;
  802cc3:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		blockToInsert->size=0;
  802ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)

		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802cd7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cdb:	75 17                	jne    802cf4 <insert_sorted_with_merge_freeList+0x28b>
  802cdd:	83 ec 04             	sub    $0x4,%esp
  802ce0:	68 f0 3e 80 00       	push   $0x803ef0
  802ce5:	68 5d 01 00 00       	push   $0x15d
  802cea:	68 13 3f 80 00       	push   $0x803f13
  802cef:	e8 b3 d7 ff ff       	call   8004a7 <_panic>
  802cf4:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802cfa:	8b 45 08             	mov    0x8(%ebp),%eax
  802cfd:	89 10                	mov    %edx,(%eax)
  802cff:	8b 45 08             	mov    0x8(%ebp),%eax
  802d02:	8b 00                	mov    (%eax),%eax
  802d04:	85 c0                	test   %eax,%eax
  802d06:	74 0d                	je     802d15 <insert_sorted_with_merge_freeList+0x2ac>
  802d08:	a1 48 41 80 00       	mov    0x804148,%eax
  802d0d:	8b 55 08             	mov    0x8(%ebp),%edx
  802d10:	89 50 04             	mov    %edx,0x4(%eax)
  802d13:	eb 08                	jmp    802d1d <insert_sorted_with_merge_freeList+0x2b4>
  802d15:	8b 45 08             	mov    0x8(%ebp),%eax
  802d18:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d20:	a3 48 41 80 00       	mov    %eax,0x804148
  802d25:	8b 45 08             	mov    0x8(%ebp),%eax
  802d28:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d2f:	a1 54 41 80 00       	mov    0x804154,%eax
  802d34:	40                   	inc    %eax
  802d35:	a3 54 41 80 00       	mov    %eax,0x804154
  802d3a:	e9 37 05 00 00       	jmp    803276 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva!=(blockToInsert->sva+blockToInsert->size))
  802d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d42:	8b 50 08             	mov    0x8(%eax),%edx
  802d45:	a1 38 41 80 00       	mov    0x804138,%eax
  802d4a:	8b 40 08             	mov    0x8(%eax),%eax
  802d4d:	39 c2                	cmp    %eax,%edx
  802d4f:	0f 83 82 00 00 00    	jae    802dd7 <insert_sorted_with_merge_freeList+0x36e>
  802d55:	a1 38 41 80 00       	mov    0x804138,%eax
  802d5a:	8b 50 08             	mov    0x8(%eax),%edx
  802d5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d60:	8b 48 08             	mov    0x8(%eax),%ecx
  802d63:	8b 45 08             	mov    0x8(%ebp),%eax
  802d66:	8b 40 0c             	mov    0xc(%eax),%eax
  802d69:	01 c8                	add    %ecx,%eax
  802d6b:	39 c2                	cmp    %eax,%edx
  802d6d:	74 68                	je     802dd7 <insert_sorted_with_merge_freeList+0x36e>

	{
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802d6f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d73:	75 17                	jne    802d8c <insert_sorted_with_merge_freeList+0x323>
  802d75:	83 ec 04             	sub    $0x4,%esp
  802d78:	68 f0 3e 80 00       	push   $0x803ef0
  802d7d:	68 62 01 00 00       	push   $0x162
  802d82:	68 13 3f 80 00       	push   $0x803f13
  802d87:	e8 1b d7 ff ff       	call   8004a7 <_panic>
  802d8c:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802d92:	8b 45 08             	mov    0x8(%ebp),%eax
  802d95:	89 10                	mov    %edx,(%eax)
  802d97:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9a:	8b 00                	mov    (%eax),%eax
  802d9c:	85 c0                	test   %eax,%eax
  802d9e:	74 0d                	je     802dad <insert_sorted_with_merge_freeList+0x344>
  802da0:	a1 38 41 80 00       	mov    0x804138,%eax
  802da5:	8b 55 08             	mov    0x8(%ebp),%edx
  802da8:	89 50 04             	mov    %edx,0x4(%eax)
  802dab:	eb 08                	jmp    802db5 <insert_sorted_with_merge_freeList+0x34c>
  802dad:	8b 45 08             	mov    0x8(%ebp),%eax
  802db0:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802db5:	8b 45 08             	mov    0x8(%ebp),%eax
  802db8:	a3 38 41 80 00       	mov    %eax,0x804138
  802dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dc7:	a1 44 41 80 00       	mov    0x804144,%eax
  802dcc:	40                   	inc    %eax
  802dcd:	a3 44 41 80 00       	mov    %eax,0x804144
  802dd2:	e9 9f 04 00 00       	jmp    803276 <insert_sorted_with_merge_freeList+0x80d>
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
  802dd7:	a1 38 41 80 00       	mov    0x804138,%eax
  802ddc:	8b 00                	mov    (%eax),%eax
  802dde:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  802de1:	e9 84 04 00 00       	jmp    80326a <insert_sorted_with_merge_freeList+0x801>
		{
			if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802de6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de9:	8b 50 08             	mov    0x8(%eax),%edx
  802dec:	8b 45 08             	mov    0x8(%ebp),%eax
  802def:	8b 40 08             	mov    0x8(%eax),%eax
  802df2:	39 c2                	cmp    %eax,%edx
  802df4:	0f 86 a9 00 00 00    	jbe    802ea3 <insert_sorted_with_merge_freeList+0x43a>
  802dfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfd:	8b 50 08             	mov    0x8(%eax),%edx
  802e00:	8b 45 08             	mov    0x8(%ebp),%eax
  802e03:	8b 48 08             	mov    0x8(%eax),%ecx
  802e06:	8b 45 08             	mov    0x8(%ebp),%eax
  802e09:	8b 40 0c             	mov    0xc(%eax),%eax
  802e0c:	01 c8                	add    %ecx,%eax
  802e0e:	39 c2                	cmp    %eax,%edx
  802e10:	0f 84 8d 00 00 00    	je     802ea3 <insert_sorted_with_merge_freeList+0x43a>
  802e16:	8b 45 08             	mov    0x8(%ebp),%eax
  802e19:	8b 50 08             	mov    0x8(%eax),%edx
  802e1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1f:	8b 40 04             	mov    0x4(%eax),%eax
  802e22:	8b 48 08             	mov    0x8(%eax),%ecx
  802e25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e28:	8b 40 04             	mov    0x4(%eax),%eax
  802e2b:	8b 40 0c             	mov    0xc(%eax),%eax
  802e2e:	01 c8                	add    %ecx,%eax
  802e30:	39 c2                	cmp    %eax,%edx
  802e32:	74 6f                	je     802ea3 <insert_sorted_with_merge_freeList+0x43a>
			{
				LIST_INSERT_BEFORE(&FreeMemBlocksList,tmp,blockToInsert);
  802e34:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e38:	74 06                	je     802e40 <insert_sorted_with_merge_freeList+0x3d7>
  802e3a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e3e:	75 17                	jne    802e57 <insert_sorted_with_merge_freeList+0x3ee>
  802e40:	83 ec 04             	sub    $0x4,%esp
  802e43:	68 50 3f 80 00       	push   $0x803f50
  802e48:	68 6b 01 00 00       	push   $0x16b
  802e4d:	68 13 3f 80 00       	push   $0x803f13
  802e52:	e8 50 d6 ff ff       	call   8004a7 <_panic>
  802e57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5a:	8b 50 04             	mov    0x4(%eax),%edx
  802e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e60:	89 50 04             	mov    %edx,0x4(%eax)
  802e63:	8b 45 08             	mov    0x8(%ebp),%eax
  802e66:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e69:	89 10                	mov    %edx,(%eax)
  802e6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6e:	8b 40 04             	mov    0x4(%eax),%eax
  802e71:	85 c0                	test   %eax,%eax
  802e73:	74 0d                	je     802e82 <insert_sorted_with_merge_freeList+0x419>
  802e75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e78:	8b 40 04             	mov    0x4(%eax),%eax
  802e7b:	8b 55 08             	mov    0x8(%ebp),%edx
  802e7e:	89 10                	mov    %edx,(%eax)
  802e80:	eb 08                	jmp    802e8a <insert_sorted_with_merge_freeList+0x421>
  802e82:	8b 45 08             	mov    0x8(%ebp),%eax
  802e85:	a3 38 41 80 00       	mov    %eax,0x804138
  802e8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8d:	8b 55 08             	mov    0x8(%ebp),%edx
  802e90:	89 50 04             	mov    %edx,0x4(%eax)
  802e93:	a1 44 41 80 00       	mov    0x804144,%eax
  802e98:	40                   	inc    %eax
  802e99:	a3 44 41 80 00       	mov    %eax,0x804144
				break;
  802e9e:	e9 d3 03 00 00       	jmp    803276 <insert_sorted_with_merge_freeList+0x80d>
			}// no merge
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802ea3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea6:	8b 50 08             	mov    0x8(%eax),%edx
  802ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  802eac:	8b 40 08             	mov    0x8(%eax),%eax
  802eaf:	39 c2                	cmp    %eax,%edx
  802eb1:	0f 86 da 00 00 00    	jbe    802f91 <insert_sorted_with_merge_freeList+0x528>
  802eb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eba:	8b 50 08             	mov    0x8(%eax),%edx
  802ebd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec0:	8b 48 08             	mov    0x8(%eax),%ecx
  802ec3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec6:	8b 40 0c             	mov    0xc(%eax),%eax
  802ec9:	01 c8                	add    %ecx,%eax
  802ecb:	39 c2                	cmp    %eax,%edx
  802ecd:	0f 85 be 00 00 00    	jne    802f91 <insert_sorted_with_merge_freeList+0x528>
  802ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed6:	8b 50 08             	mov    0x8(%eax),%edx
  802ed9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802edc:	8b 40 04             	mov    0x4(%eax),%eax
  802edf:	8b 48 08             	mov    0x8(%eax),%ecx
  802ee2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee5:	8b 40 04             	mov    0x4(%eax),%eax
  802ee8:	8b 40 0c             	mov    0xc(%eax),%eax
  802eeb:	01 c8                	add    %ecx,%eax
  802eed:	39 c2                	cmp    %eax,%edx
  802eef:	0f 84 9c 00 00 00    	je     802f91 <insert_sorted_with_merge_freeList+0x528>
			{
tmp->sva=blockToInsert->sva;
  802ef5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef8:	8b 50 08             	mov    0x8(%eax),%edx
  802efb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802efe:	89 50 08             	mov    %edx,0x8(%eax)
tmp->size+=blockToInsert->size;
  802f01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f04:	8b 50 0c             	mov    0xc(%eax),%edx
  802f07:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0a:	8b 40 0c             	mov    0xc(%eax),%eax
  802f0d:	01 c2                	add    %eax,%edx
  802f0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f12:	89 50 0c             	mov    %edx,0xc(%eax)
blockToInsert->sva=0;
  802f15:	8b 45 08             	mov    0x8(%ebp),%eax
  802f18:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
blockToInsert->size=0;
  802f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f22:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802f29:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f2d:	75 17                	jne    802f46 <insert_sorted_with_merge_freeList+0x4dd>
  802f2f:	83 ec 04             	sub    $0x4,%esp
  802f32:	68 f0 3e 80 00       	push   $0x803ef0
  802f37:	68 74 01 00 00       	push   $0x174
  802f3c:	68 13 3f 80 00       	push   $0x803f13
  802f41:	e8 61 d5 ff ff       	call   8004a7 <_panic>
  802f46:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4f:	89 10                	mov    %edx,(%eax)
  802f51:	8b 45 08             	mov    0x8(%ebp),%eax
  802f54:	8b 00                	mov    (%eax),%eax
  802f56:	85 c0                	test   %eax,%eax
  802f58:	74 0d                	je     802f67 <insert_sorted_with_merge_freeList+0x4fe>
  802f5a:	a1 48 41 80 00       	mov    0x804148,%eax
  802f5f:	8b 55 08             	mov    0x8(%ebp),%edx
  802f62:	89 50 04             	mov    %edx,0x4(%eax)
  802f65:	eb 08                	jmp    802f6f <insert_sorted_with_merge_freeList+0x506>
  802f67:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f72:	a3 48 41 80 00       	mov    %eax,0x804148
  802f77:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f81:	a1 54 41 80 00       	mov    0x804154,%eax
  802f86:	40                   	inc    %eax
  802f87:	a3 54 41 80 00       	mov    %eax,0x804154
break;
  802f8c:	e9 e5 02 00 00       	jmp    803276 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with the next
			else if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802f91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f94:	8b 50 08             	mov    0x8(%eax),%edx
  802f97:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9a:	8b 40 08             	mov    0x8(%eax),%eax
  802f9d:	39 c2                	cmp    %eax,%edx
  802f9f:	0f 86 d7 00 00 00    	jbe    80307c <insert_sorted_with_merge_freeList+0x613>
  802fa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa8:	8b 50 08             	mov    0x8(%eax),%edx
  802fab:	8b 45 08             	mov    0x8(%ebp),%eax
  802fae:	8b 48 08             	mov    0x8(%eax),%ecx
  802fb1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb4:	8b 40 0c             	mov    0xc(%eax),%eax
  802fb7:	01 c8                	add    %ecx,%eax
  802fb9:	39 c2                	cmp    %eax,%edx
  802fbb:	0f 84 bb 00 00 00    	je     80307c <insert_sorted_with_merge_freeList+0x613>
  802fc1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc4:	8b 50 08             	mov    0x8(%eax),%edx
  802fc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fca:	8b 40 04             	mov    0x4(%eax),%eax
  802fcd:	8b 48 08             	mov    0x8(%eax),%ecx
  802fd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd3:	8b 40 04             	mov    0x4(%eax),%eax
  802fd6:	8b 40 0c             	mov    0xc(%eax),%eax
  802fd9:	01 c8                	add    %ecx,%eax
  802fdb:	39 c2                	cmp    %eax,%edx
  802fdd:	0f 85 99 00 00 00    	jne    80307c <insert_sorted_with_merge_freeList+0x613>
			{
				struct MemBlock *ptr=LIST_PREV(tmp);
  802fe3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe6:	8b 40 04             	mov    0x4(%eax),%eax
  802fe9:	89 45 f0             	mov    %eax,-0x10(%ebp)
				ptr->size+=blockToInsert->size;
  802fec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fef:	8b 50 0c             	mov    0xc(%eax),%edx
  802ff2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff5:	8b 40 0c             	mov    0xc(%eax),%eax
  802ff8:	01 c2                	add    %eax,%edx
  802ffa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ffd:	89 50 0c             	mov    %edx,0xc(%eax)
				blockToInsert->sva=0;
  803000:	8b 45 08             	mov    0x8(%ebp),%eax
  803003:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size =0;
  80300a:	8b 45 08             	mov    0x8(%ebp),%eax
  80300d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803014:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803018:	75 17                	jne    803031 <insert_sorted_with_merge_freeList+0x5c8>
  80301a:	83 ec 04             	sub    $0x4,%esp
  80301d:	68 f0 3e 80 00       	push   $0x803ef0
  803022:	68 7d 01 00 00       	push   $0x17d
  803027:	68 13 3f 80 00       	push   $0x803f13
  80302c:	e8 76 d4 ff ff       	call   8004a7 <_panic>
  803031:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803037:	8b 45 08             	mov    0x8(%ebp),%eax
  80303a:	89 10                	mov    %edx,(%eax)
  80303c:	8b 45 08             	mov    0x8(%ebp),%eax
  80303f:	8b 00                	mov    (%eax),%eax
  803041:	85 c0                	test   %eax,%eax
  803043:	74 0d                	je     803052 <insert_sorted_with_merge_freeList+0x5e9>
  803045:	a1 48 41 80 00       	mov    0x804148,%eax
  80304a:	8b 55 08             	mov    0x8(%ebp),%edx
  80304d:	89 50 04             	mov    %edx,0x4(%eax)
  803050:	eb 08                	jmp    80305a <insert_sorted_with_merge_freeList+0x5f1>
  803052:	8b 45 08             	mov    0x8(%ebp),%eax
  803055:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80305a:	8b 45 08             	mov    0x8(%ebp),%eax
  80305d:	a3 48 41 80 00       	mov    %eax,0x804148
  803062:	8b 45 08             	mov    0x8(%ebp),%eax
  803065:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80306c:	a1 54 41 80 00       	mov    0x804154,%eax
  803071:	40                   	inc    %eax
  803072:	a3 54 41 80 00       	mov    %eax,0x804154
break;
  803077:	e9 fa 01 00 00       	jmp    803276 <insert_sorted_with_merge_freeList+0x80d>
			}// merge with previous
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  80307c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80307f:	8b 50 08             	mov    0x8(%eax),%edx
  803082:	8b 45 08             	mov    0x8(%ebp),%eax
  803085:	8b 40 08             	mov    0x8(%eax),%eax
  803088:	39 c2                	cmp    %eax,%edx
  80308a:	0f 86 d2 01 00 00    	jbe    803262 <insert_sorted_with_merge_freeList+0x7f9>
  803090:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803093:	8b 50 08             	mov    0x8(%eax),%edx
  803096:	8b 45 08             	mov    0x8(%ebp),%eax
  803099:	8b 48 08             	mov    0x8(%eax),%ecx
  80309c:	8b 45 08             	mov    0x8(%ebp),%eax
  80309f:	8b 40 0c             	mov    0xc(%eax),%eax
  8030a2:	01 c8                	add    %ecx,%eax
  8030a4:	39 c2                	cmp    %eax,%edx
  8030a6:	0f 85 b6 01 00 00    	jne    803262 <insert_sorted_with_merge_freeList+0x7f9>
  8030ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8030af:	8b 50 08             	mov    0x8(%eax),%edx
  8030b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b5:	8b 40 04             	mov    0x4(%eax),%eax
  8030b8:	8b 48 08             	mov    0x8(%eax),%ecx
  8030bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030be:	8b 40 04             	mov    0x4(%eax),%eax
  8030c1:	8b 40 0c             	mov    0xc(%eax),%eax
  8030c4:	01 c8                	add    %ecx,%eax
  8030c6:	39 c2                	cmp    %eax,%edx
  8030c8:	0f 85 94 01 00 00    	jne    803262 <insert_sorted_with_merge_freeList+0x7f9>
			{

				LIST_PREV(tmp)->size+=blockToInsert->size+tmp->size;
  8030ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d1:	8b 40 04             	mov    0x4(%eax),%eax
  8030d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030d7:	8b 52 04             	mov    0x4(%edx),%edx
  8030da:	8b 4a 0c             	mov    0xc(%edx),%ecx
  8030dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8030e0:	8b 5a 0c             	mov    0xc(%edx),%ebx
  8030e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030e6:	8b 52 0c             	mov    0xc(%edx),%edx
  8030e9:	01 da                	add    %ebx,%edx
  8030eb:	01 ca                	add    %ecx,%edx
  8030ed:	89 50 0c             	mov    %edx,0xc(%eax)
				tmp->size=0;
  8030f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				tmp->sva=0;
  8030fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030fd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  803104:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803108:	75 17                	jne    803121 <insert_sorted_with_merge_freeList+0x6b8>
  80310a:	83 ec 04             	sub    $0x4,%esp
  80310d:	68 85 3f 80 00       	push   $0x803f85
  803112:	68 86 01 00 00       	push   $0x186
  803117:	68 13 3f 80 00       	push   $0x803f13
  80311c:	e8 86 d3 ff ff       	call   8004a7 <_panic>
  803121:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803124:	8b 00                	mov    (%eax),%eax
  803126:	85 c0                	test   %eax,%eax
  803128:	74 10                	je     80313a <insert_sorted_with_merge_freeList+0x6d1>
  80312a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80312d:	8b 00                	mov    (%eax),%eax
  80312f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803132:	8b 52 04             	mov    0x4(%edx),%edx
  803135:	89 50 04             	mov    %edx,0x4(%eax)
  803138:	eb 0b                	jmp    803145 <insert_sorted_with_merge_freeList+0x6dc>
  80313a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80313d:	8b 40 04             	mov    0x4(%eax),%eax
  803140:	a3 3c 41 80 00       	mov    %eax,0x80413c
  803145:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803148:	8b 40 04             	mov    0x4(%eax),%eax
  80314b:	85 c0                	test   %eax,%eax
  80314d:	74 0f                	je     80315e <insert_sorted_with_merge_freeList+0x6f5>
  80314f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803152:	8b 40 04             	mov    0x4(%eax),%eax
  803155:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803158:	8b 12                	mov    (%edx),%edx
  80315a:	89 10                	mov    %edx,(%eax)
  80315c:	eb 0a                	jmp    803168 <insert_sorted_with_merge_freeList+0x6ff>
  80315e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803161:	8b 00                	mov    (%eax),%eax
  803163:	a3 38 41 80 00       	mov    %eax,0x804138
  803168:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80316b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803171:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803174:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80317b:	a1 44 41 80 00       	mov    0x804144,%eax
  803180:	48                   	dec    %eax
  803181:	a3 44 41 80 00       	mov    %eax,0x804144
				LIST_INSERT_HEAD(&AvailableMemBlocksList,tmp);
  803186:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80318a:	75 17                	jne    8031a3 <insert_sorted_with_merge_freeList+0x73a>
  80318c:	83 ec 04             	sub    $0x4,%esp
  80318f:	68 f0 3e 80 00       	push   $0x803ef0
  803194:	68 87 01 00 00       	push   $0x187
  803199:	68 13 3f 80 00       	push   $0x803f13
  80319e:	e8 04 d3 ff ff       	call   8004a7 <_panic>
  8031a3:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8031a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ac:	89 10                	mov    %edx,(%eax)
  8031ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b1:	8b 00                	mov    (%eax),%eax
  8031b3:	85 c0                	test   %eax,%eax
  8031b5:	74 0d                	je     8031c4 <insert_sorted_with_merge_freeList+0x75b>
  8031b7:	a1 48 41 80 00       	mov    0x804148,%eax
  8031bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031bf:	89 50 04             	mov    %edx,0x4(%eax)
  8031c2:	eb 08                	jmp    8031cc <insert_sorted_with_merge_freeList+0x763>
  8031c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c7:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8031cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031cf:	a3 48 41 80 00       	mov    %eax,0x804148
  8031d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031de:	a1 54 41 80 00       	mov    0x804154,%eax
  8031e3:	40                   	inc    %eax
  8031e4:	a3 54 41 80 00       	mov    %eax,0x804154
				blockToInsert->sva=0;
  8031e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ec:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size=0;
  8031f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8031fd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803201:	75 17                	jne    80321a <insert_sorted_with_merge_freeList+0x7b1>
  803203:	83 ec 04             	sub    $0x4,%esp
  803206:	68 f0 3e 80 00       	push   $0x803ef0
  80320b:	68 8a 01 00 00       	push   $0x18a
  803210:	68 13 3f 80 00       	push   $0x803f13
  803215:	e8 8d d2 ff ff       	call   8004a7 <_panic>
  80321a:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803220:	8b 45 08             	mov    0x8(%ebp),%eax
  803223:	89 10                	mov    %edx,(%eax)
  803225:	8b 45 08             	mov    0x8(%ebp),%eax
  803228:	8b 00                	mov    (%eax),%eax
  80322a:	85 c0                	test   %eax,%eax
  80322c:	74 0d                	je     80323b <insert_sorted_with_merge_freeList+0x7d2>
  80322e:	a1 48 41 80 00       	mov    0x804148,%eax
  803233:	8b 55 08             	mov    0x8(%ebp),%edx
  803236:	89 50 04             	mov    %edx,0x4(%eax)
  803239:	eb 08                	jmp    803243 <insert_sorted_with_merge_freeList+0x7da>
  80323b:	8b 45 08             	mov    0x8(%ebp),%eax
  80323e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803243:	8b 45 08             	mov    0x8(%ebp),%eax
  803246:	a3 48 41 80 00       	mov    %eax,0x804148
  80324b:	8b 45 08             	mov    0x8(%ebp),%eax
  80324e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803255:	a1 54 41 80 00       	mov    0x804154,%eax
  80325a:	40                   	inc    %eax
  80325b:	a3 54 41 80 00       	mov    %eax,0x804154
				break;
  803260:	eb 14                	jmp    803276 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with next and previous
			tmp=tmp->prev_next_info.le_next;
  803262:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803265:	8b 00                	mov    (%eax),%eax
  803267:	89 45 f4             	mov    %eax,-0xc(%ebp)
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
		while(tmp!=NULL)
  80326a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80326e:	0f 85 72 fb ff ff    	jne    802de6 <insert_sorted_with_merge_freeList+0x37d>
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  803274:	eb 00                	jmp    803276 <insert_sorted_with_merge_freeList+0x80d>
  803276:	90                   	nop
  803277:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80327a:	c9                   	leave  
  80327b:	c3                   	ret    

0080327c <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  80327c:	55                   	push   %ebp
  80327d:	89 e5                	mov    %esp,%ebp
  80327f:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803282:	8b 55 08             	mov    0x8(%ebp),%edx
  803285:	89 d0                	mov    %edx,%eax
  803287:	c1 e0 02             	shl    $0x2,%eax
  80328a:	01 d0                	add    %edx,%eax
  80328c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803293:	01 d0                	add    %edx,%eax
  803295:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80329c:	01 d0                	add    %edx,%eax
  80329e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8032a5:	01 d0                	add    %edx,%eax
  8032a7:	c1 e0 04             	shl    $0x4,%eax
  8032aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8032ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8032b4:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8032b7:	83 ec 0c             	sub    $0xc,%esp
  8032ba:	50                   	push   %eax
  8032bb:	e8 7b eb ff ff       	call   801e3b <sys_get_virtual_time>
  8032c0:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8032c3:	eb 41                	jmp    803306 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8032c5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8032c8:	83 ec 0c             	sub    $0xc,%esp
  8032cb:	50                   	push   %eax
  8032cc:	e8 6a eb ff ff       	call   801e3b <sys_get_virtual_time>
  8032d1:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8032d4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8032d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032da:	29 c2                	sub    %eax,%edx
  8032dc:	89 d0                	mov    %edx,%eax
  8032de:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8032e1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8032e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032e7:	89 d1                	mov    %edx,%ecx
  8032e9:	29 c1                	sub    %eax,%ecx
  8032eb:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8032ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032f1:	39 c2                	cmp    %eax,%edx
  8032f3:	0f 97 c0             	seta   %al
  8032f6:	0f b6 c0             	movzbl %al,%eax
  8032f9:	29 c1                	sub    %eax,%ecx
  8032fb:	89 c8                	mov    %ecx,%eax
  8032fd:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803300:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803303:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803306:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803309:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80330c:	72 b7                	jb     8032c5 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  80330e:	90                   	nop
  80330f:	c9                   	leave  
  803310:	c3                   	ret    

00803311 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803311:	55                   	push   %ebp
  803312:	89 e5                	mov    %esp,%ebp
  803314:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803317:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  80331e:	eb 03                	jmp    803323 <busy_wait+0x12>
  803320:	ff 45 fc             	incl   -0x4(%ebp)
  803323:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803326:	3b 45 08             	cmp    0x8(%ebp),%eax
  803329:	72 f5                	jb     803320 <busy_wait+0xf>
	return i;
  80332b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80332e:	c9                   	leave  
  80332f:	c3                   	ret    

00803330 <__udivdi3>:
  803330:	55                   	push   %ebp
  803331:	57                   	push   %edi
  803332:	56                   	push   %esi
  803333:	53                   	push   %ebx
  803334:	83 ec 1c             	sub    $0x1c,%esp
  803337:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80333b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80333f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803343:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803347:	89 ca                	mov    %ecx,%edx
  803349:	89 f8                	mov    %edi,%eax
  80334b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80334f:	85 f6                	test   %esi,%esi
  803351:	75 2d                	jne    803380 <__udivdi3+0x50>
  803353:	39 cf                	cmp    %ecx,%edi
  803355:	77 65                	ja     8033bc <__udivdi3+0x8c>
  803357:	89 fd                	mov    %edi,%ebp
  803359:	85 ff                	test   %edi,%edi
  80335b:	75 0b                	jne    803368 <__udivdi3+0x38>
  80335d:	b8 01 00 00 00       	mov    $0x1,%eax
  803362:	31 d2                	xor    %edx,%edx
  803364:	f7 f7                	div    %edi
  803366:	89 c5                	mov    %eax,%ebp
  803368:	31 d2                	xor    %edx,%edx
  80336a:	89 c8                	mov    %ecx,%eax
  80336c:	f7 f5                	div    %ebp
  80336e:	89 c1                	mov    %eax,%ecx
  803370:	89 d8                	mov    %ebx,%eax
  803372:	f7 f5                	div    %ebp
  803374:	89 cf                	mov    %ecx,%edi
  803376:	89 fa                	mov    %edi,%edx
  803378:	83 c4 1c             	add    $0x1c,%esp
  80337b:	5b                   	pop    %ebx
  80337c:	5e                   	pop    %esi
  80337d:	5f                   	pop    %edi
  80337e:	5d                   	pop    %ebp
  80337f:	c3                   	ret    
  803380:	39 ce                	cmp    %ecx,%esi
  803382:	77 28                	ja     8033ac <__udivdi3+0x7c>
  803384:	0f bd fe             	bsr    %esi,%edi
  803387:	83 f7 1f             	xor    $0x1f,%edi
  80338a:	75 40                	jne    8033cc <__udivdi3+0x9c>
  80338c:	39 ce                	cmp    %ecx,%esi
  80338e:	72 0a                	jb     80339a <__udivdi3+0x6a>
  803390:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803394:	0f 87 9e 00 00 00    	ja     803438 <__udivdi3+0x108>
  80339a:	b8 01 00 00 00       	mov    $0x1,%eax
  80339f:	89 fa                	mov    %edi,%edx
  8033a1:	83 c4 1c             	add    $0x1c,%esp
  8033a4:	5b                   	pop    %ebx
  8033a5:	5e                   	pop    %esi
  8033a6:	5f                   	pop    %edi
  8033a7:	5d                   	pop    %ebp
  8033a8:	c3                   	ret    
  8033a9:	8d 76 00             	lea    0x0(%esi),%esi
  8033ac:	31 ff                	xor    %edi,%edi
  8033ae:	31 c0                	xor    %eax,%eax
  8033b0:	89 fa                	mov    %edi,%edx
  8033b2:	83 c4 1c             	add    $0x1c,%esp
  8033b5:	5b                   	pop    %ebx
  8033b6:	5e                   	pop    %esi
  8033b7:	5f                   	pop    %edi
  8033b8:	5d                   	pop    %ebp
  8033b9:	c3                   	ret    
  8033ba:	66 90                	xchg   %ax,%ax
  8033bc:	89 d8                	mov    %ebx,%eax
  8033be:	f7 f7                	div    %edi
  8033c0:	31 ff                	xor    %edi,%edi
  8033c2:	89 fa                	mov    %edi,%edx
  8033c4:	83 c4 1c             	add    $0x1c,%esp
  8033c7:	5b                   	pop    %ebx
  8033c8:	5e                   	pop    %esi
  8033c9:	5f                   	pop    %edi
  8033ca:	5d                   	pop    %ebp
  8033cb:	c3                   	ret    
  8033cc:	bd 20 00 00 00       	mov    $0x20,%ebp
  8033d1:	89 eb                	mov    %ebp,%ebx
  8033d3:	29 fb                	sub    %edi,%ebx
  8033d5:	89 f9                	mov    %edi,%ecx
  8033d7:	d3 e6                	shl    %cl,%esi
  8033d9:	89 c5                	mov    %eax,%ebp
  8033db:	88 d9                	mov    %bl,%cl
  8033dd:	d3 ed                	shr    %cl,%ebp
  8033df:	89 e9                	mov    %ebp,%ecx
  8033e1:	09 f1                	or     %esi,%ecx
  8033e3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8033e7:	89 f9                	mov    %edi,%ecx
  8033e9:	d3 e0                	shl    %cl,%eax
  8033eb:	89 c5                	mov    %eax,%ebp
  8033ed:	89 d6                	mov    %edx,%esi
  8033ef:	88 d9                	mov    %bl,%cl
  8033f1:	d3 ee                	shr    %cl,%esi
  8033f3:	89 f9                	mov    %edi,%ecx
  8033f5:	d3 e2                	shl    %cl,%edx
  8033f7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8033fb:	88 d9                	mov    %bl,%cl
  8033fd:	d3 e8                	shr    %cl,%eax
  8033ff:	09 c2                	or     %eax,%edx
  803401:	89 d0                	mov    %edx,%eax
  803403:	89 f2                	mov    %esi,%edx
  803405:	f7 74 24 0c          	divl   0xc(%esp)
  803409:	89 d6                	mov    %edx,%esi
  80340b:	89 c3                	mov    %eax,%ebx
  80340d:	f7 e5                	mul    %ebp
  80340f:	39 d6                	cmp    %edx,%esi
  803411:	72 19                	jb     80342c <__udivdi3+0xfc>
  803413:	74 0b                	je     803420 <__udivdi3+0xf0>
  803415:	89 d8                	mov    %ebx,%eax
  803417:	31 ff                	xor    %edi,%edi
  803419:	e9 58 ff ff ff       	jmp    803376 <__udivdi3+0x46>
  80341e:	66 90                	xchg   %ax,%ax
  803420:	8b 54 24 08          	mov    0x8(%esp),%edx
  803424:	89 f9                	mov    %edi,%ecx
  803426:	d3 e2                	shl    %cl,%edx
  803428:	39 c2                	cmp    %eax,%edx
  80342a:	73 e9                	jae    803415 <__udivdi3+0xe5>
  80342c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80342f:	31 ff                	xor    %edi,%edi
  803431:	e9 40 ff ff ff       	jmp    803376 <__udivdi3+0x46>
  803436:	66 90                	xchg   %ax,%ax
  803438:	31 c0                	xor    %eax,%eax
  80343a:	e9 37 ff ff ff       	jmp    803376 <__udivdi3+0x46>
  80343f:	90                   	nop

00803440 <__umoddi3>:
  803440:	55                   	push   %ebp
  803441:	57                   	push   %edi
  803442:	56                   	push   %esi
  803443:	53                   	push   %ebx
  803444:	83 ec 1c             	sub    $0x1c,%esp
  803447:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80344b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80344f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803453:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803457:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80345b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80345f:	89 f3                	mov    %esi,%ebx
  803461:	89 fa                	mov    %edi,%edx
  803463:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803467:	89 34 24             	mov    %esi,(%esp)
  80346a:	85 c0                	test   %eax,%eax
  80346c:	75 1a                	jne    803488 <__umoddi3+0x48>
  80346e:	39 f7                	cmp    %esi,%edi
  803470:	0f 86 a2 00 00 00    	jbe    803518 <__umoddi3+0xd8>
  803476:	89 c8                	mov    %ecx,%eax
  803478:	89 f2                	mov    %esi,%edx
  80347a:	f7 f7                	div    %edi
  80347c:	89 d0                	mov    %edx,%eax
  80347e:	31 d2                	xor    %edx,%edx
  803480:	83 c4 1c             	add    $0x1c,%esp
  803483:	5b                   	pop    %ebx
  803484:	5e                   	pop    %esi
  803485:	5f                   	pop    %edi
  803486:	5d                   	pop    %ebp
  803487:	c3                   	ret    
  803488:	39 f0                	cmp    %esi,%eax
  80348a:	0f 87 ac 00 00 00    	ja     80353c <__umoddi3+0xfc>
  803490:	0f bd e8             	bsr    %eax,%ebp
  803493:	83 f5 1f             	xor    $0x1f,%ebp
  803496:	0f 84 ac 00 00 00    	je     803548 <__umoddi3+0x108>
  80349c:	bf 20 00 00 00       	mov    $0x20,%edi
  8034a1:	29 ef                	sub    %ebp,%edi
  8034a3:	89 fe                	mov    %edi,%esi
  8034a5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8034a9:	89 e9                	mov    %ebp,%ecx
  8034ab:	d3 e0                	shl    %cl,%eax
  8034ad:	89 d7                	mov    %edx,%edi
  8034af:	89 f1                	mov    %esi,%ecx
  8034b1:	d3 ef                	shr    %cl,%edi
  8034b3:	09 c7                	or     %eax,%edi
  8034b5:	89 e9                	mov    %ebp,%ecx
  8034b7:	d3 e2                	shl    %cl,%edx
  8034b9:	89 14 24             	mov    %edx,(%esp)
  8034bc:	89 d8                	mov    %ebx,%eax
  8034be:	d3 e0                	shl    %cl,%eax
  8034c0:	89 c2                	mov    %eax,%edx
  8034c2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034c6:	d3 e0                	shl    %cl,%eax
  8034c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8034cc:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034d0:	89 f1                	mov    %esi,%ecx
  8034d2:	d3 e8                	shr    %cl,%eax
  8034d4:	09 d0                	or     %edx,%eax
  8034d6:	d3 eb                	shr    %cl,%ebx
  8034d8:	89 da                	mov    %ebx,%edx
  8034da:	f7 f7                	div    %edi
  8034dc:	89 d3                	mov    %edx,%ebx
  8034de:	f7 24 24             	mull   (%esp)
  8034e1:	89 c6                	mov    %eax,%esi
  8034e3:	89 d1                	mov    %edx,%ecx
  8034e5:	39 d3                	cmp    %edx,%ebx
  8034e7:	0f 82 87 00 00 00    	jb     803574 <__umoddi3+0x134>
  8034ed:	0f 84 91 00 00 00    	je     803584 <__umoddi3+0x144>
  8034f3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8034f7:	29 f2                	sub    %esi,%edx
  8034f9:	19 cb                	sbb    %ecx,%ebx
  8034fb:	89 d8                	mov    %ebx,%eax
  8034fd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803501:	d3 e0                	shl    %cl,%eax
  803503:	89 e9                	mov    %ebp,%ecx
  803505:	d3 ea                	shr    %cl,%edx
  803507:	09 d0                	or     %edx,%eax
  803509:	89 e9                	mov    %ebp,%ecx
  80350b:	d3 eb                	shr    %cl,%ebx
  80350d:	89 da                	mov    %ebx,%edx
  80350f:	83 c4 1c             	add    $0x1c,%esp
  803512:	5b                   	pop    %ebx
  803513:	5e                   	pop    %esi
  803514:	5f                   	pop    %edi
  803515:	5d                   	pop    %ebp
  803516:	c3                   	ret    
  803517:	90                   	nop
  803518:	89 fd                	mov    %edi,%ebp
  80351a:	85 ff                	test   %edi,%edi
  80351c:	75 0b                	jne    803529 <__umoddi3+0xe9>
  80351e:	b8 01 00 00 00       	mov    $0x1,%eax
  803523:	31 d2                	xor    %edx,%edx
  803525:	f7 f7                	div    %edi
  803527:	89 c5                	mov    %eax,%ebp
  803529:	89 f0                	mov    %esi,%eax
  80352b:	31 d2                	xor    %edx,%edx
  80352d:	f7 f5                	div    %ebp
  80352f:	89 c8                	mov    %ecx,%eax
  803531:	f7 f5                	div    %ebp
  803533:	89 d0                	mov    %edx,%eax
  803535:	e9 44 ff ff ff       	jmp    80347e <__umoddi3+0x3e>
  80353a:	66 90                	xchg   %ax,%ax
  80353c:	89 c8                	mov    %ecx,%eax
  80353e:	89 f2                	mov    %esi,%edx
  803540:	83 c4 1c             	add    $0x1c,%esp
  803543:	5b                   	pop    %ebx
  803544:	5e                   	pop    %esi
  803545:	5f                   	pop    %edi
  803546:	5d                   	pop    %ebp
  803547:	c3                   	ret    
  803548:	3b 04 24             	cmp    (%esp),%eax
  80354b:	72 06                	jb     803553 <__umoddi3+0x113>
  80354d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803551:	77 0f                	ja     803562 <__umoddi3+0x122>
  803553:	89 f2                	mov    %esi,%edx
  803555:	29 f9                	sub    %edi,%ecx
  803557:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80355b:	89 14 24             	mov    %edx,(%esp)
  80355e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803562:	8b 44 24 04          	mov    0x4(%esp),%eax
  803566:	8b 14 24             	mov    (%esp),%edx
  803569:	83 c4 1c             	add    $0x1c,%esp
  80356c:	5b                   	pop    %ebx
  80356d:	5e                   	pop    %esi
  80356e:	5f                   	pop    %edi
  80356f:	5d                   	pop    %ebp
  803570:	c3                   	ret    
  803571:	8d 76 00             	lea    0x0(%esi),%esi
  803574:	2b 04 24             	sub    (%esp),%eax
  803577:	19 fa                	sbb    %edi,%edx
  803579:	89 d1                	mov    %edx,%ecx
  80357b:	89 c6                	mov    %eax,%esi
  80357d:	e9 71 ff ff ff       	jmp    8034f3 <__umoddi3+0xb3>
  803582:	66 90                	xchg   %ax,%ax
  803584:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803588:	72 ea                	jb     803574 <__umoddi3+0x134>
  80358a:	89 d9                	mov    %ebx,%ecx
  80358c:	e9 62 ff ff ff       	jmp    8034f3 <__umoddi3+0xb3>
