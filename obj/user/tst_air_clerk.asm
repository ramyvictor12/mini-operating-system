
obj/user/tst_air_clerk:     file format elf32-i386


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
  800031:	e8 e7 05 00 00       	call   80061d <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>
#include <user/air.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec 9c 01 00 00    	sub    $0x19c,%esp
	int parentenvID = sys_getparentenvid();
  800044:	e8 71 20 00 00       	call   8020ba <sys_getparentenvid>
  800049:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// Get the shared variables from the main program ***********************************

	char _customers[] = "customers";
  80004c:	8d 45 ae             	lea    -0x52(%ebp),%eax
  80004f:	bb d5 37 80 00       	mov    $0x8037d5,%ebx
  800054:	ba 0a 00 00 00       	mov    $0xa,%edx
  800059:	89 c7                	mov    %eax,%edi
  80005b:	89 de                	mov    %ebx,%esi
  80005d:	89 d1                	mov    %edx,%ecx
  80005f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custCounter[] = "custCounter";
  800061:	8d 45 a2             	lea    -0x5e(%ebp),%eax
  800064:	bb df 37 80 00       	mov    $0x8037df,%ebx
  800069:	ba 03 00 00 00       	mov    $0x3,%edx
  80006e:	89 c7                	mov    %eax,%edi
  800070:	89 de                	mov    %ebx,%esi
  800072:	89 d1                	mov    %edx,%ecx
  800074:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1Counter[] = "flight1Counter";
  800076:	8d 45 93             	lea    -0x6d(%ebp),%eax
  800079:	bb eb 37 80 00       	mov    $0x8037eb,%ebx
  80007e:	ba 0f 00 00 00       	mov    $0xf,%edx
  800083:	89 c7                	mov    %eax,%edi
  800085:	89 de                	mov    %ebx,%esi
  800087:	89 d1                	mov    %edx,%ecx
  800089:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Counter[] = "flight2Counter";
  80008b:	8d 45 84             	lea    -0x7c(%ebp),%eax
  80008e:	bb fa 37 80 00       	mov    $0x8037fa,%ebx
  800093:	ba 0f 00 00 00       	mov    $0xf,%edx
  800098:	89 c7                	mov    %eax,%edi
  80009a:	89 de                	mov    %ebx,%esi
  80009c:	89 d1                	mov    %edx,%ecx
  80009e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Counter[] = "flightBooked1Counter";
  8000a0:	8d 85 6f ff ff ff    	lea    -0x91(%ebp),%eax
  8000a6:	bb 09 38 80 00       	mov    $0x803809,%ebx
  8000ab:	ba 15 00 00 00       	mov    $0x15,%edx
  8000b0:	89 c7                	mov    %eax,%edi
  8000b2:	89 de                	mov    %ebx,%esi
  8000b4:	89 d1                	mov    %edx,%ecx
  8000b6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Counter[] = "flightBooked2Counter";
  8000b8:	8d 85 5a ff ff ff    	lea    -0xa6(%ebp),%eax
  8000be:	bb 1e 38 80 00       	mov    $0x80381e,%ebx
  8000c3:	ba 15 00 00 00       	mov    $0x15,%edx
  8000c8:	89 c7                	mov    %eax,%edi
  8000ca:	89 de                	mov    %ebx,%esi
  8000cc:	89 d1                	mov    %edx,%ecx
  8000ce:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Arr[] = "flightBooked1Arr";
  8000d0:	8d 85 49 ff ff ff    	lea    -0xb7(%ebp),%eax
  8000d6:	bb 33 38 80 00       	mov    $0x803833,%ebx
  8000db:	ba 11 00 00 00       	mov    $0x11,%edx
  8000e0:	89 c7                	mov    %eax,%edi
  8000e2:	89 de                	mov    %ebx,%esi
  8000e4:	89 d1                	mov    %edx,%ecx
  8000e6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Arr[] = "flightBooked2Arr";
  8000e8:	8d 85 38 ff ff ff    	lea    -0xc8(%ebp),%eax
  8000ee:	bb 44 38 80 00       	mov    $0x803844,%ebx
  8000f3:	ba 11 00 00 00       	mov    $0x11,%edx
  8000f8:	89 c7                	mov    %eax,%edi
  8000fa:	89 de                	mov    %ebx,%esi
  8000fc:	89 d1                	mov    %edx,%ecx
  8000fe:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _cust_ready_queue[] = "cust_ready_queue";
  800100:	8d 85 27 ff ff ff    	lea    -0xd9(%ebp),%eax
  800106:	bb 55 38 80 00       	mov    $0x803855,%ebx
  80010b:	ba 11 00 00 00       	mov    $0x11,%edx
  800110:	89 c7                	mov    %eax,%edi
  800112:	89 de                	mov    %ebx,%esi
  800114:	89 d1                	mov    %edx,%ecx
  800116:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_in[] = "queue_in";
  800118:	8d 85 1e ff ff ff    	lea    -0xe2(%ebp),%eax
  80011e:	bb 66 38 80 00       	mov    $0x803866,%ebx
  800123:	ba 09 00 00 00       	mov    $0x9,%edx
  800128:	89 c7                	mov    %eax,%edi
  80012a:	89 de                	mov    %ebx,%esi
  80012c:	89 d1                	mov    %edx,%ecx
  80012e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_out[] = "queue_out";
  800130:	8d 85 14 ff ff ff    	lea    -0xec(%ebp),%eax
  800136:	bb 6f 38 80 00       	mov    $0x80386f,%ebx
  80013b:	ba 0a 00 00 00       	mov    $0xa,%edx
  800140:	89 c7                	mov    %eax,%edi
  800142:	89 de                	mov    %ebx,%esi
  800144:	89 d1                	mov    %edx,%ecx
  800146:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _cust_ready[] = "cust_ready";
  800148:	8d 85 09 ff ff ff    	lea    -0xf7(%ebp),%eax
  80014e:	bb 79 38 80 00       	mov    $0x803879,%ebx
  800153:	ba 0b 00 00 00       	mov    $0xb,%edx
  800158:	89 c7                	mov    %eax,%edi
  80015a:	89 de                	mov    %ebx,%esi
  80015c:	89 d1                	mov    %edx,%ecx
  80015e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custQueueCS[] = "custQueueCS";
  800160:	8d 85 fd fe ff ff    	lea    -0x103(%ebp),%eax
  800166:	bb 84 38 80 00       	mov    $0x803884,%ebx
  80016b:	ba 03 00 00 00       	mov    $0x3,%edx
  800170:	89 c7                	mov    %eax,%edi
  800172:	89 de                	mov    %ebx,%esi
  800174:	89 d1                	mov    %edx,%ecx
  800176:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1CS[] = "flight1CS";
  800178:	8d 85 f3 fe ff ff    	lea    -0x10d(%ebp),%eax
  80017e:	bb 90 38 80 00       	mov    $0x803890,%ebx
  800183:	ba 0a 00 00 00       	mov    $0xa,%edx
  800188:	89 c7                	mov    %eax,%edi
  80018a:	89 de                	mov    %ebx,%esi
  80018c:	89 d1                	mov    %edx,%ecx
  80018e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2CS[] = "flight2CS";
  800190:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  800196:	bb 9a 38 80 00       	mov    $0x80389a,%ebx
  80019b:	ba 0a 00 00 00       	mov    $0xa,%edx
  8001a0:	89 c7                	mov    %eax,%edi
  8001a2:	89 de                	mov    %ebx,%esi
  8001a4:	89 d1                	mov    %edx,%ecx
  8001a6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _clerk[] = "clerk";
  8001a8:	c7 85 e3 fe ff ff 63 	movl   $0x72656c63,-0x11d(%ebp)
  8001af:	6c 65 72 
  8001b2:	66 c7 85 e7 fe ff ff 	movw   $0x6b,-0x119(%ebp)
  8001b9:	6b 00 
	char _custCounterCS[] = "custCounterCS";
  8001bb:	8d 85 d5 fe ff ff    	lea    -0x12b(%ebp),%eax
  8001c1:	bb a4 38 80 00       	mov    $0x8038a4,%ebx
  8001c6:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001cb:	89 c7                	mov    %eax,%edi
  8001cd:	89 de                	mov    %ebx,%esi
  8001cf:	89 d1                	mov    %edx,%ecx
  8001d1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custTerminated[] = "custTerminated";
  8001d3:	8d 85 c6 fe ff ff    	lea    -0x13a(%ebp),%eax
  8001d9:	bb b2 38 80 00       	mov    $0x8038b2,%ebx
  8001de:	ba 0f 00 00 00       	mov    $0xf,%edx
  8001e3:	89 c7                	mov    %eax,%edi
  8001e5:	89 de                	mov    %ebx,%esi
  8001e7:	89 d1                	mov    %edx,%ecx
  8001e9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _taircl[] = "taircl";
  8001eb:	8d 85 bf fe ff ff    	lea    -0x141(%ebp),%eax
  8001f1:	bb c1 38 80 00       	mov    $0x8038c1,%ebx
  8001f6:	ba 07 00 00 00       	mov    $0x7,%edx
  8001fb:	89 c7                	mov    %eax,%edi
  8001fd:	89 de                	mov    %ebx,%esi
  8001ff:	89 d1                	mov    %edx,%ecx
  800201:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _taircu[] = "taircu";
  800203:	8d 85 b8 fe ff ff    	lea    -0x148(%ebp),%eax
  800209:	bb c8 38 80 00       	mov    $0x8038c8,%ebx
  80020e:	ba 07 00 00 00       	mov    $0x7,%edx
  800213:	89 c7                	mov    %eax,%edi
  800215:	89 de                	mov    %ebx,%esi
  800217:	89 d1                	mov    %edx,%ecx
  800219:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	struct Customer * customers = sget(parentenvID, _customers);
  80021b:	83 ec 08             	sub    $0x8,%esp
  80021e:	8d 45 ae             	lea    -0x52(%ebp),%eax
  800221:	50                   	push   %eax
  800222:	ff 75 e4             	pushl  -0x1c(%ebp)
  800225:	e8 57 19 00 00       	call   801b81 <sget>
  80022a:	83 c4 10             	add    $0x10,%esp
  80022d:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int* flight1Counter = sget(parentenvID, _flight1Counter);
  800230:	83 ec 08             	sub    $0x8,%esp
  800233:	8d 45 93             	lea    -0x6d(%ebp),%eax
  800236:	50                   	push   %eax
  800237:	ff 75 e4             	pushl  -0x1c(%ebp)
  80023a:	e8 42 19 00 00       	call   801b81 <sget>
  80023f:	83 c4 10             	add    $0x10,%esp
  800242:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int* flight2Counter = sget(parentenvID, _flight2Counter);
  800245:	83 ec 08             	sub    $0x8,%esp
  800248:	8d 45 84             	lea    -0x7c(%ebp),%eax
  80024b:	50                   	push   %eax
  80024c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80024f:	e8 2d 19 00 00       	call   801b81 <sget>
  800254:	83 c4 10             	add    $0x10,%esp
  800257:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* flight1BookedCounter = sget(parentenvID, _flightBooked1Counter);
  80025a:	83 ec 08             	sub    $0x8,%esp
  80025d:	8d 85 6f ff ff ff    	lea    -0x91(%ebp),%eax
  800263:	50                   	push   %eax
  800264:	ff 75 e4             	pushl  -0x1c(%ebp)
  800267:	e8 15 19 00 00       	call   801b81 <sget>
  80026c:	83 c4 10             	add    $0x10,%esp
  80026f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	int* flight2BookedCounter = sget(parentenvID, _flightBooked2Counter);
  800272:	83 ec 08             	sub    $0x8,%esp
  800275:	8d 85 5a ff ff ff    	lea    -0xa6(%ebp),%eax
  80027b:	50                   	push   %eax
  80027c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80027f:	e8 fd 18 00 00       	call   801b81 <sget>
  800284:	83 c4 10             	add    $0x10,%esp
  800287:	89 45 d0             	mov    %eax,-0x30(%ebp)

	int* flight1BookedArr = sget(parentenvID, _flightBooked1Arr);
  80028a:	83 ec 08             	sub    $0x8,%esp
  80028d:	8d 85 49 ff ff ff    	lea    -0xb7(%ebp),%eax
  800293:	50                   	push   %eax
  800294:	ff 75 e4             	pushl  -0x1c(%ebp)
  800297:	e8 e5 18 00 00       	call   801b81 <sget>
  80029c:	83 c4 10             	add    $0x10,%esp
  80029f:	89 45 cc             	mov    %eax,-0x34(%ebp)
	int* flight2BookedArr = sget(parentenvID, _flightBooked2Arr);
  8002a2:	83 ec 08             	sub    $0x8,%esp
  8002a5:	8d 85 38 ff ff ff    	lea    -0xc8(%ebp),%eax
  8002ab:	50                   	push   %eax
  8002ac:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002af:	e8 cd 18 00 00       	call   801b81 <sget>
  8002b4:	83 c4 10             	add    $0x10,%esp
  8002b7:	89 45 c8             	mov    %eax,-0x38(%ebp)

	int* cust_ready_queue = sget(parentenvID, _cust_ready_queue);
  8002ba:	83 ec 08             	sub    $0x8,%esp
  8002bd:	8d 85 27 ff ff ff    	lea    -0xd9(%ebp),%eax
  8002c3:	50                   	push   %eax
  8002c4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002c7:	e8 b5 18 00 00       	call   801b81 <sget>
  8002cc:	83 c4 10             	add    $0x10,%esp
  8002cf:	89 45 c4             	mov    %eax,-0x3c(%ebp)

	int* queue_out = sget(parentenvID, _queue_out);
  8002d2:	83 ec 08             	sub    $0x8,%esp
  8002d5:	8d 85 14 ff ff ff    	lea    -0xec(%ebp),%eax
  8002db:	50                   	push   %eax
  8002dc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002df:	e8 9d 18 00 00       	call   801b81 <sget>
  8002e4:	83 c4 10             	add    $0x10,%esp
  8002e7:	89 45 c0             	mov    %eax,-0x40(%ebp)

	while(1==1)
	{
		int custId;
		//wait for a customer
		sys_waitSemaphore(parentenvID, _cust_ready);
  8002ea:	83 ec 08             	sub    $0x8,%esp
  8002ed:	8d 85 09 ff ff ff    	lea    -0xf7(%ebp),%eax
  8002f3:	50                   	push   %eax
  8002f4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002f7:	e8 5f 1c 00 00       	call   801f5b <sys_waitSemaphore>
  8002fc:	83 c4 10             	add    $0x10,%esp

		//dequeue the customer info
		sys_waitSemaphore(parentenvID, _custQueueCS);
  8002ff:	83 ec 08             	sub    $0x8,%esp
  800302:	8d 85 fd fe ff ff    	lea    -0x103(%ebp),%eax
  800308:	50                   	push   %eax
  800309:	ff 75 e4             	pushl  -0x1c(%ebp)
  80030c:	e8 4a 1c 00 00       	call   801f5b <sys_waitSemaphore>
  800311:	83 c4 10             	add    $0x10,%esp
		{
			//cprintf("*queue_out = %d\n", *queue_out);
			custId = cust_ready_queue[*queue_out];
  800314:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800317:	8b 00                	mov    (%eax),%eax
  800319:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800320:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800323:	01 d0                	add    %edx,%eax
  800325:	8b 00                	mov    (%eax),%eax
  800327:	89 45 bc             	mov    %eax,-0x44(%ebp)
			*queue_out = *queue_out +1;
  80032a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80032d:	8b 00                	mov    (%eax),%eax
  80032f:	8d 50 01             	lea    0x1(%eax),%edx
  800332:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800335:	89 10                	mov    %edx,(%eax)
		}
		sys_signalSemaphore(parentenvID, _custQueueCS);
  800337:	83 ec 08             	sub    $0x8,%esp
  80033a:	8d 85 fd fe ff ff    	lea    -0x103(%ebp),%eax
  800340:	50                   	push   %eax
  800341:	ff 75 e4             	pushl  -0x1c(%ebp)
  800344:	e8 30 1c 00 00       	call   801f79 <sys_signalSemaphore>
  800349:	83 c4 10             	add    $0x10,%esp

		//try reserving on the required flight
		int custFlightType = customers[custId].flightType;
  80034c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80034f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800356:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800359:	01 d0                	add    %edx,%eax
  80035b:	8b 00                	mov    (%eax),%eax
  80035d:	89 45 b8             	mov    %eax,-0x48(%ebp)
		//cprintf("custId dequeued = %d, ft = %d\n", custId, customers[custId].flightType);

		switch (custFlightType)
  800360:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800363:	83 f8 02             	cmp    $0x2,%eax
  800366:	0f 84 90 00 00 00    	je     8003fc <_main+0x3c4>
  80036c:	83 f8 03             	cmp    $0x3,%eax
  80036f:	0f 84 05 01 00 00    	je     80047a <_main+0x442>
  800375:	83 f8 01             	cmp    $0x1,%eax
  800378:	0f 85 f8 01 00 00    	jne    800576 <_main+0x53e>
		{
		case 1:
		{
			//Check and update Flight1
			sys_waitSemaphore(parentenvID, _flight1CS);
  80037e:	83 ec 08             	sub    $0x8,%esp
  800381:	8d 85 f3 fe ff ff    	lea    -0x10d(%ebp),%eax
  800387:	50                   	push   %eax
  800388:	ff 75 e4             	pushl  -0x1c(%ebp)
  80038b:	e8 cb 1b 00 00       	call   801f5b <sys_waitSemaphore>
  800390:	83 c4 10             	add    $0x10,%esp
			{
				if(*flight1Counter > 0)
  800393:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800396:	8b 00                	mov    (%eax),%eax
  800398:	85 c0                	test   %eax,%eax
  80039a:	7e 46                	jle    8003e2 <_main+0x3aa>
				{
					*flight1Counter = *flight1Counter - 1;
  80039c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80039f:	8b 00                	mov    (%eax),%eax
  8003a1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8003a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003a7:	89 10                	mov    %edx,(%eax)
					customers[custId].booked = 1;
  8003a9:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8003ac:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8003b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003b6:	01 d0                	add    %edx,%eax
  8003b8:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
					flight1BookedArr[*flight1BookedCounter] = custId;
  8003bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003c2:	8b 00                	mov    (%eax),%eax
  8003c4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003cb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8003ce:	01 c2                	add    %eax,%edx
  8003d0:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8003d3:	89 02                	mov    %eax,(%edx)
					*flight1BookedCounter =*flight1BookedCounter+1;
  8003d5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003d8:	8b 00                	mov    (%eax),%eax
  8003da:	8d 50 01             	lea    0x1(%eax),%edx
  8003dd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003e0:	89 10                	mov    %edx,(%eax)
				else
				{

				}
			}
			sys_signalSemaphore(parentenvID, _flight1CS);
  8003e2:	83 ec 08             	sub    $0x8,%esp
  8003e5:	8d 85 f3 fe ff ff    	lea    -0x10d(%ebp),%eax
  8003eb:	50                   	push   %eax
  8003ec:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003ef:	e8 85 1b 00 00       	call   801f79 <sys_signalSemaphore>
  8003f4:	83 c4 10             	add    $0x10,%esp
		}

		break;
  8003f7:	e9 91 01 00 00       	jmp    80058d <_main+0x555>
		case 2:
		{
			//Check and update Flight2
			sys_waitSemaphore(parentenvID, _flight2CS);
  8003fc:	83 ec 08             	sub    $0x8,%esp
  8003ff:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  800405:	50                   	push   %eax
  800406:	ff 75 e4             	pushl  -0x1c(%ebp)
  800409:	e8 4d 1b 00 00       	call   801f5b <sys_waitSemaphore>
  80040e:	83 c4 10             	add    $0x10,%esp
			{
				if(*flight2Counter > 0)
  800411:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800414:	8b 00                	mov    (%eax),%eax
  800416:	85 c0                	test   %eax,%eax
  800418:	7e 46                	jle    800460 <_main+0x428>
				{
					*flight2Counter = *flight2Counter - 1;
  80041a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80041d:	8b 00                	mov    (%eax),%eax
  80041f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800422:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800425:	89 10                	mov    %edx,(%eax)
					customers[custId].booked = 1;
  800427:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80042a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800431:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800434:	01 d0                	add    %edx,%eax
  800436:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
					flight2BookedArr[*flight2BookedCounter] = custId;
  80043d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800440:	8b 00                	mov    (%eax),%eax
  800442:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800449:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80044c:	01 c2                	add    %eax,%edx
  80044e:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800451:	89 02                	mov    %eax,(%edx)
					*flight2BookedCounter =*flight2BookedCounter+1;
  800453:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800456:	8b 00                	mov    (%eax),%eax
  800458:	8d 50 01             	lea    0x1(%eax),%edx
  80045b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80045e:	89 10                	mov    %edx,(%eax)
				else
				{

				}
			}
			sys_signalSemaphore(parentenvID, _flight2CS);
  800460:	83 ec 08             	sub    $0x8,%esp
  800463:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  800469:	50                   	push   %eax
  80046a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80046d:	e8 07 1b 00 00       	call   801f79 <sys_signalSemaphore>
  800472:	83 c4 10             	add    $0x10,%esp
		}
		break;
  800475:	e9 13 01 00 00       	jmp    80058d <_main+0x555>
		case 3:
		{
			//Check and update Both Flights
			sys_waitSemaphore(parentenvID, _flight1CS); sys_waitSemaphore(parentenvID, _flight2CS);
  80047a:	83 ec 08             	sub    $0x8,%esp
  80047d:	8d 85 f3 fe ff ff    	lea    -0x10d(%ebp),%eax
  800483:	50                   	push   %eax
  800484:	ff 75 e4             	pushl  -0x1c(%ebp)
  800487:	e8 cf 1a 00 00       	call   801f5b <sys_waitSemaphore>
  80048c:	83 c4 10             	add    $0x10,%esp
  80048f:	83 ec 08             	sub    $0x8,%esp
  800492:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  800498:	50                   	push   %eax
  800499:	ff 75 e4             	pushl  -0x1c(%ebp)
  80049c:	e8 ba 1a 00 00       	call   801f5b <sys_waitSemaphore>
  8004a1:	83 c4 10             	add    $0x10,%esp
			{
				if(*flight1Counter > 0 && *flight2Counter >0 )
  8004a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004a7:	8b 00                	mov    (%eax),%eax
  8004a9:	85 c0                	test   %eax,%eax
  8004ab:	0f 8e 99 00 00 00    	jle    80054a <_main+0x512>
  8004b1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004b4:	8b 00                	mov    (%eax),%eax
  8004b6:	85 c0                	test   %eax,%eax
  8004b8:	0f 8e 8c 00 00 00    	jle    80054a <_main+0x512>
				{
					*flight1Counter = *flight1Counter - 1;
  8004be:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004c1:	8b 00                	mov    (%eax),%eax
  8004c3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8004c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004c9:	89 10                	mov    %edx,(%eax)
					customers[custId].booked = 1;
  8004cb:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8004ce:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8004d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004d8:	01 d0                	add    %edx,%eax
  8004da:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
					flight1BookedArr[*flight1BookedCounter] = custId;
  8004e1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8004e4:	8b 00                	mov    (%eax),%eax
  8004e6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004ed:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004f0:	01 c2                	add    %eax,%edx
  8004f2:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8004f5:	89 02                	mov    %eax,(%edx)
					*flight1BookedCounter =*flight1BookedCounter+1;
  8004f7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8004fa:	8b 00                	mov    (%eax),%eax
  8004fc:	8d 50 01             	lea    0x1(%eax),%edx
  8004ff:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800502:	89 10                	mov    %edx,(%eax)

					*flight2Counter = *flight2Counter - 1;
  800504:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800507:	8b 00                	mov    (%eax),%eax
  800509:	8d 50 ff             	lea    -0x1(%eax),%edx
  80050c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80050f:	89 10                	mov    %edx,(%eax)
					customers[custId].booked = 1;
  800511:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800514:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80051b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80051e:	01 d0                	add    %edx,%eax
  800520:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
					flight2BookedArr[*flight2BookedCounter] = custId;
  800527:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80052a:	8b 00                	mov    (%eax),%eax
  80052c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800533:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800536:	01 c2                	add    %eax,%edx
  800538:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80053b:	89 02                	mov    %eax,(%edx)
					*flight2BookedCounter =*flight2BookedCounter+1;
  80053d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800540:	8b 00                	mov    (%eax),%eax
  800542:	8d 50 01             	lea    0x1(%eax),%edx
  800545:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800548:	89 10                	mov    %edx,(%eax)
				else
				{

				}
			}
			sys_signalSemaphore(parentenvID, _flight2CS); sys_signalSemaphore(parentenvID, _flight1CS);
  80054a:	83 ec 08             	sub    $0x8,%esp
  80054d:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  800553:	50                   	push   %eax
  800554:	ff 75 e4             	pushl  -0x1c(%ebp)
  800557:	e8 1d 1a 00 00       	call   801f79 <sys_signalSemaphore>
  80055c:	83 c4 10             	add    $0x10,%esp
  80055f:	83 ec 08             	sub    $0x8,%esp
  800562:	8d 85 f3 fe ff ff    	lea    -0x10d(%ebp),%eax
  800568:	50                   	push   %eax
  800569:	ff 75 e4             	pushl  -0x1c(%ebp)
  80056c:	e8 08 1a 00 00       	call   801f79 <sys_signalSemaphore>
  800571:	83 c4 10             	add    $0x10,%esp
		}
		break;
  800574:	eb 17                	jmp    80058d <_main+0x555>
		default:
			panic("customer must have flight type\n");
  800576:	83 ec 04             	sub    $0x4,%esp
  800579:	68 a0 37 80 00       	push   $0x8037a0
  80057e:	68 8f 00 00 00       	push   $0x8f
  800583:	68 c0 37 80 00       	push   $0x8037c0
  800588:	e8 cc 01 00 00       	call   800759 <_panic>
		}

		//signal finished
		char prefix[30]="cust_finished";
  80058d:	8d 85 9a fe ff ff    	lea    -0x166(%ebp),%eax
  800593:	bb cf 38 80 00       	mov    $0x8038cf,%ebx
  800598:	ba 0e 00 00 00       	mov    $0xe,%edx
  80059d:	89 c7                	mov    %eax,%edi
  80059f:	89 de                	mov    %ebx,%esi
  8005a1:	89 d1                	mov    %edx,%ecx
  8005a3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8005a5:	8d 95 a8 fe ff ff    	lea    -0x158(%ebp),%edx
  8005ab:	b9 04 00 00 00       	mov    $0x4,%ecx
  8005b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8005b5:	89 d7                	mov    %edx,%edi
  8005b7:	f3 ab                	rep stos %eax,%es:(%edi)
		char id[5]; char sname[50];
		ltostr(custId, id);
  8005b9:	83 ec 08             	sub    $0x8,%esp
  8005bc:	8d 85 95 fe ff ff    	lea    -0x16b(%ebp),%eax
  8005c2:	50                   	push   %eax
  8005c3:	ff 75 bc             	pushl  -0x44(%ebp)
  8005c6:	e8 6a 0f 00 00       	call   801535 <ltostr>
  8005cb:	83 c4 10             	add    $0x10,%esp
		strcconcat(prefix, id, sname);
  8005ce:	83 ec 04             	sub    $0x4,%esp
  8005d1:	8d 85 63 fe ff ff    	lea    -0x19d(%ebp),%eax
  8005d7:	50                   	push   %eax
  8005d8:	8d 85 95 fe ff ff    	lea    -0x16b(%ebp),%eax
  8005de:	50                   	push   %eax
  8005df:	8d 85 9a fe ff ff    	lea    -0x166(%ebp),%eax
  8005e5:	50                   	push   %eax
  8005e6:	e8 42 10 00 00       	call   80162d <strcconcat>
  8005eb:	83 c4 10             	add    $0x10,%esp
		sys_signalSemaphore(parentenvID, sname);
  8005ee:	83 ec 08             	sub    $0x8,%esp
  8005f1:	8d 85 63 fe ff ff    	lea    -0x19d(%ebp),%eax
  8005f7:	50                   	push   %eax
  8005f8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8005fb:	e8 79 19 00 00       	call   801f79 <sys_signalSemaphore>
  800600:	83 c4 10             	add    $0x10,%esp

		//signal the clerk
		sys_signalSemaphore(parentenvID, _clerk);
  800603:	83 ec 08             	sub    $0x8,%esp
  800606:	8d 85 e3 fe ff ff    	lea    -0x11d(%ebp),%eax
  80060c:	50                   	push   %eax
  80060d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800610:	e8 64 19 00 00       	call   801f79 <sys_signalSemaphore>
  800615:	83 c4 10             	add    $0x10,%esp
	}
  800618:	e9 cd fc ff ff       	jmp    8002ea <_main+0x2b2>

0080061d <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80061d:	55                   	push   %ebp
  80061e:	89 e5                	mov    %esp,%ebp
  800620:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800623:	e8 79 1a 00 00       	call   8020a1 <sys_getenvindex>
  800628:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80062b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80062e:	89 d0                	mov    %edx,%eax
  800630:	c1 e0 03             	shl    $0x3,%eax
  800633:	01 d0                	add    %edx,%eax
  800635:	01 c0                	add    %eax,%eax
  800637:	01 d0                	add    %edx,%eax
  800639:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800640:	01 d0                	add    %edx,%eax
  800642:	c1 e0 04             	shl    $0x4,%eax
  800645:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80064a:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80064f:	a1 20 50 80 00       	mov    0x805020,%eax
  800654:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80065a:	84 c0                	test   %al,%al
  80065c:	74 0f                	je     80066d <libmain+0x50>
		binaryname = myEnv->prog_name;
  80065e:	a1 20 50 80 00       	mov    0x805020,%eax
  800663:	05 5c 05 00 00       	add    $0x55c,%eax
  800668:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80066d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800671:	7e 0a                	jle    80067d <libmain+0x60>
		binaryname = argv[0];
  800673:	8b 45 0c             	mov    0xc(%ebp),%eax
  800676:	8b 00                	mov    (%eax),%eax
  800678:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  80067d:	83 ec 08             	sub    $0x8,%esp
  800680:	ff 75 0c             	pushl  0xc(%ebp)
  800683:	ff 75 08             	pushl  0x8(%ebp)
  800686:	e8 ad f9 ff ff       	call   800038 <_main>
  80068b:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80068e:	e8 1b 18 00 00       	call   801eae <sys_disable_interrupt>
	cprintf("**************************************\n");
  800693:	83 ec 0c             	sub    $0xc,%esp
  800696:	68 08 39 80 00       	push   $0x803908
  80069b:	e8 6d 03 00 00       	call   800a0d <cprintf>
  8006a0:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8006a3:	a1 20 50 80 00       	mov    0x805020,%eax
  8006a8:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8006ae:	a1 20 50 80 00       	mov    0x805020,%eax
  8006b3:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8006b9:	83 ec 04             	sub    $0x4,%esp
  8006bc:	52                   	push   %edx
  8006bd:	50                   	push   %eax
  8006be:	68 30 39 80 00       	push   $0x803930
  8006c3:	e8 45 03 00 00       	call   800a0d <cprintf>
  8006c8:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8006cb:	a1 20 50 80 00       	mov    0x805020,%eax
  8006d0:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8006d6:	a1 20 50 80 00       	mov    0x805020,%eax
  8006db:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8006e1:	a1 20 50 80 00       	mov    0x805020,%eax
  8006e6:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8006ec:	51                   	push   %ecx
  8006ed:	52                   	push   %edx
  8006ee:	50                   	push   %eax
  8006ef:	68 58 39 80 00       	push   $0x803958
  8006f4:	e8 14 03 00 00       	call   800a0d <cprintf>
  8006f9:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8006fc:	a1 20 50 80 00       	mov    0x805020,%eax
  800701:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800707:	83 ec 08             	sub    $0x8,%esp
  80070a:	50                   	push   %eax
  80070b:	68 b0 39 80 00       	push   $0x8039b0
  800710:	e8 f8 02 00 00       	call   800a0d <cprintf>
  800715:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800718:	83 ec 0c             	sub    $0xc,%esp
  80071b:	68 08 39 80 00       	push   $0x803908
  800720:	e8 e8 02 00 00       	call   800a0d <cprintf>
  800725:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800728:	e8 9b 17 00 00       	call   801ec8 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80072d:	e8 19 00 00 00       	call   80074b <exit>
}
  800732:	90                   	nop
  800733:	c9                   	leave  
  800734:	c3                   	ret    

00800735 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800735:	55                   	push   %ebp
  800736:	89 e5                	mov    %esp,%ebp
  800738:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80073b:	83 ec 0c             	sub    $0xc,%esp
  80073e:	6a 00                	push   $0x0
  800740:	e8 28 19 00 00       	call   80206d <sys_destroy_env>
  800745:	83 c4 10             	add    $0x10,%esp
}
  800748:	90                   	nop
  800749:	c9                   	leave  
  80074a:	c3                   	ret    

0080074b <exit>:

void
exit(void)
{
  80074b:	55                   	push   %ebp
  80074c:	89 e5                	mov    %esp,%ebp
  80074e:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800751:	e8 7d 19 00 00       	call   8020d3 <sys_exit_env>
}
  800756:	90                   	nop
  800757:	c9                   	leave  
  800758:	c3                   	ret    

00800759 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800759:	55                   	push   %ebp
  80075a:	89 e5                	mov    %esp,%ebp
  80075c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80075f:	8d 45 10             	lea    0x10(%ebp),%eax
  800762:	83 c0 04             	add    $0x4,%eax
  800765:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800768:	a1 5c 51 80 00       	mov    0x80515c,%eax
  80076d:	85 c0                	test   %eax,%eax
  80076f:	74 16                	je     800787 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800771:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800776:	83 ec 08             	sub    $0x8,%esp
  800779:	50                   	push   %eax
  80077a:	68 c4 39 80 00       	push   $0x8039c4
  80077f:	e8 89 02 00 00       	call   800a0d <cprintf>
  800784:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800787:	a1 00 50 80 00       	mov    0x805000,%eax
  80078c:	ff 75 0c             	pushl  0xc(%ebp)
  80078f:	ff 75 08             	pushl  0x8(%ebp)
  800792:	50                   	push   %eax
  800793:	68 c9 39 80 00       	push   $0x8039c9
  800798:	e8 70 02 00 00       	call   800a0d <cprintf>
  80079d:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8007a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8007a3:	83 ec 08             	sub    $0x8,%esp
  8007a6:	ff 75 f4             	pushl  -0xc(%ebp)
  8007a9:	50                   	push   %eax
  8007aa:	e8 f3 01 00 00       	call   8009a2 <vcprintf>
  8007af:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8007b2:	83 ec 08             	sub    $0x8,%esp
  8007b5:	6a 00                	push   $0x0
  8007b7:	68 e5 39 80 00       	push   $0x8039e5
  8007bc:	e8 e1 01 00 00       	call   8009a2 <vcprintf>
  8007c1:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8007c4:	e8 82 ff ff ff       	call   80074b <exit>

	// should not return here
	while (1) ;
  8007c9:	eb fe                	jmp    8007c9 <_panic+0x70>

008007cb <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8007cb:	55                   	push   %ebp
  8007cc:	89 e5                	mov    %esp,%ebp
  8007ce:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8007d1:	a1 20 50 80 00       	mov    0x805020,%eax
  8007d6:	8b 50 74             	mov    0x74(%eax),%edx
  8007d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007dc:	39 c2                	cmp    %eax,%edx
  8007de:	74 14                	je     8007f4 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8007e0:	83 ec 04             	sub    $0x4,%esp
  8007e3:	68 e8 39 80 00       	push   $0x8039e8
  8007e8:	6a 26                	push   $0x26
  8007ea:	68 34 3a 80 00       	push   $0x803a34
  8007ef:	e8 65 ff ff ff       	call   800759 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8007f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8007fb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800802:	e9 c2 00 00 00       	jmp    8008c9 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800807:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80080a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800811:	8b 45 08             	mov    0x8(%ebp),%eax
  800814:	01 d0                	add    %edx,%eax
  800816:	8b 00                	mov    (%eax),%eax
  800818:	85 c0                	test   %eax,%eax
  80081a:	75 08                	jne    800824 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80081c:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80081f:	e9 a2 00 00 00       	jmp    8008c6 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800824:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80082b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800832:	eb 69                	jmp    80089d <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800834:	a1 20 50 80 00       	mov    0x805020,%eax
  800839:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80083f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800842:	89 d0                	mov    %edx,%eax
  800844:	01 c0                	add    %eax,%eax
  800846:	01 d0                	add    %edx,%eax
  800848:	c1 e0 03             	shl    $0x3,%eax
  80084b:	01 c8                	add    %ecx,%eax
  80084d:	8a 40 04             	mov    0x4(%eax),%al
  800850:	84 c0                	test   %al,%al
  800852:	75 46                	jne    80089a <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800854:	a1 20 50 80 00       	mov    0x805020,%eax
  800859:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80085f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800862:	89 d0                	mov    %edx,%eax
  800864:	01 c0                	add    %eax,%eax
  800866:	01 d0                	add    %edx,%eax
  800868:	c1 e0 03             	shl    $0x3,%eax
  80086b:	01 c8                	add    %ecx,%eax
  80086d:	8b 00                	mov    (%eax),%eax
  80086f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800872:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800875:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80087a:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80087c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80087f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800886:	8b 45 08             	mov    0x8(%ebp),%eax
  800889:	01 c8                	add    %ecx,%eax
  80088b:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80088d:	39 c2                	cmp    %eax,%edx
  80088f:	75 09                	jne    80089a <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800891:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800898:	eb 12                	jmp    8008ac <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80089a:	ff 45 e8             	incl   -0x18(%ebp)
  80089d:	a1 20 50 80 00       	mov    0x805020,%eax
  8008a2:	8b 50 74             	mov    0x74(%eax),%edx
  8008a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008a8:	39 c2                	cmp    %eax,%edx
  8008aa:	77 88                	ja     800834 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8008ac:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8008b0:	75 14                	jne    8008c6 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8008b2:	83 ec 04             	sub    $0x4,%esp
  8008b5:	68 40 3a 80 00       	push   $0x803a40
  8008ba:	6a 3a                	push   $0x3a
  8008bc:	68 34 3a 80 00       	push   $0x803a34
  8008c1:	e8 93 fe ff ff       	call   800759 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8008c6:	ff 45 f0             	incl   -0x10(%ebp)
  8008c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008cc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8008cf:	0f 8c 32 ff ff ff    	jl     800807 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8008d5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008dc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8008e3:	eb 26                	jmp    80090b <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8008e5:	a1 20 50 80 00       	mov    0x805020,%eax
  8008ea:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8008f0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008f3:	89 d0                	mov    %edx,%eax
  8008f5:	01 c0                	add    %eax,%eax
  8008f7:	01 d0                	add    %edx,%eax
  8008f9:	c1 e0 03             	shl    $0x3,%eax
  8008fc:	01 c8                	add    %ecx,%eax
  8008fe:	8a 40 04             	mov    0x4(%eax),%al
  800901:	3c 01                	cmp    $0x1,%al
  800903:	75 03                	jne    800908 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800905:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800908:	ff 45 e0             	incl   -0x20(%ebp)
  80090b:	a1 20 50 80 00       	mov    0x805020,%eax
  800910:	8b 50 74             	mov    0x74(%eax),%edx
  800913:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800916:	39 c2                	cmp    %eax,%edx
  800918:	77 cb                	ja     8008e5 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80091a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80091d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800920:	74 14                	je     800936 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800922:	83 ec 04             	sub    $0x4,%esp
  800925:	68 94 3a 80 00       	push   $0x803a94
  80092a:	6a 44                	push   $0x44
  80092c:	68 34 3a 80 00       	push   $0x803a34
  800931:	e8 23 fe ff ff       	call   800759 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800936:	90                   	nop
  800937:	c9                   	leave  
  800938:	c3                   	ret    

00800939 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800939:	55                   	push   %ebp
  80093a:	89 e5                	mov    %esp,%ebp
  80093c:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80093f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800942:	8b 00                	mov    (%eax),%eax
  800944:	8d 48 01             	lea    0x1(%eax),%ecx
  800947:	8b 55 0c             	mov    0xc(%ebp),%edx
  80094a:	89 0a                	mov    %ecx,(%edx)
  80094c:	8b 55 08             	mov    0x8(%ebp),%edx
  80094f:	88 d1                	mov    %dl,%cl
  800951:	8b 55 0c             	mov    0xc(%ebp),%edx
  800954:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800958:	8b 45 0c             	mov    0xc(%ebp),%eax
  80095b:	8b 00                	mov    (%eax),%eax
  80095d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800962:	75 2c                	jne    800990 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800964:	a0 24 50 80 00       	mov    0x805024,%al
  800969:	0f b6 c0             	movzbl %al,%eax
  80096c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80096f:	8b 12                	mov    (%edx),%edx
  800971:	89 d1                	mov    %edx,%ecx
  800973:	8b 55 0c             	mov    0xc(%ebp),%edx
  800976:	83 c2 08             	add    $0x8,%edx
  800979:	83 ec 04             	sub    $0x4,%esp
  80097c:	50                   	push   %eax
  80097d:	51                   	push   %ecx
  80097e:	52                   	push   %edx
  80097f:	e8 7c 13 00 00       	call   801d00 <sys_cputs>
  800984:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800987:	8b 45 0c             	mov    0xc(%ebp),%eax
  80098a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800990:	8b 45 0c             	mov    0xc(%ebp),%eax
  800993:	8b 40 04             	mov    0x4(%eax),%eax
  800996:	8d 50 01             	lea    0x1(%eax),%edx
  800999:	8b 45 0c             	mov    0xc(%ebp),%eax
  80099c:	89 50 04             	mov    %edx,0x4(%eax)
}
  80099f:	90                   	nop
  8009a0:	c9                   	leave  
  8009a1:	c3                   	ret    

008009a2 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8009a2:	55                   	push   %ebp
  8009a3:	89 e5                	mov    %esp,%ebp
  8009a5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8009ab:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8009b2:	00 00 00 
	b.cnt = 0;
  8009b5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8009bc:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8009bf:	ff 75 0c             	pushl  0xc(%ebp)
  8009c2:	ff 75 08             	pushl  0x8(%ebp)
  8009c5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009cb:	50                   	push   %eax
  8009cc:	68 39 09 80 00       	push   $0x800939
  8009d1:	e8 11 02 00 00       	call   800be7 <vprintfmt>
  8009d6:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8009d9:	a0 24 50 80 00       	mov    0x805024,%al
  8009de:	0f b6 c0             	movzbl %al,%eax
  8009e1:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8009e7:	83 ec 04             	sub    $0x4,%esp
  8009ea:	50                   	push   %eax
  8009eb:	52                   	push   %edx
  8009ec:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009f2:	83 c0 08             	add    $0x8,%eax
  8009f5:	50                   	push   %eax
  8009f6:	e8 05 13 00 00       	call   801d00 <sys_cputs>
  8009fb:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8009fe:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800a05:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a0b:	c9                   	leave  
  800a0c:	c3                   	ret    

00800a0d <cprintf>:

int cprintf(const char *fmt, ...) {
  800a0d:	55                   	push   %ebp
  800a0e:	89 e5                	mov    %esp,%ebp
  800a10:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a13:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800a1a:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a20:	8b 45 08             	mov    0x8(%ebp),%eax
  800a23:	83 ec 08             	sub    $0x8,%esp
  800a26:	ff 75 f4             	pushl  -0xc(%ebp)
  800a29:	50                   	push   %eax
  800a2a:	e8 73 ff ff ff       	call   8009a2 <vcprintf>
  800a2f:	83 c4 10             	add    $0x10,%esp
  800a32:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800a35:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a38:	c9                   	leave  
  800a39:	c3                   	ret    

00800a3a <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800a3a:	55                   	push   %ebp
  800a3b:	89 e5                	mov    %esp,%ebp
  800a3d:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800a40:	e8 69 14 00 00       	call   801eae <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800a45:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a48:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4e:	83 ec 08             	sub    $0x8,%esp
  800a51:	ff 75 f4             	pushl  -0xc(%ebp)
  800a54:	50                   	push   %eax
  800a55:	e8 48 ff ff ff       	call   8009a2 <vcprintf>
  800a5a:	83 c4 10             	add    $0x10,%esp
  800a5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800a60:	e8 63 14 00 00       	call   801ec8 <sys_enable_interrupt>
	return cnt;
  800a65:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a68:	c9                   	leave  
  800a69:	c3                   	ret    

00800a6a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a6a:	55                   	push   %ebp
  800a6b:	89 e5                	mov    %esp,%ebp
  800a6d:	53                   	push   %ebx
  800a6e:	83 ec 14             	sub    $0x14,%esp
  800a71:	8b 45 10             	mov    0x10(%ebp),%eax
  800a74:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a77:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a7d:	8b 45 18             	mov    0x18(%ebp),%eax
  800a80:	ba 00 00 00 00       	mov    $0x0,%edx
  800a85:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a88:	77 55                	ja     800adf <printnum+0x75>
  800a8a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a8d:	72 05                	jb     800a94 <printnum+0x2a>
  800a8f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800a92:	77 4b                	ja     800adf <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a94:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800a97:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800a9a:	8b 45 18             	mov    0x18(%ebp),%eax
  800a9d:	ba 00 00 00 00       	mov    $0x0,%edx
  800aa2:	52                   	push   %edx
  800aa3:	50                   	push   %eax
  800aa4:	ff 75 f4             	pushl  -0xc(%ebp)
  800aa7:	ff 75 f0             	pushl  -0x10(%ebp)
  800aaa:	e8 81 2a 00 00       	call   803530 <__udivdi3>
  800aaf:	83 c4 10             	add    $0x10,%esp
  800ab2:	83 ec 04             	sub    $0x4,%esp
  800ab5:	ff 75 20             	pushl  0x20(%ebp)
  800ab8:	53                   	push   %ebx
  800ab9:	ff 75 18             	pushl  0x18(%ebp)
  800abc:	52                   	push   %edx
  800abd:	50                   	push   %eax
  800abe:	ff 75 0c             	pushl  0xc(%ebp)
  800ac1:	ff 75 08             	pushl  0x8(%ebp)
  800ac4:	e8 a1 ff ff ff       	call   800a6a <printnum>
  800ac9:	83 c4 20             	add    $0x20,%esp
  800acc:	eb 1a                	jmp    800ae8 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800ace:	83 ec 08             	sub    $0x8,%esp
  800ad1:	ff 75 0c             	pushl  0xc(%ebp)
  800ad4:	ff 75 20             	pushl  0x20(%ebp)
  800ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  800ada:	ff d0                	call   *%eax
  800adc:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800adf:	ff 4d 1c             	decl   0x1c(%ebp)
  800ae2:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800ae6:	7f e6                	jg     800ace <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800ae8:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800aeb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800af0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800af3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800af6:	53                   	push   %ebx
  800af7:	51                   	push   %ecx
  800af8:	52                   	push   %edx
  800af9:	50                   	push   %eax
  800afa:	e8 41 2b 00 00       	call   803640 <__umoddi3>
  800aff:	83 c4 10             	add    $0x10,%esp
  800b02:	05 f4 3c 80 00       	add    $0x803cf4,%eax
  800b07:	8a 00                	mov    (%eax),%al
  800b09:	0f be c0             	movsbl %al,%eax
  800b0c:	83 ec 08             	sub    $0x8,%esp
  800b0f:	ff 75 0c             	pushl  0xc(%ebp)
  800b12:	50                   	push   %eax
  800b13:	8b 45 08             	mov    0x8(%ebp),%eax
  800b16:	ff d0                	call   *%eax
  800b18:	83 c4 10             	add    $0x10,%esp
}
  800b1b:	90                   	nop
  800b1c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b1f:	c9                   	leave  
  800b20:	c3                   	ret    

00800b21 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b21:	55                   	push   %ebp
  800b22:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b24:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b28:	7e 1c                	jle    800b46 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800b2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2d:	8b 00                	mov    (%eax),%eax
  800b2f:	8d 50 08             	lea    0x8(%eax),%edx
  800b32:	8b 45 08             	mov    0x8(%ebp),%eax
  800b35:	89 10                	mov    %edx,(%eax)
  800b37:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3a:	8b 00                	mov    (%eax),%eax
  800b3c:	83 e8 08             	sub    $0x8,%eax
  800b3f:	8b 50 04             	mov    0x4(%eax),%edx
  800b42:	8b 00                	mov    (%eax),%eax
  800b44:	eb 40                	jmp    800b86 <getuint+0x65>
	else if (lflag)
  800b46:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b4a:	74 1e                	je     800b6a <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4f:	8b 00                	mov    (%eax),%eax
  800b51:	8d 50 04             	lea    0x4(%eax),%edx
  800b54:	8b 45 08             	mov    0x8(%ebp),%eax
  800b57:	89 10                	mov    %edx,(%eax)
  800b59:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5c:	8b 00                	mov    (%eax),%eax
  800b5e:	83 e8 04             	sub    $0x4,%eax
  800b61:	8b 00                	mov    (%eax),%eax
  800b63:	ba 00 00 00 00       	mov    $0x0,%edx
  800b68:	eb 1c                	jmp    800b86 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6d:	8b 00                	mov    (%eax),%eax
  800b6f:	8d 50 04             	lea    0x4(%eax),%edx
  800b72:	8b 45 08             	mov    0x8(%ebp),%eax
  800b75:	89 10                	mov    %edx,(%eax)
  800b77:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7a:	8b 00                	mov    (%eax),%eax
  800b7c:	83 e8 04             	sub    $0x4,%eax
  800b7f:	8b 00                	mov    (%eax),%eax
  800b81:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800b86:	5d                   	pop    %ebp
  800b87:	c3                   	ret    

00800b88 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800b88:	55                   	push   %ebp
  800b89:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b8b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b8f:	7e 1c                	jle    800bad <getint+0x25>
		return va_arg(*ap, long long);
  800b91:	8b 45 08             	mov    0x8(%ebp),%eax
  800b94:	8b 00                	mov    (%eax),%eax
  800b96:	8d 50 08             	lea    0x8(%eax),%edx
  800b99:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9c:	89 10                	mov    %edx,(%eax)
  800b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba1:	8b 00                	mov    (%eax),%eax
  800ba3:	83 e8 08             	sub    $0x8,%eax
  800ba6:	8b 50 04             	mov    0x4(%eax),%edx
  800ba9:	8b 00                	mov    (%eax),%eax
  800bab:	eb 38                	jmp    800be5 <getint+0x5d>
	else if (lflag)
  800bad:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bb1:	74 1a                	je     800bcd <getint+0x45>
		return va_arg(*ap, long);
  800bb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb6:	8b 00                	mov    (%eax),%eax
  800bb8:	8d 50 04             	lea    0x4(%eax),%edx
  800bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbe:	89 10                	mov    %edx,(%eax)
  800bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc3:	8b 00                	mov    (%eax),%eax
  800bc5:	83 e8 04             	sub    $0x4,%eax
  800bc8:	8b 00                	mov    (%eax),%eax
  800bca:	99                   	cltd   
  800bcb:	eb 18                	jmp    800be5 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd0:	8b 00                	mov    (%eax),%eax
  800bd2:	8d 50 04             	lea    0x4(%eax),%edx
  800bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd8:	89 10                	mov    %edx,(%eax)
  800bda:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdd:	8b 00                	mov    (%eax),%eax
  800bdf:	83 e8 04             	sub    $0x4,%eax
  800be2:	8b 00                	mov    (%eax),%eax
  800be4:	99                   	cltd   
}
  800be5:	5d                   	pop    %ebp
  800be6:	c3                   	ret    

00800be7 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800be7:	55                   	push   %ebp
  800be8:	89 e5                	mov    %esp,%ebp
  800bea:	56                   	push   %esi
  800beb:	53                   	push   %ebx
  800bec:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bef:	eb 17                	jmp    800c08 <vprintfmt+0x21>
			if (ch == '\0')
  800bf1:	85 db                	test   %ebx,%ebx
  800bf3:	0f 84 af 03 00 00    	je     800fa8 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800bf9:	83 ec 08             	sub    $0x8,%esp
  800bfc:	ff 75 0c             	pushl  0xc(%ebp)
  800bff:	53                   	push   %ebx
  800c00:	8b 45 08             	mov    0x8(%ebp),%eax
  800c03:	ff d0                	call   *%eax
  800c05:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c08:	8b 45 10             	mov    0x10(%ebp),%eax
  800c0b:	8d 50 01             	lea    0x1(%eax),%edx
  800c0e:	89 55 10             	mov    %edx,0x10(%ebp)
  800c11:	8a 00                	mov    (%eax),%al
  800c13:	0f b6 d8             	movzbl %al,%ebx
  800c16:	83 fb 25             	cmp    $0x25,%ebx
  800c19:	75 d6                	jne    800bf1 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c1b:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800c1f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800c26:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800c2d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800c34:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c3b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c3e:	8d 50 01             	lea    0x1(%eax),%edx
  800c41:	89 55 10             	mov    %edx,0x10(%ebp)
  800c44:	8a 00                	mov    (%eax),%al
  800c46:	0f b6 d8             	movzbl %al,%ebx
  800c49:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800c4c:	83 f8 55             	cmp    $0x55,%eax
  800c4f:	0f 87 2b 03 00 00    	ja     800f80 <vprintfmt+0x399>
  800c55:	8b 04 85 18 3d 80 00 	mov    0x803d18(,%eax,4),%eax
  800c5c:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c5e:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800c62:	eb d7                	jmp    800c3b <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c64:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800c68:	eb d1                	jmp    800c3b <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c6a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800c71:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c74:	89 d0                	mov    %edx,%eax
  800c76:	c1 e0 02             	shl    $0x2,%eax
  800c79:	01 d0                	add    %edx,%eax
  800c7b:	01 c0                	add    %eax,%eax
  800c7d:	01 d8                	add    %ebx,%eax
  800c7f:	83 e8 30             	sub    $0x30,%eax
  800c82:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800c85:	8b 45 10             	mov    0x10(%ebp),%eax
  800c88:	8a 00                	mov    (%eax),%al
  800c8a:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c8d:	83 fb 2f             	cmp    $0x2f,%ebx
  800c90:	7e 3e                	jle    800cd0 <vprintfmt+0xe9>
  800c92:	83 fb 39             	cmp    $0x39,%ebx
  800c95:	7f 39                	jg     800cd0 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c97:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c9a:	eb d5                	jmp    800c71 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800c9c:	8b 45 14             	mov    0x14(%ebp),%eax
  800c9f:	83 c0 04             	add    $0x4,%eax
  800ca2:	89 45 14             	mov    %eax,0x14(%ebp)
  800ca5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ca8:	83 e8 04             	sub    $0x4,%eax
  800cab:	8b 00                	mov    (%eax),%eax
  800cad:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800cb0:	eb 1f                	jmp    800cd1 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800cb2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cb6:	79 83                	jns    800c3b <vprintfmt+0x54>
				width = 0;
  800cb8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800cbf:	e9 77 ff ff ff       	jmp    800c3b <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800cc4:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800ccb:	e9 6b ff ff ff       	jmp    800c3b <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800cd0:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800cd1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cd5:	0f 89 60 ff ff ff    	jns    800c3b <vprintfmt+0x54>
				width = precision, precision = -1;
  800cdb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800cde:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800ce1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800ce8:	e9 4e ff ff ff       	jmp    800c3b <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ced:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800cf0:	e9 46 ff ff ff       	jmp    800c3b <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800cf5:	8b 45 14             	mov    0x14(%ebp),%eax
  800cf8:	83 c0 04             	add    $0x4,%eax
  800cfb:	89 45 14             	mov    %eax,0x14(%ebp)
  800cfe:	8b 45 14             	mov    0x14(%ebp),%eax
  800d01:	83 e8 04             	sub    $0x4,%eax
  800d04:	8b 00                	mov    (%eax),%eax
  800d06:	83 ec 08             	sub    $0x8,%esp
  800d09:	ff 75 0c             	pushl  0xc(%ebp)
  800d0c:	50                   	push   %eax
  800d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d10:	ff d0                	call   *%eax
  800d12:	83 c4 10             	add    $0x10,%esp
			break;
  800d15:	e9 89 02 00 00       	jmp    800fa3 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800d1a:	8b 45 14             	mov    0x14(%ebp),%eax
  800d1d:	83 c0 04             	add    $0x4,%eax
  800d20:	89 45 14             	mov    %eax,0x14(%ebp)
  800d23:	8b 45 14             	mov    0x14(%ebp),%eax
  800d26:	83 e8 04             	sub    $0x4,%eax
  800d29:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800d2b:	85 db                	test   %ebx,%ebx
  800d2d:	79 02                	jns    800d31 <vprintfmt+0x14a>
				err = -err;
  800d2f:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800d31:	83 fb 64             	cmp    $0x64,%ebx
  800d34:	7f 0b                	jg     800d41 <vprintfmt+0x15a>
  800d36:	8b 34 9d 60 3b 80 00 	mov    0x803b60(,%ebx,4),%esi
  800d3d:	85 f6                	test   %esi,%esi
  800d3f:	75 19                	jne    800d5a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d41:	53                   	push   %ebx
  800d42:	68 05 3d 80 00       	push   $0x803d05
  800d47:	ff 75 0c             	pushl  0xc(%ebp)
  800d4a:	ff 75 08             	pushl  0x8(%ebp)
  800d4d:	e8 5e 02 00 00       	call   800fb0 <printfmt>
  800d52:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d55:	e9 49 02 00 00       	jmp    800fa3 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d5a:	56                   	push   %esi
  800d5b:	68 0e 3d 80 00       	push   $0x803d0e
  800d60:	ff 75 0c             	pushl  0xc(%ebp)
  800d63:	ff 75 08             	pushl  0x8(%ebp)
  800d66:	e8 45 02 00 00       	call   800fb0 <printfmt>
  800d6b:	83 c4 10             	add    $0x10,%esp
			break;
  800d6e:	e9 30 02 00 00       	jmp    800fa3 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800d73:	8b 45 14             	mov    0x14(%ebp),%eax
  800d76:	83 c0 04             	add    $0x4,%eax
  800d79:	89 45 14             	mov    %eax,0x14(%ebp)
  800d7c:	8b 45 14             	mov    0x14(%ebp),%eax
  800d7f:	83 e8 04             	sub    $0x4,%eax
  800d82:	8b 30                	mov    (%eax),%esi
  800d84:	85 f6                	test   %esi,%esi
  800d86:	75 05                	jne    800d8d <vprintfmt+0x1a6>
				p = "(null)";
  800d88:	be 11 3d 80 00       	mov    $0x803d11,%esi
			if (width > 0 && padc != '-')
  800d8d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d91:	7e 6d                	jle    800e00 <vprintfmt+0x219>
  800d93:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800d97:	74 67                	je     800e00 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d99:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d9c:	83 ec 08             	sub    $0x8,%esp
  800d9f:	50                   	push   %eax
  800da0:	56                   	push   %esi
  800da1:	e8 0c 03 00 00       	call   8010b2 <strnlen>
  800da6:	83 c4 10             	add    $0x10,%esp
  800da9:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800dac:	eb 16                	jmp    800dc4 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800dae:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800db2:	83 ec 08             	sub    $0x8,%esp
  800db5:	ff 75 0c             	pushl  0xc(%ebp)
  800db8:	50                   	push   %eax
  800db9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbc:	ff d0                	call   *%eax
  800dbe:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800dc1:	ff 4d e4             	decl   -0x1c(%ebp)
  800dc4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dc8:	7f e4                	jg     800dae <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800dca:	eb 34                	jmp    800e00 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800dcc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800dd0:	74 1c                	je     800dee <vprintfmt+0x207>
  800dd2:	83 fb 1f             	cmp    $0x1f,%ebx
  800dd5:	7e 05                	jle    800ddc <vprintfmt+0x1f5>
  800dd7:	83 fb 7e             	cmp    $0x7e,%ebx
  800dda:	7e 12                	jle    800dee <vprintfmt+0x207>
					putch('?', putdat);
  800ddc:	83 ec 08             	sub    $0x8,%esp
  800ddf:	ff 75 0c             	pushl  0xc(%ebp)
  800de2:	6a 3f                	push   $0x3f
  800de4:	8b 45 08             	mov    0x8(%ebp),%eax
  800de7:	ff d0                	call   *%eax
  800de9:	83 c4 10             	add    $0x10,%esp
  800dec:	eb 0f                	jmp    800dfd <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800dee:	83 ec 08             	sub    $0x8,%esp
  800df1:	ff 75 0c             	pushl  0xc(%ebp)
  800df4:	53                   	push   %ebx
  800df5:	8b 45 08             	mov    0x8(%ebp),%eax
  800df8:	ff d0                	call   *%eax
  800dfa:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800dfd:	ff 4d e4             	decl   -0x1c(%ebp)
  800e00:	89 f0                	mov    %esi,%eax
  800e02:	8d 70 01             	lea    0x1(%eax),%esi
  800e05:	8a 00                	mov    (%eax),%al
  800e07:	0f be d8             	movsbl %al,%ebx
  800e0a:	85 db                	test   %ebx,%ebx
  800e0c:	74 24                	je     800e32 <vprintfmt+0x24b>
  800e0e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e12:	78 b8                	js     800dcc <vprintfmt+0x1e5>
  800e14:	ff 4d e0             	decl   -0x20(%ebp)
  800e17:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e1b:	79 af                	jns    800dcc <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e1d:	eb 13                	jmp    800e32 <vprintfmt+0x24b>
				putch(' ', putdat);
  800e1f:	83 ec 08             	sub    $0x8,%esp
  800e22:	ff 75 0c             	pushl  0xc(%ebp)
  800e25:	6a 20                	push   $0x20
  800e27:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2a:	ff d0                	call   *%eax
  800e2c:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e2f:	ff 4d e4             	decl   -0x1c(%ebp)
  800e32:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e36:	7f e7                	jg     800e1f <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800e38:	e9 66 01 00 00       	jmp    800fa3 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e3d:	83 ec 08             	sub    $0x8,%esp
  800e40:	ff 75 e8             	pushl  -0x18(%ebp)
  800e43:	8d 45 14             	lea    0x14(%ebp),%eax
  800e46:	50                   	push   %eax
  800e47:	e8 3c fd ff ff       	call   800b88 <getint>
  800e4c:	83 c4 10             	add    $0x10,%esp
  800e4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e52:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800e55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e58:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e5b:	85 d2                	test   %edx,%edx
  800e5d:	79 23                	jns    800e82 <vprintfmt+0x29b>
				putch('-', putdat);
  800e5f:	83 ec 08             	sub    $0x8,%esp
  800e62:	ff 75 0c             	pushl  0xc(%ebp)
  800e65:	6a 2d                	push   $0x2d
  800e67:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6a:	ff d0                	call   *%eax
  800e6c:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800e6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e72:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e75:	f7 d8                	neg    %eax
  800e77:	83 d2 00             	adc    $0x0,%edx
  800e7a:	f7 da                	neg    %edx
  800e7c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e7f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800e82:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e89:	e9 bc 00 00 00       	jmp    800f4a <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800e8e:	83 ec 08             	sub    $0x8,%esp
  800e91:	ff 75 e8             	pushl  -0x18(%ebp)
  800e94:	8d 45 14             	lea    0x14(%ebp),%eax
  800e97:	50                   	push   %eax
  800e98:	e8 84 fc ff ff       	call   800b21 <getuint>
  800e9d:	83 c4 10             	add    $0x10,%esp
  800ea0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ea3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800ea6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ead:	e9 98 00 00 00       	jmp    800f4a <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800eb2:	83 ec 08             	sub    $0x8,%esp
  800eb5:	ff 75 0c             	pushl  0xc(%ebp)
  800eb8:	6a 58                	push   $0x58
  800eba:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebd:	ff d0                	call   *%eax
  800ebf:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ec2:	83 ec 08             	sub    $0x8,%esp
  800ec5:	ff 75 0c             	pushl  0xc(%ebp)
  800ec8:	6a 58                	push   $0x58
  800eca:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecd:	ff d0                	call   *%eax
  800ecf:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ed2:	83 ec 08             	sub    $0x8,%esp
  800ed5:	ff 75 0c             	pushl  0xc(%ebp)
  800ed8:	6a 58                	push   $0x58
  800eda:	8b 45 08             	mov    0x8(%ebp),%eax
  800edd:	ff d0                	call   *%eax
  800edf:	83 c4 10             	add    $0x10,%esp
			break;
  800ee2:	e9 bc 00 00 00       	jmp    800fa3 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800ee7:	83 ec 08             	sub    $0x8,%esp
  800eea:	ff 75 0c             	pushl  0xc(%ebp)
  800eed:	6a 30                	push   $0x30
  800eef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef2:	ff d0                	call   *%eax
  800ef4:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ef7:	83 ec 08             	sub    $0x8,%esp
  800efa:	ff 75 0c             	pushl  0xc(%ebp)
  800efd:	6a 78                	push   $0x78
  800eff:	8b 45 08             	mov    0x8(%ebp),%eax
  800f02:	ff d0                	call   *%eax
  800f04:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800f07:	8b 45 14             	mov    0x14(%ebp),%eax
  800f0a:	83 c0 04             	add    $0x4,%eax
  800f0d:	89 45 14             	mov    %eax,0x14(%ebp)
  800f10:	8b 45 14             	mov    0x14(%ebp),%eax
  800f13:	83 e8 04             	sub    $0x4,%eax
  800f16:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f18:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f1b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800f22:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800f29:	eb 1f                	jmp    800f4a <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800f2b:	83 ec 08             	sub    $0x8,%esp
  800f2e:	ff 75 e8             	pushl  -0x18(%ebp)
  800f31:	8d 45 14             	lea    0x14(%ebp),%eax
  800f34:	50                   	push   %eax
  800f35:	e8 e7 fb ff ff       	call   800b21 <getuint>
  800f3a:	83 c4 10             	add    $0x10,%esp
  800f3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f40:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800f43:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f4a:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800f4e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f51:	83 ec 04             	sub    $0x4,%esp
  800f54:	52                   	push   %edx
  800f55:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f58:	50                   	push   %eax
  800f59:	ff 75 f4             	pushl  -0xc(%ebp)
  800f5c:	ff 75 f0             	pushl  -0x10(%ebp)
  800f5f:	ff 75 0c             	pushl  0xc(%ebp)
  800f62:	ff 75 08             	pushl  0x8(%ebp)
  800f65:	e8 00 fb ff ff       	call   800a6a <printnum>
  800f6a:	83 c4 20             	add    $0x20,%esp
			break;
  800f6d:	eb 34                	jmp    800fa3 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f6f:	83 ec 08             	sub    $0x8,%esp
  800f72:	ff 75 0c             	pushl  0xc(%ebp)
  800f75:	53                   	push   %ebx
  800f76:	8b 45 08             	mov    0x8(%ebp),%eax
  800f79:	ff d0                	call   *%eax
  800f7b:	83 c4 10             	add    $0x10,%esp
			break;
  800f7e:	eb 23                	jmp    800fa3 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f80:	83 ec 08             	sub    $0x8,%esp
  800f83:	ff 75 0c             	pushl  0xc(%ebp)
  800f86:	6a 25                	push   $0x25
  800f88:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8b:	ff d0                	call   *%eax
  800f8d:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f90:	ff 4d 10             	decl   0x10(%ebp)
  800f93:	eb 03                	jmp    800f98 <vprintfmt+0x3b1>
  800f95:	ff 4d 10             	decl   0x10(%ebp)
  800f98:	8b 45 10             	mov    0x10(%ebp),%eax
  800f9b:	48                   	dec    %eax
  800f9c:	8a 00                	mov    (%eax),%al
  800f9e:	3c 25                	cmp    $0x25,%al
  800fa0:	75 f3                	jne    800f95 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800fa2:	90                   	nop
		}
	}
  800fa3:	e9 47 fc ff ff       	jmp    800bef <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800fa8:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800fa9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800fac:	5b                   	pop    %ebx
  800fad:	5e                   	pop    %esi
  800fae:	5d                   	pop    %ebp
  800faf:	c3                   	ret    

00800fb0 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800fb0:	55                   	push   %ebp
  800fb1:	89 e5                	mov    %esp,%ebp
  800fb3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800fb6:	8d 45 10             	lea    0x10(%ebp),%eax
  800fb9:	83 c0 04             	add    $0x4,%eax
  800fbc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800fbf:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc2:	ff 75 f4             	pushl  -0xc(%ebp)
  800fc5:	50                   	push   %eax
  800fc6:	ff 75 0c             	pushl  0xc(%ebp)
  800fc9:	ff 75 08             	pushl  0x8(%ebp)
  800fcc:	e8 16 fc ff ff       	call   800be7 <vprintfmt>
  800fd1:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800fd4:	90                   	nop
  800fd5:	c9                   	leave  
  800fd6:	c3                   	ret    

00800fd7 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800fd7:	55                   	push   %ebp
  800fd8:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800fda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fdd:	8b 40 08             	mov    0x8(%eax),%eax
  800fe0:	8d 50 01             	lea    0x1(%eax),%edx
  800fe3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe6:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800fe9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fec:	8b 10                	mov    (%eax),%edx
  800fee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff1:	8b 40 04             	mov    0x4(%eax),%eax
  800ff4:	39 c2                	cmp    %eax,%edx
  800ff6:	73 12                	jae    80100a <sprintputch+0x33>
		*b->buf++ = ch;
  800ff8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ffb:	8b 00                	mov    (%eax),%eax
  800ffd:	8d 48 01             	lea    0x1(%eax),%ecx
  801000:	8b 55 0c             	mov    0xc(%ebp),%edx
  801003:	89 0a                	mov    %ecx,(%edx)
  801005:	8b 55 08             	mov    0x8(%ebp),%edx
  801008:	88 10                	mov    %dl,(%eax)
}
  80100a:	90                   	nop
  80100b:	5d                   	pop    %ebp
  80100c:	c3                   	ret    

0080100d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80100d:	55                   	push   %ebp
  80100e:	89 e5                	mov    %esp,%ebp
  801010:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801013:	8b 45 08             	mov    0x8(%ebp),%eax
  801016:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801019:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80101f:	8b 45 08             	mov    0x8(%ebp),%eax
  801022:	01 d0                	add    %edx,%eax
  801024:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801027:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80102e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801032:	74 06                	je     80103a <vsnprintf+0x2d>
  801034:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801038:	7f 07                	jg     801041 <vsnprintf+0x34>
		return -E_INVAL;
  80103a:	b8 03 00 00 00       	mov    $0x3,%eax
  80103f:	eb 20                	jmp    801061 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801041:	ff 75 14             	pushl  0x14(%ebp)
  801044:	ff 75 10             	pushl  0x10(%ebp)
  801047:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80104a:	50                   	push   %eax
  80104b:	68 d7 0f 80 00       	push   $0x800fd7
  801050:	e8 92 fb ff ff       	call   800be7 <vprintfmt>
  801055:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801058:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80105b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80105e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801061:	c9                   	leave  
  801062:	c3                   	ret    

00801063 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801063:	55                   	push   %ebp
  801064:	89 e5                	mov    %esp,%ebp
  801066:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801069:	8d 45 10             	lea    0x10(%ebp),%eax
  80106c:	83 c0 04             	add    $0x4,%eax
  80106f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801072:	8b 45 10             	mov    0x10(%ebp),%eax
  801075:	ff 75 f4             	pushl  -0xc(%ebp)
  801078:	50                   	push   %eax
  801079:	ff 75 0c             	pushl  0xc(%ebp)
  80107c:	ff 75 08             	pushl  0x8(%ebp)
  80107f:	e8 89 ff ff ff       	call   80100d <vsnprintf>
  801084:	83 c4 10             	add    $0x10,%esp
  801087:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80108a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80108d:	c9                   	leave  
  80108e:	c3                   	ret    

0080108f <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80108f:	55                   	push   %ebp
  801090:	89 e5                	mov    %esp,%ebp
  801092:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801095:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80109c:	eb 06                	jmp    8010a4 <strlen+0x15>
		n++;
  80109e:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8010a1:	ff 45 08             	incl   0x8(%ebp)
  8010a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a7:	8a 00                	mov    (%eax),%al
  8010a9:	84 c0                	test   %al,%al
  8010ab:	75 f1                	jne    80109e <strlen+0xf>
		n++;
	return n;
  8010ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010b0:	c9                   	leave  
  8010b1:	c3                   	ret    

008010b2 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8010b2:	55                   	push   %ebp
  8010b3:	89 e5                	mov    %esp,%ebp
  8010b5:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010bf:	eb 09                	jmp    8010ca <strnlen+0x18>
		n++;
  8010c1:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010c4:	ff 45 08             	incl   0x8(%ebp)
  8010c7:	ff 4d 0c             	decl   0xc(%ebp)
  8010ca:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010ce:	74 09                	je     8010d9 <strnlen+0x27>
  8010d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d3:	8a 00                	mov    (%eax),%al
  8010d5:	84 c0                	test   %al,%al
  8010d7:	75 e8                	jne    8010c1 <strnlen+0xf>
		n++;
	return n;
  8010d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010dc:	c9                   	leave  
  8010dd:	c3                   	ret    

008010de <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8010de:	55                   	push   %ebp
  8010df:	89 e5                	mov    %esp,%ebp
  8010e1:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8010e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8010ea:	90                   	nop
  8010eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ee:	8d 50 01             	lea    0x1(%eax),%edx
  8010f1:	89 55 08             	mov    %edx,0x8(%ebp)
  8010f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010f7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010fa:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010fd:	8a 12                	mov    (%edx),%dl
  8010ff:	88 10                	mov    %dl,(%eax)
  801101:	8a 00                	mov    (%eax),%al
  801103:	84 c0                	test   %al,%al
  801105:	75 e4                	jne    8010eb <strcpy+0xd>
		/* do nothing */;
	return ret;
  801107:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80110a:	c9                   	leave  
  80110b:	c3                   	ret    

0080110c <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80110c:	55                   	push   %ebp
  80110d:	89 e5                	mov    %esp,%ebp
  80110f:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801112:	8b 45 08             	mov    0x8(%ebp),%eax
  801115:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801118:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80111f:	eb 1f                	jmp    801140 <strncpy+0x34>
		*dst++ = *src;
  801121:	8b 45 08             	mov    0x8(%ebp),%eax
  801124:	8d 50 01             	lea    0x1(%eax),%edx
  801127:	89 55 08             	mov    %edx,0x8(%ebp)
  80112a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80112d:	8a 12                	mov    (%edx),%dl
  80112f:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801131:	8b 45 0c             	mov    0xc(%ebp),%eax
  801134:	8a 00                	mov    (%eax),%al
  801136:	84 c0                	test   %al,%al
  801138:	74 03                	je     80113d <strncpy+0x31>
			src++;
  80113a:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80113d:	ff 45 fc             	incl   -0x4(%ebp)
  801140:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801143:	3b 45 10             	cmp    0x10(%ebp),%eax
  801146:	72 d9                	jb     801121 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801148:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80114b:	c9                   	leave  
  80114c:	c3                   	ret    

0080114d <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80114d:	55                   	push   %ebp
  80114e:	89 e5                	mov    %esp,%ebp
  801150:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801153:	8b 45 08             	mov    0x8(%ebp),%eax
  801156:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801159:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80115d:	74 30                	je     80118f <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80115f:	eb 16                	jmp    801177 <strlcpy+0x2a>
			*dst++ = *src++;
  801161:	8b 45 08             	mov    0x8(%ebp),%eax
  801164:	8d 50 01             	lea    0x1(%eax),%edx
  801167:	89 55 08             	mov    %edx,0x8(%ebp)
  80116a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80116d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801170:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801173:	8a 12                	mov    (%edx),%dl
  801175:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801177:	ff 4d 10             	decl   0x10(%ebp)
  80117a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80117e:	74 09                	je     801189 <strlcpy+0x3c>
  801180:	8b 45 0c             	mov    0xc(%ebp),%eax
  801183:	8a 00                	mov    (%eax),%al
  801185:	84 c0                	test   %al,%al
  801187:	75 d8                	jne    801161 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801189:	8b 45 08             	mov    0x8(%ebp),%eax
  80118c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80118f:	8b 55 08             	mov    0x8(%ebp),%edx
  801192:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801195:	29 c2                	sub    %eax,%edx
  801197:	89 d0                	mov    %edx,%eax
}
  801199:	c9                   	leave  
  80119a:	c3                   	ret    

0080119b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80119b:	55                   	push   %ebp
  80119c:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80119e:	eb 06                	jmp    8011a6 <strcmp+0xb>
		p++, q++;
  8011a0:	ff 45 08             	incl   0x8(%ebp)
  8011a3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8011a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a9:	8a 00                	mov    (%eax),%al
  8011ab:	84 c0                	test   %al,%al
  8011ad:	74 0e                	je     8011bd <strcmp+0x22>
  8011af:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b2:	8a 10                	mov    (%eax),%dl
  8011b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b7:	8a 00                	mov    (%eax),%al
  8011b9:	38 c2                	cmp    %al,%dl
  8011bb:	74 e3                	je     8011a0 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8011bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c0:	8a 00                	mov    (%eax),%al
  8011c2:	0f b6 d0             	movzbl %al,%edx
  8011c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c8:	8a 00                	mov    (%eax),%al
  8011ca:	0f b6 c0             	movzbl %al,%eax
  8011cd:	29 c2                	sub    %eax,%edx
  8011cf:	89 d0                	mov    %edx,%eax
}
  8011d1:	5d                   	pop    %ebp
  8011d2:	c3                   	ret    

008011d3 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8011d3:	55                   	push   %ebp
  8011d4:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8011d6:	eb 09                	jmp    8011e1 <strncmp+0xe>
		n--, p++, q++;
  8011d8:	ff 4d 10             	decl   0x10(%ebp)
  8011db:	ff 45 08             	incl   0x8(%ebp)
  8011de:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8011e1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011e5:	74 17                	je     8011fe <strncmp+0x2b>
  8011e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ea:	8a 00                	mov    (%eax),%al
  8011ec:	84 c0                	test   %al,%al
  8011ee:	74 0e                	je     8011fe <strncmp+0x2b>
  8011f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f3:	8a 10                	mov    (%eax),%dl
  8011f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f8:	8a 00                	mov    (%eax),%al
  8011fa:	38 c2                	cmp    %al,%dl
  8011fc:	74 da                	je     8011d8 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8011fe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801202:	75 07                	jne    80120b <strncmp+0x38>
		return 0;
  801204:	b8 00 00 00 00       	mov    $0x0,%eax
  801209:	eb 14                	jmp    80121f <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80120b:	8b 45 08             	mov    0x8(%ebp),%eax
  80120e:	8a 00                	mov    (%eax),%al
  801210:	0f b6 d0             	movzbl %al,%edx
  801213:	8b 45 0c             	mov    0xc(%ebp),%eax
  801216:	8a 00                	mov    (%eax),%al
  801218:	0f b6 c0             	movzbl %al,%eax
  80121b:	29 c2                	sub    %eax,%edx
  80121d:	89 d0                	mov    %edx,%eax
}
  80121f:	5d                   	pop    %ebp
  801220:	c3                   	ret    

00801221 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801221:	55                   	push   %ebp
  801222:	89 e5                	mov    %esp,%ebp
  801224:	83 ec 04             	sub    $0x4,%esp
  801227:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80122d:	eb 12                	jmp    801241 <strchr+0x20>
		if (*s == c)
  80122f:	8b 45 08             	mov    0x8(%ebp),%eax
  801232:	8a 00                	mov    (%eax),%al
  801234:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801237:	75 05                	jne    80123e <strchr+0x1d>
			return (char *) s;
  801239:	8b 45 08             	mov    0x8(%ebp),%eax
  80123c:	eb 11                	jmp    80124f <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80123e:	ff 45 08             	incl   0x8(%ebp)
  801241:	8b 45 08             	mov    0x8(%ebp),%eax
  801244:	8a 00                	mov    (%eax),%al
  801246:	84 c0                	test   %al,%al
  801248:	75 e5                	jne    80122f <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80124a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80124f:	c9                   	leave  
  801250:	c3                   	ret    

00801251 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801251:	55                   	push   %ebp
  801252:	89 e5                	mov    %esp,%ebp
  801254:	83 ec 04             	sub    $0x4,%esp
  801257:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80125d:	eb 0d                	jmp    80126c <strfind+0x1b>
		if (*s == c)
  80125f:	8b 45 08             	mov    0x8(%ebp),%eax
  801262:	8a 00                	mov    (%eax),%al
  801264:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801267:	74 0e                	je     801277 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801269:	ff 45 08             	incl   0x8(%ebp)
  80126c:	8b 45 08             	mov    0x8(%ebp),%eax
  80126f:	8a 00                	mov    (%eax),%al
  801271:	84 c0                	test   %al,%al
  801273:	75 ea                	jne    80125f <strfind+0xe>
  801275:	eb 01                	jmp    801278 <strfind+0x27>
		if (*s == c)
			break;
  801277:	90                   	nop
	return (char *) s;
  801278:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80127b:	c9                   	leave  
  80127c:	c3                   	ret    

0080127d <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80127d:	55                   	push   %ebp
  80127e:	89 e5                	mov    %esp,%ebp
  801280:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801283:	8b 45 08             	mov    0x8(%ebp),%eax
  801286:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801289:	8b 45 10             	mov    0x10(%ebp),%eax
  80128c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80128f:	eb 0e                	jmp    80129f <memset+0x22>
		*p++ = c;
  801291:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801294:	8d 50 01             	lea    0x1(%eax),%edx
  801297:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80129a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80129d:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80129f:	ff 4d f8             	decl   -0x8(%ebp)
  8012a2:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8012a6:	79 e9                	jns    801291 <memset+0x14>
		*p++ = c;

	return v;
  8012a8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012ab:	c9                   	leave  
  8012ac:	c3                   	ret    

008012ad <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8012ad:	55                   	push   %ebp
  8012ae:	89 e5                	mov    %esp,%ebp
  8012b0:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8012b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8012b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8012bf:	eb 16                	jmp    8012d7 <memcpy+0x2a>
		*d++ = *s++;
  8012c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012c4:	8d 50 01             	lea    0x1(%eax),%edx
  8012c7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012ca:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012cd:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012d0:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8012d3:	8a 12                	mov    (%edx),%dl
  8012d5:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8012d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8012da:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012dd:	89 55 10             	mov    %edx,0x10(%ebp)
  8012e0:	85 c0                	test   %eax,%eax
  8012e2:	75 dd                	jne    8012c1 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8012e4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012e7:	c9                   	leave  
  8012e8:	c3                   	ret    

008012e9 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8012e9:	55                   	push   %ebp
  8012ea:	89 e5                	mov    %esp,%ebp
  8012ec:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8012ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8012f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8012fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012fe:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801301:	73 50                	jae    801353 <memmove+0x6a>
  801303:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801306:	8b 45 10             	mov    0x10(%ebp),%eax
  801309:	01 d0                	add    %edx,%eax
  80130b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80130e:	76 43                	jbe    801353 <memmove+0x6a>
		s += n;
  801310:	8b 45 10             	mov    0x10(%ebp),%eax
  801313:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801316:	8b 45 10             	mov    0x10(%ebp),%eax
  801319:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80131c:	eb 10                	jmp    80132e <memmove+0x45>
			*--d = *--s;
  80131e:	ff 4d f8             	decl   -0x8(%ebp)
  801321:	ff 4d fc             	decl   -0x4(%ebp)
  801324:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801327:	8a 10                	mov    (%eax),%dl
  801329:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80132c:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80132e:	8b 45 10             	mov    0x10(%ebp),%eax
  801331:	8d 50 ff             	lea    -0x1(%eax),%edx
  801334:	89 55 10             	mov    %edx,0x10(%ebp)
  801337:	85 c0                	test   %eax,%eax
  801339:	75 e3                	jne    80131e <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80133b:	eb 23                	jmp    801360 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80133d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801340:	8d 50 01             	lea    0x1(%eax),%edx
  801343:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801346:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801349:	8d 4a 01             	lea    0x1(%edx),%ecx
  80134c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80134f:	8a 12                	mov    (%edx),%dl
  801351:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801353:	8b 45 10             	mov    0x10(%ebp),%eax
  801356:	8d 50 ff             	lea    -0x1(%eax),%edx
  801359:	89 55 10             	mov    %edx,0x10(%ebp)
  80135c:	85 c0                	test   %eax,%eax
  80135e:	75 dd                	jne    80133d <memmove+0x54>
			*d++ = *s++;

	return dst;
  801360:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801363:	c9                   	leave  
  801364:	c3                   	ret    

00801365 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801365:	55                   	push   %ebp
  801366:	89 e5                	mov    %esp,%ebp
  801368:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80136b:	8b 45 08             	mov    0x8(%ebp),%eax
  80136e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801371:	8b 45 0c             	mov    0xc(%ebp),%eax
  801374:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801377:	eb 2a                	jmp    8013a3 <memcmp+0x3e>
		if (*s1 != *s2)
  801379:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80137c:	8a 10                	mov    (%eax),%dl
  80137e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801381:	8a 00                	mov    (%eax),%al
  801383:	38 c2                	cmp    %al,%dl
  801385:	74 16                	je     80139d <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801387:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80138a:	8a 00                	mov    (%eax),%al
  80138c:	0f b6 d0             	movzbl %al,%edx
  80138f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801392:	8a 00                	mov    (%eax),%al
  801394:	0f b6 c0             	movzbl %al,%eax
  801397:	29 c2                	sub    %eax,%edx
  801399:	89 d0                	mov    %edx,%eax
  80139b:	eb 18                	jmp    8013b5 <memcmp+0x50>
		s1++, s2++;
  80139d:	ff 45 fc             	incl   -0x4(%ebp)
  8013a0:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8013a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8013a6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013a9:	89 55 10             	mov    %edx,0x10(%ebp)
  8013ac:	85 c0                	test   %eax,%eax
  8013ae:	75 c9                	jne    801379 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8013b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013b5:	c9                   	leave  
  8013b6:	c3                   	ret    

008013b7 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8013b7:	55                   	push   %ebp
  8013b8:	89 e5                	mov    %esp,%ebp
  8013ba:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8013bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8013c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8013c3:	01 d0                	add    %edx,%eax
  8013c5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8013c8:	eb 15                	jmp    8013df <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8013ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cd:	8a 00                	mov    (%eax),%al
  8013cf:	0f b6 d0             	movzbl %al,%edx
  8013d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d5:	0f b6 c0             	movzbl %al,%eax
  8013d8:	39 c2                	cmp    %eax,%edx
  8013da:	74 0d                	je     8013e9 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8013dc:	ff 45 08             	incl   0x8(%ebp)
  8013df:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8013e5:	72 e3                	jb     8013ca <memfind+0x13>
  8013e7:	eb 01                	jmp    8013ea <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8013e9:	90                   	nop
	return (void *) s;
  8013ea:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013ed:	c9                   	leave  
  8013ee:	c3                   	ret    

008013ef <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8013ef:	55                   	push   %ebp
  8013f0:	89 e5                	mov    %esp,%ebp
  8013f2:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8013f5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8013fc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801403:	eb 03                	jmp    801408 <strtol+0x19>
		s++;
  801405:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801408:	8b 45 08             	mov    0x8(%ebp),%eax
  80140b:	8a 00                	mov    (%eax),%al
  80140d:	3c 20                	cmp    $0x20,%al
  80140f:	74 f4                	je     801405 <strtol+0x16>
  801411:	8b 45 08             	mov    0x8(%ebp),%eax
  801414:	8a 00                	mov    (%eax),%al
  801416:	3c 09                	cmp    $0x9,%al
  801418:	74 eb                	je     801405 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80141a:	8b 45 08             	mov    0x8(%ebp),%eax
  80141d:	8a 00                	mov    (%eax),%al
  80141f:	3c 2b                	cmp    $0x2b,%al
  801421:	75 05                	jne    801428 <strtol+0x39>
		s++;
  801423:	ff 45 08             	incl   0x8(%ebp)
  801426:	eb 13                	jmp    80143b <strtol+0x4c>
	else if (*s == '-')
  801428:	8b 45 08             	mov    0x8(%ebp),%eax
  80142b:	8a 00                	mov    (%eax),%al
  80142d:	3c 2d                	cmp    $0x2d,%al
  80142f:	75 0a                	jne    80143b <strtol+0x4c>
		s++, neg = 1;
  801431:	ff 45 08             	incl   0x8(%ebp)
  801434:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80143b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80143f:	74 06                	je     801447 <strtol+0x58>
  801441:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801445:	75 20                	jne    801467 <strtol+0x78>
  801447:	8b 45 08             	mov    0x8(%ebp),%eax
  80144a:	8a 00                	mov    (%eax),%al
  80144c:	3c 30                	cmp    $0x30,%al
  80144e:	75 17                	jne    801467 <strtol+0x78>
  801450:	8b 45 08             	mov    0x8(%ebp),%eax
  801453:	40                   	inc    %eax
  801454:	8a 00                	mov    (%eax),%al
  801456:	3c 78                	cmp    $0x78,%al
  801458:	75 0d                	jne    801467 <strtol+0x78>
		s += 2, base = 16;
  80145a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80145e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801465:	eb 28                	jmp    80148f <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801467:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80146b:	75 15                	jne    801482 <strtol+0x93>
  80146d:	8b 45 08             	mov    0x8(%ebp),%eax
  801470:	8a 00                	mov    (%eax),%al
  801472:	3c 30                	cmp    $0x30,%al
  801474:	75 0c                	jne    801482 <strtol+0x93>
		s++, base = 8;
  801476:	ff 45 08             	incl   0x8(%ebp)
  801479:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801480:	eb 0d                	jmp    80148f <strtol+0xa0>
	else if (base == 0)
  801482:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801486:	75 07                	jne    80148f <strtol+0xa0>
		base = 10;
  801488:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80148f:	8b 45 08             	mov    0x8(%ebp),%eax
  801492:	8a 00                	mov    (%eax),%al
  801494:	3c 2f                	cmp    $0x2f,%al
  801496:	7e 19                	jle    8014b1 <strtol+0xc2>
  801498:	8b 45 08             	mov    0x8(%ebp),%eax
  80149b:	8a 00                	mov    (%eax),%al
  80149d:	3c 39                	cmp    $0x39,%al
  80149f:	7f 10                	jg     8014b1 <strtol+0xc2>
			dig = *s - '0';
  8014a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a4:	8a 00                	mov    (%eax),%al
  8014a6:	0f be c0             	movsbl %al,%eax
  8014a9:	83 e8 30             	sub    $0x30,%eax
  8014ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014af:	eb 42                	jmp    8014f3 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8014b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b4:	8a 00                	mov    (%eax),%al
  8014b6:	3c 60                	cmp    $0x60,%al
  8014b8:	7e 19                	jle    8014d3 <strtol+0xe4>
  8014ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bd:	8a 00                	mov    (%eax),%al
  8014bf:	3c 7a                	cmp    $0x7a,%al
  8014c1:	7f 10                	jg     8014d3 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8014c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c6:	8a 00                	mov    (%eax),%al
  8014c8:	0f be c0             	movsbl %al,%eax
  8014cb:	83 e8 57             	sub    $0x57,%eax
  8014ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014d1:	eb 20                	jmp    8014f3 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8014d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d6:	8a 00                	mov    (%eax),%al
  8014d8:	3c 40                	cmp    $0x40,%al
  8014da:	7e 39                	jle    801515 <strtol+0x126>
  8014dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014df:	8a 00                	mov    (%eax),%al
  8014e1:	3c 5a                	cmp    $0x5a,%al
  8014e3:	7f 30                	jg     801515 <strtol+0x126>
			dig = *s - 'A' + 10;
  8014e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e8:	8a 00                	mov    (%eax),%al
  8014ea:	0f be c0             	movsbl %al,%eax
  8014ed:	83 e8 37             	sub    $0x37,%eax
  8014f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8014f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014f6:	3b 45 10             	cmp    0x10(%ebp),%eax
  8014f9:	7d 19                	jge    801514 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8014fb:	ff 45 08             	incl   0x8(%ebp)
  8014fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801501:	0f af 45 10          	imul   0x10(%ebp),%eax
  801505:	89 c2                	mov    %eax,%edx
  801507:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80150a:	01 d0                	add    %edx,%eax
  80150c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80150f:	e9 7b ff ff ff       	jmp    80148f <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801514:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801515:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801519:	74 08                	je     801523 <strtol+0x134>
		*endptr = (char *) s;
  80151b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80151e:	8b 55 08             	mov    0x8(%ebp),%edx
  801521:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801523:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801527:	74 07                	je     801530 <strtol+0x141>
  801529:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80152c:	f7 d8                	neg    %eax
  80152e:	eb 03                	jmp    801533 <strtol+0x144>
  801530:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801533:	c9                   	leave  
  801534:	c3                   	ret    

00801535 <ltostr>:

void
ltostr(long value, char *str)
{
  801535:	55                   	push   %ebp
  801536:	89 e5                	mov    %esp,%ebp
  801538:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80153b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801542:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801549:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80154d:	79 13                	jns    801562 <ltostr+0x2d>
	{
		neg = 1;
  80154f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801556:	8b 45 0c             	mov    0xc(%ebp),%eax
  801559:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80155c:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80155f:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801562:	8b 45 08             	mov    0x8(%ebp),%eax
  801565:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80156a:	99                   	cltd   
  80156b:	f7 f9                	idiv   %ecx
  80156d:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801570:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801573:	8d 50 01             	lea    0x1(%eax),%edx
  801576:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801579:	89 c2                	mov    %eax,%edx
  80157b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80157e:	01 d0                	add    %edx,%eax
  801580:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801583:	83 c2 30             	add    $0x30,%edx
  801586:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801588:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80158b:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801590:	f7 e9                	imul   %ecx
  801592:	c1 fa 02             	sar    $0x2,%edx
  801595:	89 c8                	mov    %ecx,%eax
  801597:	c1 f8 1f             	sar    $0x1f,%eax
  80159a:	29 c2                	sub    %eax,%edx
  80159c:	89 d0                	mov    %edx,%eax
  80159e:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8015a1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015a4:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8015a9:	f7 e9                	imul   %ecx
  8015ab:	c1 fa 02             	sar    $0x2,%edx
  8015ae:	89 c8                	mov    %ecx,%eax
  8015b0:	c1 f8 1f             	sar    $0x1f,%eax
  8015b3:	29 c2                	sub    %eax,%edx
  8015b5:	89 d0                	mov    %edx,%eax
  8015b7:	c1 e0 02             	shl    $0x2,%eax
  8015ba:	01 d0                	add    %edx,%eax
  8015bc:	01 c0                	add    %eax,%eax
  8015be:	29 c1                	sub    %eax,%ecx
  8015c0:	89 ca                	mov    %ecx,%edx
  8015c2:	85 d2                	test   %edx,%edx
  8015c4:	75 9c                	jne    801562 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8015c6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8015cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015d0:	48                   	dec    %eax
  8015d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8015d4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8015d8:	74 3d                	je     801617 <ltostr+0xe2>
		start = 1 ;
  8015da:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8015e1:	eb 34                	jmp    801617 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8015e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e9:	01 d0                	add    %edx,%eax
  8015eb:	8a 00                	mov    (%eax),%al
  8015ed:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8015f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f6:	01 c2                	add    %eax,%edx
  8015f8:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8015fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015fe:	01 c8                	add    %ecx,%eax
  801600:	8a 00                	mov    (%eax),%al
  801602:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801604:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801607:	8b 45 0c             	mov    0xc(%ebp),%eax
  80160a:	01 c2                	add    %eax,%edx
  80160c:	8a 45 eb             	mov    -0x15(%ebp),%al
  80160f:	88 02                	mov    %al,(%edx)
		start++ ;
  801611:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801614:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801617:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80161a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80161d:	7c c4                	jl     8015e3 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80161f:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801622:	8b 45 0c             	mov    0xc(%ebp),%eax
  801625:	01 d0                	add    %edx,%eax
  801627:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80162a:	90                   	nop
  80162b:	c9                   	leave  
  80162c:	c3                   	ret    

0080162d <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80162d:	55                   	push   %ebp
  80162e:	89 e5                	mov    %esp,%ebp
  801630:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801633:	ff 75 08             	pushl  0x8(%ebp)
  801636:	e8 54 fa ff ff       	call   80108f <strlen>
  80163b:	83 c4 04             	add    $0x4,%esp
  80163e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801641:	ff 75 0c             	pushl  0xc(%ebp)
  801644:	e8 46 fa ff ff       	call   80108f <strlen>
  801649:	83 c4 04             	add    $0x4,%esp
  80164c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80164f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801656:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80165d:	eb 17                	jmp    801676 <strcconcat+0x49>
		final[s] = str1[s] ;
  80165f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801662:	8b 45 10             	mov    0x10(%ebp),%eax
  801665:	01 c2                	add    %eax,%edx
  801667:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80166a:	8b 45 08             	mov    0x8(%ebp),%eax
  80166d:	01 c8                	add    %ecx,%eax
  80166f:	8a 00                	mov    (%eax),%al
  801671:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801673:	ff 45 fc             	incl   -0x4(%ebp)
  801676:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801679:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80167c:	7c e1                	jl     80165f <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80167e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801685:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80168c:	eb 1f                	jmp    8016ad <strcconcat+0x80>
		final[s++] = str2[i] ;
  80168e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801691:	8d 50 01             	lea    0x1(%eax),%edx
  801694:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801697:	89 c2                	mov    %eax,%edx
  801699:	8b 45 10             	mov    0x10(%ebp),%eax
  80169c:	01 c2                	add    %eax,%edx
  80169e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8016a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a4:	01 c8                	add    %ecx,%eax
  8016a6:	8a 00                	mov    (%eax),%al
  8016a8:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8016aa:	ff 45 f8             	incl   -0x8(%ebp)
  8016ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016b0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8016b3:	7c d9                	jl     80168e <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8016b5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8016bb:	01 d0                	add    %edx,%eax
  8016bd:	c6 00 00             	movb   $0x0,(%eax)
}
  8016c0:	90                   	nop
  8016c1:	c9                   	leave  
  8016c2:	c3                   	ret    

008016c3 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8016c3:	55                   	push   %ebp
  8016c4:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8016c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8016c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8016cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8016d2:	8b 00                	mov    (%eax),%eax
  8016d4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016db:	8b 45 10             	mov    0x10(%ebp),%eax
  8016de:	01 d0                	add    %edx,%eax
  8016e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8016e6:	eb 0c                	jmp    8016f4 <strsplit+0x31>
			*string++ = 0;
  8016e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016eb:	8d 50 01             	lea    0x1(%eax),%edx
  8016ee:	89 55 08             	mov    %edx,0x8(%ebp)
  8016f1:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8016f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f7:	8a 00                	mov    (%eax),%al
  8016f9:	84 c0                	test   %al,%al
  8016fb:	74 18                	je     801715 <strsplit+0x52>
  8016fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801700:	8a 00                	mov    (%eax),%al
  801702:	0f be c0             	movsbl %al,%eax
  801705:	50                   	push   %eax
  801706:	ff 75 0c             	pushl  0xc(%ebp)
  801709:	e8 13 fb ff ff       	call   801221 <strchr>
  80170e:	83 c4 08             	add    $0x8,%esp
  801711:	85 c0                	test   %eax,%eax
  801713:	75 d3                	jne    8016e8 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801715:	8b 45 08             	mov    0x8(%ebp),%eax
  801718:	8a 00                	mov    (%eax),%al
  80171a:	84 c0                	test   %al,%al
  80171c:	74 5a                	je     801778 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80171e:	8b 45 14             	mov    0x14(%ebp),%eax
  801721:	8b 00                	mov    (%eax),%eax
  801723:	83 f8 0f             	cmp    $0xf,%eax
  801726:	75 07                	jne    80172f <strsplit+0x6c>
		{
			return 0;
  801728:	b8 00 00 00 00       	mov    $0x0,%eax
  80172d:	eb 66                	jmp    801795 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80172f:	8b 45 14             	mov    0x14(%ebp),%eax
  801732:	8b 00                	mov    (%eax),%eax
  801734:	8d 48 01             	lea    0x1(%eax),%ecx
  801737:	8b 55 14             	mov    0x14(%ebp),%edx
  80173a:	89 0a                	mov    %ecx,(%edx)
  80173c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801743:	8b 45 10             	mov    0x10(%ebp),%eax
  801746:	01 c2                	add    %eax,%edx
  801748:	8b 45 08             	mov    0x8(%ebp),%eax
  80174b:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80174d:	eb 03                	jmp    801752 <strsplit+0x8f>
			string++;
  80174f:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801752:	8b 45 08             	mov    0x8(%ebp),%eax
  801755:	8a 00                	mov    (%eax),%al
  801757:	84 c0                	test   %al,%al
  801759:	74 8b                	je     8016e6 <strsplit+0x23>
  80175b:	8b 45 08             	mov    0x8(%ebp),%eax
  80175e:	8a 00                	mov    (%eax),%al
  801760:	0f be c0             	movsbl %al,%eax
  801763:	50                   	push   %eax
  801764:	ff 75 0c             	pushl  0xc(%ebp)
  801767:	e8 b5 fa ff ff       	call   801221 <strchr>
  80176c:	83 c4 08             	add    $0x8,%esp
  80176f:	85 c0                	test   %eax,%eax
  801771:	74 dc                	je     80174f <strsplit+0x8c>
			string++;
	}
  801773:	e9 6e ff ff ff       	jmp    8016e6 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801778:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801779:	8b 45 14             	mov    0x14(%ebp),%eax
  80177c:	8b 00                	mov    (%eax),%eax
  80177e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801785:	8b 45 10             	mov    0x10(%ebp),%eax
  801788:	01 d0                	add    %edx,%eax
  80178a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801790:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801795:	c9                   	leave  
  801796:	c3                   	ret    

00801797 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801797:	55                   	push   %ebp
  801798:	89 e5                	mov    %esp,%ebp
  80179a:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  80179d:	a1 04 50 80 00       	mov    0x805004,%eax
  8017a2:	85 c0                	test   %eax,%eax
  8017a4:	74 1f                	je     8017c5 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8017a6:	e8 1d 00 00 00       	call   8017c8 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8017ab:	83 ec 0c             	sub    $0xc,%esp
  8017ae:	68 70 3e 80 00       	push   $0x803e70
  8017b3:	e8 55 f2 ff ff       	call   800a0d <cprintf>
  8017b8:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8017bb:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  8017c2:	00 00 00 
	}
}
  8017c5:	90                   	nop
  8017c6:	c9                   	leave  
  8017c7:	c3                   	ret    

008017c8 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8017c8:	55                   	push   %ebp
  8017c9:	89 e5                	mov    %esp,%ebp
  8017cb:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");
LIST_INIT(&AllocMemBlocksList);
  8017ce:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  8017d5:	00 00 00 
  8017d8:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  8017df:	00 00 00 
  8017e2:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  8017e9:	00 00 00 
LIST_INIT(&FreeMemBlocksList);
  8017ec:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  8017f3:	00 00 00 
  8017f6:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  8017fd:	00 00 00 
  801800:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801807:	00 00 00 
MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  80180a:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801811:	00 02 00 
uint32 requiredSpace=sizeof(struct MemBlock)*NUM_OF_UHEAP_PAGES;
  801814:	c7 45 f4 00 00 20 00 	movl   $0x200000,-0xc(%ebp)
		MemBlockNodes=(struct MemBlock*)USER_DYN_BLKS_ARRAY;
  80181b:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801822:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801825:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80182a:	2d 00 10 00 00       	sub    $0x1000,%eax
  80182f:	a3 50 50 80 00       	mov    %eax,0x805050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,requiredSpace,PERM_WRITEABLE|PERM_USER);
  801834:	c7 45 ec 00 00 e0 7f 	movl   $0x7fe00000,-0x14(%ebp)
  80183b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80183e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801843:	2d 00 10 00 00       	sub    $0x1000,%eax
  801848:	83 ec 04             	sub    $0x4,%esp
  80184b:	6a 06                	push   $0x6
  80184d:	ff 75 f4             	pushl  -0xc(%ebp)
  801850:	50                   	push   %eax
  801851:	e8 ee 05 00 00       	call   801e44 <sys_allocate_chunk>
  801856:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801859:	a1 20 51 80 00       	mov    0x805120,%eax
  80185e:	83 ec 0c             	sub    $0xc,%esp
  801861:	50                   	push   %eax
  801862:	e8 63 0c 00 00       	call   8024ca <initialize_MemBlocksList>
  801867:	83 c4 10             	add    $0x10,%esp
			struct MemBlock *freeSva=AvailableMemBlocksList.lh_last;
  80186a:	a1 4c 51 80 00       	mov    0x80514c,%eax
  80186f:	89 45 e8             	mov    %eax,-0x18(%ebp)
			freeSva->size=USER_HEAP_MAX-USER_HEAP_START;
  801872:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801875:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
			freeSva->size=ROUNDDOWN(freeSva->size,PAGE_SIZE);
  80187c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80187f:	8b 40 0c             	mov    0xc(%eax),%eax
  801882:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801885:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801888:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80188d:	89 c2                	mov    %eax,%edx
  80188f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801892:	89 50 0c             	mov    %edx,0xc(%eax)

			freeSva->sva=USER_HEAP_START;
  801895:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801898:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
			freeSva->sva=ROUNDUP(freeSva->sva,PAGE_SIZE);
  80189f:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8018a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018a9:	8b 50 08             	mov    0x8(%eax),%edx
  8018ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018af:	01 d0                	add    %edx,%eax
  8018b1:	48                   	dec    %eax
  8018b2:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8018b5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8018b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8018bd:	f7 75 e0             	divl   -0x20(%ebp)
  8018c0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8018c3:	29 d0                	sub    %edx,%eax
  8018c5:	89 c2                	mov    %eax,%edx
  8018c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018ca:	89 50 08             	mov    %edx,0x8(%eax)




			LIST_REMOVE(&AvailableMemBlocksList,freeSva);
  8018cd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8018d1:	75 14                	jne    8018e7 <initialize_dyn_block_system+0x11f>
  8018d3:	83 ec 04             	sub    $0x4,%esp
  8018d6:	68 95 3e 80 00       	push   $0x803e95
  8018db:	6a 34                	push   $0x34
  8018dd:	68 b3 3e 80 00       	push   $0x803eb3
  8018e2:	e8 72 ee ff ff       	call   800759 <_panic>
  8018e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018ea:	8b 00                	mov    (%eax),%eax
  8018ec:	85 c0                	test   %eax,%eax
  8018ee:	74 10                	je     801900 <initialize_dyn_block_system+0x138>
  8018f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018f3:	8b 00                	mov    (%eax),%eax
  8018f5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8018f8:	8b 52 04             	mov    0x4(%edx),%edx
  8018fb:	89 50 04             	mov    %edx,0x4(%eax)
  8018fe:	eb 0b                	jmp    80190b <initialize_dyn_block_system+0x143>
  801900:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801903:	8b 40 04             	mov    0x4(%eax),%eax
  801906:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80190b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80190e:	8b 40 04             	mov    0x4(%eax),%eax
  801911:	85 c0                	test   %eax,%eax
  801913:	74 0f                	je     801924 <initialize_dyn_block_system+0x15c>
  801915:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801918:	8b 40 04             	mov    0x4(%eax),%eax
  80191b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80191e:	8b 12                	mov    (%edx),%edx
  801920:	89 10                	mov    %edx,(%eax)
  801922:	eb 0a                	jmp    80192e <initialize_dyn_block_system+0x166>
  801924:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801927:	8b 00                	mov    (%eax),%eax
  801929:	a3 48 51 80 00       	mov    %eax,0x805148
  80192e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801931:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801937:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80193a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801941:	a1 54 51 80 00       	mov    0x805154,%eax
  801946:	48                   	dec    %eax
  801947:	a3 54 51 80 00       	mov    %eax,0x805154
			insert_sorted_with_merge_freeList(freeSva);
  80194c:	83 ec 0c             	sub    $0xc,%esp
  80194f:	ff 75 e8             	pushl  -0x18(%ebp)
  801952:	e8 c4 13 00 00       	call   802d1b <insert_sorted_with_merge_freeList>
  801957:	83 c4 10             	add    $0x10,%esp
//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  80195a:	90                   	nop
  80195b:	c9                   	leave  
  80195c:	c3                   	ret    

0080195d <malloc>:
//=================================



void* malloc(uint32 size)
{
  80195d:	55                   	push   %ebp
  80195e:	89 e5                	mov    %esp,%ebp
  801960:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801963:	e8 2f fe ff ff       	call   801797 <InitializeUHeap>
	if (size == 0) return NULL ;
  801968:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80196c:	75 07                	jne    801975 <malloc+0x18>
  80196e:	b8 00 00 00 00       	mov    $0x0,%eax
  801973:	eb 71                	jmp    8019e6 <malloc+0x89>
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");
if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  801975:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  80197c:	76 07                	jbe    801985 <malloc+0x28>
	return NULL;
  80197e:	b8 00 00 00 00       	mov    $0x0,%eax
  801983:	eb 61                	jmp    8019e6 <malloc+0x89>

	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801985:	e8 88 08 00 00       	call   802212 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80198a:	85 c0                	test   %eax,%eax
  80198c:	74 53                	je     8019e1 <malloc+0x84>
	        {
		struct MemBlock *returned_block;
		uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  80198e:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801995:	8b 55 08             	mov    0x8(%ebp),%edx
  801998:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80199b:	01 d0                	add    %edx,%eax
  80199d:	48                   	dec    %eax
  80199e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8019a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8019a9:	f7 75 f4             	divl   -0xc(%ebp)
  8019ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019af:	29 d0                	sub    %edx,%eax
  8019b1:	89 45 ec             	mov    %eax,-0x14(%ebp)
   returned_block=alloc_block_FF(newSize);
  8019b4:	83 ec 0c             	sub    $0xc,%esp
  8019b7:	ff 75 ec             	pushl  -0x14(%ebp)
  8019ba:	e8 d2 0d 00 00       	call   802791 <alloc_block_FF>
  8019bf:	83 c4 10             	add    $0x10,%esp
  8019c2:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(returned_block!=NULL)
  8019c5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8019c9:	74 16                	je     8019e1 <malloc+0x84>
    {
    	insert_sorted_allocList(returned_block);
  8019cb:	83 ec 0c             	sub    $0xc,%esp
  8019ce:	ff 75 e8             	pushl  -0x18(%ebp)
  8019d1:	e8 0c 0c 00 00       	call   8025e2 <insert_sorted_allocList>
  8019d6:	83 c4 10             	add    $0x10,%esp
	return(void*) returned_block->sva;
  8019d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8019dc:	8b 40 08             	mov    0x8(%eax),%eax
  8019df:	eb 05                	jmp    8019e6 <malloc+0x89>
    }

			}


	return NULL;
  8019e1:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  8019e6:	c9                   	leave  
  8019e7:	c3                   	ret    

008019e8 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8019e8:	55                   	push   %ebp
  8019e9:	89 e5                	mov    %esp,%ebp
  8019eb:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//you should get the size of the given allocation using its address
	uint32 va=ROUNDDOWN((uint32)virtual_address,PAGE_SIZE);
  8019ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8019f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019f7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8019fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *returned_block=find_block(&AllocMemBlocksList,va);
  8019ff:	83 ec 08             	sub    $0x8,%esp
  801a02:	ff 75 f0             	pushl  -0x10(%ebp)
  801a05:	68 40 50 80 00       	push   $0x805040
  801a0a:	e8 a0 0b 00 00       	call   8025af <find_block>
  801a0f:	83 c4 10             	add    $0x10,%esp
  801a12:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_free_user_mem((uint32)virtual_address,returned_block->size);
  801a15:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a18:	8b 50 0c             	mov    0xc(%eax),%edx
  801a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1e:	83 ec 08             	sub    $0x8,%esp
  801a21:	52                   	push   %edx
  801a22:	50                   	push   %eax
  801a23:	e8 e4 03 00 00       	call   801e0c <sys_free_user_mem>
  801a28:	83 c4 10             	add    $0x10,%esp

    LIST_REMOVE(&AllocMemBlocksList,returned_block);
  801a2b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801a2f:	75 17                	jne    801a48 <free+0x60>
  801a31:	83 ec 04             	sub    $0x4,%esp
  801a34:	68 95 3e 80 00       	push   $0x803e95
  801a39:	68 84 00 00 00       	push   $0x84
  801a3e:	68 b3 3e 80 00       	push   $0x803eb3
  801a43:	e8 11 ed ff ff       	call   800759 <_panic>
  801a48:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a4b:	8b 00                	mov    (%eax),%eax
  801a4d:	85 c0                	test   %eax,%eax
  801a4f:	74 10                	je     801a61 <free+0x79>
  801a51:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a54:	8b 00                	mov    (%eax),%eax
  801a56:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801a59:	8b 52 04             	mov    0x4(%edx),%edx
  801a5c:	89 50 04             	mov    %edx,0x4(%eax)
  801a5f:	eb 0b                	jmp    801a6c <free+0x84>
  801a61:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a64:	8b 40 04             	mov    0x4(%eax),%eax
  801a67:	a3 44 50 80 00       	mov    %eax,0x805044
  801a6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a6f:	8b 40 04             	mov    0x4(%eax),%eax
  801a72:	85 c0                	test   %eax,%eax
  801a74:	74 0f                	je     801a85 <free+0x9d>
  801a76:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a79:	8b 40 04             	mov    0x4(%eax),%eax
  801a7c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801a7f:	8b 12                	mov    (%edx),%edx
  801a81:	89 10                	mov    %edx,(%eax)
  801a83:	eb 0a                	jmp    801a8f <free+0xa7>
  801a85:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a88:	8b 00                	mov    (%eax),%eax
  801a8a:	a3 40 50 80 00       	mov    %eax,0x805040
  801a8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a92:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801a98:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a9b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801aa2:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801aa7:	48                   	dec    %eax
  801aa8:	a3 4c 50 80 00       	mov    %eax,0x80504c
	insert_sorted_with_merge_freeList(returned_block);
  801aad:	83 ec 0c             	sub    $0xc,%esp
  801ab0:	ff 75 ec             	pushl  -0x14(%ebp)
  801ab3:	e8 63 12 00 00       	call   802d1b <insert_sorted_with_merge_freeList>
  801ab8:	83 c4 10             	add    $0x10,%esp

	//you need to call sys_free_user_mem()
}
  801abb:	90                   	nop
  801abc:	c9                   	leave  
  801abd:	c3                   	ret    

00801abe <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801abe:	55                   	push   %ebp
  801abf:	89 e5                	mov    %esp,%ebp
  801ac1:	83 ec 38             	sub    $0x38,%esp
  801ac4:	8b 45 10             	mov    0x10(%ebp),%eax
  801ac7:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801aca:	e8 c8 fc ff ff       	call   801797 <InitializeUHeap>
	if (size == 0) return NULL ;
  801acf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ad3:	75 0a                	jne    801adf <smalloc+0x21>
  801ad5:	b8 00 00 00 00       	mov    $0x0,%eax
  801ada:	e9 a0 00 00 00       	jmp    801b7f <smalloc+0xc1>
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	// Steps:
	//	1) Implement FIRST FIT strategy to search the heap for suitable space
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  801adf:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  801ae6:	76 0a                	jbe    801af2 <smalloc+0x34>
		return NULL;
  801ae8:	b8 00 00 00 00       	mov    $0x0,%eax
  801aed:	e9 8d 00 00 00       	jmp    801b7f <smalloc+0xc1>

		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801af2:	e8 1b 07 00 00       	call   802212 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801af7:	85 c0                	test   %eax,%eax
  801af9:	74 7f                	je     801b7a <smalloc+0xbc>
		        {
			struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801afb:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801b02:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b08:	01 d0                	add    %edx,%eax
  801b0a:	48                   	dec    %eax
  801b0b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b11:	ba 00 00 00 00       	mov    $0x0,%edx
  801b16:	f7 75 f4             	divl   -0xc(%ebp)
  801b19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b1c:	29 d0                	sub    %edx,%eax
  801b1e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	   returned_block=alloc_block_FF(newSize);
  801b21:	83 ec 0c             	sub    $0xc,%esp
  801b24:	ff 75 ec             	pushl  -0x14(%ebp)
  801b27:	e8 65 0c 00 00       	call   802791 <alloc_block_FF>
  801b2c:	83 c4 10             	add    $0x10,%esp
  801b2f:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   if(returned_block!=NULL)
  801b32:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801b36:	74 42                	je     801b7a <smalloc+0xbc>
	      {
	      	   insert_sorted_allocList(returned_block);
  801b38:	83 ec 0c             	sub    $0xc,%esp
  801b3b:	ff 75 e8             	pushl  -0x18(%ebp)
  801b3e:	e8 9f 0a 00 00       	call   8025e2 <insert_sorted_allocList>
  801b43:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_createSharedObject(sharedVarName,size,isWritable,(void*)returned_block->sva);
  801b46:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b49:	8b 40 08             	mov    0x8(%eax),%eax
  801b4c:	89 c2                	mov    %eax,%edx
  801b4e:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801b52:	52                   	push   %edx
  801b53:	50                   	push   %eax
  801b54:	ff 75 0c             	pushl  0xc(%ebp)
  801b57:	ff 75 08             	pushl  0x8(%ebp)
  801b5a:	e8 38 04 00 00       	call   801f97 <sys_createSharedObject>
  801b5f:	83 c4 10             	add    $0x10,%esp
  801b62:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    	     if(ID<0)
  801b65:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801b69:	79 07                	jns    801b72 <smalloc+0xb4>
	    		  return NULL;
  801b6b:	b8 00 00 00 00       	mov    $0x0,%eax
  801b70:	eb 0d                	jmp    801b7f <smalloc+0xc1>
	  	return(void*) returned_block->sva;
  801b72:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b75:	8b 40 08             	mov    0x8(%eax),%eax
  801b78:	eb 05                	jmp    801b7f <smalloc+0xc1>


				}


		return NULL;
  801b7a:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801b7f:	c9                   	leave  
  801b80:	c3                   	ret    

00801b81 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801b81:	55                   	push   %ebp
  801b82:	89 e5                	mov    %esp,%ebp
  801b84:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801b87:	e8 0b fc ff ff       	call   801797 <InitializeUHeap>
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	// Steps:
	//	1) Get the size of the shared variable (use sys_getSizeOfSharedObject())
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  801b8c:	e8 81 06 00 00       	call   802212 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b91:	85 c0                	test   %eax,%eax
  801b93:	0f 84 9f 00 00 00    	je     801c38 <sget+0xb7>
	int size=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801b99:	83 ec 08             	sub    $0x8,%esp
  801b9c:	ff 75 0c             	pushl  0xc(%ebp)
  801b9f:	ff 75 08             	pushl  0x8(%ebp)
  801ba2:	e8 1a 04 00 00       	call   801fc1 <sys_getSizeOfSharedObject>
  801ba7:	83 c4 10             	add    $0x10,%esp
  801baa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size<0)
  801bad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801bb1:	79 0a                	jns    801bbd <sget+0x3c>
		return NULL;
  801bb3:	b8 00 00 00 00       	mov    $0x0,%eax
  801bb8:	e9 80 00 00 00       	jmp    801c3d <sget+0xbc>
	struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801bbd:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801bc4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bca:	01 d0                	add    %edx,%eax
  801bcc:	48                   	dec    %eax
  801bcd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801bd0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bd3:	ba 00 00 00 00       	mov    $0x0,%edx
  801bd8:	f7 75 f0             	divl   -0x10(%ebp)
  801bdb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bde:	29 d0                	sub    %edx,%eax
  801be0:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   returned_block=alloc_block_FF(newSize);
  801be3:	83 ec 0c             	sub    $0xc,%esp
  801be6:	ff 75 e8             	pushl  -0x18(%ebp)
  801be9:	e8 a3 0b 00 00       	call   802791 <alloc_block_FF>
  801bee:	83 c4 10             	add    $0x10,%esp
  801bf1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	   if(returned_block!=NULL)
  801bf4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801bf8:	74 3e                	je     801c38 <sget+0xb7>
	      {
	      	   insert_sorted_allocList(returned_block);
  801bfa:	83 ec 0c             	sub    $0xc,%esp
  801bfd:	ff 75 e4             	pushl  -0x1c(%ebp)
  801c00:	e8 dd 09 00 00       	call   8025e2 <insert_sorted_allocList>
  801c05:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)returned_block->sva);
  801c08:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c0b:	8b 40 08             	mov    0x8(%eax),%eax
  801c0e:	83 ec 04             	sub    $0x4,%esp
  801c11:	50                   	push   %eax
  801c12:	ff 75 0c             	pushl  0xc(%ebp)
  801c15:	ff 75 08             	pushl  0x8(%ebp)
  801c18:	e8 c1 03 00 00       	call   801fde <sys_getSharedObject>
  801c1d:	83 c4 10             	add    $0x10,%esp
  801c20:	89 45 e0             	mov    %eax,-0x20(%ebp)
	    	     if(ID<0)
  801c23:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801c27:	79 07                	jns    801c30 <sget+0xaf>
	    		  return NULL;
  801c29:	b8 00 00 00 00       	mov    $0x0,%eax
  801c2e:	eb 0d                	jmp    801c3d <sget+0xbc>
	  	return(void*) returned_block->sva;
  801c30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c33:	8b 40 08             	mov    0x8(%eax),%eax
  801c36:	eb 05                	jmp    801c3d <sget+0xbc>
	      }
	}
	   return NULL;
  801c38:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801c3d:	c9                   	leave  
  801c3e:	c3                   	ret    

00801c3f <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801c3f:	55                   	push   %ebp
  801c40:	89 e5                	mov    %esp,%ebp
  801c42:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801c45:	e8 4d fb ff ff       	call   801797 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801c4a:	83 ec 04             	sub    $0x4,%esp
  801c4d:	68 c0 3e 80 00       	push   $0x803ec0
  801c52:	68 12 01 00 00       	push   $0x112
  801c57:	68 b3 3e 80 00       	push   $0x803eb3
  801c5c:	e8 f8 ea ff ff       	call   800759 <_panic>

00801c61 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801c61:	55                   	push   %ebp
  801c62:	89 e5                	mov    %esp,%ebp
  801c64:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801c67:	83 ec 04             	sub    $0x4,%esp
  801c6a:	68 e8 3e 80 00       	push   $0x803ee8
  801c6f:	68 26 01 00 00       	push   $0x126
  801c74:	68 b3 3e 80 00       	push   $0x803eb3
  801c79:	e8 db ea ff ff       	call   800759 <_panic>

00801c7e <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801c7e:	55                   	push   %ebp
  801c7f:	89 e5                	mov    %esp,%ebp
  801c81:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c84:	83 ec 04             	sub    $0x4,%esp
  801c87:	68 0c 3f 80 00       	push   $0x803f0c
  801c8c:	68 31 01 00 00       	push   $0x131
  801c91:	68 b3 3e 80 00       	push   $0x803eb3
  801c96:	e8 be ea ff ff       	call   800759 <_panic>

00801c9b <shrink>:

}
void shrink(uint32 newSize)
{
  801c9b:	55                   	push   %ebp
  801c9c:	89 e5                	mov    %esp,%ebp
  801c9e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ca1:	83 ec 04             	sub    $0x4,%esp
  801ca4:	68 0c 3f 80 00       	push   $0x803f0c
  801ca9:	68 36 01 00 00       	push   $0x136
  801cae:	68 b3 3e 80 00       	push   $0x803eb3
  801cb3:	e8 a1 ea ff ff       	call   800759 <_panic>

00801cb8 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801cb8:	55                   	push   %ebp
  801cb9:	89 e5                	mov    %esp,%ebp
  801cbb:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801cbe:	83 ec 04             	sub    $0x4,%esp
  801cc1:	68 0c 3f 80 00       	push   $0x803f0c
  801cc6:	68 3b 01 00 00       	push   $0x13b
  801ccb:	68 b3 3e 80 00       	push   $0x803eb3
  801cd0:	e8 84 ea ff ff       	call   800759 <_panic>

00801cd5 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801cd5:	55                   	push   %ebp
  801cd6:	89 e5                	mov    %esp,%ebp
  801cd8:	57                   	push   %edi
  801cd9:	56                   	push   %esi
  801cda:	53                   	push   %ebx
  801cdb:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801cde:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ce4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ce7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cea:	8b 7d 18             	mov    0x18(%ebp),%edi
  801ced:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801cf0:	cd 30                	int    $0x30
  801cf2:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801cf5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801cf8:	83 c4 10             	add    $0x10,%esp
  801cfb:	5b                   	pop    %ebx
  801cfc:	5e                   	pop    %esi
  801cfd:	5f                   	pop    %edi
  801cfe:	5d                   	pop    %ebp
  801cff:	c3                   	ret    

00801d00 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801d00:	55                   	push   %ebp
  801d01:	89 e5                	mov    %esp,%ebp
  801d03:	83 ec 04             	sub    $0x4,%esp
  801d06:	8b 45 10             	mov    0x10(%ebp),%eax
  801d09:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801d0c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d10:	8b 45 08             	mov    0x8(%ebp),%eax
  801d13:	6a 00                	push   $0x0
  801d15:	6a 00                	push   $0x0
  801d17:	52                   	push   %edx
  801d18:	ff 75 0c             	pushl  0xc(%ebp)
  801d1b:	50                   	push   %eax
  801d1c:	6a 00                	push   $0x0
  801d1e:	e8 b2 ff ff ff       	call   801cd5 <syscall>
  801d23:	83 c4 18             	add    $0x18,%esp
}
  801d26:	90                   	nop
  801d27:	c9                   	leave  
  801d28:	c3                   	ret    

00801d29 <sys_cgetc>:

int
sys_cgetc(void)
{
  801d29:	55                   	push   %ebp
  801d2a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801d2c:	6a 00                	push   $0x0
  801d2e:	6a 00                	push   $0x0
  801d30:	6a 00                	push   $0x0
  801d32:	6a 00                	push   $0x0
  801d34:	6a 00                	push   $0x0
  801d36:	6a 01                	push   $0x1
  801d38:	e8 98 ff ff ff       	call   801cd5 <syscall>
  801d3d:	83 c4 18             	add    $0x18,%esp
}
  801d40:	c9                   	leave  
  801d41:	c3                   	ret    

00801d42 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801d42:	55                   	push   %ebp
  801d43:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801d45:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d48:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4b:	6a 00                	push   $0x0
  801d4d:	6a 00                	push   $0x0
  801d4f:	6a 00                	push   $0x0
  801d51:	52                   	push   %edx
  801d52:	50                   	push   %eax
  801d53:	6a 05                	push   $0x5
  801d55:	e8 7b ff ff ff       	call   801cd5 <syscall>
  801d5a:	83 c4 18             	add    $0x18,%esp
}
  801d5d:	c9                   	leave  
  801d5e:	c3                   	ret    

00801d5f <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801d5f:	55                   	push   %ebp
  801d60:	89 e5                	mov    %esp,%ebp
  801d62:	56                   	push   %esi
  801d63:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801d64:	8b 75 18             	mov    0x18(%ebp),%esi
  801d67:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d6a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d6d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d70:	8b 45 08             	mov    0x8(%ebp),%eax
  801d73:	56                   	push   %esi
  801d74:	53                   	push   %ebx
  801d75:	51                   	push   %ecx
  801d76:	52                   	push   %edx
  801d77:	50                   	push   %eax
  801d78:	6a 06                	push   $0x6
  801d7a:	e8 56 ff ff ff       	call   801cd5 <syscall>
  801d7f:	83 c4 18             	add    $0x18,%esp
}
  801d82:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d85:	5b                   	pop    %ebx
  801d86:	5e                   	pop    %esi
  801d87:	5d                   	pop    %ebp
  801d88:	c3                   	ret    

00801d89 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801d89:	55                   	push   %ebp
  801d8a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801d8c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d92:	6a 00                	push   $0x0
  801d94:	6a 00                	push   $0x0
  801d96:	6a 00                	push   $0x0
  801d98:	52                   	push   %edx
  801d99:	50                   	push   %eax
  801d9a:	6a 07                	push   $0x7
  801d9c:	e8 34 ff ff ff       	call   801cd5 <syscall>
  801da1:	83 c4 18             	add    $0x18,%esp
}
  801da4:	c9                   	leave  
  801da5:	c3                   	ret    

00801da6 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801da6:	55                   	push   %ebp
  801da7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801da9:	6a 00                	push   $0x0
  801dab:	6a 00                	push   $0x0
  801dad:	6a 00                	push   $0x0
  801daf:	ff 75 0c             	pushl  0xc(%ebp)
  801db2:	ff 75 08             	pushl  0x8(%ebp)
  801db5:	6a 08                	push   $0x8
  801db7:	e8 19 ff ff ff       	call   801cd5 <syscall>
  801dbc:	83 c4 18             	add    $0x18,%esp
}
  801dbf:	c9                   	leave  
  801dc0:	c3                   	ret    

00801dc1 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801dc1:	55                   	push   %ebp
  801dc2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801dc4:	6a 00                	push   $0x0
  801dc6:	6a 00                	push   $0x0
  801dc8:	6a 00                	push   $0x0
  801dca:	6a 00                	push   $0x0
  801dcc:	6a 00                	push   $0x0
  801dce:	6a 09                	push   $0x9
  801dd0:	e8 00 ff ff ff       	call   801cd5 <syscall>
  801dd5:	83 c4 18             	add    $0x18,%esp
}
  801dd8:	c9                   	leave  
  801dd9:	c3                   	ret    

00801dda <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801dda:	55                   	push   %ebp
  801ddb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801ddd:	6a 00                	push   $0x0
  801ddf:	6a 00                	push   $0x0
  801de1:	6a 00                	push   $0x0
  801de3:	6a 00                	push   $0x0
  801de5:	6a 00                	push   $0x0
  801de7:	6a 0a                	push   $0xa
  801de9:	e8 e7 fe ff ff       	call   801cd5 <syscall>
  801dee:	83 c4 18             	add    $0x18,%esp
}
  801df1:	c9                   	leave  
  801df2:	c3                   	ret    

00801df3 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801df3:	55                   	push   %ebp
  801df4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801df6:	6a 00                	push   $0x0
  801df8:	6a 00                	push   $0x0
  801dfa:	6a 00                	push   $0x0
  801dfc:	6a 00                	push   $0x0
  801dfe:	6a 00                	push   $0x0
  801e00:	6a 0b                	push   $0xb
  801e02:	e8 ce fe ff ff       	call   801cd5 <syscall>
  801e07:	83 c4 18             	add    $0x18,%esp
}
  801e0a:	c9                   	leave  
  801e0b:	c3                   	ret    

00801e0c <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801e0c:	55                   	push   %ebp
  801e0d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 00                	push   $0x0
  801e13:	6a 00                	push   $0x0
  801e15:	ff 75 0c             	pushl  0xc(%ebp)
  801e18:	ff 75 08             	pushl  0x8(%ebp)
  801e1b:	6a 0f                	push   $0xf
  801e1d:	e8 b3 fe ff ff       	call   801cd5 <syscall>
  801e22:	83 c4 18             	add    $0x18,%esp
	return;
  801e25:	90                   	nop
}
  801e26:	c9                   	leave  
  801e27:	c3                   	ret    

00801e28 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801e28:	55                   	push   %ebp
  801e29:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 00                	push   $0x0
  801e31:	ff 75 0c             	pushl  0xc(%ebp)
  801e34:	ff 75 08             	pushl  0x8(%ebp)
  801e37:	6a 10                	push   $0x10
  801e39:	e8 97 fe ff ff       	call   801cd5 <syscall>
  801e3e:	83 c4 18             	add    $0x18,%esp
	return ;
  801e41:	90                   	nop
}
  801e42:	c9                   	leave  
  801e43:	c3                   	ret    

00801e44 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801e44:	55                   	push   %ebp
  801e45:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801e47:	6a 00                	push   $0x0
  801e49:	6a 00                	push   $0x0
  801e4b:	ff 75 10             	pushl  0x10(%ebp)
  801e4e:	ff 75 0c             	pushl  0xc(%ebp)
  801e51:	ff 75 08             	pushl  0x8(%ebp)
  801e54:	6a 11                	push   $0x11
  801e56:	e8 7a fe ff ff       	call   801cd5 <syscall>
  801e5b:	83 c4 18             	add    $0x18,%esp
	return ;
  801e5e:	90                   	nop
}
  801e5f:	c9                   	leave  
  801e60:	c3                   	ret    

00801e61 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801e61:	55                   	push   %ebp
  801e62:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801e64:	6a 00                	push   $0x0
  801e66:	6a 00                	push   $0x0
  801e68:	6a 00                	push   $0x0
  801e6a:	6a 00                	push   $0x0
  801e6c:	6a 00                	push   $0x0
  801e6e:	6a 0c                	push   $0xc
  801e70:	e8 60 fe ff ff       	call   801cd5 <syscall>
  801e75:	83 c4 18             	add    $0x18,%esp
}
  801e78:	c9                   	leave  
  801e79:	c3                   	ret    

00801e7a <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801e7a:	55                   	push   %ebp
  801e7b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801e7d:	6a 00                	push   $0x0
  801e7f:	6a 00                	push   $0x0
  801e81:	6a 00                	push   $0x0
  801e83:	6a 00                	push   $0x0
  801e85:	ff 75 08             	pushl  0x8(%ebp)
  801e88:	6a 0d                	push   $0xd
  801e8a:	e8 46 fe ff ff       	call   801cd5 <syscall>
  801e8f:	83 c4 18             	add    $0x18,%esp
}
  801e92:	c9                   	leave  
  801e93:	c3                   	ret    

00801e94 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801e94:	55                   	push   %ebp
  801e95:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801e97:	6a 00                	push   $0x0
  801e99:	6a 00                	push   $0x0
  801e9b:	6a 00                	push   $0x0
  801e9d:	6a 00                	push   $0x0
  801e9f:	6a 00                	push   $0x0
  801ea1:	6a 0e                	push   $0xe
  801ea3:	e8 2d fe ff ff       	call   801cd5 <syscall>
  801ea8:	83 c4 18             	add    $0x18,%esp
}
  801eab:	90                   	nop
  801eac:	c9                   	leave  
  801ead:	c3                   	ret    

00801eae <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801eae:	55                   	push   %ebp
  801eaf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801eb1:	6a 00                	push   $0x0
  801eb3:	6a 00                	push   $0x0
  801eb5:	6a 00                	push   $0x0
  801eb7:	6a 00                	push   $0x0
  801eb9:	6a 00                	push   $0x0
  801ebb:	6a 13                	push   $0x13
  801ebd:	e8 13 fe ff ff       	call   801cd5 <syscall>
  801ec2:	83 c4 18             	add    $0x18,%esp
}
  801ec5:	90                   	nop
  801ec6:	c9                   	leave  
  801ec7:	c3                   	ret    

00801ec8 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801ec8:	55                   	push   %ebp
  801ec9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801ecb:	6a 00                	push   $0x0
  801ecd:	6a 00                	push   $0x0
  801ecf:	6a 00                	push   $0x0
  801ed1:	6a 00                	push   $0x0
  801ed3:	6a 00                	push   $0x0
  801ed5:	6a 14                	push   $0x14
  801ed7:	e8 f9 fd ff ff       	call   801cd5 <syscall>
  801edc:	83 c4 18             	add    $0x18,%esp
}
  801edf:	90                   	nop
  801ee0:	c9                   	leave  
  801ee1:	c3                   	ret    

00801ee2 <sys_cputc>:


void
sys_cputc(const char c)
{
  801ee2:	55                   	push   %ebp
  801ee3:	89 e5                	mov    %esp,%ebp
  801ee5:	83 ec 04             	sub    $0x4,%esp
  801ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  801eeb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801eee:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ef2:	6a 00                	push   $0x0
  801ef4:	6a 00                	push   $0x0
  801ef6:	6a 00                	push   $0x0
  801ef8:	6a 00                	push   $0x0
  801efa:	50                   	push   %eax
  801efb:	6a 15                	push   $0x15
  801efd:	e8 d3 fd ff ff       	call   801cd5 <syscall>
  801f02:	83 c4 18             	add    $0x18,%esp
}
  801f05:	90                   	nop
  801f06:	c9                   	leave  
  801f07:	c3                   	ret    

00801f08 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801f08:	55                   	push   %ebp
  801f09:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801f0b:	6a 00                	push   $0x0
  801f0d:	6a 00                	push   $0x0
  801f0f:	6a 00                	push   $0x0
  801f11:	6a 00                	push   $0x0
  801f13:	6a 00                	push   $0x0
  801f15:	6a 16                	push   $0x16
  801f17:	e8 b9 fd ff ff       	call   801cd5 <syscall>
  801f1c:	83 c4 18             	add    $0x18,%esp
}
  801f1f:	90                   	nop
  801f20:	c9                   	leave  
  801f21:	c3                   	ret    

00801f22 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801f22:	55                   	push   %ebp
  801f23:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801f25:	8b 45 08             	mov    0x8(%ebp),%eax
  801f28:	6a 00                	push   $0x0
  801f2a:	6a 00                	push   $0x0
  801f2c:	6a 00                	push   $0x0
  801f2e:	ff 75 0c             	pushl  0xc(%ebp)
  801f31:	50                   	push   %eax
  801f32:	6a 17                	push   $0x17
  801f34:	e8 9c fd ff ff       	call   801cd5 <syscall>
  801f39:	83 c4 18             	add    $0x18,%esp
}
  801f3c:	c9                   	leave  
  801f3d:	c3                   	ret    

00801f3e <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801f3e:	55                   	push   %ebp
  801f3f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f41:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f44:	8b 45 08             	mov    0x8(%ebp),%eax
  801f47:	6a 00                	push   $0x0
  801f49:	6a 00                	push   $0x0
  801f4b:	6a 00                	push   $0x0
  801f4d:	52                   	push   %edx
  801f4e:	50                   	push   %eax
  801f4f:	6a 1a                	push   $0x1a
  801f51:	e8 7f fd ff ff       	call   801cd5 <syscall>
  801f56:	83 c4 18             	add    $0x18,%esp
}
  801f59:	c9                   	leave  
  801f5a:	c3                   	ret    

00801f5b <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801f5b:	55                   	push   %ebp
  801f5c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f61:	8b 45 08             	mov    0x8(%ebp),%eax
  801f64:	6a 00                	push   $0x0
  801f66:	6a 00                	push   $0x0
  801f68:	6a 00                	push   $0x0
  801f6a:	52                   	push   %edx
  801f6b:	50                   	push   %eax
  801f6c:	6a 18                	push   $0x18
  801f6e:	e8 62 fd ff ff       	call   801cd5 <syscall>
  801f73:	83 c4 18             	add    $0x18,%esp
}
  801f76:	90                   	nop
  801f77:	c9                   	leave  
  801f78:	c3                   	ret    

00801f79 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801f79:	55                   	push   %ebp
  801f7a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f7c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f82:	6a 00                	push   $0x0
  801f84:	6a 00                	push   $0x0
  801f86:	6a 00                	push   $0x0
  801f88:	52                   	push   %edx
  801f89:	50                   	push   %eax
  801f8a:	6a 19                	push   $0x19
  801f8c:	e8 44 fd ff ff       	call   801cd5 <syscall>
  801f91:	83 c4 18             	add    $0x18,%esp
}
  801f94:	90                   	nop
  801f95:	c9                   	leave  
  801f96:	c3                   	ret    

00801f97 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801f97:	55                   	push   %ebp
  801f98:	89 e5                	mov    %esp,%ebp
  801f9a:	83 ec 04             	sub    $0x4,%esp
  801f9d:	8b 45 10             	mov    0x10(%ebp),%eax
  801fa0:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801fa3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801fa6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801faa:	8b 45 08             	mov    0x8(%ebp),%eax
  801fad:	6a 00                	push   $0x0
  801faf:	51                   	push   %ecx
  801fb0:	52                   	push   %edx
  801fb1:	ff 75 0c             	pushl  0xc(%ebp)
  801fb4:	50                   	push   %eax
  801fb5:	6a 1b                	push   $0x1b
  801fb7:	e8 19 fd ff ff       	call   801cd5 <syscall>
  801fbc:	83 c4 18             	add    $0x18,%esp
}
  801fbf:	c9                   	leave  
  801fc0:	c3                   	ret    

00801fc1 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801fc1:	55                   	push   %ebp
  801fc2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801fc4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801fca:	6a 00                	push   $0x0
  801fcc:	6a 00                	push   $0x0
  801fce:	6a 00                	push   $0x0
  801fd0:	52                   	push   %edx
  801fd1:	50                   	push   %eax
  801fd2:	6a 1c                	push   $0x1c
  801fd4:	e8 fc fc ff ff       	call   801cd5 <syscall>
  801fd9:	83 c4 18             	add    $0x18,%esp
}
  801fdc:	c9                   	leave  
  801fdd:	c3                   	ret    

00801fde <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801fde:	55                   	push   %ebp
  801fdf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801fe1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801fe4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  801fea:	6a 00                	push   $0x0
  801fec:	6a 00                	push   $0x0
  801fee:	51                   	push   %ecx
  801fef:	52                   	push   %edx
  801ff0:	50                   	push   %eax
  801ff1:	6a 1d                	push   $0x1d
  801ff3:	e8 dd fc ff ff       	call   801cd5 <syscall>
  801ff8:	83 c4 18             	add    $0x18,%esp
}
  801ffb:	c9                   	leave  
  801ffc:	c3                   	ret    

00801ffd <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801ffd:	55                   	push   %ebp
  801ffe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802000:	8b 55 0c             	mov    0xc(%ebp),%edx
  802003:	8b 45 08             	mov    0x8(%ebp),%eax
  802006:	6a 00                	push   $0x0
  802008:	6a 00                	push   $0x0
  80200a:	6a 00                	push   $0x0
  80200c:	52                   	push   %edx
  80200d:	50                   	push   %eax
  80200e:	6a 1e                	push   $0x1e
  802010:	e8 c0 fc ff ff       	call   801cd5 <syscall>
  802015:	83 c4 18             	add    $0x18,%esp
}
  802018:	c9                   	leave  
  802019:	c3                   	ret    

0080201a <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80201a:	55                   	push   %ebp
  80201b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80201d:	6a 00                	push   $0x0
  80201f:	6a 00                	push   $0x0
  802021:	6a 00                	push   $0x0
  802023:	6a 00                	push   $0x0
  802025:	6a 00                	push   $0x0
  802027:	6a 1f                	push   $0x1f
  802029:	e8 a7 fc ff ff       	call   801cd5 <syscall>
  80202e:	83 c4 18             	add    $0x18,%esp
}
  802031:	c9                   	leave  
  802032:	c3                   	ret    

00802033 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802033:	55                   	push   %ebp
  802034:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802036:	8b 45 08             	mov    0x8(%ebp),%eax
  802039:	6a 00                	push   $0x0
  80203b:	ff 75 14             	pushl  0x14(%ebp)
  80203e:	ff 75 10             	pushl  0x10(%ebp)
  802041:	ff 75 0c             	pushl  0xc(%ebp)
  802044:	50                   	push   %eax
  802045:	6a 20                	push   $0x20
  802047:	e8 89 fc ff ff       	call   801cd5 <syscall>
  80204c:	83 c4 18             	add    $0x18,%esp
}
  80204f:	c9                   	leave  
  802050:	c3                   	ret    

00802051 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802051:	55                   	push   %ebp
  802052:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802054:	8b 45 08             	mov    0x8(%ebp),%eax
  802057:	6a 00                	push   $0x0
  802059:	6a 00                	push   $0x0
  80205b:	6a 00                	push   $0x0
  80205d:	6a 00                	push   $0x0
  80205f:	50                   	push   %eax
  802060:	6a 21                	push   $0x21
  802062:	e8 6e fc ff ff       	call   801cd5 <syscall>
  802067:	83 c4 18             	add    $0x18,%esp
}
  80206a:	90                   	nop
  80206b:	c9                   	leave  
  80206c:	c3                   	ret    

0080206d <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80206d:	55                   	push   %ebp
  80206e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802070:	8b 45 08             	mov    0x8(%ebp),%eax
  802073:	6a 00                	push   $0x0
  802075:	6a 00                	push   $0x0
  802077:	6a 00                	push   $0x0
  802079:	6a 00                	push   $0x0
  80207b:	50                   	push   %eax
  80207c:	6a 22                	push   $0x22
  80207e:	e8 52 fc ff ff       	call   801cd5 <syscall>
  802083:	83 c4 18             	add    $0x18,%esp
}
  802086:	c9                   	leave  
  802087:	c3                   	ret    

00802088 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802088:	55                   	push   %ebp
  802089:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80208b:	6a 00                	push   $0x0
  80208d:	6a 00                	push   $0x0
  80208f:	6a 00                	push   $0x0
  802091:	6a 00                	push   $0x0
  802093:	6a 00                	push   $0x0
  802095:	6a 02                	push   $0x2
  802097:	e8 39 fc ff ff       	call   801cd5 <syscall>
  80209c:	83 c4 18             	add    $0x18,%esp
}
  80209f:	c9                   	leave  
  8020a0:	c3                   	ret    

008020a1 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8020a1:	55                   	push   %ebp
  8020a2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8020a4:	6a 00                	push   $0x0
  8020a6:	6a 00                	push   $0x0
  8020a8:	6a 00                	push   $0x0
  8020aa:	6a 00                	push   $0x0
  8020ac:	6a 00                	push   $0x0
  8020ae:	6a 03                	push   $0x3
  8020b0:	e8 20 fc ff ff       	call   801cd5 <syscall>
  8020b5:	83 c4 18             	add    $0x18,%esp
}
  8020b8:	c9                   	leave  
  8020b9:	c3                   	ret    

008020ba <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8020ba:	55                   	push   %ebp
  8020bb:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8020bd:	6a 00                	push   $0x0
  8020bf:	6a 00                	push   $0x0
  8020c1:	6a 00                	push   $0x0
  8020c3:	6a 00                	push   $0x0
  8020c5:	6a 00                	push   $0x0
  8020c7:	6a 04                	push   $0x4
  8020c9:	e8 07 fc ff ff       	call   801cd5 <syscall>
  8020ce:	83 c4 18             	add    $0x18,%esp
}
  8020d1:	c9                   	leave  
  8020d2:	c3                   	ret    

008020d3 <sys_exit_env>:


void sys_exit_env(void)
{
  8020d3:	55                   	push   %ebp
  8020d4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8020d6:	6a 00                	push   $0x0
  8020d8:	6a 00                	push   $0x0
  8020da:	6a 00                	push   $0x0
  8020dc:	6a 00                	push   $0x0
  8020de:	6a 00                	push   $0x0
  8020e0:	6a 23                	push   $0x23
  8020e2:	e8 ee fb ff ff       	call   801cd5 <syscall>
  8020e7:	83 c4 18             	add    $0x18,%esp
}
  8020ea:	90                   	nop
  8020eb:	c9                   	leave  
  8020ec:	c3                   	ret    

008020ed <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8020ed:	55                   	push   %ebp
  8020ee:	89 e5                	mov    %esp,%ebp
  8020f0:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8020f3:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8020f6:	8d 50 04             	lea    0x4(%eax),%edx
  8020f9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8020fc:	6a 00                	push   $0x0
  8020fe:	6a 00                	push   $0x0
  802100:	6a 00                	push   $0x0
  802102:	52                   	push   %edx
  802103:	50                   	push   %eax
  802104:	6a 24                	push   $0x24
  802106:	e8 ca fb ff ff       	call   801cd5 <syscall>
  80210b:	83 c4 18             	add    $0x18,%esp
	return result;
  80210e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802111:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802114:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802117:	89 01                	mov    %eax,(%ecx)
  802119:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80211c:	8b 45 08             	mov    0x8(%ebp),%eax
  80211f:	c9                   	leave  
  802120:	c2 04 00             	ret    $0x4

00802123 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802123:	55                   	push   %ebp
  802124:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802126:	6a 00                	push   $0x0
  802128:	6a 00                	push   $0x0
  80212a:	ff 75 10             	pushl  0x10(%ebp)
  80212d:	ff 75 0c             	pushl  0xc(%ebp)
  802130:	ff 75 08             	pushl  0x8(%ebp)
  802133:	6a 12                	push   $0x12
  802135:	e8 9b fb ff ff       	call   801cd5 <syscall>
  80213a:	83 c4 18             	add    $0x18,%esp
	return ;
  80213d:	90                   	nop
}
  80213e:	c9                   	leave  
  80213f:	c3                   	ret    

00802140 <sys_rcr2>:
uint32 sys_rcr2()
{
  802140:	55                   	push   %ebp
  802141:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802143:	6a 00                	push   $0x0
  802145:	6a 00                	push   $0x0
  802147:	6a 00                	push   $0x0
  802149:	6a 00                	push   $0x0
  80214b:	6a 00                	push   $0x0
  80214d:	6a 25                	push   $0x25
  80214f:	e8 81 fb ff ff       	call   801cd5 <syscall>
  802154:	83 c4 18             	add    $0x18,%esp
}
  802157:	c9                   	leave  
  802158:	c3                   	ret    

00802159 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802159:	55                   	push   %ebp
  80215a:	89 e5                	mov    %esp,%ebp
  80215c:	83 ec 04             	sub    $0x4,%esp
  80215f:	8b 45 08             	mov    0x8(%ebp),%eax
  802162:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802165:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802169:	6a 00                	push   $0x0
  80216b:	6a 00                	push   $0x0
  80216d:	6a 00                	push   $0x0
  80216f:	6a 00                	push   $0x0
  802171:	50                   	push   %eax
  802172:	6a 26                	push   $0x26
  802174:	e8 5c fb ff ff       	call   801cd5 <syscall>
  802179:	83 c4 18             	add    $0x18,%esp
	return ;
  80217c:	90                   	nop
}
  80217d:	c9                   	leave  
  80217e:	c3                   	ret    

0080217f <rsttst>:
void rsttst()
{
  80217f:	55                   	push   %ebp
  802180:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802182:	6a 00                	push   $0x0
  802184:	6a 00                	push   $0x0
  802186:	6a 00                	push   $0x0
  802188:	6a 00                	push   $0x0
  80218a:	6a 00                	push   $0x0
  80218c:	6a 28                	push   $0x28
  80218e:	e8 42 fb ff ff       	call   801cd5 <syscall>
  802193:	83 c4 18             	add    $0x18,%esp
	return ;
  802196:	90                   	nop
}
  802197:	c9                   	leave  
  802198:	c3                   	ret    

00802199 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802199:	55                   	push   %ebp
  80219a:	89 e5                	mov    %esp,%ebp
  80219c:	83 ec 04             	sub    $0x4,%esp
  80219f:	8b 45 14             	mov    0x14(%ebp),%eax
  8021a2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8021a5:	8b 55 18             	mov    0x18(%ebp),%edx
  8021a8:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8021ac:	52                   	push   %edx
  8021ad:	50                   	push   %eax
  8021ae:	ff 75 10             	pushl  0x10(%ebp)
  8021b1:	ff 75 0c             	pushl  0xc(%ebp)
  8021b4:	ff 75 08             	pushl  0x8(%ebp)
  8021b7:	6a 27                	push   $0x27
  8021b9:	e8 17 fb ff ff       	call   801cd5 <syscall>
  8021be:	83 c4 18             	add    $0x18,%esp
	return ;
  8021c1:	90                   	nop
}
  8021c2:	c9                   	leave  
  8021c3:	c3                   	ret    

008021c4 <chktst>:
void chktst(uint32 n)
{
  8021c4:	55                   	push   %ebp
  8021c5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8021c7:	6a 00                	push   $0x0
  8021c9:	6a 00                	push   $0x0
  8021cb:	6a 00                	push   $0x0
  8021cd:	6a 00                	push   $0x0
  8021cf:	ff 75 08             	pushl  0x8(%ebp)
  8021d2:	6a 29                	push   $0x29
  8021d4:	e8 fc fa ff ff       	call   801cd5 <syscall>
  8021d9:	83 c4 18             	add    $0x18,%esp
	return ;
  8021dc:	90                   	nop
}
  8021dd:	c9                   	leave  
  8021de:	c3                   	ret    

008021df <inctst>:

void inctst()
{
  8021df:	55                   	push   %ebp
  8021e0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8021e2:	6a 00                	push   $0x0
  8021e4:	6a 00                	push   $0x0
  8021e6:	6a 00                	push   $0x0
  8021e8:	6a 00                	push   $0x0
  8021ea:	6a 00                	push   $0x0
  8021ec:	6a 2a                	push   $0x2a
  8021ee:	e8 e2 fa ff ff       	call   801cd5 <syscall>
  8021f3:	83 c4 18             	add    $0x18,%esp
	return ;
  8021f6:	90                   	nop
}
  8021f7:	c9                   	leave  
  8021f8:	c3                   	ret    

008021f9 <gettst>:
uint32 gettst()
{
  8021f9:	55                   	push   %ebp
  8021fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8021fc:	6a 00                	push   $0x0
  8021fe:	6a 00                	push   $0x0
  802200:	6a 00                	push   $0x0
  802202:	6a 00                	push   $0x0
  802204:	6a 00                	push   $0x0
  802206:	6a 2b                	push   $0x2b
  802208:	e8 c8 fa ff ff       	call   801cd5 <syscall>
  80220d:	83 c4 18             	add    $0x18,%esp
}
  802210:	c9                   	leave  
  802211:	c3                   	ret    

00802212 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802212:	55                   	push   %ebp
  802213:	89 e5                	mov    %esp,%ebp
  802215:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802218:	6a 00                	push   $0x0
  80221a:	6a 00                	push   $0x0
  80221c:	6a 00                	push   $0x0
  80221e:	6a 00                	push   $0x0
  802220:	6a 00                	push   $0x0
  802222:	6a 2c                	push   $0x2c
  802224:	e8 ac fa ff ff       	call   801cd5 <syscall>
  802229:	83 c4 18             	add    $0x18,%esp
  80222c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80222f:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802233:	75 07                	jne    80223c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802235:	b8 01 00 00 00       	mov    $0x1,%eax
  80223a:	eb 05                	jmp    802241 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80223c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802241:	c9                   	leave  
  802242:	c3                   	ret    

00802243 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802243:	55                   	push   %ebp
  802244:	89 e5                	mov    %esp,%ebp
  802246:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802249:	6a 00                	push   $0x0
  80224b:	6a 00                	push   $0x0
  80224d:	6a 00                	push   $0x0
  80224f:	6a 00                	push   $0x0
  802251:	6a 00                	push   $0x0
  802253:	6a 2c                	push   $0x2c
  802255:	e8 7b fa ff ff       	call   801cd5 <syscall>
  80225a:	83 c4 18             	add    $0x18,%esp
  80225d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802260:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802264:	75 07                	jne    80226d <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802266:	b8 01 00 00 00       	mov    $0x1,%eax
  80226b:	eb 05                	jmp    802272 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80226d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802272:	c9                   	leave  
  802273:	c3                   	ret    

00802274 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802274:	55                   	push   %ebp
  802275:	89 e5                	mov    %esp,%ebp
  802277:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80227a:	6a 00                	push   $0x0
  80227c:	6a 00                	push   $0x0
  80227e:	6a 00                	push   $0x0
  802280:	6a 00                	push   $0x0
  802282:	6a 00                	push   $0x0
  802284:	6a 2c                	push   $0x2c
  802286:	e8 4a fa ff ff       	call   801cd5 <syscall>
  80228b:	83 c4 18             	add    $0x18,%esp
  80228e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802291:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802295:	75 07                	jne    80229e <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802297:	b8 01 00 00 00       	mov    $0x1,%eax
  80229c:	eb 05                	jmp    8022a3 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80229e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022a3:	c9                   	leave  
  8022a4:	c3                   	ret    

008022a5 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8022a5:	55                   	push   %ebp
  8022a6:	89 e5                	mov    %esp,%ebp
  8022a8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022ab:	6a 00                	push   $0x0
  8022ad:	6a 00                	push   $0x0
  8022af:	6a 00                	push   $0x0
  8022b1:	6a 00                	push   $0x0
  8022b3:	6a 00                	push   $0x0
  8022b5:	6a 2c                	push   $0x2c
  8022b7:	e8 19 fa ff ff       	call   801cd5 <syscall>
  8022bc:	83 c4 18             	add    $0x18,%esp
  8022bf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8022c2:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8022c6:	75 07                	jne    8022cf <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8022c8:	b8 01 00 00 00       	mov    $0x1,%eax
  8022cd:	eb 05                	jmp    8022d4 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8022cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022d4:	c9                   	leave  
  8022d5:	c3                   	ret    

008022d6 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8022d6:	55                   	push   %ebp
  8022d7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8022d9:	6a 00                	push   $0x0
  8022db:	6a 00                	push   $0x0
  8022dd:	6a 00                	push   $0x0
  8022df:	6a 00                	push   $0x0
  8022e1:	ff 75 08             	pushl  0x8(%ebp)
  8022e4:	6a 2d                	push   $0x2d
  8022e6:	e8 ea f9 ff ff       	call   801cd5 <syscall>
  8022eb:	83 c4 18             	add    $0x18,%esp
	return ;
  8022ee:	90                   	nop
}
  8022ef:	c9                   	leave  
  8022f0:	c3                   	ret    

008022f1 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8022f1:	55                   	push   %ebp
  8022f2:	89 e5                	mov    %esp,%ebp
  8022f4:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8022f5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8022f8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8022fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802301:	6a 00                	push   $0x0
  802303:	53                   	push   %ebx
  802304:	51                   	push   %ecx
  802305:	52                   	push   %edx
  802306:	50                   	push   %eax
  802307:	6a 2e                	push   $0x2e
  802309:	e8 c7 f9 ff ff       	call   801cd5 <syscall>
  80230e:	83 c4 18             	add    $0x18,%esp
}
  802311:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802314:	c9                   	leave  
  802315:	c3                   	ret    

00802316 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802316:	55                   	push   %ebp
  802317:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802319:	8b 55 0c             	mov    0xc(%ebp),%edx
  80231c:	8b 45 08             	mov    0x8(%ebp),%eax
  80231f:	6a 00                	push   $0x0
  802321:	6a 00                	push   $0x0
  802323:	6a 00                	push   $0x0
  802325:	52                   	push   %edx
  802326:	50                   	push   %eax
  802327:	6a 2f                	push   $0x2f
  802329:	e8 a7 f9 ff ff       	call   801cd5 <syscall>
  80232e:	83 c4 18             	add    $0x18,%esp
}
  802331:	c9                   	leave  
  802332:	c3                   	ret    

00802333 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802333:	55                   	push   %ebp
  802334:	89 e5                	mov    %esp,%ebp
  802336:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802339:	83 ec 0c             	sub    $0xc,%esp
  80233c:	68 1c 3f 80 00       	push   $0x803f1c
  802341:	e8 c7 e6 ff ff       	call   800a0d <cprintf>
  802346:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802349:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802350:	83 ec 0c             	sub    $0xc,%esp
  802353:	68 48 3f 80 00       	push   $0x803f48
  802358:	e8 b0 e6 ff ff       	call   800a0d <cprintf>
  80235d:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802360:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802364:	a1 38 51 80 00       	mov    0x805138,%eax
  802369:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80236c:	eb 56                	jmp    8023c4 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80236e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802372:	74 1c                	je     802390 <print_mem_block_lists+0x5d>
  802374:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802377:	8b 50 08             	mov    0x8(%eax),%edx
  80237a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80237d:	8b 48 08             	mov    0x8(%eax),%ecx
  802380:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802383:	8b 40 0c             	mov    0xc(%eax),%eax
  802386:	01 c8                	add    %ecx,%eax
  802388:	39 c2                	cmp    %eax,%edx
  80238a:	73 04                	jae    802390 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  80238c:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802390:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802393:	8b 50 08             	mov    0x8(%eax),%edx
  802396:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802399:	8b 40 0c             	mov    0xc(%eax),%eax
  80239c:	01 c2                	add    %eax,%edx
  80239e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a1:	8b 40 08             	mov    0x8(%eax),%eax
  8023a4:	83 ec 04             	sub    $0x4,%esp
  8023a7:	52                   	push   %edx
  8023a8:	50                   	push   %eax
  8023a9:	68 5d 3f 80 00       	push   $0x803f5d
  8023ae:	e8 5a e6 ff ff       	call   800a0d <cprintf>
  8023b3:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8023b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8023bc:	a1 40 51 80 00       	mov    0x805140,%eax
  8023c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023c8:	74 07                	je     8023d1 <print_mem_block_lists+0x9e>
  8023ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cd:	8b 00                	mov    (%eax),%eax
  8023cf:	eb 05                	jmp    8023d6 <print_mem_block_lists+0xa3>
  8023d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8023d6:	a3 40 51 80 00       	mov    %eax,0x805140
  8023db:	a1 40 51 80 00       	mov    0x805140,%eax
  8023e0:	85 c0                	test   %eax,%eax
  8023e2:	75 8a                	jne    80236e <print_mem_block_lists+0x3b>
  8023e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023e8:	75 84                	jne    80236e <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8023ea:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8023ee:	75 10                	jne    802400 <print_mem_block_lists+0xcd>
  8023f0:	83 ec 0c             	sub    $0xc,%esp
  8023f3:	68 6c 3f 80 00       	push   $0x803f6c
  8023f8:	e8 10 e6 ff ff       	call   800a0d <cprintf>
  8023fd:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802400:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802407:	83 ec 0c             	sub    $0xc,%esp
  80240a:	68 90 3f 80 00       	push   $0x803f90
  80240f:	e8 f9 e5 ff ff       	call   800a0d <cprintf>
  802414:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802417:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80241b:	a1 40 50 80 00       	mov    0x805040,%eax
  802420:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802423:	eb 56                	jmp    80247b <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802425:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802429:	74 1c                	je     802447 <print_mem_block_lists+0x114>
  80242b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242e:	8b 50 08             	mov    0x8(%eax),%edx
  802431:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802434:	8b 48 08             	mov    0x8(%eax),%ecx
  802437:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80243a:	8b 40 0c             	mov    0xc(%eax),%eax
  80243d:	01 c8                	add    %ecx,%eax
  80243f:	39 c2                	cmp    %eax,%edx
  802441:	73 04                	jae    802447 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802443:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802447:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244a:	8b 50 08             	mov    0x8(%eax),%edx
  80244d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802450:	8b 40 0c             	mov    0xc(%eax),%eax
  802453:	01 c2                	add    %eax,%edx
  802455:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802458:	8b 40 08             	mov    0x8(%eax),%eax
  80245b:	83 ec 04             	sub    $0x4,%esp
  80245e:	52                   	push   %edx
  80245f:	50                   	push   %eax
  802460:	68 5d 3f 80 00       	push   $0x803f5d
  802465:	e8 a3 e5 ff ff       	call   800a0d <cprintf>
  80246a:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80246d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802470:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802473:	a1 48 50 80 00       	mov    0x805048,%eax
  802478:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80247b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80247f:	74 07                	je     802488 <print_mem_block_lists+0x155>
  802481:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802484:	8b 00                	mov    (%eax),%eax
  802486:	eb 05                	jmp    80248d <print_mem_block_lists+0x15a>
  802488:	b8 00 00 00 00       	mov    $0x0,%eax
  80248d:	a3 48 50 80 00       	mov    %eax,0x805048
  802492:	a1 48 50 80 00       	mov    0x805048,%eax
  802497:	85 c0                	test   %eax,%eax
  802499:	75 8a                	jne    802425 <print_mem_block_lists+0xf2>
  80249b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80249f:	75 84                	jne    802425 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8024a1:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8024a5:	75 10                	jne    8024b7 <print_mem_block_lists+0x184>
  8024a7:	83 ec 0c             	sub    $0xc,%esp
  8024aa:	68 a8 3f 80 00       	push   $0x803fa8
  8024af:	e8 59 e5 ff ff       	call   800a0d <cprintf>
  8024b4:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8024b7:	83 ec 0c             	sub    $0xc,%esp
  8024ba:	68 1c 3f 80 00       	push   $0x803f1c
  8024bf:	e8 49 e5 ff ff       	call   800a0d <cprintf>
  8024c4:	83 c4 10             	add    $0x10,%esp

}
  8024c7:	90                   	nop
  8024c8:	c9                   	leave  
  8024c9:	c3                   	ret    

008024ca <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8024ca:	55                   	push   %ebp
  8024cb:	89 e5                	mov    %esp,%ebp
  8024cd:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);
  8024d0:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8024d7:	00 00 00 
  8024da:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8024e1:	00 00 00 
  8024e4:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8024eb:	00 00 00 

		struct MemBlock *tmp=MemBlockNodes;
  8024ee:	a1 50 50 80 00       	mov    0x805050,%eax
  8024f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (int i=0;i<numOfBlocks;i++)
  8024f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8024fd:	e9 9e 00 00 00       	jmp    8025a0 <initialize_MemBlocksList+0xd6>
		{

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  802502:	a1 50 50 80 00       	mov    0x805050,%eax
  802507:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80250a:	c1 e2 04             	shl    $0x4,%edx
  80250d:	01 d0                	add    %edx,%eax
  80250f:	85 c0                	test   %eax,%eax
  802511:	75 14                	jne    802527 <initialize_MemBlocksList+0x5d>
  802513:	83 ec 04             	sub    $0x4,%esp
  802516:	68 d0 3f 80 00       	push   $0x803fd0
  80251b:	6a 48                	push   $0x48
  80251d:	68 f3 3f 80 00       	push   $0x803ff3
  802522:	e8 32 e2 ff ff       	call   800759 <_panic>
  802527:	a1 50 50 80 00       	mov    0x805050,%eax
  80252c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80252f:	c1 e2 04             	shl    $0x4,%edx
  802532:	01 d0                	add    %edx,%eax
  802534:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80253a:	89 10                	mov    %edx,(%eax)
  80253c:	8b 00                	mov    (%eax),%eax
  80253e:	85 c0                	test   %eax,%eax
  802540:	74 18                	je     80255a <initialize_MemBlocksList+0x90>
  802542:	a1 48 51 80 00       	mov    0x805148,%eax
  802547:	8b 15 50 50 80 00    	mov    0x805050,%edx
  80254d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802550:	c1 e1 04             	shl    $0x4,%ecx
  802553:	01 ca                	add    %ecx,%edx
  802555:	89 50 04             	mov    %edx,0x4(%eax)
  802558:	eb 12                	jmp    80256c <initialize_MemBlocksList+0xa2>
  80255a:	a1 50 50 80 00       	mov    0x805050,%eax
  80255f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802562:	c1 e2 04             	shl    $0x4,%edx
  802565:	01 d0                	add    %edx,%eax
  802567:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80256c:	a1 50 50 80 00       	mov    0x805050,%eax
  802571:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802574:	c1 e2 04             	shl    $0x4,%edx
  802577:	01 d0                	add    %edx,%eax
  802579:	a3 48 51 80 00       	mov    %eax,0x805148
  80257e:	a1 50 50 80 00       	mov    0x805050,%eax
  802583:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802586:	c1 e2 04             	shl    $0x4,%edx
  802589:	01 d0                	add    %edx,%eax
  80258b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802592:	a1 54 51 80 00       	mov    0x805154,%eax
  802597:	40                   	inc    %eax
  802598:	a3 54 51 80 00       	mov    %eax,0x805154
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);

		struct MemBlock *tmp=MemBlockNodes;
		for (int i=0;i<numOfBlocks;i++)
  80259d:	ff 45 f4             	incl   -0xc(%ebp)
  8025a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025a6:	0f 82 56 ff ff ff    	jb     802502 <initialize_MemBlocksList+0x38>

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
		}


}
  8025ac:	90                   	nop
  8025ad:	c9                   	leave  
  8025ae:	c3                   	ret    

008025af <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8025af:	55                   	push   %ebp
  8025b0:	89 e5                	mov    %esp,%ebp
  8025b2:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;
  8025b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b8:	8b 00                	mov    (%eax),%eax
  8025ba:	89 45 fc             	mov    %eax,-0x4(%ebp)

	while(tmp!=NULL)
  8025bd:	eb 18                	jmp    8025d7 <find_block+0x28>
		{
			if(tmp->sva==va)
  8025bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025c2:	8b 40 08             	mov    0x8(%eax),%eax
  8025c5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8025c8:	75 05                	jne    8025cf <find_block+0x20>
			{
				return tmp;
  8025ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025cd:	eb 11                	jmp    8025e0 <find_block+0x31>

			}
		tmp=tmp->prev_next_info.le_next;
  8025cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025d2:	8b 00                	mov    (%eax),%eax
  8025d4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;

	while(tmp!=NULL)
  8025d7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8025db:	75 e2                	jne    8025bf <find_block+0x10>
				return tmp;

			}
		tmp=tmp->prev_next_info.le_next;
		}
		return tmp;
  8025dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
//
//		}
//
//		}
//			return tmp;
}
  8025e0:	c9                   	leave  
  8025e1:	c3                   	ret    

008025e2 <insert_sorted_allocList>:
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================


void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8025e2:	55                   	push   %ebp
  8025e3:	89 e5                	mov    %esp,%ebp
  8025e5:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code

	if(AllocMemBlocksList.lh_first==NULL)
  8025e8:	a1 40 50 80 00       	mov    0x805040,%eax
  8025ed:	85 c0                	test   %eax,%eax
  8025ef:	0f 85 83 00 00 00    	jne    802678 <insert_sorted_allocList+0x96>
	{
		LIST_INIT(&AllocMemBlocksList);
  8025f5:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  8025fc:	00 00 00 
  8025ff:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  802606:	00 00 00 
  802609:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  802610:	00 00 00 
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802613:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802617:	75 14                	jne    80262d <insert_sorted_allocList+0x4b>
  802619:	83 ec 04             	sub    $0x4,%esp
  80261c:	68 d0 3f 80 00       	push   $0x803fd0
  802621:	6a 7f                	push   $0x7f
  802623:	68 f3 3f 80 00       	push   $0x803ff3
  802628:	e8 2c e1 ff ff       	call   800759 <_panic>
  80262d:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802633:	8b 45 08             	mov    0x8(%ebp),%eax
  802636:	89 10                	mov    %edx,(%eax)
  802638:	8b 45 08             	mov    0x8(%ebp),%eax
  80263b:	8b 00                	mov    (%eax),%eax
  80263d:	85 c0                	test   %eax,%eax
  80263f:	74 0d                	je     80264e <insert_sorted_allocList+0x6c>
  802641:	a1 40 50 80 00       	mov    0x805040,%eax
  802646:	8b 55 08             	mov    0x8(%ebp),%edx
  802649:	89 50 04             	mov    %edx,0x4(%eax)
  80264c:	eb 08                	jmp    802656 <insert_sorted_allocList+0x74>
  80264e:	8b 45 08             	mov    0x8(%ebp),%eax
  802651:	a3 44 50 80 00       	mov    %eax,0x805044
  802656:	8b 45 08             	mov    0x8(%ebp),%eax
  802659:	a3 40 50 80 00       	mov    %eax,0x805040
  80265e:	8b 45 08             	mov    0x8(%ebp),%eax
  802661:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802668:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80266d:	40                   	inc    %eax
  80266e:	a3 4c 50 80 00       	mov    %eax,0x80504c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802673:	e9 16 01 00 00       	jmp    80278e <insert_sorted_allocList+0x1ac>
		LIST_INIT(&AllocMemBlocksList);
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}


	else if(blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  802678:	8b 45 08             	mov    0x8(%ebp),%eax
  80267b:	8b 50 08             	mov    0x8(%eax),%edx
  80267e:	a1 44 50 80 00       	mov    0x805044,%eax
  802683:	8b 40 08             	mov    0x8(%eax),%eax
  802686:	39 c2                	cmp    %eax,%edx
  802688:	76 68                	jbe    8026f2 <insert_sorted_allocList+0x110>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
  80268a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80268e:	75 17                	jne    8026a7 <insert_sorted_allocList+0xc5>
  802690:	83 ec 04             	sub    $0x4,%esp
  802693:	68 0c 40 80 00       	push   $0x80400c
  802698:	68 85 00 00 00       	push   $0x85
  80269d:	68 f3 3f 80 00       	push   $0x803ff3
  8026a2:	e8 b2 e0 ff ff       	call   800759 <_panic>
  8026a7:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8026ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b0:	89 50 04             	mov    %edx,0x4(%eax)
  8026b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b6:	8b 40 04             	mov    0x4(%eax),%eax
  8026b9:	85 c0                	test   %eax,%eax
  8026bb:	74 0c                	je     8026c9 <insert_sorted_allocList+0xe7>
  8026bd:	a1 44 50 80 00       	mov    0x805044,%eax
  8026c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8026c5:	89 10                	mov    %edx,(%eax)
  8026c7:	eb 08                	jmp    8026d1 <insert_sorted_allocList+0xef>
  8026c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8026cc:	a3 40 50 80 00       	mov    %eax,0x805040
  8026d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d4:	a3 44 50 80 00       	mov    %eax,0x805044
  8026d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8026dc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026e2:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8026e7:	40                   	inc    %eax
  8026e8:	a3 4c 50 80 00       	mov    %eax,0x80504c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8026ed:	e9 9c 00 00 00       	jmp    80278e <insert_sorted_allocList+0x1ac>
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
  8026f2:	a1 40 50 80 00       	mov    0x805040,%eax
  8026f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  8026fa:	e9 85 00 00 00       	jmp    802784 <insert_sorted_allocList+0x1a2>
		{
			if(blockToInsert->sva<tmp->sva)
  8026ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802702:	8b 50 08             	mov    0x8(%eax),%edx
  802705:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802708:	8b 40 08             	mov    0x8(%eax),%eax
  80270b:	39 c2                	cmp    %eax,%edx
  80270d:	73 6d                	jae    80277c <insert_sorted_allocList+0x19a>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
  80270f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802713:	74 06                	je     80271b <insert_sorted_allocList+0x139>
  802715:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802719:	75 17                	jne    802732 <insert_sorted_allocList+0x150>
  80271b:	83 ec 04             	sub    $0x4,%esp
  80271e:	68 30 40 80 00       	push   $0x804030
  802723:	68 90 00 00 00       	push   $0x90
  802728:	68 f3 3f 80 00       	push   $0x803ff3
  80272d:	e8 27 e0 ff ff       	call   800759 <_panic>
  802732:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802735:	8b 50 04             	mov    0x4(%eax),%edx
  802738:	8b 45 08             	mov    0x8(%ebp),%eax
  80273b:	89 50 04             	mov    %edx,0x4(%eax)
  80273e:	8b 45 08             	mov    0x8(%ebp),%eax
  802741:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802744:	89 10                	mov    %edx,(%eax)
  802746:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802749:	8b 40 04             	mov    0x4(%eax),%eax
  80274c:	85 c0                	test   %eax,%eax
  80274e:	74 0d                	je     80275d <insert_sorted_allocList+0x17b>
  802750:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802753:	8b 40 04             	mov    0x4(%eax),%eax
  802756:	8b 55 08             	mov    0x8(%ebp),%edx
  802759:	89 10                	mov    %edx,(%eax)
  80275b:	eb 08                	jmp    802765 <insert_sorted_allocList+0x183>
  80275d:	8b 45 08             	mov    0x8(%ebp),%eax
  802760:	a3 40 50 80 00       	mov    %eax,0x805040
  802765:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802768:	8b 55 08             	mov    0x8(%ebp),%edx
  80276b:	89 50 04             	mov    %edx,0x4(%eax)
  80276e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802773:	40                   	inc    %eax
  802774:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802779:	90                   	nop
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  80277a:	eb 12                	jmp    80278e <insert_sorted_allocList+0x1ac>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
				break;
			}
			tmp=tmp->prev_next_info.le_next;
  80277c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277f:	8b 00                	mov    (%eax),%eax
  802781:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
		while(tmp!=NULL)
  802784:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802788:	0f 85 71 ff ff ff    	jne    8026ff <insert_sorted_allocList+0x11d>
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  80278e:	90                   	nop
  80278f:	c9                   	leave  
  802790:	c3                   	ret    

00802791 <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

struct MemBlock *alloc_block_FF(uint32 size)
{
  802791:	55                   	push   %ebp
  802792:	89 e5                	mov    %esp,%ebp
  802794:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  802797:	a1 38 51 80 00       	mov    0x805138,%eax
  80279c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	while(tmp!=NULL)
  80279f:	e9 76 01 00 00       	jmp    80291a <alloc_block_FF+0x189>
	{
		if(size==(tmp->size))
  8027a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a7:	8b 40 0c             	mov    0xc(%eax),%eax
  8027aa:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027ad:	0f 85 8a 00 00 00    	jne    80283d <alloc_block_FF+0xac>
		{

			LIST_REMOVE(&FreeMemBlocksList,tmp);
  8027b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027b7:	75 17                	jne    8027d0 <alloc_block_FF+0x3f>
  8027b9:	83 ec 04             	sub    $0x4,%esp
  8027bc:	68 65 40 80 00       	push   $0x804065
  8027c1:	68 a8 00 00 00       	push   $0xa8
  8027c6:	68 f3 3f 80 00       	push   $0x803ff3
  8027cb:	e8 89 df ff ff       	call   800759 <_panic>
  8027d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d3:	8b 00                	mov    (%eax),%eax
  8027d5:	85 c0                	test   %eax,%eax
  8027d7:	74 10                	je     8027e9 <alloc_block_FF+0x58>
  8027d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027dc:	8b 00                	mov    (%eax),%eax
  8027de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027e1:	8b 52 04             	mov    0x4(%edx),%edx
  8027e4:	89 50 04             	mov    %edx,0x4(%eax)
  8027e7:	eb 0b                	jmp    8027f4 <alloc_block_FF+0x63>
  8027e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ec:	8b 40 04             	mov    0x4(%eax),%eax
  8027ef:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8027f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f7:	8b 40 04             	mov    0x4(%eax),%eax
  8027fa:	85 c0                	test   %eax,%eax
  8027fc:	74 0f                	je     80280d <alloc_block_FF+0x7c>
  8027fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802801:	8b 40 04             	mov    0x4(%eax),%eax
  802804:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802807:	8b 12                	mov    (%edx),%edx
  802809:	89 10                	mov    %edx,(%eax)
  80280b:	eb 0a                	jmp    802817 <alloc_block_FF+0x86>
  80280d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802810:	8b 00                	mov    (%eax),%eax
  802812:	a3 38 51 80 00       	mov    %eax,0x805138
  802817:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802820:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802823:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80282a:	a1 44 51 80 00       	mov    0x805144,%eax
  80282f:	48                   	dec    %eax
  802830:	a3 44 51 80 00       	mov    %eax,0x805144

			return tmp;
  802835:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802838:	e9 ea 00 00 00       	jmp    802927 <alloc_block_FF+0x196>

		}
		else if(size<tmp->size)
  80283d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802840:	8b 40 0c             	mov    0xc(%eax),%eax
  802843:	3b 45 08             	cmp    0x8(%ebp),%eax
  802846:	0f 86 c6 00 00 00    	jbe    802912 <alloc_block_FF+0x181>
		{

			 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  80284c:	a1 48 51 80 00       	mov    0x805148,%eax
  802851:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 newBlock->size=size;
  802854:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802857:	8b 55 08             	mov    0x8(%ebp),%edx
  80285a:	89 50 0c             	mov    %edx,0xc(%eax)
			 newBlock->sva=tmp->sva;
  80285d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802860:	8b 50 08             	mov    0x8(%eax),%edx
  802863:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802866:	89 50 08             	mov    %edx,0x8(%eax)
			 tmp->size=tmp->size-size;
  802869:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286c:	8b 40 0c             	mov    0xc(%eax),%eax
  80286f:	2b 45 08             	sub    0x8(%ebp),%eax
  802872:	89 c2                	mov    %eax,%edx
  802874:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802877:	89 50 0c             	mov    %edx,0xc(%eax)
			 tmp->sva=tmp->sva+size;
  80287a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287d:	8b 50 08             	mov    0x8(%eax),%edx
  802880:	8b 45 08             	mov    0x8(%ebp),%eax
  802883:	01 c2                	add    %eax,%edx
  802885:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802888:	89 50 08             	mov    %edx,0x8(%eax)

			 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  80288b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80288f:	75 17                	jne    8028a8 <alloc_block_FF+0x117>
  802891:	83 ec 04             	sub    $0x4,%esp
  802894:	68 65 40 80 00       	push   $0x804065
  802899:	68 b6 00 00 00       	push   $0xb6
  80289e:	68 f3 3f 80 00       	push   $0x803ff3
  8028a3:	e8 b1 de ff ff       	call   800759 <_panic>
  8028a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ab:	8b 00                	mov    (%eax),%eax
  8028ad:	85 c0                	test   %eax,%eax
  8028af:	74 10                	je     8028c1 <alloc_block_FF+0x130>
  8028b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b4:	8b 00                	mov    (%eax),%eax
  8028b6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028b9:	8b 52 04             	mov    0x4(%edx),%edx
  8028bc:	89 50 04             	mov    %edx,0x4(%eax)
  8028bf:	eb 0b                	jmp    8028cc <alloc_block_FF+0x13b>
  8028c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c4:	8b 40 04             	mov    0x4(%eax),%eax
  8028c7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8028cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028cf:	8b 40 04             	mov    0x4(%eax),%eax
  8028d2:	85 c0                	test   %eax,%eax
  8028d4:	74 0f                	je     8028e5 <alloc_block_FF+0x154>
  8028d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028d9:	8b 40 04             	mov    0x4(%eax),%eax
  8028dc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028df:	8b 12                	mov    (%edx),%edx
  8028e1:	89 10                	mov    %edx,(%eax)
  8028e3:	eb 0a                	jmp    8028ef <alloc_block_FF+0x15e>
  8028e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e8:	8b 00                	mov    (%eax),%eax
  8028ea:	a3 48 51 80 00       	mov    %eax,0x805148
  8028ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028fb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802902:	a1 54 51 80 00       	mov    0x805154,%eax
  802907:	48                   	dec    %eax
  802908:	a3 54 51 80 00       	mov    %eax,0x805154
			 return newBlock;
  80290d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802910:	eb 15                	jmp    802927 <alloc_block_FF+0x196>

		}
		tmp=tmp->prev_next_info.le_next;
  802912:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802915:	8b 00                	mov    (%eax),%eax
  802917:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;

	while(tmp!=NULL)
  80291a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80291e:	0f 85 80 fe ff ff    	jne    8027a4 <alloc_block_FF+0x13>
			 return newBlock;

		}
		tmp=tmp->prev_next_info.le_next;
	}
	return tmp;
  802924:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802927:	c9                   	leave  
  802928:	c3                   	ret    

00802929 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802929:	55                   	push   %ebp
  80292a:	89 e5                	mov    %esp,%ebp
  80292c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  80292f:	a1 38 51 80 00       	mov    0x805138,%eax
  802934:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 newSize=UINT_MAX;
  802937:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)


		while(tmp!=NULL)
  80293e:	e9 c0 00 00 00       	jmp    802a03 <alloc_block_BF+0xda>
		{
			if(size==(tmp->size))
  802943:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802946:	8b 40 0c             	mov    0xc(%eax),%eax
  802949:	3b 45 08             	cmp    0x8(%ebp),%eax
  80294c:	0f 85 8a 00 00 00    	jne    8029dc <alloc_block_BF+0xb3>
			{
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  802952:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802956:	75 17                	jne    80296f <alloc_block_BF+0x46>
  802958:	83 ec 04             	sub    $0x4,%esp
  80295b:	68 65 40 80 00       	push   $0x804065
  802960:	68 cf 00 00 00       	push   $0xcf
  802965:	68 f3 3f 80 00       	push   $0x803ff3
  80296a:	e8 ea dd ff ff       	call   800759 <_panic>
  80296f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802972:	8b 00                	mov    (%eax),%eax
  802974:	85 c0                	test   %eax,%eax
  802976:	74 10                	je     802988 <alloc_block_BF+0x5f>
  802978:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297b:	8b 00                	mov    (%eax),%eax
  80297d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802980:	8b 52 04             	mov    0x4(%edx),%edx
  802983:	89 50 04             	mov    %edx,0x4(%eax)
  802986:	eb 0b                	jmp    802993 <alloc_block_BF+0x6a>
  802988:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298b:	8b 40 04             	mov    0x4(%eax),%eax
  80298e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802993:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802996:	8b 40 04             	mov    0x4(%eax),%eax
  802999:	85 c0                	test   %eax,%eax
  80299b:	74 0f                	je     8029ac <alloc_block_BF+0x83>
  80299d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a0:	8b 40 04             	mov    0x4(%eax),%eax
  8029a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029a6:	8b 12                	mov    (%edx),%edx
  8029a8:	89 10                	mov    %edx,(%eax)
  8029aa:	eb 0a                	jmp    8029b6 <alloc_block_BF+0x8d>
  8029ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029af:	8b 00                	mov    (%eax),%eax
  8029b1:	a3 38 51 80 00       	mov    %eax,0x805138
  8029b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029c9:	a1 44 51 80 00       	mov    0x805144,%eax
  8029ce:	48                   	dec    %eax
  8029cf:	a3 44 51 80 00       	mov    %eax,0x805144
				return tmp;
  8029d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d7:	e9 2a 01 00 00       	jmp    802b06 <alloc_block_BF+0x1dd>

			}
			else if (tmp->size<newSize&&tmp->size>size)
  8029dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029df:	8b 40 0c             	mov    0xc(%eax),%eax
  8029e2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8029e5:	73 14                	jae    8029fb <alloc_block_BF+0xd2>
  8029e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ea:	8b 40 0c             	mov    0xc(%eax),%eax
  8029ed:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029f0:	76 09                	jbe    8029fb <alloc_block_BF+0xd2>
			{
				newSize=tmp->size;
  8029f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f5:	8b 40 0c             	mov    0xc(%eax),%eax
  8029f8:	89 45 f0             	mov    %eax,-0x10(%ebp)


			}
			tmp=tmp->prev_next_info.le_next;
  8029fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fe:	8b 00                	mov    (%eax),%eax
  802a00:	89 45 f4             	mov    %eax,-0xc(%ebp)

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
	uint32 newSize=UINT_MAX;


		while(tmp!=NULL)
  802a03:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a07:	0f 85 36 ff ff ff    	jne    802943 <alloc_block_BF+0x1a>
		}//tmp=NULL




			tmp =FreeMemBlocksList.lh_first;
  802a0d:	a1 38 51 80 00       	mov    0x805138,%eax
  802a12:	89 45 f4             	mov    %eax,-0xc(%ebp)
			while(tmp!=NULL)
  802a15:	e9 dd 00 00 00       	jmp    802af7 <alloc_block_BF+0x1ce>
			{
				if(tmp->size==newSize)
  802a1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1d:	8b 40 0c             	mov    0xc(%eax),%eax
  802a20:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802a23:	0f 85 c6 00 00 00    	jne    802aef <alloc_block_BF+0x1c6>
					{
					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802a29:	a1 48 51 80 00       	mov    0x805148,%eax
  802a2e:	89 45 ec             	mov    %eax,-0x14(%ebp)

								 newBlock->sva=tmp->sva;     //newBlock.sva=tmp.sva
  802a31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a34:	8b 50 08             	mov    0x8(%eax),%edx
  802a37:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a3a:	89 50 08             	mov    %edx,0x8(%eax)
								 newBlock->size=size;
  802a3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a40:	8b 55 08             	mov    0x8(%ebp),%edx
  802a43:	89 50 0c             	mov    %edx,0xc(%eax)

											 tmp->sva+=size;
  802a46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a49:	8b 50 08             	mov    0x8(%eax),%edx
  802a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4f:	01 c2                	add    %eax,%edx
  802a51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a54:	89 50 08             	mov    %edx,0x8(%eax)
											 tmp->size-=size;
  802a57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5a:	8b 40 0c             	mov    0xc(%eax),%eax
  802a5d:	2b 45 08             	sub    0x8(%ebp),%eax
  802a60:	89 c2                	mov    %eax,%edx
  802a62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a65:	89 50 0c             	mov    %edx,0xc(%eax)
											 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802a68:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a6c:	75 17                	jne    802a85 <alloc_block_BF+0x15c>
  802a6e:	83 ec 04             	sub    $0x4,%esp
  802a71:	68 65 40 80 00       	push   $0x804065
  802a76:	68 eb 00 00 00       	push   $0xeb
  802a7b:	68 f3 3f 80 00       	push   $0x803ff3
  802a80:	e8 d4 dc ff ff       	call   800759 <_panic>
  802a85:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a88:	8b 00                	mov    (%eax),%eax
  802a8a:	85 c0                	test   %eax,%eax
  802a8c:	74 10                	je     802a9e <alloc_block_BF+0x175>
  802a8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a91:	8b 00                	mov    (%eax),%eax
  802a93:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a96:	8b 52 04             	mov    0x4(%edx),%edx
  802a99:	89 50 04             	mov    %edx,0x4(%eax)
  802a9c:	eb 0b                	jmp    802aa9 <alloc_block_BF+0x180>
  802a9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aa1:	8b 40 04             	mov    0x4(%eax),%eax
  802aa4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802aa9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aac:	8b 40 04             	mov    0x4(%eax),%eax
  802aaf:	85 c0                	test   %eax,%eax
  802ab1:	74 0f                	je     802ac2 <alloc_block_BF+0x199>
  802ab3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ab6:	8b 40 04             	mov    0x4(%eax),%eax
  802ab9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802abc:	8b 12                	mov    (%edx),%edx
  802abe:	89 10                	mov    %edx,(%eax)
  802ac0:	eb 0a                	jmp    802acc <alloc_block_BF+0x1a3>
  802ac2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ac5:	8b 00                	mov    (%eax),%eax
  802ac7:	a3 48 51 80 00       	mov    %eax,0x805148
  802acc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802acf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ad5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ad8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802adf:	a1 54 51 80 00       	mov    0x805154,%eax
  802ae4:	48                   	dec    %eax
  802ae5:	a3 54 51 80 00       	mov    %eax,0x805154
											 return newBlock;
  802aea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aed:	eb 17                	jmp    802b06 <alloc_block_BF+0x1dd>

					}
				tmp=tmp->prev_next_info.le_next;
  802aef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af2:	8b 00                	mov    (%eax),%eax
  802af4:	89 45 f4             	mov    %eax,-0xc(%ebp)




			tmp =FreeMemBlocksList.lh_first;
			while(tmp!=NULL)
  802af7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802afb:	0f 85 19 ff ff ff    	jne    802a1a <alloc_block_BF+0xf1>
			//tmp ->  block newSize,Sva




		return NULL; //return NULL
  802b01:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802b06:	c9                   	leave  
  802b07:	c3                   	ret    

00802b08 <alloc_block_NF>:
//=========================================



struct MemBlock *alloc_block_NF(uint32 size)
{
  802b08:	55                   	push   %ebp
  802b09:	89 e5                	mov    %esp,%ebp
  802b0b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp1;
	uint32 currentSva;
	if(AllocMemBlocksList.lh_first==NULL)
  802b0e:	a1 40 50 80 00       	mov    0x805040,%eax
  802b13:	85 c0                	test   %eax,%eax
  802b15:	75 19                	jne    802b30 <alloc_block_NF+0x28>
	{
		tmp1=alloc_block_FF(size);
  802b17:	83 ec 0c             	sub    $0xc,%esp
  802b1a:	ff 75 08             	pushl  0x8(%ebp)
  802b1d:	e8 6f fc ff ff       	call   802791 <alloc_block_FF>
  802b22:	83 c4 10             	add    $0x10,%esp
  802b25:	89 45 f4             	mov    %eax,-0xc(%ebp)
		return tmp1;
  802b28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2b:	e9 e9 01 00 00       	jmp    802d19 <alloc_block_NF+0x211>
	}

			else
			{
            currentSva=AllocMemBlocksList.lh_last->sva;
  802b30:	a1 44 50 80 00       	mov    0x805044,%eax
  802b35:	8b 40 08             	mov    0x8(%eax),%eax
  802b38:	89 45 f0             	mov    %eax,-0x10(%ebp)
			tmp1=find_block(&FreeMemBlocksList,AllocMemBlocksList.lh_last->size+AllocMemBlocksList.lh_last->sva);
  802b3b:	a1 44 50 80 00       	mov    0x805044,%eax
  802b40:	8b 50 0c             	mov    0xc(%eax),%edx
  802b43:	a1 44 50 80 00       	mov    0x805044,%eax
  802b48:	8b 40 08             	mov    0x8(%eax),%eax
  802b4b:	01 d0                	add    %edx,%eax
  802b4d:	83 ec 08             	sub    $0x8,%esp
  802b50:	50                   	push   %eax
  802b51:	68 38 51 80 00       	push   $0x805138
  802b56:	e8 54 fa ff ff       	call   8025af <find_block>
  802b5b:	83 c4 10             	add    $0x10,%esp
  802b5e:	89 45 f4             	mov    %eax,-0xc(%ebp)


do
	{

		if(size==(tmp1->size))
  802b61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b64:	8b 40 0c             	mov    0xc(%eax),%eax
  802b67:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b6a:	0f 85 9b 00 00 00    	jne    802c0b <alloc_block_NF+0x103>
				{
			currentSva=tmp1->size+tmp1->sva;
  802b70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b73:	8b 50 0c             	mov    0xc(%eax),%edx
  802b76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b79:	8b 40 08             	mov    0x8(%eax),%eax
  802b7c:	01 d0                	add    %edx,%eax
  802b7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,tmp1);
  802b81:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b85:	75 17                	jne    802b9e <alloc_block_NF+0x96>
  802b87:	83 ec 04             	sub    $0x4,%esp
  802b8a:	68 65 40 80 00       	push   $0x804065
  802b8f:	68 1a 01 00 00       	push   $0x11a
  802b94:	68 f3 3f 80 00       	push   $0x803ff3
  802b99:	e8 bb db ff ff       	call   800759 <_panic>
  802b9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba1:	8b 00                	mov    (%eax),%eax
  802ba3:	85 c0                	test   %eax,%eax
  802ba5:	74 10                	je     802bb7 <alloc_block_NF+0xaf>
  802ba7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802baa:	8b 00                	mov    (%eax),%eax
  802bac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802baf:	8b 52 04             	mov    0x4(%edx),%edx
  802bb2:	89 50 04             	mov    %edx,0x4(%eax)
  802bb5:	eb 0b                	jmp    802bc2 <alloc_block_NF+0xba>
  802bb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bba:	8b 40 04             	mov    0x4(%eax),%eax
  802bbd:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802bc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc5:	8b 40 04             	mov    0x4(%eax),%eax
  802bc8:	85 c0                	test   %eax,%eax
  802bca:	74 0f                	je     802bdb <alloc_block_NF+0xd3>
  802bcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcf:	8b 40 04             	mov    0x4(%eax),%eax
  802bd2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bd5:	8b 12                	mov    (%edx),%edx
  802bd7:	89 10                	mov    %edx,(%eax)
  802bd9:	eb 0a                	jmp    802be5 <alloc_block_NF+0xdd>
  802bdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bde:	8b 00                	mov    (%eax),%eax
  802be0:	a3 38 51 80 00       	mov    %eax,0x805138
  802be5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bf8:	a1 44 51 80 00       	mov    0x805144,%eax
  802bfd:	48                   	dec    %eax
  802bfe:	a3 44 51 80 00       	mov    %eax,0x805144
					return tmp1;
  802c03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c06:	e9 0e 01 00 00       	jmp    802d19 <alloc_block_NF+0x211>

				}
				else if(size<tmp1->size)
  802c0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0e:	8b 40 0c             	mov    0xc(%eax),%eax
  802c11:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c14:	0f 86 cf 00 00 00    	jbe    802ce9 <alloc_block_NF+0x1e1>
				{

					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802c1a:	a1 48 51 80 00       	mov    0x805148,%eax
  802c1f:	89 45 ec             	mov    %eax,-0x14(%ebp)
					 newBlock->size=size;
  802c22:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c25:	8b 55 08             	mov    0x8(%ebp),%edx
  802c28:	89 50 0c             	mov    %edx,0xc(%eax)
					 newBlock->sva=tmp1->sva;
  802c2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2e:	8b 50 08             	mov    0x8(%eax),%edx
  802c31:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c34:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->sva+=size;
  802c37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3a:	8b 50 08             	mov    0x8(%eax),%edx
  802c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c40:	01 c2                	add    %eax,%edx
  802c42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c45:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->size-=size;
  802c48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4b:	8b 40 0c             	mov    0xc(%eax),%eax
  802c4e:	2b 45 08             	sub    0x8(%ebp),%eax
  802c51:	89 c2                	mov    %eax,%edx
  802c53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c56:	89 50 0c             	mov    %edx,0xc(%eax)
                     currentSva=tmp1->sva;
  802c59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5c:	8b 40 08             	mov    0x8(%eax),%eax
  802c5f:	89 45 f0             	mov    %eax,-0x10(%ebp)

					 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802c62:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c66:	75 17                	jne    802c7f <alloc_block_NF+0x177>
  802c68:	83 ec 04             	sub    $0x4,%esp
  802c6b:	68 65 40 80 00       	push   $0x804065
  802c70:	68 28 01 00 00       	push   $0x128
  802c75:	68 f3 3f 80 00       	push   $0x803ff3
  802c7a:	e8 da da ff ff       	call   800759 <_panic>
  802c7f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c82:	8b 00                	mov    (%eax),%eax
  802c84:	85 c0                	test   %eax,%eax
  802c86:	74 10                	je     802c98 <alloc_block_NF+0x190>
  802c88:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c8b:	8b 00                	mov    (%eax),%eax
  802c8d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c90:	8b 52 04             	mov    0x4(%edx),%edx
  802c93:	89 50 04             	mov    %edx,0x4(%eax)
  802c96:	eb 0b                	jmp    802ca3 <alloc_block_NF+0x19b>
  802c98:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c9b:	8b 40 04             	mov    0x4(%eax),%eax
  802c9e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ca3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ca6:	8b 40 04             	mov    0x4(%eax),%eax
  802ca9:	85 c0                	test   %eax,%eax
  802cab:	74 0f                	je     802cbc <alloc_block_NF+0x1b4>
  802cad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cb0:	8b 40 04             	mov    0x4(%eax),%eax
  802cb3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802cb6:	8b 12                	mov    (%edx),%edx
  802cb8:	89 10                	mov    %edx,(%eax)
  802cba:	eb 0a                	jmp    802cc6 <alloc_block_NF+0x1be>
  802cbc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cbf:	8b 00                	mov    (%eax),%eax
  802cc1:	a3 48 51 80 00       	mov    %eax,0x805148
  802cc6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cc9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ccf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cd2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cd9:	a1 54 51 80 00       	mov    0x805154,%eax
  802cde:	48                   	dec    %eax
  802cdf:	a3 54 51 80 00       	mov    %eax,0x805154
					 return newBlock;
  802ce4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ce7:	eb 30                	jmp    802d19 <alloc_block_NF+0x211>

				}
		if(tmp1==FreeMemBlocksList.lh_last)
  802ce9:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802cee:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802cf1:	75 0a                	jne    802cfd <alloc_block_NF+0x1f5>
			tmp1=FreeMemBlocksList.lh_first;
  802cf3:	a1 38 51 80 00       	mov    0x805138,%eax
  802cf8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cfb:	eb 08                	jmp    802d05 <alloc_block_NF+0x1fd>
		else
				tmp1=tmp1->prev_next_info.le_next;
  802cfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d00:	8b 00                	mov    (%eax),%eax
  802d02:	89 45 f4             	mov    %eax,-0xc(%ebp)


			}
while(tmp1->sva!=currentSva);
  802d05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d08:	8b 40 08             	mov    0x8(%eax),%eax
  802d0b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802d0e:	0f 85 4d fe ff ff    	jne    802b61 <alloc_block_NF+0x59>

			return NULL;
  802d14:	b8 00 00 00 00       	mov    $0x0,%eax

	}
  802d19:	c9                   	leave  
  802d1a:	c3                   	ret    

00802d1b <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802d1b:	55                   	push   %ebp
  802d1c:	89 e5                	mov    %esp,%ebp
  802d1e:	53                   	push   %ebx
  802d1f:	83 ec 14             	sub    $0x14,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	if(FreeMemBlocksList.lh_first==NULL)
  802d22:	a1 38 51 80 00       	mov    0x805138,%eax
  802d27:	85 c0                	test   %eax,%eax
  802d29:	0f 85 86 00 00 00    	jne    802db5 <insert_sorted_with_merge_freeList+0x9a>
	{
		LIST_INIT(&FreeMemBlocksList);
  802d2f:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  802d36:	00 00 00 
  802d39:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  802d40:	00 00 00 
  802d43:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  802d4a:	00 00 00 
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802d4d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d51:	75 17                	jne    802d6a <insert_sorted_with_merge_freeList+0x4f>
  802d53:	83 ec 04             	sub    $0x4,%esp
  802d56:	68 d0 3f 80 00       	push   $0x803fd0
  802d5b:	68 48 01 00 00       	push   $0x148
  802d60:	68 f3 3f 80 00       	push   $0x803ff3
  802d65:	e8 ef d9 ff ff       	call   800759 <_panic>
  802d6a:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802d70:	8b 45 08             	mov    0x8(%ebp),%eax
  802d73:	89 10                	mov    %edx,(%eax)
  802d75:	8b 45 08             	mov    0x8(%ebp),%eax
  802d78:	8b 00                	mov    (%eax),%eax
  802d7a:	85 c0                	test   %eax,%eax
  802d7c:	74 0d                	je     802d8b <insert_sorted_with_merge_freeList+0x70>
  802d7e:	a1 38 51 80 00       	mov    0x805138,%eax
  802d83:	8b 55 08             	mov    0x8(%ebp),%edx
  802d86:	89 50 04             	mov    %edx,0x4(%eax)
  802d89:	eb 08                	jmp    802d93 <insert_sorted_with_merge_freeList+0x78>
  802d8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d93:	8b 45 08             	mov    0x8(%ebp),%eax
  802d96:	a3 38 51 80 00       	mov    %eax,0x805138
  802d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802da5:	a1 44 51 80 00       	mov    0x805144,%eax
  802daa:	40                   	inc    %eax
  802dab:	a3 44 51 80 00       	mov    %eax,0x805144
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  802db0:	e9 73 07 00 00       	jmp    803528 <insert_sorted_with_merge_freeList+0x80d>
	if(FreeMemBlocksList.lh_first==NULL)
	{
		LIST_INIT(&FreeMemBlocksList);
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva!=(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  802db5:	8b 45 08             	mov    0x8(%ebp),%eax
  802db8:	8b 50 08             	mov    0x8(%eax),%edx
  802dbb:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802dc0:	8b 40 08             	mov    0x8(%eax),%eax
  802dc3:	39 c2                	cmp    %eax,%edx
  802dc5:	0f 86 84 00 00 00    	jbe    802e4f <insert_sorted_with_merge_freeList+0x134>
  802dcb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dce:	8b 50 08             	mov    0x8(%eax),%edx
  802dd1:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802dd6:	8b 48 0c             	mov    0xc(%eax),%ecx
  802dd9:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802dde:	8b 40 08             	mov    0x8(%eax),%eax
  802de1:	01 c8                	add    %ecx,%eax
  802de3:	39 c2                	cmp    %eax,%edx
  802de5:	74 68                	je     802e4f <insert_sorted_with_merge_freeList+0x134>
	{
		LIST_INSERT_TAIL(&FreeMemBlocksList,blockToInsert);
  802de7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802deb:	75 17                	jne    802e04 <insert_sorted_with_merge_freeList+0xe9>
  802ded:	83 ec 04             	sub    $0x4,%esp
  802df0:	68 0c 40 80 00       	push   $0x80400c
  802df5:	68 4c 01 00 00       	push   $0x14c
  802dfa:	68 f3 3f 80 00       	push   $0x803ff3
  802dff:	e8 55 d9 ff ff       	call   800759 <_panic>
  802e04:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802e0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0d:	89 50 04             	mov    %edx,0x4(%eax)
  802e10:	8b 45 08             	mov    0x8(%ebp),%eax
  802e13:	8b 40 04             	mov    0x4(%eax),%eax
  802e16:	85 c0                	test   %eax,%eax
  802e18:	74 0c                	je     802e26 <insert_sorted_with_merge_freeList+0x10b>
  802e1a:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802e1f:	8b 55 08             	mov    0x8(%ebp),%edx
  802e22:	89 10                	mov    %edx,(%eax)
  802e24:	eb 08                	jmp    802e2e <insert_sorted_with_merge_freeList+0x113>
  802e26:	8b 45 08             	mov    0x8(%ebp),%eax
  802e29:	a3 38 51 80 00       	mov    %eax,0x805138
  802e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e31:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e36:	8b 45 08             	mov    0x8(%ebp),%eax
  802e39:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e3f:	a1 44 51 80 00       	mov    0x805144,%eax
  802e44:	40                   	inc    %eax
  802e45:	a3 44 51 80 00       	mov    %eax,0x805144
  802e4a:	e9 d9 06 00 00       	jmp    803528 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva==(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  802e4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e52:	8b 50 08             	mov    0x8(%eax),%edx
  802e55:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802e5a:	8b 40 08             	mov    0x8(%eax),%eax
  802e5d:	39 c2                	cmp    %eax,%edx
  802e5f:	0f 86 b5 00 00 00    	jbe    802f1a <insert_sorted_with_merge_freeList+0x1ff>
  802e65:	8b 45 08             	mov    0x8(%ebp),%eax
  802e68:	8b 50 08             	mov    0x8(%eax),%edx
  802e6b:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802e70:	8b 48 0c             	mov    0xc(%eax),%ecx
  802e73:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802e78:	8b 40 08             	mov    0x8(%eax),%eax
  802e7b:	01 c8                	add    %ecx,%eax
  802e7d:	39 c2                	cmp    %eax,%edx
  802e7f:	0f 85 95 00 00 00    	jne    802f1a <insert_sorted_with_merge_freeList+0x1ff>

	{
		FreeMemBlocksList.lh_last->size+=blockToInsert->size;
  802e85:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802e8a:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802e90:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802e93:	8b 55 08             	mov    0x8(%ebp),%edx
  802e96:	8b 52 0c             	mov    0xc(%edx),%edx
  802e99:	01 ca                	add    %ecx,%edx
  802e9b:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802ea8:	8b 45 08             	mov    0x8(%ebp),%eax
  802eab:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802eb2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802eb6:	75 17                	jne    802ecf <insert_sorted_with_merge_freeList+0x1b4>
  802eb8:	83 ec 04             	sub    $0x4,%esp
  802ebb:	68 d0 3f 80 00       	push   $0x803fd0
  802ec0:	68 54 01 00 00       	push   $0x154
  802ec5:	68 f3 3f 80 00       	push   $0x803ff3
  802eca:	e8 8a d8 ff ff       	call   800759 <_panic>
  802ecf:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802ed5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed8:	89 10                	mov    %edx,(%eax)
  802eda:	8b 45 08             	mov    0x8(%ebp),%eax
  802edd:	8b 00                	mov    (%eax),%eax
  802edf:	85 c0                	test   %eax,%eax
  802ee1:	74 0d                	je     802ef0 <insert_sorted_with_merge_freeList+0x1d5>
  802ee3:	a1 48 51 80 00       	mov    0x805148,%eax
  802ee8:	8b 55 08             	mov    0x8(%ebp),%edx
  802eeb:	89 50 04             	mov    %edx,0x4(%eax)
  802eee:	eb 08                	jmp    802ef8 <insert_sorted_with_merge_freeList+0x1dd>
  802ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ef8:	8b 45 08             	mov    0x8(%ebp),%eax
  802efb:	a3 48 51 80 00       	mov    %eax,0x805148
  802f00:	8b 45 08             	mov    0x8(%ebp),%eax
  802f03:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f0a:	a1 54 51 80 00       	mov    0x805154,%eax
  802f0f:	40                   	inc    %eax
  802f10:	a3 54 51 80 00       	mov    %eax,0x805154
  802f15:	e9 0e 06 00 00       	jmp    803528 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva==(blockToInsert->sva+blockToInsert->size))
  802f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1d:	8b 50 08             	mov    0x8(%eax),%edx
  802f20:	a1 38 51 80 00       	mov    0x805138,%eax
  802f25:	8b 40 08             	mov    0x8(%eax),%eax
  802f28:	39 c2                	cmp    %eax,%edx
  802f2a:	0f 83 c1 00 00 00    	jae    802ff1 <insert_sorted_with_merge_freeList+0x2d6>
  802f30:	a1 38 51 80 00       	mov    0x805138,%eax
  802f35:	8b 50 08             	mov    0x8(%eax),%edx
  802f38:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3b:	8b 48 08             	mov    0x8(%eax),%ecx
  802f3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f41:	8b 40 0c             	mov    0xc(%eax),%eax
  802f44:	01 c8                	add    %ecx,%eax
  802f46:	39 c2                	cmp    %eax,%edx
  802f48:	0f 85 a3 00 00 00    	jne    802ff1 <insert_sorted_with_merge_freeList+0x2d6>
	{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  802f4e:	a1 38 51 80 00       	mov    0x805138,%eax
  802f53:	8b 55 08             	mov    0x8(%ebp),%edx
  802f56:	8b 52 08             	mov    0x8(%edx),%edx
  802f59:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size+=blockToInsert->size;
  802f5c:	a1 38 51 80 00       	mov    0x805138,%eax
  802f61:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802f67:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802f6a:	8b 55 08             	mov    0x8(%ebp),%edx
  802f6d:	8b 52 0c             	mov    0xc(%edx),%edx
  802f70:	01 ca                	add    %ecx,%edx
  802f72:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->sva=0;
  802f75:	8b 45 08             	mov    0x8(%ebp),%eax
  802f78:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		blockToInsert->size=0;
  802f7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f82:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)

		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802f89:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f8d:	75 17                	jne    802fa6 <insert_sorted_with_merge_freeList+0x28b>
  802f8f:	83 ec 04             	sub    $0x4,%esp
  802f92:	68 d0 3f 80 00       	push   $0x803fd0
  802f97:	68 5d 01 00 00       	push   $0x15d
  802f9c:	68 f3 3f 80 00       	push   $0x803ff3
  802fa1:	e8 b3 d7 ff ff       	call   800759 <_panic>
  802fa6:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802fac:	8b 45 08             	mov    0x8(%ebp),%eax
  802faf:	89 10                	mov    %edx,(%eax)
  802fb1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb4:	8b 00                	mov    (%eax),%eax
  802fb6:	85 c0                	test   %eax,%eax
  802fb8:	74 0d                	je     802fc7 <insert_sorted_with_merge_freeList+0x2ac>
  802fba:	a1 48 51 80 00       	mov    0x805148,%eax
  802fbf:	8b 55 08             	mov    0x8(%ebp),%edx
  802fc2:	89 50 04             	mov    %edx,0x4(%eax)
  802fc5:	eb 08                	jmp    802fcf <insert_sorted_with_merge_freeList+0x2b4>
  802fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  802fca:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd2:	a3 48 51 80 00       	mov    %eax,0x805148
  802fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  802fda:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fe1:	a1 54 51 80 00       	mov    0x805154,%eax
  802fe6:	40                   	inc    %eax
  802fe7:	a3 54 51 80 00       	mov    %eax,0x805154
  802fec:	e9 37 05 00 00       	jmp    803528 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva!=(blockToInsert->sva+blockToInsert->size))
  802ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff4:	8b 50 08             	mov    0x8(%eax),%edx
  802ff7:	a1 38 51 80 00       	mov    0x805138,%eax
  802ffc:	8b 40 08             	mov    0x8(%eax),%eax
  802fff:	39 c2                	cmp    %eax,%edx
  803001:	0f 83 82 00 00 00    	jae    803089 <insert_sorted_with_merge_freeList+0x36e>
  803007:	a1 38 51 80 00       	mov    0x805138,%eax
  80300c:	8b 50 08             	mov    0x8(%eax),%edx
  80300f:	8b 45 08             	mov    0x8(%ebp),%eax
  803012:	8b 48 08             	mov    0x8(%eax),%ecx
  803015:	8b 45 08             	mov    0x8(%ebp),%eax
  803018:	8b 40 0c             	mov    0xc(%eax),%eax
  80301b:	01 c8                	add    %ecx,%eax
  80301d:	39 c2                	cmp    %eax,%edx
  80301f:	74 68                	je     803089 <insert_sorted_with_merge_freeList+0x36e>

	{
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  803021:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803025:	75 17                	jne    80303e <insert_sorted_with_merge_freeList+0x323>
  803027:	83 ec 04             	sub    $0x4,%esp
  80302a:	68 d0 3f 80 00       	push   $0x803fd0
  80302f:	68 62 01 00 00       	push   $0x162
  803034:	68 f3 3f 80 00       	push   $0x803ff3
  803039:	e8 1b d7 ff ff       	call   800759 <_panic>
  80303e:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803044:	8b 45 08             	mov    0x8(%ebp),%eax
  803047:	89 10                	mov    %edx,(%eax)
  803049:	8b 45 08             	mov    0x8(%ebp),%eax
  80304c:	8b 00                	mov    (%eax),%eax
  80304e:	85 c0                	test   %eax,%eax
  803050:	74 0d                	je     80305f <insert_sorted_with_merge_freeList+0x344>
  803052:	a1 38 51 80 00       	mov    0x805138,%eax
  803057:	8b 55 08             	mov    0x8(%ebp),%edx
  80305a:	89 50 04             	mov    %edx,0x4(%eax)
  80305d:	eb 08                	jmp    803067 <insert_sorted_with_merge_freeList+0x34c>
  80305f:	8b 45 08             	mov    0x8(%ebp),%eax
  803062:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803067:	8b 45 08             	mov    0x8(%ebp),%eax
  80306a:	a3 38 51 80 00       	mov    %eax,0x805138
  80306f:	8b 45 08             	mov    0x8(%ebp),%eax
  803072:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803079:	a1 44 51 80 00       	mov    0x805144,%eax
  80307e:	40                   	inc    %eax
  80307f:	a3 44 51 80 00       	mov    %eax,0x805144
  803084:	e9 9f 04 00 00       	jmp    803528 <insert_sorted_with_merge_freeList+0x80d>
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
  803089:	a1 38 51 80 00       	mov    0x805138,%eax
  80308e:	8b 00                	mov    (%eax),%eax
  803090:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  803093:	e9 84 04 00 00       	jmp    80351c <insert_sorted_with_merge_freeList+0x801>
		{
			if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  803098:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309b:	8b 50 08             	mov    0x8(%eax),%edx
  80309e:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a1:	8b 40 08             	mov    0x8(%eax),%eax
  8030a4:	39 c2                	cmp    %eax,%edx
  8030a6:	0f 86 a9 00 00 00    	jbe    803155 <insert_sorted_with_merge_freeList+0x43a>
  8030ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030af:	8b 50 08             	mov    0x8(%eax),%edx
  8030b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b5:	8b 48 08             	mov    0x8(%eax),%ecx
  8030b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030bb:	8b 40 0c             	mov    0xc(%eax),%eax
  8030be:	01 c8                	add    %ecx,%eax
  8030c0:	39 c2                	cmp    %eax,%edx
  8030c2:	0f 84 8d 00 00 00    	je     803155 <insert_sorted_with_merge_freeList+0x43a>
  8030c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030cb:	8b 50 08             	mov    0x8(%eax),%edx
  8030ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d1:	8b 40 04             	mov    0x4(%eax),%eax
  8030d4:	8b 48 08             	mov    0x8(%eax),%ecx
  8030d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030da:	8b 40 04             	mov    0x4(%eax),%eax
  8030dd:	8b 40 0c             	mov    0xc(%eax),%eax
  8030e0:	01 c8                	add    %ecx,%eax
  8030e2:	39 c2                	cmp    %eax,%edx
  8030e4:	74 6f                	je     803155 <insert_sorted_with_merge_freeList+0x43a>
			{
				LIST_INSERT_BEFORE(&FreeMemBlocksList,tmp,blockToInsert);
  8030e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030ea:	74 06                	je     8030f2 <insert_sorted_with_merge_freeList+0x3d7>
  8030ec:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030f0:	75 17                	jne    803109 <insert_sorted_with_merge_freeList+0x3ee>
  8030f2:	83 ec 04             	sub    $0x4,%esp
  8030f5:	68 30 40 80 00       	push   $0x804030
  8030fa:	68 6b 01 00 00       	push   $0x16b
  8030ff:	68 f3 3f 80 00       	push   $0x803ff3
  803104:	e8 50 d6 ff ff       	call   800759 <_panic>
  803109:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80310c:	8b 50 04             	mov    0x4(%eax),%edx
  80310f:	8b 45 08             	mov    0x8(%ebp),%eax
  803112:	89 50 04             	mov    %edx,0x4(%eax)
  803115:	8b 45 08             	mov    0x8(%ebp),%eax
  803118:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80311b:	89 10                	mov    %edx,(%eax)
  80311d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803120:	8b 40 04             	mov    0x4(%eax),%eax
  803123:	85 c0                	test   %eax,%eax
  803125:	74 0d                	je     803134 <insert_sorted_with_merge_freeList+0x419>
  803127:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80312a:	8b 40 04             	mov    0x4(%eax),%eax
  80312d:	8b 55 08             	mov    0x8(%ebp),%edx
  803130:	89 10                	mov    %edx,(%eax)
  803132:	eb 08                	jmp    80313c <insert_sorted_with_merge_freeList+0x421>
  803134:	8b 45 08             	mov    0x8(%ebp),%eax
  803137:	a3 38 51 80 00       	mov    %eax,0x805138
  80313c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80313f:	8b 55 08             	mov    0x8(%ebp),%edx
  803142:	89 50 04             	mov    %edx,0x4(%eax)
  803145:	a1 44 51 80 00       	mov    0x805144,%eax
  80314a:	40                   	inc    %eax
  80314b:	a3 44 51 80 00       	mov    %eax,0x805144
				break;
  803150:	e9 d3 03 00 00       	jmp    803528 <insert_sorted_with_merge_freeList+0x80d>
			}// no merge
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  803155:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803158:	8b 50 08             	mov    0x8(%eax),%edx
  80315b:	8b 45 08             	mov    0x8(%ebp),%eax
  80315e:	8b 40 08             	mov    0x8(%eax),%eax
  803161:	39 c2                	cmp    %eax,%edx
  803163:	0f 86 da 00 00 00    	jbe    803243 <insert_sorted_with_merge_freeList+0x528>
  803169:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80316c:	8b 50 08             	mov    0x8(%eax),%edx
  80316f:	8b 45 08             	mov    0x8(%ebp),%eax
  803172:	8b 48 08             	mov    0x8(%eax),%ecx
  803175:	8b 45 08             	mov    0x8(%ebp),%eax
  803178:	8b 40 0c             	mov    0xc(%eax),%eax
  80317b:	01 c8                	add    %ecx,%eax
  80317d:	39 c2                	cmp    %eax,%edx
  80317f:	0f 85 be 00 00 00    	jne    803243 <insert_sorted_with_merge_freeList+0x528>
  803185:	8b 45 08             	mov    0x8(%ebp),%eax
  803188:	8b 50 08             	mov    0x8(%eax),%edx
  80318b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80318e:	8b 40 04             	mov    0x4(%eax),%eax
  803191:	8b 48 08             	mov    0x8(%eax),%ecx
  803194:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803197:	8b 40 04             	mov    0x4(%eax),%eax
  80319a:	8b 40 0c             	mov    0xc(%eax),%eax
  80319d:	01 c8                	add    %ecx,%eax
  80319f:	39 c2                	cmp    %eax,%edx
  8031a1:	0f 84 9c 00 00 00    	je     803243 <insert_sorted_with_merge_freeList+0x528>
			{
tmp->sva=blockToInsert->sva;
  8031a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031aa:	8b 50 08             	mov    0x8(%eax),%edx
  8031ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b0:	89 50 08             	mov    %edx,0x8(%eax)
tmp->size+=blockToInsert->size;
  8031b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b6:	8b 50 0c             	mov    0xc(%eax),%edx
  8031b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8031bf:	01 c2                	add    %eax,%edx
  8031c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c4:	89 50 0c             	mov    %edx,0xc(%eax)
blockToInsert->sva=0;
  8031c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ca:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
blockToInsert->size=0;
  8031d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8031db:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031df:	75 17                	jne    8031f8 <insert_sorted_with_merge_freeList+0x4dd>
  8031e1:	83 ec 04             	sub    $0x4,%esp
  8031e4:	68 d0 3f 80 00       	push   $0x803fd0
  8031e9:	68 74 01 00 00       	push   $0x174
  8031ee:	68 f3 3f 80 00       	push   $0x803ff3
  8031f3:	e8 61 d5 ff ff       	call   800759 <_panic>
  8031f8:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803201:	89 10                	mov    %edx,(%eax)
  803203:	8b 45 08             	mov    0x8(%ebp),%eax
  803206:	8b 00                	mov    (%eax),%eax
  803208:	85 c0                	test   %eax,%eax
  80320a:	74 0d                	je     803219 <insert_sorted_with_merge_freeList+0x4fe>
  80320c:	a1 48 51 80 00       	mov    0x805148,%eax
  803211:	8b 55 08             	mov    0x8(%ebp),%edx
  803214:	89 50 04             	mov    %edx,0x4(%eax)
  803217:	eb 08                	jmp    803221 <insert_sorted_with_merge_freeList+0x506>
  803219:	8b 45 08             	mov    0x8(%ebp),%eax
  80321c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803221:	8b 45 08             	mov    0x8(%ebp),%eax
  803224:	a3 48 51 80 00       	mov    %eax,0x805148
  803229:	8b 45 08             	mov    0x8(%ebp),%eax
  80322c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803233:	a1 54 51 80 00       	mov    0x805154,%eax
  803238:	40                   	inc    %eax
  803239:	a3 54 51 80 00       	mov    %eax,0x805154
break;
  80323e:	e9 e5 02 00 00       	jmp    803528 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with the next
			else if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  803243:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803246:	8b 50 08             	mov    0x8(%eax),%edx
  803249:	8b 45 08             	mov    0x8(%ebp),%eax
  80324c:	8b 40 08             	mov    0x8(%eax),%eax
  80324f:	39 c2                	cmp    %eax,%edx
  803251:	0f 86 d7 00 00 00    	jbe    80332e <insert_sorted_with_merge_freeList+0x613>
  803257:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80325a:	8b 50 08             	mov    0x8(%eax),%edx
  80325d:	8b 45 08             	mov    0x8(%ebp),%eax
  803260:	8b 48 08             	mov    0x8(%eax),%ecx
  803263:	8b 45 08             	mov    0x8(%ebp),%eax
  803266:	8b 40 0c             	mov    0xc(%eax),%eax
  803269:	01 c8                	add    %ecx,%eax
  80326b:	39 c2                	cmp    %eax,%edx
  80326d:	0f 84 bb 00 00 00    	je     80332e <insert_sorted_with_merge_freeList+0x613>
  803273:	8b 45 08             	mov    0x8(%ebp),%eax
  803276:	8b 50 08             	mov    0x8(%eax),%edx
  803279:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80327c:	8b 40 04             	mov    0x4(%eax),%eax
  80327f:	8b 48 08             	mov    0x8(%eax),%ecx
  803282:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803285:	8b 40 04             	mov    0x4(%eax),%eax
  803288:	8b 40 0c             	mov    0xc(%eax),%eax
  80328b:	01 c8                	add    %ecx,%eax
  80328d:	39 c2                	cmp    %eax,%edx
  80328f:	0f 85 99 00 00 00    	jne    80332e <insert_sorted_with_merge_freeList+0x613>
			{
				struct MemBlock *ptr=LIST_PREV(tmp);
  803295:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803298:	8b 40 04             	mov    0x4(%eax),%eax
  80329b:	89 45 f0             	mov    %eax,-0x10(%ebp)
				ptr->size+=blockToInsert->size;
  80329e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032a1:	8b 50 0c             	mov    0xc(%eax),%edx
  8032a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a7:	8b 40 0c             	mov    0xc(%eax),%eax
  8032aa:	01 c2                	add    %eax,%edx
  8032ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032af:	89 50 0c             	mov    %edx,0xc(%eax)
				blockToInsert->sva=0;
  8032b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size =0;
  8032bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8032bf:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8032c6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032ca:	75 17                	jne    8032e3 <insert_sorted_with_merge_freeList+0x5c8>
  8032cc:	83 ec 04             	sub    $0x4,%esp
  8032cf:	68 d0 3f 80 00       	push   $0x803fd0
  8032d4:	68 7d 01 00 00       	push   $0x17d
  8032d9:	68 f3 3f 80 00       	push   $0x803ff3
  8032de:	e8 76 d4 ff ff       	call   800759 <_panic>
  8032e3:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ec:	89 10                	mov    %edx,(%eax)
  8032ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f1:	8b 00                	mov    (%eax),%eax
  8032f3:	85 c0                	test   %eax,%eax
  8032f5:	74 0d                	je     803304 <insert_sorted_with_merge_freeList+0x5e9>
  8032f7:	a1 48 51 80 00       	mov    0x805148,%eax
  8032fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8032ff:	89 50 04             	mov    %edx,0x4(%eax)
  803302:	eb 08                	jmp    80330c <insert_sorted_with_merge_freeList+0x5f1>
  803304:	8b 45 08             	mov    0x8(%ebp),%eax
  803307:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80330c:	8b 45 08             	mov    0x8(%ebp),%eax
  80330f:	a3 48 51 80 00       	mov    %eax,0x805148
  803314:	8b 45 08             	mov    0x8(%ebp),%eax
  803317:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80331e:	a1 54 51 80 00       	mov    0x805154,%eax
  803323:	40                   	inc    %eax
  803324:	a3 54 51 80 00       	mov    %eax,0x805154
break;
  803329:	e9 fa 01 00 00       	jmp    803528 <insert_sorted_with_merge_freeList+0x80d>
			}// merge with previous
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  80332e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803331:	8b 50 08             	mov    0x8(%eax),%edx
  803334:	8b 45 08             	mov    0x8(%ebp),%eax
  803337:	8b 40 08             	mov    0x8(%eax),%eax
  80333a:	39 c2                	cmp    %eax,%edx
  80333c:	0f 86 d2 01 00 00    	jbe    803514 <insert_sorted_with_merge_freeList+0x7f9>
  803342:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803345:	8b 50 08             	mov    0x8(%eax),%edx
  803348:	8b 45 08             	mov    0x8(%ebp),%eax
  80334b:	8b 48 08             	mov    0x8(%eax),%ecx
  80334e:	8b 45 08             	mov    0x8(%ebp),%eax
  803351:	8b 40 0c             	mov    0xc(%eax),%eax
  803354:	01 c8                	add    %ecx,%eax
  803356:	39 c2                	cmp    %eax,%edx
  803358:	0f 85 b6 01 00 00    	jne    803514 <insert_sorted_with_merge_freeList+0x7f9>
  80335e:	8b 45 08             	mov    0x8(%ebp),%eax
  803361:	8b 50 08             	mov    0x8(%eax),%edx
  803364:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803367:	8b 40 04             	mov    0x4(%eax),%eax
  80336a:	8b 48 08             	mov    0x8(%eax),%ecx
  80336d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803370:	8b 40 04             	mov    0x4(%eax),%eax
  803373:	8b 40 0c             	mov    0xc(%eax),%eax
  803376:	01 c8                	add    %ecx,%eax
  803378:	39 c2                	cmp    %eax,%edx
  80337a:	0f 85 94 01 00 00    	jne    803514 <insert_sorted_with_merge_freeList+0x7f9>
			{

				LIST_PREV(tmp)->size+=blockToInsert->size+tmp->size;
  803380:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803383:	8b 40 04             	mov    0x4(%eax),%eax
  803386:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803389:	8b 52 04             	mov    0x4(%edx),%edx
  80338c:	8b 4a 0c             	mov    0xc(%edx),%ecx
  80338f:	8b 55 08             	mov    0x8(%ebp),%edx
  803392:	8b 5a 0c             	mov    0xc(%edx),%ebx
  803395:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803398:	8b 52 0c             	mov    0xc(%edx),%edx
  80339b:	01 da                	add    %ebx,%edx
  80339d:	01 ca                	add    %ecx,%edx
  80339f:	89 50 0c             	mov    %edx,0xc(%eax)
				tmp->size=0;
  8033a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				tmp->sva=0;
  8033ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033af:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  8033b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033ba:	75 17                	jne    8033d3 <insert_sorted_with_merge_freeList+0x6b8>
  8033bc:	83 ec 04             	sub    $0x4,%esp
  8033bf:	68 65 40 80 00       	push   $0x804065
  8033c4:	68 86 01 00 00       	push   $0x186
  8033c9:	68 f3 3f 80 00       	push   $0x803ff3
  8033ce:	e8 86 d3 ff ff       	call   800759 <_panic>
  8033d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d6:	8b 00                	mov    (%eax),%eax
  8033d8:	85 c0                	test   %eax,%eax
  8033da:	74 10                	je     8033ec <insert_sorted_with_merge_freeList+0x6d1>
  8033dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033df:	8b 00                	mov    (%eax),%eax
  8033e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033e4:	8b 52 04             	mov    0x4(%edx),%edx
  8033e7:	89 50 04             	mov    %edx,0x4(%eax)
  8033ea:	eb 0b                	jmp    8033f7 <insert_sorted_with_merge_freeList+0x6dc>
  8033ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ef:	8b 40 04             	mov    0x4(%eax),%eax
  8033f2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033fa:	8b 40 04             	mov    0x4(%eax),%eax
  8033fd:	85 c0                	test   %eax,%eax
  8033ff:	74 0f                	je     803410 <insert_sorted_with_merge_freeList+0x6f5>
  803401:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803404:	8b 40 04             	mov    0x4(%eax),%eax
  803407:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80340a:	8b 12                	mov    (%edx),%edx
  80340c:	89 10                	mov    %edx,(%eax)
  80340e:	eb 0a                	jmp    80341a <insert_sorted_with_merge_freeList+0x6ff>
  803410:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803413:	8b 00                	mov    (%eax),%eax
  803415:	a3 38 51 80 00       	mov    %eax,0x805138
  80341a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80341d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803423:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803426:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80342d:	a1 44 51 80 00       	mov    0x805144,%eax
  803432:	48                   	dec    %eax
  803433:	a3 44 51 80 00       	mov    %eax,0x805144
				LIST_INSERT_HEAD(&AvailableMemBlocksList,tmp);
  803438:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80343c:	75 17                	jne    803455 <insert_sorted_with_merge_freeList+0x73a>
  80343e:	83 ec 04             	sub    $0x4,%esp
  803441:	68 d0 3f 80 00       	push   $0x803fd0
  803446:	68 87 01 00 00       	push   $0x187
  80344b:	68 f3 3f 80 00       	push   $0x803ff3
  803450:	e8 04 d3 ff ff       	call   800759 <_panic>
  803455:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80345b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80345e:	89 10                	mov    %edx,(%eax)
  803460:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803463:	8b 00                	mov    (%eax),%eax
  803465:	85 c0                	test   %eax,%eax
  803467:	74 0d                	je     803476 <insert_sorted_with_merge_freeList+0x75b>
  803469:	a1 48 51 80 00       	mov    0x805148,%eax
  80346e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803471:	89 50 04             	mov    %edx,0x4(%eax)
  803474:	eb 08                	jmp    80347e <insert_sorted_with_merge_freeList+0x763>
  803476:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803479:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80347e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803481:	a3 48 51 80 00       	mov    %eax,0x805148
  803486:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803489:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803490:	a1 54 51 80 00       	mov    0x805154,%eax
  803495:	40                   	inc    %eax
  803496:	a3 54 51 80 00       	mov    %eax,0x805154
				blockToInsert->sva=0;
  80349b:	8b 45 08             	mov    0x8(%ebp),%eax
  80349e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size=0;
  8034a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8034af:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034b3:	75 17                	jne    8034cc <insert_sorted_with_merge_freeList+0x7b1>
  8034b5:	83 ec 04             	sub    $0x4,%esp
  8034b8:	68 d0 3f 80 00       	push   $0x803fd0
  8034bd:	68 8a 01 00 00       	push   $0x18a
  8034c2:	68 f3 3f 80 00       	push   $0x803ff3
  8034c7:	e8 8d d2 ff ff       	call   800759 <_panic>
  8034cc:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8034d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d5:	89 10                	mov    %edx,(%eax)
  8034d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8034da:	8b 00                	mov    (%eax),%eax
  8034dc:	85 c0                	test   %eax,%eax
  8034de:	74 0d                	je     8034ed <insert_sorted_with_merge_freeList+0x7d2>
  8034e0:	a1 48 51 80 00       	mov    0x805148,%eax
  8034e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8034e8:	89 50 04             	mov    %edx,0x4(%eax)
  8034eb:	eb 08                	jmp    8034f5 <insert_sorted_with_merge_freeList+0x7da>
  8034ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f8:	a3 48 51 80 00       	mov    %eax,0x805148
  8034fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803500:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803507:	a1 54 51 80 00       	mov    0x805154,%eax
  80350c:	40                   	inc    %eax
  80350d:	a3 54 51 80 00       	mov    %eax,0x805154
				break;
  803512:	eb 14                	jmp    803528 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with next and previous
			tmp=tmp->prev_next_info.le_next;
  803514:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803517:	8b 00                	mov    (%eax),%eax
  803519:	89 45 f4             	mov    %eax,-0xc(%ebp)
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
		while(tmp!=NULL)
  80351c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803520:	0f 85 72 fb ff ff    	jne    803098 <insert_sorted_with_merge_freeList+0x37d>
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  803526:	eb 00                	jmp    803528 <insert_sorted_with_merge_freeList+0x80d>
  803528:	90                   	nop
  803529:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80352c:	c9                   	leave  
  80352d:	c3                   	ret    
  80352e:	66 90                	xchg   %ax,%ax

00803530 <__udivdi3>:
  803530:	55                   	push   %ebp
  803531:	57                   	push   %edi
  803532:	56                   	push   %esi
  803533:	53                   	push   %ebx
  803534:	83 ec 1c             	sub    $0x1c,%esp
  803537:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80353b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80353f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803543:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803547:	89 ca                	mov    %ecx,%edx
  803549:	89 f8                	mov    %edi,%eax
  80354b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80354f:	85 f6                	test   %esi,%esi
  803551:	75 2d                	jne    803580 <__udivdi3+0x50>
  803553:	39 cf                	cmp    %ecx,%edi
  803555:	77 65                	ja     8035bc <__udivdi3+0x8c>
  803557:	89 fd                	mov    %edi,%ebp
  803559:	85 ff                	test   %edi,%edi
  80355b:	75 0b                	jne    803568 <__udivdi3+0x38>
  80355d:	b8 01 00 00 00       	mov    $0x1,%eax
  803562:	31 d2                	xor    %edx,%edx
  803564:	f7 f7                	div    %edi
  803566:	89 c5                	mov    %eax,%ebp
  803568:	31 d2                	xor    %edx,%edx
  80356a:	89 c8                	mov    %ecx,%eax
  80356c:	f7 f5                	div    %ebp
  80356e:	89 c1                	mov    %eax,%ecx
  803570:	89 d8                	mov    %ebx,%eax
  803572:	f7 f5                	div    %ebp
  803574:	89 cf                	mov    %ecx,%edi
  803576:	89 fa                	mov    %edi,%edx
  803578:	83 c4 1c             	add    $0x1c,%esp
  80357b:	5b                   	pop    %ebx
  80357c:	5e                   	pop    %esi
  80357d:	5f                   	pop    %edi
  80357e:	5d                   	pop    %ebp
  80357f:	c3                   	ret    
  803580:	39 ce                	cmp    %ecx,%esi
  803582:	77 28                	ja     8035ac <__udivdi3+0x7c>
  803584:	0f bd fe             	bsr    %esi,%edi
  803587:	83 f7 1f             	xor    $0x1f,%edi
  80358a:	75 40                	jne    8035cc <__udivdi3+0x9c>
  80358c:	39 ce                	cmp    %ecx,%esi
  80358e:	72 0a                	jb     80359a <__udivdi3+0x6a>
  803590:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803594:	0f 87 9e 00 00 00    	ja     803638 <__udivdi3+0x108>
  80359a:	b8 01 00 00 00       	mov    $0x1,%eax
  80359f:	89 fa                	mov    %edi,%edx
  8035a1:	83 c4 1c             	add    $0x1c,%esp
  8035a4:	5b                   	pop    %ebx
  8035a5:	5e                   	pop    %esi
  8035a6:	5f                   	pop    %edi
  8035a7:	5d                   	pop    %ebp
  8035a8:	c3                   	ret    
  8035a9:	8d 76 00             	lea    0x0(%esi),%esi
  8035ac:	31 ff                	xor    %edi,%edi
  8035ae:	31 c0                	xor    %eax,%eax
  8035b0:	89 fa                	mov    %edi,%edx
  8035b2:	83 c4 1c             	add    $0x1c,%esp
  8035b5:	5b                   	pop    %ebx
  8035b6:	5e                   	pop    %esi
  8035b7:	5f                   	pop    %edi
  8035b8:	5d                   	pop    %ebp
  8035b9:	c3                   	ret    
  8035ba:	66 90                	xchg   %ax,%ax
  8035bc:	89 d8                	mov    %ebx,%eax
  8035be:	f7 f7                	div    %edi
  8035c0:	31 ff                	xor    %edi,%edi
  8035c2:	89 fa                	mov    %edi,%edx
  8035c4:	83 c4 1c             	add    $0x1c,%esp
  8035c7:	5b                   	pop    %ebx
  8035c8:	5e                   	pop    %esi
  8035c9:	5f                   	pop    %edi
  8035ca:	5d                   	pop    %ebp
  8035cb:	c3                   	ret    
  8035cc:	bd 20 00 00 00       	mov    $0x20,%ebp
  8035d1:	89 eb                	mov    %ebp,%ebx
  8035d3:	29 fb                	sub    %edi,%ebx
  8035d5:	89 f9                	mov    %edi,%ecx
  8035d7:	d3 e6                	shl    %cl,%esi
  8035d9:	89 c5                	mov    %eax,%ebp
  8035db:	88 d9                	mov    %bl,%cl
  8035dd:	d3 ed                	shr    %cl,%ebp
  8035df:	89 e9                	mov    %ebp,%ecx
  8035e1:	09 f1                	or     %esi,%ecx
  8035e3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8035e7:	89 f9                	mov    %edi,%ecx
  8035e9:	d3 e0                	shl    %cl,%eax
  8035eb:	89 c5                	mov    %eax,%ebp
  8035ed:	89 d6                	mov    %edx,%esi
  8035ef:	88 d9                	mov    %bl,%cl
  8035f1:	d3 ee                	shr    %cl,%esi
  8035f3:	89 f9                	mov    %edi,%ecx
  8035f5:	d3 e2                	shl    %cl,%edx
  8035f7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035fb:	88 d9                	mov    %bl,%cl
  8035fd:	d3 e8                	shr    %cl,%eax
  8035ff:	09 c2                	or     %eax,%edx
  803601:	89 d0                	mov    %edx,%eax
  803603:	89 f2                	mov    %esi,%edx
  803605:	f7 74 24 0c          	divl   0xc(%esp)
  803609:	89 d6                	mov    %edx,%esi
  80360b:	89 c3                	mov    %eax,%ebx
  80360d:	f7 e5                	mul    %ebp
  80360f:	39 d6                	cmp    %edx,%esi
  803611:	72 19                	jb     80362c <__udivdi3+0xfc>
  803613:	74 0b                	je     803620 <__udivdi3+0xf0>
  803615:	89 d8                	mov    %ebx,%eax
  803617:	31 ff                	xor    %edi,%edi
  803619:	e9 58 ff ff ff       	jmp    803576 <__udivdi3+0x46>
  80361e:	66 90                	xchg   %ax,%ax
  803620:	8b 54 24 08          	mov    0x8(%esp),%edx
  803624:	89 f9                	mov    %edi,%ecx
  803626:	d3 e2                	shl    %cl,%edx
  803628:	39 c2                	cmp    %eax,%edx
  80362a:	73 e9                	jae    803615 <__udivdi3+0xe5>
  80362c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80362f:	31 ff                	xor    %edi,%edi
  803631:	e9 40 ff ff ff       	jmp    803576 <__udivdi3+0x46>
  803636:	66 90                	xchg   %ax,%ax
  803638:	31 c0                	xor    %eax,%eax
  80363a:	e9 37 ff ff ff       	jmp    803576 <__udivdi3+0x46>
  80363f:	90                   	nop

00803640 <__umoddi3>:
  803640:	55                   	push   %ebp
  803641:	57                   	push   %edi
  803642:	56                   	push   %esi
  803643:	53                   	push   %ebx
  803644:	83 ec 1c             	sub    $0x1c,%esp
  803647:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80364b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80364f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803653:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803657:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80365b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80365f:	89 f3                	mov    %esi,%ebx
  803661:	89 fa                	mov    %edi,%edx
  803663:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803667:	89 34 24             	mov    %esi,(%esp)
  80366a:	85 c0                	test   %eax,%eax
  80366c:	75 1a                	jne    803688 <__umoddi3+0x48>
  80366e:	39 f7                	cmp    %esi,%edi
  803670:	0f 86 a2 00 00 00    	jbe    803718 <__umoddi3+0xd8>
  803676:	89 c8                	mov    %ecx,%eax
  803678:	89 f2                	mov    %esi,%edx
  80367a:	f7 f7                	div    %edi
  80367c:	89 d0                	mov    %edx,%eax
  80367e:	31 d2                	xor    %edx,%edx
  803680:	83 c4 1c             	add    $0x1c,%esp
  803683:	5b                   	pop    %ebx
  803684:	5e                   	pop    %esi
  803685:	5f                   	pop    %edi
  803686:	5d                   	pop    %ebp
  803687:	c3                   	ret    
  803688:	39 f0                	cmp    %esi,%eax
  80368a:	0f 87 ac 00 00 00    	ja     80373c <__umoddi3+0xfc>
  803690:	0f bd e8             	bsr    %eax,%ebp
  803693:	83 f5 1f             	xor    $0x1f,%ebp
  803696:	0f 84 ac 00 00 00    	je     803748 <__umoddi3+0x108>
  80369c:	bf 20 00 00 00       	mov    $0x20,%edi
  8036a1:	29 ef                	sub    %ebp,%edi
  8036a3:	89 fe                	mov    %edi,%esi
  8036a5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8036a9:	89 e9                	mov    %ebp,%ecx
  8036ab:	d3 e0                	shl    %cl,%eax
  8036ad:	89 d7                	mov    %edx,%edi
  8036af:	89 f1                	mov    %esi,%ecx
  8036b1:	d3 ef                	shr    %cl,%edi
  8036b3:	09 c7                	or     %eax,%edi
  8036b5:	89 e9                	mov    %ebp,%ecx
  8036b7:	d3 e2                	shl    %cl,%edx
  8036b9:	89 14 24             	mov    %edx,(%esp)
  8036bc:	89 d8                	mov    %ebx,%eax
  8036be:	d3 e0                	shl    %cl,%eax
  8036c0:	89 c2                	mov    %eax,%edx
  8036c2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8036c6:	d3 e0                	shl    %cl,%eax
  8036c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8036cc:	8b 44 24 08          	mov    0x8(%esp),%eax
  8036d0:	89 f1                	mov    %esi,%ecx
  8036d2:	d3 e8                	shr    %cl,%eax
  8036d4:	09 d0                	or     %edx,%eax
  8036d6:	d3 eb                	shr    %cl,%ebx
  8036d8:	89 da                	mov    %ebx,%edx
  8036da:	f7 f7                	div    %edi
  8036dc:	89 d3                	mov    %edx,%ebx
  8036de:	f7 24 24             	mull   (%esp)
  8036e1:	89 c6                	mov    %eax,%esi
  8036e3:	89 d1                	mov    %edx,%ecx
  8036e5:	39 d3                	cmp    %edx,%ebx
  8036e7:	0f 82 87 00 00 00    	jb     803774 <__umoddi3+0x134>
  8036ed:	0f 84 91 00 00 00    	je     803784 <__umoddi3+0x144>
  8036f3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8036f7:	29 f2                	sub    %esi,%edx
  8036f9:	19 cb                	sbb    %ecx,%ebx
  8036fb:	89 d8                	mov    %ebx,%eax
  8036fd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803701:	d3 e0                	shl    %cl,%eax
  803703:	89 e9                	mov    %ebp,%ecx
  803705:	d3 ea                	shr    %cl,%edx
  803707:	09 d0                	or     %edx,%eax
  803709:	89 e9                	mov    %ebp,%ecx
  80370b:	d3 eb                	shr    %cl,%ebx
  80370d:	89 da                	mov    %ebx,%edx
  80370f:	83 c4 1c             	add    $0x1c,%esp
  803712:	5b                   	pop    %ebx
  803713:	5e                   	pop    %esi
  803714:	5f                   	pop    %edi
  803715:	5d                   	pop    %ebp
  803716:	c3                   	ret    
  803717:	90                   	nop
  803718:	89 fd                	mov    %edi,%ebp
  80371a:	85 ff                	test   %edi,%edi
  80371c:	75 0b                	jne    803729 <__umoddi3+0xe9>
  80371e:	b8 01 00 00 00       	mov    $0x1,%eax
  803723:	31 d2                	xor    %edx,%edx
  803725:	f7 f7                	div    %edi
  803727:	89 c5                	mov    %eax,%ebp
  803729:	89 f0                	mov    %esi,%eax
  80372b:	31 d2                	xor    %edx,%edx
  80372d:	f7 f5                	div    %ebp
  80372f:	89 c8                	mov    %ecx,%eax
  803731:	f7 f5                	div    %ebp
  803733:	89 d0                	mov    %edx,%eax
  803735:	e9 44 ff ff ff       	jmp    80367e <__umoddi3+0x3e>
  80373a:	66 90                	xchg   %ax,%ax
  80373c:	89 c8                	mov    %ecx,%eax
  80373e:	89 f2                	mov    %esi,%edx
  803740:	83 c4 1c             	add    $0x1c,%esp
  803743:	5b                   	pop    %ebx
  803744:	5e                   	pop    %esi
  803745:	5f                   	pop    %edi
  803746:	5d                   	pop    %ebp
  803747:	c3                   	ret    
  803748:	3b 04 24             	cmp    (%esp),%eax
  80374b:	72 06                	jb     803753 <__umoddi3+0x113>
  80374d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803751:	77 0f                	ja     803762 <__umoddi3+0x122>
  803753:	89 f2                	mov    %esi,%edx
  803755:	29 f9                	sub    %edi,%ecx
  803757:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80375b:	89 14 24             	mov    %edx,(%esp)
  80375e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803762:	8b 44 24 04          	mov    0x4(%esp),%eax
  803766:	8b 14 24             	mov    (%esp),%edx
  803769:	83 c4 1c             	add    $0x1c,%esp
  80376c:	5b                   	pop    %ebx
  80376d:	5e                   	pop    %esi
  80376e:	5f                   	pop    %edi
  80376f:	5d                   	pop    %ebp
  803770:	c3                   	ret    
  803771:	8d 76 00             	lea    0x0(%esi),%esi
  803774:	2b 04 24             	sub    (%esp),%eax
  803777:	19 fa                	sbb    %edi,%edx
  803779:	89 d1                	mov    %edx,%ecx
  80377b:	89 c6                	mov    %eax,%esi
  80377d:	e9 71 ff ff ff       	jmp    8036f3 <__umoddi3+0xb3>
  803782:	66 90                	xchg   %ax,%ax
  803784:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803788:	72 ea                	jb     803774 <__umoddi3+0x134>
  80378a:	89 d9                	mov    %ebx,%ecx
  80378c:	e9 62 ff ff ff       	jmp    8036f3 <__umoddi3+0xb3>
