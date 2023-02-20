
obj/user/tst_air:     file format elf32-i386


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
  800031:	e8 15 0b 00 00       	call   800b4b <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <user/air.h>
int find(int* arr, int size, int val);

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec fc 01 00 00    	sub    $0x1fc,%esp
	int envID = sys_getenvid();
  800044:	e8 6d 25 00 00       	call   8025b6 <sys_getenvid>
  800049:	89 45 bc             	mov    %eax,-0x44(%ebp)

	// *************************************************************************************************
	/// Shared Variables Region ************************************************************************
	// *************************************************************************************************

	int numOfCustomers = 15;
  80004c:	c7 45 b8 0f 00 00 00 	movl   $0xf,-0x48(%ebp)
	int flight1Customers = 3;
  800053:	c7 45 b4 03 00 00 00 	movl   $0x3,-0x4c(%ebp)
	int flight2Customers = 8;
  80005a:	c7 45 b0 08 00 00 00 	movl   $0x8,-0x50(%ebp)
	int flight3Customers = 4;
  800061:	c7 45 ac 04 00 00 00 	movl   $0x4,-0x54(%ebp)

	int flight1NumOfTickets = 8;
  800068:	c7 45 a8 08 00 00 00 	movl   $0x8,-0x58(%ebp)
	int flight2NumOfTickets = 15;
  80006f:	c7 45 a4 0f 00 00 00 	movl   $0xf,-0x5c(%ebp)

	char _customers[] = "customers";
  800076:	8d 85 6a ff ff ff    	lea    -0x96(%ebp),%eax
  80007c:	bb 56 40 80 00       	mov    $0x804056,%ebx
  800081:	ba 0a 00 00 00       	mov    $0xa,%edx
  800086:	89 c7                	mov    %eax,%edi
  800088:	89 de                	mov    %ebx,%esi
  80008a:	89 d1                	mov    %edx,%ecx
  80008c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custCounter[] = "custCounter";
  80008e:	8d 85 5e ff ff ff    	lea    -0xa2(%ebp),%eax
  800094:	bb 60 40 80 00       	mov    $0x804060,%ebx
  800099:	ba 03 00 00 00       	mov    $0x3,%edx
  80009e:	89 c7                	mov    %eax,%edi
  8000a0:	89 de                	mov    %ebx,%esi
  8000a2:	89 d1                	mov    %edx,%ecx
  8000a4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1Counter[] = "flight1Counter";
  8000a6:	8d 85 4f ff ff ff    	lea    -0xb1(%ebp),%eax
  8000ac:	bb 6c 40 80 00       	mov    $0x80406c,%ebx
  8000b1:	ba 0f 00 00 00       	mov    $0xf,%edx
  8000b6:	89 c7                	mov    %eax,%edi
  8000b8:	89 de                	mov    %ebx,%esi
  8000ba:	89 d1                	mov    %edx,%ecx
  8000bc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Counter[] = "flight2Counter";
  8000be:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
  8000c4:	bb 7b 40 80 00       	mov    $0x80407b,%ebx
  8000c9:	ba 0f 00 00 00       	mov    $0xf,%edx
  8000ce:	89 c7                	mov    %eax,%edi
  8000d0:	89 de                	mov    %ebx,%esi
  8000d2:	89 d1                	mov    %edx,%ecx
  8000d4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Counter[] = "flightBooked1Counter";
  8000d6:	8d 85 2b ff ff ff    	lea    -0xd5(%ebp),%eax
  8000dc:	bb 8a 40 80 00       	mov    $0x80408a,%ebx
  8000e1:	ba 15 00 00 00       	mov    $0x15,%edx
  8000e6:	89 c7                	mov    %eax,%edi
  8000e8:	89 de                	mov    %ebx,%esi
  8000ea:	89 d1                	mov    %edx,%ecx
  8000ec:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Counter[] = "flightBooked2Counter";
  8000ee:	8d 85 16 ff ff ff    	lea    -0xea(%ebp),%eax
  8000f4:	bb 9f 40 80 00       	mov    $0x80409f,%ebx
  8000f9:	ba 15 00 00 00       	mov    $0x15,%edx
  8000fe:	89 c7                	mov    %eax,%edi
  800100:	89 de                	mov    %ebx,%esi
  800102:	89 d1                	mov    %edx,%ecx
  800104:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Arr[] = "flightBooked1Arr";
  800106:	8d 85 05 ff ff ff    	lea    -0xfb(%ebp),%eax
  80010c:	bb b4 40 80 00       	mov    $0x8040b4,%ebx
  800111:	ba 11 00 00 00       	mov    $0x11,%edx
  800116:	89 c7                	mov    %eax,%edi
  800118:	89 de                	mov    %ebx,%esi
  80011a:	89 d1                	mov    %edx,%ecx
  80011c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Arr[] = "flightBooked2Arr";
  80011e:	8d 85 f4 fe ff ff    	lea    -0x10c(%ebp),%eax
  800124:	bb c5 40 80 00       	mov    $0x8040c5,%ebx
  800129:	ba 11 00 00 00       	mov    $0x11,%edx
  80012e:	89 c7                	mov    %eax,%edi
  800130:	89 de                	mov    %ebx,%esi
  800132:	89 d1                	mov    %edx,%ecx
  800134:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _cust_ready_queue[] = "cust_ready_queue";
  800136:	8d 85 e3 fe ff ff    	lea    -0x11d(%ebp),%eax
  80013c:	bb d6 40 80 00       	mov    $0x8040d6,%ebx
  800141:	ba 11 00 00 00       	mov    $0x11,%edx
  800146:	89 c7                	mov    %eax,%edi
  800148:	89 de                	mov    %ebx,%esi
  80014a:	89 d1                	mov    %edx,%ecx
  80014c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_in[] = "queue_in";
  80014e:	8d 85 da fe ff ff    	lea    -0x126(%ebp),%eax
  800154:	bb e7 40 80 00       	mov    $0x8040e7,%ebx
  800159:	ba 09 00 00 00       	mov    $0x9,%edx
  80015e:	89 c7                	mov    %eax,%edi
  800160:	89 de                	mov    %ebx,%esi
  800162:	89 d1                	mov    %edx,%ecx
  800164:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_out[] = "queue_out";
  800166:	8d 85 d0 fe ff ff    	lea    -0x130(%ebp),%eax
  80016c:	bb f0 40 80 00       	mov    $0x8040f0,%ebx
  800171:	ba 0a 00 00 00       	mov    $0xa,%edx
  800176:	89 c7                	mov    %eax,%edi
  800178:	89 de                	mov    %ebx,%esi
  80017a:	89 d1                	mov    %edx,%ecx
  80017c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _cust_ready[] = "cust_ready";
  80017e:	8d 85 c5 fe ff ff    	lea    -0x13b(%ebp),%eax
  800184:	bb fa 40 80 00       	mov    $0x8040fa,%ebx
  800189:	ba 0b 00 00 00       	mov    $0xb,%edx
  80018e:	89 c7                	mov    %eax,%edi
  800190:	89 de                	mov    %ebx,%esi
  800192:	89 d1                	mov    %edx,%ecx
  800194:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custQueueCS[] = "custQueueCS";
  800196:	8d 85 b9 fe ff ff    	lea    -0x147(%ebp),%eax
  80019c:	bb 05 41 80 00       	mov    $0x804105,%ebx
  8001a1:	ba 03 00 00 00       	mov    $0x3,%edx
  8001a6:	89 c7                	mov    %eax,%edi
  8001a8:	89 de                	mov    %ebx,%esi
  8001aa:	89 d1                	mov    %edx,%ecx
  8001ac:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1CS[] = "flight1CS";
  8001ae:	8d 85 af fe ff ff    	lea    -0x151(%ebp),%eax
  8001b4:	bb 11 41 80 00       	mov    $0x804111,%ebx
  8001b9:	ba 0a 00 00 00       	mov    $0xa,%edx
  8001be:	89 c7                	mov    %eax,%edi
  8001c0:	89 de                	mov    %ebx,%esi
  8001c2:	89 d1                	mov    %edx,%ecx
  8001c4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2CS[] = "flight2CS";
  8001c6:	8d 85 a5 fe ff ff    	lea    -0x15b(%ebp),%eax
  8001cc:	bb 1b 41 80 00       	mov    $0x80411b,%ebx
  8001d1:	ba 0a 00 00 00       	mov    $0xa,%edx
  8001d6:	89 c7                	mov    %eax,%edi
  8001d8:	89 de                	mov    %ebx,%esi
  8001da:	89 d1                	mov    %edx,%ecx
  8001dc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _clerk[] = "clerk";
  8001de:	c7 85 9f fe ff ff 63 	movl   $0x72656c63,-0x161(%ebp)
  8001e5:	6c 65 72 
  8001e8:	66 c7 85 a3 fe ff ff 	movw   $0x6b,-0x15d(%ebp)
  8001ef:	6b 00 
	char _custCounterCS[] = "custCounterCS";
  8001f1:	8d 85 91 fe ff ff    	lea    -0x16f(%ebp),%eax
  8001f7:	bb 25 41 80 00       	mov    $0x804125,%ebx
  8001fc:	ba 0e 00 00 00       	mov    $0xe,%edx
  800201:	89 c7                	mov    %eax,%edi
  800203:	89 de                	mov    %ebx,%esi
  800205:	89 d1                	mov    %edx,%ecx
  800207:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custTerminated[] = "custTerminated";
  800209:	8d 85 82 fe ff ff    	lea    -0x17e(%ebp),%eax
  80020f:	bb 33 41 80 00       	mov    $0x804133,%ebx
  800214:	ba 0f 00 00 00       	mov    $0xf,%edx
  800219:	89 c7                	mov    %eax,%edi
  80021b:	89 de                	mov    %ebx,%esi
  80021d:	89 d1                	mov    %edx,%ecx
  80021f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _taircl[] = "taircl";
  800221:	8d 85 7b fe ff ff    	lea    -0x185(%ebp),%eax
  800227:	bb 42 41 80 00       	mov    $0x804142,%ebx
  80022c:	ba 07 00 00 00       	mov    $0x7,%edx
  800231:	89 c7                	mov    %eax,%edi
  800233:	89 de                	mov    %ebx,%esi
  800235:	89 d1                	mov    %edx,%ecx
  800237:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _taircu[] = "taircu";
  800239:	8d 85 74 fe ff ff    	lea    -0x18c(%ebp),%eax
  80023f:	bb 49 41 80 00       	mov    $0x804149,%ebx
  800244:	ba 07 00 00 00       	mov    $0x7,%edx
  800249:	89 c7                	mov    %eax,%edi
  80024b:	89 de                	mov    %ebx,%esi
  80024d:	89 d1                	mov    %edx,%ecx
  80024f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	struct Customer * custs;
	custs = smalloc(_customers, sizeof(struct Customer)*numOfCustomers, 1);
  800251:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800254:	c1 e0 03             	shl    $0x3,%eax
  800257:	83 ec 04             	sub    $0x4,%esp
  80025a:	6a 01                	push   $0x1
  80025c:	50                   	push   %eax
  80025d:	8d 85 6a ff ff ff    	lea    -0x96(%ebp),%eax
  800263:	50                   	push   %eax
  800264:	e8 83 1d 00 00       	call   801fec <smalloc>
  800269:	83 c4 10             	add    $0x10,%esp
  80026c:	89 45 a0             	mov    %eax,-0x60(%ebp)
	//sys_createSharedObject("customers", sizeof(struct Customer)*numOfCustomers, 1, (void**)&custs);


	{
		int f1 = 0;
  80026f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		for(;f1<flight1Customers; ++f1)
  800276:	eb 2e                	jmp    8002a6 <_main+0x26e>
		{
			custs[f1].booked = 0;
  800278:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80027b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800282:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800285:	01 d0                	add    %edx,%eax
  800287:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
			custs[f1].flightType = 1;
  80028e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800291:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800298:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80029b:	01 d0                	add    %edx,%eax
  80029d:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
	//sys_createSharedObject("customers", sizeof(struct Customer)*numOfCustomers, 1, (void**)&custs);


	{
		int f1 = 0;
		for(;f1<flight1Customers; ++f1)
  8002a3:	ff 45 e4             	incl   -0x1c(%ebp)
  8002a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002a9:	3b 45 b4             	cmp    -0x4c(%ebp),%eax
  8002ac:	7c ca                	jl     800278 <_main+0x240>
		{
			custs[f1].booked = 0;
			custs[f1].flightType = 1;
		}

		int f2=f1;
  8002ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
		for(;f2<f1+flight2Customers; ++f2)
  8002b4:	eb 2e                	jmp    8002e4 <_main+0x2ac>
		{
			custs[f2].booked = 0;
  8002b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002b9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8002c0:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8002c3:	01 d0                	add    %edx,%eax
  8002c5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
			custs[f2].flightType = 2;
  8002cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002cf:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8002d6:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8002d9:	01 d0                	add    %edx,%eax
  8002db:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
			custs[f1].booked = 0;
			custs[f1].flightType = 1;
		}

		int f2=f1;
		for(;f2<f1+flight2Customers; ++f2)
  8002e1:	ff 45 e0             	incl   -0x20(%ebp)
  8002e4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002e7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8002ea:	01 d0                	add    %edx,%eax
  8002ec:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002ef:	7f c5                	jg     8002b6 <_main+0x27e>
		{
			custs[f2].booked = 0;
			custs[f2].flightType = 2;
		}

		int f3=f2;
  8002f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002f4:	89 45 dc             	mov    %eax,-0x24(%ebp)
		for(;f3<f2+flight3Customers; ++f3)
  8002f7:	eb 2e                	jmp    800327 <_main+0x2ef>
		{
			custs[f3].booked = 0;
  8002f9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002fc:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800303:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800306:	01 d0                	add    %edx,%eax
  800308:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
			custs[f3].flightType = 3;
  80030f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800312:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800319:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80031c:	01 d0                	add    %edx,%eax
  80031e:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
			custs[f2].booked = 0;
			custs[f2].flightType = 2;
		}

		int f3=f2;
		for(;f3<f2+flight3Customers; ++f3)
  800324:	ff 45 dc             	incl   -0x24(%ebp)
  800327:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80032a:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80032d:	01 d0                	add    %edx,%eax
  80032f:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800332:	7f c5                	jg     8002f9 <_main+0x2c1>
			custs[f3].booked = 0;
			custs[f3].flightType = 3;
		}
	}

	int* custCounter = smalloc(_custCounter, sizeof(int), 1);
  800334:	83 ec 04             	sub    $0x4,%esp
  800337:	6a 01                	push   $0x1
  800339:	6a 04                	push   $0x4
  80033b:	8d 85 5e ff ff ff    	lea    -0xa2(%ebp),%eax
  800341:	50                   	push   %eax
  800342:	e8 a5 1c 00 00       	call   801fec <smalloc>
  800347:	83 c4 10             	add    $0x10,%esp
  80034a:	89 45 9c             	mov    %eax,-0x64(%ebp)
	*custCounter = 0;
  80034d:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800350:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int* flight1Counter = smalloc(_flight1Counter, sizeof(int), 1);
  800356:	83 ec 04             	sub    $0x4,%esp
  800359:	6a 01                	push   $0x1
  80035b:	6a 04                	push   $0x4
  80035d:	8d 85 4f ff ff ff    	lea    -0xb1(%ebp),%eax
  800363:	50                   	push   %eax
  800364:	e8 83 1c 00 00       	call   801fec <smalloc>
  800369:	83 c4 10             	add    $0x10,%esp
  80036c:	89 45 98             	mov    %eax,-0x68(%ebp)
	*flight1Counter = flight1NumOfTickets;
  80036f:	8b 45 98             	mov    -0x68(%ebp),%eax
  800372:	8b 55 a8             	mov    -0x58(%ebp),%edx
  800375:	89 10                	mov    %edx,(%eax)

	int* flight2Counter = smalloc(_flight2Counter, sizeof(int), 1);
  800377:	83 ec 04             	sub    $0x4,%esp
  80037a:	6a 01                	push   $0x1
  80037c:	6a 04                	push   $0x4
  80037e:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
  800384:	50                   	push   %eax
  800385:	e8 62 1c 00 00       	call   801fec <smalloc>
  80038a:	83 c4 10             	add    $0x10,%esp
  80038d:	89 45 94             	mov    %eax,-0x6c(%ebp)
	*flight2Counter = flight2NumOfTickets;
  800390:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800393:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  800396:	89 10                	mov    %edx,(%eax)

	int* flight1BookedCounter = smalloc(_flightBooked1Counter, sizeof(int), 1);
  800398:	83 ec 04             	sub    $0x4,%esp
  80039b:	6a 01                	push   $0x1
  80039d:	6a 04                	push   $0x4
  80039f:	8d 85 2b ff ff ff    	lea    -0xd5(%ebp),%eax
  8003a5:	50                   	push   %eax
  8003a6:	e8 41 1c 00 00       	call   801fec <smalloc>
  8003ab:	83 c4 10             	add    $0x10,%esp
  8003ae:	89 45 90             	mov    %eax,-0x70(%ebp)
	*flight1BookedCounter = 0;
  8003b1:	8b 45 90             	mov    -0x70(%ebp),%eax
  8003b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int* flight2BookedCounter = smalloc(_flightBooked2Counter, sizeof(int), 1);
  8003ba:	83 ec 04             	sub    $0x4,%esp
  8003bd:	6a 01                	push   $0x1
  8003bf:	6a 04                	push   $0x4
  8003c1:	8d 85 16 ff ff ff    	lea    -0xea(%ebp),%eax
  8003c7:	50                   	push   %eax
  8003c8:	e8 1f 1c 00 00       	call   801fec <smalloc>
  8003cd:	83 c4 10             	add    $0x10,%esp
  8003d0:	89 45 8c             	mov    %eax,-0x74(%ebp)
	*flight2BookedCounter = 0;
  8003d3:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8003d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int* flight1BookedArr = smalloc(_flightBooked1Arr, sizeof(int)*flight1NumOfTickets, 1);
  8003dc:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8003df:	c1 e0 02             	shl    $0x2,%eax
  8003e2:	83 ec 04             	sub    $0x4,%esp
  8003e5:	6a 01                	push   $0x1
  8003e7:	50                   	push   %eax
  8003e8:	8d 85 05 ff ff ff    	lea    -0xfb(%ebp),%eax
  8003ee:	50                   	push   %eax
  8003ef:	e8 f8 1b 00 00       	call   801fec <smalloc>
  8003f4:	83 c4 10             	add    $0x10,%esp
  8003f7:	89 45 88             	mov    %eax,-0x78(%ebp)
	int* flight2BookedArr = smalloc(_flightBooked2Arr, sizeof(int)*flight2NumOfTickets, 1);
  8003fa:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003fd:	c1 e0 02             	shl    $0x2,%eax
  800400:	83 ec 04             	sub    $0x4,%esp
  800403:	6a 01                	push   $0x1
  800405:	50                   	push   %eax
  800406:	8d 85 f4 fe ff ff    	lea    -0x10c(%ebp),%eax
  80040c:	50                   	push   %eax
  80040d:	e8 da 1b 00 00       	call   801fec <smalloc>
  800412:	83 c4 10             	add    $0x10,%esp
  800415:	89 45 84             	mov    %eax,-0x7c(%ebp)

	int* cust_ready_queue = smalloc(_cust_ready_queue, sizeof(int)*numOfCustomers, 1);
  800418:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80041b:	c1 e0 02             	shl    $0x2,%eax
  80041e:	83 ec 04             	sub    $0x4,%esp
  800421:	6a 01                	push   $0x1
  800423:	50                   	push   %eax
  800424:	8d 85 e3 fe ff ff    	lea    -0x11d(%ebp),%eax
  80042a:	50                   	push   %eax
  80042b:	e8 bc 1b 00 00       	call   801fec <smalloc>
  800430:	83 c4 10             	add    $0x10,%esp
  800433:	89 45 80             	mov    %eax,-0x80(%ebp)

	int* queue_in = smalloc(_queue_in, sizeof(int), 1);
  800436:	83 ec 04             	sub    $0x4,%esp
  800439:	6a 01                	push   $0x1
  80043b:	6a 04                	push   $0x4
  80043d:	8d 85 da fe ff ff    	lea    -0x126(%ebp),%eax
  800443:	50                   	push   %eax
  800444:	e8 a3 1b 00 00       	call   801fec <smalloc>
  800449:	83 c4 10             	add    $0x10,%esp
  80044c:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
	*queue_in = 0;
  800452:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800458:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int* queue_out = smalloc(_queue_out, sizeof(int), 1);
  80045e:	83 ec 04             	sub    $0x4,%esp
  800461:	6a 01                	push   $0x1
  800463:	6a 04                	push   $0x4
  800465:	8d 85 d0 fe ff ff    	lea    -0x130(%ebp),%eax
  80046b:	50                   	push   %eax
  80046c:	e8 7b 1b 00 00       	call   801fec <smalloc>
  800471:	83 c4 10             	add    $0x10,%esp
  800474:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
	*queue_out = 0;
  80047a:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800480:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	// *************************************************************************************************
	/// Semaphores Region ******************************************************************************
	// *************************************************************************************************
	sys_createSemaphore(_flight1CS, 1);
  800486:	83 ec 08             	sub    $0x8,%esp
  800489:	6a 01                	push   $0x1
  80048b:	8d 85 af fe ff ff    	lea    -0x151(%ebp),%eax
  800491:	50                   	push   %eax
  800492:	e8 b9 1f 00 00       	call   802450 <sys_createSemaphore>
  800497:	83 c4 10             	add    $0x10,%esp
	sys_createSemaphore(_flight2CS, 1);
  80049a:	83 ec 08             	sub    $0x8,%esp
  80049d:	6a 01                	push   $0x1
  80049f:	8d 85 a5 fe ff ff    	lea    -0x15b(%ebp),%eax
  8004a5:	50                   	push   %eax
  8004a6:	e8 a5 1f 00 00       	call   802450 <sys_createSemaphore>
  8004ab:	83 c4 10             	add    $0x10,%esp

	sys_createSemaphore(_custCounterCS, 1);
  8004ae:	83 ec 08             	sub    $0x8,%esp
  8004b1:	6a 01                	push   $0x1
  8004b3:	8d 85 91 fe ff ff    	lea    -0x16f(%ebp),%eax
  8004b9:	50                   	push   %eax
  8004ba:	e8 91 1f 00 00       	call   802450 <sys_createSemaphore>
  8004bf:	83 c4 10             	add    $0x10,%esp
	sys_createSemaphore(_custQueueCS, 1);
  8004c2:	83 ec 08             	sub    $0x8,%esp
  8004c5:	6a 01                	push   $0x1
  8004c7:	8d 85 b9 fe ff ff    	lea    -0x147(%ebp),%eax
  8004cd:	50                   	push   %eax
  8004ce:	e8 7d 1f 00 00       	call   802450 <sys_createSemaphore>
  8004d3:	83 c4 10             	add    $0x10,%esp

	sys_createSemaphore(_clerk, 3);
  8004d6:	83 ec 08             	sub    $0x8,%esp
  8004d9:	6a 03                	push   $0x3
  8004db:	8d 85 9f fe ff ff    	lea    -0x161(%ebp),%eax
  8004e1:	50                   	push   %eax
  8004e2:	e8 69 1f 00 00       	call   802450 <sys_createSemaphore>
  8004e7:	83 c4 10             	add    $0x10,%esp

	sys_createSemaphore(_cust_ready, 0);
  8004ea:	83 ec 08             	sub    $0x8,%esp
  8004ed:	6a 00                	push   $0x0
  8004ef:	8d 85 c5 fe ff ff    	lea    -0x13b(%ebp),%eax
  8004f5:	50                   	push   %eax
  8004f6:	e8 55 1f 00 00       	call   802450 <sys_createSemaphore>
  8004fb:	83 c4 10             	add    $0x10,%esp

	sys_createSemaphore(_custTerminated, 0);
  8004fe:	83 ec 08             	sub    $0x8,%esp
  800501:	6a 00                	push   $0x0
  800503:	8d 85 82 fe ff ff    	lea    -0x17e(%ebp),%eax
  800509:	50                   	push   %eax
  80050a:	e8 41 1f 00 00       	call   802450 <sys_createSemaphore>
  80050f:	83 c4 10             	add    $0x10,%esp

	int s=0;
  800512:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
	for(s=0; s<numOfCustomers; ++s)
  800519:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800520:	eb 78                	jmp    80059a <_main+0x562>
	{
		char prefix[30]="cust_finished";
  800522:	8d 85 56 fe ff ff    	lea    -0x1aa(%ebp),%eax
  800528:	bb 50 41 80 00       	mov    $0x804150,%ebx
  80052d:	ba 0e 00 00 00       	mov    $0xe,%edx
  800532:	89 c7                	mov    %eax,%edi
  800534:	89 de                	mov    %ebx,%esi
  800536:	89 d1                	mov    %edx,%ecx
  800538:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80053a:	8d 95 64 fe ff ff    	lea    -0x19c(%ebp),%edx
  800540:	b9 04 00 00 00       	mov    $0x4,%ecx
  800545:	b8 00 00 00 00       	mov    $0x0,%eax
  80054a:	89 d7                	mov    %edx,%edi
  80054c:	f3 ab                	rep stos %eax,%es:(%edi)
		char id[5]; char sname[50];
		ltostr(s, id);
  80054e:	83 ec 08             	sub    $0x8,%esp
  800551:	8d 85 51 fe ff ff    	lea    -0x1af(%ebp),%eax
  800557:	50                   	push   %eax
  800558:	ff 75 d8             	pushl  -0x28(%ebp)
  80055b:	e8 03 15 00 00       	call   801a63 <ltostr>
  800560:	83 c4 10             	add    $0x10,%esp
		strcconcat(prefix, id, sname);
  800563:	83 ec 04             	sub    $0x4,%esp
  800566:	8d 85 fc fd ff ff    	lea    -0x204(%ebp),%eax
  80056c:	50                   	push   %eax
  80056d:	8d 85 51 fe ff ff    	lea    -0x1af(%ebp),%eax
  800573:	50                   	push   %eax
  800574:	8d 85 56 fe ff ff    	lea    -0x1aa(%ebp),%eax
  80057a:	50                   	push   %eax
  80057b:	e8 db 15 00 00       	call   801b5b <strcconcat>
  800580:	83 c4 10             	add    $0x10,%esp
		sys_createSemaphore(sname, 0);
  800583:	83 ec 08             	sub    $0x8,%esp
  800586:	6a 00                	push   $0x0
  800588:	8d 85 fc fd ff ff    	lea    -0x204(%ebp),%eax
  80058e:	50                   	push   %eax
  80058f:	e8 bc 1e 00 00       	call   802450 <sys_createSemaphore>
  800594:	83 c4 10             	add    $0x10,%esp
	sys_createSemaphore(_cust_ready, 0);

	sys_createSemaphore(_custTerminated, 0);

	int s=0;
	for(s=0; s<numOfCustomers; ++s)
  800597:	ff 45 d8             	incl   -0x28(%ebp)
  80059a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80059d:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8005a0:	7c 80                	jl     800522 <_main+0x4ea>
	// start all clerks and customers ******************************************************************
	// *************************************************************************************************

	//3 clerks
	uint32 envId;
	envId = sys_create_env(_taircl, (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8005a2:	a1 20 50 80 00       	mov    0x805020,%eax
  8005a7:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8005ad:	a1 20 50 80 00       	mov    0x805020,%eax
  8005b2:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8005b8:	89 c1                	mov    %eax,%ecx
  8005ba:	a1 20 50 80 00       	mov    0x805020,%eax
  8005bf:	8b 40 74             	mov    0x74(%eax),%eax
  8005c2:	52                   	push   %edx
  8005c3:	51                   	push   %ecx
  8005c4:	50                   	push   %eax
  8005c5:	8d 85 7b fe ff ff    	lea    -0x185(%ebp),%eax
  8005cb:	50                   	push   %eax
  8005cc:	e8 90 1f 00 00       	call   802561 <sys_create_env>
  8005d1:	83 c4 10             	add    $0x10,%esp
  8005d4:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
	sys_run_env(envId);
  8005da:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8005e0:	83 ec 0c             	sub    $0xc,%esp
  8005e3:	50                   	push   %eax
  8005e4:	e8 96 1f 00 00       	call   80257f <sys_run_env>
  8005e9:	83 c4 10             	add    $0x10,%esp

	envId = sys_create_env(_taircl, (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  8005ec:	a1 20 50 80 00       	mov    0x805020,%eax
  8005f1:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8005f7:	a1 20 50 80 00       	mov    0x805020,%eax
  8005fc:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800602:	89 c1                	mov    %eax,%ecx
  800604:	a1 20 50 80 00       	mov    0x805020,%eax
  800609:	8b 40 74             	mov    0x74(%eax),%eax
  80060c:	52                   	push   %edx
  80060d:	51                   	push   %ecx
  80060e:	50                   	push   %eax
  80060f:	8d 85 7b fe ff ff    	lea    -0x185(%ebp),%eax
  800615:	50                   	push   %eax
  800616:	e8 46 1f 00 00       	call   802561 <sys_create_env>
  80061b:	83 c4 10             	add    $0x10,%esp
  80061e:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
	sys_run_env(envId);
  800624:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  80062a:	83 ec 0c             	sub    $0xc,%esp
  80062d:	50                   	push   %eax
  80062e:	e8 4c 1f 00 00       	call   80257f <sys_run_env>
  800633:	83 c4 10             	add    $0x10,%esp

	envId = sys_create_env(_taircl, (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800636:	a1 20 50 80 00       	mov    0x805020,%eax
  80063b:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800641:	a1 20 50 80 00       	mov    0x805020,%eax
  800646:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80064c:	89 c1                	mov    %eax,%ecx
  80064e:	a1 20 50 80 00       	mov    0x805020,%eax
  800653:	8b 40 74             	mov    0x74(%eax),%eax
  800656:	52                   	push   %edx
  800657:	51                   	push   %ecx
  800658:	50                   	push   %eax
  800659:	8d 85 7b fe ff ff    	lea    -0x185(%ebp),%eax
  80065f:	50                   	push   %eax
  800660:	e8 fc 1e 00 00       	call   802561 <sys_create_env>
  800665:	83 c4 10             	add    $0x10,%esp
  800668:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
	sys_run_env(envId);
  80066e:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800674:	83 ec 0c             	sub    $0xc,%esp
  800677:	50                   	push   %eax
  800678:	e8 02 1f 00 00       	call   80257f <sys_run_env>
  80067d:	83 c4 10             	add    $0x10,%esp

	//customers
	int c;
	for(c=0; c< numOfCustomers;++c)
  800680:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  800687:	eb 6d                	jmp    8006f6 <_main+0x6be>
	{
		envId = sys_create_env(_taircu, (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800689:	a1 20 50 80 00       	mov    0x805020,%eax
  80068e:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800694:	a1 20 50 80 00       	mov    0x805020,%eax
  800699:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80069f:	89 c1                	mov    %eax,%ecx
  8006a1:	a1 20 50 80 00       	mov    0x805020,%eax
  8006a6:	8b 40 74             	mov    0x74(%eax),%eax
  8006a9:	52                   	push   %edx
  8006aa:	51                   	push   %ecx
  8006ab:	50                   	push   %eax
  8006ac:	8d 85 74 fe ff ff    	lea    -0x18c(%ebp),%eax
  8006b2:	50                   	push   %eax
  8006b3:	e8 a9 1e 00 00       	call   802561 <sys_create_env>
  8006b8:	83 c4 10             	add    $0x10,%esp
  8006bb:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
		if (envId == E_ENV_CREATION_ERROR)
  8006c1:	83 bd 74 ff ff ff ef 	cmpl   $0xffffffef,-0x8c(%ebp)
  8006c8:	75 17                	jne    8006e1 <_main+0x6a9>
			panic("NO AVAILABLE ENVs... Please reduce the num of customers and try again");
  8006ca:	83 ec 04             	sub    $0x4,%esp
  8006cd:	68 80 3d 80 00       	push   $0x803d80
  8006d2:	68 95 00 00 00       	push   $0x95
  8006d7:	68 c6 3d 80 00       	push   $0x803dc6
  8006dc:	e8 a6 05 00 00       	call   800c87 <_panic>

		sys_run_env(envId);
  8006e1:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8006e7:	83 ec 0c             	sub    $0xc,%esp
  8006ea:	50                   	push   %eax
  8006eb:	e8 8f 1e 00 00       	call   80257f <sys_run_env>
  8006f0:	83 c4 10             	add    $0x10,%esp
	envId = sys_create_env(_taircl, (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
	sys_run_env(envId);

	//customers
	int c;
	for(c=0; c< numOfCustomers;++c)
  8006f3:	ff 45 d4             	incl   -0x2c(%ebp)
  8006f6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006f9:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8006fc:	7c 8b                	jl     800689 <_main+0x651>

		sys_run_env(envId);
	}

	//wait until all customers terminated
	for(c=0; c< numOfCustomers;++c)
  8006fe:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  800705:	eb 18                	jmp    80071f <_main+0x6e7>
	{
		sys_waitSemaphore(envID, _custTerminated);
  800707:	83 ec 08             	sub    $0x8,%esp
  80070a:	8d 85 82 fe ff ff    	lea    -0x17e(%ebp),%eax
  800710:	50                   	push   %eax
  800711:	ff 75 bc             	pushl  -0x44(%ebp)
  800714:	e8 70 1d 00 00       	call   802489 <sys_waitSemaphore>
  800719:	83 c4 10             	add    $0x10,%esp

		sys_run_env(envId);
	}

	//wait until all customers terminated
	for(c=0; c< numOfCustomers;++c)
  80071c:	ff 45 d4             	incl   -0x2c(%ebp)
  80071f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800722:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  800725:	7c e0                	jl     800707 <_main+0x6cf>
	{
		sys_waitSemaphore(envID, _custTerminated);
	}

	env_sleep(1500);
  800727:	83 ec 0c             	sub    $0xc,%esp
  80072a:	68 dc 05 00 00       	push   $0x5dc
  80072f:	e8 28 33 00 00       	call   803a5c <env_sleep>
  800734:	83 c4 10             	add    $0x10,%esp

	//print out the results
	int b;
	for(b=0; b< (*flight1BookedCounter);++b)
  800737:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  80073e:	eb 45                	jmp    800785 <_main+0x74d>
	{
		cprintf("cust %d booked flight 1, originally ordered %d\n", flight1BookedArr[b], custs[flight1BookedArr[b]].flightType);
  800740:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800743:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80074a:	8b 45 88             	mov    -0x78(%ebp),%eax
  80074d:	01 d0                	add    %edx,%eax
  80074f:	8b 00                	mov    (%eax),%eax
  800751:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800758:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80075b:	01 d0                	add    %edx,%eax
  80075d:	8b 10                	mov    (%eax),%edx
  80075f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800762:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800769:	8b 45 88             	mov    -0x78(%ebp),%eax
  80076c:	01 c8                	add    %ecx,%eax
  80076e:	8b 00                	mov    (%eax),%eax
  800770:	83 ec 04             	sub    $0x4,%esp
  800773:	52                   	push   %edx
  800774:	50                   	push   %eax
  800775:	68 d8 3d 80 00       	push   $0x803dd8
  80077a:	e8 bc 07 00 00       	call   800f3b <cprintf>
  80077f:	83 c4 10             	add    $0x10,%esp

	env_sleep(1500);

	//print out the results
	int b;
	for(b=0; b< (*flight1BookedCounter);++b)
  800782:	ff 45 d0             	incl   -0x30(%ebp)
  800785:	8b 45 90             	mov    -0x70(%ebp),%eax
  800788:	8b 00                	mov    (%eax),%eax
  80078a:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80078d:	7f b1                	jg     800740 <_main+0x708>
	{
		cprintf("cust %d booked flight 1, originally ordered %d\n", flight1BookedArr[b], custs[flight1BookedArr[b]].flightType);
	}

	for(b=0; b< (*flight2BookedCounter);++b)
  80078f:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  800796:	eb 45                	jmp    8007dd <_main+0x7a5>
	{
		cprintf("cust %d booked flight 2, originally ordered %d\n", flight2BookedArr[b], custs[flight2BookedArr[b]].flightType);
  800798:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80079b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007a2:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8007a5:	01 d0                	add    %edx,%eax
  8007a7:	8b 00                	mov    (%eax),%eax
  8007a9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8007b0:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8007b3:	01 d0                	add    %edx,%eax
  8007b5:	8b 10                	mov    (%eax),%edx
  8007b7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007ba:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8007c1:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8007c4:	01 c8                	add    %ecx,%eax
  8007c6:	8b 00                	mov    (%eax),%eax
  8007c8:	83 ec 04             	sub    $0x4,%esp
  8007cb:	52                   	push   %edx
  8007cc:	50                   	push   %eax
  8007cd:	68 08 3e 80 00       	push   $0x803e08
  8007d2:	e8 64 07 00 00       	call   800f3b <cprintf>
  8007d7:	83 c4 10             	add    $0x10,%esp
	for(b=0; b< (*flight1BookedCounter);++b)
	{
		cprintf("cust %d booked flight 1, originally ordered %d\n", flight1BookedArr[b], custs[flight1BookedArr[b]].flightType);
	}

	for(b=0; b< (*flight2BookedCounter);++b)
  8007da:	ff 45 d0             	incl   -0x30(%ebp)
  8007dd:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8007e0:	8b 00                	mov    (%eax),%eax
  8007e2:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8007e5:	7f b1                	jg     800798 <_main+0x760>
		cprintf("cust %d booked flight 2, originally ordered %d\n", flight2BookedArr[b], custs[flight2BookedArr[b]].flightType);
	}

	//check out the final results and semaphores
	{
		int f1 = 0;
  8007e7:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
		for(;f1<flight1Customers; ++f1)
  8007ee:	eb 33                	jmp    800823 <_main+0x7eb>
		{
			if(find(flight1BookedArr, flight1NumOfTickets, f1) != 1)
  8007f0:	83 ec 04             	sub    $0x4,%esp
  8007f3:	ff 75 cc             	pushl  -0x34(%ebp)
  8007f6:	ff 75 a8             	pushl  -0x58(%ebp)
  8007f9:	ff 75 88             	pushl  -0x78(%ebp)
  8007fc:	e8 05 03 00 00       	call   800b06 <find>
  800801:	83 c4 10             	add    $0x10,%esp
  800804:	83 f8 01             	cmp    $0x1,%eax
  800807:	74 17                	je     800820 <_main+0x7e8>
			{
				panic("Error, wrong booking for user %d\n", f1);
  800809:	ff 75 cc             	pushl  -0x34(%ebp)
  80080c:	68 38 3e 80 00       	push   $0x803e38
  800811:	68 b5 00 00 00       	push   $0xb5
  800816:	68 c6 3d 80 00       	push   $0x803dc6
  80081b:	e8 67 04 00 00       	call   800c87 <_panic>
	}

	//check out the final results and semaphores
	{
		int f1 = 0;
		for(;f1<flight1Customers; ++f1)
  800820:	ff 45 cc             	incl   -0x34(%ebp)
  800823:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800826:	3b 45 b4             	cmp    -0x4c(%ebp),%eax
  800829:	7c c5                	jl     8007f0 <_main+0x7b8>
			{
				panic("Error, wrong booking for user %d\n", f1);
			}
		}

		int f2=f1;
  80082b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80082e:	89 45 c8             	mov    %eax,-0x38(%ebp)
		for(;f2<f1+flight2Customers; ++f2)
  800831:	eb 33                	jmp    800866 <_main+0x82e>
		{
			if(find(flight2BookedArr, flight2NumOfTickets, f2) != 1)
  800833:	83 ec 04             	sub    $0x4,%esp
  800836:	ff 75 c8             	pushl  -0x38(%ebp)
  800839:	ff 75 a4             	pushl  -0x5c(%ebp)
  80083c:	ff 75 84             	pushl  -0x7c(%ebp)
  80083f:	e8 c2 02 00 00       	call   800b06 <find>
  800844:	83 c4 10             	add    $0x10,%esp
  800847:	83 f8 01             	cmp    $0x1,%eax
  80084a:	74 17                	je     800863 <_main+0x82b>
			{
				panic("Error, wrong booking for user %d\n", f2);
  80084c:	ff 75 c8             	pushl  -0x38(%ebp)
  80084f:	68 38 3e 80 00       	push   $0x803e38
  800854:	68 be 00 00 00       	push   $0xbe
  800859:	68 c6 3d 80 00       	push   $0x803dc6
  80085e:	e8 24 04 00 00       	call   800c87 <_panic>
				panic("Error, wrong booking for user %d\n", f1);
			}
		}

		int f2=f1;
		for(;f2<f1+flight2Customers; ++f2)
  800863:	ff 45 c8             	incl   -0x38(%ebp)
  800866:	8b 55 cc             	mov    -0x34(%ebp),%edx
  800869:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80086c:	01 d0                	add    %edx,%eax
  80086e:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800871:	7f c0                	jg     800833 <_main+0x7fb>
			{
				panic("Error, wrong booking for user %d\n", f2);
			}
		}

		int f3=f2;
  800873:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800876:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		for(;f3<f2+flight3Customers; ++f3)
  800879:	eb 4c                	jmp    8008c7 <_main+0x88f>
		{
			if(find(flight1BookedArr, flight1NumOfTickets, f3) != 1 || find(flight2BookedArr, flight2NumOfTickets, f3) != 1)
  80087b:	83 ec 04             	sub    $0x4,%esp
  80087e:	ff 75 c4             	pushl  -0x3c(%ebp)
  800881:	ff 75 a8             	pushl  -0x58(%ebp)
  800884:	ff 75 88             	pushl  -0x78(%ebp)
  800887:	e8 7a 02 00 00       	call   800b06 <find>
  80088c:	83 c4 10             	add    $0x10,%esp
  80088f:	83 f8 01             	cmp    $0x1,%eax
  800892:	75 19                	jne    8008ad <_main+0x875>
  800894:	83 ec 04             	sub    $0x4,%esp
  800897:	ff 75 c4             	pushl  -0x3c(%ebp)
  80089a:	ff 75 a4             	pushl  -0x5c(%ebp)
  80089d:	ff 75 84             	pushl  -0x7c(%ebp)
  8008a0:	e8 61 02 00 00       	call   800b06 <find>
  8008a5:	83 c4 10             	add    $0x10,%esp
  8008a8:	83 f8 01             	cmp    $0x1,%eax
  8008ab:	74 17                	je     8008c4 <_main+0x88c>
			{
				panic("Error, wrong booking for user %d\n", f3);
  8008ad:	ff 75 c4             	pushl  -0x3c(%ebp)
  8008b0:	68 38 3e 80 00       	push   $0x803e38
  8008b5:	68 c7 00 00 00       	push   $0xc7
  8008ba:	68 c6 3d 80 00       	push   $0x803dc6
  8008bf:	e8 c3 03 00 00       	call   800c87 <_panic>
				panic("Error, wrong booking for user %d\n", f2);
			}
		}

		int f3=f2;
		for(;f3<f2+flight3Customers; ++f3)
  8008c4:	ff 45 c4             	incl   -0x3c(%ebp)
  8008c7:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8008ca:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8008cd:	01 d0                	add    %edx,%eax
  8008cf:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  8008d2:	7f a7                	jg     80087b <_main+0x843>
			{
				panic("Error, wrong booking for user %d\n", f3);
			}
		}

		assert(sys_getSemaphoreValue(envID, _flight1CS) == 1);
  8008d4:	83 ec 08             	sub    $0x8,%esp
  8008d7:	8d 85 af fe ff ff    	lea    -0x151(%ebp),%eax
  8008dd:	50                   	push   %eax
  8008de:	ff 75 bc             	pushl  -0x44(%ebp)
  8008e1:	e8 86 1b 00 00       	call   80246c <sys_getSemaphoreValue>
  8008e6:	83 c4 10             	add    $0x10,%esp
  8008e9:	83 f8 01             	cmp    $0x1,%eax
  8008ec:	74 19                	je     800907 <_main+0x8cf>
  8008ee:	68 5c 3e 80 00       	push   $0x803e5c
  8008f3:	68 8a 3e 80 00       	push   $0x803e8a
  8008f8:	68 cb 00 00 00       	push   $0xcb
  8008fd:	68 c6 3d 80 00       	push   $0x803dc6
  800902:	e8 80 03 00 00       	call   800c87 <_panic>
		assert(sys_getSemaphoreValue(envID, _flight2CS) == 1);
  800907:	83 ec 08             	sub    $0x8,%esp
  80090a:	8d 85 a5 fe ff ff    	lea    -0x15b(%ebp),%eax
  800910:	50                   	push   %eax
  800911:	ff 75 bc             	pushl  -0x44(%ebp)
  800914:	e8 53 1b 00 00       	call   80246c <sys_getSemaphoreValue>
  800919:	83 c4 10             	add    $0x10,%esp
  80091c:	83 f8 01             	cmp    $0x1,%eax
  80091f:	74 19                	je     80093a <_main+0x902>
  800921:	68 a0 3e 80 00       	push   $0x803ea0
  800926:	68 8a 3e 80 00       	push   $0x803e8a
  80092b:	68 cc 00 00 00       	push   $0xcc
  800930:	68 c6 3d 80 00       	push   $0x803dc6
  800935:	e8 4d 03 00 00       	call   800c87 <_panic>

		assert(sys_getSemaphoreValue(envID, _custCounterCS) ==  1);
  80093a:	83 ec 08             	sub    $0x8,%esp
  80093d:	8d 85 91 fe ff ff    	lea    -0x16f(%ebp),%eax
  800943:	50                   	push   %eax
  800944:	ff 75 bc             	pushl  -0x44(%ebp)
  800947:	e8 20 1b 00 00       	call   80246c <sys_getSemaphoreValue>
  80094c:	83 c4 10             	add    $0x10,%esp
  80094f:	83 f8 01             	cmp    $0x1,%eax
  800952:	74 19                	je     80096d <_main+0x935>
  800954:	68 d0 3e 80 00       	push   $0x803ed0
  800959:	68 8a 3e 80 00       	push   $0x803e8a
  80095e:	68 ce 00 00 00       	push   $0xce
  800963:	68 c6 3d 80 00       	push   $0x803dc6
  800968:	e8 1a 03 00 00       	call   800c87 <_panic>
		assert(sys_getSemaphoreValue(envID, _custQueueCS) ==  1);
  80096d:	83 ec 08             	sub    $0x8,%esp
  800970:	8d 85 b9 fe ff ff    	lea    -0x147(%ebp),%eax
  800976:	50                   	push   %eax
  800977:	ff 75 bc             	pushl  -0x44(%ebp)
  80097a:	e8 ed 1a 00 00       	call   80246c <sys_getSemaphoreValue>
  80097f:	83 c4 10             	add    $0x10,%esp
  800982:	83 f8 01             	cmp    $0x1,%eax
  800985:	74 19                	je     8009a0 <_main+0x968>
  800987:	68 04 3f 80 00       	push   $0x803f04
  80098c:	68 8a 3e 80 00       	push   $0x803e8a
  800991:	68 cf 00 00 00       	push   $0xcf
  800996:	68 c6 3d 80 00       	push   $0x803dc6
  80099b:	e8 e7 02 00 00       	call   800c87 <_panic>

		assert(sys_getSemaphoreValue(envID, _clerk) == 3);
  8009a0:	83 ec 08             	sub    $0x8,%esp
  8009a3:	8d 85 9f fe ff ff    	lea    -0x161(%ebp),%eax
  8009a9:	50                   	push   %eax
  8009aa:	ff 75 bc             	pushl  -0x44(%ebp)
  8009ad:	e8 ba 1a 00 00       	call   80246c <sys_getSemaphoreValue>
  8009b2:	83 c4 10             	add    $0x10,%esp
  8009b5:	83 f8 03             	cmp    $0x3,%eax
  8009b8:	74 19                	je     8009d3 <_main+0x99b>
  8009ba:	68 34 3f 80 00       	push   $0x803f34
  8009bf:	68 8a 3e 80 00       	push   $0x803e8a
  8009c4:	68 d1 00 00 00       	push   $0xd1
  8009c9:	68 c6 3d 80 00       	push   $0x803dc6
  8009ce:	e8 b4 02 00 00       	call   800c87 <_panic>

		assert(sys_getSemaphoreValue(envID, _cust_ready) == -3);
  8009d3:	83 ec 08             	sub    $0x8,%esp
  8009d6:	8d 85 c5 fe ff ff    	lea    -0x13b(%ebp),%eax
  8009dc:	50                   	push   %eax
  8009dd:	ff 75 bc             	pushl  -0x44(%ebp)
  8009e0:	e8 87 1a 00 00       	call   80246c <sys_getSemaphoreValue>
  8009e5:	83 c4 10             	add    $0x10,%esp
  8009e8:	83 f8 fd             	cmp    $0xfffffffd,%eax
  8009eb:	74 19                	je     800a06 <_main+0x9ce>
  8009ed:	68 60 3f 80 00       	push   $0x803f60
  8009f2:	68 8a 3e 80 00       	push   $0x803e8a
  8009f7:	68 d3 00 00 00       	push   $0xd3
  8009fc:	68 c6 3d 80 00       	push   $0x803dc6
  800a01:	e8 81 02 00 00       	call   800c87 <_panic>

		assert(sys_getSemaphoreValue(envID, _custTerminated) ==  0);
  800a06:	83 ec 08             	sub    $0x8,%esp
  800a09:	8d 85 82 fe ff ff    	lea    -0x17e(%ebp),%eax
  800a0f:	50                   	push   %eax
  800a10:	ff 75 bc             	pushl  -0x44(%ebp)
  800a13:	e8 54 1a 00 00       	call   80246c <sys_getSemaphoreValue>
  800a18:	83 c4 10             	add    $0x10,%esp
  800a1b:	85 c0                	test   %eax,%eax
  800a1d:	74 19                	je     800a38 <_main+0xa00>
  800a1f:	68 90 3f 80 00       	push   $0x803f90
  800a24:	68 8a 3e 80 00       	push   $0x803e8a
  800a29:	68 d5 00 00 00       	push   $0xd5
  800a2e:	68 c6 3d 80 00       	push   $0x803dc6
  800a33:	e8 4f 02 00 00       	call   800c87 <_panic>

		int s=0;
  800a38:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
		for(s=0; s<numOfCustomers; ++s)
  800a3f:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  800a46:	e9 96 00 00 00       	jmp    800ae1 <_main+0xaa9>
		{
			char prefix[30]="cust_finished";
  800a4b:	8d 85 33 fe ff ff    	lea    -0x1cd(%ebp),%eax
  800a51:	bb 50 41 80 00       	mov    $0x804150,%ebx
  800a56:	ba 0e 00 00 00       	mov    $0xe,%edx
  800a5b:	89 c7                	mov    %eax,%edi
  800a5d:	89 de                	mov    %ebx,%esi
  800a5f:	89 d1                	mov    %edx,%ecx
  800a61:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800a63:	8d 95 41 fe ff ff    	lea    -0x1bf(%ebp),%edx
  800a69:	b9 04 00 00 00       	mov    $0x4,%ecx
  800a6e:	b8 00 00 00 00       	mov    $0x0,%eax
  800a73:	89 d7                	mov    %edx,%edi
  800a75:	f3 ab                	rep stos %eax,%es:(%edi)
			char id[5]; char cust_finishedSemaphoreName[50];
			ltostr(s, id);
  800a77:	83 ec 08             	sub    $0x8,%esp
  800a7a:	8d 85 2e fe ff ff    	lea    -0x1d2(%ebp),%eax
  800a80:	50                   	push   %eax
  800a81:	ff 75 c0             	pushl  -0x40(%ebp)
  800a84:	e8 da 0f 00 00       	call   801a63 <ltostr>
  800a89:	83 c4 10             	add    $0x10,%esp
			strcconcat(prefix, id, cust_finishedSemaphoreName);
  800a8c:	83 ec 04             	sub    $0x4,%esp
  800a8f:	8d 85 fc fd ff ff    	lea    -0x204(%ebp),%eax
  800a95:	50                   	push   %eax
  800a96:	8d 85 2e fe ff ff    	lea    -0x1d2(%ebp),%eax
  800a9c:	50                   	push   %eax
  800a9d:	8d 85 33 fe ff ff    	lea    -0x1cd(%ebp),%eax
  800aa3:	50                   	push   %eax
  800aa4:	e8 b2 10 00 00       	call   801b5b <strcconcat>
  800aa9:	83 c4 10             	add    $0x10,%esp
			assert(sys_getSemaphoreValue(envID, cust_finishedSemaphoreName) ==  0);
  800aac:	83 ec 08             	sub    $0x8,%esp
  800aaf:	8d 85 fc fd ff ff    	lea    -0x204(%ebp),%eax
  800ab5:	50                   	push   %eax
  800ab6:	ff 75 bc             	pushl  -0x44(%ebp)
  800ab9:	e8 ae 19 00 00       	call   80246c <sys_getSemaphoreValue>
  800abe:	83 c4 10             	add    $0x10,%esp
  800ac1:	85 c0                	test   %eax,%eax
  800ac3:	74 19                	je     800ade <_main+0xaa6>
  800ac5:	68 c4 3f 80 00       	push   $0x803fc4
  800aca:	68 8a 3e 80 00       	push   $0x803e8a
  800acf:	68 de 00 00 00       	push   $0xde
  800ad4:	68 c6 3d 80 00       	push   $0x803dc6
  800ad9:	e8 a9 01 00 00       	call   800c87 <_panic>
		assert(sys_getSemaphoreValue(envID, _cust_ready) == -3);

		assert(sys_getSemaphoreValue(envID, _custTerminated) ==  0);

		int s=0;
		for(s=0; s<numOfCustomers; ++s)
  800ade:	ff 45 c0             	incl   -0x40(%ebp)
  800ae1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800ae4:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  800ae7:	0f 8c 5e ff ff ff    	jl     800a4b <_main+0xa13>
			ltostr(s, id);
			strcconcat(prefix, id, cust_finishedSemaphoreName);
			assert(sys_getSemaphoreValue(envID, cust_finishedSemaphoreName) ==  0);
		}

		cprintf("Congratulations, All reservations are successfully done... have a nice flight :)\n");
  800aed:	83 ec 0c             	sub    $0xc,%esp
  800af0:	68 04 40 80 00       	push   $0x804004
  800af5:	e8 41 04 00 00       	call   800f3b <cprintf>
  800afa:	83 c4 10             	add    $0x10,%esp
	}

}
  800afd:	90                   	nop
  800afe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b01:	5b                   	pop    %ebx
  800b02:	5e                   	pop    %esi
  800b03:	5f                   	pop    %edi
  800b04:	5d                   	pop    %ebp
  800b05:	c3                   	ret    

00800b06 <find>:


int find(int* arr, int size, int val)
{
  800b06:	55                   	push   %ebp
  800b07:	89 e5                	mov    %esp,%ebp
  800b09:	83 ec 10             	sub    $0x10,%esp

	int result = 0;
  800b0c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

	int i;
	for(i=0; i<size;++i )
  800b13:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800b1a:	eb 22                	jmp    800b3e <find+0x38>
	{
		if(arr[i] == val)
  800b1c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b1f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b26:	8b 45 08             	mov    0x8(%ebp),%eax
  800b29:	01 d0                	add    %edx,%eax
  800b2b:	8b 00                	mov    (%eax),%eax
  800b2d:	3b 45 10             	cmp    0x10(%ebp),%eax
  800b30:	75 09                	jne    800b3b <find+0x35>
		{
			result = 1;
  800b32:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
			break;
  800b39:	eb 0b                	jmp    800b46 <find+0x40>
{

	int result = 0;

	int i;
	for(i=0; i<size;++i )
  800b3b:	ff 45 f8             	incl   -0x8(%ebp)
  800b3e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b41:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800b44:	7c d6                	jl     800b1c <find+0x16>
			result = 1;
			break;
		}
	}

	return result;
  800b46:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b49:	c9                   	leave  
  800b4a:	c3                   	ret    

00800b4b <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800b4b:	55                   	push   %ebp
  800b4c:	89 e5                	mov    %esp,%ebp
  800b4e:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800b51:	e8 79 1a 00 00       	call   8025cf <sys_getenvindex>
  800b56:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800b59:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b5c:	89 d0                	mov    %edx,%eax
  800b5e:	c1 e0 03             	shl    $0x3,%eax
  800b61:	01 d0                	add    %edx,%eax
  800b63:	01 c0                	add    %eax,%eax
  800b65:	01 d0                	add    %edx,%eax
  800b67:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b6e:	01 d0                	add    %edx,%eax
  800b70:	c1 e0 04             	shl    $0x4,%eax
  800b73:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800b78:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800b7d:	a1 20 50 80 00       	mov    0x805020,%eax
  800b82:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800b88:	84 c0                	test   %al,%al
  800b8a:	74 0f                	je     800b9b <libmain+0x50>
		binaryname = myEnv->prog_name;
  800b8c:	a1 20 50 80 00       	mov    0x805020,%eax
  800b91:	05 5c 05 00 00       	add    $0x55c,%eax
  800b96:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800b9b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b9f:	7e 0a                	jle    800bab <libmain+0x60>
		binaryname = argv[0];
  800ba1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba4:	8b 00                	mov    (%eax),%eax
  800ba6:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800bab:	83 ec 08             	sub    $0x8,%esp
  800bae:	ff 75 0c             	pushl  0xc(%ebp)
  800bb1:	ff 75 08             	pushl  0x8(%ebp)
  800bb4:	e8 7f f4 ff ff       	call   800038 <_main>
  800bb9:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800bbc:	e8 1b 18 00 00       	call   8023dc <sys_disable_interrupt>
	cprintf("**************************************\n");
  800bc1:	83 ec 0c             	sub    $0xc,%esp
  800bc4:	68 88 41 80 00       	push   $0x804188
  800bc9:	e8 6d 03 00 00       	call   800f3b <cprintf>
  800bce:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800bd1:	a1 20 50 80 00       	mov    0x805020,%eax
  800bd6:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800bdc:	a1 20 50 80 00       	mov    0x805020,%eax
  800be1:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800be7:	83 ec 04             	sub    $0x4,%esp
  800bea:	52                   	push   %edx
  800beb:	50                   	push   %eax
  800bec:	68 b0 41 80 00       	push   $0x8041b0
  800bf1:	e8 45 03 00 00       	call   800f3b <cprintf>
  800bf6:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800bf9:	a1 20 50 80 00       	mov    0x805020,%eax
  800bfe:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800c04:	a1 20 50 80 00       	mov    0x805020,%eax
  800c09:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800c0f:	a1 20 50 80 00       	mov    0x805020,%eax
  800c14:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800c1a:	51                   	push   %ecx
  800c1b:	52                   	push   %edx
  800c1c:	50                   	push   %eax
  800c1d:	68 d8 41 80 00       	push   $0x8041d8
  800c22:	e8 14 03 00 00       	call   800f3b <cprintf>
  800c27:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800c2a:	a1 20 50 80 00       	mov    0x805020,%eax
  800c2f:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800c35:	83 ec 08             	sub    $0x8,%esp
  800c38:	50                   	push   %eax
  800c39:	68 30 42 80 00       	push   $0x804230
  800c3e:	e8 f8 02 00 00       	call   800f3b <cprintf>
  800c43:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800c46:	83 ec 0c             	sub    $0xc,%esp
  800c49:	68 88 41 80 00       	push   $0x804188
  800c4e:	e8 e8 02 00 00       	call   800f3b <cprintf>
  800c53:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800c56:	e8 9b 17 00 00       	call   8023f6 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800c5b:	e8 19 00 00 00       	call   800c79 <exit>
}
  800c60:	90                   	nop
  800c61:	c9                   	leave  
  800c62:	c3                   	ret    

00800c63 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800c63:	55                   	push   %ebp
  800c64:	89 e5                	mov    %esp,%ebp
  800c66:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800c69:	83 ec 0c             	sub    $0xc,%esp
  800c6c:	6a 00                	push   $0x0
  800c6e:	e8 28 19 00 00       	call   80259b <sys_destroy_env>
  800c73:	83 c4 10             	add    $0x10,%esp
}
  800c76:	90                   	nop
  800c77:	c9                   	leave  
  800c78:	c3                   	ret    

00800c79 <exit>:

void
exit(void)
{
  800c79:	55                   	push   %ebp
  800c7a:	89 e5                	mov    %esp,%ebp
  800c7c:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800c7f:	e8 7d 19 00 00       	call   802601 <sys_exit_env>
}
  800c84:	90                   	nop
  800c85:	c9                   	leave  
  800c86:	c3                   	ret    

00800c87 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800c87:	55                   	push   %ebp
  800c88:	89 e5                	mov    %esp,%ebp
  800c8a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800c8d:	8d 45 10             	lea    0x10(%ebp),%eax
  800c90:	83 c0 04             	add    $0x4,%eax
  800c93:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800c96:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800c9b:	85 c0                	test   %eax,%eax
  800c9d:	74 16                	je     800cb5 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800c9f:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800ca4:	83 ec 08             	sub    $0x8,%esp
  800ca7:	50                   	push   %eax
  800ca8:	68 44 42 80 00       	push   $0x804244
  800cad:	e8 89 02 00 00       	call   800f3b <cprintf>
  800cb2:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800cb5:	a1 00 50 80 00       	mov    0x805000,%eax
  800cba:	ff 75 0c             	pushl  0xc(%ebp)
  800cbd:	ff 75 08             	pushl  0x8(%ebp)
  800cc0:	50                   	push   %eax
  800cc1:	68 49 42 80 00       	push   $0x804249
  800cc6:	e8 70 02 00 00       	call   800f3b <cprintf>
  800ccb:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800cce:	8b 45 10             	mov    0x10(%ebp),%eax
  800cd1:	83 ec 08             	sub    $0x8,%esp
  800cd4:	ff 75 f4             	pushl  -0xc(%ebp)
  800cd7:	50                   	push   %eax
  800cd8:	e8 f3 01 00 00       	call   800ed0 <vcprintf>
  800cdd:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800ce0:	83 ec 08             	sub    $0x8,%esp
  800ce3:	6a 00                	push   $0x0
  800ce5:	68 65 42 80 00       	push   $0x804265
  800cea:	e8 e1 01 00 00       	call   800ed0 <vcprintf>
  800cef:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800cf2:	e8 82 ff ff ff       	call   800c79 <exit>

	// should not return here
	while (1) ;
  800cf7:	eb fe                	jmp    800cf7 <_panic+0x70>

00800cf9 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800cf9:	55                   	push   %ebp
  800cfa:	89 e5                	mov    %esp,%ebp
  800cfc:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800cff:	a1 20 50 80 00       	mov    0x805020,%eax
  800d04:	8b 50 74             	mov    0x74(%eax),%edx
  800d07:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d0a:	39 c2                	cmp    %eax,%edx
  800d0c:	74 14                	je     800d22 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800d0e:	83 ec 04             	sub    $0x4,%esp
  800d11:	68 68 42 80 00       	push   $0x804268
  800d16:	6a 26                	push   $0x26
  800d18:	68 b4 42 80 00       	push   $0x8042b4
  800d1d:	e8 65 ff ff ff       	call   800c87 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800d22:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800d29:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800d30:	e9 c2 00 00 00       	jmp    800df7 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800d35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d38:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d42:	01 d0                	add    %edx,%eax
  800d44:	8b 00                	mov    (%eax),%eax
  800d46:	85 c0                	test   %eax,%eax
  800d48:	75 08                	jne    800d52 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800d4a:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800d4d:	e9 a2 00 00 00       	jmp    800df4 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800d52:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800d59:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800d60:	eb 69                	jmp    800dcb <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800d62:	a1 20 50 80 00       	mov    0x805020,%eax
  800d67:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800d6d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800d70:	89 d0                	mov    %edx,%eax
  800d72:	01 c0                	add    %eax,%eax
  800d74:	01 d0                	add    %edx,%eax
  800d76:	c1 e0 03             	shl    $0x3,%eax
  800d79:	01 c8                	add    %ecx,%eax
  800d7b:	8a 40 04             	mov    0x4(%eax),%al
  800d7e:	84 c0                	test   %al,%al
  800d80:	75 46                	jne    800dc8 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800d82:	a1 20 50 80 00       	mov    0x805020,%eax
  800d87:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800d8d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800d90:	89 d0                	mov    %edx,%eax
  800d92:	01 c0                	add    %eax,%eax
  800d94:	01 d0                	add    %edx,%eax
  800d96:	c1 e0 03             	shl    $0x3,%eax
  800d99:	01 c8                	add    %ecx,%eax
  800d9b:	8b 00                	mov    (%eax),%eax
  800d9d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800da0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800da3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800da8:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800daa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dad:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800db4:	8b 45 08             	mov    0x8(%ebp),%eax
  800db7:	01 c8                	add    %ecx,%eax
  800db9:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800dbb:	39 c2                	cmp    %eax,%edx
  800dbd:	75 09                	jne    800dc8 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800dbf:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800dc6:	eb 12                	jmp    800dda <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800dc8:	ff 45 e8             	incl   -0x18(%ebp)
  800dcb:	a1 20 50 80 00       	mov    0x805020,%eax
  800dd0:	8b 50 74             	mov    0x74(%eax),%edx
  800dd3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800dd6:	39 c2                	cmp    %eax,%edx
  800dd8:	77 88                	ja     800d62 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800dda:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800dde:	75 14                	jne    800df4 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800de0:	83 ec 04             	sub    $0x4,%esp
  800de3:	68 c0 42 80 00       	push   $0x8042c0
  800de8:	6a 3a                	push   $0x3a
  800dea:	68 b4 42 80 00       	push   $0x8042b4
  800def:	e8 93 fe ff ff       	call   800c87 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800df4:	ff 45 f0             	incl   -0x10(%ebp)
  800df7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dfa:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800dfd:	0f 8c 32 ff ff ff    	jl     800d35 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800e03:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800e0a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800e11:	eb 26                	jmp    800e39 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800e13:	a1 20 50 80 00       	mov    0x805020,%eax
  800e18:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800e1e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800e21:	89 d0                	mov    %edx,%eax
  800e23:	01 c0                	add    %eax,%eax
  800e25:	01 d0                	add    %edx,%eax
  800e27:	c1 e0 03             	shl    $0x3,%eax
  800e2a:	01 c8                	add    %ecx,%eax
  800e2c:	8a 40 04             	mov    0x4(%eax),%al
  800e2f:	3c 01                	cmp    $0x1,%al
  800e31:	75 03                	jne    800e36 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800e33:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800e36:	ff 45 e0             	incl   -0x20(%ebp)
  800e39:	a1 20 50 80 00       	mov    0x805020,%eax
  800e3e:	8b 50 74             	mov    0x74(%eax),%edx
  800e41:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e44:	39 c2                	cmp    %eax,%edx
  800e46:	77 cb                	ja     800e13 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800e48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e4b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800e4e:	74 14                	je     800e64 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800e50:	83 ec 04             	sub    $0x4,%esp
  800e53:	68 14 43 80 00       	push   $0x804314
  800e58:	6a 44                	push   $0x44
  800e5a:	68 b4 42 80 00       	push   $0x8042b4
  800e5f:	e8 23 fe ff ff       	call   800c87 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800e64:	90                   	nop
  800e65:	c9                   	leave  
  800e66:	c3                   	ret    

00800e67 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800e67:	55                   	push   %ebp
  800e68:	89 e5                	mov    %esp,%ebp
  800e6a:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800e6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e70:	8b 00                	mov    (%eax),%eax
  800e72:	8d 48 01             	lea    0x1(%eax),%ecx
  800e75:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e78:	89 0a                	mov    %ecx,(%edx)
  800e7a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e7d:	88 d1                	mov    %dl,%cl
  800e7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e82:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800e86:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e89:	8b 00                	mov    (%eax),%eax
  800e8b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800e90:	75 2c                	jne    800ebe <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800e92:	a0 24 50 80 00       	mov    0x805024,%al
  800e97:	0f b6 c0             	movzbl %al,%eax
  800e9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e9d:	8b 12                	mov    (%edx),%edx
  800e9f:	89 d1                	mov    %edx,%ecx
  800ea1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ea4:	83 c2 08             	add    $0x8,%edx
  800ea7:	83 ec 04             	sub    $0x4,%esp
  800eaa:	50                   	push   %eax
  800eab:	51                   	push   %ecx
  800eac:	52                   	push   %edx
  800ead:	e8 7c 13 00 00       	call   80222e <sys_cputs>
  800eb2:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800eb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800ebe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec1:	8b 40 04             	mov    0x4(%eax),%eax
  800ec4:	8d 50 01             	lea    0x1(%eax),%edx
  800ec7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eca:	89 50 04             	mov    %edx,0x4(%eax)
}
  800ecd:	90                   	nop
  800ece:	c9                   	leave  
  800ecf:	c3                   	ret    

00800ed0 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800ed0:	55                   	push   %ebp
  800ed1:	89 e5                	mov    %esp,%ebp
  800ed3:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800ed9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800ee0:	00 00 00 
	b.cnt = 0;
  800ee3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800eea:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800eed:	ff 75 0c             	pushl  0xc(%ebp)
  800ef0:	ff 75 08             	pushl  0x8(%ebp)
  800ef3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800ef9:	50                   	push   %eax
  800efa:	68 67 0e 80 00       	push   $0x800e67
  800eff:	e8 11 02 00 00       	call   801115 <vprintfmt>
  800f04:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800f07:	a0 24 50 80 00       	mov    0x805024,%al
  800f0c:	0f b6 c0             	movzbl %al,%eax
  800f0f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800f15:	83 ec 04             	sub    $0x4,%esp
  800f18:	50                   	push   %eax
  800f19:	52                   	push   %edx
  800f1a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800f20:	83 c0 08             	add    $0x8,%eax
  800f23:	50                   	push   %eax
  800f24:	e8 05 13 00 00       	call   80222e <sys_cputs>
  800f29:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800f2c:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800f33:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800f39:	c9                   	leave  
  800f3a:	c3                   	ret    

00800f3b <cprintf>:

int cprintf(const char *fmt, ...) {
  800f3b:	55                   	push   %ebp
  800f3c:	89 e5                	mov    %esp,%ebp
  800f3e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800f41:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800f48:	8d 45 0c             	lea    0xc(%ebp),%eax
  800f4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f51:	83 ec 08             	sub    $0x8,%esp
  800f54:	ff 75 f4             	pushl  -0xc(%ebp)
  800f57:	50                   	push   %eax
  800f58:	e8 73 ff ff ff       	call   800ed0 <vcprintf>
  800f5d:	83 c4 10             	add    $0x10,%esp
  800f60:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800f63:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800f66:	c9                   	leave  
  800f67:	c3                   	ret    

00800f68 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800f68:	55                   	push   %ebp
  800f69:	89 e5                	mov    %esp,%ebp
  800f6b:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800f6e:	e8 69 14 00 00       	call   8023dc <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800f73:	8d 45 0c             	lea    0xc(%ebp),%eax
  800f76:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800f79:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7c:	83 ec 08             	sub    $0x8,%esp
  800f7f:	ff 75 f4             	pushl  -0xc(%ebp)
  800f82:	50                   	push   %eax
  800f83:	e8 48 ff ff ff       	call   800ed0 <vcprintf>
  800f88:	83 c4 10             	add    $0x10,%esp
  800f8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800f8e:	e8 63 14 00 00       	call   8023f6 <sys_enable_interrupt>
	return cnt;
  800f93:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800f96:	c9                   	leave  
  800f97:	c3                   	ret    

00800f98 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800f98:	55                   	push   %ebp
  800f99:	89 e5                	mov    %esp,%ebp
  800f9b:	53                   	push   %ebx
  800f9c:	83 ec 14             	sub    $0x14,%esp
  800f9f:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fa5:	8b 45 14             	mov    0x14(%ebp),%eax
  800fa8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800fab:	8b 45 18             	mov    0x18(%ebp),%eax
  800fae:	ba 00 00 00 00       	mov    $0x0,%edx
  800fb3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800fb6:	77 55                	ja     80100d <printnum+0x75>
  800fb8:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800fbb:	72 05                	jb     800fc2 <printnum+0x2a>
  800fbd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800fc0:	77 4b                	ja     80100d <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800fc2:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800fc5:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800fc8:	8b 45 18             	mov    0x18(%ebp),%eax
  800fcb:	ba 00 00 00 00       	mov    $0x0,%edx
  800fd0:	52                   	push   %edx
  800fd1:	50                   	push   %eax
  800fd2:	ff 75 f4             	pushl  -0xc(%ebp)
  800fd5:	ff 75 f0             	pushl  -0x10(%ebp)
  800fd8:	e8 33 2b 00 00       	call   803b10 <__udivdi3>
  800fdd:	83 c4 10             	add    $0x10,%esp
  800fe0:	83 ec 04             	sub    $0x4,%esp
  800fe3:	ff 75 20             	pushl  0x20(%ebp)
  800fe6:	53                   	push   %ebx
  800fe7:	ff 75 18             	pushl  0x18(%ebp)
  800fea:	52                   	push   %edx
  800feb:	50                   	push   %eax
  800fec:	ff 75 0c             	pushl  0xc(%ebp)
  800fef:	ff 75 08             	pushl  0x8(%ebp)
  800ff2:	e8 a1 ff ff ff       	call   800f98 <printnum>
  800ff7:	83 c4 20             	add    $0x20,%esp
  800ffa:	eb 1a                	jmp    801016 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800ffc:	83 ec 08             	sub    $0x8,%esp
  800fff:	ff 75 0c             	pushl  0xc(%ebp)
  801002:	ff 75 20             	pushl  0x20(%ebp)
  801005:	8b 45 08             	mov    0x8(%ebp),%eax
  801008:	ff d0                	call   *%eax
  80100a:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80100d:	ff 4d 1c             	decl   0x1c(%ebp)
  801010:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801014:	7f e6                	jg     800ffc <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801016:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801019:	bb 00 00 00 00       	mov    $0x0,%ebx
  80101e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801021:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801024:	53                   	push   %ebx
  801025:	51                   	push   %ecx
  801026:	52                   	push   %edx
  801027:	50                   	push   %eax
  801028:	e8 f3 2b 00 00       	call   803c20 <__umoddi3>
  80102d:	83 c4 10             	add    $0x10,%esp
  801030:	05 74 45 80 00       	add    $0x804574,%eax
  801035:	8a 00                	mov    (%eax),%al
  801037:	0f be c0             	movsbl %al,%eax
  80103a:	83 ec 08             	sub    $0x8,%esp
  80103d:	ff 75 0c             	pushl  0xc(%ebp)
  801040:	50                   	push   %eax
  801041:	8b 45 08             	mov    0x8(%ebp),%eax
  801044:	ff d0                	call   *%eax
  801046:	83 c4 10             	add    $0x10,%esp
}
  801049:	90                   	nop
  80104a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80104d:	c9                   	leave  
  80104e:	c3                   	ret    

0080104f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80104f:	55                   	push   %ebp
  801050:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801052:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801056:	7e 1c                	jle    801074 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801058:	8b 45 08             	mov    0x8(%ebp),%eax
  80105b:	8b 00                	mov    (%eax),%eax
  80105d:	8d 50 08             	lea    0x8(%eax),%edx
  801060:	8b 45 08             	mov    0x8(%ebp),%eax
  801063:	89 10                	mov    %edx,(%eax)
  801065:	8b 45 08             	mov    0x8(%ebp),%eax
  801068:	8b 00                	mov    (%eax),%eax
  80106a:	83 e8 08             	sub    $0x8,%eax
  80106d:	8b 50 04             	mov    0x4(%eax),%edx
  801070:	8b 00                	mov    (%eax),%eax
  801072:	eb 40                	jmp    8010b4 <getuint+0x65>
	else if (lflag)
  801074:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801078:	74 1e                	je     801098 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80107a:	8b 45 08             	mov    0x8(%ebp),%eax
  80107d:	8b 00                	mov    (%eax),%eax
  80107f:	8d 50 04             	lea    0x4(%eax),%edx
  801082:	8b 45 08             	mov    0x8(%ebp),%eax
  801085:	89 10                	mov    %edx,(%eax)
  801087:	8b 45 08             	mov    0x8(%ebp),%eax
  80108a:	8b 00                	mov    (%eax),%eax
  80108c:	83 e8 04             	sub    $0x4,%eax
  80108f:	8b 00                	mov    (%eax),%eax
  801091:	ba 00 00 00 00       	mov    $0x0,%edx
  801096:	eb 1c                	jmp    8010b4 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801098:	8b 45 08             	mov    0x8(%ebp),%eax
  80109b:	8b 00                	mov    (%eax),%eax
  80109d:	8d 50 04             	lea    0x4(%eax),%edx
  8010a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a3:	89 10                	mov    %edx,(%eax)
  8010a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a8:	8b 00                	mov    (%eax),%eax
  8010aa:	83 e8 04             	sub    $0x4,%eax
  8010ad:	8b 00                	mov    (%eax),%eax
  8010af:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8010b4:	5d                   	pop    %ebp
  8010b5:	c3                   	ret    

008010b6 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8010b6:	55                   	push   %ebp
  8010b7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8010b9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8010bd:	7e 1c                	jle    8010db <getint+0x25>
		return va_arg(*ap, long long);
  8010bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c2:	8b 00                	mov    (%eax),%eax
  8010c4:	8d 50 08             	lea    0x8(%eax),%edx
  8010c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ca:	89 10                	mov    %edx,(%eax)
  8010cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cf:	8b 00                	mov    (%eax),%eax
  8010d1:	83 e8 08             	sub    $0x8,%eax
  8010d4:	8b 50 04             	mov    0x4(%eax),%edx
  8010d7:	8b 00                	mov    (%eax),%eax
  8010d9:	eb 38                	jmp    801113 <getint+0x5d>
	else if (lflag)
  8010db:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010df:	74 1a                	je     8010fb <getint+0x45>
		return va_arg(*ap, long);
  8010e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e4:	8b 00                	mov    (%eax),%eax
  8010e6:	8d 50 04             	lea    0x4(%eax),%edx
  8010e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ec:	89 10                	mov    %edx,(%eax)
  8010ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f1:	8b 00                	mov    (%eax),%eax
  8010f3:	83 e8 04             	sub    $0x4,%eax
  8010f6:	8b 00                	mov    (%eax),%eax
  8010f8:	99                   	cltd   
  8010f9:	eb 18                	jmp    801113 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8010fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fe:	8b 00                	mov    (%eax),%eax
  801100:	8d 50 04             	lea    0x4(%eax),%edx
  801103:	8b 45 08             	mov    0x8(%ebp),%eax
  801106:	89 10                	mov    %edx,(%eax)
  801108:	8b 45 08             	mov    0x8(%ebp),%eax
  80110b:	8b 00                	mov    (%eax),%eax
  80110d:	83 e8 04             	sub    $0x4,%eax
  801110:	8b 00                	mov    (%eax),%eax
  801112:	99                   	cltd   
}
  801113:	5d                   	pop    %ebp
  801114:	c3                   	ret    

00801115 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801115:	55                   	push   %ebp
  801116:	89 e5                	mov    %esp,%ebp
  801118:	56                   	push   %esi
  801119:	53                   	push   %ebx
  80111a:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80111d:	eb 17                	jmp    801136 <vprintfmt+0x21>
			if (ch == '\0')
  80111f:	85 db                	test   %ebx,%ebx
  801121:	0f 84 af 03 00 00    	je     8014d6 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  801127:	83 ec 08             	sub    $0x8,%esp
  80112a:	ff 75 0c             	pushl  0xc(%ebp)
  80112d:	53                   	push   %ebx
  80112e:	8b 45 08             	mov    0x8(%ebp),%eax
  801131:	ff d0                	call   *%eax
  801133:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801136:	8b 45 10             	mov    0x10(%ebp),%eax
  801139:	8d 50 01             	lea    0x1(%eax),%edx
  80113c:	89 55 10             	mov    %edx,0x10(%ebp)
  80113f:	8a 00                	mov    (%eax),%al
  801141:	0f b6 d8             	movzbl %al,%ebx
  801144:	83 fb 25             	cmp    $0x25,%ebx
  801147:	75 d6                	jne    80111f <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801149:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80114d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801154:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80115b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801162:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801169:	8b 45 10             	mov    0x10(%ebp),%eax
  80116c:	8d 50 01             	lea    0x1(%eax),%edx
  80116f:	89 55 10             	mov    %edx,0x10(%ebp)
  801172:	8a 00                	mov    (%eax),%al
  801174:	0f b6 d8             	movzbl %al,%ebx
  801177:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80117a:	83 f8 55             	cmp    $0x55,%eax
  80117d:	0f 87 2b 03 00 00    	ja     8014ae <vprintfmt+0x399>
  801183:	8b 04 85 98 45 80 00 	mov    0x804598(,%eax,4),%eax
  80118a:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80118c:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801190:	eb d7                	jmp    801169 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801192:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801196:	eb d1                	jmp    801169 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801198:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80119f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8011a2:	89 d0                	mov    %edx,%eax
  8011a4:	c1 e0 02             	shl    $0x2,%eax
  8011a7:	01 d0                	add    %edx,%eax
  8011a9:	01 c0                	add    %eax,%eax
  8011ab:	01 d8                	add    %ebx,%eax
  8011ad:	83 e8 30             	sub    $0x30,%eax
  8011b0:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8011b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b6:	8a 00                	mov    (%eax),%al
  8011b8:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8011bb:	83 fb 2f             	cmp    $0x2f,%ebx
  8011be:	7e 3e                	jle    8011fe <vprintfmt+0xe9>
  8011c0:	83 fb 39             	cmp    $0x39,%ebx
  8011c3:	7f 39                	jg     8011fe <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8011c5:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8011c8:	eb d5                	jmp    80119f <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8011ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8011cd:	83 c0 04             	add    $0x4,%eax
  8011d0:	89 45 14             	mov    %eax,0x14(%ebp)
  8011d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8011d6:	83 e8 04             	sub    $0x4,%eax
  8011d9:	8b 00                	mov    (%eax),%eax
  8011db:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8011de:	eb 1f                	jmp    8011ff <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8011e0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8011e4:	79 83                	jns    801169 <vprintfmt+0x54>
				width = 0;
  8011e6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8011ed:	e9 77 ff ff ff       	jmp    801169 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8011f2:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8011f9:	e9 6b ff ff ff       	jmp    801169 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8011fe:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8011ff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801203:	0f 89 60 ff ff ff    	jns    801169 <vprintfmt+0x54>
				width = precision, precision = -1;
  801209:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80120c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80120f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801216:	e9 4e ff ff ff       	jmp    801169 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80121b:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80121e:	e9 46 ff ff ff       	jmp    801169 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801223:	8b 45 14             	mov    0x14(%ebp),%eax
  801226:	83 c0 04             	add    $0x4,%eax
  801229:	89 45 14             	mov    %eax,0x14(%ebp)
  80122c:	8b 45 14             	mov    0x14(%ebp),%eax
  80122f:	83 e8 04             	sub    $0x4,%eax
  801232:	8b 00                	mov    (%eax),%eax
  801234:	83 ec 08             	sub    $0x8,%esp
  801237:	ff 75 0c             	pushl  0xc(%ebp)
  80123a:	50                   	push   %eax
  80123b:	8b 45 08             	mov    0x8(%ebp),%eax
  80123e:	ff d0                	call   *%eax
  801240:	83 c4 10             	add    $0x10,%esp
			break;
  801243:	e9 89 02 00 00       	jmp    8014d1 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801248:	8b 45 14             	mov    0x14(%ebp),%eax
  80124b:	83 c0 04             	add    $0x4,%eax
  80124e:	89 45 14             	mov    %eax,0x14(%ebp)
  801251:	8b 45 14             	mov    0x14(%ebp),%eax
  801254:	83 e8 04             	sub    $0x4,%eax
  801257:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801259:	85 db                	test   %ebx,%ebx
  80125b:	79 02                	jns    80125f <vprintfmt+0x14a>
				err = -err;
  80125d:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80125f:	83 fb 64             	cmp    $0x64,%ebx
  801262:	7f 0b                	jg     80126f <vprintfmt+0x15a>
  801264:	8b 34 9d e0 43 80 00 	mov    0x8043e0(,%ebx,4),%esi
  80126b:	85 f6                	test   %esi,%esi
  80126d:	75 19                	jne    801288 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80126f:	53                   	push   %ebx
  801270:	68 85 45 80 00       	push   $0x804585
  801275:	ff 75 0c             	pushl  0xc(%ebp)
  801278:	ff 75 08             	pushl  0x8(%ebp)
  80127b:	e8 5e 02 00 00       	call   8014de <printfmt>
  801280:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801283:	e9 49 02 00 00       	jmp    8014d1 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801288:	56                   	push   %esi
  801289:	68 8e 45 80 00       	push   $0x80458e
  80128e:	ff 75 0c             	pushl  0xc(%ebp)
  801291:	ff 75 08             	pushl  0x8(%ebp)
  801294:	e8 45 02 00 00       	call   8014de <printfmt>
  801299:	83 c4 10             	add    $0x10,%esp
			break;
  80129c:	e9 30 02 00 00       	jmp    8014d1 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8012a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8012a4:	83 c0 04             	add    $0x4,%eax
  8012a7:	89 45 14             	mov    %eax,0x14(%ebp)
  8012aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8012ad:	83 e8 04             	sub    $0x4,%eax
  8012b0:	8b 30                	mov    (%eax),%esi
  8012b2:	85 f6                	test   %esi,%esi
  8012b4:	75 05                	jne    8012bb <vprintfmt+0x1a6>
				p = "(null)";
  8012b6:	be 91 45 80 00       	mov    $0x804591,%esi
			if (width > 0 && padc != '-')
  8012bb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8012bf:	7e 6d                	jle    80132e <vprintfmt+0x219>
  8012c1:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8012c5:	74 67                	je     80132e <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8012c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012ca:	83 ec 08             	sub    $0x8,%esp
  8012cd:	50                   	push   %eax
  8012ce:	56                   	push   %esi
  8012cf:	e8 0c 03 00 00       	call   8015e0 <strnlen>
  8012d4:	83 c4 10             	add    $0x10,%esp
  8012d7:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8012da:	eb 16                	jmp    8012f2 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8012dc:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8012e0:	83 ec 08             	sub    $0x8,%esp
  8012e3:	ff 75 0c             	pushl  0xc(%ebp)
  8012e6:	50                   	push   %eax
  8012e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ea:	ff d0                	call   *%eax
  8012ec:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8012ef:	ff 4d e4             	decl   -0x1c(%ebp)
  8012f2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8012f6:	7f e4                	jg     8012dc <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8012f8:	eb 34                	jmp    80132e <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8012fa:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8012fe:	74 1c                	je     80131c <vprintfmt+0x207>
  801300:	83 fb 1f             	cmp    $0x1f,%ebx
  801303:	7e 05                	jle    80130a <vprintfmt+0x1f5>
  801305:	83 fb 7e             	cmp    $0x7e,%ebx
  801308:	7e 12                	jle    80131c <vprintfmt+0x207>
					putch('?', putdat);
  80130a:	83 ec 08             	sub    $0x8,%esp
  80130d:	ff 75 0c             	pushl  0xc(%ebp)
  801310:	6a 3f                	push   $0x3f
  801312:	8b 45 08             	mov    0x8(%ebp),%eax
  801315:	ff d0                	call   *%eax
  801317:	83 c4 10             	add    $0x10,%esp
  80131a:	eb 0f                	jmp    80132b <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80131c:	83 ec 08             	sub    $0x8,%esp
  80131f:	ff 75 0c             	pushl  0xc(%ebp)
  801322:	53                   	push   %ebx
  801323:	8b 45 08             	mov    0x8(%ebp),%eax
  801326:	ff d0                	call   *%eax
  801328:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80132b:	ff 4d e4             	decl   -0x1c(%ebp)
  80132e:	89 f0                	mov    %esi,%eax
  801330:	8d 70 01             	lea    0x1(%eax),%esi
  801333:	8a 00                	mov    (%eax),%al
  801335:	0f be d8             	movsbl %al,%ebx
  801338:	85 db                	test   %ebx,%ebx
  80133a:	74 24                	je     801360 <vprintfmt+0x24b>
  80133c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801340:	78 b8                	js     8012fa <vprintfmt+0x1e5>
  801342:	ff 4d e0             	decl   -0x20(%ebp)
  801345:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801349:	79 af                	jns    8012fa <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80134b:	eb 13                	jmp    801360 <vprintfmt+0x24b>
				putch(' ', putdat);
  80134d:	83 ec 08             	sub    $0x8,%esp
  801350:	ff 75 0c             	pushl  0xc(%ebp)
  801353:	6a 20                	push   $0x20
  801355:	8b 45 08             	mov    0x8(%ebp),%eax
  801358:	ff d0                	call   *%eax
  80135a:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80135d:	ff 4d e4             	decl   -0x1c(%ebp)
  801360:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801364:	7f e7                	jg     80134d <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801366:	e9 66 01 00 00       	jmp    8014d1 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80136b:	83 ec 08             	sub    $0x8,%esp
  80136e:	ff 75 e8             	pushl  -0x18(%ebp)
  801371:	8d 45 14             	lea    0x14(%ebp),%eax
  801374:	50                   	push   %eax
  801375:	e8 3c fd ff ff       	call   8010b6 <getint>
  80137a:	83 c4 10             	add    $0x10,%esp
  80137d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801380:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801383:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801386:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801389:	85 d2                	test   %edx,%edx
  80138b:	79 23                	jns    8013b0 <vprintfmt+0x29b>
				putch('-', putdat);
  80138d:	83 ec 08             	sub    $0x8,%esp
  801390:	ff 75 0c             	pushl  0xc(%ebp)
  801393:	6a 2d                	push   $0x2d
  801395:	8b 45 08             	mov    0x8(%ebp),%eax
  801398:	ff d0                	call   *%eax
  80139a:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80139d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013a3:	f7 d8                	neg    %eax
  8013a5:	83 d2 00             	adc    $0x0,%edx
  8013a8:	f7 da                	neg    %edx
  8013aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8013ad:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8013b0:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8013b7:	e9 bc 00 00 00       	jmp    801478 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8013bc:	83 ec 08             	sub    $0x8,%esp
  8013bf:	ff 75 e8             	pushl  -0x18(%ebp)
  8013c2:	8d 45 14             	lea    0x14(%ebp),%eax
  8013c5:	50                   	push   %eax
  8013c6:	e8 84 fc ff ff       	call   80104f <getuint>
  8013cb:	83 c4 10             	add    $0x10,%esp
  8013ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8013d1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8013d4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8013db:	e9 98 00 00 00       	jmp    801478 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8013e0:	83 ec 08             	sub    $0x8,%esp
  8013e3:	ff 75 0c             	pushl  0xc(%ebp)
  8013e6:	6a 58                	push   $0x58
  8013e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013eb:	ff d0                	call   *%eax
  8013ed:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8013f0:	83 ec 08             	sub    $0x8,%esp
  8013f3:	ff 75 0c             	pushl  0xc(%ebp)
  8013f6:	6a 58                	push   $0x58
  8013f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fb:	ff d0                	call   *%eax
  8013fd:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801400:	83 ec 08             	sub    $0x8,%esp
  801403:	ff 75 0c             	pushl  0xc(%ebp)
  801406:	6a 58                	push   $0x58
  801408:	8b 45 08             	mov    0x8(%ebp),%eax
  80140b:	ff d0                	call   *%eax
  80140d:	83 c4 10             	add    $0x10,%esp
			break;
  801410:	e9 bc 00 00 00       	jmp    8014d1 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801415:	83 ec 08             	sub    $0x8,%esp
  801418:	ff 75 0c             	pushl  0xc(%ebp)
  80141b:	6a 30                	push   $0x30
  80141d:	8b 45 08             	mov    0x8(%ebp),%eax
  801420:	ff d0                	call   *%eax
  801422:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801425:	83 ec 08             	sub    $0x8,%esp
  801428:	ff 75 0c             	pushl  0xc(%ebp)
  80142b:	6a 78                	push   $0x78
  80142d:	8b 45 08             	mov    0x8(%ebp),%eax
  801430:	ff d0                	call   *%eax
  801432:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801435:	8b 45 14             	mov    0x14(%ebp),%eax
  801438:	83 c0 04             	add    $0x4,%eax
  80143b:	89 45 14             	mov    %eax,0x14(%ebp)
  80143e:	8b 45 14             	mov    0x14(%ebp),%eax
  801441:	83 e8 04             	sub    $0x4,%eax
  801444:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801446:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801449:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801450:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801457:	eb 1f                	jmp    801478 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801459:	83 ec 08             	sub    $0x8,%esp
  80145c:	ff 75 e8             	pushl  -0x18(%ebp)
  80145f:	8d 45 14             	lea    0x14(%ebp),%eax
  801462:	50                   	push   %eax
  801463:	e8 e7 fb ff ff       	call   80104f <getuint>
  801468:	83 c4 10             	add    $0x10,%esp
  80146b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80146e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801471:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801478:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80147c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80147f:	83 ec 04             	sub    $0x4,%esp
  801482:	52                   	push   %edx
  801483:	ff 75 e4             	pushl  -0x1c(%ebp)
  801486:	50                   	push   %eax
  801487:	ff 75 f4             	pushl  -0xc(%ebp)
  80148a:	ff 75 f0             	pushl  -0x10(%ebp)
  80148d:	ff 75 0c             	pushl  0xc(%ebp)
  801490:	ff 75 08             	pushl  0x8(%ebp)
  801493:	e8 00 fb ff ff       	call   800f98 <printnum>
  801498:	83 c4 20             	add    $0x20,%esp
			break;
  80149b:	eb 34                	jmp    8014d1 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80149d:	83 ec 08             	sub    $0x8,%esp
  8014a0:	ff 75 0c             	pushl  0xc(%ebp)
  8014a3:	53                   	push   %ebx
  8014a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a7:	ff d0                	call   *%eax
  8014a9:	83 c4 10             	add    $0x10,%esp
			break;
  8014ac:	eb 23                	jmp    8014d1 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8014ae:	83 ec 08             	sub    $0x8,%esp
  8014b1:	ff 75 0c             	pushl  0xc(%ebp)
  8014b4:	6a 25                	push   $0x25
  8014b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b9:	ff d0                	call   *%eax
  8014bb:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8014be:	ff 4d 10             	decl   0x10(%ebp)
  8014c1:	eb 03                	jmp    8014c6 <vprintfmt+0x3b1>
  8014c3:	ff 4d 10             	decl   0x10(%ebp)
  8014c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c9:	48                   	dec    %eax
  8014ca:	8a 00                	mov    (%eax),%al
  8014cc:	3c 25                	cmp    $0x25,%al
  8014ce:	75 f3                	jne    8014c3 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8014d0:	90                   	nop
		}
	}
  8014d1:	e9 47 fc ff ff       	jmp    80111d <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8014d6:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8014d7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014da:	5b                   	pop    %ebx
  8014db:	5e                   	pop    %esi
  8014dc:	5d                   	pop    %ebp
  8014dd:	c3                   	ret    

008014de <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8014de:	55                   	push   %ebp
  8014df:	89 e5                	mov    %esp,%ebp
  8014e1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8014e4:	8d 45 10             	lea    0x10(%ebp),%eax
  8014e7:	83 c0 04             	add    $0x4,%eax
  8014ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8014ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8014f0:	ff 75 f4             	pushl  -0xc(%ebp)
  8014f3:	50                   	push   %eax
  8014f4:	ff 75 0c             	pushl  0xc(%ebp)
  8014f7:	ff 75 08             	pushl  0x8(%ebp)
  8014fa:	e8 16 fc ff ff       	call   801115 <vprintfmt>
  8014ff:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801502:	90                   	nop
  801503:	c9                   	leave  
  801504:	c3                   	ret    

00801505 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801505:	55                   	push   %ebp
  801506:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801508:	8b 45 0c             	mov    0xc(%ebp),%eax
  80150b:	8b 40 08             	mov    0x8(%eax),%eax
  80150e:	8d 50 01             	lea    0x1(%eax),%edx
  801511:	8b 45 0c             	mov    0xc(%ebp),%eax
  801514:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801517:	8b 45 0c             	mov    0xc(%ebp),%eax
  80151a:	8b 10                	mov    (%eax),%edx
  80151c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80151f:	8b 40 04             	mov    0x4(%eax),%eax
  801522:	39 c2                	cmp    %eax,%edx
  801524:	73 12                	jae    801538 <sprintputch+0x33>
		*b->buf++ = ch;
  801526:	8b 45 0c             	mov    0xc(%ebp),%eax
  801529:	8b 00                	mov    (%eax),%eax
  80152b:	8d 48 01             	lea    0x1(%eax),%ecx
  80152e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801531:	89 0a                	mov    %ecx,(%edx)
  801533:	8b 55 08             	mov    0x8(%ebp),%edx
  801536:	88 10                	mov    %dl,(%eax)
}
  801538:	90                   	nop
  801539:	5d                   	pop    %ebp
  80153a:	c3                   	ret    

0080153b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80153b:	55                   	push   %ebp
  80153c:	89 e5                	mov    %esp,%ebp
  80153e:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801541:	8b 45 08             	mov    0x8(%ebp),%eax
  801544:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801547:	8b 45 0c             	mov    0xc(%ebp),%eax
  80154a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80154d:	8b 45 08             	mov    0x8(%ebp),%eax
  801550:	01 d0                	add    %edx,%eax
  801552:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801555:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80155c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801560:	74 06                	je     801568 <vsnprintf+0x2d>
  801562:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801566:	7f 07                	jg     80156f <vsnprintf+0x34>
		return -E_INVAL;
  801568:	b8 03 00 00 00       	mov    $0x3,%eax
  80156d:	eb 20                	jmp    80158f <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80156f:	ff 75 14             	pushl  0x14(%ebp)
  801572:	ff 75 10             	pushl  0x10(%ebp)
  801575:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801578:	50                   	push   %eax
  801579:	68 05 15 80 00       	push   $0x801505
  80157e:	e8 92 fb ff ff       	call   801115 <vprintfmt>
  801583:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801586:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801589:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80158c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80158f:	c9                   	leave  
  801590:	c3                   	ret    

00801591 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801591:	55                   	push   %ebp
  801592:	89 e5                	mov    %esp,%ebp
  801594:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801597:	8d 45 10             	lea    0x10(%ebp),%eax
  80159a:	83 c0 04             	add    $0x4,%eax
  80159d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8015a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8015a3:	ff 75 f4             	pushl  -0xc(%ebp)
  8015a6:	50                   	push   %eax
  8015a7:	ff 75 0c             	pushl  0xc(%ebp)
  8015aa:	ff 75 08             	pushl  0x8(%ebp)
  8015ad:	e8 89 ff ff ff       	call   80153b <vsnprintf>
  8015b2:	83 c4 10             	add    $0x10,%esp
  8015b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8015b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8015bb:	c9                   	leave  
  8015bc:	c3                   	ret    

008015bd <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8015bd:	55                   	push   %ebp
  8015be:	89 e5                	mov    %esp,%ebp
  8015c0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8015c3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015ca:	eb 06                	jmp    8015d2 <strlen+0x15>
		n++;
  8015cc:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8015cf:	ff 45 08             	incl   0x8(%ebp)
  8015d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d5:	8a 00                	mov    (%eax),%al
  8015d7:	84 c0                	test   %al,%al
  8015d9:	75 f1                	jne    8015cc <strlen+0xf>
		n++;
	return n;
  8015db:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8015de:	c9                   	leave  
  8015df:	c3                   	ret    

008015e0 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8015e0:	55                   	push   %ebp
  8015e1:	89 e5                	mov    %esp,%ebp
  8015e3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8015e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015ed:	eb 09                	jmp    8015f8 <strnlen+0x18>
		n++;
  8015ef:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8015f2:	ff 45 08             	incl   0x8(%ebp)
  8015f5:	ff 4d 0c             	decl   0xc(%ebp)
  8015f8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015fc:	74 09                	je     801607 <strnlen+0x27>
  8015fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801601:	8a 00                	mov    (%eax),%al
  801603:	84 c0                	test   %al,%al
  801605:	75 e8                	jne    8015ef <strnlen+0xf>
		n++;
	return n;
  801607:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80160a:	c9                   	leave  
  80160b:	c3                   	ret    

0080160c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80160c:	55                   	push   %ebp
  80160d:	89 e5                	mov    %esp,%ebp
  80160f:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801612:	8b 45 08             	mov    0x8(%ebp),%eax
  801615:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801618:	90                   	nop
  801619:	8b 45 08             	mov    0x8(%ebp),%eax
  80161c:	8d 50 01             	lea    0x1(%eax),%edx
  80161f:	89 55 08             	mov    %edx,0x8(%ebp)
  801622:	8b 55 0c             	mov    0xc(%ebp),%edx
  801625:	8d 4a 01             	lea    0x1(%edx),%ecx
  801628:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80162b:	8a 12                	mov    (%edx),%dl
  80162d:	88 10                	mov    %dl,(%eax)
  80162f:	8a 00                	mov    (%eax),%al
  801631:	84 c0                	test   %al,%al
  801633:	75 e4                	jne    801619 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801635:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801638:	c9                   	leave  
  801639:	c3                   	ret    

0080163a <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80163a:	55                   	push   %ebp
  80163b:	89 e5                	mov    %esp,%ebp
  80163d:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801640:	8b 45 08             	mov    0x8(%ebp),%eax
  801643:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801646:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80164d:	eb 1f                	jmp    80166e <strncpy+0x34>
		*dst++ = *src;
  80164f:	8b 45 08             	mov    0x8(%ebp),%eax
  801652:	8d 50 01             	lea    0x1(%eax),%edx
  801655:	89 55 08             	mov    %edx,0x8(%ebp)
  801658:	8b 55 0c             	mov    0xc(%ebp),%edx
  80165b:	8a 12                	mov    (%edx),%dl
  80165d:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80165f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801662:	8a 00                	mov    (%eax),%al
  801664:	84 c0                	test   %al,%al
  801666:	74 03                	je     80166b <strncpy+0x31>
			src++;
  801668:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80166b:	ff 45 fc             	incl   -0x4(%ebp)
  80166e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801671:	3b 45 10             	cmp    0x10(%ebp),%eax
  801674:	72 d9                	jb     80164f <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801676:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801679:	c9                   	leave  
  80167a:	c3                   	ret    

0080167b <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80167b:	55                   	push   %ebp
  80167c:	89 e5                	mov    %esp,%ebp
  80167e:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801681:	8b 45 08             	mov    0x8(%ebp),%eax
  801684:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801687:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80168b:	74 30                	je     8016bd <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80168d:	eb 16                	jmp    8016a5 <strlcpy+0x2a>
			*dst++ = *src++;
  80168f:	8b 45 08             	mov    0x8(%ebp),%eax
  801692:	8d 50 01             	lea    0x1(%eax),%edx
  801695:	89 55 08             	mov    %edx,0x8(%ebp)
  801698:	8b 55 0c             	mov    0xc(%ebp),%edx
  80169b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80169e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8016a1:	8a 12                	mov    (%edx),%dl
  8016a3:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8016a5:	ff 4d 10             	decl   0x10(%ebp)
  8016a8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016ac:	74 09                	je     8016b7 <strlcpy+0x3c>
  8016ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016b1:	8a 00                	mov    (%eax),%al
  8016b3:	84 c0                	test   %al,%al
  8016b5:	75 d8                	jne    80168f <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8016b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ba:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8016bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8016c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016c3:	29 c2                	sub    %eax,%edx
  8016c5:	89 d0                	mov    %edx,%eax
}
  8016c7:	c9                   	leave  
  8016c8:	c3                   	ret    

008016c9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8016c9:	55                   	push   %ebp
  8016ca:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8016cc:	eb 06                	jmp    8016d4 <strcmp+0xb>
		p++, q++;
  8016ce:	ff 45 08             	incl   0x8(%ebp)
  8016d1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8016d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d7:	8a 00                	mov    (%eax),%al
  8016d9:	84 c0                	test   %al,%al
  8016db:	74 0e                	je     8016eb <strcmp+0x22>
  8016dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e0:	8a 10                	mov    (%eax),%dl
  8016e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016e5:	8a 00                	mov    (%eax),%al
  8016e7:	38 c2                	cmp    %al,%dl
  8016e9:	74 e3                	je     8016ce <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8016eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ee:	8a 00                	mov    (%eax),%al
  8016f0:	0f b6 d0             	movzbl %al,%edx
  8016f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f6:	8a 00                	mov    (%eax),%al
  8016f8:	0f b6 c0             	movzbl %al,%eax
  8016fb:	29 c2                	sub    %eax,%edx
  8016fd:	89 d0                	mov    %edx,%eax
}
  8016ff:	5d                   	pop    %ebp
  801700:	c3                   	ret    

00801701 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801701:	55                   	push   %ebp
  801702:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801704:	eb 09                	jmp    80170f <strncmp+0xe>
		n--, p++, q++;
  801706:	ff 4d 10             	decl   0x10(%ebp)
  801709:	ff 45 08             	incl   0x8(%ebp)
  80170c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80170f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801713:	74 17                	je     80172c <strncmp+0x2b>
  801715:	8b 45 08             	mov    0x8(%ebp),%eax
  801718:	8a 00                	mov    (%eax),%al
  80171a:	84 c0                	test   %al,%al
  80171c:	74 0e                	je     80172c <strncmp+0x2b>
  80171e:	8b 45 08             	mov    0x8(%ebp),%eax
  801721:	8a 10                	mov    (%eax),%dl
  801723:	8b 45 0c             	mov    0xc(%ebp),%eax
  801726:	8a 00                	mov    (%eax),%al
  801728:	38 c2                	cmp    %al,%dl
  80172a:	74 da                	je     801706 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80172c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801730:	75 07                	jne    801739 <strncmp+0x38>
		return 0;
  801732:	b8 00 00 00 00       	mov    $0x0,%eax
  801737:	eb 14                	jmp    80174d <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801739:	8b 45 08             	mov    0x8(%ebp),%eax
  80173c:	8a 00                	mov    (%eax),%al
  80173e:	0f b6 d0             	movzbl %al,%edx
  801741:	8b 45 0c             	mov    0xc(%ebp),%eax
  801744:	8a 00                	mov    (%eax),%al
  801746:	0f b6 c0             	movzbl %al,%eax
  801749:	29 c2                	sub    %eax,%edx
  80174b:	89 d0                	mov    %edx,%eax
}
  80174d:	5d                   	pop    %ebp
  80174e:	c3                   	ret    

0080174f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80174f:	55                   	push   %ebp
  801750:	89 e5                	mov    %esp,%ebp
  801752:	83 ec 04             	sub    $0x4,%esp
  801755:	8b 45 0c             	mov    0xc(%ebp),%eax
  801758:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80175b:	eb 12                	jmp    80176f <strchr+0x20>
		if (*s == c)
  80175d:	8b 45 08             	mov    0x8(%ebp),%eax
  801760:	8a 00                	mov    (%eax),%al
  801762:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801765:	75 05                	jne    80176c <strchr+0x1d>
			return (char *) s;
  801767:	8b 45 08             	mov    0x8(%ebp),%eax
  80176a:	eb 11                	jmp    80177d <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80176c:	ff 45 08             	incl   0x8(%ebp)
  80176f:	8b 45 08             	mov    0x8(%ebp),%eax
  801772:	8a 00                	mov    (%eax),%al
  801774:	84 c0                	test   %al,%al
  801776:	75 e5                	jne    80175d <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801778:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80177d:	c9                   	leave  
  80177e:	c3                   	ret    

0080177f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80177f:	55                   	push   %ebp
  801780:	89 e5                	mov    %esp,%ebp
  801782:	83 ec 04             	sub    $0x4,%esp
  801785:	8b 45 0c             	mov    0xc(%ebp),%eax
  801788:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80178b:	eb 0d                	jmp    80179a <strfind+0x1b>
		if (*s == c)
  80178d:	8b 45 08             	mov    0x8(%ebp),%eax
  801790:	8a 00                	mov    (%eax),%al
  801792:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801795:	74 0e                	je     8017a5 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801797:	ff 45 08             	incl   0x8(%ebp)
  80179a:	8b 45 08             	mov    0x8(%ebp),%eax
  80179d:	8a 00                	mov    (%eax),%al
  80179f:	84 c0                	test   %al,%al
  8017a1:	75 ea                	jne    80178d <strfind+0xe>
  8017a3:	eb 01                	jmp    8017a6 <strfind+0x27>
		if (*s == c)
			break;
  8017a5:	90                   	nop
	return (char *) s;
  8017a6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017a9:	c9                   	leave  
  8017aa:	c3                   	ret    

008017ab <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8017ab:	55                   	push   %ebp
  8017ac:	89 e5                	mov    %esp,%ebp
  8017ae:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8017b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8017b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8017ba:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8017bd:	eb 0e                	jmp    8017cd <memset+0x22>
		*p++ = c;
  8017bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017c2:	8d 50 01             	lea    0x1(%eax),%edx
  8017c5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8017c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017cb:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8017cd:	ff 4d f8             	decl   -0x8(%ebp)
  8017d0:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8017d4:	79 e9                	jns    8017bf <memset+0x14>
		*p++ = c;

	return v;
  8017d6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017d9:	c9                   	leave  
  8017da:	c3                   	ret    

008017db <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8017db:	55                   	push   %ebp
  8017dc:	89 e5                	mov    %esp,%ebp
  8017de:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8017e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8017e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ea:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8017ed:	eb 16                	jmp    801805 <memcpy+0x2a>
		*d++ = *s++;
  8017ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017f2:	8d 50 01             	lea    0x1(%eax),%edx
  8017f5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8017f8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017fb:	8d 4a 01             	lea    0x1(%edx),%ecx
  8017fe:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801801:	8a 12                	mov    (%edx),%dl
  801803:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801805:	8b 45 10             	mov    0x10(%ebp),%eax
  801808:	8d 50 ff             	lea    -0x1(%eax),%edx
  80180b:	89 55 10             	mov    %edx,0x10(%ebp)
  80180e:	85 c0                	test   %eax,%eax
  801810:	75 dd                	jne    8017ef <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801812:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801815:	c9                   	leave  
  801816:	c3                   	ret    

00801817 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801817:	55                   	push   %ebp
  801818:	89 e5                	mov    %esp,%ebp
  80181a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80181d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801820:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801823:	8b 45 08             	mov    0x8(%ebp),%eax
  801826:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801829:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80182c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80182f:	73 50                	jae    801881 <memmove+0x6a>
  801831:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801834:	8b 45 10             	mov    0x10(%ebp),%eax
  801837:	01 d0                	add    %edx,%eax
  801839:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80183c:	76 43                	jbe    801881 <memmove+0x6a>
		s += n;
  80183e:	8b 45 10             	mov    0x10(%ebp),%eax
  801841:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801844:	8b 45 10             	mov    0x10(%ebp),%eax
  801847:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80184a:	eb 10                	jmp    80185c <memmove+0x45>
			*--d = *--s;
  80184c:	ff 4d f8             	decl   -0x8(%ebp)
  80184f:	ff 4d fc             	decl   -0x4(%ebp)
  801852:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801855:	8a 10                	mov    (%eax),%dl
  801857:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80185a:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80185c:	8b 45 10             	mov    0x10(%ebp),%eax
  80185f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801862:	89 55 10             	mov    %edx,0x10(%ebp)
  801865:	85 c0                	test   %eax,%eax
  801867:	75 e3                	jne    80184c <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801869:	eb 23                	jmp    80188e <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80186b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80186e:	8d 50 01             	lea    0x1(%eax),%edx
  801871:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801874:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801877:	8d 4a 01             	lea    0x1(%edx),%ecx
  80187a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80187d:	8a 12                	mov    (%edx),%dl
  80187f:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801881:	8b 45 10             	mov    0x10(%ebp),%eax
  801884:	8d 50 ff             	lea    -0x1(%eax),%edx
  801887:	89 55 10             	mov    %edx,0x10(%ebp)
  80188a:	85 c0                	test   %eax,%eax
  80188c:	75 dd                	jne    80186b <memmove+0x54>
			*d++ = *s++;

	return dst;
  80188e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801891:	c9                   	leave  
  801892:	c3                   	ret    

00801893 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801893:	55                   	push   %ebp
  801894:	89 e5                	mov    %esp,%ebp
  801896:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801899:	8b 45 08             	mov    0x8(%ebp),%eax
  80189c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80189f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018a2:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8018a5:	eb 2a                	jmp    8018d1 <memcmp+0x3e>
		if (*s1 != *s2)
  8018a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018aa:	8a 10                	mov    (%eax),%dl
  8018ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018af:	8a 00                	mov    (%eax),%al
  8018b1:	38 c2                	cmp    %al,%dl
  8018b3:	74 16                	je     8018cb <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8018b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018b8:	8a 00                	mov    (%eax),%al
  8018ba:	0f b6 d0             	movzbl %al,%edx
  8018bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018c0:	8a 00                	mov    (%eax),%al
  8018c2:	0f b6 c0             	movzbl %al,%eax
  8018c5:	29 c2                	sub    %eax,%edx
  8018c7:	89 d0                	mov    %edx,%eax
  8018c9:	eb 18                	jmp    8018e3 <memcmp+0x50>
		s1++, s2++;
  8018cb:	ff 45 fc             	incl   -0x4(%ebp)
  8018ce:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8018d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8018d4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8018d7:	89 55 10             	mov    %edx,0x10(%ebp)
  8018da:	85 c0                	test   %eax,%eax
  8018dc:	75 c9                	jne    8018a7 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8018de:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018e3:	c9                   	leave  
  8018e4:	c3                   	ret    

008018e5 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8018e5:	55                   	push   %ebp
  8018e6:	89 e5                	mov    %esp,%ebp
  8018e8:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8018eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8018ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8018f1:	01 d0                	add    %edx,%eax
  8018f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8018f6:	eb 15                	jmp    80190d <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8018f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fb:	8a 00                	mov    (%eax),%al
  8018fd:	0f b6 d0             	movzbl %al,%edx
  801900:	8b 45 0c             	mov    0xc(%ebp),%eax
  801903:	0f b6 c0             	movzbl %al,%eax
  801906:	39 c2                	cmp    %eax,%edx
  801908:	74 0d                	je     801917 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80190a:	ff 45 08             	incl   0x8(%ebp)
  80190d:	8b 45 08             	mov    0x8(%ebp),%eax
  801910:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801913:	72 e3                	jb     8018f8 <memfind+0x13>
  801915:	eb 01                	jmp    801918 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801917:	90                   	nop
	return (void *) s;
  801918:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80191b:	c9                   	leave  
  80191c:	c3                   	ret    

0080191d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80191d:	55                   	push   %ebp
  80191e:	89 e5                	mov    %esp,%ebp
  801920:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801923:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80192a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801931:	eb 03                	jmp    801936 <strtol+0x19>
		s++;
  801933:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801936:	8b 45 08             	mov    0x8(%ebp),%eax
  801939:	8a 00                	mov    (%eax),%al
  80193b:	3c 20                	cmp    $0x20,%al
  80193d:	74 f4                	je     801933 <strtol+0x16>
  80193f:	8b 45 08             	mov    0x8(%ebp),%eax
  801942:	8a 00                	mov    (%eax),%al
  801944:	3c 09                	cmp    $0x9,%al
  801946:	74 eb                	je     801933 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801948:	8b 45 08             	mov    0x8(%ebp),%eax
  80194b:	8a 00                	mov    (%eax),%al
  80194d:	3c 2b                	cmp    $0x2b,%al
  80194f:	75 05                	jne    801956 <strtol+0x39>
		s++;
  801951:	ff 45 08             	incl   0x8(%ebp)
  801954:	eb 13                	jmp    801969 <strtol+0x4c>
	else if (*s == '-')
  801956:	8b 45 08             	mov    0x8(%ebp),%eax
  801959:	8a 00                	mov    (%eax),%al
  80195b:	3c 2d                	cmp    $0x2d,%al
  80195d:	75 0a                	jne    801969 <strtol+0x4c>
		s++, neg = 1;
  80195f:	ff 45 08             	incl   0x8(%ebp)
  801962:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801969:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80196d:	74 06                	je     801975 <strtol+0x58>
  80196f:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801973:	75 20                	jne    801995 <strtol+0x78>
  801975:	8b 45 08             	mov    0x8(%ebp),%eax
  801978:	8a 00                	mov    (%eax),%al
  80197a:	3c 30                	cmp    $0x30,%al
  80197c:	75 17                	jne    801995 <strtol+0x78>
  80197e:	8b 45 08             	mov    0x8(%ebp),%eax
  801981:	40                   	inc    %eax
  801982:	8a 00                	mov    (%eax),%al
  801984:	3c 78                	cmp    $0x78,%al
  801986:	75 0d                	jne    801995 <strtol+0x78>
		s += 2, base = 16;
  801988:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80198c:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801993:	eb 28                	jmp    8019bd <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801995:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801999:	75 15                	jne    8019b0 <strtol+0x93>
  80199b:	8b 45 08             	mov    0x8(%ebp),%eax
  80199e:	8a 00                	mov    (%eax),%al
  8019a0:	3c 30                	cmp    $0x30,%al
  8019a2:	75 0c                	jne    8019b0 <strtol+0x93>
		s++, base = 8;
  8019a4:	ff 45 08             	incl   0x8(%ebp)
  8019a7:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8019ae:	eb 0d                	jmp    8019bd <strtol+0xa0>
	else if (base == 0)
  8019b0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019b4:	75 07                	jne    8019bd <strtol+0xa0>
		base = 10;
  8019b6:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8019bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c0:	8a 00                	mov    (%eax),%al
  8019c2:	3c 2f                	cmp    $0x2f,%al
  8019c4:	7e 19                	jle    8019df <strtol+0xc2>
  8019c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c9:	8a 00                	mov    (%eax),%al
  8019cb:	3c 39                	cmp    $0x39,%al
  8019cd:	7f 10                	jg     8019df <strtol+0xc2>
			dig = *s - '0';
  8019cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d2:	8a 00                	mov    (%eax),%al
  8019d4:	0f be c0             	movsbl %al,%eax
  8019d7:	83 e8 30             	sub    $0x30,%eax
  8019da:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8019dd:	eb 42                	jmp    801a21 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8019df:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e2:	8a 00                	mov    (%eax),%al
  8019e4:	3c 60                	cmp    $0x60,%al
  8019e6:	7e 19                	jle    801a01 <strtol+0xe4>
  8019e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019eb:	8a 00                	mov    (%eax),%al
  8019ed:	3c 7a                	cmp    $0x7a,%al
  8019ef:	7f 10                	jg     801a01 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8019f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f4:	8a 00                	mov    (%eax),%al
  8019f6:	0f be c0             	movsbl %al,%eax
  8019f9:	83 e8 57             	sub    $0x57,%eax
  8019fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8019ff:	eb 20                	jmp    801a21 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801a01:	8b 45 08             	mov    0x8(%ebp),%eax
  801a04:	8a 00                	mov    (%eax),%al
  801a06:	3c 40                	cmp    $0x40,%al
  801a08:	7e 39                	jle    801a43 <strtol+0x126>
  801a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0d:	8a 00                	mov    (%eax),%al
  801a0f:	3c 5a                	cmp    $0x5a,%al
  801a11:	7f 30                	jg     801a43 <strtol+0x126>
			dig = *s - 'A' + 10;
  801a13:	8b 45 08             	mov    0x8(%ebp),%eax
  801a16:	8a 00                	mov    (%eax),%al
  801a18:	0f be c0             	movsbl %al,%eax
  801a1b:	83 e8 37             	sub    $0x37,%eax
  801a1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801a21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a24:	3b 45 10             	cmp    0x10(%ebp),%eax
  801a27:	7d 19                	jge    801a42 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801a29:	ff 45 08             	incl   0x8(%ebp)
  801a2c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a2f:	0f af 45 10          	imul   0x10(%ebp),%eax
  801a33:	89 c2                	mov    %eax,%edx
  801a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a38:	01 d0                	add    %edx,%eax
  801a3a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801a3d:	e9 7b ff ff ff       	jmp    8019bd <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801a42:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801a43:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a47:	74 08                	je     801a51 <strtol+0x134>
		*endptr = (char *) s;
  801a49:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a4c:	8b 55 08             	mov    0x8(%ebp),%edx
  801a4f:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801a51:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801a55:	74 07                	je     801a5e <strtol+0x141>
  801a57:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a5a:	f7 d8                	neg    %eax
  801a5c:	eb 03                	jmp    801a61 <strtol+0x144>
  801a5e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801a61:	c9                   	leave  
  801a62:	c3                   	ret    

00801a63 <ltostr>:

void
ltostr(long value, char *str)
{
  801a63:	55                   	push   %ebp
  801a64:	89 e5                	mov    %esp,%ebp
  801a66:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801a69:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801a70:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801a77:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a7b:	79 13                	jns    801a90 <ltostr+0x2d>
	{
		neg = 1;
  801a7d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801a84:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a87:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801a8a:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801a8d:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801a90:	8b 45 08             	mov    0x8(%ebp),%eax
  801a93:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801a98:	99                   	cltd   
  801a99:	f7 f9                	idiv   %ecx
  801a9b:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801a9e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801aa1:	8d 50 01             	lea    0x1(%eax),%edx
  801aa4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801aa7:	89 c2                	mov    %eax,%edx
  801aa9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aac:	01 d0                	add    %edx,%eax
  801aae:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801ab1:	83 c2 30             	add    $0x30,%edx
  801ab4:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801ab6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ab9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801abe:	f7 e9                	imul   %ecx
  801ac0:	c1 fa 02             	sar    $0x2,%edx
  801ac3:	89 c8                	mov    %ecx,%eax
  801ac5:	c1 f8 1f             	sar    $0x1f,%eax
  801ac8:	29 c2                	sub    %eax,%edx
  801aca:	89 d0                	mov    %edx,%eax
  801acc:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801acf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ad2:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801ad7:	f7 e9                	imul   %ecx
  801ad9:	c1 fa 02             	sar    $0x2,%edx
  801adc:	89 c8                	mov    %ecx,%eax
  801ade:	c1 f8 1f             	sar    $0x1f,%eax
  801ae1:	29 c2                	sub    %eax,%edx
  801ae3:	89 d0                	mov    %edx,%eax
  801ae5:	c1 e0 02             	shl    $0x2,%eax
  801ae8:	01 d0                	add    %edx,%eax
  801aea:	01 c0                	add    %eax,%eax
  801aec:	29 c1                	sub    %eax,%ecx
  801aee:	89 ca                	mov    %ecx,%edx
  801af0:	85 d2                	test   %edx,%edx
  801af2:	75 9c                	jne    801a90 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801af4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801afb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801afe:	48                   	dec    %eax
  801aff:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801b02:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801b06:	74 3d                	je     801b45 <ltostr+0xe2>
		start = 1 ;
  801b08:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801b0f:	eb 34                	jmp    801b45 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801b11:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b14:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b17:	01 d0                	add    %edx,%eax
  801b19:	8a 00                	mov    (%eax),%al
  801b1b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801b1e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b21:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b24:	01 c2                	add    %eax,%edx
  801b26:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801b29:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b2c:	01 c8                	add    %ecx,%eax
  801b2e:	8a 00                	mov    (%eax),%al
  801b30:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801b32:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b35:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b38:	01 c2                	add    %eax,%edx
  801b3a:	8a 45 eb             	mov    -0x15(%ebp),%al
  801b3d:	88 02                	mov    %al,(%edx)
		start++ ;
  801b3f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801b42:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801b45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b48:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801b4b:	7c c4                	jl     801b11 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801b4d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801b50:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b53:	01 d0                	add    %edx,%eax
  801b55:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801b58:	90                   	nop
  801b59:	c9                   	leave  
  801b5a:	c3                   	ret    

00801b5b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801b5b:	55                   	push   %ebp
  801b5c:	89 e5                	mov    %esp,%ebp
  801b5e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801b61:	ff 75 08             	pushl  0x8(%ebp)
  801b64:	e8 54 fa ff ff       	call   8015bd <strlen>
  801b69:	83 c4 04             	add    $0x4,%esp
  801b6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801b6f:	ff 75 0c             	pushl  0xc(%ebp)
  801b72:	e8 46 fa ff ff       	call   8015bd <strlen>
  801b77:	83 c4 04             	add    $0x4,%esp
  801b7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801b7d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801b84:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801b8b:	eb 17                	jmp    801ba4 <strcconcat+0x49>
		final[s] = str1[s] ;
  801b8d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b90:	8b 45 10             	mov    0x10(%ebp),%eax
  801b93:	01 c2                	add    %eax,%edx
  801b95:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801b98:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9b:	01 c8                	add    %ecx,%eax
  801b9d:	8a 00                	mov    (%eax),%al
  801b9f:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801ba1:	ff 45 fc             	incl   -0x4(%ebp)
  801ba4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ba7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801baa:	7c e1                	jl     801b8d <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801bac:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801bb3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801bba:	eb 1f                	jmp    801bdb <strcconcat+0x80>
		final[s++] = str2[i] ;
  801bbc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801bbf:	8d 50 01             	lea    0x1(%eax),%edx
  801bc2:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801bc5:	89 c2                	mov    %eax,%edx
  801bc7:	8b 45 10             	mov    0x10(%ebp),%eax
  801bca:	01 c2                	add    %eax,%edx
  801bcc:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801bcf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bd2:	01 c8                	add    %ecx,%eax
  801bd4:	8a 00                	mov    (%eax),%al
  801bd6:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801bd8:	ff 45 f8             	incl   -0x8(%ebp)
  801bdb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bde:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801be1:	7c d9                	jl     801bbc <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801be3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801be6:	8b 45 10             	mov    0x10(%ebp),%eax
  801be9:	01 d0                	add    %edx,%eax
  801beb:	c6 00 00             	movb   $0x0,(%eax)
}
  801bee:	90                   	nop
  801bef:	c9                   	leave  
  801bf0:	c3                   	ret    

00801bf1 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801bf1:	55                   	push   %ebp
  801bf2:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801bf4:	8b 45 14             	mov    0x14(%ebp),%eax
  801bf7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801bfd:	8b 45 14             	mov    0x14(%ebp),%eax
  801c00:	8b 00                	mov    (%eax),%eax
  801c02:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c09:	8b 45 10             	mov    0x10(%ebp),%eax
  801c0c:	01 d0                	add    %edx,%eax
  801c0e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801c14:	eb 0c                	jmp    801c22 <strsplit+0x31>
			*string++ = 0;
  801c16:	8b 45 08             	mov    0x8(%ebp),%eax
  801c19:	8d 50 01             	lea    0x1(%eax),%edx
  801c1c:	89 55 08             	mov    %edx,0x8(%ebp)
  801c1f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801c22:	8b 45 08             	mov    0x8(%ebp),%eax
  801c25:	8a 00                	mov    (%eax),%al
  801c27:	84 c0                	test   %al,%al
  801c29:	74 18                	je     801c43 <strsplit+0x52>
  801c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2e:	8a 00                	mov    (%eax),%al
  801c30:	0f be c0             	movsbl %al,%eax
  801c33:	50                   	push   %eax
  801c34:	ff 75 0c             	pushl  0xc(%ebp)
  801c37:	e8 13 fb ff ff       	call   80174f <strchr>
  801c3c:	83 c4 08             	add    $0x8,%esp
  801c3f:	85 c0                	test   %eax,%eax
  801c41:	75 d3                	jne    801c16 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801c43:	8b 45 08             	mov    0x8(%ebp),%eax
  801c46:	8a 00                	mov    (%eax),%al
  801c48:	84 c0                	test   %al,%al
  801c4a:	74 5a                	je     801ca6 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801c4c:	8b 45 14             	mov    0x14(%ebp),%eax
  801c4f:	8b 00                	mov    (%eax),%eax
  801c51:	83 f8 0f             	cmp    $0xf,%eax
  801c54:	75 07                	jne    801c5d <strsplit+0x6c>
		{
			return 0;
  801c56:	b8 00 00 00 00       	mov    $0x0,%eax
  801c5b:	eb 66                	jmp    801cc3 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801c5d:	8b 45 14             	mov    0x14(%ebp),%eax
  801c60:	8b 00                	mov    (%eax),%eax
  801c62:	8d 48 01             	lea    0x1(%eax),%ecx
  801c65:	8b 55 14             	mov    0x14(%ebp),%edx
  801c68:	89 0a                	mov    %ecx,(%edx)
  801c6a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c71:	8b 45 10             	mov    0x10(%ebp),%eax
  801c74:	01 c2                	add    %eax,%edx
  801c76:	8b 45 08             	mov    0x8(%ebp),%eax
  801c79:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801c7b:	eb 03                	jmp    801c80 <strsplit+0x8f>
			string++;
  801c7d:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801c80:	8b 45 08             	mov    0x8(%ebp),%eax
  801c83:	8a 00                	mov    (%eax),%al
  801c85:	84 c0                	test   %al,%al
  801c87:	74 8b                	je     801c14 <strsplit+0x23>
  801c89:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8c:	8a 00                	mov    (%eax),%al
  801c8e:	0f be c0             	movsbl %al,%eax
  801c91:	50                   	push   %eax
  801c92:	ff 75 0c             	pushl  0xc(%ebp)
  801c95:	e8 b5 fa ff ff       	call   80174f <strchr>
  801c9a:	83 c4 08             	add    $0x8,%esp
  801c9d:	85 c0                	test   %eax,%eax
  801c9f:	74 dc                	je     801c7d <strsplit+0x8c>
			string++;
	}
  801ca1:	e9 6e ff ff ff       	jmp    801c14 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801ca6:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801ca7:	8b 45 14             	mov    0x14(%ebp),%eax
  801caa:	8b 00                	mov    (%eax),%eax
  801cac:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801cb3:	8b 45 10             	mov    0x10(%ebp),%eax
  801cb6:	01 d0                	add    %edx,%eax
  801cb8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801cbe:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801cc3:	c9                   	leave  
  801cc4:	c3                   	ret    

00801cc5 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801cc5:	55                   	push   %ebp
  801cc6:	89 e5                	mov    %esp,%ebp
  801cc8:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801ccb:	a1 04 50 80 00       	mov    0x805004,%eax
  801cd0:	85 c0                	test   %eax,%eax
  801cd2:	74 1f                	je     801cf3 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801cd4:	e8 1d 00 00 00       	call   801cf6 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801cd9:	83 ec 0c             	sub    $0xc,%esp
  801cdc:	68 f0 46 80 00       	push   $0x8046f0
  801ce1:	e8 55 f2 ff ff       	call   800f3b <cprintf>
  801ce6:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801ce9:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801cf0:	00 00 00 
	}
}
  801cf3:	90                   	nop
  801cf4:	c9                   	leave  
  801cf5:	c3                   	ret    

00801cf6 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801cf6:	55                   	push   %ebp
  801cf7:	89 e5                	mov    %esp,%ebp
  801cf9:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");
LIST_INIT(&AllocMemBlocksList);
  801cfc:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801d03:	00 00 00 
  801d06:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801d0d:	00 00 00 
  801d10:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801d17:	00 00 00 
LIST_INIT(&FreeMemBlocksList);
  801d1a:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801d21:	00 00 00 
  801d24:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801d2b:	00 00 00 
  801d2e:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801d35:	00 00 00 
MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  801d38:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801d3f:	00 02 00 
uint32 requiredSpace=sizeof(struct MemBlock)*NUM_OF_UHEAP_PAGES;
  801d42:	c7 45 f4 00 00 20 00 	movl   $0x200000,-0xc(%ebp)
		MemBlockNodes=(struct MemBlock*)USER_DYN_BLKS_ARRAY;
  801d49:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801d50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d53:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d58:	2d 00 10 00 00       	sub    $0x1000,%eax
  801d5d:	a3 50 50 80 00       	mov    %eax,0x805050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,requiredSpace,PERM_WRITEABLE|PERM_USER);
  801d62:	c7 45 ec 00 00 e0 7f 	movl   $0x7fe00000,-0x14(%ebp)
  801d69:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d6c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d71:	2d 00 10 00 00       	sub    $0x1000,%eax
  801d76:	83 ec 04             	sub    $0x4,%esp
  801d79:	6a 06                	push   $0x6
  801d7b:	ff 75 f4             	pushl  -0xc(%ebp)
  801d7e:	50                   	push   %eax
  801d7f:	e8 ee 05 00 00       	call   802372 <sys_allocate_chunk>
  801d84:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801d87:	a1 20 51 80 00       	mov    0x805120,%eax
  801d8c:	83 ec 0c             	sub    $0xc,%esp
  801d8f:	50                   	push   %eax
  801d90:	e8 63 0c 00 00       	call   8029f8 <initialize_MemBlocksList>
  801d95:	83 c4 10             	add    $0x10,%esp
			struct MemBlock *freeSva=AvailableMemBlocksList.lh_last;
  801d98:	a1 4c 51 80 00       	mov    0x80514c,%eax
  801d9d:	89 45 e8             	mov    %eax,-0x18(%ebp)
			freeSva->size=USER_HEAP_MAX-USER_HEAP_START;
  801da0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801da3:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
			freeSva->size=ROUNDDOWN(freeSva->size,PAGE_SIZE);
  801daa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801dad:	8b 40 0c             	mov    0xc(%eax),%eax
  801db0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801db3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801db6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801dbb:	89 c2                	mov    %eax,%edx
  801dbd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801dc0:	89 50 0c             	mov    %edx,0xc(%eax)

			freeSva->sva=USER_HEAP_START;
  801dc3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801dc6:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
			freeSva->sva=ROUNDUP(freeSva->sva,PAGE_SIZE);
  801dcd:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  801dd4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801dd7:	8b 50 08             	mov    0x8(%eax),%edx
  801dda:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ddd:	01 d0                	add    %edx,%eax
  801ddf:	48                   	dec    %eax
  801de0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801de3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801de6:	ba 00 00 00 00       	mov    $0x0,%edx
  801deb:	f7 75 e0             	divl   -0x20(%ebp)
  801dee:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801df1:	29 d0                	sub    %edx,%eax
  801df3:	89 c2                	mov    %eax,%edx
  801df5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801df8:	89 50 08             	mov    %edx,0x8(%eax)




			LIST_REMOVE(&AvailableMemBlocksList,freeSva);
  801dfb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801dff:	75 14                	jne    801e15 <initialize_dyn_block_system+0x11f>
  801e01:	83 ec 04             	sub    $0x4,%esp
  801e04:	68 15 47 80 00       	push   $0x804715
  801e09:	6a 34                	push   $0x34
  801e0b:	68 33 47 80 00       	push   $0x804733
  801e10:	e8 72 ee ff ff       	call   800c87 <_panic>
  801e15:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e18:	8b 00                	mov    (%eax),%eax
  801e1a:	85 c0                	test   %eax,%eax
  801e1c:	74 10                	je     801e2e <initialize_dyn_block_system+0x138>
  801e1e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e21:	8b 00                	mov    (%eax),%eax
  801e23:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801e26:	8b 52 04             	mov    0x4(%edx),%edx
  801e29:	89 50 04             	mov    %edx,0x4(%eax)
  801e2c:	eb 0b                	jmp    801e39 <initialize_dyn_block_system+0x143>
  801e2e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e31:	8b 40 04             	mov    0x4(%eax),%eax
  801e34:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801e39:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e3c:	8b 40 04             	mov    0x4(%eax),%eax
  801e3f:	85 c0                	test   %eax,%eax
  801e41:	74 0f                	je     801e52 <initialize_dyn_block_system+0x15c>
  801e43:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e46:	8b 40 04             	mov    0x4(%eax),%eax
  801e49:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801e4c:	8b 12                	mov    (%edx),%edx
  801e4e:	89 10                	mov    %edx,(%eax)
  801e50:	eb 0a                	jmp    801e5c <initialize_dyn_block_system+0x166>
  801e52:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e55:	8b 00                	mov    (%eax),%eax
  801e57:	a3 48 51 80 00       	mov    %eax,0x805148
  801e5c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e5f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801e65:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e68:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801e6f:	a1 54 51 80 00       	mov    0x805154,%eax
  801e74:	48                   	dec    %eax
  801e75:	a3 54 51 80 00       	mov    %eax,0x805154
			insert_sorted_with_merge_freeList(freeSva);
  801e7a:	83 ec 0c             	sub    $0xc,%esp
  801e7d:	ff 75 e8             	pushl  -0x18(%ebp)
  801e80:	e8 c4 13 00 00       	call   803249 <insert_sorted_with_merge_freeList>
  801e85:	83 c4 10             	add    $0x10,%esp
//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801e88:	90                   	nop
  801e89:	c9                   	leave  
  801e8a:	c3                   	ret    

00801e8b <malloc>:
//=================================



void* malloc(uint32 size)
{
  801e8b:	55                   	push   %ebp
  801e8c:	89 e5                	mov    %esp,%ebp
  801e8e:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e91:	e8 2f fe ff ff       	call   801cc5 <InitializeUHeap>
	if (size == 0) return NULL ;
  801e96:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801e9a:	75 07                	jne    801ea3 <malloc+0x18>
  801e9c:	b8 00 00 00 00       	mov    $0x0,%eax
  801ea1:	eb 71                	jmp    801f14 <malloc+0x89>
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");
if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  801ea3:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801eaa:	76 07                	jbe    801eb3 <malloc+0x28>
	return NULL;
  801eac:	b8 00 00 00 00       	mov    $0x0,%eax
  801eb1:	eb 61                	jmp    801f14 <malloc+0x89>

	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801eb3:	e8 88 08 00 00       	call   802740 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801eb8:	85 c0                	test   %eax,%eax
  801eba:	74 53                	je     801f0f <malloc+0x84>
	        {
		struct MemBlock *returned_block;
		uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801ebc:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801ec3:	8b 55 08             	mov    0x8(%ebp),%edx
  801ec6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec9:	01 d0                	add    %edx,%eax
  801ecb:	48                   	dec    %eax
  801ecc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801ecf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ed2:	ba 00 00 00 00       	mov    $0x0,%edx
  801ed7:	f7 75 f4             	divl   -0xc(%ebp)
  801eda:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801edd:	29 d0                	sub    %edx,%eax
  801edf:	89 45 ec             	mov    %eax,-0x14(%ebp)
   returned_block=alloc_block_FF(newSize);
  801ee2:	83 ec 0c             	sub    $0xc,%esp
  801ee5:	ff 75 ec             	pushl  -0x14(%ebp)
  801ee8:	e8 d2 0d 00 00       	call   802cbf <alloc_block_FF>
  801eed:	83 c4 10             	add    $0x10,%esp
  801ef0:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(returned_block!=NULL)
  801ef3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801ef7:	74 16                	je     801f0f <malloc+0x84>
    {
    	insert_sorted_allocList(returned_block);
  801ef9:	83 ec 0c             	sub    $0xc,%esp
  801efc:	ff 75 e8             	pushl  -0x18(%ebp)
  801eff:	e8 0c 0c 00 00       	call   802b10 <insert_sorted_allocList>
  801f04:	83 c4 10             	add    $0x10,%esp
	return(void*) returned_block->sva;
  801f07:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f0a:	8b 40 08             	mov    0x8(%eax),%eax
  801f0d:	eb 05                	jmp    801f14 <malloc+0x89>
    }

			}


	return NULL;
  801f0f:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801f14:	c9                   	leave  
  801f15:	c3                   	ret    

00801f16 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801f16:	55                   	push   %ebp
  801f17:	89 e5                	mov    %esp,%ebp
  801f19:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//you should get the size of the given allocation using its address
	uint32 va=ROUNDDOWN((uint32)virtual_address,PAGE_SIZE);
  801f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f25:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801f2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *returned_block=find_block(&AllocMemBlocksList,va);
  801f2d:	83 ec 08             	sub    $0x8,%esp
  801f30:	ff 75 f0             	pushl  -0x10(%ebp)
  801f33:	68 40 50 80 00       	push   $0x805040
  801f38:	e8 a0 0b 00 00       	call   802add <find_block>
  801f3d:	83 c4 10             	add    $0x10,%esp
  801f40:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_free_user_mem((uint32)virtual_address,returned_block->size);
  801f43:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f46:	8b 50 0c             	mov    0xc(%eax),%edx
  801f49:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4c:	83 ec 08             	sub    $0x8,%esp
  801f4f:	52                   	push   %edx
  801f50:	50                   	push   %eax
  801f51:	e8 e4 03 00 00       	call   80233a <sys_free_user_mem>
  801f56:	83 c4 10             	add    $0x10,%esp

    LIST_REMOVE(&AllocMemBlocksList,returned_block);
  801f59:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801f5d:	75 17                	jne    801f76 <free+0x60>
  801f5f:	83 ec 04             	sub    $0x4,%esp
  801f62:	68 15 47 80 00       	push   $0x804715
  801f67:	68 84 00 00 00       	push   $0x84
  801f6c:	68 33 47 80 00       	push   $0x804733
  801f71:	e8 11 ed ff ff       	call   800c87 <_panic>
  801f76:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f79:	8b 00                	mov    (%eax),%eax
  801f7b:	85 c0                	test   %eax,%eax
  801f7d:	74 10                	je     801f8f <free+0x79>
  801f7f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f82:	8b 00                	mov    (%eax),%eax
  801f84:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801f87:	8b 52 04             	mov    0x4(%edx),%edx
  801f8a:	89 50 04             	mov    %edx,0x4(%eax)
  801f8d:	eb 0b                	jmp    801f9a <free+0x84>
  801f8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f92:	8b 40 04             	mov    0x4(%eax),%eax
  801f95:	a3 44 50 80 00       	mov    %eax,0x805044
  801f9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f9d:	8b 40 04             	mov    0x4(%eax),%eax
  801fa0:	85 c0                	test   %eax,%eax
  801fa2:	74 0f                	je     801fb3 <free+0x9d>
  801fa4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fa7:	8b 40 04             	mov    0x4(%eax),%eax
  801faa:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801fad:	8b 12                	mov    (%edx),%edx
  801faf:	89 10                	mov    %edx,(%eax)
  801fb1:	eb 0a                	jmp    801fbd <free+0xa7>
  801fb3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fb6:	8b 00                	mov    (%eax),%eax
  801fb8:	a3 40 50 80 00       	mov    %eax,0x805040
  801fbd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fc0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801fc6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fc9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801fd0:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801fd5:	48                   	dec    %eax
  801fd6:	a3 4c 50 80 00       	mov    %eax,0x80504c
	insert_sorted_with_merge_freeList(returned_block);
  801fdb:	83 ec 0c             	sub    $0xc,%esp
  801fde:	ff 75 ec             	pushl  -0x14(%ebp)
  801fe1:	e8 63 12 00 00       	call   803249 <insert_sorted_with_merge_freeList>
  801fe6:	83 c4 10             	add    $0x10,%esp

	//you need to call sys_free_user_mem()
}
  801fe9:	90                   	nop
  801fea:	c9                   	leave  
  801feb:	c3                   	ret    

00801fec <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801fec:	55                   	push   %ebp
  801fed:	89 e5                	mov    %esp,%ebp
  801fef:	83 ec 38             	sub    $0x38,%esp
  801ff2:	8b 45 10             	mov    0x10(%ebp),%eax
  801ff5:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801ff8:	e8 c8 fc ff ff       	call   801cc5 <InitializeUHeap>
	if (size == 0) return NULL ;
  801ffd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802001:	75 0a                	jne    80200d <smalloc+0x21>
  802003:	b8 00 00 00 00       	mov    $0x0,%eax
  802008:	e9 a0 00 00 00       	jmp    8020ad <smalloc+0xc1>
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	// Steps:
	//	1) Implement FIRST FIT strategy to search the heap for suitable space
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  80200d:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  802014:	76 0a                	jbe    802020 <smalloc+0x34>
		return NULL;
  802016:	b8 00 00 00 00       	mov    $0x0,%eax
  80201b:	e9 8d 00 00 00       	jmp    8020ad <smalloc+0xc1>

		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  802020:	e8 1b 07 00 00       	call   802740 <sys_isUHeapPlacementStrategyFIRSTFIT>
  802025:	85 c0                	test   %eax,%eax
  802027:	74 7f                	je     8020a8 <smalloc+0xbc>
		        {
			struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  802029:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  802030:	8b 55 0c             	mov    0xc(%ebp),%edx
  802033:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802036:	01 d0                	add    %edx,%eax
  802038:	48                   	dec    %eax
  802039:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80203c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80203f:	ba 00 00 00 00       	mov    $0x0,%edx
  802044:	f7 75 f4             	divl   -0xc(%ebp)
  802047:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80204a:	29 d0                	sub    %edx,%eax
  80204c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	   returned_block=alloc_block_FF(newSize);
  80204f:	83 ec 0c             	sub    $0xc,%esp
  802052:	ff 75 ec             	pushl  -0x14(%ebp)
  802055:	e8 65 0c 00 00       	call   802cbf <alloc_block_FF>
  80205a:	83 c4 10             	add    $0x10,%esp
  80205d:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   if(returned_block!=NULL)
  802060:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802064:	74 42                	je     8020a8 <smalloc+0xbc>
	      {
	      	   insert_sorted_allocList(returned_block);
  802066:	83 ec 0c             	sub    $0xc,%esp
  802069:	ff 75 e8             	pushl  -0x18(%ebp)
  80206c:	e8 9f 0a 00 00       	call   802b10 <insert_sorted_allocList>
  802071:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_createSharedObject(sharedVarName,size,isWritable,(void*)returned_block->sva);
  802074:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802077:	8b 40 08             	mov    0x8(%eax),%eax
  80207a:	89 c2                	mov    %eax,%edx
  80207c:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  802080:	52                   	push   %edx
  802081:	50                   	push   %eax
  802082:	ff 75 0c             	pushl  0xc(%ebp)
  802085:	ff 75 08             	pushl  0x8(%ebp)
  802088:	e8 38 04 00 00       	call   8024c5 <sys_createSharedObject>
  80208d:	83 c4 10             	add    $0x10,%esp
  802090:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    	     if(ID<0)
  802093:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802097:	79 07                	jns    8020a0 <smalloc+0xb4>
	    		  return NULL;
  802099:	b8 00 00 00 00       	mov    $0x0,%eax
  80209e:	eb 0d                	jmp    8020ad <smalloc+0xc1>
	  	return(void*) returned_block->sva;
  8020a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8020a3:	8b 40 08             	mov    0x8(%eax),%eax
  8020a6:	eb 05                	jmp    8020ad <smalloc+0xc1>


				}


		return NULL;
  8020a8:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8020ad:	c9                   	leave  
  8020ae:	c3                   	ret    

008020af <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8020af:	55                   	push   %ebp
  8020b0:	89 e5                	mov    %esp,%ebp
  8020b2:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8020b5:	e8 0b fc ff ff       	call   801cc5 <InitializeUHeap>
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	// Steps:
	//	1) Get the size of the shared variable (use sys_getSizeOfSharedObject())
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  8020ba:	e8 81 06 00 00       	call   802740 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8020bf:	85 c0                	test   %eax,%eax
  8020c1:	0f 84 9f 00 00 00    	je     802166 <sget+0xb7>
	int size=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8020c7:	83 ec 08             	sub    $0x8,%esp
  8020ca:	ff 75 0c             	pushl  0xc(%ebp)
  8020cd:	ff 75 08             	pushl  0x8(%ebp)
  8020d0:	e8 1a 04 00 00       	call   8024ef <sys_getSizeOfSharedObject>
  8020d5:	83 c4 10             	add    $0x10,%esp
  8020d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size<0)
  8020db:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020df:	79 0a                	jns    8020eb <sget+0x3c>
		return NULL;
  8020e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8020e6:	e9 80 00 00 00       	jmp    80216b <sget+0xbc>
	struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  8020eb:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8020f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020f8:	01 d0                	add    %edx,%eax
  8020fa:	48                   	dec    %eax
  8020fb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8020fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802101:	ba 00 00 00 00       	mov    $0x0,%edx
  802106:	f7 75 f0             	divl   -0x10(%ebp)
  802109:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80210c:	29 d0                	sub    %edx,%eax
  80210e:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   returned_block=alloc_block_FF(newSize);
  802111:	83 ec 0c             	sub    $0xc,%esp
  802114:	ff 75 e8             	pushl  -0x18(%ebp)
  802117:	e8 a3 0b 00 00       	call   802cbf <alloc_block_FF>
  80211c:	83 c4 10             	add    $0x10,%esp
  80211f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	   if(returned_block!=NULL)
  802122:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802126:	74 3e                	je     802166 <sget+0xb7>
	      {
	      	   insert_sorted_allocList(returned_block);
  802128:	83 ec 0c             	sub    $0xc,%esp
  80212b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80212e:	e8 dd 09 00 00       	call   802b10 <insert_sorted_allocList>
  802133:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)returned_block->sva);
  802136:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802139:	8b 40 08             	mov    0x8(%eax),%eax
  80213c:	83 ec 04             	sub    $0x4,%esp
  80213f:	50                   	push   %eax
  802140:	ff 75 0c             	pushl  0xc(%ebp)
  802143:	ff 75 08             	pushl  0x8(%ebp)
  802146:	e8 c1 03 00 00       	call   80250c <sys_getSharedObject>
  80214b:	83 c4 10             	add    $0x10,%esp
  80214e:	89 45 e0             	mov    %eax,-0x20(%ebp)
	    	     if(ID<0)
  802151:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802155:	79 07                	jns    80215e <sget+0xaf>
	    		  return NULL;
  802157:	b8 00 00 00 00       	mov    $0x0,%eax
  80215c:	eb 0d                	jmp    80216b <sget+0xbc>
	  	return(void*) returned_block->sva;
  80215e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802161:	8b 40 08             	mov    0x8(%eax),%eax
  802164:	eb 05                	jmp    80216b <sget+0xbc>
	      }
	}
	   return NULL;
  802166:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80216b:	c9                   	leave  
  80216c:	c3                   	ret    

0080216d <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80216d:	55                   	push   %ebp
  80216e:	89 e5                	mov    %esp,%ebp
  802170:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802173:	e8 4d fb ff ff       	call   801cc5 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802178:	83 ec 04             	sub    $0x4,%esp
  80217b:	68 40 47 80 00       	push   $0x804740
  802180:	68 12 01 00 00       	push   $0x112
  802185:	68 33 47 80 00       	push   $0x804733
  80218a:	e8 f8 ea ff ff       	call   800c87 <_panic>

0080218f <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80218f:	55                   	push   %ebp
  802190:	89 e5                	mov    %esp,%ebp
  802192:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  802195:	83 ec 04             	sub    $0x4,%esp
  802198:	68 68 47 80 00       	push   $0x804768
  80219d:	68 26 01 00 00       	push   $0x126
  8021a2:	68 33 47 80 00       	push   $0x804733
  8021a7:	e8 db ea ff ff       	call   800c87 <_panic>

008021ac <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8021ac:	55                   	push   %ebp
  8021ad:	89 e5                	mov    %esp,%ebp
  8021af:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8021b2:	83 ec 04             	sub    $0x4,%esp
  8021b5:	68 8c 47 80 00       	push   $0x80478c
  8021ba:	68 31 01 00 00       	push   $0x131
  8021bf:	68 33 47 80 00       	push   $0x804733
  8021c4:	e8 be ea ff ff       	call   800c87 <_panic>

008021c9 <shrink>:

}
void shrink(uint32 newSize)
{
  8021c9:	55                   	push   %ebp
  8021ca:	89 e5                	mov    %esp,%ebp
  8021cc:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8021cf:	83 ec 04             	sub    $0x4,%esp
  8021d2:	68 8c 47 80 00       	push   $0x80478c
  8021d7:	68 36 01 00 00       	push   $0x136
  8021dc:	68 33 47 80 00       	push   $0x804733
  8021e1:	e8 a1 ea ff ff       	call   800c87 <_panic>

008021e6 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8021e6:	55                   	push   %ebp
  8021e7:	89 e5                	mov    %esp,%ebp
  8021e9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8021ec:	83 ec 04             	sub    $0x4,%esp
  8021ef:	68 8c 47 80 00       	push   $0x80478c
  8021f4:	68 3b 01 00 00       	push   $0x13b
  8021f9:	68 33 47 80 00       	push   $0x804733
  8021fe:	e8 84 ea ff ff       	call   800c87 <_panic>

00802203 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802203:	55                   	push   %ebp
  802204:	89 e5                	mov    %esp,%ebp
  802206:	57                   	push   %edi
  802207:	56                   	push   %esi
  802208:	53                   	push   %ebx
  802209:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80220c:	8b 45 08             	mov    0x8(%ebp),%eax
  80220f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802212:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802215:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802218:	8b 7d 18             	mov    0x18(%ebp),%edi
  80221b:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80221e:	cd 30                	int    $0x30
  802220:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802223:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802226:	83 c4 10             	add    $0x10,%esp
  802229:	5b                   	pop    %ebx
  80222a:	5e                   	pop    %esi
  80222b:	5f                   	pop    %edi
  80222c:	5d                   	pop    %ebp
  80222d:	c3                   	ret    

0080222e <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80222e:	55                   	push   %ebp
  80222f:	89 e5                	mov    %esp,%ebp
  802231:	83 ec 04             	sub    $0x4,%esp
  802234:	8b 45 10             	mov    0x10(%ebp),%eax
  802237:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80223a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80223e:	8b 45 08             	mov    0x8(%ebp),%eax
  802241:	6a 00                	push   $0x0
  802243:	6a 00                	push   $0x0
  802245:	52                   	push   %edx
  802246:	ff 75 0c             	pushl  0xc(%ebp)
  802249:	50                   	push   %eax
  80224a:	6a 00                	push   $0x0
  80224c:	e8 b2 ff ff ff       	call   802203 <syscall>
  802251:	83 c4 18             	add    $0x18,%esp
}
  802254:	90                   	nop
  802255:	c9                   	leave  
  802256:	c3                   	ret    

00802257 <sys_cgetc>:

int
sys_cgetc(void)
{
  802257:	55                   	push   %ebp
  802258:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80225a:	6a 00                	push   $0x0
  80225c:	6a 00                	push   $0x0
  80225e:	6a 00                	push   $0x0
  802260:	6a 00                	push   $0x0
  802262:	6a 00                	push   $0x0
  802264:	6a 01                	push   $0x1
  802266:	e8 98 ff ff ff       	call   802203 <syscall>
  80226b:	83 c4 18             	add    $0x18,%esp
}
  80226e:	c9                   	leave  
  80226f:	c3                   	ret    

00802270 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802270:	55                   	push   %ebp
  802271:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802273:	8b 55 0c             	mov    0xc(%ebp),%edx
  802276:	8b 45 08             	mov    0x8(%ebp),%eax
  802279:	6a 00                	push   $0x0
  80227b:	6a 00                	push   $0x0
  80227d:	6a 00                	push   $0x0
  80227f:	52                   	push   %edx
  802280:	50                   	push   %eax
  802281:	6a 05                	push   $0x5
  802283:	e8 7b ff ff ff       	call   802203 <syscall>
  802288:	83 c4 18             	add    $0x18,%esp
}
  80228b:	c9                   	leave  
  80228c:	c3                   	ret    

0080228d <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80228d:	55                   	push   %ebp
  80228e:	89 e5                	mov    %esp,%ebp
  802290:	56                   	push   %esi
  802291:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802292:	8b 75 18             	mov    0x18(%ebp),%esi
  802295:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802298:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80229b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80229e:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a1:	56                   	push   %esi
  8022a2:	53                   	push   %ebx
  8022a3:	51                   	push   %ecx
  8022a4:	52                   	push   %edx
  8022a5:	50                   	push   %eax
  8022a6:	6a 06                	push   $0x6
  8022a8:	e8 56 ff ff ff       	call   802203 <syscall>
  8022ad:	83 c4 18             	add    $0x18,%esp
}
  8022b0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022b3:	5b                   	pop    %ebx
  8022b4:	5e                   	pop    %esi
  8022b5:	5d                   	pop    %ebp
  8022b6:	c3                   	ret    

008022b7 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8022b7:	55                   	push   %ebp
  8022b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8022ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c0:	6a 00                	push   $0x0
  8022c2:	6a 00                	push   $0x0
  8022c4:	6a 00                	push   $0x0
  8022c6:	52                   	push   %edx
  8022c7:	50                   	push   %eax
  8022c8:	6a 07                	push   $0x7
  8022ca:	e8 34 ff ff ff       	call   802203 <syscall>
  8022cf:	83 c4 18             	add    $0x18,%esp
}
  8022d2:	c9                   	leave  
  8022d3:	c3                   	ret    

008022d4 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8022d4:	55                   	push   %ebp
  8022d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8022d7:	6a 00                	push   $0x0
  8022d9:	6a 00                	push   $0x0
  8022db:	6a 00                	push   $0x0
  8022dd:	ff 75 0c             	pushl  0xc(%ebp)
  8022e0:	ff 75 08             	pushl  0x8(%ebp)
  8022e3:	6a 08                	push   $0x8
  8022e5:	e8 19 ff ff ff       	call   802203 <syscall>
  8022ea:	83 c4 18             	add    $0x18,%esp
}
  8022ed:	c9                   	leave  
  8022ee:	c3                   	ret    

008022ef <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8022ef:	55                   	push   %ebp
  8022f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8022f2:	6a 00                	push   $0x0
  8022f4:	6a 00                	push   $0x0
  8022f6:	6a 00                	push   $0x0
  8022f8:	6a 00                	push   $0x0
  8022fa:	6a 00                	push   $0x0
  8022fc:	6a 09                	push   $0x9
  8022fe:	e8 00 ff ff ff       	call   802203 <syscall>
  802303:	83 c4 18             	add    $0x18,%esp
}
  802306:	c9                   	leave  
  802307:	c3                   	ret    

00802308 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802308:	55                   	push   %ebp
  802309:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80230b:	6a 00                	push   $0x0
  80230d:	6a 00                	push   $0x0
  80230f:	6a 00                	push   $0x0
  802311:	6a 00                	push   $0x0
  802313:	6a 00                	push   $0x0
  802315:	6a 0a                	push   $0xa
  802317:	e8 e7 fe ff ff       	call   802203 <syscall>
  80231c:	83 c4 18             	add    $0x18,%esp
}
  80231f:	c9                   	leave  
  802320:	c3                   	ret    

00802321 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802321:	55                   	push   %ebp
  802322:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802324:	6a 00                	push   $0x0
  802326:	6a 00                	push   $0x0
  802328:	6a 00                	push   $0x0
  80232a:	6a 00                	push   $0x0
  80232c:	6a 00                	push   $0x0
  80232e:	6a 0b                	push   $0xb
  802330:	e8 ce fe ff ff       	call   802203 <syscall>
  802335:	83 c4 18             	add    $0x18,%esp
}
  802338:	c9                   	leave  
  802339:	c3                   	ret    

0080233a <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80233a:	55                   	push   %ebp
  80233b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80233d:	6a 00                	push   $0x0
  80233f:	6a 00                	push   $0x0
  802341:	6a 00                	push   $0x0
  802343:	ff 75 0c             	pushl  0xc(%ebp)
  802346:	ff 75 08             	pushl  0x8(%ebp)
  802349:	6a 0f                	push   $0xf
  80234b:	e8 b3 fe ff ff       	call   802203 <syscall>
  802350:	83 c4 18             	add    $0x18,%esp
	return;
  802353:	90                   	nop
}
  802354:	c9                   	leave  
  802355:	c3                   	ret    

00802356 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802356:	55                   	push   %ebp
  802357:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802359:	6a 00                	push   $0x0
  80235b:	6a 00                	push   $0x0
  80235d:	6a 00                	push   $0x0
  80235f:	ff 75 0c             	pushl  0xc(%ebp)
  802362:	ff 75 08             	pushl  0x8(%ebp)
  802365:	6a 10                	push   $0x10
  802367:	e8 97 fe ff ff       	call   802203 <syscall>
  80236c:	83 c4 18             	add    $0x18,%esp
	return ;
  80236f:	90                   	nop
}
  802370:	c9                   	leave  
  802371:	c3                   	ret    

00802372 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802372:	55                   	push   %ebp
  802373:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802375:	6a 00                	push   $0x0
  802377:	6a 00                	push   $0x0
  802379:	ff 75 10             	pushl  0x10(%ebp)
  80237c:	ff 75 0c             	pushl  0xc(%ebp)
  80237f:	ff 75 08             	pushl  0x8(%ebp)
  802382:	6a 11                	push   $0x11
  802384:	e8 7a fe ff ff       	call   802203 <syscall>
  802389:	83 c4 18             	add    $0x18,%esp
	return ;
  80238c:	90                   	nop
}
  80238d:	c9                   	leave  
  80238e:	c3                   	ret    

0080238f <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80238f:	55                   	push   %ebp
  802390:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802392:	6a 00                	push   $0x0
  802394:	6a 00                	push   $0x0
  802396:	6a 00                	push   $0x0
  802398:	6a 00                	push   $0x0
  80239a:	6a 00                	push   $0x0
  80239c:	6a 0c                	push   $0xc
  80239e:	e8 60 fe ff ff       	call   802203 <syscall>
  8023a3:	83 c4 18             	add    $0x18,%esp
}
  8023a6:	c9                   	leave  
  8023a7:	c3                   	ret    

008023a8 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8023a8:	55                   	push   %ebp
  8023a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8023ab:	6a 00                	push   $0x0
  8023ad:	6a 00                	push   $0x0
  8023af:	6a 00                	push   $0x0
  8023b1:	6a 00                	push   $0x0
  8023b3:	ff 75 08             	pushl  0x8(%ebp)
  8023b6:	6a 0d                	push   $0xd
  8023b8:	e8 46 fe ff ff       	call   802203 <syscall>
  8023bd:	83 c4 18             	add    $0x18,%esp
}
  8023c0:	c9                   	leave  
  8023c1:	c3                   	ret    

008023c2 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8023c2:	55                   	push   %ebp
  8023c3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8023c5:	6a 00                	push   $0x0
  8023c7:	6a 00                	push   $0x0
  8023c9:	6a 00                	push   $0x0
  8023cb:	6a 00                	push   $0x0
  8023cd:	6a 00                	push   $0x0
  8023cf:	6a 0e                	push   $0xe
  8023d1:	e8 2d fe ff ff       	call   802203 <syscall>
  8023d6:	83 c4 18             	add    $0x18,%esp
}
  8023d9:	90                   	nop
  8023da:	c9                   	leave  
  8023db:	c3                   	ret    

008023dc <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8023dc:	55                   	push   %ebp
  8023dd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8023df:	6a 00                	push   $0x0
  8023e1:	6a 00                	push   $0x0
  8023e3:	6a 00                	push   $0x0
  8023e5:	6a 00                	push   $0x0
  8023e7:	6a 00                	push   $0x0
  8023e9:	6a 13                	push   $0x13
  8023eb:	e8 13 fe ff ff       	call   802203 <syscall>
  8023f0:	83 c4 18             	add    $0x18,%esp
}
  8023f3:	90                   	nop
  8023f4:	c9                   	leave  
  8023f5:	c3                   	ret    

008023f6 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8023f6:	55                   	push   %ebp
  8023f7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8023f9:	6a 00                	push   $0x0
  8023fb:	6a 00                	push   $0x0
  8023fd:	6a 00                	push   $0x0
  8023ff:	6a 00                	push   $0x0
  802401:	6a 00                	push   $0x0
  802403:	6a 14                	push   $0x14
  802405:	e8 f9 fd ff ff       	call   802203 <syscall>
  80240a:	83 c4 18             	add    $0x18,%esp
}
  80240d:	90                   	nop
  80240e:	c9                   	leave  
  80240f:	c3                   	ret    

00802410 <sys_cputc>:


void
sys_cputc(const char c)
{
  802410:	55                   	push   %ebp
  802411:	89 e5                	mov    %esp,%ebp
  802413:	83 ec 04             	sub    $0x4,%esp
  802416:	8b 45 08             	mov    0x8(%ebp),%eax
  802419:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80241c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802420:	6a 00                	push   $0x0
  802422:	6a 00                	push   $0x0
  802424:	6a 00                	push   $0x0
  802426:	6a 00                	push   $0x0
  802428:	50                   	push   %eax
  802429:	6a 15                	push   $0x15
  80242b:	e8 d3 fd ff ff       	call   802203 <syscall>
  802430:	83 c4 18             	add    $0x18,%esp
}
  802433:	90                   	nop
  802434:	c9                   	leave  
  802435:	c3                   	ret    

00802436 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802436:	55                   	push   %ebp
  802437:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802439:	6a 00                	push   $0x0
  80243b:	6a 00                	push   $0x0
  80243d:	6a 00                	push   $0x0
  80243f:	6a 00                	push   $0x0
  802441:	6a 00                	push   $0x0
  802443:	6a 16                	push   $0x16
  802445:	e8 b9 fd ff ff       	call   802203 <syscall>
  80244a:	83 c4 18             	add    $0x18,%esp
}
  80244d:	90                   	nop
  80244e:	c9                   	leave  
  80244f:	c3                   	ret    

00802450 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802450:	55                   	push   %ebp
  802451:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802453:	8b 45 08             	mov    0x8(%ebp),%eax
  802456:	6a 00                	push   $0x0
  802458:	6a 00                	push   $0x0
  80245a:	6a 00                	push   $0x0
  80245c:	ff 75 0c             	pushl  0xc(%ebp)
  80245f:	50                   	push   %eax
  802460:	6a 17                	push   $0x17
  802462:	e8 9c fd ff ff       	call   802203 <syscall>
  802467:	83 c4 18             	add    $0x18,%esp
}
  80246a:	c9                   	leave  
  80246b:	c3                   	ret    

0080246c <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80246c:	55                   	push   %ebp
  80246d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80246f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802472:	8b 45 08             	mov    0x8(%ebp),%eax
  802475:	6a 00                	push   $0x0
  802477:	6a 00                	push   $0x0
  802479:	6a 00                	push   $0x0
  80247b:	52                   	push   %edx
  80247c:	50                   	push   %eax
  80247d:	6a 1a                	push   $0x1a
  80247f:	e8 7f fd ff ff       	call   802203 <syscall>
  802484:	83 c4 18             	add    $0x18,%esp
}
  802487:	c9                   	leave  
  802488:	c3                   	ret    

00802489 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802489:	55                   	push   %ebp
  80248a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80248c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80248f:	8b 45 08             	mov    0x8(%ebp),%eax
  802492:	6a 00                	push   $0x0
  802494:	6a 00                	push   $0x0
  802496:	6a 00                	push   $0x0
  802498:	52                   	push   %edx
  802499:	50                   	push   %eax
  80249a:	6a 18                	push   $0x18
  80249c:	e8 62 fd ff ff       	call   802203 <syscall>
  8024a1:	83 c4 18             	add    $0x18,%esp
}
  8024a4:	90                   	nop
  8024a5:	c9                   	leave  
  8024a6:	c3                   	ret    

008024a7 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8024a7:	55                   	push   %ebp
  8024a8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8024aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b0:	6a 00                	push   $0x0
  8024b2:	6a 00                	push   $0x0
  8024b4:	6a 00                	push   $0x0
  8024b6:	52                   	push   %edx
  8024b7:	50                   	push   %eax
  8024b8:	6a 19                	push   $0x19
  8024ba:	e8 44 fd ff ff       	call   802203 <syscall>
  8024bf:	83 c4 18             	add    $0x18,%esp
}
  8024c2:	90                   	nop
  8024c3:	c9                   	leave  
  8024c4:	c3                   	ret    

008024c5 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8024c5:	55                   	push   %ebp
  8024c6:	89 e5                	mov    %esp,%ebp
  8024c8:	83 ec 04             	sub    $0x4,%esp
  8024cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8024ce:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8024d1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8024d4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8024d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8024db:	6a 00                	push   $0x0
  8024dd:	51                   	push   %ecx
  8024de:	52                   	push   %edx
  8024df:	ff 75 0c             	pushl  0xc(%ebp)
  8024e2:	50                   	push   %eax
  8024e3:	6a 1b                	push   $0x1b
  8024e5:	e8 19 fd ff ff       	call   802203 <syscall>
  8024ea:	83 c4 18             	add    $0x18,%esp
}
  8024ed:	c9                   	leave  
  8024ee:	c3                   	ret    

008024ef <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8024ef:	55                   	push   %ebp
  8024f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8024f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f8:	6a 00                	push   $0x0
  8024fa:	6a 00                	push   $0x0
  8024fc:	6a 00                	push   $0x0
  8024fe:	52                   	push   %edx
  8024ff:	50                   	push   %eax
  802500:	6a 1c                	push   $0x1c
  802502:	e8 fc fc ff ff       	call   802203 <syscall>
  802507:	83 c4 18             	add    $0x18,%esp
}
  80250a:	c9                   	leave  
  80250b:	c3                   	ret    

0080250c <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80250c:	55                   	push   %ebp
  80250d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80250f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802512:	8b 55 0c             	mov    0xc(%ebp),%edx
  802515:	8b 45 08             	mov    0x8(%ebp),%eax
  802518:	6a 00                	push   $0x0
  80251a:	6a 00                	push   $0x0
  80251c:	51                   	push   %ecx
  80251d:	52                   	push   %edx
  80251e:	50                   	push   %eax
  80251f:	6a 1d                	push   $0x1d
  802521:	e8 dd fc ff ff       	call   802203 <syscall>
  802526:	83 c4 18             	add    $0x18,%esp
}
  802529:	c9                   	leave  
  80252a:	c3                   	ret    

0080252b <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80252b:	55                   	push   %ebp
  80252c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80252e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802531:	8b 45 08             	mov    0x8(%ebp),%eax
  802534:	6a 00                	push   $0x0
  802536:	6a 00                	push   $0x0
  802538:	6a 00                	push   $0x0
  80253a:	52                   	push   %edx
  80253b:	50                   	push   %eax
  80253c:	6a 1e                	push   $0x1e
  80253e:	e8 c0 fc ff ff       	call   802203 <syscall>
  802543:	83 c4 18             	add    $0x18,%esp
}
  802546:	c9                   	leave  
  802547:	c3                   	ret    

00802548 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802548:	55                   	push   %ebp
  802549:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80254b:	6a 00                	push   $0x0
  80254d:	6a 00                	push   $0x0
  80254f:	6a 00                	push   $0x0
  802551:	6a 00                	push   $0x0
  802553:	6a 00                	push   $0x0
  802555:	6a 1f                	push   $0x1f
  802557:	e8 a7 fc ff ff       	call   802203 <syscall>
  80255c:	83 c4 18             	add    $0x18,%esp
}
  80255f:	c9                   	leave  
  802560:	c3                   	ret    

00802561 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802561:	55                   	push   %ebp
  802562:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802564:	8b 45 08             	mov    0x8(%ebp),%eax
  802567:	6a 00                	push   $0x0
  802569:	ff 75 14             	pushl  0x14(%ebp)
  80256c:	ff 75 10             	pushl  0x10(%ebp)
  80256f:	ff 75 0c             	pushl  0xc(%ebp)
  802572:	50                   	push   %eax
  802573:	6a 20                	push   $0x20
  802575:	e8 89 fc ff ff       	call   802203 <syscall>
  80257a:	83 c4 18             	add    $0x18,%esp
}
  80257d:	c9                   	leave  
  80257e:	c3                   	ret    

0080257f <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80257f:	55                   	push   %ebp
  802580:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802582:	8b 45 08             	mov    0x8(%ebp),%eax
  802585:	6a 00                	push   $0x0
  802587:	6a 00                	push   $0x0
  802589:	6a 00                	push   $0x0
  80258b:	6a 00                	push   $0x0
  80258d:	50                   	push   %eax
  80258e:	6a 21                	push   $0x21
  802590:	e8 6e fc ff ff       	call   802203 <syscall>
  802595:	83 c4 18             	add    $0x18,%esp
}
  802598:	90                   	nop
  802599:	c9                   	leave  
  80259a:	c3                   	ret    

0080259b <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80259b:	55                   	push   %ebp
  80259c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80259e:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a1:	6a 00                	push   $0x0
  8025a3:	6a 00                	push   $0x0
  8025a5:	6a 00                	push   $0x0
  8025a7:	6a 00                	push   $0x0
  8025a9:	50                   	push   %eax
  8025aa:	6a 22                	push   $0x22
  8025ac:	e8 52 fc ff ff       	call   802203 <syscall>
  8025b1:	83 c4 18             	add    $0x18,%esp
}
  8025b4:	c9                   	leave  
  8025b5:	c3                   	ret    

008025b6 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8025b6:	55                   	push   %ebp
  8025b7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8025b9:	6a 00                	push   $0x0
  8025bb:	6a 00                	push   $0x0
  8025bd:	6a 00                	push   $0x0
  8025bf:	6a 00                	push   $0x0
  8025c1:	6a 00                	push   $0x0
  8025c3:	6a 02                	push   $0x2
  8025c5:	e8 39 fc ff ff       	call   802203 <syscall>
  8025ca:	83 c4 18             	add    $0x18,%esp
}
  8025cd:	c9                   	leave  
  8025ce:	c3                   	ret    

008025cf <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8025cf:	55                   	push   %ebp
  8025d0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8025d2:	6a 00                	push   $0x0
  8025d4:	6a 00                	push   $0x0
  8025d6:	6a 00                	push   $0x0
  8025d8:	6a 00                	push   $0x0
  8025da:	6a 00                	push   $0x0
  8025dc:	6a 03                	push   $0x3
  8025de:	e8 20 fc ff ff       	call   802203 <syscall>
  8025e3:	83 c4 18             	add    $0x18,%esp
}
  8025e6:	c9                   	leave  
  8025e7:	c3                   	ret    

008025e8 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8025e8:	55                   	push   %ebp
  8025e9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8025eb:	6a 00                	push   $0x0
  8025ed:	6a 00                	push   $0x0
  8025ef:	6a 00                	push   $0x0
  8025f1:	6a 00                	push   $0x0
  8025f3:	6a 00                	push   $0x0
  8025f5:	6a 04                	push   $0x4
  8025f7:	e8 07 fc ff ff       	call   802203 <syscall>
  8025fc:	83 c4 18             	add    $0x18,%esp
}
  8025ff:	c9                   	leave  
  802600:	c3                   	ret    

00802601 <sys_exit_env>:


void sys_exit_env(void)
{
  802601:	55                   	push   %ebp
  802602:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802604:	6a 00                	push   $0x0
  802606:	6a 00                	push   $0x0
  802608:	6a 00                	push   $0x0
  80260a:	6a 00                	push   $0x0
  80260c:	6a 00                	push   $0x0
  80260e:	6a 23                	push   $0x23
  802610:	e8 ee fb ff ff       	call   802203 <syscall>
  802615:	83 c4 18             	add    $0x18,%esp
}
  802618:	90                   	nop
  802619:	c9                   	leave  
  80261a:	c3                   	ret    

0080261b <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80261b:	55                   	push   %ebp
  80261c:	89 e5                	mov    %esp,%ebp
  80261e:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802621:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802624:	8d 50 04             	lea    0x4(%eax),%edx
  802627:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80262a:	6a 00                	push   $0x0
  80262c:	6a 00                	push   $0x0
  80262e:	6a 00                	push   $0x0
  802630:	52                   	push   %edx
  802631:	50                   	push   %eax
  802632:	6a 24                	push   $0x24
  802634:	e8 ca fb ff ff       	call   802203 <syscall>
  802639:	83 c4 18             	add    $0x18,%esp
	return result;
  80263c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80263f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802642:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802645:	89 01                	mov    %eax,(%ecx)
  802647:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80264a:	8b 45 08             	mov    0x8(%ebp),%eax
  80264d:	c9                   	leave  
  80264e:	c2 04 00             	ret    $0x4

00802651 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802651:	55                   	push   %ebp
  802652:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802654:	6a 00                	push   $0x0
  802656:	6a 00                	push   $0x0
  802658:	ff 75 10             	pushl  0x10(%ebp)
  80265b:	ff 75 0c             	pushl  0xc(%ebp)
  80265e:	ff 75 08             	pushl  0x8(%ebp)
  802661:	6a 12                	push   $0x12
  802663:	e8 9b fb ff ff       	call   802203 <syscall>
  802668:	83 c4 18             	add    $0x18,%esp
	return ;
  80266b:	90                   	nop
}
  80266c:	c9                   	leave  
  80266d:	c3                   	ret    

0080266e <sys_rcr2>:
uint32 sys_rcr2()
{
  80266e:	55                   	push   %ebp
  80266f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802671:	6a 00                	push   $0x0
  802673:	6a 00                	push   $0x0
  802675:	6a 00                	push   $0x0
  802677:	6a 00                	push   $0x0
  802679:	6a 00                	push   $0x0
  80267b:	6a 25                	push   $0x25
  80267d:	e8 81 fb ff ff       	call   802203 <syscall>
  802682:	83 c4 18             	add    $0x18,%esp
}
  802685:	c9                   	leave  
  802686:	c3                   	ret    

00802687 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802687:	55                   	push   %ebp
  802688:	89 e5                	mov    %esp,%ebp
  80268a:	83 ec 04             	sub    $0x4,%esp
  80268d:	8b 45 08             	mov    0x8(%ebp),%eax
  802690:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802693:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802697:	6a 00                	push   $0x0
  802699:	6a 00                	push   $0x0
  80269b:	6a 00                	push   $0x0
  80269d:	6a 00                	push   $0x0
  80269f:	50                   	push   %eax
  8026a0:	6a 26                	push   $0x26
  8026a2:	e8 5c fb ff ff       	call   802203 <syscall>
  8026a7:	83 c4 18             	add    $0x18,%esp
	return ;
  8026aa:	90                   	nop
}
  8026ab:	c9                   	leave  
  8026ac:	c3                   	ret    

008026ad <rsttst>:
void rsttst()
{
  8026ad:	55                   	push   %ebp
  8026ae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8026b0:	6a 00                	push   $0x0
  8026b2:	6a 00                	push   $0x0
  8026b4:	6a 00                	push   $0x0
  8026b6:	6a 00                	push   $0x0
  8026b8:	6a 00                	push   $0x0
  8026ba:	6a 28                	push   $0x28
  8026bc:	e8 42 fb ff ff       	call   802203 <syscall>
  8026c1:	83 c4 18             	add    $0x18,%esp
	return ;
  8026c4:	90                   	nop
}
  8026c5:	c9                   	leave  
  8026c6:	c3                   	ret    

008026c7 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8026c7:	55                   	push   %ebp
  8026c8:	89 e5                	mov    %esp,%ebp
  8026ca:	83 ec 04             	sub    $0x4,%esp
  8026cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8026d0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8026d3:	8b 55 18             	mov    0x18(%ebp),%edx
  8026d6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8026da:	52                   	push   %edx
  8026db:	50                   	push   %eax
  8026dc:	ff 75 10             	pushl  0x10(%ebp)
  8026df:	ff 75 0c             	pushl  0xc(%ebp)
  8026e2:	ff 75 08             	pushl  0x8(%ebp)
  8026e5:	6a 27                	push   $0x27
  8026e7:	e8 17 fb ff ff       	call   802203 <syscall>
  8026ec:	83 c4 18             	add    $0x18,%esp
	return ;
  8026ef:	90                   	nop
}
  8026f0:	c9                   	leave  
  8026f1:	c3                   	ret    

008026f2 <chktst>:
void chktst(uint32 n)
{
  8026f2:	55                   	push   %ebp
  8026f3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8026f5:	6a 00                	push   $0x0
  8026f7:	6a 00                	push   $0x0
  8026f9:	6a 00                	push   $0x0
  8026fb:	6a 00                	push   $0x0
  8026fd:	ff 75 08             	pushl  0x8(%ebp)
  802700:	6a 29                	push   $0x29
  802702:	e8 fc fa ff ff       	call   802203 <syscall>
  802707:	83 c4 18             	add    $0x18,%esp
	return ;
  80270a:	90                   	nop
}
  80270b:	c9                   	leave  
  80270c:	c3                   	ret    

0080270d <inctst>:

void inctst()
{
  80270d:	55                   	push   %ebp
  80270e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802710:	6a 00                	push   $0x0
  802712:	6a 00                	push   $0x0
  802714:	6a 00                	push   $0x0
  802716:	6a 00                	push   $0x0
  802718:	6a 00                	push   $0x0
  80271a:	6a 2a                	push   $0x2a
  80271c:	e8 e2 fa ff ff       	call   802203 <syscall>
  802721:	83 c4 18             	add    $0x18,%esp
	return ;
  802724:	90                   	nop
}
  802725:	c9                   	leave  
  802726:	c3                   	ret    

00802727 <gettst>:
uint32 gettst()
{
  802727:	55                   	push   %ebp
  802728:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80272a:	6a 00                	push   $0x0
  80272c:	6a 00                	push   $0x0
  80272e:	6a 00                	push   $0x0
  802730:	6a 00                	push   $0x0
  802732:	6a 00                	push   $0x0
  802734:	6a 2b                	push   $0x2b
  802736:	e8 c8 fa ff ff       	call   802203 <syscall>
  80273b:	83 c4 18             	add    $0x18,%esp
}
  80273e:	c9                   	leave  
  80273f:	c3                   	ret    

00802740 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802740:	55                   	push   %ebp
  802741:	89 e5                	mov    %esp,%ebp
  802743:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802746:	6a 00                	push   $0x0
  802748:	6a 00                	push   $0x0
  80274a:	6a 00                	push   $0x0
  80274c:	6a 00                	push   $0x0
  80274e:	6a 00                	push   $0x0
  802750:	6a 2c                	push   $0x2c
  802752:	e8 ac fa ff ff       	call   802203 <syscall>
  802757:	83 c4 18             	add    $0x18,%esp
  80275a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80275d:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802761:	75 07                	jne    80276a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802763:	b8 01 00 00 00       	mov    $0x1,%eax
  802768:	eb 05                	jmp    80276f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80276a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80276f:	c9                   	leave  
  802770:	c3                   	ret    

00802771 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802771:	55                   	push   %ebp
  802772:	89 e5                	mov    %esp,%ebp
  802774:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802777:	6a 00                	push   $0x0
  802779:	6a 00                	push   $0x0
  80277b:	6a 00                	push   $0x0
  80277d:	6a 00                	push   $0x0
  80277f:	6a 00                	push   $0x0
  802781:	6a 2c                	push   $0x2c
  802783:	e8 7b fa ff ff       	call   802203 <syscall>
  802788:	83 c4 18             	add    $0x18,%esp
  80278b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80278e:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802792:	75 07                	jne    80279b <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802794:	b8 01 00 00 00       	mov    $0x1,%eax
  802799:	eb 05                	jmp    8027a0 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80279b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027a0:	c9                   	leave  
  8027a1:	c3                   	ret    

008027a2 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8027a2:	55                   	push   %ebp
  8027a3:	89 e5                	mov    %esp,%ebp
  8027a5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8027a8:	6a 00                	push   $0x0
  8027aa:	6a 00                	push   $0x0
  8027ac:	6a 00                	push   $0x0
  8027ae:	6a 00                	push   $0x0
  8027b0:	6a 00                	push   $0x0
  8027b2:	6a 2c                	push   $0x2c
  8027b4:	e8 4a fa ff ff       	call   802203 <syscall>
  8027b9:	83 c4 18             	add    $0x18,%esp
  8027bc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8027bf:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8027c3:	75 07                	jne    8027cc <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8027c5:	b8 01 00 00 00       	mov    $0x1,%eax
  8027ca:	eb 05                	jmp    8027d1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8027cc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027d1:	c9                   	leave  
  8027d2:	c3                   	ret    

008027d3 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8027d3:	55                   	push   %ebp
  8027d4:	89 e5                	mov    %esp,%ebp
  8027d6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8027d9:	6a 00                	push   $0x0
  8027db:	6a 00                	push   $0x0
  8027dd:	6a 00                	push   $0x0
  8027df:	6a 00                	push   $0x0
  8027e1:	6a 00                	push   $0x0
  8027e3:	6a 2c                	push   $0x2c
  8027e5:	e8 19 fa ff ff       	call   802203 <syscall>
  8027ea:	83 c4 18             	add    $0x18,%esp
  8027ed:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8027f0:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8027f4:	75 07                	jne    8027fd <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8027f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8027fb:	eb 05                	jmp    802802 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8027fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802802:	c9                   	leave  
  802803:	c3                   	ret    

00802804 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802804:	55                   	push   %ebp
  802805:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802807:	6a 00                	push   $0x0
  802809:	6a 00                	push   $0x0
  80280b:	6a 00                	push   $0x0
  80280d:	6a 00                	push   $0x0
  80280f:	ff 75 08             	pushl  0x8(%ebp)
  802812:	6a 2d                	push   $0x2d
  802814:	e8 ea f9 ff ff       	call   802203 <syscall>
  802819:	83 c4 18             	add    $0x18,%esp
	return ;
  80281c:	90                   	nop
}
  80281d:	c9                   	leave  
  80281e:	c3                   	ret    

0080281f <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80281f:	55                   	push   %ebp
  802820:	89 e5                	mov    %esp,%ebp
  802822:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802823:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802826:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802829:	8b 55 0c             	mov    0xc(%ebp),%edx
  80282c:	8b 45 08             	mov    0x8(%ebp),%eax
  80282f:	6a 00                	push   $0x0
  802831:	53                   	push   %ebx
  802832:	51                   	push   %ecx
  802833:	52                   	push   %edx
  802834:	50                   	push   %eax
  802835:	6a 2e                	push   $0x2e
  802837:	e8 c7 f9 ff ff       	call   802203 <syscall>
  80283c:	83 c4 18             	add    $0x18,%esp
}
  80283f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802842:	c9                   	leave  
  802843:	c3                   	ret    

00802844 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802844:	55                   	push   %ebp
  802845:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802847:	8b 55 0c             	mov    0xc(%ebp),%edx
  80284a:	8b 45 08             	mov    0x8(%ebp),%eax
  80284d:	6a 00                	push   $0x0
  80284f:	6a 00                	push   $0x0
  802851:	6a 00                	push   $0x0
  802853:	52                   	push   %edx
  802854:	50                   	push   %eax
  802855:	6a 2f                	push   $0x2f
  802857:	e8 a7 f9 ff ff       	call   802203 <syscall>
  80285c:	83 c4 18             	add    $0x18,%esp
}
  80285f:	c9                   	leave  
  802860:	c3                   	ret    

00802861 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802861:	55                   	push   %ebp
  802862:	89 e5                	mov    %esp,%ebp
  802864:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802867:	83 ec 0c             	sub    $0xc,%esp
  80286a:	68 9c 47 80 00       	push   $0x80479c
  80286f:	e8 c7 e6 ff ff       	call   800f3b <cprintf>
  802874:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802877:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  80287e:	83 ec 0c             	sub    $0xc,%esp
  802881:	68 c8 47 80 00       	push   $0x8047c8
  802886:	e8 b0 e6 ff ff       	call   800f3b <cprintf>
  80288b:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  80288e:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802892:	a1 38 51 80 00       	mov    0x805138,%eax
  802897:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80289a:	eb 56                	jmp    8028f2 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80289c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028a0:	74 1c                	je     8028be <print_mem_block_lists+0x5d>
  8028a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a5:	8b 50 08             	mov    0x8(%eax),%edx
  8028a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ab:	8b 48 08             	mov    0x8(%eax),%ecx
  8028ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b1:	8b 40 0c             	mov    0xc(%eax),%eax
  8028b4:	01 c8                	add    %ecx,%eax
  8028b6:	39 c2                	cmp    %eax,%edx
  8028b8:	73 04                	jae    8028be <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8028ba:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8028be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c1:	8b 50 08             	mov    0x8(%eax),%edx
  8028c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c7:	8b 40 0c             	mov    0xc(%eax),%eax
  8028ca:	01 c2                	add    %eax,%edx
  8028cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cf:	8b 40 08             	mov    0x8(%eax),%eax
  8028d2:	83 ec 04             	sub    $0x4,%esp
  8028d5:	52                   	push   %edx
  8028d6:	50                   	push   %eax
  8028d7:	68 dd 47 80 00       	push   $0x8047dd
  8028dc:	e8 5a e6 ff ff       	call   800f3b <cprintf>
  8028e1:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8028e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8028ea:	a1 40 51 80 00       	mov    0x805140,%eax
  8028ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028f6:	74 07                	je     8028ff <print_mem_block_lists+0x9e>
  8028f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fb:	8b 00                	mov    (%eax),%eax
  8028fd:	eb 05                	jmp    802904 <print_mem_block_lists+0xa3>
  8028ff:	b8 00 00 00 00       	mov    $0x0,%eax
  802904:	a3 40 51 80 00       	mov    %eax,0x805140
  802909:	a1 40 51 80 00       	mov    0x805140,%eax
  80290e:	85 c0                	test   %eax,%eax
  802910:	75 8a                	jne    80289c <print_mem_block_lists+0x3b>
  802912:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802916:	75 84                	jne    80289c <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802918:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80291c:	75 10                	jne    80292e <print_mem_block_lists+0xcd>
  80291e:	83 ec 0c             	sub    $0xc,%esp
  802921:	68 ec 47 80 00       	push   $0x8047ec
  802926:	e8 10 e6 ff ff       	call   800f3b <cprintf>
  80292b:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80292e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802935:	83 ec 0c             	sub    $0xc,%esp
  802938:	68 10 48 80 00       	push   $0x804810
  80293d:	e8 f9 e5 ff ff       	call   800f3b <cprintf>
  802942:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802945:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802949:	a1 40 50 80 00       	mov    0x805040,%eax
  80294e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802951:	eb 56                	jmp    8029a9 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802953:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802957:	74 1c                	je     802975 <print_mem_block_lists+0x114>
  802959:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295c:	8b 50 08             	mov    0x8(%eax),%edx
  80295f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802962:	8b 48 08             	mov    0x8(%eax),%ecx
  802965:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802968:	8b 40 0c             	mov    0xc(%eax),%eax
  80296b:	01 c8                	add    %ecx,%eax
  80296d:	39 c2                	cmp    %eax,%edx
  80296f:	73 04                	jae    802975 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802971:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802975:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802978:	8b 50 08             	mov    0x8(%eax),%edx
  80297b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297e:	8b 40 0c             	mov    0xc(%eax),%eax
  802981:	01 c2                	add    %eax,%edx
  802983:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802986:	8b 40 08             	mov    0x8(%eax),%eax
  802989:	83 ec 04             	sub    $0x4,%esp
  80298c:	52                   	push   %edx
  80298d:	50                   	push   %eax
  80298e:	68 dd 47 80 00       	push   $0x8047dd
  802993:	e8 a3 e5 ff ff       	call   800f3b <cprintf>
  802998:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80299b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8029a1:	a1 48 50 80 00       	mov    0x805048,%eax
  8029a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029ad:	74 07                	je     8029b6 <print_mem_block_lists+0x155>
  8029af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b2:	8b 00                	mov    (%eax),%eax
  8029b4:	eb 05                	jmp    8029bb <print_mem_block_lists+0x15a>
  8029b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8029bb:	a3 48 50 80 00       	mov    %eax,0x805048
  8029c0:	a1 48 50 80 00       	mov    0x805048,%eax
  8029c5:	85 c0                	test   %eax,%eax
  8029c7:	75 8a                	jne    802953 <print_mem_block_lists+0xf2>
  8029c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029cd:	75 84                	jne    802953 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8029cf:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8029d3:	75 10                	jne    8029e5 <print_mem_block_lists+0x184>
  8029d5:	83 ec 0c             	sub    $0xc,%esp
  8029d8:	68 28 48 80 00       	push   $0x804828
  8029dd:	e8 59 e5 ff ff       	call   800f3b <cprintf>
  8029e2:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8029e5:	83 ec 0c             	sub    $0xc,%esp
  8029e8:	68 9c 47 80 00       	push   $0x80479c
  8029ed:	e8 49 e5 ff ff       	call   800f3b <cprintf>
  8029f2:	83 c4 10             	add    $0x10,%esp

}
  8029f5:	90                   	nop
  8029f6:	c9                   	leave  
  8029f7:	c3                   	ret    

008029f8 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8029f8:	55                   	push   %ebp
  8029f9:	89 e5                	mov    %esp,%ebp
  8029fb:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);
  8029fe:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802a05:	00 00 00 
  802a08:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802a0f:	00 00 00 
  802a12:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802a19:	00 00 00 

		struct MemBlock *tmp=MemBlockNodes;
  802a1c:	a1 50 50 80 00       	mov    0x805050,%eax
  802a21:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (int i=0;i<numOfBlocks;i++)
  802a24:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802a2b:	e9 9e 00 00 00       	jmp    802ace <initialize_MemBlocksList+0xd6>
		{

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  802a30:	a1 50 50 80 00       	mov    0x805050,%eax
  802a35:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a38:	c1 e2 04             	shl    $0x4,%edx
  802a3b:	01 d0                	add    %edx,%eax
  802a3d:	85 c0                	test   %eax,%eax
  802a3f:	75 14                	jne    802a55 <initialize_MemBlocksList+0x5d>
  802a41:	83 ec 04             	sub    $0x4,%esp
  802a44:	68 50 48 80 00       	push   $0x804850
  802a49:	6a 48                	push   $0x48
  802a4b:	68 73 48 80 00       	push   $0x804873
  802a50:	e8 32 e2 ff ff       	call   800c87 <_panic>
  802a55:	a1 50 50 80 00       	mov    0x805050,%eax
  802a5a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a5d:	c1 e2 04             	shl    $0x4,%edx
  802a60:	01 d0                	add    %edx,%eax
  802a62:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802a68:	89 10                	mov    %edx,(%eax)
  802a6a:	8b 00                	mov    (%eax),%eax
  802a6c:	85 c0                	test   %eax,%eax
  802a6e:	74 18                	je     802a88 <initialize_MemBlocksList+0x90>
  802a70:	a1 48 51 80 00       	mov    0x805148,%eax
  802a75:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802a7b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802a7e:	c1 e1 04             	shl    $0x4,%ecx
  802a81:	01 ca                	add    %ecx,%edx
  802a83:	89 50 04             	mov    %edx,0x4(%eax)
  802a86:	eb 12                	jmp    802a9a <initialize_MemBlocksList+0xa2>
  802a88:	a1 50 50 80 00       	mov    0x805050,%eax
  802a8d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a90:	c1 e2 04             	shl    $0x4,%edx
  802a93:	01 d0                	add    %edx,%eax
  802a95:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a9a:	a1 50 50 80 00       	mov    0x805050,%eax
  802a9f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802aa2:	c1 e2 04             	shl    $0x4,%edx
  802aa5:	01 d0                	add    %edx,%eax
  802aa7:	a3 48 51 80 00       	mov    %eax,0x805148
  802aac:	a1 50 50 80 00       	mov    0x805050,%eax
  802ab1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ab4:	c1 e2 04             	shl    $0x4,%edx
  802ab7:	01 d0                	add    %edx,%eax
  802ab9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ac0:	a1 54 51 80 00       	mov    0x805154,%eax
  802ac5:	40                   	inc    %eax
  802ac6:	a3 54 51 80 00       	mov    %eax,0x805154
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);

		struct MemBlock *tmp=MemBlockNodes;
		for (int i=0;i<numOfBlocks;i++)
  802acb:	ff 45 f4             	incl   -0xc(%ebp)
  802ace:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad1:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ad4:	0f 82 56 ff ff ff    	jb     802a30 <initialize_MemBlocksList+0x38>

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
		}


}
  802ada:	90                   	nop
  802adb:	c9                   	leave  
  802adc:	c3                   	ret    

00802add <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802add:	55                   	push   %ebp
  802ade:	89 e5                	mov    %esp,%ebp
  802ae0:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;
  802ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae6:	8b 00                	mov    (%eax),%eax
  802ae8:	89 45 fc             	mov    %eax,-0x4(%ebp)

	while(tmp!=NULL)
  802aeb:	eb 18                	jmp    802b05 <find_block+0x28>
		{
			if(tmp->sva==va)
  802aed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802af0:	8b 40 08             	mov    0x8(%eax),%eax
  802af3:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802af6:	75 05                	jne    802afd <find_block+0x20>
			{
				return tmp;
  802af8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802afb:	eb 11                	jmp    802b0e <find_block+0x31>

			}
		tmp=tmp->prev_next_info.le_next;
  802afd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802b00:	8b 00                	mov    (%eax),%eax
  802b02:	89 45 fc             	mov    %eax,-0x4(%ebp)
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;

	while(tmp!=NULL)
  802b05:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802b09:	75 e2                	jne    802aed <find_block+0x10>
				return tmp;

			}
		tmp=tmp->prev_next_info.le_next;
		}
		return tmp;
  802b0b:	8b 45 fc             	mov    -0x4(%ebp),%eax
//
//		}
//
//		}
//			return tmp;
}
  802b0e:	c9                   	leave  
  802b0f:	c3                   	ret    

00802b10 <insert_sorted_allocList>:
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================


void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802b10:	55                   	push   %ebp
  802b11:	89 e5                	mov    %esp,%ebp
  802b13:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code

	if(AllocMemBlocksList.lh_first==NULL)
  802b16:	a1 40 50 80 00       	mov    0x805040,%eax
  802b1b:	85 c0                	test   %eax,%eax
  802b1d:	0f 85 83 00 00 00    	jne    802ba6 <insert_sorted_allocList+0x96>
	{
		LIST_INIT(&AllocMemBlocksList);
  802b23:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  802b2a:	00 00 00 
  802b2d:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  802b34:	00 00 00 
  802b37:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  802b3e:	00 00 00 
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802b41:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b45:	75 14                	jne    802b5b <insert_sorted_allocList+0x4b>
  802b47:	83 ec 04             	sub    $0x4,%esp
  802b4a:	68 50 48 80 00       	push   $0x804850
  802b4f:	6a 7f                	push   $0x7f
  802b51:	68 73 48 80 00       	push   $0x804873
  802b56:	e8 2c e1 ff ff       	call   800c87 <_panic>
  802b5b:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802b61:	8b 45 08             	mov    0x8(%ebp),%eax
  802b64:	89 10                	mov    %edx,(%eax)
  802b66:	8b 45 08             	mov    0x8(%ebp),%eax
  802b69:	8b 00                	mov    (%eax),%eax
  802b6b:	85 c0                	test   %eax,%eax
  802b6d:	74 0d                	je     802b7c <insert_sorted_allocList+0x6c>
  802b6f:	a1 40 50 80 00       	mov    0x805040,%eax
  802b74:	8b 55 08             	mov    0x8(%ebp),%edx
  802b77:	89 50 04             	mov    %edx,0x4(%eax)
  802b7a:	eb 08                	jmp    802b84 <insert_sorted_allocList+0x74>
  802b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7f:	a3 44 50 80 00       	mov    %eax,0x805044
  802b84:	8b 45 08             	mov    0x8(%ebp),%eax
  802b87:	a3 40 50 80 00       	mov    %eax,0x805040
  802b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b96:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802b9b:	40                   	inc    %eax
  802b9c:	a3 4c 50 80 00       	mov    %eax,0x80504c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802ba1:	e9 16 01 00 00       	jmp    802cbc <insert_sorted_allocList+0x1ac>
		LIST_INIT(&AllocMemBlocksList);
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}


	else if(blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  802ba6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba9:	8b 50 08             	mov    0x8(%eax),%edx
  802bac:	a1 44 50 80 00       	mov    0x805044,%eax
  802bb1:	8b 40 08             	mov    0x8(%eax),%eax
  802bb4:	39 c2                	cmp    %eax,%edx
  802bb6:	76 68                	jbe    802c20 <insert_sorted_allocList+0x110>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
  802bb8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bbc:	75 17                	jne    802bd5 <insert_sorted_allocList+0xc5>
  802bbe:	83 ec 04             	sub    $0x4,%esp
  802bc1:	68 8c 48 80 00       	push   $0x80488c
  802bc6:	68 85 00 00 00       	push   $0x85
  802bcb:	68 73 48 80 00       	push   $0x804873
  802bd0:	e8 b2 e0 ff ff       	call   800c87 <_panic>
  802bd5:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bde:	89 50 04             	mov    %edx,0x4(%eax)
  802be1:	8b 45 08             	mov    0x8(%ebp),%eax
  802be4:	8b 40 04             	mov    0x4(%eax),%eax
  802be7:	85 c0                	test   %eax,%eax
  802be9:	74 0c                	je     802bf7 <insert_sorted_allocList+0xe7>
  802beb:	a1 44 50 80 00       	mov    0x805044,%eax
  802bf0:	8b 55 08             	mov    0x8(%ebp),%edx
  802bf3:	89 10                	mov    %edx,(%eax)
  802bf5:	eb 08                	jmp    802bff <insert_sorted_allocList+0xef>
  802bf7:	8b 45 08             	mov    0x8(%ebp),%eax
  802bfa:	a3 40 50 80 00       	mov    %eax,0x805040
  802bff:	8b 45 08             	mov    0x8(%ebp),%eax
  802c02:	a3 44 50 80 00       	mov    %eax,0x805044
  802c07:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c10:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802c15:	40                   	inc    %eax
  802c16:	a3 4c 50 80 00       	mov    %eax,0x80504c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802c1b:	e9 9c 00 00 00       	jmp    802cbc <insert_sorted_allocList+0x1ac>
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
  802c20:	a1 40 50 80 00       	mov    0x805040,%eax
  802c25:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  802c28:	e9 85 00 00 00       	jmp    802cb2 <insert_sorted_allocList+0x1a2>
		{
			if(blockToInsert->sva<tmp->sva)
  802c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c30:	8b 50 08             	mov    0x8(%eax),%edx
  802c33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c36:	8b 40 08             	mov    0x8(%eax),%eax
  802c39:	39 c2                	cmp    %eax,%edx
  802c3b:	73 6d                	jae    802caa <insert_sorted_allocList+0x19a>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
  802c3d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c41:	74 06                	je     802c49 <insert_sorted_allocList+0x139>
  802c43:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c47:	75 17                	jne    802c60 <insert_sorted_allocList+0x150>
  802c49:	83 ec 04             	sub    $0x4,%esp
  802c4c:	68 b0 48 80 00       	push   $0x8048b0
  802c51:	68 90 00 00 00       	push   $0x90
  802c56:	68 73 48 80 00       	push   $0x804873
  802c5b:	e8 27 e0 ff ff       	call   800c87 <_panic>
  802c60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c63:	8b 50 04             	mov    0x4(%eax),%edx
  802c66:	8b 45 08             	mov    0x8(%ebp),%eax
  802c69:	89 50 04             	mov    %edx,0x4(%eax)
  802c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c72:	89 10                	mov    %edx,(%eax)
  802c74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c77:	8b 40 04             	mov    0x4(%eax),%eax
  802c7a:	85 c0                	test   %eax,%eax
  802c7c:	74 0d                	je     802c8b <insert_sorted_allocList+0x17b>
  802c7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c81:	8b 40 04             	mov    0x4(%eax),%eax
  802c84:	8b 55 08             	mov    0x8(%ebp),%edx
  802c87:	89 10                	mov    %edx,(%eax)
  802c89:	eb 08                	jmp    802c93 <insert_sorted_allocList+0x183>
  802c8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8e:	a3 40 50 80 00       	mov    %eax,0x805040
  802c93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c96:	8b 55 08             	mov    0x8(%ebp),%edx
  802c99:	89 50 04             	mov    %edx,0x4(%eax)
  802c9c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802ca1:	40                   	inc    %eax
  802ca2:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802ca7:	90                   	nop
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802ca8:	eb 12                	jmp    802cbc <insert_sorted_allocList+0x1ac>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
				break;
			}
			tmp=tmp->prev_next_info.le_next;
  802caa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cad:	8b 00                	mov    (%eax),%eax
  802caf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
		while(tmp!=NULL)
  802cb2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cb6:	0f 85 71 ff ff ff    	jne    802c2d <insert_sorted_allocList+0x11d>
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802cbc:	90                   	nop
  802cbd:	c9                   	leave  
  802cbe:	c3                   	ret    

00802cbf <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

struct MemBlock *alloc_block_FF(uint32 size)
{
  802cbf:	55                   	push   %ebp
  802cc0:	89 e5                	mov    %esp,%ebp
  802cc2:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  802cc5:	a1 38 51 80 00       	mov    0x805138,%eax
  802cca:	89 45 f4             	mov    %eax,-0xc(%ebp)

	while(tmp!=NULL)
  802ccd:	e9 76 01 00 00       	jmp    802e48 <alloc_block_FF+0x189>
	{
		if(size==(tmp->size))
  802cd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd5:	8b 40 0c             	mov    0xc(%eax),%eax
  802cd8:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cdb:	0f 85 8a 00 00 00    	jne    802d6b <alloc_block_FF+0xac>
		{

			LIST_REMOVE(&FreeMemBlocksList,tmp);
  802ce1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ce5:	75 17                	jne    802cfe <alloc_block_FF+0x3f>
  802ce7:	83 ec 04             	sub    $0x4,%esp
  802cea:	68 e5 48 80 00       	push   $0x8048e5
  802cef:	68 a8 00 00 00       	push   $0xa8
  802cf4:	68 73 48 80 00       	push   $0x804873
  802cf9:	e8 89 df ff ff       	call   800c87 <_panic>
  802cfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d01:	8b 00                	mov    (%eax),%eax
  802d03:	85 c0                	test   %eax,%eax
  802d05:	74 10                	je     802d17 <alloc_block_FF+0x58>
  802d07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0a:	8b 00                	mov    (%eax),%eax
  802d0c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d0f:	8b 52 04             	mov    0x4(%edx),%edx
  802d12:	89 50 04             	mov    %edx,0x4(%eax)
  802d15:	eb 0b                	jmp    802d22 <alloc_block_FF+0x63>
  802d17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1a:	8b 40 04             	mov    0x4(%eax),%eax
  802d1d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d25:	8b 40 04             	mov    0x4(%eax),%eax
  802d28:	85 c0                	test   %eax,%eax
  802d2a:	74 0f                	je     802d3b <alloc_block_FF+0x7c>
  802d2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2f:	8b 40 04             	mov    0x4(%eax),%eax
  802d32:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d35:	8b 12                	mov    (%edx),%edx
  802d37:	89 10                	mov    %edx,(%eax)
  802d39:	eb 0a                	jmp    802d45 <alloc_block_FF+0x86>
  802d3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3e:	8b 00                	mov    (%eax),%eax
  802d40:	a3 38 51 80 00       	mov    %eax,0x805138
  802d45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d48:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d51:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d58:	a1 44 51 80 00       	mov    0x805144,%eax
  802d5d:	48                   	dec    %eax
  802d5e:	a3 44 51 80 00       	mov    %eax,0x805144

			return tmp;
  802d63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d66:	e9 ea 00 00 00       	jmp    802e55 <alloc_block_FF+0x196>

		}
		else if(size<tmp->size)
  802d6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6e:	8b 40 0c             	mov    0xc(%eax),%eax
  802d71:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d74:	0f 86 c6 00 00 00    	jbe    802e40 <alloc_block_FF+0x181>
		{

			 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802d7a:	a1 48 51 80 00       	mov    0x805148,%eax
  802d7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 newBlock->size=size;
  802d82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d85:	8b 55 08             	mov    0x8(%ebp),%edx
  802d88:	89 50 0c             	mov    %edx,0xc(%eax)
			 newBlock->sva=tmp->sva;
  802d8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8e:	8b 50 08             	mov    0x8(%eax),%edx
  802d91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d94:	89 50 08             	mov    %edx,0x8(%eax)
			 tmp->size=tmp->size-size;
  802d97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9a:	8b 40 0c             	mov    0xc(%eax),%eax
  802d9d:	2b 45 08             	sub    0x8(%ebp),%eax
  802da0:	89 c2                	mov    %eax,%edx
  802da2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da5:	89 50 0c             	mov    %edx,0xc(%eax)
			 tmp->sva=tmp->sva+size;
  802da8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dab:	8b 50 08             	mov    0x8(%eax),%edx
  802dae:	8b 45 08             	mov    0x8(%ebp),%eax
  802db1:	01 c2                	add    %eax,%edx
  802db3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db6:	89 50 08             	mov    %edx,0x8(%eax)

			 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802db9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802dbd:	75 17                	jne    802dd6 <alloc_block_FF+0x117>
  802dbf:	83 ec 04             	sub    $0x4,%esp
  802dc2:	68 e5 48 80 00       	push   $0x8048e5
  802dc7:	68 b6 00 00 00       	push   $0xb6
  802dcc:	68 73 48 80 00       	push   $0x804873
  802dd1:	e8 b1 de ff ff       	call   800c87 <_panic>
  802dd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dd9:	8b 00                	mov    (%eax),%eax
  802ddb:	85 c0                	test   %eax,%eax
  802ddd:	74 10                	je     802def <alloc_block_FF+0x130>
  802ddf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de2:	8b 00                	mov    (%eax),%eax
  802de4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802de7:	8b 52 04             	mov    0x4(%edx),%edx
  802dea:	89 50 04             	mov    %edx,0x4(%eax)
  802ded:	eb 0b                	jmp    802dfa <alloc_block_FF+0x13b>
  802def:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df2:	8b 40 04             	mov    0x4(%eax),%eax
  802df5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802dfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dfd:	8b 40 04             	mov    0x4(%eax),%eax
  802e00:	85 c0                	test   %eax,%eax
  802e02:	74 0f                	je     802e13 <alloc_block_FF+0x154>
  802e04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e07:	8b 40 04             	mov    0x4(%eax),%eax
  802e0a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e0d:	8b 12                	mov    (%edx),%edx
  802e0f:	89 10                	mov    %edx,(%eax)
  802e11:	eb 0a                	jmp    802e1d <alloc_block_FF+0x15e>
  802e13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e16:	8b 00                	mov    (%eax),%eax
  802e18:	a3 48 51 80 00       	mov    %eax,0x805148
  802e1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e20:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e29:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e30:	a1 54 51 80 00       	mov    0x805154,%eax
  802e35:	48                   	dec    %eax
  802e36:	a3 54 51 80 00       	mov    %eax,0x805154
			 return newBlock;
  802e3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e3e:	eb 15                	jmp    802e55 <alloc_block_FF+0x196>

		}
		tmp=tmp->prev_next_info.le_next;
  802e40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e43:	8b 00                	mov    (%eax),%eax
  802e45:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;

	while(tmp!=NULL)
  802e48:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e4c:	0f 85 80 fe ff ff    	jne    802cd2 <alloc_block_FF+0x13>
			 return newBlock;

		}
		tmp=tmp->prev_next_info.le_next;
	}
	return tmp;
  802e52:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802e55:	c9                   	leave  
  802e56:	c3                   	ret    

00802e57 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802e57:	55                   	push   %ebp
  802e58:	89 e5                	mov    %esp,%ebp
  802e5a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  802e5d:	a1 38 51 80 00       	mov    0x805138,%eax
  802e62:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 newSize=UINT_MAX;
  802e65:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)


		while(tmp!=NULL)
  802e6c:	e9 c0 00 00 00       	jmp    802f31 <alloc_block_BF+0xda>
		{
			if(size==(tmp->size))
  802e71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e74:	8b 40 0c             	mov    0xc(%eax),%eax
  802e77:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e7a:	0f 85 8a 00 00 00    	jne    802f0a <alloc_block_BF+0xb3>
			{
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  802e80:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e84:	75 17                	jne    802e9d <alloc_block_BF+0x46>
  802e86:	83 ec 04             	sub    $0x4,%esp
  802e89:	68 e5 48 80 00       	push   $0x8048e5
  802e8e:	68 cf 00 00 00       	push   $0xcf
  802e93:	68 73 48 80 00       	push   $0x804873
  802e98:	e8 ea dd ff ff       	call   800c87 <_panic>
  802e9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea0:	8b 00                	mov    (%eax),%eax
  802ea2:	85 c0                	test   %eax,%eax
  802ea4:	74 10                	je     802eb6 <alloc_block_BF+0x5f>
  802ea6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea9:	8b 00                	mov    (%eax),%eax
  802eab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802eae:	8b 52 04             	mov    0x4(%edx),%edx
  802eb1:	89 50 04             	mov    %edx,0x4(%eax)
  802eb4:	eb 0b                	jmp    802ec1 <alloc_block_BF+0x6a>
  802eb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb9:	8b 40 04             	mov    0x4(%eax),%eax
  802ebc:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ec1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec4:	8b 40 04             	mov    0x4(%eax),%eax
  802ec7:	85 c0                	test   %eax,%eax
  802ec9:	74 0f                	je     802eda <alloc_block_BF+0x83>
  802ecb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ece:	8b 40 04             	mov    0x4(%eax),%eax
  802ed1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ed4:	8b 12                	mov    (%edx),%edx
  802ed6:	89 10                	mov    %edx,(%eax)
  802ed8:	eb 0a                	jmp    802ee4 <alloc_block_BF+0x8d>
  802eda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802edd:	8b 00                	mov    (%eax),%eax
  802edf:	a3 38 51 80 00       	mov    %eax,0x805138
  802ee4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802eed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ef7:	a1 44 51 80 00       	mov    0x805144,%eax
  802efc:	48                   	dec    %eax
  802efd:	a3 44 51 80 00       	mov    %eax,0x805144
				return tmp;
  802f02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f05:	e9 2a 01 00 00       	jmp    803034 <alloc_block_BF+0x1dd>

			}
			else if (tmp->size<newSize&&tmp->size>size)
  802f0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0d:	8b 40 0c             	mov    0xc(%eax),%eax
  802f10:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802f13:	73 14                	jae    802f29 <alloc_block_BF+0xd2>
  802f15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f18:	8b 40 0c             	mov    0xc(%eax),%eax
  802f1b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f1e:	76 09                	jbe    802f29 <alloc_block_BF+0xd2>
			{
				newSize=tmp->size;
  802f20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f23:	8b 40 0c             	mov    0xc(%eax),%eax
  802f26:	89 45 f0             	mov    %eax,-0x10(%ebp)


			}
			tmp=tmp->prev_next_info.le_next;
  802f29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2c:	8b 00                	mov    (%eax),%eax
  802f2e:	89 45 f4             	mov    %eax,-0xc(%ebp)

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
	uint32 newSize=UINT_MAX;


		while(tmp!=NULL)
  802f31:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f35:	0f 85 36 ff ff ff    	jne    802e71 <alloc_block_BF+0x1a>
		}//tmp=NULL




			tmp =FreeMemBlocksList.lh_first;
  802f3b:	a1 38 51 80 00       	mov    0x805138,%eax
  802f40:	89 45 f4             	mov    %eax,-0xc(%ebp)
			while(tmp!=NULL)
  802f43:	e9 dd 00 00 00       	jmp    803025 <alloc_block_BF+0x1ce>
			{
				if(tmp->size==newSize)
  802f48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4b:	8b 40 0c             	mov    0xc(%eax),%eax
  802f4e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802f51:	0f 85 c6 00 00 00    	jne    80301d <alloc_block_BF+0x1c6>
					{
					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802f57:	a1 48 51 80 00       	mov    0x805148,%eax
  802f5c:	89 45 ec             	mov    %eax,-0x14(%ebp)

								 newBlock->sva=tmp->sva;     //newBlock.sva=tmp.sva
  802f5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f62:	8b 50 08             	mov    0x8(%eax),%edx
  802f65:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f68:	89 50 08             	mov    %edx,0x8(%eax)
								 newBlock->size=size;
  802f6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f6e:	8b 55 08             	mov    0x8(%ebp),%edx
  802f71:	89 50 0c             	mov    %edx,0xc(%eax)

											 tmp->sva+=size;
  802f74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f77:	8b 50 08             	mov    0x8(%eax),%edx
  802f7a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7d:	01 c2                	add    %eax,%edx
  802f7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f82:	89 50 08             	mov    %edx,0x8(%eax)
											 tmp->size-=size;
  802f85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f88:	8b 40 0c             	mov    0xc(%eax),%eax
  802f8b:	2b 45 08             	sub    0x8(%ebp),%eax
  802f8e:	89 c2                	mov    %eax,%edx
  802f90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f93:	89 50 0c             	mov    %edx,0xc(%eax)
											 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802f96:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802f9a:	75 17                	jne    802fb3 <alloc_block_BF+0x15c>
  802f9c:	83 ec 04             	sub    $0x4,%esp
  802f9f:	68 e5 48 80 00       	push   $0x8048e5
  802fa4:	68 eb 00 00 00       	push   $0xeb
  802fa9:	68 73 48 80 00       	push   $0x804873
  802fae:	e8 d4 dc ff ff       	call   800c87 <_panic>
  802fb3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fb6:	8b 00                	mov    (%eax),%eax
  802fb8:	85 c0                	test   %eax,%eax
  802fba:	74 10                	je     802fcc <alloc_block_BF+0x175>
  802fbc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fbf:	8b 00                	mov    (%eax),%eax
  802fc1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802fc4:	8b 52 04             	mov    0x4(%edx),%edx
  802fc7:	89 50 04             	mov    %edx,0x4(%eax)
  802fca:	eb 0b                	jmp    802fd7 <alloc_block_BF+0x180>
  802fcc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fcf:	8b 40 04             	mov    0x4(%eax),%eax
  802fd2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802fd7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fda:	8b 40 04             	mov    0x4(%eax),%eax
  802fdd:	85 c0                	test   %eax,%eax
  802fdf:	74 0f                	je     802ff0 <alloc_block_BF+0x199>
  802fe1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fe4:	8b 40 04             	mov    0x4(%eax),%eax
  802fe7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802fea:	8b 12                	mov    (%edx),%edx
  802fec:	89 10                	mov    %edx,(%eax)
  802fee:	eb 0a                	jmp    802ffa <alloc_block_BF+0x1a3>
  802ff0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ff3:	8b 00                	mov    (%eax),%eax
  802ff5:	a3 48 51 80 00       	mov    %eax,0x805148
  802ffa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ffd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803003:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803006:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80300d:	a1 54 51 80 00       	mov    0x805154,%eax
  803012:	48                   	dec    %eax
  803013:	a3 54 51 80 00       	mov    %eax,0x805154
											 return newBlock;
  803018:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80301b:	eb 17                	jmp    803034 <alloc_block_BF+0x1dd>

					}
				tmp=tmp->prev_next_info.le_next;
  80301d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803020:	8b 00                	mov    (%eax),%eax
  803022:	89 45 f4             	mov    %eax,-0xc(%ebp)




			tmp =FreeMemBlocksList.lh_first;
			while(tmp!=NULL)
  803025:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803029:	0f 85 19 ff ff ff    	jne    802f48 <alloc_block_BF+0xf1>
			//tmp ->  block newSize,Sva




		return NULL; //return NULL
  80302f:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  803034:	c9                   	leave  
  803035:	c3                   	ret    

00803036 <alloc_block_NF>:
//=========================================



struct MemBlock *alloc_block_NF(uint32 size)
{
  803036:	55                   	push   %ebp
  803037:	89 e5                	mov    %esp,%ebp
  803039:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp1;
	uint32 currentSva;
	if(AllocMemBlocksList.lh_first==NULL)
  80303c:	a1 40 50 80 00       	mov    0x805040,%eax
  803041:	85 c0                	test   %eax,%eax
  803043:	75 19                	jne    80305e <alloc_block_NF+0x28>
	{
		tmp1=alloc_block_FF(size);
  803045:	83 ec 0c             	sub    $0xc,%esp
  803048:	ff 75 08             	pushl  0x8(%ebp)
  80304b:	e8 6f fc ff ff       	call   802cbf <alloc_block_FF>
  803050:	83 c4 10             	add    $0x10,%esp
  803053:	89 45 f4             	mov    %eax,-0xc(%ebp)
		return tmp1;
  803056:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803059:	e9 e9 01 00 00       	jmp    803247 <alloc_block_NF+0x211>
	}

			else
			{
            currentSva=AllocMemBlocksList.lh_last->sva;
  80305e:	a1 44 50 80 00       	mov    0x805044,%eax
  803063:	8b 40 08             	mov    0x8(%eax),%eax
  803066:	89 45 f0             	mov    %eax,-0x10(%ebp)
			tmp1=find_block(&FreeMemBlocksList,AllocMemBlocksList.lh_last->size+AllocMemBlocksList.lh_last->sva);
  803069:	a1 44 50 80 00       	mov    0x805044,%eax
  80306e:	8b 50 0c             	mov    0xc(%eax),%edx
  803071:	a1 44 50 80 00       	mov    0x805044,%eax
  803076:	8b 40 08             	mov    0x8(%eax),%eax
  803079:	01 d0                	add    %edx,%eax
  80307b:	83 ec 08             	sub    $0x8,%esp
  80307e:	50                   	push   %eax
  80307f:	68 38 51 80 00       	push   $0x805138
  803084:	e8 54 fa ff ff       	call   802add <find_block>
  803089:	83 c4 10             	add    $0x10,%esp
  80308c:	89 45 f4             	mov    %eax,-0xc(%ebp)


do
	{

		if(size==(tmp1->size))
  80308f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803092:	8b 40 0c             	mov    0xc(%eax),%eax
  803095:	3b 45 08             	cmp    0x8(%ebp),%eax
  803098:	0f 85 9b 00 00 00    	jne    803139 <alloc_block_NF+0x103>
				{
			currentSva=tmp1->size+tmp1->sva;
  80309e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a1:	8b 50 0c             	mov    0xc(%eax),%edx
  8030a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a7:	8b 40 08             	mov    0x8(%eax),%eax
  8030aa:	01 d0                	add    %edx,%eax
  8030ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,tmp1);
  8030af:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030b3:	75 17                	jne    8030cc <alloc_block_NF+0x96>
  8030b5:	83 ec 04             	sub    $0x4,%esp
  8030b8:	68 e5 48 80 00       	push   $0x8048e5
  8030bd:	68 1a 01 00 00       	push   $0x11a
  8030c2:	68 73 48 80 00       	push   $0x804873
  8030c7:	e8 bb db ff ff       	call   800c87 <_panic>
  8030cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030cf:	8b 00                	mov    (%eax),%eax
  8030d1:	85 c0                	test   %eax,%eax
  8030d3:	74 10                	je     8030e5 <alloc_block_NF+0xaf>
  8030d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d8:	8b 00                	mov    (%eax),%eax
  8030da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030dd:	8b 52 04             	mov    0x4(%edx),%edx
  8030e0:	89 50 04             	mov    %edx,0x4(%eax)
  8030e3:	eb 0b                	jmp    8030f0 <alloc_block_NF+0xba>
  8030e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e8:	8b 40 04             	mov    0x4(%eax),%eax
  8030eb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f3:	8b 40 04             	mov    0x4(%eax),%eax
  8030f6:	85 c0                	test   %eax,%eax
  8030f8:	74 0f                	je     803109 <alloc_block_NF+0xd3>
  8030fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030fd:	8b 40 04             	mov    0x4(%eax),%eax
  803100:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803103:	8b 12                	mov    (%edx),%edx
  803105:	89 10                	mov    %edx,(%eax)
  803107:	eb 0a                	jmp    803113 <alloc_block_NF+0xdd>
  803109:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80310c:	8b 00                	mov    (%eax),%eax
  80310e:	a3 38 51 80 00       	mov    %eax,0x805138
  803113:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803116:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80311c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80311f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803126:	a1 44 51 80 00       	mov    0x805144,%eax
  80312b:	48                   	dec    %eax
  80312c:	a3 44 51 80 00       	mov    %eax,0x805144
					return tmp1;
  803131:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803134:	e9 0e 01 00 00       	jmp    803247 <alloc_block_NF+0x211>

				}
				else if(size<tmp1->size)
  803139:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80313c:	8b 40 0c             	mov    0xc(%eax),%eax
  80313f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803142:	0f 86 cf 00 00 00    	jbe    803217 <alloc_block_NF+0x1e1>
				{

					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  803148:	a1 48 51 80 00       	mov    0x805148,%eax
  80314d:	89 45 ec             	mov    %eax,-0x14(%ebp)
					 newBlock->size=size;
  803150:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803153:	8b 55 08             	mov    0x8(%ebp),%edx
  803156:	89 50 0c             	mov    %edx,0xc(%eax)
					 newBlock->sva=tmp1->sva;
  803159:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80315c:	8b 50 08             	mov    0x8(%eax),%edx
  80315f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803162:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->sva+=size;
  803165:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803168:	8b 50 08             	mov    0x8(%eax),%edx
  80316b:	8b 45 08             	mov    0x8(%ebp),%eax
  80316e:	01 c2                	add    %eax,%edx
  803170:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803173:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->size-=size;
  803176:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803179:	8b 40 0c             	mov    0xc(%eax),%eax
  80317c:	2b 45 08             	sub    0x8(%ebp),%eax
  80317f:	89 c2                	mov    %eax,%edx
  803181:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803184:	89 50 0c             	mov    %edx,0xc(%eax)
                     currentSva=tmp1->sva;
  803187:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80318a:	8b 40 08             	mov    0x8(%eax),%eax
  80318d:	89 45 f0             	mov    %eax,-0x10(%ebp)

					 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  803190:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803194:	75 17                	jne    8031ad <alloc_block_NF+0x177>
  803196:	83 ec 04             	sub    $0x4,%esp
  803199:	68 e5 48 80 00       	push   $0x8048e5
  80319e:	68 28 01 00 00       	push   $0x128
  8031a3:	68 73 48 80 00       	push   $0x804873
  8031a8:	e8 da da ff ff       	call   800c87 <_panic>
  8031ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031b0:	8b 00                	mov    (%eax),%eax
  8031b2:	85 c0                	test   %eax,%eax
  8031b4:	74 10                	je     8031c6 <alloc_block_NF+0x190>
  8031b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031b9:	8b 00                	mov    (%eax),%eax
  8031bb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8031be:	8b 52 04             	mov    0x4(%edx),%edx
  8031c1:	89 50 04             	mov    %edx,0x4(%eax)
  8031c4:	eb 0b                	jmp    8031d1 <alloc_block_NF+0x19b>
  8031c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031c9:	8b 40 04             	mov    0x4(%eax),%eax
  8031cc:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031d4:	8b 40 04             	mov    0x4(%eax),%eax
  8031d7:	85 c0                	test   %eax,%eax
  8031d9:	74 0f                	je     8031ea <alloc_block_NF+0x1b4>
  8031db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031de:	8b 40 04             	mov    0x4(%eax),%eax
  8031e1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8031e4:	8b 12                	mov    (%edx),%edx
  8031e6:	89 10                	mov    %edx,(%eax)
  8031e8:	eb 0a                	jmp    8031f4 <alloc_block_NF+0x1be>
  8031ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031ed:	8b 00                	mov    (%eax),%eax
  8031ef:	a3 48 51 80 00       	mov    %eax,0x805148
  8031f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031f7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803200:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803207:	a1 54 51 80 00       	mov    0x805154,%eax
  80320c:	48                   	dec    %eax
  80320d:	a3 54 51 80 00       	mov    %eax,0x805154
					 return newBlock;
  803212:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803215:	eb 30                	jmp    803247 <alloc_block_NF+0x211>

				}
		if(tmp1==FreeMemBlocksList.lh_last)
  803217:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80321c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80321f:	75 0a                	jne    80322b <alloc_block_NF+0x1f5>
			tmp1=FreeMemBlocksList.lh_first;
  803221:	a1 38 51 80 00       	mov    0x805138,%eax
  803226:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803229:	eb 08                	jmp    803233 <alloc_block_NF+0x1fd>
		else
				tmp1=tmp1->prev_next_info.le_next;
  80322b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80322e:	8b 00                	mov    (%eax),%eax
  803230:	89 45 f4             	mov    %eax,-0xc(%ebp)


			}
while(tmp1->sva!=currentSva);
  803233:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803236:	8b 40 08             	mov    0x8(%eax),%eax
  803239:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80323c:	0f 85 4d fe ff ff    	jne    80308f <alloc_block_NF+0x59>

			return NULL;
  803242:	b8 00 00 00 00       	mov    $0x0,%eax

	}
  803247:	c9                   	leave  
  803248:	c3                   	ret    

00803249 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803249:	55                   	push   %ebp
  80324a:	89 e5                	mov    %esp,%ebp
  80324c:	53                   	push   %ebx
  80324d:	83 ec 14             	sub    $0x14,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	if(FreeMemBlocksList.lh_first==NULL)
  803250:	a1 38 51 80 00       	mov    0x805138,%eax
  803255:	85 c0                	test   %eax,%eax
  803257:	0f 85 86 00 00 00    	jne    8032e3 <insert_sorted_with_merge_freeList+0x9a>
	{
		LIST_INIT(&FreeMemBlocksList);
  80325d:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  803264:	00 00 00 
  803267:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  80326e:	00 00 00 
  803271:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  803278:	00 00 00 
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  80327b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80327f:	75 17                	jne    803298 <insert_sorted_with_merge_freeList+0x4f>
  803281:	83 ec 04             	sub    $0x4,%esp
  803284:	68 50 48 80 00       	push   $0x804850
  803289:	68 48 01 00 00       	push   $0x148
  80328e:	68 73 48 80 00       	push   $0x804873
  803293:	e8 ef d9 ff ff       	call   800c87 <_panic>
  803298:	8b 15 38 51 80 00    	mov    0x805138,%edx
  80329e:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a1:	89 10                	mov    %edx,(%eax)
  8032a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a6:	8b 00                	mov    (%eax),%eax
  8032a8:	85 c0                	test   %eax,%eax
  8032aa:	74 0d                	je     8032b9 <insert_sorted_with_merge_freeList+0x70>
  8032ac:	a1 38 51 80 00       	mov    0x805138,%eax
  8032b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8032b4:	89 50 04             	mov    %edx,0x4(%eax)
  8032b7:	eb 08                	jmp    8032c1 <insert_sorted_with_merge_freeList+0x78>
  8032b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032bc:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c4:	a3 38 51 80 00       	mov    %eax,0x805138
  8032c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032cc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032d3:	a1 44 51 80 00       	mov    0x805144,%eax
  8032d8:	40                   	inc    %eax
  8032d9:	a3 44 51 80 00       	mov    %eax,0x805144
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  8032de:	e9 73 07 00 00       	jmp    803a56 <insert_sorted_with_merge_freeList+0x80d>
	if(FreeMemBlocksList.lh_first==NULL)
	{
		LIST_INIT(&FreeMemBlocksList);
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva!=(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  8032e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e6:	8b 50 08             	mov    0x8(%eax),%edx
  8032e9:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8032ee:	8b 40 08             	mov    0x8(%eax),%eax
  8032f1:	39 c2                	cmp    %eax,%edx
  8032f3:	0f 86 84 00 00 00    	jbe    80337d <insert_sorted_with_merge_freeList+0x134>
  8032f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fc:	8b 50 08             	mov    0x8(%eax),%edx
  8032ff:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803304:	8b 48 0c             	mov    0xc(%eax),%ecx
  803307:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80330c:	8b 40 08             	mov    0x8(%eax),%eax
  80330f:	01 c8                	add    %ecx,%eax
  803311:	39 c2                	cmp    %eax,%edx
  803313:	74 68                	je     80337d <insert_sorted_with_merge_freeList+0x134>
	{
		LIST_INSERT_TAIL(&FreeMemBlocksList,blockToInsert);
  803315:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803319:	75 17                	jne    803332 <insert_sorted_with_merge_freeList+0xe9>
  80331b:	83 ec 04             	sub    $0x4,%esp
  80331e:	68 8c 48 80 00       	push   $0x80488c
  803323:	68 4c 01 00 00       	push   $0x14c
  803328:	68 73 48 80 00       	push   $0x804873
  80332d:	e8 55 d9 ff ff       	call   800c87 <_panic>
  803332:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803338:	8b 45 08             	mov    0x8(%ebp),%eax
  80333b:	89 50 04             	mov    %edx,0x4(%eax)
  80333e:	8b 45 08             	mov    0x8(%ebp),%eax
  803341:	8b 40 04             	mov    0x4(%eax),%eax
  803344:	85 c0                	test   %eax,%eax
  803346:	74 0c                	je     803354 <insert_sorted_with_merge_freeList+0x10b>
  803348:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80334d:	8b 55 08             	mov    0x8(%ebp),%edx
  803350:	89 10                	mov    %edx,(%eax)
  803352:	eb 08                	jmp    80335c <insert_sorted_with_merge_freeList+0x113>
  803354:	8b 45 08             	mov    0x8(%ebp),%eax
  803357:	a3 38 51 80 00       	mov    %eax,0x805138
  80335c:	8b 45 08             	mov    0x8(%ebp),%eax
  80335f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803364:	8b 45 08             	mov    0x8(%ebp),%eax
  803367:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80336d:	a1 44 51 80 00       	mov    0x805144,%eax
  803372:	40                   	inc    %eax
  803373:	a3 44 51 80 00       	mov    %eax,0x805144
  803378:	e9 d9 06 00 00       	jmp    803a56 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva==(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  80337d:	8b 45 08             	mov    0x8(%ebp),%eax
  803380:	8b 50 08             	mov    0x8(%eax),%edx
  803383:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803388:	8b 40 08             	mov    0x8(%eax),%eax
  80338b:	39 c2                	cmp    %eax,%edx
  80338d:	0f 86 b5 00 00 00    	jbe    803448 <insert_sorted_with_merge_freeList+0x1ff>
  803393:	8b 45 08             	mov    0x8(%ebp),%eax
  803396:	8b 50 08             	mov    0x8(%eax),%edx
  803399:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80339e:	8b 48 0c             	mov    0xc(%eax),%ecx
  8033a1:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8033a6:	8b 40 08             	mov    0x8(%eax),%eax
  8033a9:	01 c8                	add    %ecx,%eax
  8033ab:	39 c2                	cmp    %eax,%edx
  8033ad:	0f 85 95 00 00 00    	jne    803448 <insert_sorted_with_merge_freeList+0x1ff>

	{
		FreeMemBlocksList.lh_last->size+=blockToInsert->size;
  8033b3:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8033b8:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8033be:	8b 4a 0c             	mov    0xc(%edx),%ecx
  8033c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8033c4:	8b 52 0c             	mov    0xc(%edx),%edx
  8033c7:	01 ca                	add    %ecx,%edx
  8033c9:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  8033cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8033cf:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  8033d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8033e0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033e4:	75 17                	jne    8033fd <insert_sorted_with_merge_freeList+0x1b4>
  8033e6:	83 ec 04             	sub    $0x4,%esp
  8033e9:	68 50 48 80 00       	push   $0x804850
  8033ee:	68 54 01 00 00       	push   $0x154
  8033f3:	68 73 48 80 00       	push   $0x804873
  8033f8:	e8 8a d8 ff ff       	call   800c87 <_panic>
  8033fd:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803403:	8b 45 08             	mov    0x8(%ebp),%eax
  803406:	89 10                	mov    %edx,(%eax)
  803408:	8b 45 08             	mov    0x8(%ebp),%eax
  80340b:	8b 00                	mov    (%eax),%eax
  80340d:	85 c0                	test   %eax,%eax
  80340f:	74 0d                	je     80341e <insert_sorted_with_merge_freeList+0x1d5>
  803411:	a1 48 51 80 00       	mov    0x805148,%eax
  803416:	8b 55 08             	mov    0x8(%ebp),%edx
  803419:	89 50 04             	mov    %edx,0x4(%eax)
  80341c:	eb 08                	jmp    803426 <insert_sorted_with_merge_freeList+0x1dd>
  80341e:	8b 45 08             	mov    0x8(%ebp),%eax
  803421:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803426:	8b 45 08             	mov    0x8(%ebp),%eax
  803429:	a3 48 51 80 00       	mov    %eax,0x805148
  80342e:	8b 45 08             	mov    0x8(%ebp),%eax
  803431:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803438:	a1 54 51 80 00       	mov    0x805154,%eax
  80343d:	40                   	inc    %eax
  80343e:	a3 54 51 80 00       	mov    %eax,0x805154
  803443:	e9 0e 06 00 00       	jmp    803a56 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva==(blockToInsert->sva+blockToInsert->size))
  803448:	8b 45 08             	mov    0x8(%ebp),%eax
  80344b:	8b 50 08             	mov    0x8(%eax),%edx
  80344e:	a1 38 51 80 00       	mov    0x805138,%eax
  803453:	8b 40 08             	mov    0x8(%eax),%eax
  803456:	39 c2                	cmp    %eax,%edx
  803458:	0f 83 c1 00 00 00    	jae    80351f <insert_sorted_with_merge_freeList+0x2d6>
  80345e:	a1 38 51 80 00       	mov    0x805138,%eax
  803463:	8b 50 08             	mov    0x8(%eax),%edx
  803466:	8b 45 08             	mov    0x8(%ebp),%eax
  803469:	8b 48 08             	mov    0x8(%eax),%ecx
  80346c:	8b 45 08             	mov    0x8(%ebp),%eax
  80346f:	8b 40 0c             	mov    0xc(%eax),%eax
  803472:	01 c8                	add    %ecx,%eax
  803474:	39 c2                	cmp    %eax,%edx
  803476:	0f 85 a3 00 00 00    	jne    80351f <insert_sorted_with_merge_freeList+0x2d6>
	{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  80347c:	a1 38 51 80 00       	mov    0x805138,%eax
  803481:	8b 55 08             	mov    0x8(%ebp),%edx
  803484:	8b 52 08             	mov    0x8(%edx),%edx
  803487:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size+=blockToInsert->size;
  80348a:	a1 38 51 80 00       	mov    0x805138,%eax
  80348f:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803495:	8b 4a 0c             	mov    0xc(%edx),%ecx
  803498:	8b 55 08             	mov    0x8(%ebp),%edx
  80349b:	8b 52 0c             	mov    0xc(%edx),%edx
  80349e:	01 ca                	add    %ecx,%edx
  8034a0:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->sva=0;
  8034a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		blockToInsert->size=0;
  8034ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)

		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8034b7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034bb:	75 17                	jne    8034d4 <insert_sorted_with_merge_freeList+0x28b>
  8034bd:	83 ec 04             	sub    $0x4,%esp
  8034c0:	68 50 48 80 00       	push   $0x804850
  8034c5:	68 5d 01 00 00       	push   $0x15d
  8034ca:	68 73 48 80 00       	push   $0x804873
  8034cf:	e8 b3 d7 ff ff       	call   800c87 <_panic>
  8034d4:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8034da:	8b 45 08             	mov    0x8(%ebp),%eax
  8034dd:	89 10                	mov    %edx,(%eax)
  8034df:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e2:	8b 00                	mov    (%eax),%eax
  8034e4:	85 c0                	test   %eax,%eax
  8034e6:	74 0d                	je     8034f5 <insert_sorted_with_merge_freeList+0x2ac>
  8034e8:	a1 48 51 80 00       	mov    0x805148,%eax
  8034ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8034f0:	89 50 04             	mov    %edx,0x4(%eax)
  8034f3:	eb 08                	jmp    8034fd <insert_sorted_with_merge_freeList+0x2b4>
  8034f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803500:	a3 48 51 80 00       	mov    %eax,0x805148
  803505:	8b 45 08             	mov    0x8(%ebp),%eax
  803508:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80350f:	a1 54 51 80 00       	mov    0x805154,%eax
  803514:	40                   	inc    %eax
  803515:	a3 54 51 80 00       	mov    %eax,0x805154
  80351a:	e9 37 05 00 00       	jmp    803a56 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva!=(blockToInsert->sva+blockToInsert->size))
  80351f:	8b 45 08             	mov    0x8(%ebp),%eax
  803522:	8b 50 08             	mov    0x8(%eax),%edx
  803525:	a1 38 51 80 00       	mov    0x805138,%eax
  80352a:	8b 40 08             	mov    0x8(%eax),%eax
  80352d:	39 c2                	cmp    %eax,%edx
  80352f:	0f 83 82 00 00 00    	jae    8035b7 <insert_sorted_with_merge_freeList+0x36e>
  803535:	a1 38 51 80 00       	mov    0x805138,%eax
  80353a:	8b 50 08             	mov    0x8(%eax),%edx
  80353d:	8b 45 08             	mov    0x8(%ebp),%eax
  803540:	8b 48 08             	mov    0x8(%eax),%ecx
  803543:	8b 45 08             	mov    0x8(%ebp),%eax
  803546:	8b 40 0c             	mov    0xc(%eax),%eax
  803549:	01 c8                	add    %ecx,%eax
  80354b:	39 c2                	cmp    %eax,%edx
  80354d:	74 68                	je     8035b7 <insert_sorted_with_merge_freeList+0x36e>

	{
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  80354f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803553:	75 17                	jne    80356c <insert_sorted_with_merge_freeList+0x323>
  803555:	83 ec 04             	sub    $0x4,%esp
  803558:	68 50 48 80 00       	push   $0x804850
  80355d:	68 62 01 00 00       	push   $0x162
  803562:	68 73 48 80 00       	push   $0x804873
  803567:	e8 1b d7 ff ff       	call   800c87 <_panic>
  80356c:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803572:	8b 45 08             	mov    0x8(%ebp),%eax
  803575:	89 10                	mov    %edx,(%eax)
  803577:	8b 45 08             	mov    0x8(%ebp),%eax
  80357a:	8b 00                	mov    (%eax),%eax
  80357c:	85 c0                	test   %eax,%eax
  80357e:	74 0d                	je     80358d <insert_sorted_with_merge_freeList+0x344>
  803580:	a1 38 51 80 00       	mov    0x805138,%eax
  803585:	8b 55 08             	mov    0x8(%ebp),%edx
  803588:	89 50 04             	mov    %edx,0x4(%eax)
  80358b:	eb 08                	jmp    803595 <insert_sorted_with_merge_freeList+0x34c>
  80358d:	8b 45 08             	mov    0x8(%ebp),%eax
  803590:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803595:	8b 45 08             	mov    0x8(%ebp),%eax
  803598:	a3 38 51 80 00       	mov    %eax,0x805138
  80359d:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035a7:	a1 44 51 80 00       	mov    0x805144,%eax
  8035ac:	40                   	inc    %eax
  8035ad:	a3 44 51 80 00       	mov    %eax,0x805144
  8035b2:	e9 9f 04 00 00       	jmp    803a56 <insert_sorted_with_merge_freeList+0x80d>
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
  8035b7:	a1 38 51 80 00       	mov    0x805138,%eax
  8035bc:	8b 00                	mov    (%eax),%eax
  8035be:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  8035c1:	e9 84 04 00 00       	jmp    803a4a <insert_sorted_with_merge_freeList+0x801>
		{
			if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  8035c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035c9:	8b 50 08             	mov    0x8(%eax),%edx
  8035cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8035cf:	8b 40 08             	mov    0x8(%eax),%eax
  8035d2:	39 c2                	cmp    %eax,%edx
  8035d4:	0f 86 a9 00 00 00    	jbe    803683 <insert_sorted_with_merge_freeList+0x43a>
  8035da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035dd:	8b 50 08             	mov    0x8(%eax),%edx
  8035e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e3:	8b 48 08             	mov    0x8(%eax),%ecx
  8035e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e9:	8b 40 0c             	mov    0xc(%eax),%eax
  8035ec:	01 c8                	add    %ecx,%eax
  8035ee:	39 c2                	cmp    %eax,%edx
  8035f0:	0f 84 8d 00 00 00    	je     803683 <insert_sorted_with_merge_freeList+0x43a>
  8035f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f9:	8b 50 08             	mov    0x8(%eax),%edx
  8035fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ff:	8b 40 04             	mov    0x4(%eax),%eax
  803602:	8b 48 08             	mov    0x8(%eax),%ecx
  803605:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803608:	8b 40 04             	mov    0x4(%eax),%eax
  80360b:	8b 40 0c             	mov    0xc(%eax),%eax
  80360e:	01 c8                	add    %ecx,%eax
  803610:	39 c2                	cmp    %eax,%edx
  803612:	74 6f                	je     803683 <insert_sorted_with_merge_freeList+0x43a>
			{
				LIST_INSERT_BEFORE(&FreeMemBlocksList,tmp,blockToInsert);
  803614:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803618:	74 06                	je     803620 <insert_sorted_with_merge_freeList+0x3d7>
  80361a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80361e:	75 17                	jne    803637 <insert_sorted_with_merge_freeList+0x3ee>
  803620:	83 ec 04             	sub    $0x4,%esp
  803623:	68 b0 48 80 00       	push   $0x8048b0
  803628:	68 6b 01 00 00       	push   $0x16b
  80362d:	68 73 48 80 00       	push   $0x804873
  803632:	e8 50 d6 ff ff       	call   800c87 <_panic>
  803637:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80363a:	8b 50 04             	mov    0x4(%eax),%edx
  80363d:	8b 45 08             	mov    0x8(%ebp),%eax
  803640:	89 50 04             	mov    %edx,0x4(%eax)
  803643:	8b 45 08             	mov    0x8(%ebp),%eax
  803646:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803649:	89 10                	mov    %edx,(%eax)
  80364b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80364e:	8b 40 04             	mov    0x4(%eax),%eax
  803651:	85 c0                	test   %eax,%eax
  803653:	74 0d                	je     803662 <insert_sorted_with_merge_freeList+0x419>
  803655:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803658:	8b 40 04             	mov    0x4(%eax),%eax
  80365b:	8b 55 08             	mov    0x8(%ebp),%edx
  80365e:	89 10                	mov    %edx,(%eax)
  803660:	eb 08                	jmp    80366a <insert_sorted_with_merge_freeList+0x421>
  803662:	8b 45 08             	mov    0x8(%ebp),%eax
  803665:	a3 38 51 80 00       	mov    %eax,0x805138
  80366a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80366d:	8b 55 08             	mov    0x8(%ebp),%edx
  803670:	89 50 04             	mov    %edx,0x4(%eax)
  803673:	a1 44 51 80 00       	mov    0x805144,%eax
  803678:	40                   	inc    %eax
  803679:	a3 44 51 80 00       	mov    %eax,0x805144
				break;
  80367e:	e9 d3 03 00 00       	jmp    803a56 <insert_sorted_with_merge_freeList+0x80d>
			}// no merge
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  803683:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803686:	8b 50 08             	mov    0x8(%eax),%edx
  803689:	8b 45 08             	mov    0x8(%ebp),%eax
  80368c:	8b 40 08             	mov    0x8(%eax),%eax
  80368f:	39 c2                	cmp    %eax,%edx
  803691:	0f 86 da 00 00 00    	jbe    803771 <insert_sorted_with_merge_freeList+0x528>
  803697:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80369a:	8b 50 08             	mov    0x8(%eax),%edx
  80369d:	8b 45 08             	mov    0x8(%ebp),%eax
  8036a0:	8b 48 08             	mov    0x8(%eax),%ecx
  8036a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8036a6:	8b 40 0c             	mov    0xc(%eax),%eax
  8036a9:	01 c8                	add    %ecx,%eax
  8036ab:	39 c2                	cmp    %eax,%edx
  8036ad:	0f 85 be 00 00 00    	jne    803771 <insert_sorted_with_merge_freeList+0x528>
  8036b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b6:	8b 50 08             	mov    0x8(%eax),%edx
  8036b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036bc:	8b 40 04             	mov    0x4(%eax),%eax
  8036bf:	8b 48 08             	mov    0x8(%eax),%ecx
  8036c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036c5:	8b 40 04             	mov    0x4(%eax),%eax
  8036c8:	8b 40 0c             	mov    0xc(%eax),%eax
  8036cb:	01 c8                	add    %ecx,%eax
  8036cd:	39 c2                	cmp    %eax,%edx
  8036cf:	0f 84 9c 00 00 00    	je     803771 <insert_sorted_with_merge_freeList+0x528>
			{
tmp->sva=blockToInsert->sva;
  8036d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d8:	8b 50 08             	mov    0x8(%eax),%edx
  8036db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036de:	89 50 08             	mov    %edx,0x8(%eax)
tmp->size+=blockToInsert->size;
  8036e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036e4:	8b 50 0c             	mov    0xc(%eax),%edx
  8036e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ea:	8b 40 0c             	mov    0xc(%eax),%eax
  8036ed:	01 c2                	add    %eax,%edx
  8036ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036f2:	89 50 0c             	mov    %edx,0xc(%eax)
blockToInsert->sva=0;
  8036f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8036f8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
blockToInsert->size=0;
  8036ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803702:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803709:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80370d:	75 17                	jne    803726 <insert_sorted_with_merge_freeList+0x4dd>
  80370f:	83 ec 04             	sub    $0x4,%esp
  803712:	68 50 48 80 00       	push   $0x804850
  803717:	68 74 01 00 00       	push   $0x174
  80371c:	68 73 48 80 00       	push   $0x804873
  803721:	e8 61 d5 ff ff       	call   800c87 <_panic>
  803726:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80372c:	8b 45 08             	mov    0x8(%ebp),%eax
  80372f:	89 10                	mov    %edx,(%eax)
  803731:	8b 45 08             	mov    0x8(%ebp),%eax
  803734:	8b 00                	mov    (%eax),%eax
  803736:	85 c0                	test   %eax,%eax
  803738:	74 0d                	je     803747 <insert_sorted_with_merge_freeList+0x4fe>
  80373a:	a1 48 51 80 00       	mov    0x805148,%eax
  80373f:	8b 55 08             	mov    0x8(%ebp),%edx
  803742:	89 50 04             	mov    %edx,0x4(%eax)
  803745:	eb 08                	jmp    80374f <insert_sorted_with_merge_freeList+0x506>
  803747:	8b 45 08             	mov    0x8(%ebp),%eax
  80374a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80374f:	8b 45 08             	mov    0x8(%ebp),%eax
  803752:	a3 48 51 80 00       	mov    %eax,0x805148
  803757:	8b 45 08             	mov    0x8(%ebp),%eax
  80375a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803761:	a1 54 51 80 00       	mov    0x805154,%eax
  803766:	40                   	inc    %eax
  803767:	a3 54 51 80 00       	mov    %eax,0x805154
break;
  80376c:	e9 e5 02 00 00       	jmp    803a56 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with the next
			else if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  803771:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803774:	8b 50 08             	mov    0x8(%eax),%edx
  803777:	8b 45 08             	mov    0x8(%ebp),%eax
  80377a:	8b 40 08             	mov    0x8(%eax),%eax
  80377d:	39 c2                	cmp    %eax,%edx
  80377f:	0f 86 d7 00 00 00    	jbe    80385c <insert_sorted_with_merge_freeList+0x613>
  803785:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803788:	8b 50 08             	mov    0x8(%eax),%edx
  80378b:	8b 45 08             	mov    0x8(%ebp),%eax
  80378e:	8b 48 08             	mov    0x8(%eax),%ecx
  803791:	8b 45 08             	mov    0x8(%ebp),%eax
  803794:	8b 40 0c             	mov    0xc(%eax),%eax
  803797:	01 c8                	add    %ecx,%eax
  803799:	39 c2                	cmp    %eax,%edx
  80379b:	0f 84 bb 00 00 00    	je     80385c <insert_sorted_with_merge_freeList+0x613>
  8037a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a4:	8b 50 08             	mov    0x8(%eax),%edx
  8037a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037aa:	8b 40 04             	mov    0x4(%eax),%eax
  8037ad:	8b 48 08             	mov    0x8(%eax),%ecx
  8037b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037b3:	8b 40 04             	mov    0x4(%eax),%eax
  8037b6:	8b 40 0c             	mov    0xc(%eax),%eax
  8037b9:	01 c8                	add    %ecx,%eax
  8037bb:	39 c2                	cmp    %eax,%edx
  8037bd:	0f 85 99 00 00 00    	jne    80385c <insert_sorted_with_merge_freeList+0x613>
			{
				struct MemBlock *ptr=LIST_PREV(tmp);
  8037c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037c6:	8b 40 04             	mov    0x4(%eax),%eax
  8037c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
				ptr->size+=blockToInsert->size;
  8037cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037cf:	8b 50 0c             	mov    0xc(%eax),%edx
  8037d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8037d5:	8b 40 0c             	mov    0xc(%eax),%eax
  8037d8:	01 c2                	add    %eax,%edx
  8037da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037dd:	89 50 0c             	mov    %edx,0xc(%eax)
				blockToInsert->sva=0;
  8037e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8037e3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size =0;
  8037ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ed:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8037f4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037f8:	75 17                	jne    803811 <insert_sorted_with_merge_freeList+0x5c8>
  8037fa:	83 ec 04             	sub    $0x4,%esp
  8037fd:	68 50 48 80 00       	push   $0x804850
  803802:	68 7d 01 00 00       	push   $0x17d
  803807:	68 73 48 80 00       	push   $0x804873
  80380c:	e8 76 d4 ff ff       	call   800c87 <_panic>
  803811:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803817:	8b 45 08             	mov    0x8(%ebp),%eax
  80381a:	89 10                	mov    %edx,(%eax)
  80381c:	8b 45 08             	mov    0x8(%ebp),%eax
  80381f:	8b 00                	mov    (%eax),%eax
  803821:	85 c0                	test   %eax,%eax
  803823:	74 0d                	je     803832 <insert_sorted_with_merge_freeList+0x5e9>
  803825:	a1 48 51 80 00       	mov    0x805148,%eax
  80382a:	8b 55 08             	mov    0x8(%ebp),%edx
  80382d:	89 50 04             	mov    %edx,0x4(%eax)
  803830:	eb 08                	jmp    80383a <insert_sorted_with_merge_freeList+0x5f1>
  803832:	8b 45 08             	mov    0x8(%ebp),%eax
  803835:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80383a:	8b 45 08             	mov    0x8(%ebp),%eax
  80383d:	a3 48 51 80 00       	mov    %eax,0x805148
  803842:	8b 45 08             	mov    0x8(%ebp),%eax
  803845:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80384c:	a1 54 51 80 00       	mov    0x805154,%eax
  803851:	40                   	inc    %eax
  803852:	a3 54 51 80 00       	mov    %eax,0x805154
break;
  803857:	e9 fa 01 00 00       	jmp    803a56 <insert_sorted_with_merge_freeList+0x80d>
			}// merge with previous
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  80385c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80385f:	8b 50 08             	mov    0x8(%eax),%edx
  803862:	8b 45 08             	mov    0x8(%ebp),%eax
  803865:	8b 40 08             	mov    0x8(%eax),%eax
  803868:	39 c2                	cmp    %eax,%edx
  80386a:	0f 86 d2 01 00 00    	jbe    803a42 <insert_sorted_with_merge_freeList+0x7f9>
  803870:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803873:	8b 50 08             	mov    0x8(%eax),%edx
  803876:	8b 45 08             	mov    0x8(%ebp),%eax
  803879:	8b 48 08             	mov    0x8(%eax),%ecx
  80387c:	8b 45 08             	mov    0x8(%ebp),%eax
  80387f:	8b 40 0c             	mov    0xc(%eax),%eax
  803882:	01 c8                	add    %ecx,%eax
  803884:	39 c2                	cmp    %eax,%edx
  803886:	0f 85 b6 01 00 00    	jne    803a42 <insert_sorted_with_merge_freeList+0x7f9>
  80388c:	8b 45 08             	mov    0x8(%ebp),%eax
  80388f:	8b 50 08             	mov    0x8(%eax),%edx
  803892:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803895:	8b 40 04             	mov    0x4(%eax),%eax
  803898:	8b 48 08             	mov    0x8(%eax),%ecx
  80389b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80389e:	8b 40 04             	mov    0x4(%eax),%eax
  8038a1:	8b 40 0c             	mov    0xc(%eax),%eax
  8038a4:	01 c8                	add    %ecx,%eax
  8038a6:	39 c2                	cmp    %eax,%edx
  8038a8:	0f 85 94 01 00 00    	jne    803a42 <insert_sorted_with_merge_freeList+0x7f9>
			{

				LIST_PREV(tmp)->size+=blockToInsert->size+tmp->size;
  8038ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038b1:	8b 40 04             	mov    0x4(%eax),%eax
  8038b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8038b7:	8b 52 04             	mov    0x4(%edx),%edx
  8038ba:	8b 4a 0c             	mov    0xc(%edx),%ecx
  8038bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8038c0:	8b 5a 0c             	mov    0xc(%edx),%ebx
  8038c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8038c6:	8b 52 0c             	mov    0xc(%edx),%edx
  8038c9:	01 da                	add    %ebx,%edx
  8038cb:	01 ca                	add    %ecx,%edx
  8038cd:	89 50 0c             	mov    %edx,0xc(%eax)
				tmp->size=0;
  8038d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038d3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				tmp->sva=0;
  8038da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038dd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  8038e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038e8:	75 17                	jne    803901 <insert_sorted_with_merge_freeList+0x6b8>
  8038ea:	83 ec 04             	sub    $0x4,%esp
  8038ed:	68 e5 48 80 00       	push   $0x8048e5
  8038f2:	68 86 01 00 00       	push   $0x186
  8038f7:	68 73 48 80 00       	push   $0x804873
  8038fc:	e8 86 d3 ff ff       	call   800c87 <_panic>
  803901:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803904:	8b 00                	mov    (%eax),%eax
  803906:	85 c0                	test   %eax,%eax
  803908:	74 10                	je     80391a <insert_sorted_with_merge_freeList+0x6d1>
  80390a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80390d:	8b 00                	mov    (%eax),%eax
  80390f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803912:	8b 52 04             	mov    0x4(%edx),%edx
  803915:	89 50 04             	mov    %edx,0x4(%eax)
  803918:	eb 0b                	jmp    803925 <insert_sorted_with_merge_freeList+0x6dc>
  80391a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80391d:	8b 40 04             	mov    0x4(%eax),%eax
  803920:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803925:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803928:	8b 40 04             	mov    0x4(%eax),%eax
  80392b:	85 c0                	test   %eax,%eax
  80392d:	74 0f                	je     80393e <insert_sorted_with_merge_freeList+0x6f5>
  80392f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803932:	8b 40 04             	mov    0x4(%eax),%eax
  803935:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803938:	8b 12                	mov    (%edx),%edx
  80393a:	89 10                	mov    %edx,(%eax)
  80393c:	eb 0a                	jmp    803948 <insert_sorted_with_merge_freeList+0x6ff>
  80393e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803941:	8b 00                	mov    (%eax),%eax
  803943:	a3 38 51 80 00       	mov    %eax,0x805138
  803948:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80394b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803951:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803954:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80395b:	a1 44 51 80 00       	mov    0x805144,%eax
  803960:	48                   	dec    %eax
  803961:	a3 44 51 80 00       	mov    %eax,0x805144
				LIST_INSERT_HEAD(&AvailableMemBlocksList,tmp);
  803966:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80396a:	75 17                	jne    803983 <insert_sorted_with_merge_freeList+0x73a>
  80396c:	83 ec 04             	sub    $0x4,%esp
  80396f:	68 50 48 80 00       	push   $0x804850
  803974:	68 87 01 00 00       	push   $0x187
  803979:	68 73 48 80 00       	push   $0x804873
  80397e:	e8 04 d3 ff ff       	call   800c87 <_panic>
  803983:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803989:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80398c:	89 10                	mov    %edx,(%eax)
  80398e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803991:	8b 00                	mov    (%eax),%eax
  803993:	85 c0                	test   %eax,%eax
  803995:	74 0d                	je     8039a4 <insert_sorted_with_merge_freeList+0x75b>
  803997:	a1 48 51 80 00       	mov    0x805148,%eax
  80399c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80399f:	89 50 04             	mov    %edx,0x4(%eax)
  8039a2:	eb 08                	jmp    8039ac <insert_sorted_with_merge_freeList+0x763>
  8039a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039a7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8039ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039af:	a3 48 51 80 00       	mov    %eax,0x805148
  8039b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039b7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039be:	a1 54 51 80 00       	mov    0x805154,%eax
  8039c3:	40                   	inc    %eax
  8039c4:	a3 54 51 80 00       	mov    %eax,0x805154
				blockToInsert->sva=0;
  8039c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8039cc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size=0;
  8039d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8039d6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8039dd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8039e1:	75 17                	jne    8039fa <insert_sorted_with_merge_freeList+0x7b1>
  8039e3:	83 ec 04             	sub    $0x4,%esp
  8039e6:	68 50 48 80 00       	push   $0x804850
  8039eb:	68 8a 01 00 00       	push   $0x18a
  8039f0:	68 73 48 80 00       	push   $0x804873
  8039f5:	e8 8d d2 ff ff       	call   800c87 <_panic>
  8039fa:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803a00:	8b 45 08             	mov    0x8(%ebp),%eax
  803a03:	89 10                	mov    %edx,(%eax)
  803a05:	8b 45 08             	mov    0x8(%ebp),%eax
  803a08:	8b 00                	mov    (%eax),%eax
  803a0a:	85 c0                	test   %eax,%eax
  803a0c:	74 0d                	je     803a1b <insert_sorted_with_merge_freeList+0x7d2>
  803a0e:	a1 48 51 80 00       	mov    0x805148,%eax
  803a13:	8b 55 08             	mov    0x8(%ebp),%edx
  803a16:	89 50 04             	mov    %edx,0x4(%eax)
  803a19:	eb 08                	jmp    803a23 <insert_sorted_with_merge_freeList+0x7da>
  803a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  803a1e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803a23:	8b 45 08             	mov    0x8(%ebp),%eax
  803a26:	a3 48 51 80 00       	mov    %eax,0x805148
  803a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  803a2e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a35:	a1 54 51 80 00       	mov    0x805154,%eax
  803a3a:	40                   	inc    %eax
  803a3b:	a3 54 51 80 00       	mov    %eax,0x805154
				break;
  803a40:	eb 14                	jmp    803a56 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with next and previous
			tmp=tmp->prev_next_info.le_next;
  803a42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a45:	8b 00                	mov    (%eax),%eax
  803a47:	89 45 f4             	mov    %eax,-0xc(%ebp)
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
		while(tmp!=NULL)
  803a4a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a4e:	0f 85 72 fb ff ff    	jne    8035c6 <insert_sorted_with_merge_freeList+0x37d>
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  803a54:	eb 00                	jmp    803a56 <insert_sorted_with_merge_freeList+0x80d>
  803a56:	90                   	nop
  803a57:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803a5a:	c9                   	leave  
  803a5b:	c3                   	ret    

00803a5c <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803a5c:	55                   	push   %ebp
  803a5d:	89 e5                	mov    %esp,%ebp
  803a5f:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803a62:	8b 55 08             	mov    0x8(%ebp),%edx
  803a65:	89 d0                	mov    %edx,%eax
  803a67:	c1 e0 02             	shl    $0x2,%eax
  803a6a:	01 d0                	add    %edx,%eax
  803a6c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803a73:	01 d0                	add    %edx,%eax
  803a75:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803a7c:	01 d0                	add    %edx,%eax
  803a7e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803a85:	01 d0                	add    %edx,%eax
  803a87:	c1 e0 04             	shl    $0x4,%eax
  803a8a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803a8d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803a94:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803a97:	83 ec 0c             	sub    $0xc,%esp
  803a9a:	50                   	push   %eax
  803a9b:	e8 7b eb ff ff       	call   80261b <sys_get_virtual_time>
  803aa0:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803aa3:	eb 41                	jmp    803ae6 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803aa5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803aa8:	83 ec 0c             	sub    $0xc,%esp
  803aab:	50                   	push   %eax
  803aac:	e8 6a eb ff ff       	call   80261b <sys_get_virtual_time>
  803ab1:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803ab4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803ab7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803aba:	29 c2                	sub    %eax,%edx
  803abc:	89 d0                	mov    %edx,%eax
  803abe:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803ac1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ac4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ac7:	89 d1                	mov    %edx,%ecx
  803ac9:	29 c1                	sub    %eax,%ecx
  803acb:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803ace:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803ad1:	39 c2                	cmp    %eax,%edx
  803ad3:	0f 97 c0             	seta   %al
  803ad6:	0f b6 c0             	movzbl %al,%eax
  803ad9:	29 c1                	sub    %eax,%ecx
  803adb:	89 c8                	mov    %ecx,%eax
  803add:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803ae0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803ae3:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803ae6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ae9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803aec:	72 b7                	jb     803aa5 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803aee:	90                   	nop
  803aef:	c9                   	leave  
  803af0:	c3                   	ret    

00803af1 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803af1:	55                   	push   %ebp
  803af2:	89 e5                	mov    %esp,%ebp
  803af4:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803af7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803afe:	eb 03                	jmp    803b03 <busy_wait+0x12>
  803b00:	ff 45 fc             	incl   -0x4(%ebp)
  803b03:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803b06:	3b 45 08             	cmp    0x8(%ebp),%eax
  803b09:	72 f5                	jb     803b00 <busy_wait+0xf>
	return i;
  803b0b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803b0e:	c9                   	leave  
  803b0f:	c3                   	ret    

00803b10 <__udivdi3>:
  803b10:	55                   	push   %ebp
  803b11:	57                   	push   %edi
  803b12:	56                   	push   %esi
  803b13:	53                   	push   %ebx
  803b14:	83 ec 1c             	sub    $0x1c,%esp
  803b17:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803b1b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803b1f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b23:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803b27:	89 ca                	mov    %ecx,%edx
  803b29:	89 f8                	mov    %edi,%eax
  803b2b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803b2f:	85 f6                	test   %esi,%esi
  803b31:	75 2d                	jne    803b60 <__udivdi3+0x50>
  803b33:	39 cf                	cmp    %ecx,%edi
  803b35:	77 65                	ja     803b9c <__udivdi3+0x8c>
  803b37:	89 fd                	mov    %edi,%ebp
  803b39:	85 ff                	test   %edi,%edi
  803b3b:	75 0b                	jne    803b48 <__udivdi3+0x38>
  803b3d:	b8 01 00 00 00       	mov    $0x1,%eax
  803b42:	31 d2                	xor    %edx,%edx
  803b44:	f7 f7                	div    %edi
  803b46:	89 c5                	mov    %eax,%ebp
  803b48:	31 d2                	xor    %edx,%edx
  803b4a:	89 c8                	mov    %ecx,%eax
  803b4c:	f7 f5                	div    %ebp
  803b4e:	89 c1                	mov    %eax,%ecx
  803b50:	89 d8                	mov    %ebx,%eax
  803b52:	f7 f5                	div    %ebp
  803b54:	89 cf                	mov    %ecx,%edi
  803b56:	89 fa                	mov    %edi,%edx
  803b58:	83 c4 1c             	add    $0x1c,%esp
  803b5b:	5b                   	pop    %ebx
  803b5c:	5e                   	pop    %esi
  803b5d:	5f                   	pop    %edi
  803b5e:	5d                   	pop    %ebp
  803b5f:	c3                   	ret    
  803b60:	39 ce                	cmp    %ecx,%esi
  803b62:	77 28                	ja     803b8c <__udivdi3+0x7c>
  803b64:	0f bd fe             	bsr    %esi,%edi
  803b67:	83 f7 1f             	xor    $0x1f,%edi
  803b6a:	75 40                	jne    803bac <__udivdi3+0x9c>
  803b6c:	39 ce                	cmp    %ecx,%esi
  803b6e:	72 0a                	jb     803b7a <__udivdi3+0x6a>
  803b70:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803b74:	0f 87 9e 00 00 00    	ja     803c18 <__udivdi3+0x108>
  803b7a:	b8 01 00 00 00       	mov    $0x1,%eax
  803b7f:	89 fa                	mov    %edi,%edx
  803b81:	83 c4 1c             	add    $0x1c,%esp
  803b84:	5b                   	pop    %ebx
  803b85:	5e                   	pop    %esi
  803b86:	5f                   	pop    %edi
  803b87:	5d                   	pop    %ebp
  803b88:	c3                   	ret    
  803b89:	8d 76 00             	lea    0x0(%esi),%esi
  803b8c:	31 ff                	xor    %edi,%edi
  803b8e:	31 c0                	xor    %eax,%eax
  803b90:	89 fa                	mov    %edi,%edx
  803b92:	83 c4 1c             	add    $0x1c,%esp
  803b95:	5b                   	pop    %ebx
  803b96:	5e                   	pop    %esi
  803b97:	5f                   	pop    %edi
  803b98:	5d                   	pop    %ebp
  803b99:	c3                   	ret    
  803b9a:	66 90                	xchg   %ax,%ax
  803b9c:	89 d8                	mov    %ebx,%eax
  803b9e:	f7 f7                	div    %edi
  803ba0:	31 ff                	xor    %edi,%edi
  803ba2:	89 fa                	mov    %edi,%edx
  803ba4:	83 c4 1c             	add    $0x1c,%esp
  803ba7:	5b                   	pop    %ebx
  803ba8:	5e                   	pop    %esi
  803ba9:	5f                   	pop    %edi
  803baa:	5d                   	pop    %ebp
  803bab:	c3                   	ret    
  803bac:	bd 20 00 00 00       	mov    $0x20,%ebp
  803bb1:	89 eb                	mov    %ebp,%ebx
  803bb3:	29 fb                	sub    %edi,%ebx
  803bb5:	89 f9                	mov    %edi,%ecx
  803bb7:	d3 e6                	shl    %cl,%esi
  803bb9:	89 c5                	mov    %eax,%ebp
  803bbb:	88 d9                	mov    %bl,%cl
  803bbd:	d3 ed                	shr    %cl,%ebp
  803bbf:	89 e9                	mov    %ebp,%ecx
  803bc1:	09 f1                	or     %esi,%ecx
  803bc3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803bc7:	89 f9                	mov    %edi,%ecx
  803bc9:	d3 e0                	shl    %cl,%eax
  803bcb:	89 c5                	mov    %eax,%ebp
  803bcd:	89 d6                	mov    %edx,%esi
  803bcf:	88 d9                	mov    %bl,%cl
  803bd1:	d3 ee                	shr    %cl,%esi
  803bd3:	89 f9                	mov    %edi,%ecx
  803bd5:	d3 e2                	shl    %cl,%edx
  803bd7:	8b 44 24 08          	mov    0x8(%esp),%eax
  803bdb:	88 d9                	mov    %bl,%cl
  803bdd:	d3 e8                	shr    %cl,%eax
  803bdf:	09 c2                	or     %eax,%edx
  803be1:	89 d0                	mov    %edx,%eax
  803be3:	89 f2                	mov    %esi,%edx
  803be5:	f7 74 24 0c          	divl   0xc(%esp)
  803be9:	89 d6                	mov    %edx,%esi
  803beb:	89 c3                	mov    %eax,%ebx
  803bed:	f7 e5                	mul    %ebp
  803bef:	39 d6                	cmp    %edx,%esi
  803bf1:	72 19                	jb     803c0c <__udivdi3+0xfc>
  803bf3:	74 0b                	je     803c00 <__udivdi3+0xf0>
  803bf5:	89 d8                	mov    %ebx,%eax
  803bf7:	31 ff                	xor    %edi,%edi
  803bf9:	e9 58 ff ff ff       	jmp    803b56 <__udivdi3+0x46>
  803bfe:	66 90                	xchg   %ax,%ax
  803c00:	8b 54 24 08          	mov    0x8(%esp),%edx
  803c04:	89 f9                	mov    %edi,%ecx
  803c06:	d3 e2                	shl    %cl,%edx
  803c08:	39 c2                	cmp    %eax,%edx
  803c0a:	73 e9                	jae    803bf5 <__udivdi3+0xe5>
  803c0c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803c0f:	31 ff                	xor    %edi,%edi
  803c11:	e9 40 ff ff ff       	jmp    803b56 <__udivdi3+0x46>
  803c16:	66 90                	xchg   %ax,%ax
  803c18:	31 c0                	xor    %eax,%eax
  803c1a:	e9 37 ff ff ff       	jmp    803b56 <__udivdi3+0x46>
  803c1f:	90                   	nop

00803c20 <__umoddi3>:
  803c20:	55                   	push   %ebp
  803c21:	57                   	push   %edi
  803c22:	56                   	push   %esi
  803c23:	53                   	push   %ebx
  803c24:	83 ec 1c             	sub    $0x1c,%esp
  803c27:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803c2b:	8b 74 24 34          	mov    0x34(%esp),%esi
  803c2f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c33:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803c37:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803c3b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803c3f:	89 f3                	mov    %esi,%ebx
  803c41:	89 fa                	mov    %edi,%edx
  803c43:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c47:	89 34 24             	mov    %esi,(%esp)
  803c4a:	85 c0                	test   %eax,%eax
  803c4c:	75 1a                	jne    803c68 <__umoddi3+0x48>
  803c4e:	39 f7                	cmp    %esi,%edi
  803c50:	0f 86 a2 00 00 00    	jbe    803cf8 <__umoddi3+0xd8>
  803c56:	89 c8                	mov    %ecx,%eax
  803c58:	89 f2                	mov    %esi,%edx
  803c5a:	f7 f7                	div    %edi
  803c5c:	89 d0                	mov    %edx,%eax
  803c5e:	31 d2                	xor    %edx,%edx
  803c60:	83 c4 1c             	add    $0x1c,%esp
  803c63:	5b                   	pop    %ebx
  803c64:	5e                   	pop    %esi
  803c65:	5f                   	pop    %edi
  803c66:	5d                   	pop    %ebp
  803c67:	c3                   	ret    
  803c68:	39 f0                	cmp    %esi,%eax
  803c6a:	0f 87 ac 00 00 00    	ja     803d1c <__umoddi3+0xfc>
  803c70:	0f bd e8             	bsr    %eax,%ebp
  803c73:	83 f5 1f             	xor    $0x1f,%ebp
  803c76:	0f 84 ac 00 00 00    	je     803d28 <__umoddi3+0x108>
  803c7c:	bf 20 00 00 00       	mov    $0x20,%edi
  803c81:	29 ef                	sub    %ebp,%edi
  803c83:	89 fe                	mov    %edi,%esi
  803c85:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803c89:	89 e9                	mov    %ebp,%ecx
  803c8b:	d3 e0                	shl    %cl,%eax
  803c8d:	89 d7                	mov    %edx,%edi
  803c8f:	89 f1                	mov    %esi,%ecx
  803c91:	d3 ef                	shr    %cl,%edi
  803c93:	09 c7                	or     %eax,%edi
  803c95:	89 e9                	mov    %ebp,%ecx
  803c97:	d3 e2                	shl    %cl,%edx
  803c99:	89 14 24             	mov    %edx,(%esp)
  803c9c:	89 d8                	mov    %ebx,%eax
  803c9e:	d3 e0                	shl    %cl,%eax
  803ca0:	89 c2                	mov    %eax,%edx
  803ca2:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ca6:	d3 e0                	shl    %cl,%eax
  803ca8:	89 44 24 04          	mov    %eax,0x4(%esp)
  803cac:	8b 44 24 08          	mov    0x8(%esp),%eax
  803cb0:	89 f1                	mov    %esi,%ecx
  803cb2:	d3 e8                	shr    %cl,%eax
  803cb4:	09 d0                	or     %edx,%eax
  803cb6:	d3 eb                	shr    %cl,%ebx
  803cb8:	89 da                	mov    %ebx,%edx
  803cba:	f7 f7                	div    %edi
  803cbc:	89 d3                	mov    %edx,%ebx
  803cbe:	f7 24 24             	mull   (%esp)
  803cc1:	89 c6                	mov    %eax,%esi
  803cc3:	89 d1                	mov    %edx,%ecx
  803cc5:	39 d3                	cmp    %edx,%ebx
  803cc7:	0f 82 87 00 00 00    	jb     803d54 <__umoddi3+0x134>
  803ccd:	0f 84 91 00 00 00    	je     803d64 <__umoddi3+0x144>
  803cd3:	8b 54 24 04          	mov    0x4(%esp),%edx
  803cd7:	29 f2                	sub    %esi,%edx
  803cd9:	19 cb                	sbb    %ecx,%ebx
  803cdb:	89 d8                	mov    %ebx,%eax
  803cdd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803ce1:	d3 e0                	shl    %cl,%eax
  803ce3:	89 e9                	mov    %ebp,%ecx
  803ce5:	d3 ea                	shr    %cl,%edx
  803ce7:	09 d0                	or     %edx,%eax
  803ce9:	89 e9                	mov    %ebp,%ecx
  803ceb:	d3 eb                	shr    %cl,%ebx
  803ced:	89 da                	mov    %ebx,%edx
  803cef:	83 c4 1c             	add    $0x1c,%esp
  803cf2:	5b                   	pop    %ebx
  803cf3:	5e                   	pop    %esi
  803cf4:	5f                   	pop    %edi
  803cf5:	5d                   	pop    %ebp
  803cf6:	c3                   	ret    
  803cf7:	90                   	nop
  803cf8:	89 fd                	mov    %edi,%ebp
  803cfa:	85 ff                	test   %edi,%edi
  803cfc:	75 0b                	jne    803d09 <__umoddi3+0xe9>
  803cfe:	b8 01 00 00 00       	mov    $0x1,%eax
  803d03:	31 d2                	xor    %edx,%edx
  803d05:	f7 f7                	div    %edi
  803d07:	89 c5                	mov    %eax,%ebp
  803d09:	89 f0                	mov    %esi,%eax
  803d0b:	31 d2                	xor    %edx,%edx
  803d0d:	f7 f5                	div    %ebp
  803d0f:	89 c8                	mov    %ecx,%eax
  803d11:	f7 f5                	div    %ebp
  803d13:	89 d0                	mov    %edx,%eax
  803d15:	e9 44 ff ff ff       	jmp    803c5e <__umoddi3+0x3e>
  803d1a:	66 90                	xchg   %ax,%ax
  803d1c:	89 c8                	mov    %ecx,%eax
  803d1e:	89 f2                	mov    %esi,%edx
  803d20:	83 c4 1c             	add    $0x1c,%esp
  803d23:	5b                   	pop    %ebx
  803d24:	5e                   	pop    %esi
  803d25:	5f                   	pop    %edi
  803d26:	5d                   	pop    %ebp
  803d27:	c3                   	ret    
  803d28:	3b 04 24             	cmp    (%esp),%eax
  803d2b:	72 06                	jb     803d33 <__umoddi3+0x113>
  803d2d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803d31:	77 0f                	ja     803d42 <__umoddi3+0x122>
  803d33:	89 f2                	mov    %esi,%edx
  803d35:	29 f9                	sub    %edi,%ecx
  803d37:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803d3b:	89 14 24             	mov    %edx,(%esp)
  803d3e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d42:	8b 44 24 04          	mov    0x4(%esp),%eax
  803d46:	8b 14 24             	mov    (%esp),%edx
  803d49:	83 c4 1c             	add    $0x1c,%esp
  803d4c:	5b                   	pop    %ebx
  803d4d:	5e                   	pop    %esi
  803d4e:	5f                   	pop    %edi
  803d4f:	5d                   	pop    %ebp
  803d50:	c3                   	ret    
  803d51:	8d 76 00             	lea    0x0(%esi),%esi
  803d54:	2b 04 24             	sub    (%esp),%eax
  803d57:	19 fa                	sbb    %edi,%edx
  803d59:	89 d1                	mov    %edx,%ecx
  803d5b:	89 c6                	mov    %eax,%esi
  803d5d:	e9 71 ff ff ff       	jmp    803cd3 <__umoddi3+0xb3>
  803d62:	66 90                	xchg   %ax,%ax
  803d64:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803d68:	72 ea                	jb     803d54 <__umoddi3+0x134>
  803d6a:	89 d9                	mov    %ebx,%ecx
  803d6c:	e9 62 ff ff ff       	jmp    803cd3 <__umoddi3+0xb3>
