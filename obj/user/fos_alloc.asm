
obj/user/fos_alloc:     file format elf32-i386


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
  800031:	e8 02 01 00 00       	call   800138 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>


void _main(void)
{	
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp
	//uint32 size = 2*1024*1024 +120*4096+1;
	//uint32 size = 1*1024*1024 + 256*1024;
	//uint32 size = 1*1024*1024;
	uint32 size = 100;
  80003e:	c7 45 f0 64 00 00 00 	movl   $0x64,-0x10(%ebp)

	unsigned char *x = malloc(sizeof(unsigned char)*size) ;
  800045:	83 ec 0c             	sub    $0xc,%esp
  800048:	ff 75 f0             	pushl  -0x10(%ebp)
  80004b:	e8 48 12 00 00       	call   801298 <malloc>
  800050:	83 c4 10             	add    $0x10,%esp
  800053:	89 45 ec             	mov    %eax,-0x14(%ebp)
	atomic_cprintf("x allocated at %x\n",x);
  800056:	83 ec 08             	sub    $0x8,%esp
  800059:	ff 75 ec             	pushl  -0x14(%ebp)
  80005c:	68 c0 32 80 00       	push   $0x8032c0
  800061:	e8 0f 03 00 00       	call   800375 <atomic_cprintf>
  800066:	83 c4 10             	add    $0x10,%esp

	//unsigned char *z = malloc(sizeof(unsigned char)*size) ;
	//cprintf("z allocated at %x\n",z);
	
	int i ;
	for (i = 0 ; i < size ; i++)
  800069:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800070:	eb 20                	jmp    800092 <_main+0x5a>
	{
		x[i] = i%256 ;
  800072:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800075:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800078:	01 c2                	add    %eax,%edx
  80007a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80007d:	25 ff 00 00 80       	and    $0x800000ff,%eax
  800082:	85 c0                	test   %eax,%eax
  800084:	79 07                	jns    80008d <_main+0x55>
  800086:	48                   	dec    %eax
  800087:	0d 00 ff ff ff       	or     $0xffffff00,%eax
  80008c:	40                   	inc    %eax
  80008d:	88 02                	mov    %al,(%edx)

	//unsigned char *z = malloc(sizeof(unsigned char)*size) ;
	//cprintf("z allocated at %x\n",z);
	
	int i ;
	for (i = 0 ; i < size ; i++)
  80008f:	ff 45 f4             	incl   -0xc(%ebp)
  800092:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800095:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800098:	72 d8                	jb     800072 <_main+0x3a>
		////z[i] = (int)(x[i]  * y[i]);
		////z[i] = i%256;
	}

	
	for (i = size-7 ; i < size ; i++)
  80009a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80009d:	83 e8 07             	sub    $0x7,%eax
  8000a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8000a3:	eb 24                	jmp    8000c9 <_main+0x91>
		atomic_cprintf("x[%d] = %d\n",i, x[i]);
  8000a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000ab:	01 d0                	add    %edx,%eax
  8000ad:	8a 00                	mov    (%eax),%al
  8000af:	0f b6 c0             	movzbl %al,%eax
  8000b2:	83 ec 04             	sub    $0x4,%esp
  8000b5:	50                   	push   %eax
  8000b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8000b9:	68 d3 32 80 00       	push   $0x8032d3
  8000be:	e8 b2 02 00 00       	call   800375 <atomic_cprintf>
  8000c3:	83 c4 10             	add    $0x10,%esp
		////z[i] = (int)(x[i]  * y[i]);
		////z[i] = i%256;
	}

	
	for (i = size-7 ; i < size ; i++)
  8000c6:	ff 45 f4             	incl   -0xc(%ebp)
  8000c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000cc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8000cf:	72 d4                	jb     8000a5 <_main+0x6d>
		atomic_cprintf("x[%d] = %d\n",i, x[i]);
	
	free(x);
  8000d1:	83 ec 0c             	sub    $0xc,%esp
  8000d4:	ff 75 ec             	pushl  -0x14(%ebp)
  8000d7:	e8 47 12 00 00       	call   801323 <free>
  8000dc:	83 c4 10             	add    $0x10,%esp

	x = malloc(sizeof(unsigned char)*size) ;
  8000df:	83 ec 0c             	sub    $0xc,%esp
  8000e2:	ff 75 f0             	pushl  -0x10(%ebp)
  8000e5:	e8 ae 11 00 00       	call   801298 <malloc>
  8000ea:	83 c4 10             	add    $0x10,%esp
  8000ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
	
	for (i = size-7 ; i < size ; i++)
  8000f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000f3:	83 e8 07             	sub    $0x7,%eax
  8000f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8000f9:	eb 24                	jmp    80011f <_main+0xe7>
	{
		atomic_cprintf("x[%d] = %d\n",i,x[i]);
  8000fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800101:	01 d0                	add    %edx,%eax
  800103:	8a 00                	mov    (%eax),%al
  800105:	0f b6 c0             	movzbl %al,%eax
  800108:	83 ec 04             	sub    $0x4,%esp
  80010b:	50                   	push   %eax
  80010c:	ff 75 f4             	pushl  -0xc(%ebp)
  80010f:	68 d3 32 80 00       	push   $0x8032d3
  800114:	e8 5c 02 00 00       	call   800375 <atomic_cprintf>
  800119:	83 c4 10             	add    $0x10,%esp
	
	free(x);

	x = malloc(sizeof(unsigned char)*size) ;
	
	for (i = size-7 ; i < size ; i++)
  80011c:	ff 45 f4             	incl   -0xc(%ebp)
  80011f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800122:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800125:	72 d4                	jb     8000fb <_main+0xc3>
	{
		atomic_cprintf("x[%d] = %d\n",i,x[i]);
	}

	free(x);
  800127:	83 ec 0c             	sub    $0xc,%esp
  80012a:	ff 75 ec             	pushl  -0x14(%ebp)
  80012d:	e8 f1 11 00 00       	call   801323 <free>
  800132:	83 c4 10             	add    $0x10,%esp
	
	return;	
  800135:	90                   	nop
}
  800136:	c9                   	leave  
  800137:	c3                   	ret    

00800138 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800138:	55                   	push   %ebp
  800139:	89 e5                	mov    %esp,%ebp
  80013b:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80013e:	e8 99 18 00 00       	call   8019dc <sys_getenvindex>
  800143:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800146:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800149:	89 d0                	mov    %edx,%eax
  80014b:	c1 e0 03             	shl    $0x3,%eax
  80014e:	01 d0                	add    %edx,%eax
  800150:	01 c0                	add    %eax,%eax
  800152:	01 d0                	add    %edx,%eax
  800154:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80015b:	01 d0                	add    %edx,%eax
  80015d:	c1 e0 04             	shl    $0x4,%eax
  800160:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800165:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80016a:	a1 20 40 80 00       	mov    0x804020,%eax
  80016f:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800175:	84 c0                	test   %al,%al
  800177:	74 0f                	je     800188 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800179:	a1 20 40 80 00       	mov    0x804020,%eax
  80017e:	05 5c 05 00 00       	add    $0x55c,%eax
  800183:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800188:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80018c:	7e 0a                	jle    800198 <libmain+0x60>
		binaryname = argv[0];
  80018e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800191:	8b 00                	mov    (%eax),%eax
  800193:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800198:	83 ec 08             	sub    $0x8,%esp
  80019b:	ff 75 0c             	pushl  0xc(%ebp)
  80019e:	ff 75 08             	pushl  0x8(%ebp)
  8001a1:	e8 92 fe ff ff       	call   800038 <_main>
  8001a6:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001a9:	e8 3b 16 00 00       	call   8017e9 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001ae:	83 ec 0c             	sub    $0xc,%esp
  8001b1:	68 f8 32 80 00       	push   $0x8032f8
  8001b6:	e8 8d 01 00 00       	call   800348 <cprintf>
  8001bb:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001be:	a1 20 40 80 00       	mov    0x804020,%eax
  8001c3:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8001c9:	a1 20 40 80 00       	mov    0x804020,%eax
  8001ce:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8001d4:	83 ec 04             	sub    $0x4,%esp
  8001d7:	52                   	push   %edx
  8001d8:	50                   	push   %eax
  8001d9:	68 20 33 80 00       	push   $0x803320
  8001de:	e8 65 01 00 00       	call   800348 <cprintf>
  8001e3:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001e6:	a1 20 40 80 00       	mov    0x804020,%eax
  8001eb:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8001f1:	a1 20 40 80 00       	mov    0x804020,%eax
  8001f6:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8001fc:	a1 20 40 80 00       	mov    0x804020,%eax
  800201:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800207:	51                   	push   %ecx
  800208:	52                   	push   %edx
  800209:	50                   	push   %eax
  80020a:	68 48 33 80 00       	push   $0x803348
  80020f:	e8 34 01 00 00       	call   800348 <cprintf>
  800214:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800217:	a1 20 40 80 00       	mov    0x804020,%eax
  80021c:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800222:	83 ec 08             	sub    $0x8,%esp
  800225:	50                   	push   %eax
  800226:	68 a0 33 80 00       	push   $0x8033a0
  80022b:	e8 18 01 00 00       	call   800348 <cprintf>
  800230:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800233:	83 ec 0c             	sub    $0xc,%esp
  800236:	68 f8 32 80 00       	push   $0x8032f8
  80023b:	e8 08 01 00 00       	call   800348 <cprintf>
  800240:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800243:	e8 bb 15 00 00       	call   801803 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800248:	e8 19 00 00 00       	call   800266 <exit>
}
  80024d:	90                   	nop
  80024e:	c9                   	leave  
  80024f:	c3                   	ret    

00800250 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800250:	55                   	push   %ebp
  800251:	89 e5                	mov    %esp,%ebp
  800253:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800256:	83 ec 0c             	sub    $0xc,%esp
  800259:	6a 00                	push   $0x0
  80025b:	e8 48 17 00 00       	call   8019a8 <sys_destroy_env>
  800260:	83 c4 10             	add    $0x10,%esp
}
  800263:	90                   	nop
  800264:	c9                   	leave  
  800265:	c3                   	ret    

00800266 <exit>:

void
exit(void)
{
  800266:	55                   	push   %ebp
  800267:	89 e5                	mov    %esp,%ebp
  800269:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80026c:	e8 9d 17 00 00       	call   801a0e <sys_exit_env>
}
  800271:	90                   	nop
  800272:	c9                   	leave  
  800273:	c3                   	ret    

00800274 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800274:	55                   	push   %ebp
  800275:	89 e5                	mov    %esp,%ebp
  800277:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80027a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80027d:	8b 00                	mov    (%eax),%eax
  80027f:	8d 48 01             	lea    0x1(%eax),%ecx
  800282:	8b 55 0c             	mov    0xc(%ebp),%edx
  800285:	89 0a                	mov    %ecx,(%edx)
  800287:	8b 55 08             	mov    0x8(%ebp),%edx
  80028a:	88 d1                	mov    %dl,%cl
  80028c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80028f:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800293:	8b 45 0c             	mov    0xc(%ebp),%eax
  800296:	8b 00                	mov    (%eax),%eax
  800298:	3d ff 00 00 00       	cmp    $0xff,%eax
  80029d:	75 2c                	jne    8002cb <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80029f:	a0 24 40 80 00       	mov    0x804024,%al
  8002a4:	0f b6 c0             	movzbl %al,%eax
  8002a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002aa:	8b 12                	mov    (%edx),%edx
  8002ac:	89 d1                	mov    %edx,%ecx
  8002ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002b1:	83 c2 08             	add    $0x8,%edx
  8002b4:	83 ec 04             	sub    $0x4,%esp
  8002b7:	50                   	push   %eax
  8002b8:	51                   	push   %ecx
  8002b9:	52                   	push   %edx
  8002ba:	e8 7c 13 00 00       	call   80163b <sys_cputs>
  8002bf:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8002c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8002cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ce:	8b 40 04             	mov    0x4(%eax),%eax
  8002d1:	8d 50 01             	lea    0x1(%eax),%edx
  8002d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002d7:	89 50 04             	mov    %edx,0x4(%eax)
}
  8002da:	90                   	nop
  8002db:	c9                   	leave  
  8002dc:	c3                   	ret    

008002dd <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8002dd:	55                   	push   %ebp
  8002de:	89 e5                	mov    %esp,%ebp
  8002e0:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002e6:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002ed:	00 00 00 
	b.cnt = 0;
  8002f0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002f7:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8002fa:	ff 75 0c             	pushl  0xc(%ebp)
  8002fd:	ff 75 08             	pushl  0x8(%ebp)
  800300:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800306:	50                   	push   %eax
  800307:	68 74 02 80 00       	push   $0x800274
  80030c:	e8 11 02 00 00       	call   800522 <vprintfmt>
  800311:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800314:	a0 24 40 80 00       	mov    0x804024,%al
  800319:	0f b6 c0             	movzbl %al,%eax
  80031c:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800322:	83 ec 04             	sub    $0x4,%esp
  800325:	50                   	push   %eax
  800326:	52                   	push   %edx
  800327:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80032d:	83 c0 08             	add    $0x8,%eax
  800330:	50                   	push   %eax
  800331:	e8 05 13 00 00       	call   80163b <sys_cputs>
  800336:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800339:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800340:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800346:	c9                   	leave  
  800347:	c3                   	ret    

00800348 <cprintf>:

int cprintf(const char *fmt, ...) {
  800348:	55                   	push   %ebp
  800349:	89 e5                	mov    %esp,%ebp
  80034b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80034e:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800355:	8d 45 0c             	lea    0xc(%ebp),%eax
  800358:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80035b:	8b 45 08             	mov    0x8(%ebp),%eax
  80035e:	83 ec 08             	sub    $0x8,%esp
  800361:	ff 75 f4             	pushl  -0xc(%ebp)
  800364:	50                   	push   %eax
  800365:	e8 73 ff ff ff       	call   8002dd <vcprintf>
  80036a:	83 c4 10             	add    $0x10,%esp
  80036d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800370:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800373:	c9                   	leave  
  800374:	c3                   	ret    

00800375 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800375:	55                   	push   %ebp
  800376:	89 e5                	mov    %esp,%ebp
  800378:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80037b:	e8 69 14 00 00       	call   8017e9 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800380:	8d 45 0c             	lea    0xc(%ebp),%eax
  800383:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800386:	8b 45 08             	mov    0x8(%ebp),%eax
  800389:	83 ec 08             	sub    $0x8,%esp
  80038c:	ff 75 f4             	pushl  -0xc(%ebp)
  80038f:	50                   	push   %eax
  800390:	e8 48 ff ff ff       	call   8002dd <vcprintf>
  800395:	83 c4 10             	add    $0x10,%esp
  800398:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80039b:	e8 63 14 00 00       	call   801803 <sys_enable_interrupt>
	return cnt;
  8003a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003a3:	c9                   	leave  
  8003a4:	c3                   	ret    

008003a5 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003a5:	55                   	push   %ebp
  8003a6:	89 e5                	mov    %esp,%ebp
  8003a8:	53                   	push   %ebx
  8003a9:	83 ec 14             	sub    $0x14,%esp
  8003ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8003af:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8003b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003b8:	8b 45 18             	mov    0x18(%ebp),%eax
  8003bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8003c0:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003c3:	77 55                	ja     80041a <printnum+0x75>
  8003c5:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003c8:	72 05                	jb     8003cf <printnum+0x2a>
  8003ca:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8003cd:	77 4b                	ja     80041a <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003cf:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8003d2:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8003d5:	8b 45 18             	mov    0x18(%ebp),%eax
  8003d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8003dd:	52                   	push   %edx
  8003de:	50                   	push   %eax
  8003df:	ff 75 f4             	pushl  -0xc(%ebp)
  8003e2:	ff 75 f0             	pushl  -0x10(%ebp)
  8003e5:	e8 62 2c 00 00       	call   80304c <__udivdi3>
  8003ea:	83 c4 10             	add    $0x10,%esp
  8003ed:	83 ec 04             	sub    $0x4,%esp
  8003f0:	ff 75 20             	pushl  0x20(%ebp)
  8003f3:	53                   	push   %ebx
  8003f4:	ff 75 18             	pushl  0x18(%ebp)
  8003f7:	52                   	push   %edx
  8003f8:	50                   	push   %eax
  8003f9:	ff 75 0c             	pushl  0xc(%ebp)
  8003fc:	ff 75 08             	pushl  0x8(%ebp)
  8003ff:	e8 a1 ff ff ff       	call   8003a5 <printnum>
  800404:	83 c4 20             	add    $0x20,%esp
  800407:	eb 1a                	jmp    800423 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800409:	83 ec 08             	sub    $0x8,%esp
  80040c:	ff 75 0c             	pushl  0xc(%ebp)
  80040f:	ff 75 20             	pushl  0x20(%ebp)
  800412:	8b 45 08             	mov    0x8(%ebp),%eax
  800415:	ff d0                	call   *%eax
  800417:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80041a:	ff 4d 1c             	decl   0x1c(%ebp)
  80041d:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800421:	7f e6                	jg     800409 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800423:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800426:	bb 00 00 00 00       	mov    $0x0,%ebx
  80042b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80042e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800431:	53                   	push   %ebx
  800432:	51                   	push   %ecx
  800433:	52                   	push   %edx
  800434:	50                   	push   %eax
  800435:	e8 22 2d 00 00       	call   80315c <__umoddi3>
  80043a:	83 c4 10             	add    $0x10,%esp
  80043d:	05 d4 35 80 00       	add    $0x8035d4,%eax
  800442:	8a 00                	mov    (%eax),%al
  800444:	0f be c0             	movsbl %al,%eax
  800447:	83 ec 08             	sub    $0x8,%esp
  80044a:	ff 75 0c             	pushl  0xc(%ebp)
  80044d:	50                   	push   %eax
  80044e:	8b 45 08             	mov    0x8(%ebp),%eax
  800451:	ff d0                	call   *%eax
  800453:	83 c4 10             	add    $0x10,%esp
}
  800456:	90                   	nop
  800457:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80045a:	c9                   	leave  
  80045b:	c3                   	ret    

0080045c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80045c:	55                   	push   %ebp
  80045d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80045f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800463:	7e 1c                	jle    800481 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800465:	8b 45 08             	mov    0x8(%ebp),%eax
  800468:	8b 00                	mov    (%eax),%eax
  80046a:	8d 50 08             	lea    0x8(%eax),%edx
  80046d:	8b 45 08             	mov    0x8(%ebp),%eax
  800470:	89 10                	mov    %edx,(%eax)
  800472:	8b 45 08             	mov    0x8(%ebp),%eax
  800475:	8b 00                	mov    (%eax),%eax
  800477:	83 e8 08             	sub    $0x8,%eax
  80047a:	8b 50 04             	mov    0x4(%eax),%edx
  80047d:	8b 00                	mov    (%eax),%eax
  80047f:	eb 40                	jmp    8004c1 <getuint+0x65>
	else if (lflag)
  800481:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800485:	74 1e                	je     8004a5 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800487:	8b 45 08             	mov    0x8(%ebp),%eax
  80048a:	8b 00                	mov    (%eax),%eax
  80048c:	8d 50 04             	lea    0x4(%eax),%edx
  80048f:	8b 45 08             	mov    0x8(%ebp),%eax
  800492:	89 10                	mov    %edx,(%eax)
  800494:	8b 45 08             	mov    0x8(%ebp),%eax
  800497:	8b 00                	mov    (%eax),%eax
  800499:	83 e8 04             	sub    $0x4,%eax
  80049c:	8b 00                	mov    (%eax),%eax
  80049e:	ba 00 00 00 00       	mov    $0x0,%edx
  8004a3:	eb 1c                	jmp    8004c1 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8004a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a8:	8b 00                	mov    (%eax),%eax
  8004aa:	8d 50 04             	lea    0x4(%eax),%edx
  8004ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b0:	89 10                	mov    %edx,(%eax)
  8004b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b5:	8b 00                	mov    (%eax),%eax
  8004b7:	83 e8 04             	sub    $0x4,%eax
  8004ba:	8b 00                	mov    (%eax),%eax
  8004bc:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004c1:	5d                   	pop    %ebp
  8004c2:	c3                   	ret    

008004c3 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004c3:	55                   	push   %ebp
  8004c4:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004c6:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004ca:	7e 1c                	jle    8004e8 <getint+0x25>
		return va_arg(*ap, long long);
  8004cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8004cf:	8b 00                	mov    (%eax),%eax
  8004d1:	8d 50 08             	lea    0x8(%eax),%edx
  8004d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d7:	89 10                	mov    %edx,(%eax)
  8004d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8004dc:	8b 00                	mov    (%eax),%eax
  8004de:	83 e8 08             	sub    $0x8,%eax
  8004e1:	8b 50 04             	mov    0x4(%eax),%edx
  8004e4:	8b 00                	mov    (%eax),%eax
  8004e6:	eb 38                	jmp    800520 <getint+0x5d>
	else if (lflag)
  8004e8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004ec:	74 1a                	je     800508 <getint+0x45>
		return va_arg(*ap, long);
  8004ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f1:	8b 00                	mov    (%eax),%eax
  8004f3:	8d 50 04             	lea    0x4(%eax),%edx
  8004f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f9:	89 10                	mov    %edx,(%eax)
  8004fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8004fe:	8b 00                	mov    (%eax),%eax
  800500:	83 e8 04             	sub    $0x4,%eax
  800503:	8b 00                	mov    (%eax),%eax
  800505:	99                   	cltd   
  800506:	eb 18                	jmp    800520 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800508:	8b 45 08             	mov    0x8(%ebp),%eax
  80050b:	8b 00                	mov    (%eax),%eax
  80050d:	8d 50 04             	lea    0x4(%eax),%edx
  800510:	8b 45 08             	mov    0x8(%ebp),%eax
  800513:	89 10                	mov    %edx,(%eax)
  800515:	8b 45 08             	mov    0x8(%ebp),%eax
  800518:	8b 00                	mov    (%eax),%eax
  80051a:	83 e8 04             	sub    $0x4,%eax
  80051d:	8b 00                	mov    (%eax),%eax
  80051f:	99                   	cltd   
}
  800520:	5d                   	pop    %ebp
  800521:	c3                   	ret    

00800522 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800522:	55                   	push   %ebp
  800523:	89 e5                	mov    %esp,%ebp
  800525:	56                   	push   %esi
  800526:	53                   	push   %ebx
  800527:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80052a:	eb 17                	jmp    800543 <vprintfmt+0x21>
			if (ch == '\0')
  80052c:	85 db                	test   %ebx,%ebx
  80052e:	0f 84 af 03 00 00    	je     8008e3 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800534:	83 ec 08             	sub    $0x8,%esp
  800537:	ff 75 0c             	pushl  0xc(%ebp)
  80053a:	53                   	push   %ebx
  80053b:	8b 45 08             	mov    0x8(%ebp),%eax
  80053e:	ff d0                	call   *%eax
  800540:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800543:	8b 45 10             	mov    0x10(%ebp),%eax
  800546:	8d 50 01             	lea    0x1(%eax),%edx
  800549:	89 55 10             	mov    %edx,0x10(%ebp)
  80054c:	8a 00                	mov    (%eax),%al
  80054e:	0f b6 d8             	movzbl %al,%ebx
  800551:	83 fb 25             	cmp    $0x25,%ebx
  800554:	75 d6                	jne    80052c <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800556:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80055a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800561:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800568:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80056f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800576:	8b 45 10             	mov    0x10(%ebp),%eax
  800579:	8d 50 01             	lea    0x1(%eax),%edx
  80057c:	89 55 10             	mov    %edx,0x10(%ebp)
  80057f:	8a 00                	mov    (%eax),%al
  800581:	0f b6 d8             	movzbl %al,%ebx
  800584:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800587:	83 f8 55             	cmp    $0x55,%eax
  80058a:	0f 87 2b 03 00 00    	ja     8008bb <vprintfmt+0x399>
  800590:	8b 04 85 f8 35 80 00 	mov    0x8035f8(,%eax,4),%eax
  800597:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800599:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80059d:	eb d7                	jmp    800576 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80059f:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8005a3:	eb d1                	jmp    800576 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005a5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8005ac:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005af:	89 d0                	mov    %edx,%eax
  8005b1:	c1 e0 02             	shl    $0x2,%eax
  8005b4:	01 d0                	add    %edx,%eax
  8005b6:	01 c0                	add    %eax,%eax
  8005b8:	01 d8                	add    %ebx,%eax
  8005ba:	83 e8 30             	sub    $0x30,%eax
  8005bd:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8005c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8005c3:	8a 00                	mov    (%eax),%al
  8005c5:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8005c8:	83 fb 2f             	cmp    $0x2f,%ebx
  8005cb:	7e 3e                	jle    80060b <vprintfmt+0xe9>
  8005cd:	83 fb 39             	cmp    $0x39,%ebx
  8005d0:	7f 39                	jg     80060b <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005d2:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8005d5:	eb d5                	jmp    8005ac <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8005d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005da:	83 c0 04             	add    $0x4,%eax
  8005dd:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e3:	83 e8 04             	sub    $0x4,%eax
  8005e6:	8b 00                	mov    (%eax),%eax
  8005e8:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8005eb:	eb 1f                	jmp    80060c <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8005ed:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005f1:	79 83                	jns    800576 <vprintfmt+0x54>
				width = 0;
  8005f3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8005fa:	e9 77 ff ff ff       	jmp    800576 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8005ff:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800606:	e9 6b ff ff ff       	jmp    800576 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80060b:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80060c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800610:	0f 89 60 ff ff ff    	jns    800576 <vprintfmt+0x54>
				width = precision, precision = -1;
  800616:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800619:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80061c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800623:	e9 4e ff ff ff       	jmp    800576 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800628:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80062b:	e9 46 ff ff ff       	jmp    800576 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800630:	8b 45 14             	mov    0x14(%ebp),%eax
  800633:	83 c0 04             	add    $0x4,%eax
  800636:	89 45 14             	mov    %eax,0x14(%ebp)
  800639:	8b 45 14             	mov    0x14(%ebp),%eax
  80063c:	83 e8 04             	sub    $0x4,%eax
  80063f:	8b 00                	mov    (%eax),%eax
  800641:	83 ec 08             	sub    $0x8,%esp
  800644:	ff 75 0c             	pushl  0xc(%ebp)
  800647:	50                   	push   %eax
  800648:	8b 45 08             	mov    0x8(%ebp),%eax
  80064b:	ff d0                	call   *%eax
  80064d:	83 c4 10             	add    $0x10,%esp
			break;
  800650:	e9 89 02 00 00       	jmp    8008de <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800655:	8b 45 14             	mov    0x14(%ebp),%eax
  800658:	83 c0 04             	add    $0x4,%eax
  80065b:	89 45 14             	mov    %eax,0x14(%ebp)
  80065e:	8b 45 14             	mov    0x14(%ebp),%eax
  800661:	83 e8 04             	sub    $0x4,%eax
  800664:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800666:	85 db                	test   %ebx,%ebx
  800668:	79 02                	jns    80066c <vprintfmt+0x14a>
				err = -err;
  80066a:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80066c:	83 fb 64             	cmp    $0x64,%ebx
  80066f:	7f 0b                	jg     80067c <vprintfmt+0x15a>
  800671:	8b 34 9d 40 34 80 00 	mov    0x803440(,%ebx,4),%esi
  800678:	85 f6                	test   %esi,%esi
  80067a:	75 19                	jne    800695 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80067c:	53                   	push   %ebx
  80067d:	68 e5 35 80 00       	push   $0x8035e5
  800682:	ff 75 0c             	pushl  0xc(%ebp)
  800685:	ff 75 08             	pushl  0x8(%ebp)
  800688:	e8 5e 02 00 00       	call   8008eb <printfmt>
  80068d:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800690:	e9 49 02 00 00       	jmp    8008de <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800695:	56                   	push   %esi
  800696:	68 ee 35 80 00       	push   $0x8035ee
  80069b:	ff 75 0c             	pushl  0xc(%ebp)
  80069e:	ff 75 08             	pushl  0x8(%ebp)
  8006a1:	e8 45 02 00 00       	call   8008eb <printfmt>
  8006a6:	83 c4 10             	add    $0x10,%esp
			break;
  8006a9:	e9 30 02 00 00       	jmp    8008de <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8006ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b1:	83 c0 04             	add    $0x4,%eax
  8006b4:	89 45 14             	mov    %eax,0x14(%ebp)
  8006b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ba:	83 e8 04             	sub    $0x4,%eax
  8006bd:	8b 30                	mov    (%eax),%esi
  8006bf:	85 f6                	test   %esi,%esi
  8006c1:	75 05                	jne    8006c8 <vprintfmt+0x1a6>
				p = "(null)";
  8006c3:	be f1 35 80 00       	mov    $0x8035f1,%esi
			if (width > 0 && padc != '-')
  8006c8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006cc:	7e 6d                	jle    80073b <vprintfmt+0x219>
  8006ce:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8006d2:	74 67                	je     80073b <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006d7:	83 ec 08             	sub    $0x8,%esp
  8006da:	50                   	push   %eax
  8006db:	56                   	push   %esi
  8006dc:	e8 0c 03 00 00       	call   8009ed <strnlen>
  8006e1:	83 c4 10             	add    $0x10,%esp
  8006e4:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8006e7:	eb 16                	jmp    8006ff <vprintfmt+0x1dd>
					putch(padc, putdat);
  8006e9:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8006ed:	83 ec 08             	sub    $0x8,%esp
  8006f0:	ff 75 0c             	pushl  0xc(%ebp)
  8006f3:	50                   	push   %eax
  8006f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f7:	ff d0                	call   *%eax
  8006f9:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006fc:	ff 4d e4             	decl   -0x1c(%ebp)
  8006ff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800703:	7f e4                	jg     8006e9 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800705:	eb 34                	jmp    80073b <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800707:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80070b:	74 1c                	je     800729 <vprintfmt+0x207>
  80070d:	83 fb 1f             	cmp    $0x1f,%ebx
  800710:	7e 05                	jle    800717 <vprintfmt+0x1f5>
  800712:	83 fb 7e             	cmp    $0x7e,%ebx
  800715:	7e 12                	jle    800729 <vprintfmt+0x207>
					putch('?', putdat);
  800717:	83 ec 08             	sub    $0x8,%esp
  80071a:	ff 75 0c             	pushl  0xc(%ebp)
  80071d:	6a 3f                	push   $0x3f
  80071f:	8b 45 08             	mov    0x8(%ebp),%eax
  800722:	ff d0                	call   *%eax
  800724:	83 c4 10             	add    $0x10,%esp
  800727:	eb 0f                	jmp    800738 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800729:	83 ec 08             	sub    $0x8,%esp
  80072c:	ff 75 0c             	pushl  0xc(%ebp)
  80072f:	53                   	push   %ebx
  800730:	8b 45 08             	mov    0x8(%ebp),%eax
  800733:	ff d0                	call   *%eax
  800735:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800738:	ff 4d e4             	decl   -0x1c(%ebp)
  80073b:	89 f0                	mov    %esi,%eax
  80073d:	8d 70 01             	lea    0x1(%eax),%esi
  800740:	8a 00                	mov    (%eax),%al
  800742:	0f be d8             	movsbl %al,%ebx
  800745:	85 db                	test   %ebx,%ebx
  800747:	74 24                	je     80076d <vprintfmt+0x24b>
  800749:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80074d:	78 b8                	js     800707 <vprintfmt+0x1e5>
  80074f:	ff 4d e0             	decl   -0x20(%ebp)
  800752:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800756:	79 af                	jns    800707 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800758:	eb 13                	jmp    80076d <vprintfmt+0x24b>
				putch(' ', putdat);
  80075a:	83 ec 08             	sub    $0x8,%esp
  80075d:	ff 75 0c             	pushl  0xc(%ebp)
  800760:	6a 20                	push   $0x20
  800762:	8b 45 08             	mov    0x8(%ebp),%eax
  800765:	ff d0                	call   *%eax
  800767:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80076a:	ff 4d e4             	decl   -0x1c(%ebp)
  80076d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800771:	7f e7                	jg     80075a <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800773:	e9 66 01 00 00       	jmp    8008de <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800778:	83 ec 08             	sub    $0x8,%esp
  80077b:	ff 75 e8             	pushl  -0x18(%ebp)
  80077e:	8d 45 14             	lea    0x14(%ebp),%eax
  800781:	50                   	push   %eax
  800782:	e8 3c fd ff ff       	call   8004c3 <getint>
  800787:	83 c4 10             	add    $0x10,%esp
  80078a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80078d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800790:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800793:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800796:	85 d2                	test   %edx,%edx
  800798:	79 23                	jns    8007bd <vprintfmt+0x29b>
				putch('-', putdat);
  80079a:	83 ec 08             	sub    $0x8,%esp
  80079d:	ff 75 0c             	pushl  0xc(%ebp)
  8007a0:	6a 2d                	push   $0x2d
  8007a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a5:	ff d0                	call   *%eax
  8007a7:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8007aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007b0:	f7 d8                	neg    %eax
  8007b2:	83 d2 00             	adc    $0x0,%edx
  8007b5:	f7 da                	neg    %edx
  8007b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007ba:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8007bd:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007c4:	e9 bc 00 00 00       	jmp    800885 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007c9:	83 ec 08             	sub    $0x8,%esp
  8007cc:	ff 75 e8             	pushl  -0x18(%ebp)
  8007cf:	8d 45 14             	lea    0x14(%ebp),%eax
  8007d2:	50                   	push   %eax
  8007d3:	e8 84 fc ff ff       	call   80045c <getuint>
  8007d8:	83 c4 10             	add    $0x10,%esp
  8007db:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007de:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8007e1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007e8:	e9 98 00 00 00       	jmp    800885 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8007ed:	83 ec 08             	sub    $0x8,%esp
  8007f0:	ff 75 0c             	pushl  0xc(%ebp)
  8007f3:	6a 58                	push   $0x58
  8007f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f8:	ff d0                	call   *%eax
  8007fa:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8007fd:	83 ec 08             	sub    $0x8,%esp
  800800:	ff 75 0c             	pushl  0xc(%ebp)
  800803:	6a 58                	push   $0x58
  800805:	8b 45 08             	mov    0x8(%ebp),%eax
  800808:	ff d0                	call   *%eax
  80080a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80080d:	83 ec 08             	sub    $0x8,%esp
  800810:	ff 75 0c             	pushl  0xc(%ebp)
  800813:	6a 58                	push   $0x58
  800815:	8b 45 08             	mov    0x8(%ebp),%eax
  800818:	ff d0                	call   *%eax
  80081a:	83 c4 10             	add    $0x10,%esp
			break;
  80081d:	e9 bc 00 00 00       	jmp    8008de <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800822:	83 ec 08             	sub    $0x8,%esp
  800825:	ff 75 0c             	pushl  0xc(%ebp)
  800828:	6a 30                	push   $0x30
  80082a:	8b 45 08             	mov    0x8(%ebp),%eax
  80082d:	ff d0                	call   *%eax
  80082f:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800832:	83 ec 08             	sub    $0x8,%esp
  800835:	ff 75 0c             	pushl  0xc(%ebp)
  800838:	6a 78                	push   $0x78
  80083a:	8b 45 08             	mov    0x8(%ebp),%eax
  80083d:	ff d0                	call   *%eax
  80083f:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800842:	8b 45 14             	mov    0x14(%ebp),%eax
  800845:	83 c0 04             	add    $0x4,%eax
  800848:	89 45 14             	mov    %eax,0x14(%ebp)
  80084b:	8b 45 14             	mov    0x14(%ebp),%eax
  80084e:	83 e8 04             	sub    $0x4,%eax
  800851:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800853:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800856:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80085d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800864:	eb 1f                	jmp    800885 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800866:	83 ec 08             	sub    $0x8,%esp
  800869:	ff 75 e8             	pushl  -0x18(%ebp)
  80086c:	8d 45 14             	lea    0x14(%ebp),%eax
  80086f:	50                   	push   %eax
  800870:	e8 e7 fb ff ff       	call   80045c <getuint>
  800875:	83 c4 10             	add    $0x10,%esp
  800878:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80087b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80087e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800885:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800889:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80088c:	83 ec 04             	sub    $0x4,%esp
  80088f:	52                   	push   %edx
  800890:	ff 75 e4             	pushl  -0x1c(%ebp)
  800893:	50                   	push   %eax
  800894:	ff 75 f4             	pushl  -0xc(%ebp)
  800897:	ff 75 f0             	pushl  -0x10(%ebp)
  80089a:	ff 75 0c             	pushl  0xc(%ebp)
  80089d:	ff 75 08             	pushl  0x8(%ebp)
  8008a0:	e8 00 fb ff ff       	call   8003a5 <printnum>
  8008a5:	83 c4 20             	add    $0x20,%esp
			break;
  8008a8:	eb 34                	jmp    8008de <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8008aa:	83 ec 08             	sub    $0x8,%esp
  8008ad:	ff 75 0c             	pushl  0xc(%ebp)
  8008b0:	53                   	push   %ebx
  8008b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b4:	ff d0                	call   *%eax
  8008b6:	83 c4 10             	add    $0x10,%esp
			break;
  8008b9:	eb 23                	jmp    8008de <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008bb:	83 ec 08             	sub    $0x8,%esp
  8008be:	ff 75 0c             	pushl  0xc(%ebp)
  8008c1:	6a 25                	push   $0x25
  8008c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c6:	ff d0                	call   *%eax
  8008c8:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008cb:	ff 4d 10             	decl   0x10(%ebp)
  8008ce:	eb 03                	jmp    8008d3 <vprintfmt+0x3b1>
  8008d0:	ff 4d 10             	decl   0x10(%ebp)
  8008d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8008d6:	48                   	dec    %eax
  8008d7:	8a 00                	mov    (%eax),%al
  8008d9:	3c 25                	cmp    $0x25,%al
  8008db:	75 f3                	jne    8008d0 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8008dd:	90                   	nop
		}
	}
  8008de:	e9 47 fc ff ff       	jmp    80052a <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8008e3:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8008e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008e7:	5b                   	pop    %ebx
  8008e8:	5e                   	pop    %esi
  8008e9:	5d                   	pop    %ebp
  8008ea:	c3                   	ret    

008008eb <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8008eb:	55                   	push   %ebp
  8008ec:	89 e5                	mov    %esp,%ebp
  8008ee:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8008f1:	8d 45 10             	lea    0x10(%ebp),%eax
  8008f4:	83 c0 04             	add    $0x4,%eax
  8008f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8008fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8008fd:	ff 75 f4             	pushl  -0xc(%ebp)
  800900:	50                   	push   %eax
  800901:	ff 75 0c             	pushl  0xc(%ebp)
  800904:	ff 75 08             	pushl  0x8(%ebp)
  800907:	e8 16 fc ff ff       	call   800522 <vprintfmt>
  80090c:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80090f:	90                   	nop
  800910:	c9                   	leave  
  800911:	c3                   	ret    

00800912 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800912:	55                   	push   %ebp
  800913:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800915:	8b 45 0c             	mov    0xc(%ebp),%eax
  800918:	8b 40 08             	mov    0x8(%eax),%eax
  80091b:	8d 50 01             	lea    0x1(%eax),%edx
  80091e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800921:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800924:	8b 45 0c             	mov    0xc(%ebp),%eax
  800927:	8b 10                	mov    (%eax),%edx
  800929:	8b 45 0c             	mov    0xc(%ebp),%eax
  80092c:	8b 40 04             	mov    0x4(%eax),%eax
  80092f:	39 c2                	cmp    %eax,%edx
  800931:	73 12                	jae    800945 <sprintputch+0x33>
		*b->buf++ = ch;
  800933:	8b 45 0c             	mov    0xc(%ebp),%eax
  800936:	8b 00                	mov    (%eax),%eax
  800938:	8d 48 01             	lea    0x1(%eax),%ecx
  80093b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80093e:	89 0a                	mov    %ecx,(%edx)
  800940:	8b 55 08             	mov    0x8(%ebp),%edx
  800943:	88 10                	mov    %dl,(%eax)
}
  800945:	90                   	nop
  800946:	5d                   	pop    %ebp
  800947:	c3                   	ret    

00800948 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800948:	55                   	push   %ebp
  800949:	89 e5                	mov    %esp,%ebp
  80094b:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80094e:	8b 45 08             	mov    0x8(%ebp),%eax
  800951:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800954:	8b 45 0c             	mov    0xc(%ebp),%eax
  800957:	8d 50 ff             	lea    -0x1(%eax),%edx
  80095a:	8b 45 08             	mov    0x8(%ebp),%eax
  80095d:	01 d0                	add    %edx,%eax
  80095f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800962:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800969:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80096d:	74 06                	je     800975 <vsnprintf+0x2d>
  80096f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800973:	7f 07                	jg     80097c <vsnprintf+0x34>
		return -E_INVAL;
  800975:	b8 03 00 00 00       	mov    $0x3,%eax
  80097a:	eb 20                	jmp    80099c <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80097c:	ff 75 14             	pushl  0x14(%ebp)
  80097f:	ff 75 10             	pushl  0x10(%ebp)
  800982:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800985:	50                   	push   %eax
  800986:	68 12 09 80 00       	push   $0x800912
  80098b:	e8 92 fb ff ff       	call   800522 <vprintfmt>
  800990:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800993:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800996:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800999:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80099c:	c9                   	leave  
  80099d:	c3                   	ret    

0080099e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80099e:	55                   	push   %ebp
  80099f:	89 e5                	mov    %esp,%ebp
  8009a1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009a4:	8d 45 10             	lea    0x10(%ebp),%eax
  8009a7:	83 c0 04             	add    $0x4,%eax
  8009aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8009ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8009b0:	ff 75 f4             	pushl  -0xc(%ebp)
  8009b3:	50                   	push   %eax
  8009b4:	ff 75 0c             	pushl  0xc(%ebp)
  8009b7:	ff 75 08             	pushl  0x8(%ebp)
  8009ba:	e8 89 ff ff ff       	call   800948 <vsnprintf>
  8009bf:	83 c4 10             	add    $0x10,%esp
  8009c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8009c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009c8:	c9                   	leave  
  8009c9:	c3                   	ret    

008009ca <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8009ca:	55                   	push   %ebp
  8009cb:	89 e5                	mov    %esp,%ebp
  8009cd:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8009d0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009d7:	eb 06                	jmp    8009df <strlen+0x15>
		n++;
  8009d9:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8009dc:	ff 45 08             	incl   0x8(%ebp)
  8009df:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e2:	8a 00                	mov    (%eax),%al
  8009e4:	84 c0                	test   %al,%al
  8009e6:	75 f1                	jne    8009d9 <strlen+0xf>
		n++;
	return n;
  8009e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8009eb:	c9                   	leave  
  8009ec:	c3                   	ret    

008009ed <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8009ed:	55                   	push   %ebp
  8009ee:	89 e5                	mov    %esp,%ebp
  8009f0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009f3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009fa:	eb 09                	jmp    800a05 <strnlen+0x18>
		n++;
  8009fc:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009ff:	ff 45 08             	incl   0x8(%ebp)
  800a02:	ff 4d 0c             	decl   0xc(%ebp)
  800a05:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a09:	74 09                	je     800a14 <strnlen+0x27>
  800a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0e:	8a 00                	mov    (%eax),%al
  800a10:	84 c0                	test   %al,%al
  800a12:	75 e8                	jne    8009fc <strnlen+0xf>
		n++;
	return n;
  800a14:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a17:	c9                   	leave  
  800a18:	c3                   	ret    

00800a19 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a19:	55                   	push   %ebp
  800a1a:	89 e5                	mov    %esp,%ebp
  800a1c:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a22:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800a25:	90                   	nop
  800a26:	8b 45 08             	mov    0x8(%ebp),%eax
  800a29:	8d 50 01             	lea    0x1(%eax),%edx
  800a2c:	89 55 08             	mov    %edx,0x8(%ebp)
  800a2f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a32:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a35:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a38:	8a 12                	mov    (%edx),%dl
  800a3a:	88 10                	mov    %dl,(%eax)
  800a3c:	8a 00                	mov    (%eax),%al
  800a3e:	84 c0                	test   %al,%al
  800a40:	75 e4                	jne    800a26 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800a42:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a45:	c9                   	leave  
  800a46:	c3                   	ret    

00800a47 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800a47:	55                   	push   %ebp
  800a48:	89 e5                	mov    %esp,%ebp
  800a4a:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a50:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800a53:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a5a:	eb 1f                	jmp    800a7b <strncpy+0x34>
		*dst++ = *src;
  800a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5f:	8d 50 01             	lea    0x1(%eax),%edx
  800a62:	89 55 08             	mov    %edx,0x8(%ebp)
  800a65:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a68:	8a 12                	mov    (%edx),%dl
  800a6a:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800a6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a6f:	8a 00                	mov    (%eax),%al
  800a71:	84 c0                	test   %al,%al
  800a73:	74 03                	je     800a78 <strncpy+0x31>
			src++;
  800a75:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a78:	ff 45 fc             	incl   -0x4(%ebp)
  800a7b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a7e:	3b 45 10             	cmp    0x10(%ebp),%eax
  800a81:	72 d9                	jb     800a5c <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800a83:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800a86:	c9                   	leave  
  800a87:	c3                   	ret    

00800a88 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800a88:	55                   	push   %ebp
  800a89:	89 e5                	mov    %esp,%ebp
  800a8b:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a91:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800a94:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a98:	74 30                	je     800aca <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800a9a:	eb 16                	jmp    800ab2 <strlcpy+0x2a>
			*dst++ = *src++;
  800a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9f:	8d 50 01             	lea    0x1(%eax),%edx
  800aa2:	89 55 08             	mov    %edx,0x8(%ebp)
  800aa5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aa8:	8d 4a 01             	lea    0x1(%edx),%ecx
  800aab:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800aae:	8a 12                	mov    (%edx),%dl
  800ab0:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ab2:	ff 4d 10             	decl   0x10(%ebp)
  800ab5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ab9:	74 09                	je     800ac4 <strlcpy+0x3c>
  800abb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800abe:	8a 00                	mov    (%eax),%al
  800ac0:	84 c0                	test   %al,%al
  800ac2:	75 d8                	jne    800a9c <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac7:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800aca:	8b 55 08             	mov    0x8(%ebp),%edx
  800acd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ad0:	29 c2                	sub    %eax,%edx
  800ad2:	89 d0                	mov    %edx,%eax
}
  800ad4:	c9                   	leave  
  800ad5:	c3                   	ret    

00800ad6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ad6:	55                   	push   %ebp
  800ad7:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ad9:	eb 06                	jmp    800ae1 <strcmp+0xb>
		p++, q++;
  800adb:	ff 45 08             	incl   0x8(%ebp)
  800ade:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae4:	8a 00                	mov    (%eax),%al
  800ae6:	84 c0                	test   %al,%al
  800ae8:	74 0e                	je     800af8 <strcmp+0x22>
  800aea:	8b 45 08             	mov    0x8(%ebp),%eax
  800aed:	8a 10                	mov    (%eax),%dl
  800aef:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af2:	8a 00                	mov    (%eax),%al
  800af4:	38 c2                	cmp    %al,%dl
  800af6:	74 e3                	je     800adb <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800af8:	8b 45 08             	mov    0x8(%ebp),%eax
  800afb:	8a 00                	mov    (%eax),%al
  800afd:	0f b6 d0             	movzbl %al,%edx
  800b00:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b03:	8a 00                	mov    (%eax),%al
  800b05:	0f b6 c0             	movzbl %al,%eax
  800b08:	29 c2                	sub    %eax,%edx
  800b0a:	89 d0                	mov    %edx,%eax
}
  800b0c:	5d                   	pop    %ebp
  800b0d:	c3                   	ret    

00800b0e <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800b0e:	55                   	push   %ebp
  800b0f:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800b11:	eb 09                	jmp    800b1c <strncmp+0xe>
		n--, p++, q++;
  800b13:	ff 4d 10             	decl   0x10(%ebp)
  800b16:	ff 45 08             	incl   0x8(%ebp)
  800b19:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800b1c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b20:	74 17                	je     800b39 <strncmp+0x2b>
  800b22:	8b 45 08             	mov    0x8(%ebp),%eax
  800b25:	8a 00                	mov    (%eax),%al
  800b27:	84 c0                	test   %al,%al
  800b29:	74 0e                	je     800b39 <strncmp+0x2b>
  800b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2e:	8a 10                	mov    (%eax),%dl
  800b30:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b33:	8a 00                	mov    (%eax),%al
  800b35:	38 c2                	cmp    %al,%dl
  800b37:	74 da                	je     800b13 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800b39:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b3d:	75 07                	jne    800b46 <strncmp+0x38>
		return 0;
  800b3f:	b8 00 00 00 00       	mov    $0x0,%eax
  800b44:	eb 14                	jmp    800b5a <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b46:	8b 45 08             	mov    0x8(%ebp),%eax
  800b49:	8a 00                	mov    (%eax),%al
  800b4b:	0f b6 d0             	movzbl %al,%edx
  800b4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b51:	8a 00                	mov    (%eax),%al
  800b53:	0f b6 c0             	movzbl %al,%eax
  800b56:	29 c2                	sub    %eax,%edx
  800b58:	89 d0                	mov    %edx,%eax
}
  800b5a:	5d                   	pop    %ebp
  800b5b:	c3                   	ret    

00800b5c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b5c:	55                   	push   %ebp
  800b5d:	89 e5                	mov    %esp,%ebp
  800b5f:	83 ec 04             	sub    $0x4,%esp
  800b62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b65:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b68:	eb 12                	jmp    800b7c <strchr+0x20>
		if (*s == c)
  800b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6d:	8a 00                	mov    (%eax),%al
  800b6f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b72:	75 05                	jne    800b79 <strchr+0x1d>
			return (char *) s;
  800b74:	8b 45 08             	mov    0x8(%ebp),%eax
  800b77:	eb 11                	jmp    800b8a <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800b79:	ff 45 08             	incl   0x8(%ebp)
  800b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7f:	8a 00                	mov    (%eax),%al
  800b81:	84 c0                	test   %al,%al
  800b83:	75 e5                	jne    800b6a <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800b85:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b8a:	c9                   	leave  
  800b8b:	c3                   	ret    

00800b8c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b8c:	55                   	push   %ebp
  800b8d:	89 e5                	mov    %esp,%ebp
  800b8f:	83 ec 04             	sub    $0x4,%esp
  800b92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b95:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b98:	eb 0d                	jmp    800ba7 <strfind+0x1b>
		if (*s == c)
  800b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9d:	8a 00                	mov    (%eax),%al
  800b9f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ba2:	74 0e                	je     800bb2 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ba4:	ff 45 08             	incl   0x8(%ebp)
  800ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  800baa:	8a 00                	mov    (%eax),%al
  800bac:	84 c0                	test   %al,%al
  800bae:	75 ea                	jne    800b9a <strfind+0xe>
  800bb0:	eb 01                	jmp    800bb3 <strfind+0x27>
		if (*s == c)
			break;
  800bb2:	90                   	nop
	return (char *) s;
  800bb3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bb6:	c9                   	leave  
  800bb7:	c3                   	ret    

00800bb8 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800bb8:	55                   	push   %ebp
  800bb9:	89 e5                	mov    %esp,%ebp
  800bbb:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800bbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800bc4:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800bca:	eb 0e                	jmp    800bda <memset+0x22>
		*p++ = c;
  800bcc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bcf:	8d 50 01             	lea    0x1(%eax),%edx
  800bd2:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800bd5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bd8:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800bda:	ff 4d f8             	decl   -0x8(%ebp)
  800bdd:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800be1:	79 e9                	jns    800bcc <memset+0x14>
		*p++ = c;

	return v;
  800be3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800be6:	c9                   	leave  
  800be7:	c3                   	ret    

00800be8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800be8:	55                   	push   %ebp
  800be9:	89 e5                	mov    %esp,%ebp
  800beb:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800bee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800bfa:	eb 16                	jmp    800c12 <memcpy+0x2a>
		*d++ = *s++;
  800bfc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bff:	8d 50 01             	lea    0x1(%eax),%edx
  800c02:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c05:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c08:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c0b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c0e:	8a 12                	mov    (%edx),%dl
  800c10:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800c12:	8b 45 10             	mov    0x10(%ebp),%eax
  800c15:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c18:	89 55 10             	mov    %edx,0x10(%ebp)
  800c1b:	85 c0                	test   %eax,%eax
  800c1d:	75 dd                	jne    800bfc <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800c1f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c22:	c9                   	leave  
  800c23:	c3                   	ret    

00800c24 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800c24:	55                   	push   %ebp
  800c25:	89 e5                	mov    %esp,%ebp
  800c27:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c2d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c30:	8b 45 08             	mov    0x8(%ebp),%eax
  800c33:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800c36:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c39:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c3c:	73 50                	jae    800c8e <memmove+0x6a>
  800c3e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c41:	8b 45 10             	mov    0x10(%ebp),%eax
  800c44:	01 d0                	add    %edx,%eax
  800c46:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c49:	76 43                	jbe    800c8e <memmove+0x6a>
		s += n;
  800c4b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c4e:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800c51:	8b 45 10             	mov    0x10(%ebp),%eax
  800c54:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800c57:	eb 10                	jmp    800c69 <memmove+0x45>
			*--d = *--s;
  800c59:	ff 4d f8             	decl   -0x8(%ebp)
  800c5c:	ff 4d fc             	decl   -0x4(%ebp)
  800c5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c62:	8a 10                	mov    (%eax),%dl
  800c64:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c67:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800c69:	8b 45 10             	mov    0x10(%ebp),%eax
  800c6c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c6f:	89 55 10             	mov    %edx,0x10(%ebp)
  800c72:	85 c0                	test   %eax,%eax
  800c74:	75 e3                	jne    800c59 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c76:	eb 23                	jmp    800c9b <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800c78:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c7b:	8d 50 01             	lea    0x1(%eax),%edx
  800c7e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c81:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c84:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c87:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c8a:	8a 12                	mov    (%edx),%dl
  800c8c:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800c8e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c91:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c94:	89 55 10             	mov    %edx,0x10(%ebp)
  800c97:	85 c0                	test   %eax,%eax
  800c99:	75 dd                	jne    800c78 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800c9b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c9e:	c9                   	leave  
  800c9f:	c3                   	ret    

00800ca0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ca0:	55                   	push   %ebp
  800ca1:	89 e5                	mov    %esp,%ebp
  800ca3:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800cac:	8b 45 0c             	mov    0xc(%ebp),%eax
  800caf:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800cb2:	eb 2a                	jmp    800cde <memcmp+0x3e>
		if (*s1 != *s2)
  800cb4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cb7:	8a 10                	mov    (%eax),%dl
  800cb9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cbc:	8a 00                	mov    (%eax),%al
  800cbe:	38 c2                	cmp    %al,%dl
  800cc0:	74 16                	je     800cd8 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800cc2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cc5:	8a 00                	mov    (%eax),%al
  800cc7:	0f b6 d0             	movzbl %al,%edx
  800cca:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ccd:	8a 00                	mov    (%eax),%al
  800ccf:	0f b6 c0             	movzbl %al,%eax
  800cd2:	29 c2                	sub    %eax,%edx
  800cd4:	89 d0                	mov    %edx,%eax
  800cd6:	eb 18                	jmp    800cf0 <memcmp+0x50>
		s1++, s2++;
  800cd8:	ff 45 fc             	incl   -0x4(%ebp)
  800cdb:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800cde:	8b 45 10             	mov    0x10(%ebp),%eax
  800ce1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ce4:	89 55 10             	mov    %edx,0x10(%ebp)
  800ce7:	85 c0                	test   %eax,%eax
  800ce9:	75 c9                	jne    800cb4 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ceb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cf0:	c9                   	leave  
  800cf1:	c3                   	ret    

00800cf2 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800cf2:	55                   	push   %ebp
  800cf3:	89 e5                	mov    %esp,%ebp
  800cf5:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800cf8:	8b 55 08             	mov    0x8(%ebp),%edx
  800cfb:	8b 45 10             	mov    0x10(%ebp),%eax
  800cfe:	01 d0                	add    %edx,%eax
  800d00:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800d03:	eb 15                	jmp    800d1a <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d05:	8b 45 08             	mov    0x8(%ebp),%eax
  800d08:	8a 00                	mov    (%eax),%al
  800d0a:	0f b6 d0             	movzbl %al,%edx
  800d0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d10:	0f b6 c0             	movzbl %al,%eax
  800d13:	39 c2                	cmp    %eax,%edx
  800d15:	74 0d                	je     800d24 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800d17:	ff 45 08             	incl   0x8(%ebp)
  800d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800d20:	72 e3                	jb     800d05 <memfind+0x13>
  800d22:	eb 01                	jmp    800d25 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800d24:	90                   	nop
	return (void *) s;
  800d25:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d28:	c9                   	leave  
  800d29:	c3                   	ret    

00800d2a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d2a:	55                   	push   %ebp
  800d2b:	89 e5                	mov    %esp,%ebp
  800d2d:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800d30:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800d37:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d3e:	eb 03                	jmp    800d43 <strtol+0x19>
		s++;
  800d40:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d43:	8b 45 08             	mov    0x8(%ebp),%eax
  800d46:	8a 00                	mov    (%eax),%al
  800d48:	3c 20                	cmp    $0x20,%al
  800d4a:	74 f4                	je     800d40 <strtol+0x16>
  800d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4f:	8a 00                	mov    (%eax),%al
  800d51:	3c 09                	cmp    $0x9,%al
  800d53:	74 eb                	je     800d40 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800d55:	8b 45 08             	mov    0x8(%ebp),%eax
  800d58:	8a 00                	mov    (%eax),%al
  800d5a:	3c 2b                	cmp    $0x2b,%al
  800d5c:	75 05                	jne    800d63 <strtol+0x39>
		s++;
  800d5e:	ff 45 08             	incl   0x8(%ebp)
  800d61:	eb 13                	jmp    800d76 <strtol+0x4c>
	else if (*s == '-')
  800d63:	8b 45 08             	mov    0x8(%ebp),%eax
  800d66:	8a 00                	mov    (%eax),%al
  800d68:	3c 2d                	cmp    $0x2d,%al
  800d6a:	75 0a                	jne    800d76 <strtol+0x4c>
		s++, neg = 1;
  800d6c:	ff 45 08             	incl   0x8(%ebp)
  800d6f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d76:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d7a:	74 06                	je     800d82 <strtol+0x58>
  800d7c:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800d80:	75 20                	jne    800da2 <strtol+0x78>
  800d82:	8b 45 08             	mov    0x8(%ebp),%eax
  800d85:	8a 00                	mov    (%eax),%al
  800d87:	3c 30                	cmp    $0x30,%al
  800d89:	75 17                	jne    800da2 <strtol+0x78>
  800d8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8e:	40                   	inc    %eax
  800d8f:	8a 00                	mov    (%eax),%al
  800d91:	3c 78                	cmp    $0x78,%al
  800d93:	75 0d                	jne    800da2 <strtol+0x78>
		s += 2, base = 16;
  800d95:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800d99:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800da0:	eb 28                	jmp    800dca <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800da2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800da6:	75 15                	jne    800dbd <strtol+0x93>
  800da8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dab:	8a 00                	mov    (%eax),%al
  800dad:	3c 30                	cmp    $0x30,%al
  800daf:	75 0c                	jne    800dbd <strtol+0x93>
		s++, base = 8;
  800db1:	ff 45 08             	incl   0x8(%ebp)
  800db4:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800dbb:	eb 0d                	jmp    800dca <strtol+0xa0>
	else if (base == 0)
  800dbd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dc1:	75 07                	jne    800dca <strtol+0xa0>
		base = 10;
  800dc3:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800dca:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcd:	8a 00                	mov    (%eax),%al
  800dcf:	3c 2f                	cmp    $0x2f,%al
  800dd1:	7e 19                	jle    800dec <strtol+0xc2>
  800dd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd6:	8a 00                	mov    (%eax),%al
  800dd8:	3c 39                	cmp    $0x39,%al
  800dda:	7f 10                	jg     800dec <strtol+0xc2>
			dig = *s - '0';
  800ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddf:	8a 00                	mov    (%eax),%al
  800de1:	0f be c0             	movsbl %al,%eax
  800de4:	83 e8 30             	sub    $0x30,%eax
  800de7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800dea:	eb 42                	jmp    800e2e <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800dec:	8b 45 08             	mov    0x8(%ebp),%eax
  800def:	8a 00                	mov    (%eax),%al
  800df1:	3c 60                	cmp    $0x60,%al
  800df3:	7e 19                	jle    800e0e <strtol+0xe4>
  800df5:	8b 45 08             	mov    0x8(%ebp),%eax
  800df8:	8a 00                	mov    (%eax),%al
  800dfa:	3c 7a                	cmp    $0x7a,%al
  800dfc:	7f 10                	jg     800e0e <strtol+0xe4>
			dig = *s - 'a' + 10;
  800dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800e01:	8a 00                	mov    (%eax),%al
  800e03:	0f be c0             	movsbl %al,%eax
  800e06:	83 e8 57             	sub    $0x57,%eax
  800e09:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e0c:	eb 20                	jmp    800e2e <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e11:	8a 00                	mov    (%eax),%al
  800e13:	3c 40                	cmp    $0x40,%al
  800e15:	7e 39                	jle    800e50 <strtol+0x126>
  800e17:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1a:	8a 00                	mov    (%eax),%al
  800e1c:	3c 5a                	cmp    $0x5a,%al
  800e1e:	7f 30                	jg     800e50 <strtol+0x126>
			dig = *s - 'A' + 10;
  800e20:	8b 45 08             	mov    0x8(%ebp),%eax
  800e23:	8a 00                	mov    (%eax),%al
  800e25:	0f be c0             	movsbl %al,%eax
  800e28:	83 e8 37             	sub    $0x37,%eax
  800e2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800e2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e31:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e34:	7d 19                	jge    800e4f <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800e36:	ff 45 08             	incl   0x8(%ebp)
  800e39:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e3c:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e40:	89 c2                	mov    %eax,%edx
  800e42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e45:	01 d0                	add    %edx,%eax
  800e47:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800e4a:	e9 7b ff ff ff       	jmp    800dca <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800e4f:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800e50:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e54:	74 08                	je     800e5e <strtol+0x134>
		*endptr = (char *) s;
  800e56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e59:	8b 55 08             	mov    0x8(%ebp),%edx
  800e5c:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800e5e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e62:	74 07                	je     800e6b <strtol+0x141>
  800e64:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e67:	f7 d8                	neg    %eax
  800e69:	eb 03                	jmp    800e6e <strtol+0x144>
  800e6b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e6e:	c9                   	leave  
  800e6f:	c3                   	ret    

00800e70 <ltostr>:

void
ltostr(long value, char *str)
{
  800e70:	55                   	push   %ebp
  800e71:	89 e5                	mov    %esp,%ebp
  800e73:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800e76:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800e7d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800e84:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e88:	79 13                	jns    800e9d <ltostr+0x2d>
	{
		neg = 1;
  800e8a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800e91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e94:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800e97:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800e9a:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea0:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800ea5:	99                   	cltd   
  800ea6:	f7 f9                	idiv   %ecx
  800ea8:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800eab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eae:	8d 50 01             	lea    0x1(%eax),%edx
  800eb1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800eb4:	89 c2                	mov    %eax,%edx
  800eb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb9:	01 d0                	add    %edx,%eax
  800ebb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ebe:	83 c2 30             	add    $0x30,%edx
  800ec1:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800ec3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ec6:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800ecb:	f7 e9                	imul   %ecx
  800ecd:	c1 fa 02             	sar    $0x2,%edx
  800ed0:	89 c8                	mov    %ecx,%eax
  800ed2:	c1 f8 1f             	sar    $0x1f,%eax
  800ed5:	29 c2                	sub    %eax,%edx
  800ed7:	89 d0                	mov    %edx,%eax
  800ed9:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800edc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800edf:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800ee4:	f7 e9                	imul   %ecx
  800ee6:	c1 fa 02             	sar    $0x2,%edx
  800ee9:	89 c8                	mov    %ecx,%eax
  800eeb:	c1 f8 1f             	sar    $0x1f,%eax
  800eee:	29 c2                	sub    %eax,%edx
  800ef0:	89 d0                	mov    %edx,%eax
  800ef2:	c1 e0 02             	shl    $0x2,%eax
  800ef5:	01 d0                	add    %edx,%eax
  800ef7:	01 c0                	add    %eax,%eax
  800ef9:	29 c1                	sub    %eax,%ecx
  800efb:	89 ca                	mov    %ecx,%edx
  800efd:	85 d2                	test   %edx,%edx
  800eff:	75 9c                	jne    800e9d <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800f01:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800f08:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f0b:	48                   	dec    %eax
  800f0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800f0f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f13:	74 3d                	je     800f52 <ltostr+0xe2>
		start = 1 ;
  800f15:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800f1c:	eb 34                	jmp    800f52 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800f1e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f21:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f24:	01 d0                	add    %edx,%eax
  800f26:	8a 00                	mov    (%eax),%al
  800f28:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800f2b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f31:	01 c2                	add    %eax,%edx
  800f33:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800f36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f39:	01 c8                	add    %ecx,%eax
  800f3b:	8a 00                	mov    (%eax),%al
  800f3d:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800f3f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800f42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f45:	01 c2                	add    %eax,%edx
  800f47:	8a 45 eb             	mov    -0x15(%ebp),%al
  800f4a:	88 02                	mov    %al,(%edx)
		start++ ;
  800f4c:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800f4f:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800f52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f55:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f58:	7c c4                	jl     800f1e <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800f5a:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800f5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f60:	01 d0                	add    %edx,%eax
  800f62:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800f65:	90                   	nop
  800f66:	c9                   	leave  
  800f67:	c3                   	ret    

00800f68 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800f68:	55                   	push   %ebp
  800f69:	89 e5                	mov    %esp,%ebp
  800f6b:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800f6e:	ff 75 08             	pushl  0x8(%ebp)
  800f71:	e8 54 fa ff ff       	call   8009ca <strlen>
  800f76:	83 c4 04             	add    $0x4,%esp
  800f79:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800f7c:	ff 75 0c             	pushl  0xc(%ebp)
  800f7f:	e8 46 fa ff ff       	call   8009ca <strlen>
  800f84:	83 c4 04             	add    $0x4,%esp
  800f87:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800f8a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800f91:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f98:	eb 17                	jmp    800fb1 <strcconcat+0x49>
		final[s] = str1[s] ;
  800f9a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f9d:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa0:	01 c2                	add    %eax,%edx
  800fa2:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa8:	01 c8                	add    %ecx,%eax
  800faa:	8a 00                	mov    (%eax),%al
  800fac:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800fae:	ff 45 fc             	incl   -0x4(%ebp)
  800fb1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fb4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800fb7:	7c e1                	jl     800f9a <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800fb9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800fc0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800fc7:	eb 1f                	jmp    800fe8 <strcconcat+0x80>
		final[s++] = str2[i] ;
  800fc9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fcc:	8d 50 01             	lea    0x1(%eax),%edx
  800fcf:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800fd2:	89 c2                	mov    %eax,%edx
  800fd4:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd7:	01 c2                	add    %eax,%edx
  800fd9:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800fdc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fdf:	01 c8                	add    %ecx,%eax
  800fe1:	8a 00                	mov    (%eax),%al
  800fe3:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800fe5:	ff 45 f8             	incl   -0x8(%ebp)
  800fe8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800feb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800fee:	7c d9                	jl     800fc9 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800ff0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ff3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff6:	01 d0                	add    %edx,%eax
  800ff8:	c6 00 00             	movb   $0x0,(%eax)
}
  800ffb:	90                   	nop
  800ffc:	c9                   	leave  
  800ffd:	c3                   	ret    

00800ffe <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  800ffe:	55                   	push   %ebp
  800fff:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801001:	8b 45 14             	mov    0x14(%ebp),%eax
  801004:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80100a:	8b 45 14             	mov    0x14(%ebp),%eax
  80100d:	8b 00                	mov    (%eax),%eax
  80100f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801016:	8b 45 10             	mov    0x10(%ebp),%eax
  801019:	01 d0                	add    %edx,%eax
  80101b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801021:	eb 0c                	jmp    80102f <strsplit+0x31>
			*string++ = 0;
  801023:	8b 45 08             	mov    0x8(%ebp),%eax
  801026:	8d 50 01             	lea    0x1(%eax),%edx
  801029:	89 55 08             	mov    %edx,0x8(%ebp)
  80102c:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80102f:	8b 45 08             	mov    0x8(%ebp),%eax
  801032:	8a 00                	mov    (%eax),%al
  801034:	84 c0                	test   %al,%al
  801036:	74 18                	je     801050 <strsplit+0x52>
  801038:	8b 45 08             	mov    0x8(%ebp),%eax
  80103b:	8a 00                	mov    (%eax),%al
  80103d:	0f be c0             	movsbl %al,%eax
  801040:	50                   	push   %eax
  801041:	ff 75 0c             	pushl  0xc(%ebp)
  801044:	e8 13 fb ff ff       	call   800b5c <strchr>
  801049:	83 c4 08             	add    $0x8,%esp
  80104c:	85 c0                	test   %eax,%eax
  80104e:	75 d3                	jne    801023 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801050:	8b 45 08             	mov    0x8(%ebp),%eax
  801053:	8a 00                	mov    (%eax),%al
  801055:	84 c0                	test   %al,%al
  801057:	74 5a                	je     8010b3 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801059:	8b 45 14             	mov    0x14(%ebp),%eax
  80105c:	8b 00                	mov    (%eax),%eax
  80105e:	83 f8 0f             	cmp    $0xf,%eax
  801061:	75 07                	jne    80106a <strsplit+0x6c>
		{
			return 0;
  801063:	b8 00 00 00 00       	mov    $0x0,%eax
  801068:	eb 66                	jmp    8010d0 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80106a:	8b 45 14             	mov    0x14(%ebp),%eax
  80106d:	8b 00                	mov    (%eax),%eax
  80106f:	8d 48 01             	lea    0x1(%eax),%ecx
  801072:	8b 55 14             	mov    0x14(%ebp),%edx
  801075:	89 0a                	mov    %ecx,(%edx)
  801077:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80107e:	8b 45 10             	mov    0x10(%ebp),%eax
  801081:	01 c2                	add    %eax,%edx
  801083:	8b 45 08             	mov    0x8(%ebp),%eax
  801086:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801088:	eb 03                	jmp    80108d <strsplit+0x8f>
			string++;
  80108a:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80108d:	8b 45 08             	mov    0x8(%ebp),%eax
  801090:	8a 00                	mov    (%eax),%al
  801092:	84 c0                	test   %al,%al
  801094:	74 8b                	je     801021 <strsplit+0x23>
  801096:	8b 45 08             	mov    0x8(%ebp),%eax
  801099:	8a 00                	mov    (%eax),%al
  80109b:	0f be c0             	movsbl %al,%eax
  80109e:	50                   	push   %eax
  80109f:	ff 75 0c             	pushl  0xc(%ebp)
  8010a2:	e8 b5 fa ff ff       	call   800b5c <strchr>
  8010a7:	83 c4 08             	add    $0x8,%esp
  8010aa:	85 c0                	test   %eax,%eax
  8010ac:	74 dc                	je     80108a <strsplit+0x8c>
			string++;
	}
  8010ae:	e9 6e ff ff ff       	jmp    801021 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8010b3:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8010b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8010b7:	8b 00                	mov    (%eax),%eax
  8010b9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8010c3:	01 d0                	add    %edx,%eax
  8010c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8010cb:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8010d0:	c9                   	leave  
  8010d1:	c3                   	ret    

008010d2 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8010d2:	55                   	push   %ebp
  8010d3:	89 e5                	mov    %esp,%ebp
  8010d5:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8010d8:	a1 04 40 80 00       	mov    0x804004,%eax
  8010dd:	85 c0                	test   %eax,%eax
  8010df:	74 1f                	je     801100 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8010e1:	e8 1d 00 00 00       	call   801103 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8010e6:	83 ec 0c             	sub    $0xc,%esp
  8010e9:	68 50 37 80 00       	push   $0x803750
  8010ee:	e8 55 f2 ff ff       	call   800348 <cprintf>
  8010f3:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8010f6:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8010fd:	00 00 00 
	}
}
  801100:	90                   	nop
  801101:	c9                   	leave  
  801102:	c3                   	ret    

00801103 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801103:	55                   	push   %ebp
  801104:	89 e5                	mov    %esp,%ebp
  801106:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");
LIST_INIT(&AllocMemBlocksList);
  801109:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801110:	00 00 00 
  801113:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80111a:	00 00 00 
  80111d:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801124:	00 00 00 
LIST_INIT(&FreeMemBlocksList);
  801127:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  80112e:	00 00 00 
  801131:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801138:	00 00 00 
  80113b:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801142:	00 00 00 
MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  801145:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  80114c:	00 02 00 
uint32 requiredSpace=sizeof(struct MemBlock)*NUM_OF_UHEAP_PAGES;
  80114f:	c7 45 f4 00 00 20 00 	movl   $0x200000,-0xc(%ebp)
		MemBlockNodes=(struct MemBlock*)USER_DYN_BLKS_ARRAY;
  801156:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  80115d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801160:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801165:	2d 00 10 00 00       	sub    $0x1000,%eax
  80116a:	a3 50 40 80 00       	mov    %eax,0x804050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,requiredSpace,PERM_WRITEABLE|PERM_USER);
  80116f:	c7 45 ec 00 00 e0 7f 	movl   $0x7fe00000,-0x14(%ebp)
  801176:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801179:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80117e:	2d 00 10 00 00       	sub    $0x1000,%eax
  801183:	83 ec 04             	sub    $0x4,%esp
  801186:	6a 06                	push   $0x6
  801188:	ff 75 f4             	pushl  -0xc(%ebp)
  80118b:	50                   	push   %eax
  80118c:	e8 ee 05 00 00       	call   80177f <sys_allocate_chunk>
  801191:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801194:	a1 20 41 80 00       	mov    0x804120,%eax
  801199:	83 ec 0c             	sub    $0xc,%esp
  80119c:	50                   	push   %eax
  80119d:	e8 63 0c 00 00       	call   801e05 <initialize_MemBlocksList>
  8011a2:	83 c4 10             	add    $0x10,%esp
			struct MemBlock *freeSva=AvailableMemBlocksList.lh_last;
  8011a5:	a1 4c 41 80 00       	mov    0x80414c,%eax
  8011aa:	89 45 e8             	mov    %eax,-0x18(%ebp)
			freeSva->size=USER_HEAP_MAX-USER_HEAP_START;
  8011ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8011b0:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
			freeSva->size=ROUNDDOWN(freeSva->size,PAGE_SIZE);
  8011b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8011ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8011bd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8011c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011c3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011c8:	89 c2                	mov    %eax,%edx
  8011ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8011cd:	89 50 0c             	mov    %edx,0xc(%eax)

			freeSva->sva=USER_HEAP_START;
  8011d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8011d3:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
			freeSva->sva=ROUNDUP(freeSva->sva,PAGE_SIZE);
  8011da:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8011e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8011e4:	8b 50 08             	mov    0x8(%eax),%edx
  8011e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011ea:	01 d0                	add    %edx,%eax
  8011ec:	48                   	dec    %eax
  8011ed:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8011f0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8011f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8011f8:	f7 75 e0             	divl   -0x20(%ebp)
  8011fb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8011fe:	29 d0                	sub    %edx,%eax
  801200:	89 c2                	mov    %eax,%edx
  801202:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801205:	89 50 08             	mov    %edx,0x8(%eax)




			LIST_REMOVE(&AvailableMemBlocksList,freeSva);
  801208:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80120c:	75 14                	jne    801222 <initialize_dyn_block_system+0x11f>
  80120e:	83 ec 04             	sub    $0x4,%esp
  801211:	68 75 37 80 00       	push   $0x803775
  801216:	6a 34                	push   $0x34
  801218:	68 93 37 80 00       	push   $0x803793
  80121d:	e8 47 1c 00 00       	call   802e69 <_panic>
  801222:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801225:	8b 00                	mov    (%eax),%eax
  801227:	85 c0                	test   %eax,%eax
  801229:	74 10                	je     80123b <initialize_dyn_block_system+0x138>
  80122b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80122e:	8b 00                	mov    (%eax),%eax
  801230:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801233:	8b 52 04             	mov    0x4(%edx),%edx
  801236:	89 50 04             	mov    %edx,0x4(%eax)
  801239:	eb 0b                	jmp    801246 <initialize_dyn_block_system+0x143>
  80123b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80123e:	8b 40 04             	mov    0x4(%eax),%eax
  801241:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801246:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801249:	8b 40 04             	mov    0x4(%eax),%eax
  80124c:	85 c0                	test   %eax,%eax
  80124e:	74 0f                	je     80125f <initialize_dyn_block_system+0x15c>
  801250:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801253:	8b 40 04             	mov    0x4(%eax),%eax
  801256:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801259:	8b 12                	mov    (%edx),%edx
  80125b:	89 10                	mov    %edx,(%eax)
  80125d:	eb 0a                	jmp    801269 <initialize_dyn_block_system+0x166>
  80125f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801262:	8b 00                	mov    (%eax),%eax
  801264:	a3 48 41 80 00       	mov    %eax,0x804148
  801269:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80126c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801272:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801275:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80127c:	a1 54 41 80 00       	mov    0x804154,%eax
  801281:	48                   	dec    %eax
  801282:	a3 54 41 80 00       	mov    %eax,0x804154
			insert_sorted_with_merge_freeList(freeSva);
  801287:	83 ec 0c             	sub    $0xc,%esp
  80128a:	ff 75 e8             	pushl  -0x18(%ebp)
  80128d:	e8 c4 13 00 00       	call   802656 <insert_sorted_with_merge_freeList>
  801292:	83 c4 10             	add    $0x10,%esp
//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801295:	90                   	nop
  801296:	c9                   	leave  
  801297:	c3                   	ret    

00801298 <malloc>:
//=================================



void* malloc(uint32 size)
{
  801298:	55                   	push   %ebp
  801299:	89 e5                	mov    %esp,%ebp
  80129b:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80129e:	e8 2f fe ff ff       	call   8010d2 <InitializeUHeap>
	if (size == 0) return NULL ;
  8012a3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012a7:	75 07                	jne    8012b0 <malloc+0x18>
  8012a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8012ae:	eb 71                	jmp    801321 <malloc+0x89>
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");
if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  8012b0:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  8012b7:	76 07                	jbe    8012c0 <malloc+0x28>
	return NULL;
  8012b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8012be:	eb 61                	jmp    801321 <malloc+0x89>

	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8012c0:	e8 88 08 00 00       	call   801b4d <sys_isUHeapPlacementStrategyFIRSTFIT>
  8012c5:	85 c0                	test   %eax,%eax
  8012c7:	74 53                	je     80131c <malloc+0x84>
	        {
		struct MemBlock *returned_block;
		uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  8012c9:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8012d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8012d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012d6:	01 d0                	add    %edx,%eax
  8012d8:	48                   	dec    %eax
  8012d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8012dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012df:	ba 00 00 00 00       	mov    $0x0,%edx
  8012e4:	f7 75 f4             	divl   -0xc(%ebp)
  8012e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012ea:	29 d0                	sub    %edx,%eax
  8012ec:	89 45 ec             	mov    %eax,-0x14(%ebp)
   returned_block=alloc_block_FF(newSize);
  8012ef:	83 ec 0c             	sub    $0xc,%esp
  8012f2:	ff 75 ec             	pushl  -0x14(%ebp)
  8012f5:	e8 d2 0d 00 00       	call   8020cc <alloc_block_FF>
  8012fa:	83 c4 10             	add    $0x10,%esp
  8012fd:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(returned_block!=NULL)
  801300:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801304:	74 16                	je     80131c <malloc+0x84>
    {
    	insert_sorted_allocList(returned_block);
  801306:	83 ec 0c             	sub    $0xc,%esp
  801309:	ff 75 e8             	pushl  -0x18(%ebp)
  80130c:	e8 0c 0c 00 00       	call   801f1d <insert_sorted_allocList>
  801311:	83 c4 10             	add    $0x10,%esp
	return(void*) returned_block->sva;
  801314:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801317:	8b 40 08             	mov    0x8(%eax),%eax
  80131a:	eb 05                	jmp    801321 <malloc+0x89>
    }

			}


	return NULL;
  80131c:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801321:	c9                   	leave  
  801322:	c3                   	ret    

00801323 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801323:	55                   	push   %ebp
  801324:	89 e5                	mov    %esp,%ebp
  801326:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//you should get the size of the given allocation using its address
	uint32 va=ROUNDDOWN((uint32)virtual_address,PAGE_SIZE);
  801329:	8b 45 08             	mov    0x8(%ebp),%eax
  80132c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80132f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801332:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801337:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *returned_block=find_block(&AllocMemBlocksList,va);
  80133a:	83 ec 08             	sub    $0x8,%esp
  80133d:	ff 75 f0             	pushl  -0x10(%ebp)
  801340:	68 40 40 80 00       	push   $0x804040
  801345:	e8 a0 0b 00 00       	call   801eea <find_block>
  80134a:	83 c4 10             	add    $0x10,%esp
  80134d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_free_user_mem((uint32)virtual_address,returned_block->size);
  801350:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801353:	8b 50 0c             	mov    0xc(%eax),%edx
  801356:	8b 45 08             	mov    0x8(%ebp),%eax
  801359:	83 ec 08             	sub    $0x8,%esp
  80135c:	52                   	push   %edx
  80135d:	50                   	push   %eax
  80135e:	e8 e4 03 00 00       	call   801747 <sys_free_user_mem>
  801363:	83 c4 10             	add    $0x10,%esp

    LIST_REMOVE(&AllocMemBlocksList,returned_block);
  801366:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80136a:	75 17                	jne    801383 <free+0x60>
  80136c:	83 ec 04             	sub    $0x4,%esp
  80136f:	68 75 37 80 00       	push   $0x803775
  801374:	68 84 00 00 00       	push   $0x84
  801379:	68 93 37 80 00       	push   $0x803793
  80137e:	e8 e6 1a 00 00       	call   802e69 <_panic>
  801383:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801386:	8b 00                	mov    (%eax),%eax
  801388:	85 c0                	test   %eax,%eax
  80138a:	74 10                	je     80139c <free+0x79>
  80138c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80138f:	8b 00                	mov    (%eax),%eax
  801391:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801394:	8b 52 04             	mov    0x4(%edx),%edx
  801397:	89 50 04             	mov    %edx,0x4(%eax)
  80139a:	eb 0b                	jmp    8013a7 <free+0x84>
  80139c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80139f:	8b 40 04             	mov    0x4(%eax),%eax
  8013a2:	a3 44 40 80 00       	mov    %eax,0x804044
  8013a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013aa:	8b 40 04             	mov    0x4(%eax),%eax
  8013ad:	85 c0                	test   %eax,%eax
  8013af:	74 0f                	je     8013c0 <free+0x9d>
  8013b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013b4:	8b 40 04             	mov    0x4(%eax),%eax
  8013b7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013ba:	8b 12                	mov    (%edx),%edx
  8013bc:	89 10                	mov    %edx,(%eax)
  8013be:	eb 0a                	jmp    8013ca <free+0xa7>
  8013c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013c3:	8b 00                	mov    (%eax),%eax
  8013c5:	a3 40 40 80 00       	mov    %eax,0x804040
  8013ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8013d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013d6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8013dd:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8013e2:	48                   	dec    %eax
  8013e3:	a3 4c 40 80 00       	mov    %eax,0x80404c
	insert_sorted_with_merge_freeList(returned_block);
  8013e8:	83 ec 0c             	sub    $0xc,%esp
  8013eb:	ff 75 ec             	pushl  -0x14(%ebp)
  8013ee:	e8 63 12 00 00       	call   802656 <insert_sorted_with_merge_freeList>
  8013f3:	83 c4 10             	add    $0x10,%esp

	//you need to call sys_free_user_mem()
}
  8013f6:	90                   	nop
  8013f7:	c9                   	leave  
  8013f8:	c3                   	ret    

008013f9 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8013f9:	55                   	push   %ebp
  8013fa:	89 e5                	mov    %esp,%ebp
  8013fc:	83 ec 38             	sub    $0x38,%esp
  8013ff:	8b 45 10             	mov    0x10(%ebp),%eax
  801402:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801405:	e8 c8 fc ff ff       	call   8010d2 <InitializeUHeap>
	if (size == 0) return NULL ;
  80140a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80140e:	75 0a                	jne    80141a <smalloc+0x21>
  801410:	b8 00 00 00 00       	mov    $0x0,%eax
  801415:	e9 a0 00 00 00       	jmp    8014ba <smalloc+0xc1>
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	// Steps:
	//	1) Implement FIRST FIT strategy to search the heap for suitable space
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  80141a:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  801421:	76 0a                	jbe    80142d <smalloc+0x34>
		return NULL;
  801423:	b8 00 00 00 00       	mov    $0x0,%eax
  801428:	e9 8d 00 00 00       	jmp    8014ba <smalloc+0xc1>

		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80142d:	e8 1b 07 00 00       	call   801b4d <sys_isUHeapPlacementStrategyFIRSTFIT>
  801432:	85 c0                	test   %eax,%eax
  801434:	74 7f                	je     8014b5 <smalloc+0xbc>
		        {
			struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801436:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80143d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801440:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801443:	01 d0                	add    %edx,%eax
  801445:	48                   	dec    %eax
  801446:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801449:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80144c:	ba 00 00 00 00       	mov    $0x0,%edx
  801451:	f7 75 f4             	divl   -0xc(%ebp)
  801454:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801457:	29 d0                	sub    %edx,%eax
  801459:	89 45 ec             	mov    %eax,-0x14(%ebp)
	   returned_block=alloc_block_FF(newSize);
  80145c:	83 ec 0c             	sub    $0xc,%esp
  80145f:	ff 75 ec             	pushl  -0x14(%ebp)
  801462:	e8 65 0c 00 00       	call   8020cc <alloc_block_FF>
  801467:	83 c4 10             	add    $0x10,%esp
  80146a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   if(returned_block!=NULL)
  80146d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801471:	74 42                	je     8014b5 <smalloc+0xbc>
	      {
	      	   insert_sorted_allocList(returned_block);
  801473:	83 ec 0c             	sub    $0xc,%esp
  801476:	ff 75 e8             	pushl  -0x18(%ebp)
  801479:	e8 9f 0a 00 00       	call   801f1d <insert_sorted_allocList>
  80147e:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_createSharedObject(sharedVarName,size,isWritable,(void*)returned_block->sva);
  801481:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801484:	8b 40 08             	mov    0x8(%eax),%eax
  801487:	89 c2                	mov    %eax,%edx
  801489:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  80148d:	52                   	push   %edx
  80148e:	50                   	push   %eax
  80148f:	ff 75 0c             	pushl  0xc(%ebp)
  801492:	ff 75 08             	pushl  0x8(%ebp)
  801495:	e8 38 04 00 00       	call   8018d2 <sys_createSharedObject>
  80149a:	83 c4 10             	add    $0x10,%esp
  80149d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    	     if(ID<0)
  8014a0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8014a4:	79 07                	jns    8014ad <smalloc+0xb4>
	    		  return NULL;
  8014a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8014ab:	eb 0d                	jmp    8014ba <smalloc+0xc1>
	  	return(void*) returned_block->sva;
  8014ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014b0:	8b 40 08             	mov    0x8(%eax),%eax
  8014b3:	eb 05                	jmp    8014ba <smalloc+0xc1>


				}


		return NULL;
  8014b5:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8014ba:	c9                   	leave  
  8014bb:	c3                   	ret    

008014bc <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8014bc:	55                   	push   %ebp
  8014bd:	89 e5                	mov    %esp,%ebp
  8014bf:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8014c2:	e8 0b fc ff ff       	call   8010d2 <InitializeUHeap>
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	// Steps:
	//	1) Get the size of the shared variable (use sys_getSizeOfSharedObject())
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  8014c7:	e8 81 06 00 00       	call   801b4d <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014cc:	85 c0                	test   %eax,%eax
  8014ce:	0f 84 9f 00 00 00    	je     801573 <sget+0xb7>
	int size=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8014d4:	83 ec 08             	sub    $0x8,%esp
  8014d7:	ff 75 0c             	pushl  0xc(%ebp)
  8014da:	ff 75 08             	pushl  0x8(%ebp)
  8014dd:	e8 1a 04 00 00       	call   8018fc <sys_getSizeOfSharedObject>
  8014e2:	83 c4 10             	add    $0x10,%esp
  8014e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size<0)
  8014e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8014ec:	79 0a                	jns    8014f8 <sget+0x3c>
		return NULL;
  8014ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8014f3:	e9 80 00 00 00       	jmp    801578 <sget+0xbc>
	struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  8014f8:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8014ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801502:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801505:	01 d0                	add    %edx,%eax
  801507:	48                   	dec    %eax
  801508:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80150b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80150e:	ba 00 00 00 00       	mov    $0x0,%edx
  801513:	f7 75 f0             	divl   -0x10(%ebp)
  801516:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801519:	29 d0                	sub    %edx,%eax
  80151b:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   returned_block=alloc_block_FF(newSize);
  80151e:	83 ec 0c             	sub    $0xc,%esp
  801521:	ff 75 e8             	pushl  -0x18(%ebp)
  801524:	e8 a3 0b 00 00       	call   8020cc <alloc_block_FF>
  801529:	83 c4 10             	add    $0x10,%esp
  80152c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	   if(returned_block!=NULL)
  80152f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801533:	74 3e                	je     801573 <sget+0xb7>
	      {
	      	   insert_sorted_allocList(returned_block);
  801535:	83 ec 0c             	sub    $0xc,%esp
  801538:	ff 75 e4             	pushl  -0x1c(%ebp)
  80153b:	e8 dd 09 00 00       	call   801f1d <insert_sorted_allocList>
  801540:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)returned_block->sva);
  801543:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801546:	8b 40 08             	mov    0x8(%eax),%eax
  801549:	83 ec 04             	sub    $0x4,%esp
  80154c:	50                   	push   %eax
  80154d:	ff 75 0c             	pushl  0xc(%ebp)
  801550:	ff 75 08             	pushl  0x8(%ebp)
  801553:	e8 c1 03 00 00       	call   801919 <sys_getSharedObject>
  801558:	83 c4 10             	add    $0x10,%esp
  80155b:	89 45 e0             	mov    %eax,-0x20(%ebp)
	    	     if(ID<0)
  80155e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801562:	79 07                	jns    80156b <sget+0xaf>
	    		  return NULL;
  801564:	b8 00 00 00 00       	mov    $0x0,%eax
  801569:	eb 0d                	jmp    801578 <sget+0xbc>
	  	return(void*) returned_block->sva;
  80156b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80156e:	8b 40 08             	mov    0x8(%eax),%eax
  801571:	eb 05                	jmp    801578 <sget+0xbc>
	      }
	}
	   return NULL;
  801573:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801578:	c9                   	leave  
  801579:	c3                   	ret    

0080157a <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80157a:	55                   	push   %ebp
  80157b:	89 e5                	mov    %esp,%ebp
  80157d:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801580:	e8 4d fb ff ff       	call   8010d2 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801585:	83 ec 04             	sub    $0x4,%esp
  801588:	68 a0 37 80 00       	push   $0x8037a0
  80158d:	68 12 01 00 00       	push   $0x112
  801592:	68 93 37 80 00       	push   $0x803793
  801597:	e8 cd 18 00 00       	call   802e69 <_panic>

0080159c <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80159c:	55                   	push   %ebp
  80159d:	89 e5                	mov    %esp,%ebp
  80159f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8015a2:	83 ec 04             	sub    $0x4,%esp
  8015a5:	68 c8 37 80 00       	push   $0x8037c8
  8015aa:	68 26 01 00 00       	push   $0x126
  8015af:	68 93 37 80 00       	push   $0x803793
  8015b4:	e8 b0 18 00 00       	call   802e69 <_panic>

008015b9 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8015b9:	55                   	push   %ebp
  8015ba:	89 e5                	mov    %esp,%ebp
  8015bc:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015bf:	83 ec 04             	sub    $0x4,%esp
  8015c2:	68 ec 37 80 00       	push   $0x8037ec
  8015c7:	68 31 01 00 00       	push   $0x131
  8015cc:	68 93 37 80 00       	push   $0x803793
  8015d1:	e8 93 18 00 00       	call   802e69 <_panic>

008015d6 <shrink>:

}
void shrink(uint32 newSize)
{
  8015d6:	55                   	push   %ebp
  8015d7:	89 e5                	mov    %esp,%ebp
  8015d9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015dc:	83 ec 04             	sub    $0x4,%esp
  8015df:	68 ec 37 80 00       	push   $0x8037ec
  8015e4:	68 36 01 00 00       	push   $0x136
  8015e9:	68 93 37 80 00       	push   $0x803793
  8015ee:	e8 76 18 00 00       	call   802e69 <_panic>

008015f3 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8015f3:	55                   	push   %ebp
  8015f4:	89 e5                	mov    %esp,%ebp
  8015f6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015f9:	83 ec 04             	sub    $0x4,%esp
  8015fc:	68 ec 37 80 00       	push   $0x8037ec
  801601:	68 3b 01 00 00       	push   $0x13b
  801606:	68 93 37 80 00       	push   $0x803793
  80160b:	e8 59 18 00 00       	call   802e69 <_panic>

00801610 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801610:	55                   	push   %ebp
  801611:	89 e5                	mov    %esp,%ebp
  801613:	57                   	push   %edi
  801614:	56                   	push   %esi
  801615:	53                   	push   %ebx
  801616:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801619:	8b 45 08             	mov    0x8(%ebp),%eax
  80161c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80161f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801622:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801625:	8b 7d 18             	mov    0x18(%ebp),%edi
  801628:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80162b:	cd 30                	int    $0x30
  80162d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801630:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801633:	83 c4 10             	add    $0x10,%esp
  801636:	5b                   	pop    %ebx
  801637:	5e                   	pop    %esi
  801638:	5f                   	pop    %edi
  801639:	5d                   	pop    %ebp
  80163a:	c3                   	ret    

0080163b <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80163b:	55                   	push   %ebp
  80163c:	89 e5                	mov    %esp,%ebp
  80163e:	83 ec 04             	sub    $0x4,%esp
  801641:	8b 45 10             	mov    0x10(%ebp),%eax
  801644:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801647:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80164b:	8b 45 08             	mov    0x8(%ebp),%eax
  80164e:	6a 00                	push   $0x0
  801650:	6a 00                	push   $0x0
  801652:	52                   	push   %edx
  801653:	ff 75 0c             	pushl  0xc(%ebp)
  801656:	50                   	push   %eax
  801657:	6a 00                	push   $0x0
  801659:	e8 b2 ff ff ff       	call   801610 <syscall>
  80165e:	83 c4 18             	add    $0x18,%esp
}
  801661:	90                   	nop
  801662:	c9                   	leave  
  801663:	c3                   	ret    

00801664 <sys_cgetc>:

int
sys_cgetc(void)
{
  801664:	55                   	push   %ebp
  801665:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801667:	6a 00                	push   $0x0
  801669:	6a 00                	push   $0x0
  80166b:	6a 00                	push   $0x0
  80166d:	6a 00                	push   $0x0
  80166f:	6a 00                	push   $0x0
  801671:	6a 01                	push   $0x1
  801673:	e8 98 ff ff ff       	call   801610 <syscall>
  801678:	83 c4 18             	add    $0x18,%esp
}
  80167b:	c9                   	leave  
  80167c:	c3                   	ret    

0080167d <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80167d:	55                   	push   %ebp
  80167e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801680:	8b 55 0c             	mov    0xc(%ebp),%edx
  801683:	8b 45 08             	mov    0x8(%ebp),%eax
  801686:	6a 00                	push   $0x0
  801688:	6a 00                	push   $0x0
  80168a:	6a 00                	push   $0x0
  80168c:	52                   	push   %edx
  80168d:	50                   	push   %eax
  80168e:	6a 05                	push   $0x5
  801690:	e8 7b ff ff ff       	call   801610 <syscall>
  801695:	83 c4 18             	add    $0x18,%esp
}
  801698:	c9                   	leave  
  801699:	c3                   	ret    

0080169a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80169a:	55                   	push   %ebp
  80169b:	89 e5                	mov    %esp,%ebp
  80169d:	56                   	push   %esi
  80169e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80169f:	8b 75 18             	mov    0x18(%ebp),%esi
  8016a2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016a5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ae:	56                   	push   %esi
  8016af:	53                   	push   %ebx
  8016b0:	51                   	push   %ecx
  8016b1:	52                   	push   %edx
  8016b2:	50                   	push   %eax
  8016b3:	6a 06                	push   $0x6
  8016b5:	e8 56 ff ff ff       	call   801610 <syscall>
  8016ba:	83 c4 18             	add    $0x18,%esp
}
  8016bd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016c0:	5b                   	pop    %ebx
  8016c1:	5e                   	pop    %esi
  8016c2:	5d                   	pop    %ebp
  8016c3:	c3                   	ret    

008016c4 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8016c4:	55                   	push   %ebp
  8016c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8016c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cd:	6a 00                	push   $0x0
  8016cf:	6a 00                	push   $0x0
  8016d1:	6a 00                	push   $0x0
  8016d3:	52                   	push   %edx
  8016d4:	50                   	push   %eax
  8016d5:	6a 07                	push   $0x7
  8016d7:	e8 34 ff ff ff       	call   801610 <syscall>
  8016dc:	83 c4 18             	add    $0x18,%esp
}
  8016df:	c9                   	leave  
  8016e0:	c3                   	ret    

008016e1 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8016e1:	55                   	push   %ebp
  8016e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8016e4:	6a 00                	push   $0x0
  8016e6:	6a 00                	push   $0x0
  8016e8:	6a 00                	push   $0x0
  8016ea:	ff 75 0c             	pushl  0xc(%ebp)
  8016ed:	ff 75 08             	pushl  0x8(%ebp)
  8016f0:	6a 08                	push   $0x8
  8016f2:	e8 19 ff ff ff       	call   801610 <syscall>
  8016f7:	83 c4 18             	add    $0x18,%esp
}
  8016fa:	c9                   	leave  
  8016fb:	c3                   	ret    

008016fc <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8016fc:	55                   	push   %ebp
  8016fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8016ff:	6a 00                	push   $0x0
  801701:	6a 00                	push   $0x0
  801703:	6a 00                	push   $0x0
  801705:	6a 00                	push   $0x0
  801707:	6a 00                	push   $0x0
  801709:	6a 09                	push   $0x9
  80170b:	e8 00 ff ff ff       	call   801610 <syscall>
  801710:	83 c4 18             	add    $0x18,%esp
}
  801713:	c9                   	leave  
  801714:	c3                   	ret    

00801715 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801715:	55                   	push   %ebp
  801716:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801718:	6a 00                	push   $0x0
  80171a:	6a 00                	push   $0x0
  80171c:	6a 00                	push   $0x0
  80171e:	6a 00                	push   $0x0
  801720:	6a 00                	push   $0x0
  801722:	6a 0a                	push   $0xa
  801724:	e8 e7 fe ff ff       	call   801610 <syscall>
  801729:	83 c4 18             	add    $0x18,%esp
}
  80172c:	c9                   	leave  
  80172d:	c3                   	ret    

0080172e <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80172e:	55                   	push   %ebp
  80172f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801731:	6a 00                	push   $0x0
  801733:	6a 00                	push   $0x0
  801735:	6a 00                	push   $0x0
  801737:	6a 00                	push   $0x0
  801739:	6a 00                	push   $0x0
  80173b:	6a 0b                	push   $0xb
  80173d:	e8 ce fe ff ff       	call   801610 <syscall>
  801742:	83 c4 18             	add    $0x18,%esp
}
  801745:	c9                   	leave  
  801746:	c3                   	ret    

00801747 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801747:	55                   	push   %ebp
  801748:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80174a:	6a 00                	push   $0x0
  80174c:	6a 00                	push   $0x0
  80174e:	6a 00                	push   $0x0
  801750:	ff 75 0c             	pushl  0xc(%ebp)
  801753:	ff 75 08             	pushl  0x8(%ebp)
  801756:	6a 0f                	push   $0xf
  801758:	e8 b3 fe ff ff       	call   801610 <syscall>
  80175d:	83 c4 18             	add    $0x18,%esp
	return;
  801760:	90                   	nop
}
  801761:	c9                   	leave  
  801762:	c3                   	ret    

00801763 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801763:	55                   	push   %ebp
  801764:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801766:	6a 00                	push   $0x0
  801768:	6a 00                	push   $0x0
  80176a:	6a 00                	push   $0x0
  80176c:	ff 75 0c             	pushl  0xc(%ebp)
  80176f:	ff 75 08             	pushl  0x8(%ebp)
  801772:	6a 10                	push   $0x10
  801774:	e8 97 fe ff ff       	call   801610 <syscall>
  801779:	83 c4 18             	add    $0x18,%esp
	return ;
  80177c:	90                   	nop
}
  80177d:	c9                   	leave  
  80177e:	c3                   	ret    

0080177f <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80177f:	55                   	push   %ebp
  801780:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801782:	6a 00                	push   $0x0
  801784:	6a 00                	push   $0x0
  801786:	ff 75 10             	pushl  0x10(%ebp)
  801789:	ff 75 0c             	pushl  0xc(%ebp)
  80178c:	ff 75 08             	pushl  0x8(%ebp)
  80178f:	6a 11                	push   $0x11
  801791:	e8 7a fe ff ff       	call   801610 <syscall>
  801796:	83 c4 18             	add    $0x18,%esp
	return ;
  801799:	90                   	nop
}
  80179a:	c9                   	leave  
  80179b:	c3                   	ret    

0080179c <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80179c:	55                   	push   %ebp
  80179d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80179f:	6a 00                	push   $0x0
  8017a1:	6a 00                	push   $0x0
  8017a3:	6a 00                	push   $0x0
  8017a5:	6a 00                	push   $0x0
  8017a7:	6a 00                	push   $0x0
  8017a9:	6a 0c                	push   $0xc
  8017ab:	e8 60 fe ff ff       	call   801610 <syscall>
  8017b0:	83 c4 18             	add    $0x18,%esp
}
  8017b3:	c9                   	leave  
  8017b4:	c3                   	ret    

008017b5 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8017b5:	55                   	push   %ebp
  8017b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8017b8:	6a 00                	push   $0x0
  8017ba:	6a 00                	push   $0x0
  8017bc:	6a 00                	push   $0x0
  8017be:	6a 00                	push   $0x0
  8017c0:	ff 75 08             	pushl  0x8(%ebp)
  8017c3:	6a 0d                	push   $0xd
  8017c5:	e8 46 fe ff ff       	call   801610 <syscall>
  8017ca:	83 c4 18             	add    $0x18,%esp
}
  8017cd:	c9                   	leave  
  8017ce:	c3                   	ret    

008017cf <sys_scarce_memory>:

void sys_scarce_memory()
{
  8017cf:	55                   	push   %ebp
  8017d0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8017d2:	6a 00                	push   $0x0
  8017d4:	6a 00                	push   $0x0
  8017d6:	6a 00                	push   $0x0
  8017d8:	6a 00                	push   $0x0
  8017da:	6a 00                	push   $0x0
  8017dc:	6a 0e                	push   $0xe
  8017de:	e8 2d fe ff ff       	call   801610 <syscall>
  8017e3:	83 c4 18             	add    $0x18,%esp
}
  8017e6:	90                   	nop
  8017e7:	c9                   	leave  
  8017e8:	c3                   	ret    

008017e9 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8017e9:	55                   	push   %ebp
  8017ea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8017ec:	6a 00                	push   $0x0
  8017ee:	6a 00                	push   $0x0
  8017f0:	6a 00                	push   $0x0
  8017f2:	6a 00                	push   $0x0
  8017f4:	6a 00                	push   $0x0
  8017f6:	6a 13                	push   $0x13
  8017f8:	e8 13 fe ff ff       	call   801610 <syscall>
  8017fd:	83 c4 18             	add    $0x18,%esp
}
  801800:	90                   	nop
  801801:	c9                   	leave  
  801802:	c3                   	ret    

00801803 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801803:	55                   	push   %ebp
  801804:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801806:	6a 00                	push   $0x0
  801808:	6a 00                	push   $0x0
  80180a:	6a 00                	push   $0x0
  80180c:	6a 00                	push   $0x0
  80180e:	6a 00                	push   $0x0
  801810:	6a 14                	push   $0x14
  801812:	e8 f9 fd ff ff       	call   801610 <syscall>
  801817:	83 c4 18             	add    $0x18,%esp
}
  80181a:	90                   	nop
  80181b:	c9                   	leave  
  80181c:	c3                   	ret    

0080181d <sys_cputc>:


void
sys_cputc(const char c)
{
  80181d:	55                   	push   %ebp
  80181e:	89 e5                	mov    %esp,%ebp
  801820:	83 ec 04             	sub    $0x4,%esp
  801823:	8b 45 08             	mov    0x8(%ebp),%eax
  801826:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801829:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80182d:	6a 00                	push   $0x0
  80182f:	6a 00                	push   $0x0
  801831:	6a 00                	push   $0x0
  801833:	6a 00                	push   $0x0
  801835:	50                   	push   %eax
  801836:	6a 15                	push   $0x15
  801838:	e8 d3 fd ff ff       	call   801610 <syscall>
  80183d:	83 c4 18             	add    $0x18,%esp
}
  801840:	90                   	nop
  801841:	c9                   	leave  
  801842:	c3                   	ret    

00801843 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801843:	55                   	push   %ebp
  801844:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801846:	6a 00                	push   $0x0
  801848:	6a 00                	push   $0x0
  80184a:	6a 00                	push   $0x0
  80184c:	6a 00                	push   $0x0
  80184e:	6a 00                	push   $0x0
  801850:	6a 16                	push   $0x16
  801852:	e8 b9 fd ff ff       	call   801610 <syscall>
  801857:	83 c4 18             	add    $0x18,%esp
}
  80185a:	90                   	nop
  80185b:	c9                   	leave  
  80185c:	c3                   	ret    

0080185d <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80185d:	55                   	push   %ebp
  80185e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801860:	8b 45 08             	mov    0x8(%ebp),%eax
  801863:	6a 00                	push   $0x0
  801865:	6a 00                	push   $0x0
  801867:	6a 00                	push   $0x0
  801869:	ff 75 0c             	pushl  0xc(%ebp)
  80186c:	50                   	push   %eax
  80186d:	6a 17                	push   $0x17
  80186f:	e8 9c fd ff ff       	call   801610 <syscall>
  801874:	83 c4 18             	add    $0x18,%esp
}
  801877:	c9                   	leave  
  801878:	c3                   	ret    

00801879 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801879:	55                   	push   %ebp
  80187a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80187c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80187f:	8b 45 08             	mov    0x8(%ebp),%eax
  801882:	6a 00                	push   $0x0
  801884:	6a 00                	push   $0x0
  801886:	6a 00                	push   $0x0
  801888:	52                   	push   %edx
  801889:	50                   	push   %eax
  80188a:	6a 1a                	push   $0x1a
  80188c:	e8 7f fd ff ff       	call   801610 <syscall>
  801891:	83 c4 18             	add    $0x18,%esp
}
  801894:	c9                   	leave  
  801895:	c3                   	ret    

00801896 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801896:	55                   	push   %ebp
  801897:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801899:	8b 55 0c             	mov    0xc(%ebp),%edx
  80189c:	8b 45 08             	mov    0x8(%ebp),%eax
  80189f:	6a 00                	push   $0x0
  8018a1:	6a 00                	push   $0x0
  8018a3:	6a 00                	push   $0x0
  8018a5:	52                   	push   %edx
  8018a6:	50                   	push   %eax
  8018a7:	6a 18                	push   $0x18
  8018a9:	e8 62 fd ff ff       	call   801610 <syscall>
  8018ae:	83 c4 18             	add    $0x18,%esp
}
  8018b1:	90                   	nop
  8018b2:	c9                   	leave  
  8018b3:	c3                   	ret    

008018b4 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8018b4:	55                   	push   %ebp
  8018b5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bd:	6a 00                	push   $0x0
  8018bf:	6a 00                	push   $0x0
  8018c1:	6a 00                	push   $0x0
  8018c3:	52                   	push   %edx
  8018c4:	50                   	push   %eax
  8018c5:	6a 19                	push   $0x19
  8018c7:	e8 44 fd ff ff       	call   801610 <syscall>
  8018cc:	83 c4 18             	add    $0x18,%esp
}
  8018cf:	90                   	nop
  8018d0:	c9                   	leave  
  8018d1:	c3                   	ret    

008018d2 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8018d2:	55                   	push   %ebp
  8018d3:	89 e5                	mov    %esp,%ebp
  8018d5:	83 ec 04             	sub    $0x4,%esp
  8018d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8018db:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8018de:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8018e1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e8:	6a 00                	push   $0x0
  8018ea:	51                   	push   %ecx
  8018eb:	52                   	push   %edx
  8018ec:	ff 75 0c             	pushl  0xc(%ebp)
  8018ef:	50                   	push   %eax
  8018f0:	6a 1b                	push   $0x1b
  8018f2:	e8 19 fd ff ff       	call   801610 <syscall>
  8018f7:	83 c4 18             	add    $0x18,%esp
}
  8018fa:	c9                   	leave  
  8018fb:	c3                   	ret    

008018fc <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8018fc:	55                   	push   %ebp
  8018fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8018ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801902:	8b 45 08             	mov    0x8(%ebp),%eax
  801905:	6a 00                	push   $0x0
  801907:	6a 00                	push   $0x0
  801909:	6a 00                	push   $0x0
  80190b:	52                   	push   %edx
  80190c:	50                   	push   %eax
  80190d:	6a 1c                	push   $0x1c
  80190f:	e8 fc fc ff ff       	call   801610 <syscall>
  801914:	83 c4 18             	add    $0x18,%esp
}
  801917:	c9                   	leave  
  801918:	c3                   	ret    

00801919 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801919:	55                   	push   %ebp
  80191a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80191c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80191f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801922:	8b 45 08             	mov    0x8(%ebp),%eax
  801925:	6a 00                	push   $0x0
  801927:	6a 00                	push   $0x0
  801929:	51                   	push   %ecx
  80192a:	52                   	push   %edx
  80192b:	50                   	push   %eax
  80192c:	6a 1d                	push   $0x1d
  80192e:	e8 dd fc ff ff       	call   801610 <syscall>
  801933:	83 c4 18             	add    $0x18,%esp
}
  801936:	c9                   	leave  
  801937:	c3                   	ret    

00801938 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801938:	55                   	push   %ebp
  801939:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80193b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80193e:	8b 45 08             	mov    0x8(%ebp),%eax
  801941:	6a 00                	push   $0x0
  801943:	6a 00                	push   $0x0
  801945:	6a 00                	push   $0x0
  801947:	52                   	push   %edx
  801948:	50                   	push   %eax
  801949:	6a 1e                	push   $0x1e
  80194b:	e8 c0 fc ff ff       	call   801610 <syscall>
  801950:	83 c4 18             	add    $0x18,%esp
}
  801953:	c9                   	leave  
  801954:	c3                   	ret    

00801955 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801955:	55                   	push   %ebp
  801956:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801958:	6a 00                	push   $0x0
  80195a:	6a 00                	push   $0x0
  80195c:	6a 00                	push   $0x0
  80195e:	6a 00                	push   $0x0
  801960:	6a 00                	push   $0x0
  801962:	6a 1f                	push   $0x1f
  801964:	e8 a7 fc ff ff       	call   801610 <syscall>
  801969:	83 c4 18             	add    $0x18,%esp
}
  80196c:	c9                   	leave  
  80196d:	c3                   	ret    

0080196e <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80196e:	55                   	push   %ebp
  80196f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801971:	8b 45 08             	mov    0x8(%ebp),%eax
  801974:	6a 00                	push   $0x0
  801976:	ff 75 14             	pushl  0x14(%ebp)
  801979:	ff 75 10             	pushl  0x10(%ebp)
  80197c:	ff 75 0c             	pushl  0xc(%ebp)
  80197f:	50                   	push   %eax
  801980:	6a 20                	push   $0x20
  801982:	e8 89 fc ff ff       	call   801610 <syscall>
  801987:	83 c4 18             	add    $0x18,%esp
}
  80198a:	c9                   	leave  
  80198b:	c3                   	ret    

0080198c <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80198c:	55                   	push   %ebp
  80198d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80198f:	8b 45 08             	mov    0x8(%ebp),%eax
  801992:	6a 00                	push   $0x0
  801994:	6a 00                	push   $0x0
  801996:	6a 00                	push   $0x0
  801998:	6a 00                	push   $0x0
  80199a:	50                   	push   %eax
  80199b:	6a 21                	push   $0x21
  80199d:	e8 6e fc ff ff       	call   801610 <syscall>
  8019a2:	83 c4 18             	add    $0x18,%esp
}
  8019a5:	90                   	nop
  8019a6:	c9                   	leave  
  8019a7:	c3                   	ret    

008019a8 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8019a8:	55                   	push   %ebp
  8019a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8019ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ae:	6a 00                	push   $0x0
  8019b0:	6a 00                	push   $0x0
  8019b2:	6a 00                	push   $0x0
  8019b4:	6a 00                	push   $0x0
  8019b6:	50                   	push   %eax
  8019b7:	6a 22                	push   $0x22
  8019b9:	e8 52 fc ff ff       	call   801610 <syscall>
  8019be:	83 c4 18             	add    $0x18,%esp
}
  8019c1:	c9                   	leave  
  8019c2:	c3                   	ret    

008019c3 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8019c3:	55                   	push   %ebp
  8019c4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8019c6:	6a 00                	push   $0x0
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 02                	push   $0x2
  8019d2:	e8 39 fc ff ff       	call   801610 <syscall>
  8019d7:	83 c4 18             	add    $0x18,%esp
}
  8019da:	c9                   	leave  
  8019db:	c3                   	ret    

008019dc <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8019dc:	55                   	push   %ebp
  8019dd:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 03                	push   $0x3
  8019eb:	e8 20 fc ff ff       	call   801610 <syscall>
  8019f0:	83 c4 18             	add    $0x18,%esp
}
  8019f3:	c9                   	leave  
  8019f4:	c3                   	ret    

008019f5 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8019f5:	55                   	push   %ebp
  8019f6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 00                	push   $0x0
  8019fe:	6a 00                	push   $0x0
  801a00:	6a 00                	push   $0x0
  801a02:	6a 04                	push   $0x4
  801a04:	e8 07 fc ff ff       	call   801610 <syscall>
  801a09:	83 c4 18             	add    $0x18,%esp
}
  801a0c:	c9                   	leave  
  801a0d:	c3                   	ret    

00801a0e <sys_exit_env>:


void sys_exit_env(void)
{
  801a0e:	55                   	push   %ebp
  801a0f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801a11:	6a 00                	push   $0x0
  801a13:	6a 00                	push   $0x0
  801a15:	6a 00                	push   $0x0
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 23                	push   $0x23
  801a1d:	e8 ee fb ff ff       	call   801610 <syscall>
  801a22:	83 c4 18             	add    $0x18,%esp
}
  801a25:	90                   	nop
  801a26:	c9                   	leave  
  801a27:	c3                   	ret    

00801a28 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801a28:	55                   	push   %ebp
  801a29:	89 e5                	mov    %esp,%ebp
  801a2b:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801a2e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a31:	8d 50 04             	lea    0x4(%eax),%edx
  801a34:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a37:	6a 00                	push   $0x0
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 00                	push   $0x0
  801a3d:	52                   	push   %edx
  801a3e:	50                   	push   %eax
  801a3f:	6a 24                	push   $0x24
  801a41:	e8 ca fb ff ff       	call   801610 <syscall>
  801a46:	83 c4 18             	add    $0x18,%esp
	return result;
  801a49:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a4c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a4f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a52:	89 01                	mov    %eax,(%ecx)
  801a54:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801a57:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5a:	c9                   	leave  
  801a5b:	c2 04 00             	ret    $0x4

00801a5e <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801a5e:	55                   	push   %ebp
  801a5f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801a61:	6a 00                	push   $0x0
  801a63:	6a 00                	push   $0x0
  801a65:	ff 75 10             	pushl  0x10(%ebp)
  801a68:	ff 75 0c             	pushl  0xc(%ebp)
  801a6b:	ff 75 08             	pushl  0x8(%ebp)
  801a6e:	6a 12                	push   $0x12
  801a70:	e8 9b fb ff ff       	call   801610 <syscall>
  801a75:	83 c4 18             	add    $0x18,%esp
	return ;
  801a78:	90                   	nop
}
  801a79:	c9                   	leave  
  801a7a:	c3                   	ret    

00801a7b <sys_rcr2>:
uint32 sys_rcr2()
{
  801a7b:	55                   	push   %ebp
  801a7c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	6a 00                	push   $0x0
  801a84:	6a 00                	push   $0x0
  801a86:	6a 00                	push   $0x0
  801a88:	6a 25                	push   $0x25
  801a8a:	e8 81 fb ff ff       	call   801610 <syscall>
  801a8f:	83 c4 18             	add    $0x18,%esp
}
  801a92:	c9                   	leave  
  801a93:	c3                   	ret    

00801a94 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801a94:	55                   	push   %ebp
  801a95:	89 e5                	mov    %esp,%ebp
  801a97:	83 ec 04             	sub    $0x4,%esp
  801a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801aa0:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801aa4:	6a 00                	push   $0x0
  801aa6:	6a 00                	push   $0x0
  801aa8:	6a 00                	push   $0x0
  801aaa:	6a 00                	push   $0x0
  801aac:	50                   	push   %eax
  801aad:	6a 26                	push   $0x26
  801aaf:	e8 5c fb ff ff       	call   801610 <syscall>
  801ab4:	83 c4 18             	add    $0x18,%esp
	return ;
  801ab7:	90                   	nop
}
  801ab8:	c9                   	leave  
  801ab9:	c3                   	ret    

00801aba <rsttst>:
void rsttst()
{
  801aba:	55                   	push   %ebp
  801abb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801abd:	6a 00                	push   $0x0
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 00                	push   $0x0
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 28                	push   $0x28
  801ac9:	e8 42 fb ff ff       	call   801610 <syscall>
  801ace:	83 c4 18             	add    $0x18,%esp
	return ;
  801ad1:	90                   	nop
}
  801ad2:	c9                   	leave  
  801ad3:	c3                   	ret    

00801ad4 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801ad4:	55                   	push   %ebp
  801ad5:	89 e5                	mov    %esp,%ebp
  801ad7:	83 ec 04             	sub    $0x4,%esp
  801ada:	8b 45 14             	mov    0x14(%ebp),%eax
  801add:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ae0:	8b 55 18             	mov    0x18(%ebp),%edx
  801ae3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ae7:	52                   	push   %edx
  801ae8:	50                   	push   %eax
  801ae9:	ff 75 10             	pushl  0x10(%ebp)
  801aec:	ff 75 0c             	pushl  0xc(%ebp)
  801aef:	ff 75 08             	pushl  0x8(%ebp)
  801af2:	6a 27                	push   $0x27
  801af4:	e8 17 fb ff ff       	call   801610 <syscall>
  801af9:	83 c4 18             	add    $0x18,%esp
	return ;
  801afc:	90                   	nop
}
  801afd:	c9                   	leave  
  801afe:	c3                   	ret    

00801aff <chktst>:
void chktst(uint32 n)
{
  801aff:	55                   	push   %ebp
  801b00:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801b02:	6a 00                	push   $0x0
  801b04:	6a 00                	push   $0x0
  801b06:	6a 00                	push   $0x0
  801b08:	6a 00                	push   $0x0
  801b0a:	ff 75 08             	pushl  0x8(%ebp)
  801b0d:	6a 29                	push   $0x29
  801b0f:	e8 fc fa ff ff       	call   801610 <syscall>
  801b14:	83 c4 18             	add    $0x18,%esp
	return ;
  801b17:	90                   	nop
}
  801b18:	c9                   	leave  
  801b19:	c3                   	ret    

00801b1a <inctst>:

void inctst()
{
  801b1a:	55                   	push   %ebp
  801b1b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801b1d:	6a 00                	push   $0x0
  801b1f:	6a 00                	push   $0x0
  801b21:	6a 00                	push   $0x0
  801b23:	6a 00                	push   $0x0
  801b25:	6a 00                	push   $0x0
  801b27:	6a 2a                	push   $0x2a
  801b29:	e8 e2 fa ff ff       	call   801610 <syscall>
  801b2e:	83 c4 18             	add    $0x18,%esp
	return ;
  801b31:	90                   	nop
}
  801b32:	c9                   	leave  
  801b33:	c3                   	ret    

00801b34 <gettst>:
uint32 gettst()
{
  801b34:	55                   	push   %ebp
  801b35:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801b37:	6a 00                	push   $0x0
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 00                	push   $0x0
  801b3d:	6a 00                	push   $0x0
  801b3f:	6a 00                	push   $0x0
  801b41:	6a 2b                	push   $0x2b
  801b43:	e8 c8 fa ff ff       	call   801610 <syscall>
  801b48:	83 c4 18             	add    $0x18,%esp
}
  801b4b:	c9                   	leave  
  801b4c:	c3                   	ret    

00801b4d <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801b4d:	55                   	push   %ebp
  801b4e:	89 e5                	mov    %esp,%ebp
  801b50:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b53:	6a 00                	push   $0x0
  801b55:	6a 00                	push   $0x0
  801b57:	6a 00                	push   $0x0
  801b59:	6a 00                	push   $0x0
  801b5b:	6a 00                	push   $0x0
  801b5d:	6a 2c                	push   $0x2c
  801b5f:	e8 ac fa ff ff       	call   801610 <syscall>
  801b64:	83 c4 18             	add    $0x18,%esp
  801b67:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801b6a:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801b6e:	75 07                	jne    801b77 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801b70:	b8 01 00 00 00       	mov    $0x1,%eax
  801b75:	eb 05                	jmp    801b7c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801b77:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b7c:	c9                   	leave  
  801b7d:	c3                   	ret    

00801b7e <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801b7e:	55                   	push   %ebp
  801b7f:	89 e5                	mov    %esp,%ebp
  801b81:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b84:	6a 00                	push   $0x0
  801b86:	6a 00                	push   $0x0
  801b88:	6a 00                	push   $0x0
  801b8a:	6a 00                	push   $0x0
  801b8c:	6a 00                	push   $0x0
  801b8e:	6a 2c                	push   $0x2c
  801b90:	e8 7b fa ff ff       	call   801610 <syscall>
  801b95:	83 c4 18             	add    $0x18,%esp
  801b98:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801b9b:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801b9f:	75 07                	jne    801ba8 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801ba1:	b8 01 00 00 00       	mov    $0x1,%eax
  801ba6:	eb 05                	jmp    801bad <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801ba8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bad:	c9                   	leave  
  801bae:	c3                   	ret    

00801baf <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801baf:	55                   	push   %ebp
  801bb0:	89 e5                	mov    %esp,%ebp
  801bb2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bb5:	6a 00                	push   $0x0
  801bb7:	6a 00                	push   $0x0
  801bb9:	6a 00                	push   $0x0
  801bbb:	6a 00                	push   $0x0
  801bbd:	6a 00                	push   $0x0
  801bbf:	6a 2c                	push   $0x2c
  801bc1:	e8 4a fa ff ff       	call   801610 <syscall>
  801bc6:	83 c4 18             	add    $0x18,%esp
  801bc9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801bcc:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801bd0:	75 07                	jne    801bd9 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801bd2:	b8 01 00 00 00       	mov    $0x1,%eax
  801bd7:	eb 05                	jmp    801bde <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801bd9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bde:	c9                   	leave  
  801bdf:	c3                   	ret    

00801be0 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801be0:	55                   	push   %ebp
  801be1:	89 e5                	mov    %esp,%ebp
  801be3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801be6:	6a 00                	push   $0x0
  801be8:	6a 00                	push   $0x0
  801bea:	6a 00                	push   $0x0
  801bec:	6a 00                	push   $0x0
  801bee:	6a 00                	push   $0x0
  801bf0:	6a 2c                	push   $0x2c
  801bf2:	e8 19 fa ff ff       	call   801610 <syscall>
  801bf7:	83 c4 18             	add    $0x18,%esp
  801bfa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801bfd:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801c01:	75 07                	jne    801c0a <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801c03:	b8 01 00 00 00       	mov    $0x1,%eax
  801c08:	eb 05                	jmp    801c0f <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801c0a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c0f:	c9                   	leave  
  801c10:	c3                   	ret    

00801c11 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c11:	55                   	push   %ebp
  801c12:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c14:	6a 00                	push   $0x0
  801c16:	6a 00                	push   $0x0
  801c18:	6a 00                	push   $0x0
  801c1a:	6a 00                	push   $0x0
  801c1c:	ff 75 08             	pushl  0x8(%ebp)
  801c1f:	6a 2d                	push   $0x2d
  801c21:	e8 ea f9 ff ff       	call   801610 <syscall>
  801c26:	83 c4 18             	add    $0x18,%esp
	return ;
  801c29:	90                   	nop
}
  801c2a:	c9                   	leave  
  801c2b:	c3                   	ret    

00801c2c <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801c2c:	55                   	push   %ebp
  801c2d:	89 e5                	mov    %esp,%ebp
  801c2f:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801c30:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c33:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c36:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c39:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3c:	6a 00                	push   $0x0
  801c3e:	53                   	push   %ebx
  801c3f:	51                   	push   %ecx
  801c40:	52                   	push   %edx
  801c41:	50                   	push   %eax
  801c42:	6a 2e                	push   $0x2e
  801c44:	e8 c7 f9 ff ff       	call   801610 <syscall>
  801c49:	83 c4 18             	add    $0x18,%esp
}
  801c4c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c4f:	c9                   	leave  
  801c50:	c3                   	ret    

00801c51 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801c51:	55                   	push   %ebp
  801c52:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801c54:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c57:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 00                	push   $0x0
  801c60:	52                   	push   %edx
  801c61:	50                   	push   %eax
  801c62:	6a 2f                	push   $0x2f
  801c64:	e8 a7 f9 ff ff       	call   801610 <syscall>
  801c69:	83 c4 18             	add    $0x18,%esp
}
  801c6c:	c9                   	leave  
  801c6d:	c3                   	ret    

00801c6e <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801c6e:	55                   	push   %ebp
  801c6f:	89 e5                	mov    %esp,%ebp
  801c71:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801c74:	83 ec 0c             	sub    $0xc,%esp
  801c77:	68 fc 37 80 00       	push   $0x8037fc
  801c7c:	e8 c7 e6 ff ff       	call   800348 <cprintf>
  801c81:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801c84:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801c8b:	83 ec 0c             	sub    $0xc,%esp
  801c8e:	68 28 38 80 00       	push   $0x803828
  801c93:	e8 b0 e6 ff ff       	call   800348 <cprintf>
  801c98:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801c9b:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801c9f:	a1 38 41 80 00       	mov    0x804138,%eax
  801ca4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ca7:	eb 56                	jmp    801cff <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801ca9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801cad:	74 1c                	je     801ccb <print_mem_block_lists+0x5d>
  801caf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cb2:	8b 50 08             	mov    0x8(%eax),%edx
  801cb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cb8:	8b 48 08             	mov    0x8(%eax),%ecx
  801cbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cbe:	8b 40 0c             	mov    0xc(%eax),%eax
  801cc1:	01 c8                	add    %ecx,%eax
  801cc3:	39 c2                	cmp    %eax,%edx
  801cc5:	73 04                	jae    801ccb <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801cc7:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801ccb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cce:	8b 50 08             	mov    0x8(%eax),%edx
  801cd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cd4:	8b 40 0c             	mov    0xc(%eax),%eax
  801cd7:	01 c2                	add    %eax,%edx
  801cd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cdc:	8b 40 08             	mov    0x8(%eax),%eax
  801cdf:	83 ec 04             	sub    $0x4,%esp
  801ce2:	52                   	push   %edx
  801ce3:	50                   	push   %eax
  801ce4:	68 3d 38 80 00       	push   $0x80383d
  801ce9:	e8 5a e6 ff ff       	call   800348 <cprintf>
  801cee:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801cf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cf4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801cf7:	a1 40 41 80 00       	mov    0x804140,%eax
  801cfc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801cff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d03:	74 07                	je     801d0c <print_mem_block_lists+0x9e>
  801d05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d08:	8b 00                	mov    (%eax),%eax
  801d0a:	eb 05                	jmp    801d11 <print_mem_block_lists+0xa3>
  801d0c:	b8 00 00 00 00       	mov    $0x0,%eax
  801d11:	a3 40 41 80 00       	mov    %eax,0x804140
  801d16:	a1 40 41 80 00       	mov    0x804140,%eax
  801d1b:	85 c0                	test   %eax,%eax
  801d1d:	75 8a                	jne    801ca9 <print_mem_block_lists+0x3b>
  801d1f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d23:	75 84                	jne    801ca9 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801d25:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801d29:	75 10                	jne    801d3b <print_mem_block_lists+0xcd>
  801d2b:	83 ec 0c             	sub    $0xc,%esp
  801d2e:	68 4c 38 80 00       	push   $0x80384c
  801d33:	e8 10 e6 ff ff       	call   800348 <cprintf>
  801d38:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801d3b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801d42:	83 ec 0c             	sub    $0xc,%esp
  801d45:	68 70 38 80 00       	push   $0x803870
  801d4a:	e8 f9 e5 ff ff       	call   800348 <cprintf>
  801d4f:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801d52:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801d56:	a1 40 40 80 00       	mov    0x804040,%eax
  801d5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d5e:	eb 56                	jmp    801db6 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801d60:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d64:	74 1c                	je     801d82 <print_mem_block_lists+0x114>
  801d66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d69:	8b 50 08             	mov    0x8(%eax),%edx
  801d6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d6f:	8b 48 08             	mov    0x8(%eax),%ecx
  801d72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d75:	8b 40 0c             	mov    0xc(%eax),%eax
  801d78:	01 c8                	add    %ecx,%eax
  801d7a:	39 c2                	cmp    %eax,%edx
  801d7c:	73 04                	jae    801d82 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801d7e:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801d82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d85:	8b 50 08             	mov    0x8(%eax),%edx
  801d88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d8b:	8b 40 0c             	mov    0xc(%eax),%eax
  801d8e:	01 c2                	add    %eax,%edx
  801d90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d93:	8b 40 08             	mov    0x8(%eax),%eax
  801d96:	83 ec 04             	sub    $0x4,%esp
  801d99:	52                   	push   %edx
  801d9a:	50                   	push   %eax
  801d9b:	68 3d 38 80 00       	push   $0x80383d
  801da0:	e8 a3 e5 ff ff       	call   800348 <cprintf>
  801da5:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801da8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dab:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801dae:	a1 48 40 80 00       	mov    0x804048,%eax
  801db3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801db6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801dba:	74 07                	je     801dc3 <print_mem_block_lists+0x155>
  801dbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dbf:	8b 00                	mov    (%eax),%eax
  801dc1:	eb 05                	jmp    801dc8 <print_mem_block_lists+0x15a>
  801dc3:	b8 00 00 00 00       	mov    $0x0,%eax
  801dc8:	a3 48 40 80 00       	mov    %eax,0x804048
  801dcd:	a1 48 40 80 00       	mov    0x804048,%eax
  801dd2:	85 c0                	test   %eax,%eax
  801dd4:	75 8a                	jne    801d60 <print_mem_block_lists+0xf2>
  801dd6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801dda:	75 84                	jne    801d60 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801ddc:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801de0:	75 10                	jne    801df2 <print_mem_block_lists+0x184>
  801de2:	83 ec 0c             	sub    $0xc,%esp
  801de5:	68 88 38 80 00       	push   $0x803888
  801dea:	e8 59 e5 ff ff       	call   800348 <cprintf>
  801def:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801df2:	83 ec 0c             	sub    $0xc,%esp
  801df5:	68 fc 37 80 00       	push   $0x8037fc
  801dfa:	e8 49 e5 ff ff       	call   800348 <cprintf>
  801dff:	83 c4 10             	add    $0x10,%esp

}
  801e02:	90                   	nop
  801e03:	c9                   	leave  
  801e04:	c3                   	ret    

00801e05 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801e05:	55                   	push   %ebp
  801e06:	89 e5                	mov    %esp,%ebp
  801e08:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);
  801e0b:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801e12:	00 00 00 
  801e15:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801e1c:	00 00 00 
  801e1f:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801e26:	00 00 00 

		struct MemBlock *tmp=MemBlockNodes;
  801e29:	a1 50 40 80 00       	mov    0x804050,%eax
  801e2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (int i=0;i<numOfBlocks;i++)
  801e31:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801e38:	e9 9e 00 00 00       	jmp    801edb <initialize_MemBlocksList+0xd6>
		{

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  801e3d:	a1 50 40 80 00       	mov    0x804050,%eax
  801e42:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e45:	c1 e2 04             	shl    $0x4,%edx
  801e48:	01 d0                	add    %edx,%eax
  801e4a:	85 c0                	test   %eax,%eax
  801e4c:	75 14                	jne    801e62 <initialize_MemBlocksList+0x5d>
  801e4e:	83 ec 04             	sub    $0x4,%esp
  801e51:	68 b0 38 80 00       	push   $0x8038b0
  801e56:	6a 48                	push   $0x48
  801e58:	68 d3 38 80 00       	push   $0x8038d3
  801e5d:	e8 07 10 00 00       	call   802e69 <_panic>
  801e62:	a1 50 40 80 00       	mov    0x804050,%eax
  801e67:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e6a:	c1 e2 04             	shl    $0x4,%edx
  801e6d:	01 d0                	add    %edx,%eax
  801e6f:	8b 15 48 41 80 00    	mov    0x804148,%edx
  801e75:	89 10                	mov    %edx,(%eax)
  801e77:	8b 00                	mov    (%eax),%eax
  801e79:	85 c0                	test   %eax,%eax
  801e7b:	74 18                	je     801e95 <initialize_MemBlocksList+0x90>
  801e7d:	a1 48 41 80 00       	mov    0x804148,%eax
  801e82:	8b 15 50 40 80 00    	mov    0x804050,%edx
  801e88:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801e8b:	c1 e1 04             	shl    $0x4,%ecx
  801e8e:	01 ca                	add    %ecx,%edx
  801e90:	89 50 04             	mov    %edx,0x4(%eax)
  801e93:	eb 12                	jmp    801ea7 <initialize_MemBlocksList+0xa2>
  801e95:	a1 50 40 80 00       	mov    0x804050,%eax
  801e9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e9d:	c1 e2 04             	shl    $0x4,%edx
  801ea0:	01 d0                	add    %edx,%eax
  801ea2:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801ea7:	a1 50 40 80 00       	mov    0x804050,%eax
  801eac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801eaf:	c1 e2 04             	shl    $0x4,%edx
  801eb2:	01 d0                	add    %edx,%eax
  801eb4:	a3 48 41 80 00       	mov    %eax,0x804148
  801eb9:	a1 50 40 80 00       	mov    0x804050,%eax
  801ebe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ec1:	c1 e2 04             	shl    $0x4,%edx
  801ec4:	01 d0                	add    %edx,%eax
  801ec6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801ecd:	a1 54 41 80 00       	mov    0x804154,%eax
  801ed2:	40                   	inc    %eax
  801ed3:	a3 54 41 80 00       	mov    %eax,0x804154
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);

		struct MemBlock *tmp=MemBlockNodes;
		for (int i=0;i<numOfBlocks;i++)
  801ed8:	ff 45 f4             	incl   -0xc(%ebp)
  801edb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ede:	3b 45 08             	cmp    0x8(%ebp),%eax
  801ee1:	0f 82 56 ff ff ff    	jb     801e3d <initialize_MemBlocksList+0x38>

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
		}


}
  801ee7:	90                   	nop
  801ee8:	c9                   	leave  
  801ee9:	c3                   	ret    

00801eea <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801eea:	55                   	push   %ebp
  801eeb:	89 e5                	mov    %esp,%ebp
  801eed:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;
  801ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef3:	8b 00                	mov    (%eax),%eax
  801ef5:	89 45 fc             	mov    %eax,-0x4(%ebp)

	while(tmp!=NULL)
  801ef8:	eb 18                	jmp    801f12 <find_block+0x28>
		{
			if(tmp->sva==va)
  801efa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801efd:	8b 40 08             	mov    0x8(%eax),%eax
  801f00:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801f03:	75 05                	jne    801f0a <find_block+0x20>
			{
				return tmp;
  801f05:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f08:	eb 11                	jmp    801f1b <find_block+0x31>

			}
		tmp=tmp->prev_next_info.le_next;
  801f0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f0d:	8b 00                	mov    (%eax),%eax
  801f0f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;

	while(tmp!=NULL)
  801f12:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f16:	75 e2                	jne    801efa <find_block+0x10>
				return tmp;

			}
		tmp=tmp->prev_next_info.le_next;
		}
		return tmp;
  801f18:	8b 45 fc             	mov    -0x4(%ebp),%eax
//
//		}
//
//		}
//			return tmp;
}
  801f1b:	c9                   	leave  
  801f1c:	c3                   	ret    

00801f1d <insert_sorted_allocList>:
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================


void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  801f1d:	55                   	push   %ebp
  801f1e:	89 e5                	mov    %esp,%ebp
  801f20:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code

	if(AllocMemBlocksList.lh_first==NULL)
  801f23:	a1 40 40 80 00       	mov    0x804040,%eax
  801f28:	85 c0                	test   %eax,%eax
  801f2a:	0f 85 83 00 00 00    	jne    801fb3 <insert_sorted_allocList+0x96>
	{
		LIST_INIT(&AllocMemBlocksList);
  801f30:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801f37:	00 00 00 
  801f3a:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801f41:	00 00 00 
  801f44:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801f4b:	00 00 00 
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  801f4e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f52:	75 14                	jne    801f68 <insert_sorted_allocList+0x4b>
  801f54:	83 ec 04             	sub    $0x4,%esp
  801f57:	68 b0 38 80 00       	push   $0x8038b0
  801f5c:	6a 7f                	push   $0x7f
  801f5e:	68 d3 38 80 00       	push   $0x8038d3
  801f63:	e8 01 0f 00 00       	call   802e69 <_panic>
  801f68:	8b 15 40 40 80 00    	mov    0x804040,%edx
  801f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f71:	89 10                	mov    %edx,(%eax)
  801f73:	8b 45 08             	mov    0x8(%ebp),%eax
  801f76:	8b 00                	mov    (%eax),%eax
  801f78:	85 c0                	test   %eax,%eax
  801f7a:	74 0d                	je     801f89 <insert_sorted_allocList+0x6c>
  801f7c:	a1 40 40 80 00       	mov    0x804040,%eax
  801f81:	8b 55 08             	mov    0x8(%ebp),%edx
  801f84:	89 50 04             	mov    %edx,0x4(%eax)
  801f87:	eb 08                	jmp    801f91 <insert_sorted_allocList+0x74>
  801f89:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8c:	a3 44 40 80 00       	mov    %eax,0x804044
  801f91:	8b 45 08             	mov    0x8(%ebp),%eax
  801f94:	a3 40 40 80 00       	mov    %eax,0x804040
  801f99:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801fa3:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801fa8:	40                   	inc    %eax
  801fa9:	a3 4c 40 80 00       	mov    %eax,0x80404c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  801fae:	e9 16 01 00 00       	jmp    8020c9 <insert_sorted_allocList+0x1ac>
		LIST_INIT(&AllocMemBlocksList);
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}


	else if(blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  801fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb6:	8b 50 08             	mov    0x8(%eax),%edx
  801fb9:	a1 44 40 80 00       	mov    0x804044,%eax
  801fbe:	8b 40 08             	mov    0x8(%eax),%eax
  801fc1:	39 c2                	cmp    %eax,%edx
  801fc3:	76 68                	jbe    80202d <insert_sorted_allocList+0x110>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
  801fc5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801fc9:	75 17                	jne    801fe2 <insert_sorted_allocList+0xc5>
  801fcb:	83 ec 04             	sub    $0x4,%esp
  801fce:	68 ec 38 80 00       	push   $0x8038ec
  801fd3:	68 85 00 00 00       	push   $0x85
  801fd8:	68 d3 38 80 00       	push   $0x8038d3
  801fdd:	e8 87 0e 00 00       	call   802e69 <_panic>
  801fe2:	8b 15 44 40 80 00    	mov    0x804044,%edx
  801fe8:	8b 45 08             	mov    0x8(%ebp),%eax
  801feb:	89 50 04             	mov    %edx,0x4(%eax)
  801fee:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff1:	8b 40 04             	mov    0x4(%eax),%eax
  801ff4:	85 c0                	test   %eax,%eax
  801ff6:	74 0c                	je     802004 <insert_sorted_allocList+0xe7>
  801ff8:	a1 44 40 80 00       	mov    0x804044,%eax
  801ffd:	8b 55 08             	mov    0x8(%ebp),%edx
  802000:	89 10                	mov    %edx,(%eax)
  802002:	eb 08                	jmp    80200c <insert_sorted_allocList+0xef>
  802004:	8b 45 08             	mov    0x8(%ebp),%eax
  802007:	a3 40 40 80 00       	mov    %eax,0x804040
  80200c:	8b 45 08             	mov    0x8(%ebp),%eax
  80200f:	a3 44 40 80 00       	mov    %eax,0x804044
  802014:	8b 45 08             	mov    0x8(%ebp),%eax
  802017:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80201d:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802022:	40                   	inc    %eax
  802023:	a3 4c 40 80 00       	mov    %eax,0x80404c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802028:	e9 9c 00 00 00       	jmp    8020c9 <insert_sorted_allocList+0x1ac>
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
  80202d:	a1 40 40 80 00       	mov    0x804040,%eax
  802032:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  802035:	e9 85 00 00 00       	jmp    8020bf <insert_sorted_allocList+0x1a2>
		{
			if(blockToInsert->sva<tmp->sva)
  80203a:	8b 45 08             	mov    0x8(%ebp),%eax
  80203d:	8b 50 08             	mov    0x8(%eax),%edx
  802040:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802043:	8b 40 08             	mov    0x8(%eax),%eax
  802046:	39 c2                	cmp    %eax,%edx
  802048:	73 6d                	jae    8020b7 <insert_sorted_allocList+0x19a>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
  80204a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80204e:	74 06                	je     802056 <insert_sorted_allocList+0x139>
  802050:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802054:	75 17                	jne    80206d <insert_sorted_allocList+0x150>
  802056:	83 ec 04             	sub    $0x4,%esp
  802059:	68 10 39 80 00       	push   $0x803910
  80205e:	68 90 00 00 00       	push   $0x90
  802063:	68 d3 38 80 00       	push   $0x8038d3
  802068:	e8 fc 0d 00 00       	call   802e69 <_panic>
  80206d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802070:	8b 50 04             	mov    0x4(%eax),%edx
  802073:	8b 45 08             	mov    0x8(%ebp),%eax
  802076:	89 50 04             	mov    %edx,0x4(%eax)
  802079:	8b 45 08             	mov    0x8(%ebp),%eax
  80207c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80207f:	89 10                	mov    %edx,(%eax)
  802081:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802084:	8b 40 04             	mov    0x4(%eax),%eax
  802087:	85 c0                	test   %eax,%eax
  802089:	74 0d                	je     802098 <insert_sorted_allocList+0x17b>
  80208b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80208e:	8b 40 04             	mov    0x4(%eax),%eax
  802091:	8b 55 08             	mov    0x8(%ebp),%edx
  802094:	89 10                	mov    %edx,(%eax)
  802096:	eb 08                	jmp    8020a0 <insert_sorted_allocList+0x183>
  802098:	8b 45 08             	mov    0x8(%ebp),%eax
  80209b:	a3 40 40 80 00       	mov    %eax,0x804040
  8020a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8020a6:	89 50 04             	mov    %edx,0x4(%eax)
  8020a9:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8020ae:	40                   	inc    %eax
  8020af:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  8020b4:	90                   	nop
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8020b5:	eb 12                	jmp    8020c9 <insert_sorted_allocList+0x1ac>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
				break;
			}
			tmp=tmp->prev_next_info.le_next;
  8020b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ba:	8b 00                	mov    (%eax),%eax
  8020bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
		while(tmp!=NULL)
  8020bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020c3:	0f 85 71 ff ff ff    	jne    80203a <insert_sorted_allocList+0x11d>
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8020c9:	90                   	nop
  8020ca:	c9                   	leave  
  8020cb:	c3                   	ret    

008020cc <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

struct MemBlock *alloc_block_FF(uint32 size)
{
  8020cc:	55                   	push   %ebp
  8020cd:	89 e5                	mov    %esp,%ebp
  8020cf:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  8020d2:	a1 38 41 80 00       	mov    0x804138,%eax
  8020d7:	89 45 f4             	mov    %eax,-0xc(%ebp)

	while(tmp!=NULL)
  8020da:	e9 76 01 00 00       	jmp    802255 <alloc_block_FF+0x189>
	{
		if(size==(tmp->size))
  8020df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8020e5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8020e8:	0f 85 8a 00 00 00    	jne    802178 <alloc_block_FF+0xac>
		{

			LIST_REMOVE(&FreeMemBlocksList,tmp);
  8020ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020f2:	75 17                	jne    80210b <alloc_block_FF+0x3f>
  8020f4:	83 ec 04             	sub    $0x4,%esp
  8020f7:	68 45 39 80 00       	push   $0x803945
  8020fc:	68 a8 00 00 00       	push   $0xa8
  802101:	68 d3 38 80 00       	push   $0x8038d3
  802106:	e8 5e 0d 00 00       	call   802e69 <_panic>
  80210b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80210e:	8b 00                	mov    (%eax),%eax
  802110:	85 c0                	test   %eax,%eax
  802112:	74 10                	je     802124 <alloc_block_FF+0x58>
  802114:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802117:	8b 00                	mov    (%eax),%eax
  802119:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80211c:	8b 52 04             	mov    0x4(%edx),%edx
  80211f:	89 50 04             	mov    %edx,0x4(%eax)
  802122:	eb 0b                	jmp    80212f <alloc_block_FF+0x63>
  802124:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802127:	8b 40 04             	mov    0x4(%eax),%eax
  80212a:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80212f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802132:	8b 40 04             	mov    0x4(%eax),%eax
  802135:	85 c0                	test   %eax,%eax
  802137:	74 0f                	je     802148 <alloc_block_FF+0x7c>
  802139:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80213c:	8b 40 04             	mov    0x4(%eax),%eax
  80213f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802142:	8b 12                	mov    (%edx),%edx
  802144:	89 10                	mov    %edx,(%eax)
  802146:	eb 0a                	jmp    802152 <alloc_block_FF+0x86>
  802148:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80214b:	8b 00                	mov    (%eax),%eax
  80214d:	a3 38 41 80 00       	mov    %eax,0x804138
  802152:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802155:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80215b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80215e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802165:	a1 44 41 80 00       	mov    0x804144,%eax
  80216a:	48                   	dec    %eax
  80216b:	a3 44 41 80 00       	mov    %eax,0x804144

			return tmp;
  802170:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802173:	e9 ea 00 00 00       	jmp    802262 <alloc_block_FF+0x196>

		}
		else if(size<tmp->size)
  802178:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80217b:	8b 40 0c             	mov    0xc(%eax),%eax
  80217e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802181:	0f 86 c6 00 00 00    	jbe    80224d <alloc_block_FF+0x181>
		{

			 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802187:	a1 48 41 80 00       	mov    0x804148,%eax
  80218c:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 newBlock->size=size;
  80218f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802192:	8b 55 08             	mov    0x8(%ebp),%edx
  802195:	89 50 0c             	mov    %edx,0xc(%eax)
			 newBlock->sva=tmp->sva;
  802198:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219b:	8b 50 08             	mov    0x8(%eax),%edx
  80219e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021a1:	89 50 08             	mov    %edx,0x8(%eax)
			 tmp->size=tmp->size-size;
  8021a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a7:	8b 40 0c             	mov    0xc(%eax),%eax
  8021aa:	2b 45 08             	sub    0x8(%ebp),%eax
  8021ad:	89 c2                	mov    %eax,%edx
  8021af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b2:	89 50 0c             	mov    %edx,0xc(%eax)
			 tmp->sva=tmp->sva+size;
  8021b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b8:	8b 50 08             	mov    0x8(%eax),%edx
  8021bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021be:	01 c2                	add    %eax,%edx
  8021c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c3:	89 50 08             	mov    %edx,0x8(%eax)

			 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  8021c6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021ca:	75 17                	jne    8021e3 <alloc_block_FF+0x117>
  8021cc:	83 ec 04             	sub    $0x4,%esp
  8021cf:	68 45 39 80 00       	push   $0x803945
  8021d4:	68 b6 00 00 00       	push   $0xb6
  8021d9:	68 d3 38 80 00       	push   $0x8038d3
  8021de:	e8 86 0c 00 00       	call   802e69 <_panic>
  8021e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021e6:	8b 00                	mov    (%eax),%eax
  8021e8:	85 c0                	test   %eax,%eax
  8021ea:	74 10                	je     8021fc <alloc_block_FF+0x130>
  8021ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021ef:	8b 00                	mov    (%eax),%eax
  8021f1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021f4:	8b 52 04             	mov    0x4(%edx),%edx
  8021f7:	89 50 04             	mov    %edx,0x4(%eax)
  8021fa:	eb 0b                	jmp    802207 <alloc_block_FF+0x13b>
  8021fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021ff:	8b 40 04             	mov    0x4(%eax),%eax
  802202:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802207:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80220a:	8b 40 04             	mov    0x4(%eax),%eax
  80220d:	85 c0                	test   %eax,%eax
  80220f:	74 0f                	je     802220 <alloc_block_FF+0x154>
  802211:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802214:	8b 40 04             	mov    0x4(%eax),%eax
  802217:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80221a:	8b 12                	mov    (%edx),%edx
  80221c:	89 10                	mov    %edx,(%eax)
  80221e:	eb 0a                	jmp    80222a <alloc_block_FF+0x15e>
  802220:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802223:	8b 00                	mov    (%eax),%eax
  802225:	a3 48 41 80 00       	mov    %eax,0x804148
  80222a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80222d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802233:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802236:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80223d:	a1 54 41 80 00       	mov    0x804154,%eax
  802242:	48                   	dec    %eax
  802243:	a3 54 41 80 00       	mov    %eax,0x804154
			 return newBlock;
  802248:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80224b:	eb 15                	jmp    802262 <alloc_block_FF+0x196>

		}
		tmp=tmp->prev_next_info.le_next;
  80224d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802250:	8b 00                	mov    (%eax),%eax
  802252:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;

	while(tmp!=NULL)
  802255:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802259:	0f 85 80 fe ff ff    	jne    8020df <alloc_block_FF+0x13>
			 return newBlock;

		}
		tmp=tmp->prev_next_info.le_next;
	}
	return tmp;
  80225f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802262:	c9                   	leave  
  802263:	c3                   	ret    

00802264 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802264:	55                   	push   %ebp
  802265:	89 e5                	mov    %esp,%ebp
  802267:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  80226a:	a1 38 41 80 00       	mov    0x804138,%eax
  80226f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 newSize=UINT_MAX;
  802272:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)


		while(tmp!=NULL)
  802279:	e9 c0 00 00 00       	jmp    80233e <alloc_block_BF+0xda>
		{
			if(size==(tmp->size))
  80227e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802281:	8b 40 0c             	mov    0xc(%eax),%eax
  802284:	3b 45 08             	cmp    0x8(%ebp),%eax
  802287:	0f 85 8a 00 00 00    	jne    802317 <alloc_block_BF+0xb3>
			{
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  80228d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802291:	75 17                	jne    8022aa <alloc_block_BF+0x46>
  802293:	83 ec 04             	sub    $0x4,%esp
  802296:	68 45 39 80 00       	push   $0x803945
  80229b:	68 cf 00 00 00       	push   $0xcf
  8022a0:	68 d3 38 80 00       	push   $0x8038d3
  8022a5:	e8 bf 0b 00 00       	call   802e69 <_panic>
  8022aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ad:	8b 00                	mov    (%eax),%eax
  8022af:	85 c0                	test   %eax,%eax
  8022b1:	74 10                	je     8022c3 <alloc_block_BF+0x5f>
  8022b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b6:	8b 00                	mov    (%eax),%eax
  8022b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022bb:	8b 52 04             	mov    0x4(%edx),%edx
  8022be:	89 50 04             	mov    %edx,0x4(%eax)
  8022c1:	eb 0b                	jmp    8022ce <alloc_block_BF+0x6a>
  8022c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c6:	8b 40 04             	mov    0x4(%eax),%eax
  8022c9:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8022ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d1:	8b 40 04             	mov    0x4(%eax),%eax
  8022d4:	85 c0                	test   %eax,%eax
  8022d6:	74 0f                	je     8022e7 <alloc_block_BF+0x83>
  8022d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022db:	8b 40 04             	mov    0x4(%eax),%eax
  8022de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022e1:	8b 12                	mov    (%edx),%edx
  8022e3:	89 10                	mov    %edx,(%eax)
  8022e5:	eb 0a                	jmp    8022f1 <alloc_block_BF+0x8d>
  8022e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ea:	8b 00                	mov    (%eax),%eax
  8022ec:	a3 38 41 80 00       	mov    %eax,0x804138
  8022f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022fd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802304:	a1 44 41 80 00       	mov    0x804144,%eax
  802309:	48                   	dec    %eax
  80230a:	a3 44 41 80 00       	mov    %eax,0x804144
				return tmp;
  80230f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802312:	e9 2a 01 00 00       	jmp    802441 <alloc_block_BF+0x1dd>

			}
			else if (tmp->size<newSize&&tmp->size>size)
  802317:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231a:	8b 40 0c             	mov    0xc(%eax),%eax
  80231d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802320:	73 14                	jae    802336 <alloc_block_BF+0xd2>
  802322:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802325:	8b 40 0c             	mov    0xc(%eax),%eax
  802328:	3b 45 08             	cmp    0x8(%ebp),%eax
  80232b:	76 09                	jbe    802336 <alloc_block_BF+0xd2>
			{
				newSize=tmp->size;
  80232d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802330:	8b 40 0c             	mov    0xc(%eax),%eax
  802333:	89 45 f0             	mov    %eax,-0x10(%ebp)


			}
			tmp=tmp->prev_next_info.le_next;
  802336:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802339:	8b 00                	mov    (%eax),%eax
  80233b:	89 45 f4             	mov    %eax,-0xc(%ebp)

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
	uint32 newSize=UINT_MAX;


		while(tmp!=NULL)
  80233e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802342:	0f 85 36 ff ff ff    	jne    80227e <alloc_block_BF+0x1a>
		}//tmp=NULL




			tmp =FreeMemBlocksList.lh_first;
  802348:	a1 38 41 80 00       	mov    0x804138,%eax
  80234d:	89 45 f4             	mov    %eax,-0xc(%ebp)
			while(tmp!=NULL)
  802350:	e9 dd 00 00 00       	jmp    802432 <alloc_block_BF+0x1ce>
			{
				if(tmp->size==newSize)
  802355:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802358:	8b 40 0c             	mov    0xc(%eax),%eax
  80235b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80235e:	0f 85 c6 00 00 00    	jne    80242a <alloc_block_BF+0x1c6>
					{
					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802364:	a1 48 41 80 00       	mov    0x804148,%eax
  802369:	89 45 ec             	mov    %eax,-0x14(%ebp)

								 newBlock->sva=tmp->sva;     //newBlock.sva=tmp.sva
  80236c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236f:	8b 50 08             	mov    0x8(%eax),%edx
  802372:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802375:	89 50 08             	mov    %edx,0x8(%eax)
								 newBlock->size=size;
  802378:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80237b:	8b 55 08             	mov    0x8(%ebp),%edx
  80237e:	89 50 0c             	mov    %edx,0xc(%eax)

											 tmp->sva+=size;
  802381:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802384:	8b 50 08             	mov    0x8(%eax),%edx
  802387:	8b 45 08             	mov    0x8(%ebp),%eax
  80238a:	01 c2                	add    %eax,%edx
  80238c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238f:	89 50 08             	mov    %edx,0x8(%eax)
											 tmp->size-=size;
  802392:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802395:	8b 40 0c             	mov    0xc(%eax),%eax
  802398:	2b 45 08             	sub    0x8(%ebp),%eax
  80239b:	89 c2                	mov    %eax,%edx
  80239d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a0:	89 50 0c             	mov    %edx,0xc(%eax)
											 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  8023a3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8023a7:	75 17                	jne    8023c0 <alloc_block_BF+0x15c>
  8023a9:	83 ec 04             	sub    $0x4,%esp
  8023ac:	68 45 39 80 00       	push   $0x803945
  8023b1:	68 eb 00 00 00       	push   $0xeb
  8023b6:	68 d3 38 80 00       	push   $0x8038d3
  8023bb:	e8 a9 0a 00 00       	call   802e69 <_panic>
  8023c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023c3:	8b 00                	mov    (%eax),%eax
  8023c5:	85 c0                	test   %eax,%eax
  8023c7:	74 10                	je     8023d9 <alloc_block_BF+0x175>
  8023c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023cc:	8b 00                	mov    (%eax),%eax
  8023ce:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8023d1:	8b 52 04             	mov    0x4(%edx),%edx
  8023d4:	89 50 04             	mov    %edx,0x4(%eax)
  8023d7:	eb 0b                	jmp    8023e4 <alloc_block_BF+0x180>
  8023d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023dc:	8b 40 04             	mov    0x4(%eax),%eax
  8023df:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8023e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023e7:	8b 40 04             	mov    0x4(%eax),%eax
  8023ea:	85 c0                	test   %eax,%eax
  8023ec:	74 0f                	je     8023fd <alloc_block_BF+0x199>
  8023ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023f1:	8b 40 04             	mov    0x4(%eax),%eax
  8023f4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8023f7:	8b 12                	mov    (%edx),%edx
  8023f9:	89 10                	mov    %edx,(%eax)
  8023fb:	eb 0a                	jmp    802407 <alloc_block_BF+0x1a3>
  8023fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802400:	8b 00                	mov    (%eax),%eax
  802402:	a3 48 41 80 00       	mov    %eax,0x804148
  802407:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80240a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802410:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802413:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80241a:	a1 54 41 80 00       	mov    0x804154,%eax
  80241f:	48                   	dec    %eax
  802420:	a3 54 41 80 00       	mov    %eax,0x804154
											 return newBlock;
  802425:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802428:	eb 17                	jmp    802441 <alloc_block_BF+0x1dd>

					}
				tmp=tmp->prev_next_info.le_next;
  80242a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242d:	8b 00                	mov    (%eax),%eax
  80242f:	89 45 f4             	mov    %eax,-0xc(%ebp)




			tmp =FreeMemBlocksList.lh_first;
			while(tmp!=NULL)
  802432:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802436:	0f 85 19 ff ff ff    	jne    802355 <alloc_block_BF+0xf1>
			//tmp ->  block newSize,Sva




		return NULL; //return NULL
  80243c:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802441:	c9                   	leave  
  802442:	c3                   	ret    

00802443 <alloc_block_NF>:
//=========================================



struct MemBlock *alloc_block_NF(uint32 size)
{
  802443:	55                   	push   %ebp
  802444:	89 e5                	mov    %esp,%ebp
  802446:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp1;
	uint32 currentSva;
	if(AllocMemBlocksList.lh_first==NULL)
  802449:	a1 40 40 80 00       	mov    0x804040,%eax
  80244e:	85 c0                	test   %eax,%eax
  802450:	75 19                	jne    80246b <alloc_block_NF+0x28>
	{
		tmp1=alloc_block_FF(size);
  802452:	83 ec 0c             	sub    $0xc,%esp
  802455:	ff 75 08             	pushl  0x8(%ebp)
  802458:	e8 6f fc ff ff       	call   8020cc <alloc_block_FF>
  80245d:	83 c4 10             	add    $0x10,%esp
  802460:	89 45 f4             	mov    %eax,-0xc(%ebp)
		return tmp1;
  802463:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802466:	e9 e9 01 00 00       	jmp    802654 <alloc_block_NF+0x211>
	}

			else
			{
            currentSva=AllocMemBlocksList.lh_last->sva;
  80246b:	a1 44 40 80 00       	mov    0x804044,%eax
  802470:	8b 40 08             	mov    0x8(%eax),%eax
  802473:	89 45 f0             	mov    %eax,-0x10(%ebp)
			tmp1=find_block(&FreeMemBlocksList,AllocMemBlocksList.lh_last->size+AllocMemBlocksList.lh_last->sva);
  802476:	a1 44 40 80 00       	mov    0x804044,%eax
  80247b:	8b 50 0c             	mov    0xc(%eax),%edx
  80247e:	a1 44 40 80 00       	mov    0x804044,%eax
  802483:	8b 40 08             	mov    0x8(%eax),%eax
  802486:	01 d0                	add    %edx,%eax
  802488:	83 ec 08             	sub    $0x8,%esp
  80248b:	50                   	push   %eax
  80248c:	68 38 41 80 00       	push   $0x804138
  802491:	e8 54 fa ff ff       	call   801eea <find_block>
  802496:	83 c4 10             	add    $0x10,%esp
  802499:	89 45 f4             	mov    %eax,-0xc(%ebp)


do
	{

		if(size==(tmp1->size))
  80249c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249f:	8b 40 0c             	mov    0xc(%eax),%eax
  8024a2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024a5:	0f 85 9b 00 00 00    	jne    802546 <alloc_block_NF+0x103>
				{
			currentSva=tmp1->size+tmp1->sva;
  8024ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ae:	8b 50 0c             	mov    0xc(%eax),%edx
  8024b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b4:	8b 40 08             	mov    0x8(%eax),%eax
  8024b7:	01 d0                	add    %edx,%eax
  8024b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,tmp1);
  8024bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024c0:	75 17                	jne    8024d9 <alloc_block_NF+0x96>
  8024c2:	83 ec 04             	sub    $0x4,%esp
  8024c5:	68 45 39 80 00       	push   $0x803945
  8024ca:	68 1a 01 00 00       	push   $0x11a
  8024cf:	68 d3 38 80 00       	push   $0x8038d3
  8024d4:	e8 90 09 00 00       	call   802e69 <_panic>
  8024d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024dc:	8b 00                	mov    (%eax),%eax
  8024de:	85 c0                	test   %eax,%eax
  8024e0:	74 10                	je     8024f2 <alloc_block_NF+0xaf>
  8024e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e5:	8b 00                	mov    (%eax),%eax
  8024e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024ea:	8b 52 04             	mov    0x4(%edx),%edx
  8024ed:	89 50 04             	mov    %edx,0x4(%eax)
  8024f0:	eb 0b                	jmp    8024fd <alloc_block_NF+0xba>
  8024f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f5:	8b 40 04             	mov    0x4(%eax),%eax
  8024f8:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8024fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802500:	8b 40 04             	mov    0x4(%eax),%eax
  802503:	85 c0                	test   %eax,%eax
  802505:	74 0f                	je     802516 <alloc_block_NF+0xd3>
  802507:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250a:	8b 40 04             	mov    0x4(%eax),%eax
  80250d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802510:	8b 12                	mov    (%edx),%edx
  802512:	89 10                	mov    %edx,(%eax)
  802514:	eb 0a                	jmp    802520 <alloc_block_NF+0xdd>
  802516:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802519:	8b 00                	mov    (%eax),%eax
  80251b:	a3 38 41 80 00       	mov    %eax,0x804138
  802520:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802523:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802529:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802533:	a1 44 41 80 00       	mov    0x804144,%eax
  802538:	48                   	dec    %eax
  802539:	a3 44 41 80 00       	mov    %eax,0x804144
					return tmp1;
  80253e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802541:	e9 0e 01 00 00       	jmp    802654 <alloc_block_NF+0x211>

				}
				else if(size<tmp1->size)
  802546:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802549:	8b 40 0c             	mov    0xc(%eax),%eax
  80254c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80254f:	0f 86 cf 00 00 00    	jbe    802624 <alloc_block_NF+0x1e1>
				{

					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802555:	a1 48 41 80 00       	mov    0x804148,%eax
  80255a:	89 45 ec             	mov    %eax,-0x14(%ebp)
					 newBlock->size=size;
  80255d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802560:	8b 55 08             	mov    0x8(%ebp),%edx
  802563:	89 50 0c             	mov    %edx,0xc(%eax)
					 newBlock->sva=tmp1->sva;
  802566:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802569:	8b 50 08             	mov    0x8(%eax),%edx
  80256c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80256f:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->sva+=size;
  802572:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802575:	8b 50 08             	mov    0x8(%eax),%edx
  802578:	8b 45 08             	mov    0x8(%ebp),%eax
  80257b:	01 c2                	add    %eax,%edx
  80257d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802580:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->size-=size;
  802583:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802586:	8b 40 0c             	mov    0xc(%eax),%eax
  802589:	2b 45 08             	sub    0x8(%ebp),%eax
  80258c:	89 c2                	mov    %eax,%edx
  80258e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802591:	89 50 0c             	mov    %edx,0xc(%eax)
                     currentSva=tmp1->sva;
  802594:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802597:	8b 40 08             	mov    0x8(%eax),%eax
  80259a:	89 45 f0             	mov    %eax,-0x10(%ebp)

					 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  80259d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8025a1:	75 17                	jne    8025ba <alloc_block_NF+0x177>
  8025a3:	83 ec 04             	sub    $0x4,%esp
  8025a6:	68 45 39 80 00       	push   $0x803945
  8025ab:	68 28 01 00 00       	push   $0x128
  8025b0:	68 d3 38 80 00       	push   $0x8038d3
  8025b5:	e8 af 08 00 00       	call   802e69 <_panic>
  8025ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025bd:	8b 00                	mov    (%eax),%eax
  8025bf:	85 c0                	test   %eax,%eax
  8025c1:	74 10                	je     8025d3 <alloc_block_NF+0x190>
  8025c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025c6:	8b 00                	mov    (%eax),%eax
  8025c8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025cb:	8b 52 04             	mov    0x4(%edx),%edx
  8025ce:	89 50 04             	mov    %edx,0x4(%eax)
  8025d1:	eb 0b                	jmp    8025de <alloc_block_NF+0x19b>
  8025d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025d6:	8b 40 04             	mov    0x4(%eax),%eax
  8025d9:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8025de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025e1:	8b 40 04             	mov    0x4(%eax),%eax
  8025e4:	85 c0                	test   %eax,%eax
  8025e6:	74 0f                	je     8025f7 <alloc_block_NF+0x1b4>
  8025e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025eb:	8b 40 04             	mov    0x4(%eax),%eax
  8025ee:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025f1:	8b 12                	mov    (%edx),%edx
  8025f3:	89 10                	mov    %edx,(%eax)
  8025f5:	eb 0a                	jmp    802601 <alloc_block_NF+0x1be>
  8025f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025fa:	8b 00                	mov    (%eax),%eax
  8025fc:	a3 48 41 80 00       	mov    %eax,0x804148
  802601:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802604:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80260a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80260d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802614:	a1 54 41 80 00       	mov    0x804154,%eax
  802619:	48                   	dec    %eax
  80261a:	a3 54 41 80 00       	mov    %eax,0x804154
					 return newBlock;
  80261f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802622:	eb 30                	jmp    802654 <alloc_block_NF+0x211>

				}
		if(tmp1==FreeMemBlocksList.lh_last)
  802624:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802629:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80262c:	75 0a                	jne    802638 <alloc_block_NF+0x1f5>
			tmp1=FreeMemBlocksList.lh_first;
  80262e:	a1 38 41 80 00       	mov    0x804138,%eax
  802633:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802636:	eb 08                	jmp    802640 <alloc_block_NF+0x1fd>
		else
				tmp1=tmp1->prev_next_info.le_next;
  802638:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263b:	8b 00                	mov    (%eax),%eax
  80263d:	89 45 f4             	mov    %eax,-0xc(%ebp)


			}
while(tmp1->sva!=currentSva);
  802640:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802643:	8b 40 08             	mov    0x8(%eax),%eax
  802646:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802649:	0f 85 4d fe ff ff    	jne    80249c <alloc_block_NF+0x59>

			return NULL;
  80264f:	b8 00 00 00 00       	mov    $0x0,%eax

	}
  802654:	c9                   	leave  
  802655:	c3                   	ret    

00802656 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802656:	55                   	push   %ebp
  802657:	89 e5                	mov    %esp,%ebp
  802659:	53                   	push   %ebx
  80265a:	83 ec 14             	sub    $0x14,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	if(FreeMemBlocksList.lh_first==NULL)
  80265d:	a1 38 41 80 00       	mov    0x804138,%eax
  802662:	85 c0                	test   %eax,%eax
  802664:	0f 85 86 00 00 00    	jne    8026f0 <insert_sorted_with_merge_freeList+0x9a>
	{
		LIST_INIT(&FreeMemBlocksList);
  80266a:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  802671:	00 00 00 
  802674:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  80267b:	00 00 00 
  80267e:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  802685:	00 00 00 
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802688:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80268c:	75 17                	jne    8026a5 <insert_sorted_with_merge_freeList+0x4f>
  80268e:	83 ec 04             	sub    $0x4,%esp
  802691:	68 b0 38 80 00       	push   $0x8038b0
  802696:	68 48 01 00 00       	push   $0x148
  80269b:	68 d3 38 80 00       	push   $0x8038d3
  8026a0:	e8 c4 07 00 00       	call   802e69 <_panic>
  8026a5:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8026ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ae:	89 10                	mov    %edx,(%eax)
  8026b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b3:	8b 00                	mov    (%eax),%eax
  8026b5:	85 c0                	test   %eax,%eax
  8026b7:	74 0d                	je     8026c6 <insert_sorted_with_merge_freeList+0x70>
  8026b9:	a1 38 41 80 00       	mov    0x804138,%eax
  8026be:	8b 55 08             	mov    0x8(%ebp),%edx
  8026c1:	89 50 04             	mov    %edx,0x4(%eax)
  8026c4:	eb 08                	jmp    8026ce <insert_sorted_with_merge_freeList+0x78>
  8026c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c9:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8026ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d1:	a3 38 41 80 00       	mov    %eax,0x804138
  8026d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026e0:	a1 44 41 80 00       	mov    0x804144,%eax
  8026e5:	40                   	inc    %eax
  8026e6:	a3 44 41 80 00       	mov    %eax,0x804144
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  8026eb:	e9 73 07 00 00       	jmp    802e63 <insert_sorted_with_merge_freeList+0x80d>
	if(FreeMemBlocksList.lh_first==NULL)
	{
		LIST_INIT(&FreeMemBlocksList);
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva!=(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  8026f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f3:	8b 50 08             	mov    0x8(%eax),%edx
  8026f6:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8026fb:	8b 40 08             	mov    0x8(%eax),%eax
  8026fe:	39 c2                	cmp    %eax,%edx
  802700:	0f 86 84 00 00 00    	jbe    80278a <insert_sorted_with_merge_freeList+0x134>
  802706:	8b 45 08             	mov    0x8(%ebp),%eax
  802709:	8b 50 08             	mov    0x8(%eax),%edx
  80270c:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802711:	8b 48 0c             	mov    0xc(%eax),%ecx
  802714:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802719:	8b 40 08             	mov    0x8(%eax),%eax
  80271c:	01 c8                	add    %ecx,%eax
  80271e:	39 c2                	cmp    %eax,%edx
  802720:	74 68                	je     80278a <insert_sorted_with_merge_freeList+0x134>
	{
		LIST_INSERT_TAIL(&FreeMemBlocksList,blockToInsert);
  802722:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802726:	75 17                	jne    80273f <insert_sorted_with_merge_freeList+0xe9>
  802728:	83 ec 04             	sub    $0x4,%esp
  80272b:	68 ec 38 80 00       	push   $0x8038ec
  802730:	68 4c 01 00 00       	push   $0x14c
  802735:	68 d3 38 80 00       	push   $0x8038d3
  80273a:	e8 2a 07 00 00       	call   802e69 <_panic>
  80273f:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802745:	8b 45 08             	mov    0x8(%ebp),%eax
  802748:	89 50 04             	mov    %edx,0x4(%eax)
  80274b:	8b 45 08             	mov    0x8(%ebp),%eax
  80274e:	8b 40 04             	mov    0x4(%eax),%eax
  802751:	85 c0                	test   %eax,%eax
  802753:	74 0c                	je     802761 <insert_sorted_with_merge_freeList+0x10b>
  802755:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80275a:	8b 55 08             	mov    0x8(%ebp),%edx
  80275d:	89 10                	mov    %edx,(%eax)
  80275f:	eb 08                	jmp    802769 <insert_sorted_with_merge_freeList+0x113>
  802761:	8b 45 08             	mov    0x8(%ebp),%eax
  802764:	a3 38 41 80 00       	mov    %eax,0x804138
  802769:	8b 45 08             	mov    0x8(%ebp),%eax
  80276c:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802771:	8b 45 08             	mov    0x8(%ebp),%eax
  802774:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80277a:	a1 44 41 80 00       	mov    0x804144,%eax
  80277f:	40                   	inc    %eax
  802780:	a3 44 41 80 00       	mov    %eax,0x804144
  802785:	e9 d9 06 00 00       	jmp    802e63 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva==(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  80278a:	8b 45 08             	mov    0x8(%ebp),%eax
  80278d:	8b 50 08             	mov    0x8(%eax),%edx
  802790:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802795:	8b 40 08             	mov    0x8(%eax),%eax
  802798:	39 c2                	cmp    %eax,%edx
  80279a:	0f 86 b5 00 00 00    	jbe    802855 <insert_sorted_with_merge_freeList+0x1ff>
  8027a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a3:	8b 50 08             	mov    0x8(%eax),%edx
  8027a6:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8027ab:	8b 48 0c             	mov    0xc(%eax),%ecx
  8027ae:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8027b3:	8b 40 08             	mov    0x8(%eax),%eax
  8027b6:	01 c8                	add    %ecx,%eax
  8027b8:	39 c2                	cmp    %eax,%edx
  8027ba:	0f 85 95 00 00 00    	jne    802855 <insert_sorted_with_merge_freeList+0x1ff>

	{
		FreeMemBlocksList.lh_last->size+=blockToInsert->size;
  8027c0:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8027c5:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  8027cb:	8b 4a 0c             	mov    0xc(%edx),%ecx
  8027ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8027d1:	8b 52 0c             	mov    0xc(%edx),%edx
  8027d4:	01 ca                	add    %ecx,%edx
  8027d6:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  8027d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8027dc:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  8027e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8027ed:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8027f1:	75 17                	jne    80280a <insert_sorted_with_merge_freeList+0x1b4>
  8027f3:	83 ec 04             	sub    $0x4,%esp
  8027f6:	68 b0 38 80 00       	push   $0x8038b0
  8027fb:	68 54 01 00 00       	push   $0x154
  802800:	68 d3 38 80 00       	push   $0x8038d3
  802805:	e8 5f 06 00 00       	call   802e69 <_panic>
  80280a:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802810:	8b 45 08             	mov    0x8(%ebp),%eax
  802813:	89 10                	mov    %edx,(%eax)
  802815:	8b 45 08             	mov    0x8(%ebp),%eax
  802818:	8b 00                	mov    (%eax),%eax
  80281a:	85 c0                	test   %eax,%eax
  80281c:	74 0d                	je     80282b <insert_sorted_with_merge_freeList+0x1d5>
  80281e:	a1 48 41 80 00       	mov    0x804148,%eax
  802823:	8b 55 08             	mov    0x8(%ebp),%edx
  802826:	89 50 04             	mov    %edx,0x4(%eax)
  802829:	eb 08                	jmp    802833 <insert_sorted_with_merge_freeList+0x1dd>
  80282b:	8b 45 08             	mov    0x8(%ebp),%eax
  80282e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802833:	8b 45 08             	mov    0x8(%ebp),%eax
  802836:	a3 48 41 80 00       	mov    %eax,0x804148
  80283b:	8b 45 08             	mov    0x8(%ebp),%eax
  80283e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802845:	a1 54 41 80 00       	mov    0x804154,%eax
  80284a:	40                   	inc    %eax
  80284b:	a3 54 41 80 00       	mov    %eax,0x804154
  802850:	e9 0e 06 00 00       	jmp    802e63 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva==(blockToInsert->sva+blockToInsert->size))
  802855:	8b 45 08             	mov    0x8(%ebp),%eax
  802858:	8b 50 08             	mov    0x8(%eax),%edx
  80285b:	a1 38 41 80 00       	mov    0x804138,%eax
  802860:	8b 40 08             	mov    0x8(%eax),%eax
  802863:	39 c2                	cmp    %eax,%edx
  802865:	0f 83 c1 00 00 00    	jae    80292c <insert_sorted_with_merge_freeList+0x2d6>
  80286b:	a1 38 41 80 00       	mov    0x804138,%eax
  802870:	8b 50 08             	mov    0x8(%eax),%edx
  802873:	8b 45 08             	mov    0x8(%ebp),%eax
  802876:	8b 48 08             	mov    0x8(%eax),%ecx
  802879:	8b 45 08             	mov    0x8(%ebp),%eax
  80287c:	8b 40 0c             	mov    0xc(%eax),%eax
  80287f:	01 c8                	add    %ecx,%eax
  802881:	39 c2                	cmp    %eax,%edx
  802883:	0f 85 a3 00 00 00    	jne    80292c <insert_sorted_with_merge_freeList+0x2d6>
	{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  802889:	a1 38 41 80 00       	mov    0x804138,%eax
  80288e:	8b 55 08             	mov    0x8(%ebp),%edx
  802891:	8b 52 08             	mov    0x8(%edx),%edx
  802894:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size+=blockToInsert->size;
  802897:	a1 38 41 80 00       	mov    0x804138,%eax
  80289c:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8028a2:	8b 4a 0c             	mov    0xc(%edx),%ecx
  8028a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8028a8:	8b 52 0c             	mov    0xc(%edx),%edx
  8028ab:	01 ca                	add    %ecx,%edx
  8028ad:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->sva=0;
  8028b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		blockToInsert->size=0;
  8028ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8028bd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)

		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8028c4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028c8:	75 17                	jne    8028e1 <insert_sorted_with_merge_freeList+0x28b>
  8028ca:	83 ec 04             	sub    $0x4,%esp
  8028cd:	68 b0 38 80 00       	push   $0x8038b0
  8028d2:	68 5d 01 00 00       	push   $0x15d
  8028d7:	68 d3 38 80 00       	push   $0x8038d3
  8028dc:	e8 88 05 00 00       	call   802e69 <_panic>
  8028e1:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8028e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ea:	89 10                	mov    %edx,(%eax)
  8028ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ef:	8b 00                	mov    (%eax),%eax
  8028f1:	85 c0                	test   %eax,%eax
  8028f3:	74 0d                	je     802902 <insert_sorted_with_merge_freeList+0x2ac>
  8028f5:	a1 48 41 80 00       	mov    0x804148,%eax
  8028fa:	8b 55 08             	mov    0x8(%ebp),%edx
  8028fd:	89 50 04             	mov    %edx,0x4(%eax)
  802900:	eb 08                	jmp    80290a <insert_sorted_with_merge_freeList+0x2b4>
  802902:	8b 45 08             	mov    0x8(%ebp),%eax
  802905:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80290a:	8b 45 08             	mov    0x8(%ebp),%eax
  80290d:	a3 48 41 80 00       	mov    %eax,0x804148
  802912:	8b 45 08             	mov    0x8(%ebp),%eax
  802915:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80291c:	a1 54 41 80 00       	mov    0x804154,%eax
  802921:	40                   	inc    %eax
  802922:	a3 54 41 80 00       	mov    %eax,0x804154
  802927:	e9 37 05 00 00       	jmp    802e63 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva!=(blockToInsert->sva+blockToInsert->size))
  80292c:	8b 45 08             	mov    0x8(%ebp),%eax
  80292f:	8b 50 08             	mov    0x8(%eax),%edx
  802932:	a1 38 41 80 00       	mov    0x804138,%eax
  802937:	8b 40 08             	mov    0x8(%eax),%eax
  80293a:	39 c2                	cmp    %eax,%edx
  80293c:	0f 83 82 00 00 00    	jae    8029c4 <insert_sorted_with_merge_freeList+0x36e>
  802942:	a1 38 41 80 00       	mov    0x804138,%eax
  802947:	8b 50 08             	mov    0x8(%eax),%edx
  80294a:	8b 45 08             	mov    0x8(%ebp),%eax
  80294d:	8b 48 08             	mov    0x8(%eax),%ecx
  802950:	8b 45 08             	mov    0x8(%ebp),%eax
  802953:	8b 40 0c             	mov    0xc(%eax),%eax
  802956:	01 c8                	add    %ecx,%eax
  802958:	39 c2                	cmp    %eax,%edx
  80295a:	74 68                	je     8029c4 <insert_sorted_with_merge_freeList+0x36e>

	{
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  80295c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802960:	75 17                	jne    802979 <insert_sorted_with_merge_freeList+0x323>
  802962:	83 ec 04             	sub    $0x4,%esp
  802965:	68 b0 38 80 00       	push   $0x8038b0
  80296a:	68 62 01 00 00       	push   $0x162
  80296f:	68 d3 38 80 00       	push   $0x8038d3
  802974:	e8 f0 04 00 00       	call   802e69 <_panic>
  802979:	8b 15 38 41 80 00    	mov    0x804138,%edx
  80297f:	8b 45 08             	mov    0x8(%ebp),%eax
  802982:	89 10                	mov    %edx,(%eax)
  802984:	8b 45 08             	mov    0x8(%ebp),%eax
  802987:	8b 00                	mov    (%eax),%eax
  802989:	85 c0                	test   %eax,%eax
  80298b:	74 0d                	je     80299a <insert_sorted_with_merge_freeList+0x344>
  80298d:	a1 38 41 80 00       	mov    0x804138,%eax
  802992:	8b 55 08             	mov    0x8(%ebp),%edx
  802995:	89 50 04             	mov    %edx,0x4(%eax)
  802998:	eb 08                	jmp    8029a2 <insert_sorted_with_merge_freeList+0x34c>
  80299a:	8b 45 08             	mov    0x8(%ebp),%eax
  80299d:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8029a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a5:	a3 38 41 80 00       	mov    %eax,0x804138
  8029aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ad:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029b4:	a1 44 41 80 00       	mov    0x804144,%eax
  8029b9:	40                   	inc    %eax
  8029ba:	a3 44 41 80 00       	mov    %eax,0x804144
  8029bf:	e9 9f 04 00 00       	jmp    802e63 <insert_sorted_with_merge_freeList+0x80d>
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
  8029c4:	a1 38 41 80 00       	mov    0x804138,%eax
  8029c9:	8b 00                	mov    (%eax),%eax
  8029cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  8029ce:	e9 84 04 00 00       	jmp    802e57 <insert_sorted_with_merge_freeList+0x801>
		{
			if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  8029d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d6:	8b 50 08             	mov    0x8(%eax),%edx
  8029d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8029dc:	8b 40 08             	mov    0x8(%eax),%eax
  8029df:	39 c2                	cmp    %eax,%edx
  8029e1:	0f 86 a9 00 00 00    	jbe    802a90 <insert_sorted_with_merge_freeList+0x43a>
  8029e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ea:	8b 50 08             	mov    0x8(%eax),%edx
  8029ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f0:	8b 48 08             	mov    0x8(%eax),%ecx
  8029f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f6:	8b 40 0c             	mov    0xc(%eax),%eax
  8029f9:	01 c8                	add    %ecx,%eax
  8029fb:	39 c2                	cmp    %eax,%edx
  8029fd:	0f 84 8d 00 00 00    	je     802a90 <insert_sorted_with_merge_freeList+0x43a>
  802a03:	8b 45 08             	mov    0x8(%ebp),%eax
  802a06:	8b 50 08             	mov    0x8(%eax),%edx
  802a09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0c:	8b 40 04             	mov    0x4(%eax),%eax
  802a0f:	8b 48 08             	mov    0x8(%eax),%ecx
  802a12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a15:	8b 40 04             	mov    0x4(%eax),%eax
  802a18:	8b 40 0c             	mov    0xc(%eax),%eax
  802a1b:	01 c8                	add    %ecx,%eax
  802a1d:	39 c2                	cmp    %eax,%edx
  802a1f:	74 6f                	je     802a90 <insert_sorted_with_merge_freeList+0x43a>
			{
				LIST_INSERT_BEFORE(&FreeMemBlocksList,tmp,blockToInsert);
  802a21:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a25:	74 06                	je     802a2d <insert_sorted_with_merge_freeList+0x3d7>
  802a27:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a2b:	75 17                	jne    802a44 <insert_sorted_with_merge_freeList+0x3ee>
  802a2d:	83 ec 04             	sub    $0x4,%esp
  802a30:	68 10 39 80 00       	push   $0x803910
  802a35:	68 6b 01 00 00       	push   $0x16b
  802a3a:	68 d3 38 80 00       	push   $0x8038d3
  802a3f:	e8 25 04 00 00       	call   802e69 <_panic>
  802a44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a47:	8b 50 04             	mov    0x4(%eax),%edx
  802a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4d:	89 50 04             	mov    %edx,0x4(%eax)
  802a50:	8b 45 08             	mov    0x8(%ebp),%eax
  802a53:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a56:	89 10                	mov    %edx,(%eax)
  802a58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5b:	8b 40 04             	mov    0x4(%eax),%eax
  802a5e:	85 c0                	test   %eax,%eax
  802a60:	74 0d                	je     802a6f <insert_sorted_with_merge_freeList+0x419>
  802a62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a65:	8b 40 04             	mov    0x4(%eax),%eax
  802a68:	8b 55 08             	mov    0x8(%ebp),%edx
  802a6b:	89 10                	mov    %edx,(%eax)
  802a6d:	eb 08                	jmp    802a77 <insert_sorted_with_merge_freeList+0x421>
  802a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a72:	a3 38 41 80 00       	mov    %eax,0x804138
  802a77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7a:	8b 55 08             	mov    0x8(%ebp),%edx
  802a7d:	89 50 04             	mov    %edx,0x4(%eax)
  802a80:	a1 44 41 80 00       	mov    0x804144,%eax
  802a85:	40                   	inc    %eax
  802a86:	a3 44 41 80 00       	mov    %eax,0x804144
				break;
  802a8b:	e9 d3 03 00 00       	jmp    802e63 <insert_sorted_with_merge_freeList+0x80d>
			}// no merge
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802a90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a93:	8b 50 08             	mov    0x8(%eax),%edx
  802a96:	8b 45 08             	mov    0x8(%ebp),%eax
  802a99:	8b 40 08             	mov    0x8(%eax),%eax
  802a9c:	39 c2                	cmp    %eax,%edx
  802a9e:	0f 86 da 00 00 00    	jbe    802b7e <insert_sorted_with_merge_freeList+0x528>
  802aa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa7:	8b 50 08             	mov    0x8(%eax),%edx
  802aaa:	8b 45 08             	mov    0x8(%ebp),%eax
  802aad:	8b 48 08             	mov    0x8(%eax),%ecx
  802ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab3:	8b 40 0c             	mov    0xc(%eax),%eax
  802ab6:	01 c8                	add    %ecx,%eax
  802ab8:	39 c2                	cmp    %eax,%edx
  802aba:	0f 85 be 00 00 00    	jne    802b7e <insert_sorted_with_merge_freeList+0x528>
  802ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac3:	8b 50 08             	mov    0x8(%eax),%edx
  802ac6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac9:	8b 40 04             	mov    0x4(%eax),%eax
  802acc:	8b 48 08             	mov    0x8(%eax),%ecx
  802acf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad2:	8b 40 04             	mov    0x4(%eax),%eax
  802ad5:	8b 40 0c             	mov    0xc(%eax),%eax
  802ad8:	01 c8                	add    %ecx,%eax
  802ada:	39 c2                	cmp    %eax,%edx
  802adc:	0f 84 9c 00 00 00    	je     802b7e <insert_sorted_with_merge_freeList+0x528>
			{
tmp->sva=blockToInsert->sva;
  802ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae5:	8b 50 08             	mov    0x8(%eax),%edx
  802ae8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aeb:	89 50 08             	mov    %edx,0x8(%eax)
tmp->size+=blockToInsert->size;
  802aee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af1:	8b 50 0c             	mov    0xc(%eax),%edx
  802af4:	8b 45 08             	mov    0x8(%ebp),%eax
  802af7:	8b 40 0c             	mov    0xc(%eax),%eax
  802afa:	01 c2                	add    %eax,%edx
  802afc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aff:	89 50 0c             	mov    %edx,0xc(%eax)
blockToInsert->sva=0;
  802b02:	8b 45 08             	mov    0x8(%ebp),%eax
  802b05:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
blockToInsert->size=0;
  802b0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802b16:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b1a:	75 17                	jne    802b33 <insert_sorted_with_merge_freeList+0x4dd>
  802b1c:	83 ec 04             	sub    $0x4,%esp
  802b1f:	68 b0 38 80 00       	push   $0x8038b0
  802b24:	68 74 01 00 00       	push   $0x174
  802b29:	68 d3 38 80 00       	push   $0x8038d3
  802b2e:	e8 36 03 00 00       	call   802e69 <_panic>
  802b33:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b39:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3c:	89 10                	mov    %edx,(%eax)
  802b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b41:	8b 00                	mov    (%eax),%eax
  802b43:	85 c0                	test   %eax,%eax
  802b45:	74 0d                	je     802b54 <insert_sorted_with_merge_freeList+0x4fe>
  802b47:	a1 48 41 80 00       	mov    0x804148,%eax
  802b4c:	8b 55 08             	mov    0x8(%ebp),%edx
  802b4f:	89 50 04             	mov    %edx,0x4(%eax)
  802b52:	eb 08                	jmp    802b5c <insert_sorted_with_merge_freeList+0x506>
  802b54:	8b 45 08             	mov    0x8(%ebp),%eax
  802b57:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5f:	a3 48 41 80 00       	mov    %eax,0x804148
  802b64:	8b 45 08             	mov    0x8(%ebp),%eax
  802b67:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b6e:	a1 54 41 80 00       	mov    0x804154,%eax
  802b73:	40                   	inc    %eax
  802b74:	a3 54 41 80 00       	mov    %eax,0x804154
break;
  802b79:	e9 e5 02 00 00       	jmp    802e63 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with the next
			else if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802b7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b81:	8b 50 08             	mov    0x8(%eax),%edx
  802b84:	8b 45 08             	mov    0x8(%ebp),%eax
  802b87:	8b 40 08             	mov    0x8(%eax),%eax
  802b8a:	39 c2                	cmp    %eax,%edx
  802b8c:	0f 86 d7 00 00 00    	jbe    802c69 <insert_sorted_with_merge_freeList+0x613>
  802b92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b95:	8b 50 08             	mov    0x8(%eax),%edx
  802b98:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9b:	8b 48 08             	mov    0x8(%eax),%ecx
  802b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ba4:	01 c8                	add    %ecx,%eax
  802ba6:	39 c2                	cmp    %eax,%edx
  802ba8:	0f 84 bb 00 00 00    	je     802c69 <insert_sorted_with_merge_freeList+0x613>
  802bae:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb1:	8b 50 08             	mov    0x8(%eax),%edx
  802bb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb7:	8b 40 04             	mov    0x4(%eax),%eax
  802bba:	8b 48 08             	mov    0x8(%eax),%ecx
  802bbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc0:	8b 40 04             	mov    0x4(%eax),%eax
  802bc3:	8b 40 0c             	mov    0xc(%eax),%eax
  802bc6:	01 c8                	add    %ecx,%eax
  802bc8:	39 c2                	cmp    %eax,%edx
  802bca:	0f 85 99 00 00 00    	jne    802c69 <insert_sorted_with_merge_freeList+0x613>
			{
				struct MemBlock *ptr=LIST_PREV(tmp);
  802bd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd3:	8b 40 04             	mov    0x4(%eax),%eax
  802bd6:	89 45 f0             	mov    %eax,-0x10(%ebp)
				ptr->size+=blockToInsert->size;
  802bd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bdc:	8b 50 0c             	mov    0xc(%eax),%edx
  802bdf:	8b 45 08             	mov    0x8(%ebp),%eax
  802be2:	8b 40 0c             	mov    0xc(%eax),%eax
  802be5:	01 c2                	add    %eax,%edx
  802be7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bea:	89 50 0c             	mov    %edx,0xc(%eax)
				blockToInsert->sva=0;
  802bed:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size =0;
  802bf7:	8b 45 08             	mov    0x8(%ebp),%eax
  802bfa:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802c01:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c05:	75 17                	jne    802c1e <insert_sorted_with_merge_freeList+0x5c8>
  802c07:	83 ec 04             	sub    $0x4,%esp
  802c0a:	68 b0 38 80 00       	push   $0x8038b0
  802c0f:	68 7d 01 00 00       	push   $0x17d
  802c14:	68 d3 38 80 00       	push   $0x8038d3
  802c19:	e8 4b 02 00 00       	call   802e69 <_panic>
  802c1e:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c24:	8b 45 08             	mov    0x8(%ebp),%eax
  802c27:	89 10                	mov    %edx,(%eax)
  802c29:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2c:	8b 00                	mov    (%eax),%eax
  802c2e:	85 c0                	test   %eax,%eax
  802c30:	74 0d                	je     802c3f <insert_sorted_with_merge_freeList+0x5e9>
  802c32:	a1 48 41 80 00       	mov    0x804148,%eax
  802c37:	8b 55 08             	mov    0x8(%ebp),%edx
  802c3a:	89 50 04             	mov    %edx,0x4(%eax)
  802c3d:	eb 08                	jmp    802c47 <insert_sorted_with_merge_freeList+0x5f1>
  802c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c42:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c47:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4a:	a3 48 41 80 00       	mov    %eax,0x804148
  802c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c52:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c59:	a1 54 41 80 00       	mov    0x804154,%eax
  802c5e:	40                   	inc    %eax
  802c5f:	a3 54 41 80 00       	mov    %eax,0x804154
break;
  802c64:	e9 fa 01 00 00       	jmp    802e63 <insert_sorted_with_merge_freeList+0x80d>
			}// merge with previous
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802c69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6c:	8b 50 08             	mov    0x8(%eax),%edx
  802c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c72:	8b 40 08             	mov    0x8(%eax),%eax
  802c75:	39 c2                	cmp    %eax,%edx
  802c77:	0f 86 d2 01 00 00    	jbe    802e4f <insert_sorted_with_merge_freeList+0x7f9>
  802c7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c80:	8b 50 08             	mov    0x8(%eax),%edx
  802c83:	8b 45 08             	mov    0x8(%ebp),%eax
  802c86:	8b 48 08             	mov    0x8(%eax),%ecx
  802c89:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8c:	8b 40 0c             	mov    0xc(%eax),%eax
  802c8f:	01 c8                	add    %ecx,%eax
  802c91:	39 c2                	cmp    %eax,%edx
  802c93:	0f 85 b6 01 00 00    	jne    802e4f <insert_sorted_with_merge_freeList+0x7f9>
  802c99:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9c:	8b 50 08             	mov    0x8(%eax),%edx
  802c9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca2:	8b 40 04             	mov    0x4(%eax),%eax
  802ca5:	8b 48 08             	mov    0x8(%eax),%ecx
  802ca8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cab:	8b 40 04             	mov    0x4(%eax),%eax
  802cae:	8b 40 0c             	mov    0xc(%eax),%eax
  802cb1:	01 c8                	add    %ecx,%eax
  802cb3:	39 c2                	cmp    %eax,%edx
  802cb5:	0f 85 94 01 00 00    	jne    802e4f <insert_sorted_with_merge_freeList+0x7f9>
			{

				LIST_PREV(tmp)->size+=blockToInsert->size+tmp->size;
  802cbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbe:	8b 40 04             	mov    0x4(%eax),%eax
  802cc1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cc4:	8b 52 04             	mov    0x4(%edx),%edx
  802cc7:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802cca:	8b 55 08             	mov    0x8(%ebp),%edx
  802ccd:	8b 5a 0c             	mov    0xc(%edx),%ebx
  802cd0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cd3:	8b 52 0c             	mov    0xc(%edx),%edx
  802cd6:	01 da                	add    %ebx,%edx
  802cd8:	01 ca                	add    %ecx,%edx
  802cda:	89 50 0c             	mov    %edx,0xc(%eax)
				tmp->size=0;
  802cdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				tmp->sva=0;
  802ce7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cea:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  802cf1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cf5:	75 17                	jne    802d0e <insert_sorted_with_merge_freeList+0x6b8>
  802cf7:	83 ec 04             	sub    $0x4,%esp
  802cfa:	68 45 39 80 00       	push   $0x803945
  802cff:	68 86 01 00 00       	push   $0x186
  802d04:	68 d3 38 80 00       	push   $0x8038d3
  802d09:	e8 5b 01 00 00       	call   802e69 <_panic>
  802d0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d11:	8b 00                	mov    (%eax),%eax
  802d13:	85 c0                	test   %eax,%eax
  802d15:	74 10                	je     802d27 <insert_sorted_with_merge_freeList+0x6d1>
  802d17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1a:	8b 00                	mov    (%eax),%eax
  802d1c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d1f:	8b 52 04             	mov    0x4(%edx),%edx
  802d22:	89 50 04             	mov    %edx,0x4(%eax)
  802d25:	eb 0b                	jmp    802d32 <insert_sorted_with_merge_freeList+0x6dc>
  802d27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2a:	8b 40 04             	mov    0x4(%eax),%eax
  802d2d:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802d32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d35:	8b 40 04             	mov    0x4(%eax),%eax
  802d38:	85 c0                	test   %eax,%eax
  802d3a:	74 0f                	je     802d4b <insert_sorted_with_merge_freeList+0x6f5>
  802d3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3f:	8b 40 04             	mov    0x4(%eax),%eax
  802d42:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d45:	8b 12                	mov    (%edx),%edx
  802d47:	89 10                	mov    %edx,(%eax)
  802d49:	eb 0a                	jmp    802d55 <insert_sorted_with_merge_freeList+0x6ff>
  802d4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4e:	8b 00                	mov    (%eax),%eax
  802d50:	a3 38 41 80 00       	mov    %eax,0x804138
  802d55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d58:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d61:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d68:	a1 44 41 80 00       	mov    0x804144,%eax
  802d6d:	48                   	dec    %eax
  802d6e:	a3 44 41 80 00       	mov    %eax,0x804144
				LIST_INSERT_HEAD(&AvailableMemBlocksList,tmp);
  802d73:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d77:	75 17                	jne    802d90 <insert_sorted_with_merge_freeList+0x73a>
  802d79:	83 ec 04             	sub    $0x4,%esp
  802d7c:	68 b0 38 80 00       	push   $0x8038b0
  802d81:	68 87 01 00 00       	push   $0x187
  802d86:	68 d3 38 80 00       	push   $0x8038d3
  802d8b:	e8 d9 00 00 00       	call   802e69 <_panic>
  802d90:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d99:	89 10                	mov    %edx,(%eax)
  802d9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9e:	8b 00                	mov    (%eax),%eax
  802da0:	85 c0                	test   %eax,%eax
  802da2:	74 0d                	je     802db1 <insert_sorted_with_merge_freeList+0x75b>
  802da4:	a1 48 41 80 00       	mov    0x804148,%eax
  802da9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dac:	89 50 04             	mov    %edx,0x4(%eax)
  802daf:	eb 08                	jmp    802db9 <insert_sorted_with_merge_freeList+0x763>
  802db1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db4:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802db9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbc:	a3 48 41 80 00       	mov    %eax,0x804148
  802dc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dcb:	a1 54 41 80 00       	mov    0x804154,%eax
  802dd0:	40                   	inc    %eax
  802dd1:	a3 54 41 80 00       	mov    %eax,0x804154
				blockToInsert->sva=0;
  802dd6:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size=0;
  802de0:	8b 45 08             	mov    0x8(%ebp),%eax
  802de3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802dea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dee:	75 17                	jne    802e07 <insert_sorted_with_merge_freeList+0x7b1>
  802df0:	83 ec 04             	sub    $0x4,%esp
  802df3:	68 b0 38 80 00       	push   $0x8038b0
  802df8:	68 8a 01 00 00       	push   $0x18a
  802dfd:	68 d3 38 80 00       	push   $0x8038d3
  802e02:	e8 62 00 00 00       	call   802e69 <_panic>
  802e07:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e10:	89 10                	mov    %edx,(%eax)
  802e12:	8b 45 08             	mov    0x8(%ebp),%eax
  802e15:	8b 00                	mov    (%eax),%eax
  802e17:	85 c0                	test   %eax,%eax
  802e19:	74 0d                	je     802e28 <insert_sorted_with_merge_freeList+0x7d2>
  802e1b:	a1 48 41 80 00       	mov    0x804148,%eax
  802e20:	8b 55 08             	mov    0x8(%ebp),%edx
  802e23:	89 50 04             	mov    %edx,0x4(%eax)
  802e26:	eb 08                	jmp    802e30 <insert_sorted_with_merge_freeList+0x7da>
  802e28:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e30:	8b 45 08             	mov    0x8(%ebp),%eax
  802e33:	a3 48 41 80 00       	mov    %eax,0x804148
  802e38:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e42:	a1 54 41 80 00       	mov    0x804154,%eax
  802e47:	40                   	inc    %eax
  802e48:	a3 54 41 80 00       	mov    %eax,0x804154
				break;
  802e4d:	eb 14                	jmp    802e63 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with next and previous
			tmp=tmp->prev_next_info.le_next;
  802e4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e52:	8b 00                	mov    (%eax),%eax
  802e54:	89 45 f4             	mov    %eax,-0xc(%ebp)
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
		while(tmp!=NULL)
  802e57:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e5b:	0f 85 72 fb ff ff    	jne    8029d3 <insert_sorted_with_merge_freeList+0x37d>
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  802e61:	eb 00                	jmp    802e63 <insert_sorted_with_merge_freeList+0x80d>
  802e63:	90                   	nop
  802e64:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802e67:	c9                   	leave  
  802e68:	c3                   	ret    

00802e69 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  802e69:	55                   	push   %ebp
  802e6a:	89 e5                	mov    %esp,%ebp
  802e6c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  802e6f:	8d 45 10             	lea    0x10(%ebp),%eax
  802e72:	83 c0 04             	add    $0x4,%eax
  802e75:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  802e78:	a1 5c 41 80 00       	mov    0x80415c,%eax
  802e7d:	85 c0                	test   %eax,%eax
  802e7f:	74 16                	je     802e97 <_panic+0x2e>
		cprintf("%s: ", argv0);
  802e81:	a1 5c 41 80 00       	mov    0x80415c,%eax
  802e86:	83 ec 08             	sub    $0x8,%esp
  802e89:	50                   	push   %eax
  802e8a:	68 64 39 80 00       	push   $0x803964
  802e8f:	e8 b4 d4 ff ff       	call   800348 <cprintf>
  802e94:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  802e97:	a1 00 40 80 00       	mov    0x804000,%eax
  802e9c:	ff 75 0c             	pushl  0xc(%ebp)
  802e9f:	ff 75 08             	pushl  0x8(%ebp)
  802ea2:	50                   	push   %eax
  802ea3:	68 69 39 80 00       	push   $0x803969
  802ea8:	e8 9b d4 ff ff       	call   800348 <cprintf>
  802ead:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  802eb0:	8b 45 10             	mov    0x10(%ebp),%eax
  802eb3:	83 ec 08             	sub    $0x8,%esp
  802eb6:	ff 75 f4             	pushl  -0xc(%ebp)
  802eb9:	50                   	push   %eax
  802eba:	e8 1e d4 ff ff       	call   8002dd <vcprintf>
  802ebf:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  802ec2:	83 ec 08             	sub    $0x8,%esp
  802ec5:	6a 00                	push   $0x0
  802ec7:	68 85 39 80 00       	push   $0x803985
  802ecc:	e8 0c d4 ff ff       	call   8002dd <vcprintf>
  802ed1:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  802ed4:	e8 8d d3 ff ff       	call   800266 <exit>

	// should not return here
	while (1) ;
  802ed9:	eb fe                	jmp    802ed9 <_panic+0x70>

00802edb <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  802edb:	55                   	push   %ebp
  802edc:	89 e5                	mov    %esp,%ebp
  802ede:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  802ee1:	a1 20 40 80 00       	mov    0x804020,%eax
  802ee6:	8b 50 74             	mov    0x74(%eax),%edx
  802ee9:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eec:	39 c2                	cmp    %eax,%edx
  802eee:	74 14                	je     802f04 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  802ef0:	83 ec 04             	sub    $0x4,%esp
  802ef3:	68 88 39 80 00       	push   $0x803988
  802ef8:	6a 26                	push   $0x26
  802efa:	68 d4 39 80 00       	push   $0x8039d4
  802eff:	e8 65 ff ff ff       	call   802e69 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  802f04:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  802f0b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802f12:	e9 c2 00 00 00       	jmp    802fd9 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  802f17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f1a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802f21:	8b 45 08             	mov    0x8(%ebp),%eax
  802f24:	01 d0                	add    %edx,%eax
  802f26:	8b 00                	mov    (%eax),%eax
  802f28:	85 c0                	test   %eax,%eax
  802f2a:	75 08                	jne    802f34 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  802f2c:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  802f2f:	e9 a2 00 00 00       	jmp    802fd6 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  802f34:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802f3b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802f42:	eb 69                	jmp    802fad <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  802f44:	a1 20 40 80 00       	mov    0x804020,%eax
  802f49:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  802f4f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f52:	89 d0                	mov    %edx,%eax
  802f54:	01 c0                	add    %eax,%eax
  802f56:	01 d0                	add    %edx,%eax
  802f58:	c1 e0 03             	shl    $0x3,%eax
  802f5b:	01 c8                	add    %ecx,%eax
  802f5d:	8a 40 04             	mov    0x4(%eax),%al
  802f60:	84 c0                	test   %al,%al
  802f62:	75 46                	jne    802faa <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  802f64:	a1 20 40 80 00       	mov    0x804020,%eax
  802f69:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  802f6f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f72:	89 d0                	mov    %edx,%eax
  802f74:	01 c0                	add    %eax,%eax
  802f76:	01 d0                	add    %edx,%eax
  802f78:	c1 e0 03             	shl    $0x3,%eax
  802f7b:	01 c8                	add    %ecx,%eax
  802f7d:	8b 00                	mov    (%eax),%eax
  802f7f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802f82:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f85:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802f8a:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  802f8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f8f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  802f96:	8b 45 08             	mov    0x8(%ebp),%eax
  802f99:	01 c8                	add    %ecx,%eax
  802f9b:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  802f9d:	39 c2                	cmp    %eax,%edx
  802f9f:	75 09                	jne    802faa <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  802fa1:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  802fa8:	eb 12                	jmp    802fbc <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802faa:	ff 45 e8             	incl   -0x18(%ebp)
  802fad:	a1 20 40 80 00       	mov    0x804020,%eax
  802fb2:	8b 50 74             	mov    0x74(%eax),%edx
  802fb5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fb8:	39 c2                	cmp    %eax,%edx
  802fba:	77 88                	ja     802f44 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  802fbc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802fc0:	75 14                	jne    802fd6 <CheckWSWithoutLastIndex+0xfb>
			panic(
  802fc2:	83 ec 04             	sub    $0x4,%esp
  802fc5:	68 e0 39 80 00       	push   $0x8039e0
  802fca:	6a 3a                	push   $0x3a
  802fcc:	68 d4 39 80 00       	push   $0x8039d4
  802fd1:	e8 93 fe ff ff       	call   802e69 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  802fd6:	ff 45 f0             	incl   -0x10(%ebp)
  802fd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fdc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802fdf:	0f 8c 32 ff ff ff    	jl     802f17 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  802fe5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802fec:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802ff3:	eb 26                	jmp    80301b <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  802ff5:	a1 20 40 80 00       	mov    0x804020,%eax
  802ffa:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803000:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803003:	89 d0                	mov    %edx,%eax
  803005:	01 c0                	add    %eax,%eax
  803007:	01 d0                	add    %edx,%eax
  803009:	c1 e0 03             	shl    $0x3,%eax
  80300c:	01 c8                	add    %ecx,%eax
  80300e:	8a 40 04             	mov    0x4(%eax),%al
  803011:	3c 01                	cmp    $0x1,%al
  803013:	75 03                	jne    803018 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  803015:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803018:	ff 45 e0             	incl   -0x20(%ebp)
  80301b:	a1 20 40 80 00       	mov    0x804020,%eax
  803020:	8b 50 74             	mov    0x74(%eax),%edx
  803023:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803026:	39 c2                	cmp    %eax,%edx
  803028:	77 cb                	ja     802ff5 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80302a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80302d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803030:	74 14                	je     803046 <CheckWSWithoutLastIndex+0x16b>
		panic(
  803032:	83 ec 04             	sub    $0x4,%esp
  803035:	68 34 3a 80 00       	push   $0x803a34
  80303a:	6a 44                	push   $0x44
  80303c:	68 d4 39 80 00       	push   $0x8039d4
  803041:	e8 23 fe ff ff       	call   802e69 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803046:	90                   	nop
  803047:	c9                   	leave  
  803048:	c3                   	ret    
  803049:	66 90                	xchg   %ax,%ax
  80304b:	90                   	nop

0080304c <__udivdi3>:
  80304c:	55                   	push   %ebp
  80304d:	57                   	push   %edi
  80304e:	56                   	push   %esi
  80304f:	53                   	push   %ebx
  803050:	83 ec 1c             	sub    $0x1c,%esp
  803053:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803057:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80305b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80305f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803063:	89 ca                	mov    %ecx,%edx
  803065:	89 f8                	mov    %edi,%eax
  803067:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80306b:	85 f6                	test   %esi,%esi
  80306d:	75 2d                	jne    80309c <__udivdi3+0x50>
  80306f:	39 cf                	cmp    %ecx,%edi
  803071:	77 65                	ja     8030d8 <__udivdi3+0x8c>
  803073:	89 fd                	mov    %edi,%ebp
  803075:	85 ff                	test   %edi,%edi
  803077:	75 0b                	jne    803084 <__udivdi3+0x38>
  803079:	b8 01 00 00 00       	mov    $0x1,%eax
  80307e:	31 d2                	xor    %edx,%edx
  803080:	f7 f7                	div    %edi
  803082:	89 c5                	mov    %eax,%ebp
  803084:	31 d2                	xor    %edx,%edx
  803086:	89 c8                	mov    %ecx,%eax
  803088:	f7 f5                	div    %ebp
  80308a:	89 c1                	mov    %eax,%ecx
  80308c:	89 d8                	mov    %ebx,%eax
  80308e:	f7 f5                	div    %ebp
  803090:	89 cf                	mov    %ecx,%edi
  803092:	89 fa                	mov    %edi,%edx
  803094:	83 c4 1c             	add    $0x1c,%esp
  803097:	5b                   	pop    %ebx
  803098:	5e                   	pop    %esi
  803099:	5f                   	pop    %edi
  80309a:	5d                   	pop    %ebp
  80309b:	c3                   	ret    
  80309c:	39 ce                	cmp    %ecx,%esi
  80309e:	77 28                	ja     8030c8 <__udivdi3+0x7c>
  8030a0:	0f bd fe             	bsr    %esi,%edi
  8030a3:	83 f7 1f             	xor    $0x1f,%edi
  8030a6:	75 40                	jne    8030e8 <__udivdi3+0x9c>
  8030a8:	39 ce                	cmp    %ecx,%esi
  8030aa:	72 0a                	jb     8030b6 <__udivdi3+0x6a>
  8030ac:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8030b0:	0f 87 9e 00 00 00    	ja     803154 <__udivdi3+0x108>
  8030b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8030bb:	89 fa                	mov    %edi,%edx
  8030bd:	83 c4 1c             	add    $0x1c,%esp
  8030c0:	5b                   	pop    %ebx
  8030c1:	5e                   	pop    %esi
  8030c2:	5f                   	pop    %edi
  8030c3:	5d                   	pop    %ebp
  8030c4:	c3                   	ret    
  8030c5:	8d 76 00             	lea    0x0(%esi),%esi
  8030c8:	31 ff                	xor    %edi,%edi
  8030ca:	31 c0                	xor    %eax,%eax
  8030cc:	89 fa                	mov    %edi,%edx
  8030ce:	83 c4 1c             	add    $0x1c,%esp
  8030d1:	5b                   	pop    %ebx
  8030d2:	5e                   	pop    %esi
  8030d3:	5f                   	pop    %edi
  8030d4:	5d                   	pop    %ebp
  8030d5:	c3                   	ret    
  8030d6:	66 90                	xchg   %ax,%ax
  8030d8:	89 d8                	mov    %ebx,%eax
  8030da:	f7 f7                	div    %edi
  8030dc:	31 ff                	xor    %edi,%edi
  8030de:	89 fa                	mov    %edi,%edx
  8030e0:	83 c4 1c             	add    $0x1c,%esp
  8030e3:	5b                   	pop    %ebx
  8030e4:	5e                   	pop    %esi
  8030e5:	5f                   	pop    %edi
  8030e6:	5d                   	pop    %ebp
  8030e7:	c3                   	ret    
  8030e8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8030ed:	89 eb                	mov    %ebp,%ebx
  8030ef:	29 fb                	sub    %edi,%ebx
  8030f1:	89 f9                	mov    %edi,%ecx
  8030f3:	d3 e6                	shl    %cl,%esi
  8030f5:	89 c5                	mov    %eax,%ebp
  8030f7:	88 d9                	mov    %bl,%cl
  8030f9:	d3 ed                	shr    %cl,%ebp
  8030fb:	89 e9                	mov    %ebp,%ecx
  8030fd:	09 f1                	or     %esi,%ecx
  8030ff:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803103:	89 f9                	mov    %edi,%ecx
  803105:	d3 e0                	shl    %cl,%eax
  803107:	89 c5                	mov    %eax,%ebp
  803109:	89 d6                	mov    %edx,%esi
  80310b:	88 d9                	mov    %bl,%cl
  80310d:	d3 ee                	shr    %cl,%esi
  80310f:	89 f9                	mov    %edi,%ecx
  803111:	d3 e2                	shl    %cl,%edx
  803113:	8b 44 24 08          	mov    0x8(%esp),%eax
  803117:	88 d9                	mov    %bl,%cl
  803119:	d3 e8                	shr    %cl,%eax
  80311b:	09 c2                	or     %eax,%edx
  80311d:	89 d0                	mov    %edx,%eax
  80311f:	89 f2                	mov    %esi,%edx
  803121:	f7 74 24 0c          	divl   0xc(%esp)
  803125:	89 d6                	mov    %edx,%esi
  803127:	89 c3                	mov    %eax,%ebx
  803129:	f7 e5                	mul    %ebp
  80312b:	39 d6                	cmp    %edx,%esi
  80312d:	72 19                	jb     803148 <__udivdi3+0xfc>
  80312f:	74 0b                	je     80313c <__udivdi3+0xf0>
  803131:	89 d8                	mov    %ebx,%eax
  803133:	31 ff                	xor    %edi,%edi
  803135:	e9 58 ff ff ff       	jmp    803092 <__udivdi3+0x46>
  80313a:	66 90                	xchg   %ax,%ax
  80313c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803140:	89 f9                	mov    %edi,%ecx
  803142:	d3 e2                	shl    %cl,%edx
  803144:	39 c2                	cmp    %eax,%edx
  803146:	73 e9                	jae    803131 <__udivdi3+0xe5>
  803148:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80314b:	31 ff                	xor    %edi,%edi
  80314d:	e9 40 ff ff ff       	jmp    803092 <__udivdi3+0x46>
  803152:	66 90                	xchg   %ax,%ax
  803154:	31 c0                	xor    %eax,%eax
  803156:	e9 37 ff ff ff       	jmp    803092 <__udivdi3+0x46>
  80315b:	90                   	nop

0080315c <__umoddi3>:
  80315c:	55                   	push   %ebp
  80315d:	57                   	push   %edi
  80315e:	56                   	push   %esi
  80315f:	53                   	push   %ebx
  803160:	83 ec 1c             	sub    $0x1c,%esp
  803163:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803167:	8b 74 24 34          	mov    0x34(%esp),%esi
  80316b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80316f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803173:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803177:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80317b:	89 f3                	mov    %esi,%ebx
  80317d:	89 fa                	mov    %edi,%edx
  80317f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803183:	89 34 24             	mov    %esi,(%esp)
  803186:	85 c0                	test   %eax,%eax
  803188:	75 1a                	jne    8031a4 <__umoddi3+0x48>
  80318a:	39 f7                	cmp    %esi,%edi
  80318c:	0f 86 a2 00 00 00    	jbe    803234 <__umoddi3+0xd8>
  803192:	89 c8                	mov    %ecx,%eax
  803194:	89 f2                	mov    %esi,%edx
  803196:	f7 f7                	div    %edi
  803198:	89 d0                	mov    %edx,%eax
  80319a:	31 d2                	xor    %edx,%edx
  80319c:	83 c4 1c             	add    $0x1c,%esp
  80319f:	5b                   	pop    %ebx
  8031a0:	5e                   	pop    %esi
  8031a1:	5f                   	pop    %edi
  8031a2:	5d                   	pop    %ebp
  8031a3:	c3                   	ret    
  8031a4:	39 f0                	cmp    %esi,%eax
  8031a6:	0f 87 ac 00 00 00    	ja     803258 <__umoddi3+0xfc>
  8031ac:	0f bd e8             	bsr    %eax,%ebp
  8031af:	83 f5 1f             	xor    $0x1f,%ebp
  8031b2:	0f 84 ac 00 00 00    	je     803264 <__umoddi3+0x108>
  8031b8:	bf 20 00 00 00       	mov    $0x20,%edi
  8031bd:	29 ef                	sub    %ebp,%edi
  8031bf:	89 fe                	mov    %edi,%esi
  8031c1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8031c5:	89 e9                	mov    %ebp,%ecx
  8031c7:	d3 e0                	shl    %cl,%eax
  8031c9:	89 d7                	mov    %edx,%edi
  8031cb:	89 f1                	mov    %esi,%ecx
  8031cd:	d3 ef                	shr    %cl,%edi
  8031cf:	09 c7                	or     %eax,%edi
  8031d1:	89 e9                	mov    %ebp,%ecx
  8031d3:	d3 e2                	shl    %cl,%edx
  8031d5:	89 14 24             	mov    %edx,(%esp)
  8031d8:	89 d8                	mov    %ebx,%eax
  8031da:	d3 e0                	shl    %cl,%eax
  8031dc:	89 c2                	mov    %eax,%edx
  8031de:	8b 44 24 08          	mov    0x8(%esp),%eax
  8031e2:	d3 e0                	shl    %cl,%eax
  8031e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8031e8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8031ec:	89 f1                	mov    %esi,%ecx
  8031ee:	d3 e8                	shr    %cl,%eax
  8031f0:	09 d0                	or     %edx,%eax
  8031f2:	d3 eb                	shr    %cl,%ebx
  8031f4:	89 da                	mov    %ebx,%edx
  8031f6:	f7 f7                	div    %edi
  8031f8:	89 d3                	mov    %edx,%ebx
  8031fa:	f7 24 24             	mull   (%esp)
  8031fd:	89 c6                	mov    %eax,%esi
  8031ff:	89 d1                	mov    %edx,%ecx
  803201:	39 d3                	cmp    %edx,%ebx
  803203:	0f 82 87 00 00 00    	jb     803290 <__umoddi3+0x134>
  803209:	0f 84 91 00 00 00    	je     8032a0 <__umoddi3+0x144>
  80320f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803213:	29 f2                	sub    %esi,%edx
  803215:	19 cb                	sbb    %ecx,%ebx
  803217:	89 d8                	mov    %ebx,%eax
  803219:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80321d:	d3 e0                	shl    %cl,%eax
  80321f:	89 e9                	mov    %ebp,%ecx
  803221:	d3 ea                	shr    %cl,%edx
  803223:	09 d0                	or     %edx,%eax
  803225:	89 e9                	mov    %ebp,%ecx
  803227:	d3 eb                	shr    %cl,%ebx
  803229:	89 da                	mov    %ebx,%edx
  80322b:	83 c4 1c             	add    $0x1c,%esp
  80322e:	5b                   	pop    %ebx
  80322f:	5e                   	pop    %esi
  803230:	5f                   	pop    %edi
  803231:	5d                   	pop    %ebp
  803232:	c3                   	ret    
  803233:	90                   	nop
  803234:	89 fd                	mov    %edi,%ebp
  803236:	85 ff                	test   %edi,%edi
  803238:	75 0b                	jne    803245 <__umoddi3+0xe9>
  80323a:	b8 01 00 00 00       	mov    $0x1,%eax
  80323f:	31 d2                	xor    %edx,%edx
  803241:	f7 f7                	div    %edi
  803243:	89 c5                	mov    %eax,%ebp
  803245:	89 f0                	mov    %esi,%eax
  803247:	31 d2                	xor    %edx,%edx
  803249:	f7 f5                	div    %ebp
  80324b:	89 c8                	mov    %ecx,%eax
  80324d:	f7 f5                	div    %ebp
  80324f:	89 d0                	mov    %edx,%eax
  803251:	e9 44 ff ff ff       	jmp    80319a <__umoddi3+0x3e>
  803256:	66 90                	xchg   %ax,%ax
  803258:	89 c8                	mov    %ecx,%eax
  80325a:	89 f2                	mov    %esi,%edx
  80325c:	83 c4 1c             	add    $0x1c,%esp
  80325f:	5b                   	pop    %ebx
  803260:	5e                   	pop    %esi
  803261:	5f                   	pop    %edi
  803262:	5d                   	pop    %ebp
  803263:	c3                   	ret    
  803264:	3b 04 24             	cmp    (%esp),%eax
  803267:	72 06                	jb     80326f <__umoddi3+0x113>
  803269:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80326d:	77 0f                	ja     80327e <__umoddi3+0x122>
  80326f:	89 f2                	mov    %esi,%edx
  803271:	29 f9                	sub    %edi,%ecx
  803273:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803277:	89 14 24             	mov    %edx,(%esp)
  80327a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80327e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803282:	8b 14 24             	mov    (%esp),%edx
  803285:	83 c4 1c             	add    $0x1c,%esp
  803288:	5b                   	pop    %ebx
  803289:	5e                   	pop    %esi
  80328a:	5f                   	pop    %edi
  80328b:	5d                   	pop    %ebp
  80328c:	c3                   	ret    
  80328d:	8d 76 00             	lea    0x0(%esi),%esi
  803290:	2b 04 24             	sub    (%esp),%eax
  803293:	19 fa                	sbb    %edi,%edx
  803295:	89 d1                	mov    %edx,%ecx
  803297:	89 c6                	mov    %eax,%esi
  803299:	e9 71 ff ff ff       	jmp    80320f <__umoddi3+0xb3>
  80329e:	66 90                	xchg   %ax,%ax
  8032a0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8032a4:	72 ea                	jb     803290 <__umoddi3+0x134>
  8032a6:	89 d9                	mov    %ebx,%ecx
  8032a8:	e9 62 ff ff ff       	jmp    80320f <__umoddi3+0xb3>
