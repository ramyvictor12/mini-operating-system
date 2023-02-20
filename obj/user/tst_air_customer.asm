
obj/user/tst_air_customer:     file format elf32-i386


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
  800031:	e8 dc 03 00 00       	call   800412 <libmain>
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
  80003e:	81 ec 8c 01 00 00    	sub    $0x18c,%esp
	int32 parentenvID = sys_getparentenvid();
  800044:	e8 86 1c 00 00       	call   801ccf <sys_getparentenvid>
  800049:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	char _customers[] = "customers";
  80004c:	8d 45 c2             	lea    -0x3e(%ebp),%eax
  80004f:	bb e9 35 80 00       	mov    $0x8035e9,%ebx
  800054:	ba 0a 00 00 00       	mov    $0xa,%edx
  800059:	89 c7                	mov    %eax,%edi
  80005b:	89 de                	mov    %ebx,%esi
  80005d:	89 d1                	mov    %edx,%ecx
  80005f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custCounter[] = "custCounter";
  800061:	8d 45 b6             	lea    -0x4a(%ebp),%eax
  800064:	bb f3 35 80 00       	mov    $0x8035f3,%ebx
  800069:	ba 03 00 00 00       	mov    $0x3,%edx
  80006e:	89 c7                	mov    %eax,%edi
  800070:	89 de                	mov    %ebx,%esi
  800072:	89 d1                	mov    %edx,%ecx
  800074:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1Counter[] = "flight1Counter";
  800076:	8d 45 a7             	lea    -0x59(%ebp),%eax
  800079:	bb ff 35 80 00       	mov    $0x8035ff,%ebx
  80007e:	ba 0f 00 00 00       	mov    $0xf,%edx
  800083:	89 c7                	mov    %eax,%edi
  800085:	89 de                	mov    %ebx,%esi
  800087:	89 d1                	mov    %edx,%ecx
  800089:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Counter[] = "flight2Counter";
  80008b:	8d 45 98             	lea    -0x68(%ebp),%eax
  80008e:	bb 0e 36 80 00       	mov    $0x80360e,%ebx
  800093:	ba 0f 00 00 00       	mov    $0xf,%edx
  800098:	89 c7                	mov    %eax,%edi
  80009a:	89 de                	mov    %ebx,%esi
  80009c:	89 d1                	mov    %edx,%ecx
  80009e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Counter[] = "flightBooked1Counter";
  8000a0:	8d 45 83             	lea    -0x7d(%ebp),%eax
  8000a3:	bb 1d 36 80 00       	mov    $0x80361d,%ebx
  8000a8:	ba 15 00 00 00       	mov    $0x15,%edx
  8000ad:	89 c7                	mov    %eax,%edi
  8000af:	89 de                	mov    %ebx,%esi
  8000b1:	89 d1                	mov    %edx,%ecx
  8000b3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Counter[] = "flightBooked2Counter";
  8000b5:	8d 85 6e ff ff ff    	lea    -0x92(%ebp),%eax
  8000bb:	bb 32 36 80 00       	mov    $0x803632,%ebx
  8000c0:	ba 15 00 00 00       	mov    $0x15,%edx
  8000c5:	89 c7                	mov    %eax,%edi
  8000c7:	89 de                	mov    %ebx,%esi
  8000c9:	89 d1                	mov    %edx,%ecx
  8000cb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Arr[] = "flightBooked1Arr";
  8000cd:	8d 85 5d ff ff ff    	lea    -0xa3(%ebp),%eax
  8000d3:	bb 47 36 80 00       	mov    $0x803647,%ebx
  8000d8:	ba 11 00 00 00       	mov    $0x11,%edx
  8000dd:	89 c7                	mov    %eax,%edi
  8000df:	89 de                	mov    %ebx,%esi
  8000e1:	89 d1                	mov    %edx,%ecx
  8000e3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Arr[] = "flightBooked2Arr";
  8000e5:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  8000eb:	bb 58 36 80 00       	mov    $0x803658,%ebx
  8000f0:	ba 11 00 00 00       	mov    $0x11,%edx
  8000f5:	89 c7                	mov    %eax,%edi
  8000f7:	89 de                	mov    %ebx,%esi
  8000f9:	89 d1                	mov    %edx,%ecx
  8000fb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _cust_ready_queue[] = "cust_ready_queue";
  8000fd:	8d 85 3b ff ff ff    	lea    -0xc5(%ebp),%eax
  800103:	bb 69 36 80 00       	mov    $0x803669,%ebx
  800108:	ba 11 00 00 00       	mov    $0x11,%edx
  80010d:	89 c7                	mov    %eax,%edi
  80010f:	89 de                	mov    %ebx,%esi
  800111:	89 d1                	mov    %edx,%ecx
  800113:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_in[] = "queue_in";
  800115:	8d 85 32 ff ff ff    	lea    -0xce(%ebp),%eax
  80011b:	bb 7a 36 80 00       	mov    $0x80367a,%ebx
  800120:	ba 09 00 00 00       	mov    $0x9,%edx
  800125:	89 c7                	mov    %eax,%edi
  800127:	89 de                	mov    %ebx,%esi
  800129:	89 d1                	mov    %edx,%ecx
  80012b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_out[] = "queue_out";
  80012d:	8d 85 28 ff ff ff    	lea    -0xd8(%ebp),%eax
  800133:	bb 83 36 80 00       	mov    $0x803683,%ebx
  800138:	ba 0a 00 00 00       	mov    $0xa,%edx
  80013d:	89 c7                	mov    %eax,%edi
  80013f:	89 de                	mov    %ebx,%esi
  800141:	89 d1                	mov    %edx,%ecx
  800143:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _cust_ready[] = "cust_ready";
  800145:	8d 85 1d ff ff ff    	lea    -0xe3(%ebp),%eax
  80014b:	bb 8d 36 80 00       	mov    $0x80368d,%ebx
  800150:	ba 0b 00 00 00       	mov    $0xb,%edx
  800155:	89 c7                	mov    %eax,%edi
  800157:	89 de                	mov    %ebx,%esi
  800159:	89 d1                	mov    %edx,%ecx
  80015b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custQueueCS[] = "custQueueCS";
  80015d:	8d 85 11 ff ff ff    	lea    -0xef(%ebp),%eax
  800163:	bb 98 36 80 00       	mov    $0x803698,%ebx
  800168:	ba 03 00 00 00       	mov    $0x3,%edx
  80016d:	89 c7                	mov    %eax,%edi
  80016f:	89 de                	mov    %ebx,%esi
  800171:	89 d1                	mov    %edx,%ecx
  800173:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1CS[] = "flight1CS";
  800175:	8d 85 07 ff ff ff    	lea    -0xf9(%ebp),%eax
  80017b:	bb a4 36 80 00       	mov    $0x8036a4,%ebx
  800180:	ba 0a 00 00 00       	mov    $0xa,%edx
  800185:	89 c7                	mov    %eax,%edi
  800187:	89 de                	mov    %ebx,%esi
  800189:	89 d1                	mov    %edx,%ecx
  80018b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2CS[] = "flight2CS";
  80018d:	8d 85 fd fe ff ff    	lea    -0x103(%ebp),%eax
  800193:	bb ae 36 80 00       	mov    $0x8036ae,%ebx
  800198:	ba 0a 00 00 00       	mov    $0xa,%edx
  80019d:	89 c7                	mov    %eax,%edi
  80019f:	89 de                	mov    %ebx,%esi
  8001a1:	89 d1                	mov    %edx,%ecx
  8001a3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _clerk[] = "clerk";
  8001a5:	c7 85 f7 fe ff ff 63 	movl   $0x72656c63,-0x109(%ebp)
  8001ac:	6c 65 72 
  8001af:	66 c7 85 fb fe ff ff 	movw   $0x6b,-0x105(%ebp)
  8001b6:	6b 00 
	char _custCounterCS[] = "custCounterCS";
  8001b8:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8001be:	bb b8 36 80 00       	mov    $0x8036b8,%ebx
  8001c3:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001c8:	89 c7                	mov    %eax,%edi
  8001ca:	89 de                	mov    %ebx,%esi
  8001cc:	89 d1                	mov    %edx,%ecx
  8001ce:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custTerminated[] = "custTerminated";
  8001d0:	8d 85 da fe ff ff    	lea    -0x126(%ebp),%eax
  8001d6:	bb c6 36 80 00       	mov    $0x8036c6,%ebx
  8001db:	ba 0f 00 00 00       	mov    $0xf,%edx
  8001e0:	89 c7                	mov    %eax,%edi
  8001e2:	89 de                	mov    %ebx,%esi
  8001e4:	89 d1                	mov    %edx,%ecx
  8001e6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _taircl[] = "taircl";
  8001e8:	8d 85 d3 fe ff ff    	lea    -0x12d(%ebp),%eax
  8001ee:	bb d5 36 80 00       	mov    $0x8036d5,%ebx
  8001f3:	ba 07 00 00 00       	mov    $0x7,%edx
  8001f8:	89 c7                	mov    %eax,%edi
  8001fa:	89 de                	mov    %ebx,%esi
  8001fc:	89 d1                	mov    %edx,%ecx
  8001fe:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _taircu[] = "taircu";
  800200:	8d 85 cc fe ff ff    	lea    -0x134(%ebp),%eax
  800206:	bb dc 36 80 00       	mov    $0x8036dc,%ebx
  80020b:	ba 07 00 00 00       	mov    $0x7,%edx
  800210:	89 c7                	mov    %eax,%edi
  800212:	89 de                	mov    %ebx,%esi
  800214:	89 d1                	mov    %edx,%ecx
  800216:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	// Get the shared variables from the main program ***********************************

	struct Customer * customers = sget(parentenvID, _customers);
  800218:	83 ec 08             	sub    $0x8,%esp
  80021b:	8d 45 c2             	lea    -0x3e(%ebp),%eax
  80021e:	50                   	push   %eax
  80021f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800222:	e8 6f 15 00 00       	call   801796 <sget>
  800227:	83 c4 10             	add    $0x10,%esp
  80022a:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int* custCounter = sget(parentenvID, _custCounter);
  80022d:	83 ec 08             	sub    $0x8,%esp
  800230:	8d 45 b6             	lea    -0x4a(%ebp),%eax
  800233:	50                   	push   %eax
  800234:	ff 75 e4             	pushl  -0x1c(%ebp)
  800237:	e8 5a 15 00 00       	call   801796 <sget>
  80023c:	83 c4 10             	add    $0x10,%esp
  80023f:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int* cust_ready_queue = sget(parentenvID, _cust_ready_queue);
  800242:	83 ec 08             	sub    $0x8,%esp
  800245:	8d 85 3b ff ff ff    	lea    -0xc5(%ebp),%eax
  80024b:	50                   	push   %eax
  80024c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80024f:	e8 42 15 00 00       	call   801796 <sget>
  800254:	83 c4 10             	add    $0x10,%esp
  800257:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* queue_in = sget(parentenvID, _queue_in);
  80025a:	83 ec 08             	sub    $0x8,%esp
  80025d:	8d 85 32 ff ff ff    	lea    -0xce(%ebp),%eax
  800263:	50                   	push   %eax
  800264:	ff 75 e4             	pushl  -0x1c(%ebp)
  800267:	e8 2a 15 00 00       	call   801796 <sget>
  80026c:	83 c4 10             	add    $0x10,%esp
  80026f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	// *********************************************************************************

	int custId, flightType;
	sys_waitSemaphore(parentenvID, _custCounterCS);
  800272:	83 ec 08             	sub    $0x8,%esp
  800275:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80027b:	50                   	push   %eax
  80027c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80027f:	e8 ec 18 00 00       	call   801b70 <sys_waitSemaphore>
  800284:	83 c4 10             	add    $0x10,%esp
	{
		custId = *custCounter;
  800287:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80028a:	8b 00                	mov    (%eax),%eax
  80028c:	89 45 d0             	mov    %eax,-0x30(%ebp)
		//cprintf("custCounter= %d\n", *custCounter);
		*custCounter = *custCounter +1;
  80028f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800292:	8b 00                	mov    (%eax),%eax
  800294:	8d 50 01             	lea    0x1(%eax),%edx
  800297:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80029a:	89 10                	mov    %edx,(%eax)
	}
	sys_signalSemaphore(parentenvID, _custCounterCS);
  80029c:	83 ec 08             	sub    $0x8,%esp
  80029f:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8002a5:	50                   	push   %eax
  8002a6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002a9:	e8 e0 18 00 00       	call   801b8e <sys_signalSemaphore>
  8002ae:	83 c4 10             	add    $0x10,%esp

	//wait on one of the clerks
	sys_waitSemaphore(parentenvID, _clerk);
  8002b1:	83 ec 08             	sub    $0x8,%esp
  8002b4:	8d 85 f7 fe ff ff    	lea    -0x109(%ebp),%eax
  8002ba:	50                   	push   %eax
  8002bb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002be:	e8 ad 18 00 00       	call   801b70 <sys_waitSemaphore>
  8002c3:	83 c4 10             	add    $0x10,%esp

	//enqueue the request
	flightType = customers[custId].flightType;
  8002c6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8002c9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8002d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002d3:	01 d0                	add    %edx,%eax
  8002d5:	8b 00                	mov    (%eax),%eax
  8002d7:	89 45 cc             	mov    %eax,-0x34(%ebp)
	sys_waitSemaphore(parentenvID, _custQueueCS);
  8002da:	83 ec 08             	sub    $0x8,%esp
  8002dd:	8d 85 11 ff ff ff    	lea    -0xef(%ebp),%eax
  8002e3:	50                   	push   %eax
  8002e4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002e7:	e8 84 18 00 00       	call   801b70 <sys_waitSemaphore>
  8002ec:	83 c4 10             	add    $0x10,%esp
	{
		cust_ready_queue[*queue_in] = custId;
  8002ef:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8002f2:	8b 00                	mov    (%eax),%eax
  8002f4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002fb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002fe:	01 c2                	add    %eax,%edx
  800300:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800303:	89 02                	mov    %eax,(%edx)
		*queue_in = *queue_in +1;
  800305:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800308:	8b 00                	mov    (%eax),%eax
  80030a:	8d 50 01             	lea    0x1(%eax),%edx
  80030d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800310:	89 10                	mov    %edx,(%eax)
	}
	sys_signalSemaphore(parentenvID, _custQueueCS);
  800312:	83 ec 08             	sub    $0x8,%esp
  800315:	8d 85 11 ff ff ff    	lea    -0xef(%ebp),%eax
  80031b:	50                   	push   %eax
  80031c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80031f:	e8 6a 18 00 00       	call   801b8e <sys_signalSemaphore>
  800324:	83 c4 10             	add    $0x10,%esp

	//signal ready
	sys_signalSemaphore(parentenvID, _cust_ready);
  800327:	83 ec 08             	sub    $0x8,%esp
  80032a:	8d 85 1d ff ff ff    	lea    -0xe3(%ebp),%eax
  800330:	50                   	push   %eax
  800331:	ff 75 e4             	pushl  -0x1c(%ebp)
  800334:	e8 55 18 00 00       	call   801b8e <sys_signalSemaphore>
  800339:	83 c4 10             	add    $0x10,%esp

	//wait on finished
	char prefix[30]="cust_finished";
  80033c:	8d 85 ae fe ff ff    	lea    -0x152(%ebp),%eax
  800342:	bb e3 36 80 00       	mov    $0x8036e3,%ebx
  800347:	ba 0e 00 00 00       	mov    $0xe,%edx
  80034c:	89 c7                	mov    %eax,%edi
  80034e:	89 de                	mov    %ebx,%esi
  800350:	89 d1                	mov    %edx,%ecx
  800352:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800354:	8d 95 bc fe ff ff    	lea    -0x144(%ebp),%edx
  80035a:	b9 04 00 00 00       	mov    $0x4,%ecx
  80035f:	b8 00 00 00 00       	mov    $0x0,%eax
  800364:	89 d7                	mov    %edx,%edi
  800366:	f3 ab                	rep stos %eax,%es:(%edi)
	char id[5]; char sname[50];
	ltostr(custId, id);
  800368:	83 ec 08             	sub    $0x8,%esp
  80036b:	8d 85 a9 fe ff ff    	lea    -0x157(%ebp),%eax
  800371:	50                   	push   %eax
  800372:	ff 75 d0             	pushl  -0x30(%ebp)
  800375:	e8 d0 0d 00 00       	call   80114a <ltostr>
  80037a:	83 c4 10             	add    $0x10,%esp
	strcconcat(prefix, id, sname);
  80037d:	83 ec 04             	sub    $0x4,%esp
  800380:	8d 85 77 fe ff ff    	lea    -0x189(%ebp),%eax
  800386:	50                   	push   %eax
  800387:	8d 85 a9 fe ff ff    	lea    -0x157(%ebp),%eax
  80038d:	50                   	push   %eax
  80038e:	8d 85 ae fe ff ff    	lea    -0x152(%ebp),%eax
  800394:	50                   	push   %eax
  800395:	e8 a8 0e 00 00       	call   801242 <strcconcat>
  80039a:	83 c4 10             	add    $0x10,%esp
	sys_waitSemaphore(parentenvID, sname);
  80039d:	83 ec 08             	sub    $0x8,%esp
  8003a0:	8d 85 77 fe ff ff    	lea    -0x189(%ebp),%eax
  8003a6:	50                   	push   %eax
  8003a7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003aa:	e8 c1 17 00 00       	call   801b70 <sys_waitSemaphore>
  8003af:	83 c4 10             	add    $0x10,%esp

	//print the customer status
	if(customers[custId].booked == 1)
  8003b2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8003b5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8003bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003bf:	01 d0                	add    %edx,%eax
  8003c1:	8b 40 04             	mov    0x4(%eax),%eax
  8003c4:	83 f8 01             	cmp    $0x1,%eax
  8003c7:	75 18                	jne    8003e1 <_main+0x3a9>
	{
		cprintf("cust %d: finished (BOOKED flight %d) \n", custId, flightType);
  8003c9:	83 ec 04             	sub    $0x4,%esp
  8003cc:	ff 75 cc             	pushl  -0x34(%ebp)
  8003cf:	ff 75 d0             	pushl  -0x30(%ebp)
  8003d2:	68 a0 35 80 00       	push   $0x8035a0
  8003d7:	e8 46 02 00 00       	call   800622 <cprintf>
  8003dc:	83 c4 10             	add    $0x10,%esp
  8003df:	eb 13                	jmp    8003f4 <_main+0x3bc>
	}
	else
	{
		cprintf("cust %d: finished (NOT BOOKED) \n", custId);
  8003e1:	83 ec 08             	sub    $0x8,%esp
  8003e4:	ff 75 d0             	pushl  -0x30(%ebp)
  8003e7:	68 c8 35 80 00       	push   $0x8035c8
  8003ec:	e8 31 02 00 00       	call   800622 <cprintf>
  8003f1:	83 c4 10             	add    $0x10,%esp
	}

	//customer is terminated
	sys_signalSemaphore(parentenvID, _custTerminated);
  8003f4:	83 ec 08             	sub    $0x8,%esp
  8003f7:	8d 85 da fe ff ff    	lea    -0x126(%ebp),%eax
  8003fd:	50                   	push   %eax
  8003fe:	ff 75 e4             	pushl  -0x1c(%ebp)
  800401:	e8 88 17 00 00       	call   801b8e <sys_signalSemaphore>
  800406:	83 c4 10             	add    $0x10,%esp

	return;
  800409:	90                   	nop
}
  80040a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80040d:	5b                   	pop    %ebx
  80040e:	5e                   	pop    %esi
  80040f:	5f                   	pop    %edi
  800410:	5d                   	pop    %ebp
  800411:	c3                   	ret    

00800412 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800412:	55                   	push   %ebp
  800413:	89 e5                	mov    %esp,%ebp
  800415:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800418:	e8 99 18 00 00       	call   801cb6 <sys_getenvindex>
  80041d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800420:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800423:	89 d0                	mov    %edx,%eax
  800425:	c1 e0 03             	shl    $0x3,%eax
  800428:	01 d0                	add    %edx,%eax
  80042a:	01 c0                	add    %eax,%eax
  80042c:	01 d0                	add    %edx,%eax
  80042e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800435:	01 d0                	add    %edx,%eax
  800437:	c1 e0 04             	shl    $0x4,%eax
  80043a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80043f:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800444:	a1 20 40 80 00       	mov    0x804020,%eax
  800449:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80044f:	84 c0                	test   %al,%al
  800451:	74 0f                	je     800462 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800453:	a1 20 40 80 00       	mov    0x804020,%eax
  800458:	05 5c 05 00 00       	add    $0x55c,%eax
  80045d:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800462:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800466:	7e 0a                	jle    800472 <libmain+0x60>
		binaryname = argv[0];
  800468:	8b 45 0c             	mov    0xc(%ebp),%eax
  80046b:	8b 00                	mov    (%eax),%eax
  80046d:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800472:	83 ec 08             	sub    $0x8,%esp
  800475:	ff 75 0c             	pushl  0xc(%ebp)
  800478:	ff 75 08             	pushl  0x8(%ebp)
  80047b:	e8 b8 fb ff ff       	call   800038 <_main>
  800480:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800483:	e8 3b 16 00 00       	call   801ac3 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800488:	83 ec 0c             	sub    $0xc,%esp
  80048b:	68 1c 37 80 00       	push   $0x80371c
  800490:	e8 8d 01 00 00       	call   800622 <cprintf>
  800495:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800498:	a1 20 40 80 00       	mov    0x804020,%eax
  80049d:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8004a3:	a1 20 40 80 00       	mov    0x804020,%eax
  8004a8:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8004ae:	83 ec 04             	sub    $0x4,%esp
  8004b1:	52                   	push   %edx
  8004b2:	50                   	push   %eax
  8004b3:	68 44 37 80 00       	push   $0x803744
  8004b8:	e8 65 01 00 00       	call   800622 <cprintf>
  8004bd:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8004c0:	a1 20 40 80 00       	mov    0x804020,%eax
  8004c5:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8004cb:	a1 20 40 80 00       	mov    0x804020,%eax
  8004d0:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8004d6:	a1 20 40 80 00       	mov    0x804020,%eax
  8004db:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8004e1:	51                   	push   %ecx
  8004e2:	52                   	push   %edx
  8004e3:	50                   	push   %eax
  8004e4:	68 6c 37 80 00       	push   $0x80376c
  8004e9:	e8 34 01 00 00       	call   800622 <cprintf>
  8004ee:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8004f1:	a1 20 40 80 00       	mov    0x804020,%eax
  8004f6:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8004fc:	83 ec 08             	sub    $0x8,%esp
  8004ff:	50                   	push   %eax
  800500:	68 c4 37 80 00       	push   $0x8037c4
  800505:	e8 18 01 00 00       	call   800622 <cprintf>
  80050a:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80050d:	83 ec 0c             	sub    $0xc,%esp
  800510:	68 1c 37 80 00       	push   $0x80371c
  800515:	e8 08 01 00 00       	call   800622 <cprintf>
  80051a:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80051d:	e8 bb 15 00 00       	call   801add <sys_enable_interrupt>

	// exit gracefully
	exit();
  800522:	e8 19 00 00 00       	call   800540 <exit>
}
  800527:	90                   	nop
  800528:	c9                   	leave  
  800529:	c3                   	ret    

0080052a <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80052a:	55                   	push   %ebp
  80052b:	89 e5                	mov    %esp,%ebp
  80052d:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800530:	83 ec 0c             	sub    $0xc,%esp
  800533:	6a 00                	push   $0x0
  800535:	e8 48 17 00 00       	call   801c82 <sys_destroy_env>
  80053a:	83 c4 10             	add    $0x10,%esp
}
  80053d:	90                   	nop
  80053e:	c9                   	leave  
  80053f:	c3                   	ret    

00800540 <exit>:

void
exit(void)
{
  800540:	55                   	push   %ebp
  800541:	89 e5                	mov    %esp,%ebp
  800543:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800546:	e8 9d 17 00 00       	call   801ce8 <sys_exit_env>
}
  80054b:	90                   	nop
  80054c:	c9                   	leave  
  80054d:	c3                   	ret    

0080054e <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80054e:	55                   	push   %ebp
  80054f:	89 e5                	mov    %esp,%ebp
  800551:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800554:	8b 45 0c             	mov    0xc(%ebp),%eax
  800557:	8b 00                	mov    (%eax),%eax
  800559:	8d 48 01             	lea    0x1(%eax),%ecx
  80055c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80055f:	89 0a                	mov    %ecx,(%edx)
  800561:	8b 55 08             	mov    0x8(%ebp),%edx
  800564:	88 d1                	mov    %dl,%cl
  800566:	8b 55 0c             	mov    0xc(%ebp),%edx
  800569:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80056d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800570:	8b 00                	mov    (%eax),%eax
  800572:	3d ff 00 00 00       	cmp    $0xff,%eax
  800577:	75 2c                	jne    8005a5 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800579:	a0 24 40 80 00       	mov    0x804024,%al
  80057e:	0f b6 c0             	movzbl %al,%eax
  800581:	8b 55 0c             	mov    0xc(%ebp),%edx
  800584:	8b 12                	mov    (%edx),%edx
  800586:	89 d1                	mov    %edx,%ecx
  800588:	8b 55 0c             	mov    0xc(%ebp),%edx
  80058b:	83 c2 08             	add    $0x8,%edx
  80058e:	83 ec 04             	sub    $0x4,%esp
  800591:	50                   	push   %eax
  800592:	51                   	push   %ecx
  800593:	52                   	push   %edx
  800594:	e8 7c 13 00 00       	call   801915 <sys_cputs>
  800599:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80059c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80059f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8005a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005a8:	8b 40 04             	mov    0x4(%eax),%eax
  8005ab:	8d 50 01             	lea    0x1(%eax),%edx
  8005ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005b1:	89 50 04             	mov    %edx,0x4(%eax)
}
  8005b4:	90                   	nop
  8005b5:	c9                   	leave  
  8005b6:	c3                   	ret    

008005b7 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8005b7:	55                   	push   %ebp
  8005b8:	89 e5                	mov    %esp,%ebp
  8005ba:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8005c0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005c7:	00 00 00 
	b.cnt = 0;
  8005ca:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8005d1:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8005d4:	ff 75 0c             	pushl  0xc(%ebp)
  8005d7:	ff 75 08             	pushl  0x8(%ebp)
  8005da:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005e0:	50                   	push   %eax
  8005e1:	68 4e 05 80 00       	push   $0x80054e
  8005e6:	e8 11 02 00 00       	call   8007fc <vprintfmt>
  8005eb:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8005ee:	a0 24 40 80 00       	mov    0x804024,%al
  8005f3:	0f b6 c0             	movzbl %al,%eax
  8005f6:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8005fc:	83 ec 04             	sub    $0x4,%esp
  8005ff:	50                   	push   %eax
  800600:	52                   	push   %edx
  800601:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800607:	83 c0 08             	add    $0x8,%eax
  80060a:	50                   	push   %eax
  80060b:	e8 05 13 00 00       	call   801915 <sys_cputs>
  800610:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800613:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80061a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800620:	c9                   	leave  
  800621:	c3                   	ret    

00800622 <cprintf>:

int cprintf(const char *fmt, ...) {
  800622:	55                   	push   %ebp
  800623:	89 e5                	mov    %esp,%ebp
  800625:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800628:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  80062f:	8d 45 0c             	lea    0xc(%ebp),%eax
  800632:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800635:	8b 45 08             	mov    0x8(%ebp),%eax
  800638:	83 ec 08             	sub    $0x8,%esp
  80063b:	ff 75 f4             	pushl  -0xc(%ebp)
  80063e:	50                   	push   %eax
  80063f:	e8 73 ff ff ff       	call   8005b7 <vcprintf>
  800644:	83 c4 10             	add    $0x10,%esp
  800647:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80064a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80064d:	c9                   	leave  
  80064e:	c3                   	ret    

0080064f <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80064f:	55                   	push   %ebp
  800650:	89 e5                	mov    %esp,%ebp
  800652:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800655:	e8 69 14 00 00       	call   801ac3 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80065a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80065d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800660:	8b 45 08             	mov    0x8(%ebp),%eax
  800663:	83 ec 08             	sub    $0x8,%esp
  800666:	ff 75 f4             	pushl  -0xc(%ebp)
  800669:	50                   	push   %eax
  80066a:	e8 48 ff ff ff       	call   8005b7 <vcprintf>
  80066f:	83 c4 10             	add    $0x10,%esp
  800672:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800675:	e8 63 14 00 00       	call   801add <sys_enable_interrupt>
	return cnt;
  80067a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80067d:	c9                   	leave  
  80067e:	c3                   	ret    

0080067f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80067f:	55                   	push   %ebp
  800680:	89 e5                	mov    %esp,%ebp
  800682:	53                   	push   %ebx
  800683:	83 ec 14             	sub    $0x14,%esp
  800686:	8b 45 10             	mov    0x10(%ebp),%eax
  800689:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80068c:	8b 45 14             	mov    0x14(%ebp),%eax
  80068f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800692:	8b 45 18             	mov    0x18(%ebp),%eax
  800695:	ba 00 00 00 00       	mov    $0x0,%edx
  80069a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80069d:	77 55                	ja     8006f4 <printnum+0x75>
  80069f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006a2:	72 05                	jb     8006a9 <printnum+0x2a>
  8006a4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8006a7:	77 4b                	ja     8006f4 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006a9:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8006ac:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8006af:	8b 45 18             	mov    0x18(%ebp),%eax
  8006b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8006b7:	52                   	push   %edx
  8006b8:	50                   	push   %eax
  8006b9:	ff 75 f4             	pushl  -0xc(%ebp)
  8006bc:	ff 75 f0             	pushl  -0x10(%ebp)
  8006bf:	e8 60 2c 00 00       	call   803324 <__udivdi3>
  8006c4:	83 c4 10             	add    $0x10,%esp
  8006c7:	83 ec 04             	sub    $0x4,%esp
  8006ca:	ff 75 20             	pushl  0x20(%ebp)
  8006cd:	53                   	push   %ebx
  8006ce:	ff 75 18             	pushl  0x18(%ebp)
  8006d1:	52                   	push   %edx
  8006d2:	50                   	push   %eax
  8006d3:	ff 75 0c             	pushl  0xc(%ebp)
  8006d6:	ff 75 08             	pushl  0x8(%ebp)
  8006d9:	e8 a1 ff ff ff       	call   80067f <printnum>
  8006de:	83 c4 20             	add    $0x20,%esp
  8006e1:	eb 1a                	jmp    8006fd <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006e3:	83 ec 08             	sub    $0x8,%esp
  8006e6:	ff 75 0c             	pushl  0xc(%ebp)
  8006e9:	ff 75 20             	pushl  0x20(%ebp)
  8006ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ef:	ff d0                	call   *%eax
  8006f1:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006f4:	ff 4d 1c             	decl   0x1c(%ebp)
  8006f7:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006fb:	7f e6                	jg     8006e3 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006fd:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800700:	bb 00 00 00 00       	mov    $0x0,%ebx
  800705:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800708:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80070b:	53                   	push   %ebx
  80070c:	51                   	push   %ecx
  80070d:	52                   	push   %edx
  80070e:	50                   	push   %eax
  80070f:	e8 20 2d 00 00       	call   803434 <__umoddi3>
  800714:	83 c4 10             	add    $0x10,%esp
  800717:	05 f4 39 80 00       	add    $0x8039f4,%eax
  80071c:	8a 00                	mov    (%eax),%al
  80071e:	0f be c0             	movsbl %al,%eax
  800721:	83 ec 08             	sub    $0x8,%esp
  800724:	ff 75 0c             	pushl  0xc(%ebp)
  800727:	50                   	push   %eax
  800728:	8b 45 08             	mov    0x8(%ebp),%eax
  80072b:	ff d0                	call   *%eax
  80072d:	83 c4 10             	add    $0x10,%esp
}
  800730:	90                   	nop
  800731:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800734:	c9                   	leave  
  800735:	c3                   	ret    

00800736 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800736:	55                   	push   %ebp
  800737:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800739:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80073d:	7e 1c                	jle    80075b <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80073f:	8b 45 08             	mov    0x8(%ebp),%eax
  800742:	8b 00                	mov    (%eax),%eax
  800744:	8d 50 08             	lea    0x8(%eax),%edx
  800747:	8b 45 08             	mov    0x8(%ebp),%eax
  80074a:	89 10                	mov    %edx,(%eax)
  80074c:	8b 45 08             	mov    0x8(%ebp),%eax
  80074f:	8b 00                	mov    (%eax),%eax
  800751:	83 e8 08             	sub    $0x8,%eax
  800754:	8b 50 04             	mov    0x4(%eax),%edx
  800757:	8b 00                	mov    (%eax),%eax
  800759:	eb 40                	jmp    80079b <getuint+0x65>
	else if (lflag)
  80075b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80075f:	74 1e                	je     80077f <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800761:	8b 45 08             	mov    0x8(%ebp),%eax
  800764:	8b 00                	mov    (%eax),%eax
  800766:	8d 50 04             	lea    0x4(%eax),%edx
  800769:	8b 45 08             	mov    0x8(%ebp),%eax
  80076c:	89 10                	mov    %edx,(%eax)
  80076e:	8b 45 08             	mov    0x8(%ebp),%eax
  800771:	8b 00                	mov    (%eax),%eax
  800773:	83 e8 04             	sub    $0x4,%eax
  800776:	8b 00                	mov    (%eax),%eax
  800778:	ba 00 00 00 00       	mov    $0x0,%edx
  80077d:	eb 1c                	jmp    80079b <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80077f:	8b 45 08             	mov    0x8(%ebp),%eax
  800782:	8b 00                	mov    (%eax),%eax
  800784:	8d 50 04             	lea    0x4(%eax),%edx
  800787:	8b 45 08             	mov    0x8(%ebp),%eax
  80078a:	89 10                	mov    %edx,(%eax)
  80078c:	8b 45 08             	mov    0x8(%ebp),%eax
  80078f:	8b 00                	mov    (%eax),%eax
  800791:	83 e8 04             	sub    $0x4,%eax
  800794:	8b 00                	mov    (%eax),%eax
  800796:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80079b:	5d                   	pop    %ebp
  80079c:	c3                   	ret    

0080079d <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80079d:	55                   	push   %ebp
  80079e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007a0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007a4:	7e 1c                	jle    8007c2 <getint+0x25>
		return va_arg(*ap, long long);
  8007a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a9:	8b 00                	mov    (%eax),%eax
  8007ab:	8d 50 08             	lea    0x8(%eax),%edx
  8007ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b1:	89 10                	mov    %edx,(%eax)
  8007b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b6:	8b 00                	mov    (%eax),%eax
  8007b8:	83 e8 08             	sub    $0x8,%eax
  8007bb:	8b 50 04             	mov    0x4(%eax),%edx
  8007be:	8b 00                	mov    (%eax),%eax
  8007c0:	eb 38                	jmp    8007fa <getint+0x5d>
	else if (lflag)
  8007c2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007c6:	74 1a                	je     8007e2 <getint+0x45>
		return va_arg(*ap, long);
  8007c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cb:	8b 00                	mov    (%eax),%eax
  8007cd:	8d 50 04             	lea    0x4(%eax),%edx
  8007d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d3:	89 10                	mov    %edx,(%eax)
  8007d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d8:	8b 00                	mov    (%eax),%eax
  8007da:	83 e8 04             	sub    $0x4,%eax
  8007dd:	8b 00                	mov    (%eax),%eax
  8007df:	99                   	cltd   
  8007e0:	eb 18                	jmp    8007fa <getint+0x5d>
	else
		return va_arg(*ap, int);
  8007e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e5:	8b 00                	mov    (%eax),%eax
  8007e7:	8d 50 04             	lea    0x4(%eax),%edx
  8007ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ed:	89 10                	mov    %edx,(%eax)
  8007ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f2:	8b 00                	mov    (%eax),%eax
  8007f4:	83 e8 04             	sub    $0x4,%eax
  8007f7:	8b 00                	mov    (%eax),%eax
  8007f9:	99                   	cltd   
}
  8007fa:	5d                   	pop    %ebp
  8007fb:	c3                   	ret    

008007fc <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007fc:	55                   	push   %ebp
  8007fd:	89 e5                	mov    %esp,%ebp
  8007ff:	56                   	push   %esi
  800800:	53                   	push   %ebx
  800801:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800804:	eb 17                	jmp    80081d <vprintfmt+0x21>
			if (ch == '\0')
  800806:	85 db                	test   %ebx,%ebx
  800808:	0f 84 af 03 00 00    	je     800bbd <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80080e:	83 ec 08             	sub    $0x8,%esp
  800811:	ff 75 0c             	pushl  0xc(%ebp)
  800814:	53                   	push   %ebx
  800815:	8b 45 08             	mov    0x8(%ebp),%eax
  800818:	ff d0                	call   *%eax
  80081a:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80081d:	8b 45 10             	mov    0x10(%ebp),%eax
  800820:	8d 50 01             	lea    0x1(%eax),%edx
  800823:	89 55 10             	mov    %edx,0x10(%ebp)
  800826:	8a 00                	mov    (%eax),%al
  800828:	0f b6 d8             	movzbl %al,%ebx
  80082b:	83 fb 25             	cmp    $0x25,%ebx
  80082e:	75 d6                	jne    800806 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800830:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800834:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80083b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800842:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800849:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800850:	8b 45 10             	mov    0x10(%ebp),%eax
  800853:	8d 50 01             	lea    0x1(%eax),%edx
  800856:	89 55 10             	mov    %edx,0x10(%ebp)
  800859:	8a 00                	mov    (%eax),%al
  80085b:	0f b6 d8             	movzbl %al,%ebx
  80085e:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800861:	83 f8 55             	cmp    $0x55,%eax
  800864:	0f 87 2b 03 00 00    	ja     800b95 <vprintfmt+0x399>
  80086a:	8b 04 85 18 3a 80 00 	mov    0x803a18(,%eax,4),%eax
  800871:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800873:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800877:	eb d7                	jmp    800850 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800879:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80087d:	eb d1                	jmp    800850 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80087f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800886:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800889:	89 d0                	mov    %edx,%eax
  80088b:	c1 e0 02             	shl    $0x2,%eax
  80088e:	01 d0                	add    %edx,%eax
  800890:	01 c0                	add    %eax,%eax
  800892:	01 d8                	add    %ebx,%eax
  800894:	83 e8 30             	sub    $0x30,%eax
  800897:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80089a:	8b 45 10             	mov    0x10(%ebp),%eax
  80089d:	8a 00                	mov    (%eax),%al
  80089f:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8008a2:	83 fb 2f             	cmp    $0x2f,%ebx
  8008a5:	7e 3e                	jle    8008e5 <vprintfmt+0xe9>
  8008a7:	83 fb 39             	cmp    $0x39,%ebx
  8008aa:	7f 39                	jg     8008e5 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008ac:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008af:	eb d5                	jmp    800886 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8008b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b4:	83 c0 04             	add    $0x4,%eax
  8008b7:	89 45 14             	mov    %eax,0x14(%ebp)
  8008ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8008bd:	83 e8 04             	sub    $0x4,%eax
  8008c0:	8b 00                	mov    (%eax),%eax
  8008c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8008c5:	eb 1f                	jmp    8008e6 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8008c7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008cb:	79 83                	jns    800850 <vprintfmt+0x54>
				width = 0;
  8008cd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8008d4:	e9 77 ff ff ff       	jmp    800850 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008d9:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8008e0:	e9 6b ff ff ff       	jmp    800850 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008e5:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008e6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ea:	0f 89 60 ff ff ff    	jns    800850 <vprintfmt+0x54>
				width = precision, precision = -1;
  8008f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008f6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008fd:	e9 4e ff ff ff       	jmp    800850 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800902:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800905:	e9 46 ff ff ff       	jmp    800850 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80090a:	8b 45 14             	mov    0x14(%ebp),%eax
  80090d:	83 c0 04             	add    $0x4,%eax
  800910:	89 45 14             	mov    %eax,0x14(%ebp)
  800913:	8b 45 14             	mov    0x14(%ebp),%eax
  800916:	83 e8 04             	sub    $0x4,%eax
  800919:	8b 00                	mov    (%eax),%eax
  80091b:	83 ec 08             	sub    $0x8,%esp
  80091e:	ff 75 0c             	pushl  0xc(%ebp)
  800921:	50                   	push   %eax
  800922:	8b 45 08             	mov    0x8(%ebp),%eax
  800925:	ff d0                	call   *%eax
  800927:	83 c4 10             	add    $0x10,%esp
			break;
  80092a:	e9 89 02 00 00       	jmp    800bb8 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80092f:	8b 45 14             	mov    0x14(%ebp),%eax
  800932:	83 c0 04             	add    $0x4,%eax
  800935:	89 45 14             	mov    %eax,0x14(%ebp)
  800938:	8b 45 14             	mov    0x14(%ebp),%eax
  80093b:	83 e8 04             	sub    $0x4,%eax
  80093e:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800940:	85 db                	test   %ebx,%ebx
  800942:	79 02                	jns    800946 <vprintfmt+0x14a>
				err = -err;
  800944:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800946:	83 fb 64             	cmp    $0x64,%ebx
  800949:	7f 0b                	jg     800956 <vprintfmt+0x15a>
  80094b:	8b 34 9d 60 38 80 00 	mov    0x803860(,%ebx,4),%esi
  800952:	85 f6                	test   %esi,%esi
  800954:	75 19                	jne    80096f <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800956:	53                   	push   %ebx
  800957:	68 05 3a 80 00       	push   $0x803a05
  80095c:	ff 75 0c             	pushl  0xc(%ebp)
  80095f:	ff 75 08             	pushl  0x8(%ebp)
  800962:	e8 5e 02 00 00       	call   800bc5 <printfmt>
  800967:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80096a:	e9 49 02 00 00       	jmp    800bb8 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80096f:	56                   	push   %esi
  800970:	68 0e 3a 80 00       	push   $0x803a0e
  800975:	ff 75 0c             	pushl  0xc(%ebp)
  800978:	ff 75 08             	pushl  0x8(%ebp)
  80097b:	e8 45 02 00 00       	call   800bc5 <printfmt>
  800980:	83 c4 10             	add    $0x10,%esp
			break;
  800983:	e9 30 02 00 00       	jmp    800bb8 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800988:	8b 45 14             	mov    0x14(%ebp),%eax
  80098b:	83 c0 04             	add    $0x4,%eax
  80098e:	89 45 14             	mov    %eax,0x14(%ebp)
  800991:	8b 45 14             	mov    0x14(%ebp),%eax
  800994:	83 e8 04             	sub    $0x4,%eax
  800997:	8b 30                	mov    (%eax),%esi
  800999:	85 f6                	test   %esi,%esi
  80099b:	75 05                	jne    8009a2 <vprintfmt+0x1a6>
				p = "(null)";
  80099d:	be 11 3a 80 00       	mov    $0x803a11,%esi
			if (width > 0 && padc != '-')
  8009a2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009a6:	7e 6d                	jle    800a15 <vprintfmt+0x219>
  8009a8:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8009ac:	74 67                	je     800a15 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009b1:	83 ec 08             	sub    $0x8,%esp
  8009b4:	50                   	push   %eax
  8009b5:	56                   	push   %esi
  8009b6:	e8 0c 03 00 00       	call   800cc7 <strnlen>
  8009bb:	83 c4 10             	add    $0x10,%esp
  8009be:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8009c1:	eb 16                	jmp    8009d9 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8009c3:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009c7:	83 ec 08             	sub    $0x8,%esp
  8009ca:	ff 75 0c             	pushl  0xc(%ebp)
  8009cd:	50                   	push   %eax
  8009ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d1:	ff d0                	call   *%eax
  8009d3:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009d6:	ff 4d e4             	decl   -0x1c(%ebp)
  8009d9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009dd:	7f e4                	jg     8009c3 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009df:	eb 34                	jmp    800a15 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8009e1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009e5:	74 1c                	je     800a03 <vprintfmt+0x207>
  8009e7:	83 fb 1f             	cmp    $0x1f,%ebx
  8009ea:	7e 05                	jle    8009f1 <vprintfmt+0x1f5>
  8009ec:	83 fb 7e             	cmp    $0x7e,%ebx
  8009ef:	7e 12                	jle    800a03 <vprintfmt+0x207>
					putch('?', putdat);
  8009f1:	83 ec 08             	sub    $0x8,%esp
  8009f4:	ff 75 0c             	pushl  0xc(%ebp)
  8009f7:	6a 3f                	push   $0x3f
  8009f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fc:	ff d0                	call   *%eax
  8009fe:	83 c4 10             	add    $0x10,%esp
  800a01:	eb 0f                	jmp    800a12 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a03:	83 ec 08             	sub    $0x8,%esp
  800a06:	ff 75 0c             	pushl  0xc(%ebp)
  800a09:	53                   	push   %ebx
  800a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0d:	ff d0                	call   *%eax
  800a0f:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a12:	ff 4d e4             	decl   -0x1c(%ebp)
  800a15:	89 f0                	mov    %esi,%eax
  800a17:	8d 70 01             	lea    0x1(%eax),%esi
  800a1a:	8a 00                	mov    (%eax),%al
  800a1c:	0f be d8             	movsbl %al,%ebx
  800a1f:	85 db                	test   %ebx,%ebx
  800a21:	74 24                	je     800a47 <vprintfmt+0x24b>
  800a23:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a27:	78 b8                	js     8009e1 <vprintfmt+0x1e5>
  800a29:	ff 4d e0             	decl   -0x20(%ebp)
  800a2c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a30:	79 af                	jns    8009e1 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a32:	eb 13                	jmp    800a47 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a34:	83 ec 08             	sub    $0x8,%esp
  800a37:	ff 75 0c             	pushl  0xc(%ebp)
  800a3a:	6a 20                	push   $0x20
  800a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3f:	ff d0                	call   *%eax
  800a41:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a44:	ff 4d e4             	decl   -0x1c(%ebp)
  800a47:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a4b:	7f e7                	jg     800a34 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a4d:	e9 66 01 00 00       	jmp    800bb8 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a52:	83 ec 08             	sub    $0x8,%esp
  800a55:	ff 75 e8             	pushl  -0x18(%ebp)
  800a58:	8d 45 14             	lea    0x14(%ebp),%eax
  800a5b:	50                   	push   %eax
  800a5c:	e8 3c fd ff ff       	call   80079d <getint>
  800a61:	83 c4 10             	add    $0x10,%esp
  800a64:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a67:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a6d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a70:	85 d2                	test   %edx,%edx
  800a72:	79 23                	jns    800a97 <vprintfmt+0x29b>
				putch('-', putdat);
  800a74:	83 ec 08             	sub    $0x8,%esp
  800a77:	ff 75 0c             	pushl  0xc(%ebp)
  800a7a:	6a 2d                	push   $0x2d
  800a7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7f:	ff d0                	call   *%eax
  800a81:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a87:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a8a:	f7 d8                	neg    %eax
  800a8c:	83 d2 00             	adc    $0x0,%edx
  800a8f:	f7 da                	neg    %edx
  800a91:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a94:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a97:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a9e:	e9 bc 00 00 00       	jmp    800b5f <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800aa3:	83 ec 08             	sub    $0x8,%esp
  800aa6:	ff 75 e8             	pushl  -0x18(%ebp)
  800aa9:	8d 45 14             	lea    0x14(%ebp),%eax
  800aac:	50                   	push   %eax
  800aad:	e8 84 fc ff ff       	call   800736 <getuint>
  800ab2:	83 c4 10             	add    $0x10,%esp
  800ab5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ab8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800abb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ac2:	e9 98 00 00 00       	jmp    800b5f <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ac7:	83 ec 08             	sub    $0x8,%esp
  800aca:	ff 75 0c             	pushl  0xc(%ebp)
  800acd:	6a 58                	push   $0x58
  800acf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad2:	ff d0                	call   *%eax
  800ad4:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ad7:	83 ec 08             	sub    $0x8,%esp
  800ada:	ff 75 0c             	pushl  0xc(%ebp)
  800add:	6a 58                	push   $0x58
  800adf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae2:	ff d0                	call   *%eax
  800ae4:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ae7:	83 ec 08             	sub    $0x8,%esp
  800aea:	ff 75 0c             	pushl  0xc(%ebp)
  800aed:	6a 58                	push   $0x58
  800aef:	8b 45 08             	mov    0x8(%ebp),%eax
  800af2:	ff d0                	call   *%eax
  800af4:	83 c4 10             	add    $0x10,%esp
			break;
  800af7:	e9 bc 00 00 00       	jmp    800bb8 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800afc:	83 ec 08             	sub    $0x8,%esp
  800aff:	ff 75 0c             	pushl  0xc(%ebp)
  800b02:	6a 30                	push   $0x30
  800b04:	8b 45 08             	mov    0x8(%ebp),%eax
  800b07:	ff d0                	call   *%eax
  800b09:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b0c:	83 ec 08             	sub    $0x8,%esp
  800b0f:	ff 75 0c             	pushl  0xc(%ebp)
  800b12:	6a 78                	push   $0x78
  800b14:	8b 45 08             	mov    0x8(%ebp),%eax
  800b17:	ff d0                	call   *%eax
  800b19:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b1c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b1f:	83 c0 04             	add    $0x4,%eax
  800b22:	89 45 14             	mov    %eax,0x14(%ebp)
  800b25:	8b 45 14             	mov    0x14(%ebp),%eax
  800b28:	83 e8 04             	sub    $0x4,%eax
  800b2b:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b2d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b30:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b37:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b3e:	eb 1f                	jmp    800b5f <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b40:	83 ec 08             	sub    $0x8,%esp
  800b43:	ff 75 e8             	pushl  -0x18(%ebp)
  800b46:	8d 45 14             	lea    0x14(%ebp),%eax
  800b49:	50                   	push   %eax
  800b4a:	e8 e7 fb ff ff       	call   800736 <getuint>
  800b4f:	83 c4 10             	add    $0x10,%esp
  800b52:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b55:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b58:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b5f:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b63:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b66:	83 ec 04             	sub    $0x4,%esp
  800b69:	52                   	push   %edx
  800b6a:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b6d:	50                   	push   %eax
  800b6e:	ff 75 f4             	pushl  -0xc(%ebp)
  800b71:	ff 75 f0             	pushl  -0x10(%ebp)
  800b74:	ff 75 0c             	pushl  0xc(%ebp)
  800b77:	ff 75 08             	pushl  0x8(%ebp)
  800b7a:	e8 00 fb ff ff       	call   80067f <printnum>
  800b7f:	83 c4 20             	add    $0x20,%esp
			break;
  800b82:	eb 34                	jmp    800bb8 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b84:	83 ec 08             	sub    $0x8,%esp
  800b87:	ff 75 0c             	pushl  0xc(%ebp)
  800b8a:	53                   	push   %ebx
  800b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8e:	ff d0                	call   *%eax
  800b90:	83 c4 10             	add    $0x10,%esp
			break;
  800b93:	eb 23                	jmp    800bb8 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b95:	83 ec 08             	sub    $0x8,%esp
  800b98:	ff 75 0c             	pushl  0xc(%ebp)
  800b9b:	6a 25                	push   $0x25
  800b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba0:	ff d0                	call   *%eax
  800ba2:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ba5:	ff 4d 10             	decl   0x10(%ebp)
  800ba8:	eb 03                	jmp    800bad <vprintfmt+0x3b1>
  800baa:	ff 4d 10             	decl   0x10(%ebp)
  800bad:	8b 45 10             	mov    0x10(%ebp),%eax
  800bb0:	48                   	dec    %eax
  800bb1:	8a 00                	mov    (%eax),%al
  800bb3:	3c 25                	cmp    $0x25,%al
  800bb5:	75 f3                	jne    800baa <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800bb7:	90                   	nop
		}
	}
  800bb8:	e9 47 fc ff ff       	jmp    800804 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800bbd:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800bbe:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bc1:	5b                   	pop    %ebx
  800bc2:	5e                   	pop    %esi
  800bc3:	5d                   	pop    %ebp
  800bc4:	c3                   	ret    

00800bc5 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bc5:	55                   	push   %ebp
  800bc6:	89 e5                	mov    %esp,%ebp
  800bc8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800bcb:	8d 45 10             	lea    0x10(%ebp),%eax
  800bce:	83 c0 04             	add    $0x4,%eax
  800bd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800bd4:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd7:	ff 75 f4             	pushl  -0xc(%ebp)
  800bda:	50                   	push   %eax
  800bdb:	ff 75 0c             	pushl  0xc(%ebp)
  800bde:	ff 75 08             	pushl  0x8(%ebp)
  800be1:	e8 16 fc ff ff       	call   8007fc <vprintfmt>
  800be6:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800be9:	90                   	nop
  800bea:	c9                   	leave  
  800beb:	c3                   	ret    

00800bec <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bec:	55                   	push   %ebp
  800bed:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800bef:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf2:	8b 40 08             	mov    0x8(%eax),%eax
  800bf5:	8d 50 01             	lea    0x1(%eax),%edx
  800bf8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bfb:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800bfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c01:	8b 10                	mov    (%eax),%edx
  800c03:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c06:	8b 40 04             	mov    0x4(%eax),%eax
  800c09:	39 c2                	cmp    %eax,%edx
  800c0b:	73 12                	jae    800c1f <sprintputch+0x33>
		*b->buf++ = ch;
  800c0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c10:	8b 00                	mov    (%eax),%eax
  800c12:	8d 48 01             	lea    0x1(%eax),%ecx
  800c15:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c18:	89 0a                	mov    %ecx,(%edx)
  800c1a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c1d:	88 10                	mov    %dl,(%eax)
}
  800c1f:	90                   	nop
  800c20:	5d                   	pop    %ebp
  800c21:	c3                   	ret    

00800c22 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c22:	55                   	push   %ebp
  800c23:	89 e5                	mov    %esp,%ebp
  800c25:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c28:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c31:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c34:	8b 45 08             	mov    0x8(%ebp),%eax
  800c37:	01 d0                	add    %edx,%eax
  800c39:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c3c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c43:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c47:	74 06                	je     800c4f <vsnprintf+0x2d>
  800c49:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c4d:	7f 07                	jg     800c56 <vsnprintf+0x34>
		return -E_INVAL;
  800c4f:	b8 03 00 00 00       	mov    $0x3,%eax
  800c54:	eb 20                	jmp    800c76 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c56:	ff 75 14             	pushl  0x14(%ebp)
  800c59:	ff 75 10             	pushl  0x10(%ebp)
  800c5c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c5f:	50                   	push   %eax
  800c60:	68 ec 0b 80 00       	push   $0x800bec
  800c65:	e8 92 fb ff ff       	call   8007fc <vprintfmt>
  800c6a:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c6d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c70:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c73:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c76:	c9                   	leave  
  800c77:	c3                   	ret    

00800c78 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c78:	55                   	push   %ebp
  800c79:	89 e5                	mov    %esp,%ebp
  800c7b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c7e:	8d 45 10             	lea    0x10(%ebp),%eax
  800c81:	83 c0 04             	add    $0x4,%eax
  800c84:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c87:	8b 45 10             	mov    0x10(%ebp),%eax
  800c8a:	ff 75 f4             	pushl  -0xc(%ebp)
  800c8d:	50                   	push   %eax
  800c8e:	ff 75 0c             	pushl  0xc(%ebp)
  800c91:	ff 75 08             	pushl  0x8(%ebp)
  800c94:	e8 89 ff ff ff       	call   800c22 <vsnprintf>
  800c99:	83 c4 10             	add    $0x10,%esp
  800c9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ca2:	c9                   	leave  
  800ca3:	c3                   	ret    

00800ca4 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800ca4:	55                   	push   %ebp
  800ca5:	89 e5                	mov    %esp,%ebp
  800ca7:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800caa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cb1:	eb 06                	jmp    800cb9 <strlen+0x15>
		n++;
  800cb3:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800cb6:	ff 45 08             	incl   0x8(%ebp)
  800cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbc:	8a 00                	mov    (%eax),%al
  800cbe:	84 c0                	test   %al,%al
  800cc0:	75 f1                	jne    800cb3 <strlen+0xf>
		n++;
	return n;
  800cc2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cc5:	c9                   	leave  
  800cc6:	c3                   	ret    

00800cc7 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800cc7:	55                   	push   %ebp
  800cc8:	89 e5                	mov    %esp,%ebp
  800cca:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ccd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cd4:	eb 09                	jmp    800cdf <strnlen+0x18>
		n++;
  800cd6:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cd9:	ff 45 08             	incl   0x8(%ebp)
  800cdc:	ff 4d 0c             	decl   0xc(%ebp)
  800cdf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ce3:	74 09                	je     800cee <strnlen+0x27>
  800ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce8:	8a 00                	mov    (%eax),%al
  800cea:	84 c0                	test   %al,%al
  800cec:	75 e8                	jne    800cd6 <strnlen+0xf>
		n++;
	return n;
  800cee:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cf1:	c9                   	leave  
  800cf2:	c3                   	ret    

00800cf3 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cf3:	55                   	push   %ebp
  800cf4:	89 e5                	mov    %esp,%ebp
  800cf6:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800cff:	90                   	nop
  800d00:	8b 45 08             	mov    0x8(%ebp),%eax
  800d03:	8d 50 01             	lea    0x1(%eax),%edx
  800d06:	89 55 08             	mov    %edx,0x8(%ebp)
  800d09:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d0c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d0f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d12:	8a 12                	mov    (%edx),%dl
  800d14:	88 10                	mov    %dl,(%eax)
  800d16:	8a 00                	mov    (%eax),%al
  800d18:	84 c0                	test   %al,%al
  800d1a:	75 e4                	jne    800d00 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d1f:	c9                   	leave  
  800d20:	c3                   	ret    

00800d21 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d21:	55                   	push   %ebp
  800d22:	89 e5                	mov    %esp,%ebp
  800d24:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d27:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d2d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d34:	eb 1f                	jmp    800d55 <strncpy+0x34>
		*dst++ = *src;
  800d36:	8b 45 08             	mov    0x8(%ebp),%eax
  800d39:	8d 50 01             	lea    0x1(%eax),%edx
  800d3c:	89 55 08             	mov    %edx,0x8(%ebp)
  800d3f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d42:	8a 12                	mov    (%edx),%dl
  800d44:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d49:	8a 00                	mov    (%eax),%al
  800d4b:	84 c0                	test   %al,%al
  800d4d:	74 03                	je     800d52 <strncpy+0x31>
			src++;
  800d4f:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d52:	ff 45 fc             	incl   -0x4(%ebp)
  800d55:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d58:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d5b:	72 d9                	jb     800d36 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d5d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d60:	c9                   	leave  
  800d61:	c3                   	ret    

00800d62 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d62:	55                   	push   %ebp
  800d63:	89 e5                	mov    %esp,%ebp
  800d65:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d68:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d6e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d72:	74 30                	je     800da4 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d74:	eb 16                	jmp    800d8c <strlcpy+0x2a>
			*dst++ = *src++;
  800d76:	8b 45 08             	mov    0x8(%ebp),%eax
  800d79:	8d 50 01             	lea    0x1(%eax),%edx
  800d7c:	89 55 08             	mov    %edx,0x8(%ebp)
  800d7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d82:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d85:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d88:	8a 12                	mov    (%edx),%dl
  800d8a:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d8c:	ff 4d 10             	decl   0x10(%ebp)
  800d8f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d93:	74 09                	je     800d9e <strlcpy+0x3c>
  800d95:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d98:	8a 00                	mov    (%eax),%al
  800d9a:	84 c0                	test   %al,%al
  800d9c:	75 d8                	jne    800d76 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800da1:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800da4:	8b 55 08             	mov    0x8(%ebp),%edx
  800da7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800daa:	29 c2                	sub    %eax,%edx
  800dac:	89 d0                	mov    %edx,%eax
}
  800dae:	c9                   	leave  
  800daf:	c3                   	ret    

00800db0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800db0:	55                   	push   %ebp
  800db1:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800db3:	eb 06                	jmp    800dbb <strcmp+0xb>
		p++, q++;
  800db5:	ff 45 08             	incl   0x8(%ebp)
  800db8:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbe:	8a 00                	mov    (%eax),%al
  800dc0:	84 c0                	test   %al,%al
  800dc2:	74 0e                	je     800dd2 <strcmp+0x22>
  800dc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc7:	8a 10                	mov    (%eax),%dl
  800dc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dcc:	8a 00                	mov    (%eax),%al
  800dce:	38 c2                	cmp    %al,%dl
  800dd0:	74 e3                	je     800db5 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd5:	8a 00                	mov    (%eax),%al
  800dd7:	0f b6 d0             	movzbl %al,%edx
  800dda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddd:	8a 00                	mov    (%eax),%al
  800ddf:	0f b6 c0             	movzbl %al,%eax
  800de2:	29 c2                	sub    %eax,%edx
  800de4:	89 d0                	mov    %edx,%eax
}
  800de6:	5d                   	pop    %ebp
  800de7:	c3                   	ret    

00800de8 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800de8:	55                   	push   %ebp
  800de9:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800deb:	eb 09                	jmp    800df6 <strncmp+0xe>
		n--, p++, q++;
  800ded:	ff 4d 10             	decl   0x10(%ebp)
  800df0:	ff 45 08             	incl   0x8(%ebp)
  800df3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800df6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dfa:	74 17                	je     800e13 <strncmp+0x2b>
  800dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dff:	8a 00                	mov    (%eax),%al
  800e01:	84 c0                	test   %al,%al
  800e03:	74 0e                	je     800e13 <strncmp+0x2b>
  800e05:	8b 45 08             	mov    0x8(%ebp),%eax
  800e08:	8a 10                	mov    (%eax),%dl
  800e0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0d:	8a 00                	mov    (%eax),%al
  800e0f:	38 c2                	cmp    %al,%dl
  800e11:	74 da                	je     800ded <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e13:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e17:	75 07                	jne    800e20 <strncmp+0x38>
		return 0;
  800e19:	b8 00 00 00 00       	mov    $0x0,%eax
  800e1e:	eb 14                	jmp    800e34 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e20:	8b 45 08             	mov    0x8(%ebp),%eax
  800e23:	8a 00                	mov    (%eax),%al
  800e25:	0f b6 d0             	movzbl %al,%edx
  800e28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2b:	8a 00                	mov    (%eax),%al
  800e2d:	0f b6 c0             	movzbl %al,%eax
  800e30:	29 c2                	sub    %eax,%edx
  800e32:	89 d0                	mov    %edx,%eax
}
  800e34:	5d                   	pop    %ebp
  800e35:	c3                   	ret    

00800e36 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e36:	55                   	push   %ebp
  800e37:	89 e5                	mov    %esp,%ebp
  800e39:	83 ec 04             	sub    $0x4,%esp
  800e3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e42:	eb 12                	jmp    800e56 <strchr+0x20>
		if (*s == c)
  800e44:	8b 45 08             	mov    0x8(%ebp),%eax
  800e47:	8a 00                	mov    (%eax),%al
  800e49:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e4c:	75 05                	jne    800e53 <strchr+0x1d>
			return (char *) s;
  800e4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e51:	eb 11                	jmp    800e64 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e53:	ff 45 08             	incl   0x8(%ebp)
  800e56:	8b 45 08             	mov    0x8(%ebp),%eax
  800e59:	8a 00                	mov    (%eax),%al
  800e5b:	84 c0                	test   %al,%al
  800e5d:	75 e5                	jne    800e44 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e5f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e64:	c9                   	leave  
  800e65:	c3                   	ret    

00800e66 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e66:	55                   	push   %ebp
  800e67:	89 e5                	mov    %esp,%ebp
  800e69:	83 ec 04             	sub    $0x4,%esp
  800e6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e72:	eb 0d                	jmp    800e81 <strfind+0x1b>
		if (*s == c)
  800e74:	8b 45 08             	mov    0x8(%ebp),%eax
  800e77:	8a 00                	mov    (%eax),%al
  800e79:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e7c:	74 0e                	je     800e8c <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e7e:	ff 45 08             	incl   0x8(%ebp)
  800e81:	8b 45 08             	mov    0x8(%ebp),%eax
  800e84:	8a 00                	mov    (%eax),%al
  800e86:	84 c0                	test   %al,%al
  800e88:	75 ea                	jne    800e74 <strfind+0xe>
  800e8a:	eb 01                	jmp    800e8d <strfind+0x27>
		if (*s == c)
			break;
  800e8c:	90                   	nop
	return (char *) s;
  800e8d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e90:	c9                   	leave  
  800e91:	c3                   	ret    

00800e92 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800e92:	55                   	push   %ebp
  800e93:	89 e5                	mov    %esp,%ebp
  800e95:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e98:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e9e:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800ea4:	eb 0e                	jmp    800eb4 <memset+0x22>
		*p++ = c;
  800ea6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea9:	8d 50 01             	lea    0x1(%eax),%edx
  800eac:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800eaf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eb2:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800eb4:	ff 4d f8             	decl   -0x8(%ebp)
  800eb7:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800ebb:	79 e9                	jns    800ea6 <memset+0x14>
		*p++ = c;

	return v;
  800ebd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ec0:	c9                   	leave  
  800ec1:	c3                   	ret    

00800ec2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800ec2:	55                   	push   %ebp
  800ec3:	89 e5                	mov    %esp,%ebp
  800ec5:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ec8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ecb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ece:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800ed4:	eb 16                	jmp    800eec <memcpy+0x2a>
		*d++ = *s++;
  800ed6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ed9:	8d 50 01             	lea    0x1(%eax),%edx
  800edc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800edf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ee2:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ee5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ee8:	8a 12                	mov    (%edx),%dl
  800eea:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800eec:	8b 45 10             	mov    0x10(%ebp),%eax
  800eef:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ef2:	89 55 10             	mov    %edx,0x10(%ebp)
  800ef5:	85 c0                	test   %eax,%eax
  800ef7:	75 dd                	jne    800ed6 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800ef9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800efc:	c9                   	leave  
  800efd:	c3                   	ret    

00800efe <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800efe:	55                   	push   %ebp
  800eff:	89 e5                	mov    %esp,%ebp
  800f01:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f04:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f07:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f10:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f13:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f16:	73 50                	jae    800f68 <memmove+0x6a>
  800f18:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f1b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1e:	01 d0                	add    %edx,%eax
  800f20:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f23:	76 43                	jbe    800f68 <memmove+0x6a>
		s += n;
  800f25:	8b 45 10             	mov    0x10(%ebp),%eax
  800f28:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f2b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f2e:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f31:	eb 10                	jmp    800f43 <memmove+0x45>
			*--d = *--s;
  800f33:	ff 4d f8             	decl   -0x8(%ebp)
  800f36:	ff 4d fc             	decl   -0x4(%ebp)
  800f39:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f3c:	8a 10                	mov    (%eax),%dl
  800f3e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f41:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f43:	8b 45 10             	mov    0x10(%ebp),%eax
  800f46:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f49:	89 55 10             	mov    %edx,0x10(%ebp)
  800f4c:	85 c0                	test   %eax,%eax
  800f4e:	75 e3                	jne    800f33 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f50:	eb 23                	jmp    800f75 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f52:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f55:	8d 50 01             	lea    0x1(%eax),%edx
  800f58:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f5b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f5e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f61:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f64:	8a 12                	mov    (%edx),%dl
  800f66:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f68:	8b 45 10             	mov    0x10(%ebp),%eax
  800f6b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f6e:	89 55 10             	mov    %edx,0x10(%ebp)
  800f71:	85 c0                	test   %eax,%eax
  800f73:	75 dd                	jne    800f52 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f75:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f78:	c9                   	leave  
  800f79:	c3                   	ret    

00800f7a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f7a:	55                   	push   %ebp
  800f7b:	89 e5                	mov    %esp,%ebp
  800f7d:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f80:	8b 45 08             	mov    0x8(%ebp),%eax
  800f83:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f86:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f89:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f8c:	eb 2a                	jmp    800fb8 <memcmp+0x3e>
		if (*s1 != *s2)
  800f8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f91:	8a 10                	mov    (%eax),%dl
  800f93:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f96:	8a 00                	mov    (%eax),%al
  800f98:	38 c2                	cmp    %al,%dl
  800f9a:	74 16                	je     800fb2 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f9c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f9f:	8a 00                	mov    (%eax),%al
  800fa1:	0f b6 d0             	movzbl %al,%edx
  800fa4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fa7:	8a 00                	mov    (%eax),%al
  800fa9:	0f b6 c0             	movzbl %al,%eax
  800fac:	29 c2                	sub    %eax,%edx
  800fae:	89 d0                	mov    %edx,%eax
  800fb0:	eb 18                	jmp    800fca <memcmp+0x50>
		s1++, s2++;
  800fb2:	ff 45 fc             	incl   -0x4(%ebp)
  800fb5:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800fb8:	8b 45 10             	mov    0x10(%ebp),%eax
  800fbb:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fbe:	89 55 10             	mov    %edx,0x10(%ebp)
  800fc1:	85 c0                	test   %eax,%eax
  800fc3:	75 c9                	jne    800f8e <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800fc5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fca:	c9                   	leave  
  800fcb:	c3                   	ret    

00800fcc <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800fcc:	55                   	push   %ebp
  800fcd:	89 e5                	mov    %esp,%ebp
  800fcf:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800fd2:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd5:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd8:	01 d0                	add    %edx,%eax
  800fda:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800fdd:	eb 15                	jmp    800ff4 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800fdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe2:	8a 00                	mov    (%eax),%al
  800fe4:	0f b6 d0             	movzbl %al,%edx
  800fe7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fea:	0f b6 c0             	movzbl %al,%eax
  800fed:	39 c2                	cmp    %eax,%edx
  800fef:	74 0d                	je     800ffe <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ff1:	ff 45 08             	incl   0x8(%ebp)
  800ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800ffa:	72 e3                	jb     800fdf <memfind+0x13>
  800ffc:	eb 01                	jmp    800fff <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800ffe:	90                   	nop
	return (void *) s;
  800fff:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801002:	c9                   	leave  
  801003:	c3                   	ret    

00801004 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801004:	55                   	push   %ebp
  801005:	89 e5                	mov    %esp,%ebp
  801007:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80100a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801011:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801018:	eb 03                	jmp    80101d <strtol+0x19>
		s++;
  80101a:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80101d:	8b 45 08             	mov    0x8(%ebp),%eax
  801020:	8a 00                	mov    (%eax),%al
  801022:	3c 20                	cmp    $0x20,%al
  801024:	74 f4                	je     80101a <strtol+0x16>
  801026:	8b 45 08             	mov    0x8(%ebp),%eax
  801029:	8a 00                	mov    (%eax),%al
  80102b:	3c 09                	cmp    $0x9,%al
  80102d:	74 eb                	je     80101a <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80102f:	8b 45 08             	mov    0x8(%ebp),%eax
  801032:	8a 00                	mov    (%eax),%al
  801034:	3c 2b                	cmp    $0x2b,%al
  801036:	75 05                	jne    80103d <strtol+0x39>
		s++;
  801038:	ff 45 08             	incl   0x8(%ebp)
  80103b:	eb 13                	jmp    801050 <strtol+0x4c>
	else if (*s == '-')
  80103d:	8b 45 08             	mov    0x8(%ebp),%eax
  801040:	8a 00                	mov    (%eax),%al
  801042:	3c 2d                	cmp    $0x2d,%al
  801044:	75 0a                	jne    801050 <strtol+0x4c>
		s++, neg = 1;
  801046:	ff 45 08             	incl   0x8(%ebp)
  801049:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801050:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801054:	74 06                	je     80105c <strtol+0x58>
  801056:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80105a:	75 20                	jne    80107c <strtol+0x78>
  80105c:	8b 45 08             	mov    0x8(%ebp),%eax
  80105f:	8a 00                	mov    (%eax),%al
  801061:	3c 30                	cmp    $0x30,%al
  801063:	75 17                	jne    80107c <strtol+0x78>
  801065:	8b 45 08             	mov    0x8(%ebp),%eax
  801068:	40                   	inc    %eax
  801069:	8a 00                	mov    (%eax),%al
  80106b:	3c 78                	cmp    $0x78,%al
  80106d:	75 0d                	jne    80107c <strtol+0x78>
		s += 2, base = 16;
  80106f:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801073:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80107a:	eb 28                	jmp    8010a4 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80107c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801080:	75 15                	jne    801097 <strtol+0x93>
  801082:	8b 45 08             	mov    0x8(%ebp),%eax
  801085:	8a 00                	mov    (%eax),%al
  801087:	3c 30                	cmp    $0x30,%al
  801089:	75 0c                	jne    801097 <strtol+0x93>
		s++, base = 8;
  80108b:	ff 45 08             	incl   0x8(%ebp)
  80108e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801095:	eb 0d                	jmp    8010a4 <strtol+0xa0>
	else if (base == 0)
  801097:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80109b:	75 07                	jne    8010a4 <strtol+0xa0>
		base = 10;
  80109d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8010a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a7:	8a 00                	mov    (%eax),%al
  8010a9:	3c 2f                	cmp    $0x2f,%al
  8010ab:	7e 19                	jle    8010c6 <strtol+0xc2>
  8010ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b0:	8a 00                	mov    (%eax),%al
  8010b2:	3c 39                	cmp    $0x39,%al
  8010b4:	7f 10                	jg     8010c6 <strtol+0xc2>
			dig = *s - '0';
  8010b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b9:	8a 00                	mov    (%eax),%al
  8010bb:	0f be c0             	movsbl %al,%eax
  8010be:	83 e8 30             	sub    $0x30,%eax
  8010c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010c4:	eb 42                	jmp    801108 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8010c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c9:	8a 00                	mov    (%eax),%al
  8010cb:	3c 60                	cmp    $0x60,%al
  8010cd:	7e 19                	jle    8010e8 <strtol+0xe4>
  8010cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d2:	8a 00                	mov    (%eax),%al
  8010d4:	3c 7a                	cmp    $0x7a,%al
  8010d6:	7f 10                	jg     8010e8 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8010d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010db:	8a 00                	mov    (%eax),%al
  8010dd:	0f be c0             	movsbl %al,%eax
  8010e0:	83 e8 57             	sub    $0x57,%eax
  8010e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010e6:	eb 20                	jmp    801108 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8010e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010eb:	8a 00                	mov    (%eax),%al
  8010ed:	3c 40                	cmp    $0x40,%al
  8010ef:	7e 39                	jle    80112a <strtol+0x126>
  8010f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f4:	8a 00                	mov    (%eax),%al
  8010f6:	3c 5a                	cmp    $0x5a,%al
  8010f8:	7f 30                	jg     80112a <strtol+0x126>
			dig = *s - 'A' + 10;
  8010fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fd:	8a 00                	mov    (%eax),%al
  8010ff:	0f be c0             	movsbl %al,%eax
  801102:	83 e8 37             	sub    $0x37,%eax
  801105:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801108:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80110b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80110e:	7d 19                	jge    801129 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801110:	ff 45 08             	incl   0x8(%ebp)
  801113:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801116:	0f af 45 10          	imul   0x10(%ebp),%eax
  80111a:	89 c2                	mov    %eax,%edx
  80111c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80111f:	01 d0                	add    %edx,%eax
  801121:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801124:	e9 7b ff ff ff       	jmp    8010a4 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801129:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80112a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80112e:	74 08                	je     801138 <strtol+0x134>
		*endptr = (char *) s;
  801130:	8b 45 0c             	mov    0xc(%ebp),%eax
  801133:	8b 55 08             	mov    0x8(%ebp),%edx
  801136:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801138:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80113c:	74 07                	je     801145 <strtol+0x141>
  80113e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801141:	f7 d8                	neg    %eax
  801143:	eb 03                	jmp    801148 <strtol+0x144>
  801145:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801148:	c9                   	leave  
  801149:	c3                   	ret    

0080114a <ltostr>:

void
ltostr(long value, char *str)
{
  80114a:	55                   	push   %ebp
  80114b:	89 e5                	mov    %esp,%ebp
  80114d:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801150:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801157:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80115e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801162:	79 13                	jns    801177 <ltostr+0x2d>
	{
		neg = 1;
  801164:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80116b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116e:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801171:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801174:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801177:	8b 45 08             	mov    0x8(%ebp),%eax
  80117a:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80117f:	99                   	cltd   
  801180:	f7 f9                	idiv   %ecx
  801182:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801185:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801188:	8d 50 01             	lea    0x1(%eax),%edx
  80118b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80118e:	89 c2                	mov    %eax,%edx
  801190:	8b 45 0c             	mov    0xc(%ebp),%eax
  801193:	01 d0                	add    %edx,%eax
  801195:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801198:	83 c2 30             	add    $0x30,%edx
  80119b:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80119d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011a0:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011a5:	f7 e9                	imul   %ecx
  8011a7:	c1 fa 02             	sar    $0x2,%edx
  8011aa:	89 c8                	mov    %ecx,%eax
  8011ac:	c1 f8 1f             	sar    $0x1f,%eax
  8011af:	29 c2                	sub    %eax,%edx
  8011b1:	89 d0                	mov    %edx,%eax
  8011b3:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8011b6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011b9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011be:	f7 e9                	imul   %ecx
  8011c0:	c1 fa 02             	sar    $0x2,%edx
  8011c3:	89 c8                	mov    %ecx,%eax
  8011c5:	c1 f8 1f             	sar    $0x1f,%eax
  8011c8:	29 c2                	sub    %eax,%edx
  8011ca:	89 d0                	mov    %edx,%eax
  8011cc:	c1 e0 02             	shl    $0x2,%eax
  8011cf:	01 d0                	add    %edx,%eax
  8011d1:	01 c0                	add    %eax,%eax
  8011d3:	29 c1                	sub    %eax,%ecx
  8011d5:	89 ca                	mov    %ecx,%edx
  8011d7:	85 d2                	test   %edx,%edx
  8011d9:	75 9c                	jne    801177 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8011db:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8011e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011e5:	48                   	dec    %eax
  8011e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8011e9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011ed:	74 3d                	je     80122c <ltostr+0xe2>
		start = 1 ;
  8011ef:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8011f6:	eb 34                	jmp    80122c <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8011f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fe:	01 d0                	add    %edx,%eax
  801200:	8a 00                	mov    (%eax),%al
  801202:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801205:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801208:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120b:	01 c2                	add    %eax,%edx
  80120d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801210:	8b 45 0c             	mov    0xc(%ebp),%eax
  801213:	01 c8                	add    %ecx,%eax
  801215:	8a 00                	mov    (%eax),%al
  801217:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801219:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80121c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121f:	01 c2                	add    %eax,%edx
  801221:	8a 45 eb             	mov    -0x15(%ebp),%al
  801224:	88 02                	mov    %al,(%edx)
		start++ ;
  801226:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801229:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80122c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80122f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801232:	7c c4                	jl     8011f8 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801234:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801237:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123a:	01 d0                	add    %edx,%eax
  80123c:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80123f:	90                   	nop
  801240:	c9                   	leave  
  801241:	c3                   	ret    

00801242 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801242:	55                   	push   %ebp
  801243:	89 e5                	mov    %esp,%ebp
  801245:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801248:	ff 75 08             	pushl  0x8(%ebp)
  80124b:	e8 54 fa ff ff       	call   800ca4 <strlen>
  801250:	83 c4 04             	add    $0x4,%esp
  801253:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801256:	ff 75 0c             	pushl  0xc(%ebp)
  801259:	e8 46 fa ff ff       	call   800ca4 <strlen>
  80125e:	83 c4 04             	add    $0x4,%esp
  801261:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801264:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80126b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801272:	eb 17                	jmp    80128b <strcconcat+0x49>
		final[s] = str1[s] ;
  801274:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801277:	8b 45 10             	mov    0x10(%ebp),%eax
  80127a:	01 c2                	add    %eax,%edx
  80127c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80127f:	8b 45 08             	mov    0x8(%ebp),%eax
  801282:	01 c8                	add    %ecx,%eax
  801284:	8a 00                	mov    (%eax),%al
  801286:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801288:	ff 45 fc             	incl   -0x4(%ebp)
  80128b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80128e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801291:	7c e1                	jl     801274 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801293:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80129a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8012a1:	eb 1f                	jmp    8012c2 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8012a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012a6:	8d 50 01             	lea    0x1(%eax),%edx
  8012a9:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012ac:	89 c2                	mov    %eax,%edx
  8012ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b1:	01 c2                	add    %eax,%edx
  8012b3:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b9:	01 c8                	add    %ecx,%eax
  8012bb:	8a 00                	mov    (%eax),%al
  8012bd:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8012bf:	ff 45 f8             	incl   -0x8(%ebp)
  8012c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012c5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012c8:	7c d9                	jl     8012a3 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8012ca:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d0:	01 d0                	add    %edx,%eax
  8012d2:	c6 00 00             	movb   $0x0,(%eax)
}
  8012d5:	90                   	nop
  8012d6:	c9                   	leave  
  8012d7:	c3                   	ret    

008012d8 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8012d8:	55                   	push   %ebp
  8012d9:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8012db:	8b 45 14             	mov    0x14(%ebp),%eax
  8012de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8012e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8012e7:	8b 00                	mov    (%eax),%eax
  8012e9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f3:	01 d0                	add    %edx,%eax
  8012f5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012fb:	eb 0c                	jmp    801309 <strsplit+0x31>
			*string++ = 0;
  8012fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801300:	8d 50 01             	lea    0x1(%eax),%edx
  801303:	89 55 08             	mov    %edx,0x8(%ebp)
  801306:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801309:	8b 45 08             	mov    0x8(%ebp),%eax
  80130c:	8a 00                	mov    (%eax),%al
  80130e:	84 c0                	test   %al,%al
  801310:	74 18                	je     80132a <strsplit+0x52>
  801312:	8b 45 08             	mov    0x8(%ebp),%eax
  801315:	8a 00                	mov    (%eax),%al
  801317:	0f be c0             	movsbl %al,%eax
  80131a:	50                   	push   %eax
  80131b:	ff 75 0c             	pushl  0xc(%ebp)
  80131e:	e8 13 fb ff ff       	call   800e36 <strchr>
  801323:	83 c4 08             	add    $0x8,%esp
  801326:	85 c0                	test   %eax,%eax
  801328:	75 d3                	jne    8012fd <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80132a:	8b 45 08             	mov    0x8(%ebp),%eax
  80132d:	8a 00                	mov    (%eax),%al
  80132f:	84 c0                	test   %al,%al
  801331:	74 5a                	je     80138d <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801333:	8b 45 14             	mov    0x14(%ebp),%eax
  801336:	8b 00                	mov    (%eax),%eax
  801338:	83 f8 0f             	cmp    $0xf,%eax
  80133b:	75 07                	jne    801344 <strsplit+0x6c>
		{
			return 0;
  80133d:	b8 00 00 00 00       	mov    $0x0,%eax
  801342:	eb 66                	jmp    8013aa <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801344:	8b 45 14             	mov    0x14(%ebp),%eax
  801347:	8b 00                	mov    (%eax),%eax
  801349:	8d 48 01             	lea    0x1(%eax),%ecx
  80134c:	8b 55 14             	mov    0x14(%ebp),%edx
  80134f:	89 0a                	mov    %ecx,(%edx)
  801351:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801358:	8b 45 10             	mov    0x10(%ebp),%eax
  80135b:	01 c2                	add    %eax,%edx
  80135d:	8b 45 08             	mov    0x8(%ebp),%eax
  801360:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801362:	eb 03                	jmp    801367 <strsplit+0x8f>
			string++;
  801364:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801367:	8b 45 08             	mov    0x8(%ebp),%eax
  80136a:	8a 00                	mov    (%eax),%al
  80136c:	84 c0                	test   %al,%al
  80136e:	74 8b                	je     8012fb <strsplit+0x23>
  801370:	8b 45 08             	mov    0x8(%ebp),%eax
  801373:	8a 00                	mov    (%eax),%al
  801375:	0f be c0             	movsbl %al,%eax
  801378:	50                   	push   %eax
  801379:	ff 75 0c             	pushl  0xc(%ebp)
  80137c:	e8 b5 fa ff ff       	call   800e36 <strchr>
  801381:	83 c4 08             	add    $0x8,%esp
  801384:	85 c0                	test   %eax,%eax
  801386:	74 dc                	je     801364 <strsplit+0x8c>
			string++;
	}
  801388:	e9 6e ff ff ff       	jmp    8012fb <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80138d:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80138e:	8b 45 14             	mov    0x14(%ebp),%eax
  801391:	8b 00                	mov    (%eax),%eax
  801393:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80139a:	8b 45 10             	mov    0x10(%ebp),%eax
  80139d:	01 d0                	add    %edx,%eax
  80139f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8013a5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013aa:	c9                   	leave  
  8013ab:	c3                   	ret    

008013ac <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8013ac:	55                   	push   %ebp
  8013ad:	89 e5                	mov    %esp,%ebp
  8013af:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8013b2:	a1 04 40 80 00       	mov    0x804004,%eax
  8013b7:	85 c0                	test   %eax,%eax
  8013b9:	74 1f                	je     8013da <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8013bb:	e8 1d 00 00 00       	call   8013dd <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8013c0:	83 ec 0c             	sub    $0xc,%esp
  8013c3:	68 70 3b 80 00       	push   $0x803b70
  8013c8:	e8 55 f2 ff ff       	call   800622 <cprintf>
  8013cd:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8013d0:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8013d7:	00 00 00 
	}
}
  8013da:	90                   	nop
  8013db:	c9                   	leave  
  8013dc:	c3                   	ret    

008013dd <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8013dd:	55                   	push   %ebp
  8013de:	89 e5                	mov    %esp,%ebp
  8013e0:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");
LIST_INIT(&AllocMemBlocksList);
  8013e3:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  8013ea:	00 00 00 
  8013ed:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  8013f4:	00 00 00 
  8013f7:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  8013fe:	00 00 00 
LIST_INIT(&FreeMemBlocksList);
  801401:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801408:	00 00 00 
  80140b:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801412:	00 00 00 
  801415:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  80141c:	00 00 00 
MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  80141f:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801426:	00 02 00 
uint32 requiredSpace=sizeof(struct MemBlock)*NUM_OF_UHEAP_PAGES;
  801429:	c7 45 f4 00 00 20 00 	movl   $0x200000,-0xc(%ebp)
		MemBlockNodes=(struct MemBlock*)USER_DYN_BLKS_ARRAY;
  801430:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801437:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80143a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80143f:	2d 00 10 00 00       	sub    $0x1000,%eax
  801444:	a3 50 40 80 00       	mov    %eax,0x804050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,requiredSpace,PERM_WRITEABLE|PERM_USER);
  801449:	c7 45 ec 00 00 e0 7f 	movl   $0x7fe00000,-0x14(%ebp)
  801450:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801453:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801458:	2d 00 10 00 00       	sub    $0x1000,%eax
  80145d:	83 ec 04             	sub    $0x4,%esp
  801460:	6a 06                	push   $0x6
  801462:	ff 75 f4             	pushl  -0xc(%ebp)
  801465:	50                   	push   %eax
  801466:	e8 ee 05 00 00       	call   801a59 <sys_allocate_chunk>
  80146b:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  80146e:	a1 20 41 80 00       	mov    0x804120,%eax
  801473:	83 ec 0c             	sub    $0xc,%esp
  801476:	50                   	push   %eax
  801477:	e8 63 0c 00 00       	call   8020df <initialize_MemBlocksList>
  80147c:	83 c4 10             	add    $0x10,%esp
			struct MemBlock *freeSva=AvailableMemBlocksList.lh_last;
  80147f:	a1 4c 41 80 00       	mov    0x80414c,%eax
  801484:	89 45 e8             	mov    %eax,-0x18(%ebp)
			freeSva->size=USER_HEAP_MAX-USER_HEAP_START;
  801487:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80148a:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
			freeSva->size=ROUNDDOWN(freeSva->size,PAGE_SIZE);
  801491:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801494:	8b 40 0c             	mov    0xc(%eax),%eax
  801497:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80149a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80149d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014a2:	89 c2                	mov    %eax,%edx
  8014a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014a7:	89 50 0c             	mov    %edx,0xc(%eax)

			freeSva->sva=USER_HEAP_START;
  8014aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014ad:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
			freeSva->sva=ROUNDUP(freeSva->sva,PAGE_SIZE);
  8014b4:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8014bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014be:	8b 50 08             	mov    0x8(%eax),%edx
  8014c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014c4:	01 d0                	add    %edx,%eax
  8014c6:	48                   	dec    %eax
  8014c7:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8014ca:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8014d2:	f7 75 e0             	divl   -0x20(%ebp)
  8014d5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014d8:	29 d0                	sub    %edx,%eax
  8014da:	89 c2                	mov    %eax,%edx
  8014dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014df:	89 50 08             	mov    %edx,0x8(%eax)




			LIST_REMOVE(&AvailableMemBlocksList,freeSva);
  8014e2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8014e6:	75 14                	jne    8014fc <initialize_dyn_block_system+0x11f>
  8014e8:	83 ec 04             	sub    $0x4,%esp
  8014eb:	68 95 3b 80 00       	push   $0x803b95
  8014f0:	6a 34                	push   $0x34
  8014f2:	68 b3 3b 80 00       	push   $0x803bb3
  8014f7:	e8 47 1c 00 00       	call   803143 <_panic>
  8014fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014ff:	8b 00                	mov    (%eax),%eax
  801501:	85 c0                	test   %eax,%eax
  801503:	74 10                	je     801515 <initialize_dyn_block_system+0x138>
  801505:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801508:	8b 00                	mov    (%eax),%eax
  80150a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80150d:	8b 52 04             	mov    0x4(%edx),%edx
  801510:	89 50 04             	mov    %edx,0x4(%eax)
  801513:	eb 0b                	jmp    801520 <initialize_dyn_block_system+0x143>
  801515:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801518:	8b 40 04             	mov    0x4(%eax),%eax
  80151b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801520:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801523:	8b 40 04             	mov    0x4(%eax),%eax
  801526:	85 c0                	test   %eax,%eax
  801528:	74 0f                	je     801539 <initialize_dyn_block_system+0x15c>
  80152a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80152d:	8b 40 04             	mov    0x4(%eax),%eax
  801530:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801533:	8b 12                	mov    (%edx),%edx
  801535:	89 10                	mov    %edx,(%eax)
  801537:	eb 0a                	jmp    801543 <initialize_dyn_block_system+0x166>
  801539:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80153c:	8b 00                	mov    (%eax),%eax
  80153e:	a3 48 41 80 00       	mov    %eax,0x804148
  801543:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801546:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80154c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80154f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801556:	a1 54 41 80 00       	mov    0x804154,%eax
  80155b:	48                   	dec    %eax
  80155c:	a3 54 41 80 00       	mov    %eax,0x804154
			insert_sorted_with_merge_freeList(freeSva);
  801561:	83 ec 0c             	sub    $0xc,%esp
  801564:	ff 75 e8             	pushl  -0x18(%ebp)
  801567:	e8 c4 13 00 00       	call   802930 <insert_sorted_with_merge_freeList>
  80156c:	83 c4 10             	add    $0x10,%esp
//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  80156f:	90                   	nop
  801570:	c9                   	leave  
  801571:	c3                   	ret    

00801572 <malloc>:
//=================================



void* malloc(uint32 size)
{
  801572:	55                   	push   %ebp
  801573:	89 e5                	mov    %esp,%ebp
  801575:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801578:	e8 2f fe ff ff       	call   8013ac <InitializeUHeap>
	if (size == 0) return NULL ;
  80157d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801581:	75 07                	jne    80158a <malloc+0x18>
  801583:	b8 00 00 00 00       	mov    $0x0,%eax
  801588:	eb 71                	jmp    8015fb <malloc+0x89>
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");
if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  80158a:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801591:	76 07                	jbe    80159a <malloc+0x28>
	return NULL;
  801593:	b8 00 00 00 00       	mov    $0x0,%eax
  801598:	eb 61                	jmp    8015fb <malloc+0x89>

	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80159a:	e8 88 08 00 00       	call   801e27 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80159f:	85 c0                	test   %eax,%eax
  8015a1:	74 53                	je     8015f6 <malloc+0x84>
	        {
		struct MemBlock *returned_block;
		uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  8015a3:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8015aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8015ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015b0:	01 d0                	add    %edx,%eax
  8015b2:	48                   	dec    %eax
  8015b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8015be:	f7 75 f4             	divl   -0xc(%ebp)
  8015c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015c4:	29 d0                	sub    %edx,%eax
  8015c6:	89 45 ec             	mov    %eax,-0x14(%ebp)
   returned_block=alloc_block_FF(newSize);
  8015c9:	83 ec 0c             	sub    $0xc,%esp
  8015cc:	ff 75 ec             	pushl  -0x14(%ebp)
  8015cf:	e8 d2 0d 00 00       	call   8023a6 <alloc_block_FF>
  8015d4:	83 c4 10             	add    $0x10,%esp
  8015d7:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(returned_block!=NULL)
  8015da:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8015de:	74 16                	je     8015f6 <malloc+0x84>
    {
    	insert_sorted_allocList(returned_block);
  8015e0:	83 ec 0c             	sub    $0xc,%esp
  8015e3:	ff 75 e8             	pushl  -0x18(%ebp)
  8015e6:	e8 0c 0c 00 00       	call   8021f7 <insert_sorted_allocList>
  8015eb:	83 c4 10             	add    $0x10,%esp
	return(void*) returned_block->sva;
  8015ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015f1:	8b 40 08             	mov    0x8(%eax),%eax
  8015f4:	eb 05                	jmp    8015fb <malloc+0x89>
    }

			}


	return NULL;
  8015f6:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  8015fb:	c9                   	leave  
  8015fc:	c3                   	ret    

008015fd <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8015fd:	55                   	push   %ebp
  8015fe:	89 e5                	mov    %esp,%ebp
  801600:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//you should get the size of the given allocation using its address
	uint32 va=ROUNDDOWN((uint32)virtual_address,PAGE_SIZE);
  801603:	8b 45 08             	mov    0x8(%ebp),%eax
  801606:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801609:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80160c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801611:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *returned_block=find_block(&AllocMemBlocksList,va);
  801614:	83 ec 08             	sub    $0x8,%esp
  801617:	ff 75 f0             	pushl  -0x10(%ebp)
  80161a:	68 40 40 80 00       	push   $0x804040
  80161f:	e8 a0 0b 00 00       	call   8021c4 <find_block>
  801624:	83 c4 10             	add    $0x10,%esp
  801627:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_free_user_mem((uint32)virtual_address,returned_block->size);
  80162a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80162d:	8b 50 0c             	mov    0xc(%eax),%edx
  801630:	8b 45 08             	mov    0x8(%ebp),%eax
  801633:	83 ec 08             	sub    $0x8,%esp
  801636:	52                   	push   %edx
  801637:	50                   	push   %eax
  801638:	e8 e4 03 00 00       	call   801a21 <sys_free_user_mem>
  80163d:	83 c4 10             	add    $0x10,%esp

    LIST_REMOVE(&AllocMemBlocksList,returned_block);
  801640:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801644:	75 17                	jne    80165d <free+0x60>
  801646:	83 ec 04             	sub    $0x4,%esp
  801649:	68 95 3b 80 00       	push   $0x803b95
  80164e:	68 84 00 00 00       	push   $0x84
  801653:	68 b3 3b 80 00       	push   $0x803bb3
  801658:	e8 e6 1a 00 00       	call   803143 <_panic>
  80165d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801660:	8b 00                	mov    (%eax),%eax
  801662:	85 c0                	test   %eax,%eax
  801664:	74 10                	je     801676 <free+0x79>
  801666:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801669:	8b 00                	mov    (%eax),%eax
  80166b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80166e:	8b 52 04             	mov    0x4(%edx),%edx
  801671:	89 50 04             	mov    %edx,0x4(%eax)
  801674:	eb 0b                	jmp    801681 <free+0x84>
  801676:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801679:	8b 40 04             	mov    0x4(%eax),%eax
  80167c:	a3 44 40 80 00       	mov    %eax,0x804044
  801681:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801684:	8b 40 04             	mov    0x4(%eax),%eax
  801687:	85 c0                	test   %eax,%eax
  801689:	74 0f                	je     80169a <free+0x9d>
  80168b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80168e:	8b 40 04             	mov    0x4(%eax),%eax
  801691:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801694:	8b 12                	mov    (%edx),%edx
  801696:	89 10                	mov    %edx,(%eax)
  801698:	eb 0a                	jmp    8016a4 <free+0xa7>
  80169a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80169d:	8b 00                	mov    (%eax),%eax
  80169f:	a3 40 40 80 00       	mov    %eax,0x804040
  8016a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016a7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8016ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016b0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8016b7:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8016bc:	48                   	dec    %eax
  8016bd:	a3 4c 40 80 00       	mov    %eax,0x80404c
	insert_sorted_with_merge_freeList(returned_block);
  8016c2:	83 ec 0c             	sub    $0xc,%esp
  8016c5:	ff 75 ec             	pushl  -0x14(%ebp)
  8016c8:	e8 63 12 00 00       	call   802930 <insert_sorted_with_merge_freeList>
  8016cd:	83 c4 10             	add    $0x10,%esp

	//you need to call sys_free_user_mem()
}
  8016d0:	90                   	nop
  8016d1:	c9                   	leave  
  8016d2:	c3                   	ret    

008016d3 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8016d3:	55                   	push   %ebp
  8016d4:	89 e5                	mov    %esp,%ebp
  8016d6:	83 ec 38             	sub    $0x38,%esp
  8016d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8016dc:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016df:	e8 c8 fc ff ff       	call   8013ac <InitializeUHeap>
	if (size == 0) return NULL ;
  8016e4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016e8:	75 0a                	jne    8016f4 <smalloc+0x21>
  8016ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8016ef:	e9 a0 00 00 00       	jmp    801794 <smalloc+0xc1>
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	// Steps:
	//	1) Implement FIRST FIT strategy to search the heap for suitable space
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  8016f4:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  8016fb:	76 0a                	jbe    801707 <smalloc+0x34>
		return NULL;
  8016fd:	b8 00 00 00 00       	mov    $0x0,%eax
  801702:	e9 8d 00 00 00       	jmp    801794 <smalloc+0xc1>

		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801707:	e8 1b 07 00 00       	call   801e27 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80170c:	85 c0                	test   %eax,%eax
  80170e:	74 7f                	je     80178f <smalloc+0xbc>
		        {
			struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801710:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801717:	8b 55 0c             	mov    0xc(%ebp),%edx
  80171a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80171d:	01 d0                	add    %edx,%eax
  80171f:	48                   	dec    %eax
  801720:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801723:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801726:	ba 00 00 00 00       	mov    $0x0,%edx
  80172b:	f7 75 f4             	divl   -0xc(%ebp)
  80172e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801731:	29 d0                	sub    %edx,%eax
  801733:	89 45 ec             	mov    %eax,-0x14(%ebp)
	   returned_block=alloc_block_FF(newSize);
  801736:	83 ec 0c             	sub    $0xc,%esp
  801739:	ff 75 ec             	pushl  -0x14(%ebp)
  80173c:	e8 65 0c 00 00       	call   8023a6 <alloc_block_FF>
  801741:	83 c4 10             	add    $0x10,%esp
  801744:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   if(returned_block!=NULL)
  801747:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80174b:	74 42                	je     80178f <smalloc+0xbc>
	      {
	      	   insert_sorted_allocList(returned_block);
  80174d:	83 ec 0c             	sub    $0xc,%esp
  801750:	ff 75 e8             	pushl  -0x18(%ebp)
  801753:	e8 9f 0a 00 00       	call   8021f7 <insert_sorted_allocList>
  801758:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_createSharedObject(sharedVarName,size,isWritable,(void*)returned_block->sva);
  80175b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80175e:	8b 40 08             	mov    0x8(%eax),%eax
  801761:	89 c2                	mov    %eax,%edx
  801763:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801767:	52                   	push   %edx
  801768:	50                   	push   %eax
  801769:	ff 75 0c             	pushl  0xc(%ebp)
  80176c:	ff 75 08             	pushl  0x8(%ebp)
  80176f:	e8 38 04 00 00       	call   801bac <sys_createSharedObject>
  801774:	83 c4 10             	add    $0x10,%esp
  801777:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    	     if(ID<0)
  80177a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80177e:	79 07                	jns    801787 <smalloc+0xb4>
	    		  return NULL;
  801780:	b8 00 00 00 00       	mov    $0x0,%eax
  801785:	eb 0d                	jmp    801794 <smalloc+0xc1>
	  	return(void*) returned_block->sva;
  801787:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80178a:	8b 40 08             	mov    0x8(%eax),%eax
  80178d:	eb 05                	jmp    801794 <smalloc+0xc1>


				}


		return NULL;
  80178f:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801794:	c9                   	leave  
  801795:	c3                   	ret    

00801796 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801796:	55                   	push   %ebp
  801797:	89 e5                	mov    %esp,%ebp
  801799:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80179c:	e8 0b fc ff ff       	call   8013ac <InitializeUHeap>
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	// Steps:
	//	1) Get the size of the shared variable (use sys_getSizeOfSharedObject())
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  8017a1:	e8 81 06 00 00       	call   801e27 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8017a6:	85 c0                	test   %eax,%eax
  8017a8:	0f 84 9f 00 00 00    	je     80184d <sget+0xb7>
	int size=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8017ae:	83 ec 08             	sub    $0x8,%esp
  8017b1:	ff 75 0c             	pushl  0xc(%ebp)
  8017b4:	ff 75 08             	pushl  0x8(%ebp)
  8017b7:	e8 1a 04 00 00       	call   801bd6 <sys_getSizeOfSharedObject>
  8017bc:	83 c4 10             	add    $0x10,%esp
  8017bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size<0)
  8017c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8017c6:	79 0a                	jns    8017d2 <sget+0x3c>
		return NULL;
  8017c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8017cd:	e9 80 00 00 00       	jmp    801852 <sget+0xbc>
	struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  8017d2:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8017d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017df:	01 d0                	add    %edx,%eax
  8017e1:	48                   	dec    %eax
  8017e2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8017e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8017ed:	f7 75 f0             	divl   -0x10(%ebp)
  8017f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017f3:	29 d0                	sub    %edx,%eax
  8017f5:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   returned_block=alloc_block_FF(newSize);
  8017f8:	83 ec 0c             	sub    $0xc,%esp
  8017fb:	ff 75 e8             	pushl  -0x18(%ebp)
  8017fe:	e8 a3 0b 00 00       	call   8023a6 <alloc_block_FF>
  801803:	83 c4 10             	add    $0x10,%esp
  801806:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	   if(returned_block!=NULL)
  801809:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80180d:	74 3e                	je     80184d <sget+0xb7>
	      {
	      	   insert_sorted_allocList(returned_block);
  80180f:	83 ec 0c             	sub    $0xc,%esp
  801812:	ff 75 e4             	pushl  -0x1c(%ebp)
  801815:	e8 dd 09 00 00       	call   8021f7 <insert_sorted_allocList>
  80181a:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)returned_block->sva);
  80181d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801820:	8b 40 08             	mov    0x8(%eax),%eax
  801823:	83 ec 04             	sub    $0x4,%esp
  801826:	50                   	push   %eax
  801827:	ff 75 0c             	pushl  0xc(%ebp)
  80182a:	ff 75 08             	pushl  0x8(%ebp)
  80182d:	e8 c1 03 00 00       	call   801bf3 <sys_getSharedObject>
  801832:	83 c4 10             	add    $0x10,%esp
  801835:	89 45 e0             	mov    %eax,-0x20(%ebp)
	    	     if(ID<0)
  801838:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80183c:	79 07                	jns    801845 <sget+0xaf>
	    		  return NULL;
  80183e:	b8 00 00 00 00       	mov    $0x0,%eax
  801843:	eb 0d                	jmp    801852 <sget+0xbc>
	  	return(void*) returned_block->sva;
  801845:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801848:	8b 40 08             	mov    0x8(%eax),%eax
  80184b:	eb 05                	jmp    801852 <sget+0xbc>
	      }
	}
	   return NULL;
  80184d:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801852:	c9                   	leave  
  801853:	c3                   	ret    

00801854 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801854:	55                   	push   %ebp
  801855:	89 e5                	mov    %esp,%ebp
  801857:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80185a:	e8 4d fb ff ff       	call   8013ac <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80185f:	83 ec 04             	sub    $0x4,%esp
  801862:	68 c0 3b 80 00       	push   $0x803bc0
  801867:	68 12 01 00 00       	push   $0x112
  80186c:	68 b3 3b 80 00       	push   $0x803bb3
  801871:	e8 cd 18 00 00       	call   803143 <_panic>

00801876 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801876:	55                   	push   %ebp
  801877:	89 e5                	mov    %esp,%ebp
  801879:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80187c:	83 ec 04             	sub    $0x4,%esp
  80187f:	68 e8 3b 80 00       	push   $0x803be8
  801884:	68 26 01 00 00       	push   $0x126
  801889:	68 b3 3b 80 00       	push   $0x803bb3
  80188e:	e8 b0 18 00 00       	call   803143 <_panic>

00801893 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801893:	55                   	push   %ebp
  801894:	89 e5                	mov    %esp,%ebp
  801896:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801899:	83 ec 04             	sub    $0x4,%esp
  80189c:	68 0c 3c 80 00       	push   $0x803c0c
  8018a1:	68 31 01 00 00       	push   $0x131
  8018a6:	68 b3 3b 80 00       	push   $0x803bb3
  8018ab:	e8 93 18 00 00       	call   803143 <_panic>

008018b0 <shrink>:

}
void shrink(uint32 newSize)
{
  8018b0:	55                   	push   %ebp
  8018b1:	89 e5                	mov    %esp,%ebp
  8018b3:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018b6:	83 ec 04             	sub    $0x4,%esp
  8018b9:	68 0c 3c 80 00       	push   $0x803c0c
  8018be:	68 36 01 00 00       	push   $0x136
  8018c3:	68 b3 3b 80 00       	push   $0x803bb3
  8018c8:	e8 76 18 00 00       	call   803143 <_panic>

008018cd <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8018cd:	55                   	push   %ebp
  8018ce:	89 e5                	mov    %esp,%ebp
  8018d0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018d3:	83 ec 04             	sub    $0x4,%esp
  8018d6:	68 0c 3c 80 00       	push   $0x803c0c
  8018db:	68 3b 01 00 00       	push   $0x13b
  8018e0:	68 b3 3b 80 00       	push   $0x803bb3
  8018e5:	e8 59 18 00 00       	call   803143 <_panic>

008018ea <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8018ea:	55                   	push   %ebp
  8018eb:	89 e5                	mov    %esp,%ebp
  8018ed:	57                   	push   %edi
  8018ee:	56                   	push   %esi
  8018ef:	53                   	push   %ebx
  8018f0:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018f9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018fc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018ff:	8b 7d 18             	mov    0x18(%ebp),%edi
  801902:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801905:	cd 30                	int    $0x30
  801907:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80190a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80190d:	83 c4 10             	add    $0x10,%esp
  801910:	5b                   	pop    %ebx
  801911:	5e                   	pop    %esi
  801912:	5f                   	pop    %edi
  801913:	5d                   	pop    %ebp
  801914:	c3                   	ret    

00801915 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801915:	55                   	push   %ebp
  801916:	89 e5                	mov    %esp,%ebp
  801918:	83 ec 04             	sub    $0x4,%esp
  80191b:	8b 45 10             	mov    0x10(%ebp),%eax
  80191e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801921:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801925:	8b 45 08             	mov    0x8(%ebp),%eax
  801928:	6a 00                	push   $0x0
  80192a:	6a 00                	push   $0x0
  80192c:	52                   	push   %edx
  80192d:	ff 75 0c             	pushl  0xc(%ebp)
  801930:	50                   	push   %eax
  801931:	6a 00                	push   $0x0
  801933:	e8 b2 ff ff ff       	call   8018ea <syscall>
  801938:	83 c4 18             	add    $0x18,%esp
}
  80193b:	90                   	nop
  80193c:	c9                   	leave  
  80193d:	c3                   	ret    

0080193e <sys_cgetc>:

int
sys_cgetc(void)
{
  80193e:	55                   	push   %ebp
  80193f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801941:	6a 00                	push   $0x0
  801943:	6a 00                	push   $0x0
  801945:	6a 00                	push   $0x0
  801947:	6a 00                	push   $0x0
  801949:	6a 00                	push   $0x0
  80194b:	6a 01                	push   $0x1
  80194d:	e8 98 ff ff ff       	call   8018ea <syscall>
  801952:	83 c4 18             	add    $0x18,%esp
}
  801955:	c9                   	leave  
  801956:	c3                   	ret    

00801957 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801957:	55                   	push   %ebp
  801958:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80195a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80195d:	8b 45 08             	mov    0x8(%ebp),%eax
  801960:	6a 00                	push   $0x0
  801962:	6a 00                	push   $0x0
  801964:	6a 00                	push   $0x0
  801966:	52                   	push   %edx
  801967:	50                   	push   %eax
  801968:	6a 05                	push   $0x5
  80196a:	e8 7b ff ff ff       	call   8018ea <syscall>
  80196f:	83 c4 18             	add    $0x18,%esp
}
  801972:	c9                   	leave  
  801973:	c3                   	ret    

00801974 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801974:	55                   	push   %ebp
  801975:	89 e5                	mov    %esp,%ebp
  801977:	56                   	push   %esi
  801978:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801979:	8b 75 18             	mov    0x18(%ebp),%esi
  80197c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80197f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801982:	8b 55 0c             	mov    0xc(%ebp),%edx
  801985:	8b 45 08             	mov    0x8(%ebp),%eax
  801988:	56                   	push   %esi
  801989:	53                   	push   %ebx
  80198a:	51                   	push   %ecx
  80198b:	52                   	push   %edx
  80198c:	50                   	push   %eax
  80198d:	6a 06                	push   $0x6
  80198f:	e8 56 ff ff ff       	call   8018ea <syscall>
  801994:	83 c4 18             	add    $0x18,%esp
}
  801997:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80199a:	5b                   	pop    %ebx
  80199b:	5e                   	pop    %esi
  80199c:	5d                   	pop    %ebp
  80199d:	c3                   	ret    

0080199e <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80199e:	55                   	push   %ebp
  80199f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8019a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 00                	push   $0x0
  8019ab:	6a 00                	push   $0x0
  8019ad:	52                   	push   %edx
  8019ae:	50                   	push   %eax
  8019af:	6a 07                	push   $0x7
  8019b1:	e8 34 ff ff ff       	call   8018ea <syscall>
  8019b6:	83 c4 18             	add    $0x18,%esp
}
  8019b9:	c9                   	leave  
  8019ba:	c3                   	ret    

008019bb <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8019bb:	55                   	push   %ebp
  8019bc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 00                	push   $0x0
  8019c2:	6a 00                	push   $0x0
  8019c4:	ff 75 0c             	pushl  0xc(%ebp)
  8019c7:	ff 75 08             	pushl  0x8(%ebp)
  8019ca:	6a 08                	push   $0x8
  8019cc:	e8 19 ff ff ff       	call   8018ea <syscall>
  8019d1:	83 c4 18             	add    $0x18,%esp
}
  8019d4:	c9                   	leave  
  8019d5:	c3                   	ret    

008019d6 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8019d6:	55                   	push   %ebp
  8019d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8019d9:	6a 00                	push   $0x0
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 09                	push   $0x9
  8019e5:	e8 00 ff ff ff       	call   8018ea <syscall>
  8019ea:	83 c4 18             	add    $0x18,%esp
}
  8019ed:	c9                   	leave  
  8019ee:	c3                   	ret    

008019ef <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8019ef:	55                   	push   %ebp
  8019f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8019f2:	6a 00                	push   $0x0
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 00                	push   $0x0
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 0a                	push   $0xa
  8019fe:	e8 e7 fe ff ff       	call   8018ea <syscall>
  801a03:	83 c4 18             	add    $0x18,%esp
}
  801a06:	c9                   	leave  
  801a07:	c3                   	ret    

00801a08 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a08:	55                   	push   %ebp
  801a09:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a0b:	6a 00                	push   $0x0
  801a0d:	6a 00                	push   $0x0
  801a0f:	6a 00                	push   $0x0
  801a11:	6a 00                	push   $0x0
  801a13:	6a 00                	push   $0x0
  801a15:	6a 0b                	push   $0xb
  801a17:	e8 ce fe ff ff       	call   8018ea <syscall>
  801a1c:	83 c4 18             	add    $0x18,%esp
}
  801a1f:	c9                   	leave  
  801a20:	c3                   	ret    

00801a21 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a21:	55                   	push   %ebp
  801a22:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801a24:	6a 00                	push   $0x0
  801a26:	6a 00                	push   $0x0
  801a28:	6a 00                	push   $0x0
  801a2a:	ff 75 0c             	pushl  0xc(%ebp)
  801a2d:	ff 75 08             	pushl  0x8(%ebp)
  801a30:	6a 0f                	push   $0xf
  801a32:	e8 b3 fe ff ff       	call   8018ea <syscall>
  801a37:	83 c4 18             	add    $0x18,%esp
	return;
  801a3a:	90                   	nop
}
  801a3b:	c9                   	leave  
  801a3c:	c3                   	ret    

00801a3d <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a3d:	55                   	push   %ebp
  801a3e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a40:	6a 00                	push   $0x0
  801a42:	6a 00                	push   $0x0
  801a44:	6a 00                	push   $0x0
  801a46:	ff 75 0c             	pushl  0xc(%ebp)
  801a49:	ff 75 08             	pushl  0x8(%ebp)
  801a4c:	6a 10                	push   $0x10
  801a4e:	e8 97 fe ff ff       	call   8018ea <syscall>
  801a53:	83 c4 18             	add    $0x18,%esp
	return ;
  801a56:	90                   	nop
}
  801a57:	c9                   	leave  
  801a58:	c3                   	ret    

00801a59 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a59:	55                   	push   %ebp
  801a5a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a5c:	6a 00                	push   $0x0
  801a5e:	6a 00                	push   $0x0
  801a60:	ff 75 10             	pushl  0x10(%ebp)
  801a63:	ff 75 0c             	pushl  0xc(%ebp)
  801a66:	ff 75 08             	pushl  0x8(%ebp)
  801a69:	6a 11                	push   $0x11
  801a6b:	e8 7a fe ff ff       	call   8018ea <syscall>
  801a70:	83 c4 18             	add    $0x18,%esp
	return ;
  801a73:	90                   	nop
}
  801a74:	c9                   	leave  
  801a75:	c3                   	ret    

00801a76 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a76:	55                   	push   %ebp
  801a77:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a79:	6a 00                	push   $0x0
  801a7b:	6a 00                	push   $0x0
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 00                	push   $0x0
  801a83:	6a 0c                	push   $0xc
  801a85:	e8 60 fe ff ff       	call   8018ea <syscall>
  801a8a:	83 c4 18             	add    $0x18,%esp
}
  801a8d:	c9                   	leave  
  801a8e:	c3                   	ret    

00801a8f <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a8f:	55                   	push   %ebp
  801a90:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a92:	6a 00                	push   $0x0
  801a94:	6a 00                	push   $0x0
  801a96:	6a 00                	push   $0x0
  801a98:	6a 00                	push   $0x0
  801a9a:	ff 75 08             	pushl  0x8(%ebp)
  801a9d:	6a 0d                	push   $0xd
  801a9f:	e8 46 fe ff ff       	call   8018ea <syscall>
  801aa4:	83 c4 18             	add    $0x18,%esp
}
  801aa7:	c9                   	leave  
  801aa8:	c3                   	ret    

00801aa9 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801aa9:	55                   	push   %ebp
  801aaa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801aac:	6a 00                	push   $0x0
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 0e                	push   $0xe
  801ab8:	e8 2d fe ff ff       	call   8018ea <syscall>
  801abd:	83 c4 18             	add    $0x18,%esp
}
  801ac0:	90                   	nop
  801ac1:	c9                   	leave  
  801ac2:	c3                   	ret    

00801ac3 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801ac3:	55                   	push   %ebp
  801ac4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 00                	push   $0x0
  801aca:	6a 00                	push   $0x0
  801acc:	6a 00                	push   $0x0
  801ace:	6a 00                	push   $0x0
  801ad0:	6a 13                	push   $0x13
  801ad2:	e8 13 fe ff ff       	call   8018ea <syscall>
  801ad7:	83 c4 18             	add    $0x18,%esp
}
  801ada:	90                   	nop
  801adb:	c9                   	leave  
  801adc:	c3                   	ret    

00801add <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801add:	55                   	push   %ebp
  801ade:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 00                	push   $0x0
  801ae4:	6a 00                	push   $0x0
  801ae6:	6a 00                	push   $0x0
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 14                	push   $0x14
  801aec:	e8 f9 fd ff ff       	call   8018ea <syscall>
  801af1:	83 c4 18             	add    $0x18,%esp
}
  801af4:	90                   	nop
  801af5:	c9                   	leave  
  801af6:	c3                   	ret    

00801af7 <sys_cputc>:


void
sys_cputc(const char c)
{
  801af7:	55                   	push   %ebp
  801af8:	89 e5                	mov    %esp,%ebp
  801afa:	83 ec 04             	sub    $0x4,%esp
  801afd:	8b 45 08             	mov    0x8(%ebp),%eax
  801b00:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b03:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 00                	push   $0x0
  801b0f:	50                   	push   %eax
  801b10:	6a 15                	push   $0x15
  801b12:	e8 d3 fd ff ff       	call   8018ea <syscall>
  801b17:	83 c4 18             	add    $0x18,%esp
}
  801b1a:	90                   	nop
  801b1b:	c9                   	leave  
  801b1c:	c3                   	ret    

00801b1d <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b1d:	55                   	push   %ebp
  801b1e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b20:	6a 00                	push   $0x0
  801b22:	6a 00                	push   $0x0
  801b24:	6a 00                	push   $0x0
  801b26:	6a 00                	push   $0x0
  801b28:	6a 00                	push   $0x0
  801b2a:	6a 16                	push   $0x16
  801b2c:	e8 b9 fd ff ff       	call   8018ea <syscall>
  801b31:	83 c4 18             	add    $0x18,%esp
}
  801b34:	90                   	nop
  801b35:	c9                   	leave  
  801b36:	c3                   	ret    

00801b37 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801b37:	55                   	push   %ebp
  801b38:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3d:	6a 00                	push   $0x0
  801b3f:	6a 00                	push   $0x0
  801b41:	6a 00                	push   $0x0
  801b43:	ff 75 0c             	pushl  0xc(%ebp)
  801b46:	50                   	push   %eax
  801b47:	6a 17                	push   $0x17
  801b49:	e8 9c fd ff ff       	call   8018ea <syscall>
  801b4e:	83 c4 18             	add    $0x18,%esp
}
  801b51:	c9                   	leave  
  801b52:	c3                   	ret    

00801b53 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801b53:	55                   	push   %ebp
  801b54:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b56:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b59:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5c:	6a 00                	push   $0x0
  801b5e:	6a 00                	push   $0x0
  801b60:	6a 00                	push   $0x0
  801b62:	52                   	push   %edx
  801b63:	50                   	push   %eax
  801b64:	6a 1a                	push   $0x1a
  801b66:	e8 7f fd ff ff       	call   8018ea <syscall>
  801b6b:	83 c4 18             	add    $0x18,%esp
}
  801b6e:	c9                   	leave  
  801b6f:	c3                   	ret    

00801b70 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b70:	55                   	push   %ebp
  801b71:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b73:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b76:	8b 45 08             	mov    0x8(%ebp),%eax
  801b79:	6a 00                	push   $0x0
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 00                	push   $0x0
  801b7f:	52                   	push   %edx
  801b80:	50                   	push   %eax
  801b81:	6a 18                	push   $0x18
  801b83:	e8 62 fd ff ff       	call   8018ea <syscall>
  801b88:	83 c4 18             	add    $0x18,%esp
}
  801b8b:	90                   	nop
  801b8c:	c9                   	leave  
  801b8d:	c3                   	ret    

00801b8e <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b8e:	55                   	push   %ebp
  801b8f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b91:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b94:	8b 45 08             	mov    0x8(%ebp),%eax
  801b97:	6a 00                	push   $0x0
  801b99:	6a 00                	push   $0x0
  801b9b:	6a 00                	push   $0x0
  801b9d:	52                   	push   %edx
  801b9e:	50                   	push   %eax
  801b9f:	6a 19                	push   $0x19
  801ba1:	e8 44 fd ff ff       	call   8018ea <syscall>
  801ba6:	83 c4 18             	add    $0x18,%esp
}
  801ba9:	90                   	nop
  801baa:	c9                   	leave  
  801bab:	c3                   	ret    

00801bac <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801bac:	55                   	push   %ebp
  801bad:	89 e5                	mov    %esp,%ebp
  801baf:	83 ec 04             	sub    $0x4,%esp
  801bb2:	8b 45 10             	mov    0x10(%ebp),%eax
  801bb5:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801bb8:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801bbb:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc2:	6a 00                	push   $0x0
  801bc4:	51                   	push   %ecx
  801bc5:	52                   	push   %edx
  801bc6:	ff 75 0c             	pushl  0xc(%ebp)
  801bc9:	50                   	push   %eax
  801bca:	6a 1b                	push   $0x1b
  801bcc:	e8 19 fd ff ff       	call   8018ea <syscall>
  801bd1:	83 c4 18             	add    $0x18,%esp
}
  801bd4:	c9                   	leave  
  801bd5:	c3                   	ret    

00801bd6 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801bd6:	55                   	push   %ebp
  801bd7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801bd9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bdc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 00                	push   $0x0
  801be3:	6a 00                	push   $0x0
  801be5:	52                   	push   %edx
  801be6:	50                   	push   %eax
  801be7:	6a 1c                	push   $0x1c
  801be9:	e8 fc fc ff ff       	call   8018ea <syscall>
  801bee:	83 c4 18             	add    $0x18,%esp
}
  801bf1:	c9                   	leave  
  801bf2:	c3                   	ret    

00801bf3 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801bf3:	55                   	push   %ebp
  801bf4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801bf6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bf9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bff:	6a 00                	push   $0x0
  801c01:	6a 00                	push   $0x0
  801c03:	51                   	push   %ecx
  801c04:	52                   	push   %edx
  801c05:	50                   	push   %eax
  801c06:	6a 1d                	push   $0x1d
  801c08:	e8 dd fc ff ff       	call   8018ea <syscall>
  801c0d:	83 c4 18             	add    $0x18,%esp
}
  801c10:	c9                   	leave  
  801c11:	c3                   	ret    

00801c12 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801c12:	55                   	push   %ebp
  801c13:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801c15:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c18:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 00                	push   $0x0
  801c21:	52                   	push   %edx
  801c22:	50                   	push   %eax
  801c23:	6a 1e                	push   $0x1e
  801c25:	e8 c0 fc ff ff       	call   8018ea <syscall>
  801c2a:	83 c4 18             	add    $0x18,%esp
}
  801c2d:	c9                   	leave  
  801c2e:	c3                   	ret    

00801c2f <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801c2f:	55                   	push   %ebp
  801c30:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801c32:	6a 00                	push   $0x0
  801c34:	6a 00                	push   $0x0
  801c36:	6a 00                	push   $0x0
  801c38:	6a 00                	push   $0x0
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 1f                	push   $0x1f
  801c3e:	e8 a7 fc ff ff       	call   8018ea <syscall>
  801c43:	83 c4 18             	add    $0x18,%esp
}
  801c46:	c9                   	leave  
  801c47:	c3                   	ret    

00801c48 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c48:	55                   	push   %ebp
  801c49:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4e:	6a 00                	push   $0x0
  801c50:	ff 75 14             	pushl  0x14(%ebp)
  801c53:	ff 75 10             	pushl  0x10(%ebp)
  801c56:	ff 75 0c             	pushl  0xc(%ebp)
  801c59:	50                   	push   %eax
  801c5a:	6a 20                	push   $0x20
  801c5c:	e8 89 fc ff ff       	call   8018ea <syscall>
  801c61:	83 c4 18             	add    $0x18,%esp
}
  801c64:	c9                   	leave  
  801c65:	c3                   	ret    

00801c66 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801c66:	55                   	push   %ebp
  801c67:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c69:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 00                	push   $0x0
  801c70:	6a 00                	push   $0x0
  801c72:	6a 00                	push   $0x0
  801c74:	50                   	push   %eax
  801c75:	6a 21                	push   $0x21
  801c77:	e8 6e fc ff ff       	call   8018ea <syscall>
  801c7c:	83 c4 18             	add    $0x18,%esp
}
  801c7f:	90                   	nop
  801c80:	c9                   	leave  
  801c81:	c3                   	ret    

00801c82 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c82:	55                   	push   %ebp
  801c83:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c85:	8b 45 08             	mov    0x8(%ebp),%eax
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	50                   	push   %eax
  801c91:	6a 22                	push   $0x22
  801c93:	e8 52 fc ff ff       	call   8018ea <syscall>
  801c98:	83 c4 18             	add    $0x18,%esp
}
  801c9b:	c9                   	leave  
  801c9c:	c3                   	ret    

00801c9d <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c9d:	55                   	push   %ebp
  801c9e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 00                	push   $0x0
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 02                	push   $0x2
  801cac:	e8 39 fc ff ff       	call   8018ea <syscall>
  801cb1:	83 c4 18             	add    $0x18,%esp
}
  801cb4:	c9                   	leave  
  801cb5:	c3                   	ret    

00801cb6 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801cb6:	55                   	push   %ebp
  801cb7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801cb9:	6a 00                	push   $0x0
  801cbb:	6a 00                	push   $0x0
  801cbd:	6a 00                	push   $0x0
  801cbf:	6a 00                	push   $0x0
  801cc1:	6a 00                	push   $0x0
  801cc3:	6a 03                	push   $0x3
  801cc5:	e8 20 fc ff ff       	call   8018ea <syscall>
  801cca:	83 c4 18             	add    $0x18,%esp
}
  801ccd:	c9                   	leave  
  801cce:	c3                   	ret    

00801ccf <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801ccf:	55                   	push   %ebp
  801cd0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801cd2:	6a 00                	push   $0x0
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 00                	push   $0x0
  801cda:	6a 00                	push   $0x0
  801cdc:	6a 04                	push   $0x4
  801cde:	e8 07 fc ff ff       	call   8018ea <syscall>
  801ce3:	83 c4 18             	add    $0x18,%esp
}
  801ce6:	c9                   	leave  
  801ce7:	c3                   	ret    

00801ce8 <sys_exit_env>:


void sys_exit_env(void)
{
  801ce8:	55                   	push   %ebp
  801ce9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801ceb:	6a 00                	push   $0x0
  801ced:	6a 00                	push   $0x0
  801cef:	6a 00                	push   $0x0
  801cf1:	6a 00                	push   $0x0
  801cf3:	6a 00                	push   $0x0
  801cf5:	6a 23                	push   $0x23
  801cf7:	e8 ee fb ff ff       	call   8018ea <syscall>
  801cfc:	83 c4 18             	add    $0x18,%esp
}
  801cff:	90                   	nop
  801d00:	c9                   	leave  
  801d01:	c3                   	ret    

00801d02 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801d02:	55                   	push   %ebp
  801d03:	89 e5                	mov    %esp,%ebp
  801d05:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801d08:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d0b:	8d 50 04             	lea    0x4(%eax),%edx
  801d0e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d11:	6a 00                	push   $0x0
  801d13:	6a 00                	push   $0x0
  801d15:	6a 00                	push   $0x0
  801d17:	52                   	push   %edx
  801d18:	50                   	push   %eax
  801d19:	6a 24                	push   $0x24
  801d1b:	e8 ca fb ff ff       	call   8018ea <syscall>
  801d20:	83 c4 18             	add    $0x18,%esp
	return result;
  801d23:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d26:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d29:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d2c:	89 01                	mov    %eax,(%ecx)
  801d2e:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d31:	8b 45 08             	mov    0x8(%ebp),%eax
  801d34:	c9                   	leave  
  801d35:	c2 04 00             	ret    $0x4

00801d38 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d38:	55                   	push   %ebp
  801d39:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d3b:	6a 00                	push   $0x0
  801d3d:	6a 00                	push   $0x0
  801d3f:	ff 75 10             	pushl  0x10(%ebp)
  801d42:	ff 75 0c             	pushl  0xc(%ebp)
  801d45:	ff 75 08             	pushl  0x8(%ebp)
  801d48:	6a 12                	push   $0x12
  801d4a:	e8 9b fb ff ff       	call   8018ea <syscall>
  801d4f:	83 c4 18             	add    $0x18,%esp
	return ;
  801d52:	90                   	nop
}
  801d53:	c9                   	leave  
  801d54:	c3                   	ret    

00801d55 <sys_rcr2>:
uint32 sys_rcr2()
{
  801d55:	55                   	push   %ebp
  801d56:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d58:	6a 00                	push   $0x0
  801d5a:	6a 00                	push   $0x0
  801d5c:	6a 00                	push   $0x0
  801d5e:	6a 00                	push   $0x0
  801d60:	6a 00                	push   $0x0
  801d62:	6a 25                	push   $0x25
  801d64:	e8 81 fb ff ff       	call   8018ea <syscall>
  801d69:	83 c4 18             	add    $0x18,%esp
}
  801d6c:	c9                   	leave  
  801d6d:	c3                   	ret    

00801d6e <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801d6e:	55                   	push   %ebp
  801d6f:	89 e5                	mov    %esp,%ebp
  801d71:	83 ec 04             	sub    $0x4,%esp
  801d74:	8b 45 08             	mov    0x8(%ebp),%eax
  801d77:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d7a:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d7e:	6a 00                	push   $0x0
  801d80:	6a 00                	push   $0x0
  801d82:	6a 00                	push   $0x0
  801d84:	6a 00                	push   $0x0
  801d86:	50                   	push   %eax
  801d87:	6a 26                	push   $0x26
  801d89:	e8 5c fb ff ff       	call   8018ea <syscall>
  801d8e:	83 c4 18             	add    $0x18,%esp
	return ;
  801d91:	90                   	nop
}
  801d92:	c9                   	leave  
  801d93:	c3                   	ret    

00801d94 <rsttst>:
void rsttst()
{
  801d94:	55                   	push   %ebp
  801d95:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d97:	6a 00                	push   $0x0
  801d99:	6a 00                	push   $0x0
  801d9b:	6a 00                	push   $0x0
  801d9d:	6a 00                	push   $0x0
  801d9f:	6a 00                	push   $0x0
  801da1:	6a 28                	push   $0x28
  801da3:	e8 42 fb ff ff       	call   8018ea <syscall>
  801da8:	83 c4 18             	add    $0x18,%esp
	return ;
  801dab:	90                   	nop
}
  801dac:	c9                   	leave  
  801dad:	c3                   	ret    

00801dae <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801dae:	55                   	push   %ebp
  801daf:	89 e5                	mov    %esp,%ebp
  801db1:	83 ec 04             	sub    $0x4,%esp
  801db4:	8b 45 14             	mov    0x14(%ebp),%eax
  801db7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801dba:	8b 55 18             	mov    0x18(%ebp),%edx
  801dbd:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801dc1:	52                   	push   %edx
  801dc2:	50                   	push   %eax
  801dc3:	ff 75 10             	pushl  0x10(%ebp)
  801dc6:	ff 75 0c             	pushl  0xc(%ebp)
  801dc9:	ff 75 08             	pushl  0x8(%ebp)
  801dcc:	6a 27                	push   $0x27
  801dce:	e8 17 fb ff ff       	call   8018ea <syscall>
  801dd3:	83 c4 18             	add    $0x18,%esp
	return ;
  801dd6:	90                   	nop
}
  801dd7:	c9                   	leave  
  801dd8:	c3                   	ret    

00801dd9 <chktst>:
void chktst(uint32 n)
{
  801dd9:	55                   	push   %ebp
  801dda:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801ddc:	6a 00                	push   $0x0
  801dde:	6a 00                	push   $0x0
  801de0:	6a 00                	push   $0x0
  801de2:	6a 00                	push   $0x0
  801de4:	ff 75 08             	pushl  0x8(%ebp)
  801de7:	6a 29                	push   $0x29
  801de9:	e8 fc fa ff ff       	call   8018ea <syscall>
  801dee:	83 c4 18             	add    $0x18,%esp
	return ;
  801df1:	90                   	nop
}
  801df2:	c9                   	leave  
  801df3:	c3                   	ret    

00801df4 <inctst>:

void inctst()
{
  801df4:	55                   	push   %ebp
  801df5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801df7:	6a 00                	push   $0x0
  801df9:	6a 00                	push   $0x0
  801dfb:	6a 00                	push   $0x0
  801dfd:	6a 00                	push   $0x0
  801dff:	6a 00                	push   $0x0
  801e01:	6a 2a                	push   $0x2a
  801e03:	e8 e2 fa ff ff       	call   8018ea <syscall>
  801e08:	83 c4 18             	add    $0x18,%esp
	return ;
  801e0b:	90                   	nop
}
  801e0c:	c9                   	leave  
  801e0d:	c3                   	ret    

00801e0e <gettst>:
uint32 gettst()
{
  801e0e:	55                   	push   %ebp
  801e0f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801e11:	6a 00                	push   $0x0
  801e13:	6a 00                	push   $0x0
  801e15:	6a 00                	push   $0x0
  801e17:	6a 00                	push   $0x0
  801e19:	6a 00                	push   $0x0
  801e1b:	6a 2b                	push   $0x2b
  801e1d:	e8 c8 fa ff ff       	call   8018ea <syscall>
  801e22:	83 c4 18             	add    $0x18,%esp
}
  801e25:	c9                   	leave  
  801e26:	c3                   	ret    

00801e27 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801e27:	55                   	push   %ebp
  801e28:	89 e5                	mov    %esp,%ebp
  801e2a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 00                	push   $0x0
  801e31:	6a 00                	push   $0x0
  801e33:	6a 00                	push   $0x0
  801e35:	6a 00                	push   $0x0
  801e37:	6a 2c                	push   $0x2c
  801e39:	e8 ac fa ff ff       	call   8018ea <syscall>
  801e3e:	83 c4 18             	add    $0x18,%esp
  801e41:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e44:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e48:	75 07                	jne    801e51 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e4a:	b8 01 00 00 00       	mov    $0x1,%eax
  801e4f:	eb 05                	jmp    801e56 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e51:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e56:	c9                   	leave  
  801e57:	c3                   	ret    

00801e58 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e58:	55                   	push   %ebp
  801e59:	89 e5                	mov    %esp,%ebp
  801e5b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e5e:	6a 00                	push   $0x0
  801e60:	6a 00                	push   $0x0
  801e62:	6a 00                	push   $0x0
  801e64:	6a 00                	push   $0x0
  801e66:	6a 00                	push   $0x0
  801e68:	6a 2c                	push   $0x2c
  801e6a:	e8 7b fa ff ff       	call   8018ea <syscall>
  801e6f:	83 c4 18             	add    $0x18,%esp
  801e72:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e75:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e79:	75 07                	jne    801e82 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e7b:	b8 01 00 00 00       	mov    $0x1,%eax
  801e80:	eb 05                	jmp    801e87 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e82:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e87:	c9                   	leave  
  801e88:	c3                   	ret    

00801e89 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e89:	55                   	push   %ebp
  801e8a:	89 e5                	mov    %esp,%ebp
  801e8c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e8f:	6a 00                	push   $0x0
  801e91:	6a 00                	push   $0x0
  801e93:	6a 00                	push   $0x0
  801e95:	6a 00                	push   $0x0
  801e97:	6a 00                	push   $0x0
  801e99:	6a 2c                	push   $0x2c
  801e9b:	e8 4a fa ff ff       	call   8018ea <syscall>
  801ea0:	83 c4 18             	add    $0x18,%esp
  801ea3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801ea6:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801eaa:	75 07                	jne    801eb3 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801eac:	b8 01 00 00 00       	mov    $0x1,%eax
  801eb1:	eb 05                	jmp    801eb8 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801eb3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eb8:	c9                   	leave  
  801eb9:	c3                   	ret    

00801eba <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801eba:	55                   	push   %ebp
  801ebb:	89 e5                	mov    %esp,%ebp
  801ebd:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ec0:	6a 00                	push   $0x0
  801ec2:	6a 00                	push   $0x0
  801ec4:	6a 00                	push   $0x0
  801ec6:	6a 00                	push   $0x0
  801ec8:	6a 00                	push   $0x0
  801eca:	6a 2c                	push   $0x2c
  801ecc:	e8 19 fa ff ff       	call   8018ea <syscall>
  801ed1:	83 c4 18             	add    $0x18,%esp
  801ed4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801ed7:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801edb:	75 07                	jne    801ee4 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801edd:	b8 01 00 00 00       	mov    $0x1,%eax
  801ee2:	eb 05                	jmp    801ee9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801ee4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ee9:	c9                   	leave  
  801eea:	c3                   	ret    

00801eeb <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801eeb:	55                   	push   %ebp
  801eec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801eee:	6a 00                	push   $0x0
  801ef0:	6a 00                	push   $0x0
  801ef2:	6a 00                	push   $0x0
  801ef4:	6a 00                	push   $0x0
  801ef6:	ff 75 08             	pushl  0x8(%ebp)
  801ef9:	6a 2d                	push   $0x2d
  801efb:	e8 ea f9 ff ff       	call   8018ea <syscall>
  801f00:	83 c4 18             	add    $0x18,%esp
	return ;
  801f03:	90                   	nop
}
  801f04:	c9                   	leave  
  801f05:	c3                   	ret    

00801f06 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801f06:	55                   	push   %ebp
  801f07:	89 e5                	mov    %esp,%ebp
  801f09:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801f0a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f0d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f10:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f13:	8b 45 08             	mov    0x8(%ebp),%eax
  801f16:	6a 00                	push   $0x0
  801f18:	53                   	push   %ebx
  801f19:	51                   	push   %ecx
  801f1a:	52                   	push   %edx
  801f1b:	50                   	push   %eax
  801f1c:	6a 2e                	push   $0x2e
  801f1e:	e8 c7 f9 ff ff       	call   8018ea <syscall>
  801f23:	83 c4 18             	add    $0x18,%esp
}
  801f26:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f29:	c9                   	leave  
  801f2a:	c3                   	ret    

00801f2b <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f2b:	55                   	push   %ebp
  801f2c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801f2e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f31:	8b 45 08             	mov    0x8(%ebp),%eax
  801f34:	6a 00                	push   $0x0
  801f36:	6a 00                	push   $0x0
  801f38:	6a 00                	push   $0x0
  801f3a:	52                   	push   %edx
  801f3b:	50                   	push   %eax
  801f3c:	6a 2f                	push   $0x2f
  801f3e:	e8 a7 f9 ff ff       	call   8018ea <syscall>
  801f43:	83 c4 18             	add    $0x18,%esp
}
  801f46:	c9                   	leave  
  801f47:	c3                   	ret    

00801f48 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801f48:	55                   	push   %ebp
  801f49:	89 e5                	mov    %esp,%ebp
  801f4b:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801f4e:	83 ec 0c             	sub    $0xc,%esp
  801f51:	68 1c 3c 80 00       	push   $0x803c1c
  801f56:	e8 c7 e6 ff ff       	call   800622 <cprintf>
  801f5b:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801f5e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801f65:	83 ec 0c             	sub    $0xc,%esp
  801f68:	68 48 3c 80 00       	push   $0x803c48
  801f6d:	e8 b0 e6 ff ff       	call   800622 <cprintf>
  801f72:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801f75:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f79:	a1 38 41 80 00       	mov    0x804138,%eax
  801f7e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f81:	eb 56                	jmp    801fd9 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f83:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f87:	74 1c                	je     801fa5 <print_mem_block_lists+0x5d>
  801f89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f8c:	8b 50 08             	mov    0x8(%eax),%edx
  801f8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f92:	8b 48 08             	mov    0x8(%eax),%ecx
  801f95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f98:	8b 40 0c             	mov    0xc(%eax),%eax
  801f9b:	01 c8                	add    %ecx,%eax
  801f9d:	39 c2                	cmp    %eax,%edx
  801f9f:	73 04                	jae    801fa5 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801fa1:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801fa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa8:	8b 50 08             	mov    0x8(%eax),%edx
  801fab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fae:	8b 40 0c             	mov    0xc(%eax),%eax
  801fb1:	01 c2                	add    %eax,%edx
  801fb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb6:	8b 40 08             	mov    0x8(%eax),%eax
  801fb9:	83 ec 04             	sub    $0x4,%esp
  801fbc:	52                   	push   %edx
  801fbd:	50                   	push   %eax
  801fbe:	68 5d 3c 80 00       	push   $0x803c5d
  801fc3:	e8 5a e6 ff ff       	call   800622 <cprintf>
  801fc8:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801fcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fce:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801fd1:	a1 40 41 80 00       	mov    0x804140,%eax
  801fd6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fd9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fdd:	74 07                	je     801fe6 <print_mem_block_lists+0x9e>
  801fdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe2:	8b 00                	mov    (%eax),%eax
  801fe4:	eb 05                	jmp    801feb <print_mem_block_lists+0xa3>
  801fe6:	b8 00 00 00 00       	mov    $0x0,%eax
  801feb:	a3 40 41 80 00       	mov    %eax,0x804140
  801ff0:	a1 40 41 80 00       	mov    0x804140,%eax
  801ff5:	85 c0                	test   %eax,%eax
  801ff7:	75 8a                	jne    801f83 <print_mem_block_lists+0x3b>
  801ff9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ffd:	75 84                	jne    801f83 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801fff:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802003:	75 10                	jne    802015 <print_mem_block_lists+0xcd>
  802005:	83 ec 0c             	sub    $0xc,%esp
  802008:	68 6c 3c 80 00       	push   $0x803c6c
  80200d:	e8 10 e6 ff ff       	call   800622 <cprintf>
  802012:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802015:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80201c:	83 ec 0c             	sub    $0xc,%esp
  80201f:	68 90 3c 80 00       	push   $0x803c90
  802024:	e8 f9 e5 ff ff       	call   800622 <cprintf>
  802029:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80202c:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802030:	a1 40 40 80 00       	mov    0x804040,%eax
  802035:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802038:	eb 56                	jmp    802090 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80203a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80203e:	74 1c                	je     80205c <print_mem_block_lists+0x114>
  802040:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802043:	8b 50 08             	mov    0x8(%eax),%edx
  802046:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802049:	8b 48 08             	mov    0x8(%eax),%ecx
  80204c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80204f:	8b 40 0c             	mov    0xc(%eax),%eax
  802052:	01 c8                	add    %ecx,%eax
  802054:	39 c2                	cmp    %eax,%edx
  802056:	73 04                	jae    80205c <print_mem_block_lists+0x114>
			sorted = 0 ;
  802058:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80205c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80205f:	8b 50 08             	mov    0x8(%eax),%edx
  802062:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802065:	8b 40 0c             	mov    0xc(%eax),%eax
  802068:	01 c2                	add    %eax,%edx
  80206a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80206d:	8b 40 08             	mov    0x8(%eax),%eax
  802070:	83 ec 04             	sub    $0x4,%esp
  802073:	52                   	push   %edx
  802074:	50                   	push   %eax
  802075:	68 5d 3c 80 00       	push   $0x803c5d
  80207a:	e8 a3 e5 ff ff       	call   800622 <cprintf>
  80207f:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802082:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802085:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802088:	a1 48 40 80 00       	mov    0x804048,%eax
  80208d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802090:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802094:	74 07                	je     80209d <print_mem_block_lists+0x155>
  802096:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802099:	8b 00                	mov    (%eax),%eax
  80209b:	eb 05                	jmp    8020a2 <print_mem_block_lists+0x15a>
  80209d:	b8 00 00 00 00       	mov    $0x0,%eax
  8020a2:	a3 48 40 80 00       	mov    %eax,0x804048
  8020a7:	a1 48 40 80 00       	mov    0x804048,%eax
  8020ac:	85 c0                	test   %eax,%eax
  8020ae:	75 8a                	jne    80203a <print_mem_block_lists+0xf2>
  8020b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020b4:	75 84                	jne    80203a <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8020b6:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8020ba:	75 10                	jne    8020cc <print_mem_block_lists+0x184>
  8020bc:	83 ec 0c             	sub    $0xc,%esp
  8020bf:	68 a8 3c 80 00       	push   $0x803ca8
  8020c4:	e8 59 e5 ff ff       	call   800622 <cprintf>
  8020c9:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8020cc:	83 ec 0c             	sub    $0xc,%esp
  8020cf:	68 1c 3c 80 00       	push   $0x803c1c
  8020d4:	e8 49 e5 ff ff       	call   800622 <cprintf>
  8020d9:	83 c4 10             	add    $0x10,%esp

}
  8020dc:	90                   	nop
  8020dd:	c9                   	leave  
  8020de:	c3                   	ret    

008020df <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8020df:	55                   	push   %ebp
  8020e0:	89 e5                	mov    %esp,%ebp
  8020e2:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);
  8020e5:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  8020ec:	00 00 00 
  8020ef:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  8020f6:	00 00 00 
  8020f9:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  802100:	00 00 00 

		struct MemBlock *tmp=MemBlockNodes;
  802103:	a1 50 40 80 00       	mov    0x804050,%eax
  802108:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (int i=0;i<numOfBlocks;i++)
  80210b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802112:	e9 9e 00 00 00       	jmp    8021b5 <initialize_MemBlocksList+0xd6>
		{

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  802117:	a1 50 40 80 00       	mov    0x804050,%eax
  80211c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80211f:	c1 e2 04             	shl    $0x4,%edx
  802122:	01 d0                	add    %edx,%eax
  802124:	85 c0                	test   %eax,%eax
  802126:	75 14                	jne    80213c <initialize_MemBlocksList+0x5d>
  802128:	83 ec 04             	sub    $0x4,%esp
  80212b:	68 d0 3c 80 00       	push   $0x803cd0
  802130:	6a 48                	push   $0x48
  802132:	68 f3 3c 80 00       	push   $0x803cf3
  802137:	e8 07 10 00 00       	call   803143 <_panic>
  80213c:	a1 50 40 80 00       	mov    0x804050,%eax
  802141:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802144:	c1 e2 04             	shl    $0x4,%edx
  802147:	01 d0                	add    %edx,%eax
  802149:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80214f:	89 10                	mov    %edx,(%eax)
  802151:	8b 00                	mov    (%eax),%eax
  802153:	85 c0                	test   %eax,%eax
  802155:	74 18                	je     80216f <initialize_MemBlocksList+0x90>
  802157:	a1 48 41 80 00       	mov    0x804148,%eax
  80215c:	8b 15 50 40 80 00    	mov    0x804050,%edx
  802162:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802165:	c1 e1 04             	shl    $0x4,%ecx
  802168:	01 ca                	add    %ecx,%edx
  80216a:	89 50 04             	mov    %edx,0x4(%eax)
  80216d:	eb 12                	jmp    802181 <initialize_MemBlocksList+0xa2>
  80216f:	a1 50 40 80 00       	mov    0x804050,%eax
  802174:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802177:	c1 e2 04             	shl    $0x4,%edx
  80217a:	01 d0                	add    %edx,%eax
  80217c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802181:	a1 50 40 80 00       	mov    0x804050,%eax
  802186:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802189:	c1 e2 04             	shl    $0x4,%edx
  80218c:	01 d0                	add    %edx,%eax
  80218e:	a3 48 41 80 00       	mov    %eax,0x804148
  802193:	a1 50 40 80 00       	mov    0x804050,%eax
  802198:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80219b:	c1 e2 04             	shl    $0x4,%edx
  80219e:	01 d0                	add    %edx,%eax
  8021a0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021a7:	a1 54 41 80 00       	mov    0x804154,%eax
  8021ac:	40                   	inc    %eax
  8021ad:	a3 54 41 80 00       	mov    %eax,0x804154
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);

		struct MemBlock *tmp=MemBlockNodes;
		for (int i=0;i<numOfBlocks;i++)
  8021b2:	ff 45 f4             	incl   -0xc(%ebp)
  8021b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021bb:	0f 82 56 ff ff ff    	jb     802117 <initialize_MemBlocksList+0x38>

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
		}


}
  8021c1:	90                   	nop
  8021c2:	c9                   	leave  
  8021c3:	c3                   	ret    

008021c4 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8021c4:	55                   	push   %ebp
  8021c5:	89 e5                	mov    %esp,%ebp
  8021c7:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;
  8021ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cd:	8b 00                	mov    (%eax),%eax
  8021cf:	89 45 fc             	mov    %eax,-0x4(%ebp)

	while(tmp!=NULL)
  8021d2:	eb 18                	jmp    8021ec <find_block+0x28>
		{
			if(tmp->sva==va)
  8021d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021d7:	8b 40 08             	mov    0x8(%eax),%eax
  8021da:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8021dd:	75 05                	jne    8021e4 <find_block+0x20>
			{
				return tmp;
  8021df:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021e2:	eb 11                	jmp    8021f5 <find_block+0x31>

			}
		tmp=tmp->prev_next_info.le_next;
  8021e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021e7:	8b 00                	mov    (%eax),%eax
  8021e9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;

	while(tmp!=NULL)
  8021ec:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021f0:	75 e2                	jne    8021d4 <find_block+0x10>
				return tmp;

			}
		tmp=tmp->prev_next_info.le_next;
		}
		return tmp;
  8021f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
//
//		}
//
//		}
//			return tmp;
}
  8021f5:	c9                   	leave  
  8021f6:	c3                   	ret    

008021f7 <insert_sorted_allocList>:
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================


void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8021f7:	55                   	push   %ebp
  8021f8:	89 e5                	mov    %esp,%ebp
  8021fa:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code

	if(AllocMemBlocksList.lh_first==NULL)
  8021fd:	a1 40 40 80 00       	mov    0x804040,%eax
  802202:	85 c0                	test   %eax,%eax
  802204:	0f 85 83 00 00 00    	jne    80228d <insert_sorted_allocList+0x96>
	{
		LIST_INIT(&AllocMemBlocksList);
  80220a:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  802211:	00 00 00 
  802214:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80221b:	00 00 00 
  80221e:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  802225:	00 00 00 
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802228:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80222c:	75 14                	jne    802242 <insert_sorted_allocList+0x4b>
  80222e:	83 ec 04             	sub    $0x4,%esp
  802231:	68 d0 3c 80 00       	push   $0x803cd0
  802236:	6a 7f                	push   $0x7f
  802238:	68 f3 3c 80 00       	push   $0x803cf3
  80223d:	e8 01 0f 00 00       	call   803143 <_panic>
  802242:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802248:	8b 45 08             	mov    0x8(%ebp),%eax
  80224b:	89 10                	mov    %edx,(%eax)
  80224d:	8b 45 08             	mov    0x8(%ebp),%eax
  802250:	8b 00                	mov    (%eax),%eax
  802252:	85 c0                	test   %eax,%eax
  802254:	74 0d                	je     802263 <insert_sorted_allocList+0x6c>
  802256:	a1 40 40 80 00       	mov    0x804040,%eax
  80225b:	8b 55 08             	mov    0x8(%ebp),%edx
  80225e:	89 50 04             	mov    %edx,0x4(%eax)
  802261:	eb 08                	jmp    80226b <insert_sorted_allocList+0x74>
  802263:	8b 45 08             	mov    0x8(%ebp),%eax
  802266:	a3 44 40 80 00       	mov    %eax,0x804044
  80226b:	8b 45 08             	mov    0x8(%ebp),%eax
  80226e:	a3 40 40 80 00       	mov    %eax,0x804040
  802273:	8b 45 08             	mov    0x8(%ebp),%eax
  802276:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80227d:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802282:	40                   	inc    %eax
  802283:	a3 4c 40 80 00       	mov    %eax,0x80404c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802288:	e9 16 01 00 00       	jmp    8023a3 <insert_sorted_allocList+0x1ac>
		LIST_INIT(&AllocMemBlocksList);
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}


	else if(blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  80228d:	8b 45 08             	mov    0x8(%ebp),%eax
  802290:	8b 50 08             	mov    0x8(%eax),%edx
  802293:	a1 44 40 80 00       	mov    0x804044,%eax
  802298:	8b 40 08             	mov    0x8(%eax),%eax
  80229b:	39 c2                	cmp    %eax,%edx
  80229d:	76 68                	jbe    802307 <insert_sorted_allocList+0x110>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
  80229f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022a3:	75 17                	jne    8022bc <insert_sorted_allocList+0xc5>
  8022a5:	83 ec 04             	sub    $0x4,%esp
  8022a8:	68 0c 3d 80 00       	push   $0x803d0c
  8022ad:	68 85 00 00 00       	push   $0x85
  8022b2:	68 f3 3c 80 00       	push   $0x803cf3
  8022b7:	e8 87 0e 00 00       	call   803143 <_panic>
  8022bc:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8022c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c5:	89 50 04             	mov    %edx,0x4(%eax)
  8022c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cb:	8b 40 04             	mov    0x4(%eax),%eax
  8022ce:	85 c0                	test   %eax,%eax
  8022d0:	74 0c                	je     8022de <insert_sorted_allocList+0xe7>
  8022d2:	a1 44 40 80 00       	mov    0x804044,%eax
  8022d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8022da:	89 10                	mov    %edx,(%eax)
  8022dc:	eb 08                	jmp    8022e6 <insert_sorted_allocList+0xef>
  8022de:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e1:	a3 40 40 80 00       	mov    %eax,0x804040
  8022e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e9:	a3 44 40 80 00       	mov    %eax,0x804044
  8022ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022f7:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022fc:	40                   	inc    %eax
  8022fd:	a3 4c 40 80 00       	mov    %eax,0x80404c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802302:	e9 9c 00 00 00       	jmp    8023a3 <insert_sorted_allocList+0x1ac>
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
  802307:	a1 40 40 80 00       	mov    0x804040,%eax
  80230c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  80230f:	e9 85 00 00 00       	jmp    802399 <insert_sorted_allocList+0x1a2>
		{
			if(blockToInsert->sva<tmp->sva)
  802314:	8b 45 08             	mov    0x8(%ebp),%eax
  802317:	8b 50 08             	mov    0x8(%eax),%edx
  80231a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231d:	8b 40 08             	mov    0x8(%eax),%eax
  802320:	39 c2                	cmp    %eax,%edx
  802322:	73 6d                	jae    802391 <insert_sorted_allocList+0x19a>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
  802324:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802328:	74 06                	je     802330 <insert_sorted_allocList+0x139>
  80232a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80232e:	75 17                	jne    802347 <insert_sorted_allocList+0x150>
  802330:	83 ec 04             	sub    $0x4,%esp
  802333:	68 30 3d 80 00       	push   $0x803d30
  802338:	68 90 00 00 00       	push   $0x90
  80233d:	68 f3 3c 80 00       	push   $0x803cf3
  802342:	e8 fc 0d 00 00       	call   803143 <_panic>
  802347:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234a:	8b 50 04             	mov    0x4(%eax),%edx
  80234d:	8b 45 08             	mov    0x8(%ebp),%eax
  802350:	89 50 04             	mov    %edx,0x4(%eax)
  802353:	8b 45 08             	mov    0x8(%ebp),%eax
  802356:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802359:	89 10                	mov    %edx,(%eax)
  80235b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235e:	8b 40 04             	mov    0x4(%eax),%eax
  802361:	85 c0                	test   %eax,%eax
  802363:	74 0d                	je     802372 <insert_sorted_allocList+0x17b>
  802365:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802368:	8b 40 04             	mov    0x4(%eax),%eax
  80236b:	8b 55 08             	mov    0x8(%ebp),%edx
  80236e:	89 10                	mov    %edx,(%eax)
  802370:	eb 08                	jmp    80237a <insert_sorted_allocList+0x183>
  802372:	8b 45 08             	mov    0x8(%ebp),%eax
  802375:	a3 40 40 80 00       	mov    %eax,0x804040
  80237a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237d:	8b 55 08             	mov    0x8(%ebp),%edx
  802380:	89 50 04             	mov    %edx,0x4(%eax)
  802383:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802388:	40                   	inc    %eax
  802389:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  80238e:	90                   	nop
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  80238f:	eb 12                	jmp    8023a3 <insert_sorted_allocList+0x1ac>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
				break;
			}
			tmp=tmp->prev_next_info.le_next;
  802391:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802394:	8b 00                	mov    (%eax),%eax
  802396:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
		while(tmp!=NULL)
  802399:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80239d:	0f 85 71 ff ff ff    	jne    802314 <insert_sorted_allocList+0x11d>
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8023a3:	90                   	nop
  8023a4:	c9                   	leave  
  8023a5:	c3                   	ret    

008023a6 <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

struct MemBlock *alloc_block_FF(uint32 size)
{
  8023a6:	55                   	push   %ebp
  8023a7:	89 e5                	mov    %esp,%ebp
  8023a9:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  8023ac:	a1 38 41 80 00       	mov    0x804138,%eax
  8023b1:	89 45 f4             	mov    %eax,-0xc(%ebp)

	while(tmp!=NULL)
  8023b4:	e9 76 01 00 00       	jmp    80252f <alloc_block_FF+0x189>
	{
		if(size==(tmp->size))
  8023b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8023bf:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023c2:	0f 85 8a 00 00 00    	jne    802452 <alloc_block_FF+0xac>
		{

			LIST_REMOVE(&FreeMemBlocksList,tmp);
  8023c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023cc:	75 17                	jne    8023e5 <alloc_block_FF+0x3f>
  8023ce:	83 ec 04             	sub    $0x4,%esp
  8023d1:	68 65 3d 80 00       	push   $0x803d65
  8023d6:	68 a8 00 00 00       	push   $0xa8
  8023db:	68 f3 3c 80 00       	push   $0x803cf3
  8023e0:	e8 5e 0d 00 00       	call   803143 <_panic>
  8023e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e8:	8b 00                	mov    (%eax),%eax
  8023ea:	85 c0                	test   %eax,%eax
  8023ec:	74 10                	je     8023fe <alloc_block_FF+0x58>
  8023ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f1:	8b 00                	mov    (%eax),%eax
  8023f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023f6:	8b 52 04             	mov    0x4(%edx),%edx
  8023f9:	89 50 04             	mov    %edx,0x4(%eax)
  8023fc:	eb 0b                	jmp    802409 <alloc_block_FF+0x63>
  8023fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802401:	8b 40 04             	mov    0x4(%eax),%eax
  802404:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802409:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240c:	8b 40 04             	mov    0x4(%eax),%eax
  80240f:	85 c0                	test   %eax,%eax
  802411:	74 0f                	je     802422 <alloc_block_FF+0x7c>
  802413:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802416:	8b 40 04             	mov    0x4(%eax),%eax
  802419:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80241c:	8b 12                	mov    (%edx),%edx
  80241e:	89 10                	mov    %edx,(%eax)
  802420:	eb 0a                	jmp    80242c <alloc_block_FF+0x86>
  802422:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802425:	8b 00                	mov    (%eax),%eax
  802427:	a3 38 41 80 00       	mov    %eax,0x804138
  80242c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802435:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802438:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80243f:	a1 44 41 80 00       	mov    0x804144,%eax
  802444:	48                   	dec    %eax
  802445:	a3 44 41 80 00       	mov    %eax,0x804144

			return tmp;
  80244a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244d:	e9 ea 00 00 00       	jmp    80253c <alloc_block_FF+0x196>

		}
		else if(size<tmp->size)
  802452:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802455:	8b 40 0c             	mov    0xc(%eax),%eax
  802458:	3b 45 08             	cmp    0x8(%ebp),%eax
  80245b:	0f 86 c6 00 00 00    	jbe    802527 <alloc_block_FF+0x181>
		{

			 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802461:	a1 48 41 80 00       	mov    0x804148,%eax
  802466:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 newBlock->size=size;
  802469:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80246c:	8b 55 08             	mov    0x8(%ebp),%edx
  80246f:	89 50 0c             	mov    %edx,0xc(%eax)
			 newBlock->sva=tmp->sva;
  802472:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802475:	8b 50 08             	mov    0x8(%eax),%edx
  802478:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80247b:	89 50 08             	mov    %edx,0x8(%eax)
			 tmp->size=tmp->size-size;
  80247e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802481:	8b 40 0c             	mov    0xc(%eax),%eax
  802484:	2b 45 08             	sub    0x8(%ebp),%eax
  802487:	89 c2                	mov    %eax,%edx
  802489:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248c:	89 50 0c             	mov    %edx,0xc(%eax)
			 tmp->sva=tmp->sva+size;
  80248f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802492:	8b 50 08             	mov    0x8(%eax),%edx
  802495:	8b 45 08             	mov    0x8(%ebp),%eax
  802498:	01 c2                	add    %eax,%edx
  80249a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249d:	89 50 08             	mov    %edx,0x8(%eax)

			 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  8024a0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024a4:	75 17                	jne    8024bd <alloc_block_FF+0x117>
  8024a6:	83 ec 04             	sub    $0x4,%esp
  8024a9:	68 65 3d 80 00       	push   $0x803d65
  8024ae:	68 b6 00 00 00       	push   $0xb6
  8024b3:	68 f3 3c 80 00       	push   $0x803cf3
  8024b8:	e8 86 0c 00 00       	call   803143 <_panic>
  8024bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024c0:	8b 00                	mov    (%eax),%eax
  8024c2:	85 c0                	test   %eax,%eax
  8024c4:	74 10                	je     8024d6 <alloc_block_FF+0x130>
  8024c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024c9:	8b 00                	mov    (%eax),%eax
  8024cb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024ce:	8b 52 04             	mov    0x4(%edx),%edx
  8024d1:	89 50 04             	mov    %edx,0x4(%eax)
  8024d4:	eb 0b                	jmp    8024e1 <alloc_block_FF+0x13b>
  8024d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024d9:	8b 40 04             	mov    0x4(%eax),%eax
  8024dc:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8024e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024e4:	8b 40 04             	mov    0x4(%eax),%eax
  8024e7:	85 c0                	test   %eax,%eax
  8024e9:	74 0f                	je     8024fa <alloc_block_FF+0x154>
  8024eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024ee:	8b 40 04             	mov    0x4(%eax),%eax
  8024f1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024f4:	8b 12                	mov    (%edx),%edx
  8024f6:	89 10                	mov    %edx,(%eax)
  8024f8:	eb 0a                	jmp    802504 <alloc_block_FF+0x15e>
  8024fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024fd:	8b 00                	mov    (%eax),%eax
  8024ff:	a3 48 41 80 00       	mov    %eax,0x804148
  802504:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802507:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80250d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802510:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802517:	a1 54 41 80 00       	mov    0x804154,%eax
  80251c:	48                   	dec    %eax
  80251d:	a3 54 41 80 00       	mov    %eax,0x804154
			 return newBlock;
  802522:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802525:	eb 15                	jmp    80253c <alloc_block_FF+0x196>

		}
		tmp=tmp->prev_next_info.le_next;
  802527:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252a:	8b 00                	mov    (%eax),%eax
  80252c:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;

	while(tmp!=NULL)
  80252f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802533:	0f 85 80 fe ff ff    	jne    8023b9 <alloc_block_FF+0x13>
			 return newBlock;

		}
		tmp=tmp->prev_next_info.le_next;
	}
	return tmp;
  802539:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80253c:	c9                   	leave  
  80253d:	c3                   	ret    

0080253e <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80253e:	55                   	push   %ebp
  80253f:	89 e5                	mov    %esp,%ebp
  802541:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  802544:	a1 38 41 80 00       	mov    0x804138,%eax
  802549:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 newSize=UINT_MAX;
  80254c:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)


		while(tmp!=NULL)
  802553:	e9 c0 00 00 00       	jmp    802618 <alloc_block_BF+0xda>
		{
			if(size==(tmp->size))
  802558:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255b:	8b 40 0c             	mov    0xc(%eax),%eax
  80255e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802561:	0f 85 8a 00 00 00    	jne    8025f1 <alloc_block_BF+0xb3>
			{
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  802567:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80256b:	75 17                	jne    802584 <alloc_block_BF+0x46>
  80256d:	83 ec 04             	sub    $0x4,%esp
  802570:	68 65 3d 80 00       	push   $0x803d65
  802575:	68 cf 00 00 00       	push   $0xcf
  80257a:	68 f3 3c 80 00       	push   $0x803cf3
  80257f:	e8 bf 0b 00 00       	call   803143 <_panic>
  802584:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802587:	8b 00                	mov    (%eax),%eax
  802589:	85 c0                	test   %eax,%eax
  80258b:	74 10                	je     80259d <alloc_block_BF+0x5f>
  80258d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802590:	8b 00                	mov    (%eax),%eax
  802592:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802595:	8b 52 04             	mov    0x4(%edx),%edx
  802598:	89 50 04             	mov    %edx,0x4(%eax)
  80259b:	eb 0b                	jmp    8025a8 <alloc_block_BF+0x6a>
  80259d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a0:	8b 40 04             	mov    0x4(%eax),%eax
  8025a3:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8025a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ab:	8b 40 04             	mov    0x4(%eax),%eax
  8025ae:	85 c0                	test   %eax,%eax
  8025b0:	74 0f                	je     8025c1 <alloc_block_BF+0x83>
  8025b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b5:	8b 40 04             	mov    0x4(%eax),%eax
  8025b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025bb:	8b 12                	mov    (%edx),%edx
  8025bd:	89 10                	mov    %edx,(%eax)
  8025bf:	eb 0a                	jmp    8025cb <alloc_block_BF+0x8d>
  8025c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c4:	8b 00                	mov    (%eax),%eax
  8025c6:	a3 38 41 80 00       	mov    %eax,0x804138
  8025cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025de:	a1 44 41 80 00       	mov    0x804144,%eax
  8025e3:	48                   	dec    %eax
  8025e4:	a3 44 41 80 00       	mov    %eax,0x804144
				return tmp;
  8025e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ec:	e9 2a 01 00 00       	jmp    80271b <alloc_block_BF+0x1dd>

			}
			else if (tmp->size<newSize&&tmp->size>size)
  8025f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f4:	8b 40 0c             	mov    0xc(%eax),%eax
  8025f7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8025fa:	73 14                	jae    802610 <alloc_block_BF+0xd2>
  8025fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ff:	8b 40 0c             	mov    0xc(%eax),%eax
  802602:	3b 45 08             	cmp    0x8(%ebp),%eax
  802605:	76 09                	jbe    802610 <alloc_block_BF+0xd2>
			{
				newSize=tmp->size;
  802607:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260a:	8b 40 0c             	mov    0xc(%eax),%eax
  80260d:	89 45 f0             	mov    %eax,-0x10(%ebp)


			}
			tmp=tmp->prev_next_info.le_next;
  802610:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802613:	8b 00                	mov    (%eax),%eax
  802615:	89 45 f4             	mov    %eax,-0xc(%ebp)

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
	uint32 newSize=UINT_MAX;


		while(tmp!=NULL)
  802618:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80261c:	0f 85 36 ff ff ff    	jne    802558 <alloc_block_BF+0x1a>
		}//tmp=NULL




			tmp =FreeMemBlocksList.lh_first;
  802622:	a1 38 41 80 00       	mov    0x804138,%eax
  802627:	89 45 f4             	mov    %eax,-0xc(%ebp)
			while(tmp!=NULL)
  80262a:	e9 dd 00 00 00       	jmp    80270c <alloc_block_BF+0x1ce>
			{
				if(tmp->size==newSize)
  80262f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802632:	8b 40 0c             	mov    0xc(%eax),%eax
  802635:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802638:	0f 85 c6 00 00 00    	jne    802704 <alloc_block_BF+0x1c6>
					{
					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  80263e:	a1 48 41 80 00       	mov    0x804148,%eax
  802643:	89 45 ec             	mov    %eax,-0x14(%ebp)

								 newBlock->sva=tmp->sva;     //newBlock.sva=tmp.sva
  802646:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802649:	8b 50 08             	mov    0x8(%eax),%edx
  80264c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80264f:	89 50 08             	mov    %edx,0x8(%eax)
								 newBlock->size=size;
  802652:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802655:	8b 55 08             	mov    0x8(%ebp),%edx
  802658:	89 50 0c             	mov    %edx,0xc(%eax)

											 tmp->sva+=size;
  80265b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265e:	8b 50 08             	mov    0x8(%eax),%edx
  802661:	8b 45 08             	mov    0x8(%ebp),%eax
  802664:	01 c2                	add    %eax,%edx
  802666:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802669:	89 50 08             	mov    %edx,0x8(%eax)
											 tmp->size-=size;
  80266c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266f:	8b 40 0c             	mov    0xc(%eax),%eax
  802672:	2b 45 08             	sub    0x8(%ebp),%eax
  802675:	89 c2                	mov    %eax,%edx
  802677:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267a:	89 50 0c             	mov    %edx,0xc(%eax)
											 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  80267d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802681:	75 17                	jne    80269a <alloc_block_BF+0x15c>
  802683:	83 ec 04             	sub    $0x4,%esp
  802686:	68 65 3d 80 00       	push   $0x803d65
  80268b:	68 eb 00 00 00       	push   $0xeb
  802690:	68 f3 3c 80 00       	push   $0x803cf3
  802695:	e8 a9 0a 00 00       	call   803143 <_panic>
  80269a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80269d:	8b 00                	mov    (%eax),%eax
  80269f:	85 c0                	test   %eax,%eax
  8026a1:	74 10                	je     8026b3 <alloc_block_BF+0x175>
  8026a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026a6:	8b 00                	mov    (%eax),%eax
  8026a8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026ab:	8b 52 04             	mov    0x4(%edx),%edx
  8026ae:	89 50 04             	mov    %edx,0x4(%eax)
  8026b1:	eb 0b                	jmp    8026be <alloc_block_BF+0x180>
  8026b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026b6:	8b 40 04             	mov    0x4(%eax),%eax
  8026b9:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8026be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026c1:	8b 40 04             	mov    0x4(%eax),%eax
  8026c4:	85 c0                	test   %eax,%eax
  8026c6:	74 0f                	je     8026d7 <alloc_block_BF+0x199>
  8026c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026cb:	8b 40 04             	mov    0x4(%eax),%eax
  8026ce:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026d1:	8b 12                	mov    (%edx),%edx
  8026d3:	89 10                	mov    %edx,(%eax)
  8026d5:	eb 0a                	jmp    8026e1 <alloc_block_BF+0x1a3>
  8026d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026da:	8b 00                	mov    (%eax),%eax
  8026dc:	a3 48 41 80 00       	mov    %eax,0x804148
  8026e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026e4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026ed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026f4:	a1 54 41 80 00       	mov    0x804154,%eax
  8026f9:	48                   	dec    %eax
  8026fa:	a3 54 41 80 00       	mov    %eax,0x804154
											 return newBlock;
  8026ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802702:	eb 17                	jmp    80271b <alloc_block_BF+0x1dd>

					}
				tmp=tmp->prev_next_info.le_next;
  802704:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802707:	8b 00                	mov    (%eax),%eax
  802709:	89 45 f4             	mov    %eax,-0xc(%ebp)




			tmp =FreeMemBlocksList.lh_first;
			while(tmp!=NULL)
  80270c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802710:	0f 85 19 ff ff ff    	jne    80262f <alloc_block_BF+0xf1>
			//tmp ->  block newSize,Sva




		return NULL; //return NULL
  802716:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  80271b:	c9                   	leave  
  80271c:	c3                   	ret    

0080271d <alloc_block_NF>:
//=========================================



struct MemBlock *alloc_block_NF(uint32 size)
{
  80271d:	55                   	push   %ebp
  80271e:	89 e5                	mov    %esp,%ebp
  802720:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp1;
	uint32 currentSva;
	if(AllocMemBlocksList.lh_first==NULL)
  802723:	a1 40 40 80 00       	mov    0x804040,%eax
  802728:	85 c0                	test   %eax,%eax
  80272a:	75 19                	jne    802745 <alloc_block_NF+0x28>
	{
		tmp1=alloc_block_FF(size);
  80272c:	83 ec 0c             	sub    $0xc,%esp
  80272f:	ff 75 08             	pushl  0x8(%ebp)
  802732:	e8 6f fc ff ff       	call   8023a6 <alloc_block_FF>
  802737:	83 c4 10             	add    $0x10,%esp
  80273a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		return tmp1;
  80273d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802740:	e9 e9 01 00 00       	jmp    80292e <alloc_block_NF+0x211>
	}

			else
			{
            currentSva=AllocMemBlocksList.lh_last->sva;
  802745:	a1 44 40 80 00       	mov    0x804044,%eax
  80274a:	8b 40 08             	mov    0x8(%eax),%eax
  80274d:	89 45 f0             	mov    %eax,-0x10(%ebp)
			tmp1=find_block(&FreeMemBlocksList,AllocMemBlocksList.lh_last->size+AllocMemBlocksList.lh_last->sva);
  802750:	a1 44 40 80 00       	mov    0x804044,%eax
  802755:	8b 50 0c             	mov    0xc(%eax),%edx
  802758:	a1 44 40 80 00       	mov    0x804044,%eax
  80275d:	8b 40 08             	mov    0x8(%eax),%eax
  802760:	01 d0                	add    %edx,%eax
  802762:	83 ec 08             	sub    $0x8,%esp
  802765:	50                   	push   %eax
  802766:	68 38 41 80 00       	push   $0x804138
  80276b:	e8 54 fa ff ff       	call   8021c4 <find_block>
  802770:	83 c4 10             	add    $0x10,%esp
  802773:	89 45 f4             	mov    %eax,-0xc(%ebp)


do
	{

		if(size==(tmp1->size))
  802776:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802779:	8b 40 0c             	mov    0xc(%eax),%eax
  80277c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80277f:	0f 85 9b 00 00 00    	jne    802820 <alloc_block_NF+0x103>
				{
			currentSva=tmp1->size+tmp1->sva;
  802785:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802788:	8b 50 0c             	mov    0xc(%eax),%edx
  80278b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278e:	8b 40 08             	mov    0x8(%eax),%eax
  802791:	01 d0                	add    %edx,%eax
  802793:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,tmp1);
  802796:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80279a:	75 17                	jne    8027b3 <alloc_block_NF+0x96>
  80279c:	83 ec 04             	sub    $0x4,%esp
  80279f:	68 65 3d 80 00       	push   $0x803d65
  8027a4:	68 1a 01 00 00       	push   $0x11a
  8027a9:	68 f3 3c 80 00       	push   $0x803cf3
  8027ae:	e8 90 09 00 00       	call   803143 <_panic>
  8027b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b6:	8b 00                	mov    (%eax),%eax
  8027b8:	85 c0                	test   %eax,%eax
  8027ba:	74 10                	je     8027cc <alloc_block_NF+0xaf>
  8027bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027bf:	8b 00                	mov    (%eax),%eax
  8027c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027c4:	8b 52 04             	mov    0x4(%edx),%edx
  8027c7:	89 50 04             	mov    %edx,0x4(%eax)
  8027ca:	eb 0b                	jmp    8027d7 <alloc_block_NF+0xba>
  8027cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cf:	8b 40 04             	mov    0x4(%eax),%eax
  8027d2:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8027d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027da:	8b 40 04             	mov    0x4(%eax),%eax
  8027dd:	85 c0                	test   %eax,%eax
  8027df:	74 0f                	je     8027f0 <alloc_block_NF+0xd3>
  8027e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e4:	8b 40 04             	mov    0x4(%eax),%eax
  8027e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027ea:	8b 12                	mov    (%edx),%edx
  8027ec:	89 10                	mov    %edx,(%eax)
  8027ee:	eb 0a                	jmp    8027fa <alloc_block_NF+0xdd>
  8027f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f3:	8b 00                	mov    (%eax),%eax
  8027f5:	a3 38 41 80 00       	mov    %eax,0x804138
  8027fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802803:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802806:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80280d:	a1 44 41 80 00       	mov    0x804144,%eax
  802812:	48                   	dec    %eax
  802813:	a3 44 41 80 00       	mov    %eax,0x804144
					return tmp1;
  802818:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281b:	e9 0e 01 00 00       	jmp    80292e <alloc_block_NF+0x211>

				}
				else if(size<tmp1->size)
  802820:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802823:	8b 40 0c             	mov    0xc(%eax),%eax
  802826:	3b 45 08             	cmp    0x8(%ebp),%eax
  802829:	0f 86 cf 00 00 00    	jbe    8028fe <alloc_block_NF+0x1e1>
				{

					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  80282f:	a1 48 41 80 00       	mov    0x804148,%eax
  802834:	89 45 ec             	mov    %eax,-0x14(%ebp)
					 newBlock->size=size;
  802837:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80283a:	8b 55 08             	mov    0x8(%ebp),%edx
  80283d:	89 50 0c             	mov    %edx,0xc(%eax)
					 newBlock->sva=tmp1->sva;
  802840:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802843:	8b 50 08             	mov    0x8(%eax),%edx
  802846:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802849:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->sva+=size;
  80284c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284f:	8b 50 08             	mov    0x8(%eax),%edx
  802852:	8b 45 08             	mov    0x8(%ebp),%eax
  802855:	01 c2                	add    %eax,%edx
  802857:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285a:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->size-=size;
  80285d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802860:	8b 40 0c             	mov    0xc(%eax),%eax
  802863:	2b 45 08             	sub    0x8(%ebp),%eax
  802866:	89 c2                	mov    %eax,%edx
  802868:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286b:	89 50 0c             	mov    %edx,0xc(%eax)
                     currentSva=tmp1->sva;
  80286e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802871:	8b 40 08             	mov    0x8(%eax),%eax
  802874:	89 45 f0             	mov    %eax,-0x10(%ebp)

					 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802877:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80287b:	75 17                	jne    802894 <alloc_block_NF+0x177>
  80287d:	83 ec 04             	sub    $0x4,%esp
  802880:	68 65 3d 80 00       	push   $0x803d65
  802885:	68 28 01 00 00       	push   $0x128
  80288a:	68 f3 3c 80 00       	push   $0x803cf3
  80288f:	e8 af 08 00 00       	call   803143 <_panic>
  802894:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802897:	8b 00                	mov    (%eax),%eax
  802899:	85 c0                	test   %eax,%eax
  80289b:	74 10                	je     8028ad <alloc_block_NF+0x190>
  80289d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028a0:	8b 00                	mov    (%eax),%eax
  8028a2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028a5:	8b 52 04             	mov    0x4(%edx),%edx
  8028a8:	89 50 04             	mov    %edx,0x4(%eax)
  8028ab:	eb 0b                	jmp    8028b8 <alloc_block_NF+0x19b>
  8028ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028b0:	8b 40 04             	mov    0x4(%eax),%eax
  8028b3:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8028b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028bb:	8b 40 04             	mov    0x4(%eax),%eax
  8028be:	85 c0                	test   %eax,%eax
  8028c0:	74 0f                	je     8028d1 <alloc_block_NF+0x1b4>
  8028c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028c5:	8b 40 04             	mov    0x4(%eax),%eax
  8028c8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028cb:	8b 12                	mov    (%edx),%edx
  8028cd:	89 10                	mov    %edx,(%eax)
  8028cf:	eb 0a                	jmp    8028db <alloc_block_NF+0x1be>
  8028d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028d4:	8b 00                	mov    (%eax),%eax
  8028d6:	a3 48 41 80 00       	mov    %eax,0x804148
  8028db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028e7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028ee:	a1 54 41 80 00       	mov    0x804154,%eax
  8028f3:	48                   	dec    %eax
  8028f4:	a3 54 41 80 00       	mov    %eax,0x804154
					 return newBlock;
  8028f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028fc:	eb 30                	jmp    80292e <alloc_block_NF+0x211>

				}
		if(tmp1==FreeMemBlocksList.lh_last)
  8028fe:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802903:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802906:	75 0a                	jne    802912 <alloc_block_NF+0x1f5>
			tmp1=FreeMemBlocksList.lh_first;
  802908:	a1 38 41 80 00       	mov    0x804138,%eax
  80290d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802910:	eb 08                	jmp    80291a <alloc_block_NF+0x1fd>
		else
				tmp1=tmp1->prev_next_info.le_next;
  802912:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802915:	8b 00                	mov    (%eax),%eax
  802917:	89 45 f4             	mov    %eax,-0xc(%ebp)


			}
while(tmp1->sva!=currentSva);
  80291a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291d:	8b 40 08             	mov    0x8(%eax),%eax
  802920:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802923:	0f 85 4d fe ff ff    	jne    802776 <alloc_block_NF+0x59>

			return NULL;
  802929:	b8 00 00 00 00       	mov    $0x0,%eax

	}
  80292e:	c9                   	leave  
  80292f:	c3                   	ret    

00802930 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802930:	55                   	push   %ebp
  802931:	89 e5                	mov    %esp,%ebp
  802933:	53                   	push   %ebx
  802934:	83 ec 14             	sub    $0x14,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	if(FreeMemBlocksList.lh_first==NULL)
  802937:	a1 38 41 80 00       	mov    0x804138,%eax
  80293c:	85 c0                	test   %eax,%eax
  80293e:	0f 85 86 00 00 00    	jne    8029ca <insert_sorted_with_merge_freeList+0x9a>
	{
		LIST_INIT(&FreeMemBlocksList);
  802944:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  80294b:	00 00 00 
  80294e:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  802955:	00 00 00 
  802958:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  80295f:	00 00 00 
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802962:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802966:	75 17                	jne    80297f <insert_sorted_with_merge_freeList+0x4f>
  802968:	83 ec 04             	sub    $0x4,%esp
  80296b:	68 d0 3c 80 00       	push   $0x803cd0
  802970:	68 48 01 00 00       	push   $0x148
  802975:	68 f3 3c 80 00       	push   $0x803cf3
  80297a:	e8 c4 07 00 00       	call   803143 <_panic>
  80297f:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802985:	8b 45 08             	mov    0x8(%ebp),%eax
  802988:	89 10                	mov    %edx,(%eax)
  80298a:	8b 45 08             	mov    0x8(%ebp),%eax
  80298d:	8b 00                	mov    (%eax),%eax
  80298f:	85 c0                	test   %eax,%eax
  802991:	74 0d                	je     8029a0 <insert_sorted_with_merge_freeList+0x70>
  802993:	a1 38 41 80 00       	mov    0x804138,%eax
  802998:	8b 55 08             	mov    0x8(%ebp),%edx
  80299b:	89 50 04             	mov    %edx,0x4(%eax)
  80299e:	eb 08                	jmp    8029a8 <insert_sorted_with_merge_freeList+0x78>
  8029a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a3:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8029a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ab:	a3 38 41 80 00       	mov    %eax,0x804138
  8029b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029ba:	a1 44 41 80 00       	mov    0x804144,%eax
  8029bf:	40                   	inc    %eax
  8029c0:	a3 44 41 80 00       	mov    %eax,0x804144
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  8029c5:	e9 73 07 00 00       	jmp    80313d <insert_sorted_with_merge_freeList+0x80d>
	if(FreeMemBlocksList.lh_first==NULL)
	{
		LIST_INIT(&FreeMemBlocksList);
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva!=(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  8029ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8029cd:	8b 50 08             	mov    0x8(%eax),%edx
  8029d0:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8029d5:	8b 40 08             	mov    0x8(%eax),%eax
  8029d8:	39 c2                	cmp    %eax,%edx
  8029da:	0f 86 84 00 00 00    	jbe    802a64 <insert_sorted_with_merge_freeList+0x134>
  8029e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e3:	8b 50 08             	mov    0x8(%eax),%edx
  8029e6:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8029eb:	8b 48 0c             	mov    0xc(%eax),%ecx
  8029ee:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8029f3:	8b 40 08             	mov    0x8(%eax),%eax
  8029f6:	01 c8                	add    %ecx,%eax
  8029f8:	39 c2                	cmp    %eax,%edx
  8029fa:	74 68                	je     802a64 <insert_sorted_with_merge_freeList+0x134>
	{
		LIST_INSERT_TAIL(&FreeMemBlocksList,blockToInsert);
  8029fc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a00:	75 17                	jne    802a19 <insert_sorted_with_merge_freeList+0xe9>
  802a02:	83 ec 04             	sub    $0x4,%esp
  802a05:	68 0c 3d 80 00       	push   $0x803d0c
  802a0a:	68 4c 01 00 00       	push   $0x14c
  802a0f:	68 f3 3c 80 00       	push   $0x803cf3
  802a14:	e8 2a 07 00 00       	call   803143 <_panic>
  802a19:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a22:	89 50 04             	mov    %edx,0x4(%eax)
  802a25:	8b 45 08             	mov    0x8(%ebp),%eax
  802a28:	8b 40 04             	mov    0x4(%eax),%eax
  802a2b:	85 c0                	test   %eax,%eax
  802a2d:	74 0c                	je     802a3b <insert_sorted_with_merge_freeList+0x10b>
  802a2f:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a34:	8b 55 08             	mov    0x8(%ebp),%edx
  802a37:	89 10                	mov    %edx,(%eax)
  802a39:	eb 08                	jmp    802a43 <insert_sorted_with_merge_freeList+0x113>
  802a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3e:	a3 38 41 80 00       	mov    %eax,0x804138
  802a43:	8b 45 08             	mov    0x8(%ebp),%eax
  802a46:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a54:	a1 44 41 80 00       	mov    0x804144,%eax
  802a59:	40                   	inc    %eax
  802a5a:	a3 44 41 80 00       	mov    %eax,0x804144
  802a5f:	e9 d9 06 00 00       	jmp    80313d <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva==(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  802a64:	8b 45 08             	mov    0x8(%ebp),%eax
  802a67:	8b 50 08             	mov    0x8(%eax),%edx
  802a6a:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a6f:	8b 40 08             	mov    0x8(%eax),%eax
  802a72:	39 c2                	cmp    %eax,%edx
  802a74:	0f 86 b5 00 00 00    	jbe    802b2f <insert_sorted_with_merge_freeList+0x1ff>
  802a7a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a7d:	8b 50 08             	mov    0x8(%eax),%edx
  802a80:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a85:	8b 48 0c             	mov    0xc(%eax),%ecx
  802a88:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a8d:	8b 40 08             	mov    0x8(%eax),%eax
  802a90:	01 c8                	add    %ecx,%eax
  802a92:	39 c2                	cmp    %eax,%edx
  802a94:	0f 85 95 00 00 00    	jne    802b2f <insert_sorted_with_merge_freeList+0x1ff>

	{
		FreeMemBlocksList.lh_last->size+=blockToInsert->size;
  802a9a:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a9f:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802aa5:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802aa8:	8b 55 08             	mov    0x8(%ebp),%edx
  802aab:	8b 52 0c             	mov    0xc(%edx),%edx
  802aae:	01 ca                	add    %ecx,%edx
  802ab0:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802abd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802ac7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802acb:	75 17                	jne    802ae4 <insert_sorted_with_merge_freeList+0x1b4>
  802acd:	83 ec 04             	sub    $0x4,%esp
  802ad0:	68 d0 3c 80 00       	push   $0x803cd0
  802ad5:	68 54 01 00 00       	push   $0x154
  802ada:	68 f3 3c 80 00       	push   $0x803cf3
  802adf:	e8 5f 06 00 00       	call   803143 <_panic>
  802ae4:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802aea:	8b 45 08             	mov    0x8(%ebp),%eax
  802aed:	89 10                	mov    %edx,(%eax)
  802aef:	8b 45 08             	mov    0x8(%ebp),%eax
  802af2:	8b 00                	mov    (%eax),%eax
  802af4:	85 c0                	test   %eax,%eax
  802af6:	74 0d                	je     802b05 <insert_sorted_with_merge_freeList+0x1d5>
  802af8:	a1 48 41 80 00       	mov    0x804148,%eax
  802afd:	8b 55 08             	mov    0x8(%ebp),%edx
  802b00:	89 50 04             	mov    %edx,0x4(%eax)
  802b03:	eb 08                	jmp    802b0d <insert_sorted_with_merge_freeList+0x1dd>
  802b05:	8b 45 08             	mov    0x8(%ebp),%eax
  802b08:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b10:	a3 48 41 80 00       	mov    %eax,0x804148
  802b15:	8b 45 08             	mov    0x8(%ebp),%eax
  802b18:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b1f:	a1 54 41 80 00       	mov    0x804154,%eax
  802b24:	40                   	inc    %eax
  802b25:	a3 54 41 80 00       	mov    %eax,0x804154
  802b2a:	e9 0e 06 00 00       	jmp    80313d <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva==(blockToInsert->sva+blockToInsert->size))
  802b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b32:	8b 50 08             	mov    0x8(%eax),%edx
  802b35:	a1 38 41 80 00       	mov    0x804138,%eax
  802b3a:	8b 40 08             	mov    0x8(%eax),%eax
  802b3d:	39 c2                	cmp    %eax,%edx
  802b3f:	0f 83 c1 00 00 00    	jae    802c06 <insert_sorted_with_merge_freeList+0x2d6>
  802b45:	a1 38 41 80 00       	mov    0x804138,%eax
  802b4a:	8b 50 08             	mov    0x8(%eax),%edx
  802b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b50:	8b 48 08             	mov    0x8(%eax),%ecx
  802b53:	8b 45 08             	mov    0x8(%ebp),%eax
  802b56:	8b 40 0c             	mov    0xc(%eax),%eax
  802b59:	01 c8                	add    %ecx,%eax
  802b5b:	39 c2                	cmp    %eax,%edx
  802b5d:	0f 85 a3 00 00 00    	jne    802c06 <insert_sorted_with_merge_freeList+0x2d6>
	{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  802b63:	a1 38 41 80 00       	mov    0x804138,%eax
  802b68:	8b 55 08             	mov    0x8(%ebp),%edx
  802b6b:	8b 52 08             	mov    0x8(%edx),%edx
  802b6e:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size+=blockToInsert->size;
  802b71:	a1 38 41 80 00       	mov    0x804138,%eax
  802b76:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802b7c:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802b7f:	8b 55 08             	mov    0x8(%ebp),%edx
  802b82:	8b 52 0c             	mov    0xc(%edx),%edx
  802b85:	01 ca                	add    %ecx,%edx
  802b87:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->sva=0;
  802b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		blockToInsert->size=0;
  802b94:	8b 45 08             	mov    0x8(%ebp),%eax
  802b97:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)

		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802b9e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ba2:	75 17                	jne    802bbb <insert_sorted_with_merge_freeList+0x28b>
  802ba4:	83 ec 04             	sub    $0x4,%esp
  802ba7:	68 d0 3c 80 00       	push   $0x803cd0
  802bac:	68 5d 01 00 00       	push   $0x15d
  802bb1:	68 f3 3c 80 00       	push   $0x803cf3
  802bb6:	e8 88 05 00 00       	call   803143 <_panic>
  802bbb:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802bc1:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc4:	89 10                	mov    %edx,(%eax)
  802bc6:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc9:	8b 00                	mov    (%eax),%eax
  802bcb:	85 c0                	test   %eax,%eax
  802bcd:	74 0d                	je     802bdc <insert_sorted_with_merge_freeList+0x2ac>
  802bcf:	a1 48 41 80 00       	mov    0x804148,%eax
  802bd4:	8b 55 08             	mov    0x8(%ebp),%edx
  802bd7:	89 50 04             	mov    %edx,0x4(%eax)
  802bda:	eb 08                	jmp    802be4 <insert_sorted_with_merge_freeList+0x2b4>
  802bdc:	8b 45 08             	mov    0x8(%ebp),%eax
  802bdf:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802be4:	8b 45 08             	mov    0x8(%ebp),%eax
  802be7:	a3 48 41 80 00       	mov    %eax,0x804148
  802bec:	8b 45 08             	mov    0x8(%ebp),%eax
  802bef:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bf6:	a1 54 41 80 00       	mov    0x804154,%eax
  802bfb:	40                   	inc    %eax
  802bfc:	a3 54 41 80 00       	mov    %eax,0x804154
  802c01:	e9 37 05 00 00       	jmp    80313d <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva!=(blockToInsert->sva+blockToInsert->size))
  802c06:	8b 45 08             	mov    0x8(%ebp),%eax
  802c09:	8b 50 08             	mov    0x8(%eax),%edx
  802c0c:	a1 38 41 80 00       	mov    0x804138,%eax
  802c11:	8b 40 08             	mov    0x8(%eax),%eax
  802c14:	39 c2                	cmp    %eax,%edx
  802c16:	0f 83 82 00 00 00    	jae    802c9e <insert_sorted_with_merge_freeList+0x36e>
  802c1c:	a1 38 41 80 00       	mov    0x804138,%eax
  802c21:	8b 50 08             	mov    0x8(%eax),%edx
  802c24:	8b 45 08             	mov    0x8(%ebp),%eax
  802c27:	8b 48 08             	mov    0x8(%eax),%ecx
  802c2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2d:	8b 40 0c             	mov    0xc(%eax),%eax
  802c30:	01 c8                	add    %ecx,%eax
  802c32:	39 c2                	cmp    %eax,%edx
  802c34:	74 68                	je     802c9e <insert_sorted_with_merge_freeList+0x36e>

	{
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802c36:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c3a:	75 17                	jne    802c53 <insert_sorted_with_merge_freeList+0x323>
  802c3c:	83 ec 04             	sub    $0x4,%esp
  802c3f:	68 d0 3c 80 00       	push   $0x803cd0
  802c44:	68 62 01 00 00       	push   $0x162
  802c49:	68 f3 3c 80 00       	push   $0x803cf3
  802c4e:	e8 f0 04 00 00       	call   803143 <_panic>
  802c53:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802c59:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5c:	89 10                	mov    %edx,(%eax)
  802c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c61:	8b 00                	mov    (%eax),%eax
  802c63:	85 c0                	test   %eax,%eax
  802c65:	74 0d                	je     802c74 <insert_sorted_with_merge_freeList+0x344>
  802c67:	a1 38 41 80 00       	mov    0x804138,%eax
  802c6c:	8b 55 08             	mov    0x8(%ebp),%edx
  802c6f:	89 50 04             	mov    %edx,0x4(%eax)
  802c72:	eb 08                	jmp    802c7c <insert_sorted_with_merge_freeList+0x34c>
  802c74:	8b 45 08             	mov    0x8(%ebp),%eax
  802c77:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7f:	a3 38 41 80 00       	mov    %eax,0x804138
  802c84:	8b 45 08             	mov    0x8(%ebp),%eax
  802c87:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c8e:	a1 44 41 80 00       	mov    0x804144,%eax
  802c93:	40                   	inc    %eax
  802c94:	a3 44 41 80 00       	mov    %eax,0x804144
  802c99:	e9 9f 04 00 00       	jmp    80313d <insert_sorted_with_merge_freeList+0x80d>
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
  802c9e:	a1 38 41 80 00       	mov    0x804138,%eax
  802ca3:	8b 00                	mov    (%eax),%eax
  802ca5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  802ca8:	e9 84 04 00 00       	jmp    803131 <insert_sorted_with_merge_freeList+0x801>
		{
			if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802cad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb0:	8b 50 08             	mov    0x8(%eax),%edx
  802cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb6:	8b 40 08             	mov    0x8(%eax),%eax
  802cb9:	39 c2                	cmp    %eax,%edx
  802cbb:	0f 86 a9 00 00 00    	jbe    802d6a <insert_sorted_with_merge_freeList+0x43a>
  802cc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc4:	8b 50 08             	mov    0x8(%eax),%edx
  802cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  802cca:	8b 48 08             	mov    0x8(%eax),%ecx
  802ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd0:	8b 40 0c             	mov    0xc(%eax),%eax
  802cd3:	01 c8                	add    %ecx,%eax
  802cd5:	39 c2                	cmp    %eax,%edx
  802cd7:	0f 84 8d 00 00 00    	je     802d6a <insert_sorted_with_merge_freeList+0x43a>
  802cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce0:	8b 50 08             	mov    0x8(%eax),%edx
  802ce3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce6:	8b 40 04             	mov    0x4(%eax),%eax
  802ce9:	8b 48 08             	mov    0x8(%eax),%ecx
  802cec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cef:	8b 40 04             	mov    0x4(%eax),%eax
  802cf2:	8b 40 0c             	mov    0xc(%eax),%eax
  802cf5:	01 c8                	add    %ecx,%eax
  802cf7:	39 c2                	cmp    %eax,%edx
  802cf9:	74 6f                	je     802d6a <insert_sorted_with_merge_freeList+0x43a>
			{
				LIST_INSERT_BEFORE(&FreeMemBlocksList,tmp,blockToInsert);
  802cfb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cff:	74 06                	je     802d07 <insert_sorted_with_merge_freeList+0x3d7>
  802d01:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d05:	75 17                	jne    802d1e <insert_sorted_with_merge_freeList+0x3ee>
  802d07:	83 ec 04             	sub    $0x4,%esp
  802d0a:	68 30 3d 80 00       	push   $0x803d30
  802d0f:	68 6b 01 00 00       	push   $0x16b
  802d14:	68 f3 3c 80 00       	push   $0x803cf3
  802d19:	e8 25 04 00 00       	call   803143 <_panic>
  802d1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d21:	8b 50 04             	mov    0x4(%eax),%edx
  802d24:	8b 45 08             	mov    0x8(%ebp),%eax
  802d27:	89 50 04             	mov    %edx,0x4(%eax)
  802d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d30:	89 10                	mov    %edx,(%eax)
  802d32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d35:	8b 40 04             	mov    0x4(%eax),%eax
  802d38:	85 c0                	test   %eax,%eax
  802d3a:	74 0d                	je     802d49 <insert_sorted_with_merge_freeList+0x419>
  802d3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3f:	8b 40 04             	mov    0x4(%eax),%eax
  802d42:	8b 55 08             	mov    0x8(%ebp),%edx
  802d45:	89 10                	mov    %edx,(%eax)
  802d47:	eb 08                	jmp    802d51 <insert_sorted_with_merge_freeList+0x421>
  802d49:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4c:	a3 38 41 80 00       	mov    %eax,0x804138
  802d51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d54:	8b 55 08             	mov    0x8(%ebp),%edx
  802d57:	89 50 04             	mov    %edx,0x4(%eax)
  802d5a:	a1 44 41 80 00       	mov    0x804144,%eax
  802d5f:	40                   	inc    %eax
  802d60:	a3 44 41 80 00       	mov    %eax,0x804144
				break;
  802d65:	e9 d3 03 00 00       	jmp    80313d <insert_sorted_with_merge_freeList+0x80d>
			}// no merge
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802d6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6d:	8b 50 08             	mov    0x8(%eax),%edx
  802d70:	8b 45 08             	mov    0x8(%ebp),%eax
  802d73:	8b 40 08             	mov    0x8(%eax),%eax
  802d76:	39 c2                	cmp    %eax,%edx
  802d78:	0f 86 da 00 00 00    	jbe    802e58 <insert_sorted_with_merge_freeList+0x528>
  802d7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d81:	8b 50 08             	mov    0x8(%eax),%edx
  802d84:	8b 45 08             	mov    0x8(%ebp),%eax
  802d87:	8b 48 08             	mov    0x8(%eax),%ecx
  802d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8d:	8b 40 0c             	mov    0xc(%eax),%eax
  802d90:	01 c8                	add    %ecx,%eax
  802d92:	39 c2                	cmp    %eax,%edx
  802d94:	0f 85 be 00 00 00    	jne    802e58 <insert_sorted_with_merge_freeList+0x528>
  802d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9d:	8b 50 08             	mov    0x8(%eax),%edx
  802da0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da3:	8b 40 04             	mov    0x4(%eax),%eax
  802da6:	8b 48 08             	mov    0x8(%eax),%ecx
  802da9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dac:	8b 40 04             	mov    0x4(%eax),%eax
  802daf:	8b 40 0c             	mov    0xc(%eax),%eax
  802db2:	01 c8                	add    %ecx,%eax
  802db4:	39 c2                	cmp    %eax,%edx
  802db6:	0f 84 9c 00 00 00    	je     802e58 <insert_sorted_with_merge_freeList+0x528>
			{
tmp->sva=blockToInsert->sva;
  802dbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbf:	8b 50 08             	mov    0x8(%eax),%edx
  802dc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc5:	89 50 08             	mov    %edx,0x8(%eax)
tmp->size+=blockToInsert->size;
  802dc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dcb:	8b 50 0c             	mov    0xc(%eax),%edx
  802dce:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd1:	8b 40 0c             	mov    0xc(%eax),%eax
  802dd4:	01 c2                	add    %eax,%edx
  802dd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd9:	89 50 0c             	mov    %edx,0xc(%eax)
blockToInsert->sva=0;
  802ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ddf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
blockToInsert->size=0;
  802de6:	8b 45 08             	mov    0x8(%ebp),%eax
  802de9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802df0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802df4:	75 17                	jne    802e0d <insert_sorted_with_merge_freeList+0x4dd>
  802df6:	83 ec 04             	sub    $0x4,%esp
  802df9:	68 d0 3c 80 00       	push   $0x803cd0
  802dfe:	68 74 01 00 00       	push   $0x174
  802e03:	68 f3 3c 80 00       	push   $0x803cf3
  802e08:	e8 36 03 00 00       	call   803143 <_panic>
  802e0d:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e13:	8b 45 08             	mov    0x8(%ebp),%eax
  802e16:	89 10                	mov    %edx,(%eax)
  802e18:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1b:	8b 00                	mov    (%eax),%eax
  802e1d:	85 c0                	test   %eax,%eax
  802e1f:	74 0d                	je     802e2e <insert_sorted_with_merge_freeList+0x4fe>
  802e21:	a1 48 41 80 00       	mov    0x804148,%eax
  802e26:	8b 55 08             	mov    0x8(%ebp),%edx
  802e29:	89 50 04             	mov    %edx,0x4(%eax)
  802e2c:	eb 08                	jmp    802e36 <insert_sorted_with_merge_freeList+0x506>
  802e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e31:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e36:	8b 45 08             	mov    0x8(%ebp),%eax
  802e39:	a3 48 41 80 00       	mov    %eax,0x804148
  802e3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e41:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e48:	a1 54 41 80 00       	mov    0x804154,%eax
  802e4d:	40                   	inc    %eax
  802e4e:	a3 54 41 80 00       	mov    %eax,0x804154
break;
  802e53:	e9 e5 02 00 00       	jmp    80313d <insert_sorted_with_merge_freeList+0x80d>
			}//merge with the next
			else if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802e58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5b:	8b 50 08             	mov    0x8(%eax),%edx
  802e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e61:	8b 40 08             	mov    0x8(%eax),%eax
  802e64:	39 c2                	cmp    %eax,%edx
  802e66:	0f 86 d7 00 00 00    	jbe    802f43 <insert_sorted_with_merge_freeList+0x613>
  802e6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6f:	8b 50 08             	mov    0x8(%eax),%edx
  802e72:	8b 45 08             	mov    0x8(%ebp),%eax
  802e75:	8b 48 08             	mov    0x8(%eax),%ecx
  802e78:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7b:	8b 40 0c             	mov    0xc(%eax),%eax
  802e7e:	01 c8                	add    %ecx,%eax
  802e80:	39 c2                	cmp    %eax,%edx
  802e82:	0f 84 bb 00 00 00    	je     802f43 <insert_sorted_with_merge_freeList+0x613>
  802e88:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8b:	8b 50 08             	mov    0x8(%eax),%edx
  802e8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e91:	8b 40 04             	mov    0x4(%eax),%eax
  802e94:	8b 48 08             	mov    0x8(%eax),%ecx
  802e97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9a:	8b 40 04             	mov    0x4(%eax),%eax
  802e9d:	8b 40 0c             	mov    0xc(%eax),%eax
  802ea0:	01 c8                	add    %ecx,%eax
  802ea2:	39 c2                	cmp    %eax,%edx
  802ea4:	0f 85 99 00 00 00    	jne    802f43 <insert_sorted_with_merge_freeList+0x613>
			{
				struct MemBlock *ptr=LIST_PREV(tmp);
  802eaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ead:	8b 40 04             	mov    0x4(%eax),%eax
  802eb0:	89 45 f0             	mov    %eax,-0x10(%ebp)
				ptr->size+=blockToInsert->size;
  802eb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eb6:	8b 50 0c             	mov    0xc(%eax),%edx
  802eb9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebc:	8b 40 0c             	mov    0xc(%eax),%eax
  802ebf:	01 c2                	add    %eax,%edx
  802ec1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ec4:	89 50 0c             	mov    %edx,0xc(%eax)
				blockToInsert->sva=0;
  802ec7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eca:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size =0;
  802ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802edb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802edf:	75 17                	jne    802ef8 <insert_sorted_with_merge_freeList+0x5c8>
  802ee1:	83 ec 04             	sub    $0x4,%esp
  802ee4:	68 d0 3c 80 00       	push   $0x803cd0
  802ee9:	68 7d 01 00 00       	push   $0x17d
  802eee:	68 f3 3c 80 00       	push   $0x803cf3
  802ef3:	e8 4b 02 00 00       	call   803143 <_panic>
  802ef8:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802efe:	8b 45 08             	mov    0x8(%ebp),%eax
  802f01:	89 10                	mov    %edx,(%eax)
  802f03:	8b 45 08             	mov    0x8(%ebp),%eax
  802f06:	8b 00                	mov    (%eax),%eax
  802f08:	85 c0                	test   %eax,%eax
  802f0a:	74 0d                	je     802f19 <insert_sorted_with_merge_freeList+0x5e9>
  802f0c:	a1 48 41 80 00       	mov    0x804148,%eax
  802f11:	8b 55 08             	mov    0x8(%ebp),%edx
  802f14:	89 50 04             	mov    %edx,0x4(%eax)
  802f17:	eb 08                	jmp    802f21 <insert_sorted_with_merge_freeList+0x5f1>
  802f19:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f21:	8b 45 08             	mov    0x8(%ebp),%eax
  802f24:	a3 48 41 80 00       	mov    %eax,0x804148
  802f29:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f33:	a1 54 41 80 00       	mov    0x804154,%eax
  802f38:	40                   	inc    %eax
  802f39:	a3 54 41 80 00       	mov    %eax,0x804154
break;
  802f3e:	e9 fa 01 00 00       	jmp    80313d <insert_sorted_with_merge_freeList+0x80d>
			}// merge with previous
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802f43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f46:	8b 50 08             	mov    0x8(%eax),%edx
  802f49:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4c:	8b 40 08             	mov    0x8(%eax),%eax
  802f4f:	39 c2                	cmp    %eax,%edx
  802f51:	0f 86 d2 01 00 00    	jbe    803129 <insert_sorted_with_merge_freeList+0x7f9>
  802f57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5a:	8b 50 08             	mov    0x8(%eax),%edx
  802f5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f60:	8b 48 08             	mov    0x8(%eax),%ecx
  802f63:	8b 45 08             	mov    0x8(%ebp),%eax
  802f66:	8b 40 0c             	mov    0xc(%eax),%eax
  802f69:	01 c8                	add    %ecx,%eax
  802f6b:	39 c2                	cmp    %eax,%edx
  802f6d:	0f 85 b6 01 00 00    	jne    803129 <insert_sorted_with_merge_freeList+0x7f9>
  802f73:	8b 45 08             	mov    0x8(%ebp),%eax
  802f76:	8b 50 08             	mov    0x8(%eax),%edx
  802f79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7c:	8b 40 04             	mov    0x4(%eax),%eax
  802f7f:	8b 48 08             	mov    0x8(%eax),%ecx
  802f82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f85:	8b 40 04             	mov    0x4(%eax),%eax
  802f88:	8b 40 0c             	mov    0xc(%eax),%eax
  802f8b:	01 c8                	add    %ecx,%eax
  802f8d:	39 c2                	cmp    %eax,%edx
  802f8f:	0f 85 94 01 00 00    	jne    803129 <insert_sorted_with_merge_freeList+0x7f9>
			{

				LIST_PREV(tmp)->size+=blockToInsert->size+tmp->size;
  802f95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f98:	8b 40 04             	mov    0x4(%eax),%eax
  802f9b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f9e:	8b 52 04             	mov    0x4(%edx),%edx
  802fa1:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802fa4:	8b 55 08             	mov    0x8(%ebp),%edx
  802fa7:	8b 5a 0c             	mov    0xc(%edx),%ebx
  802faa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fad:	8b 52 0c             	mov    0xc(%edx),%edx
  802fb0:	01 da                	add    %ebx,%edx
  802fb2:	01 ca                	add    %ecx,%edx
  802fb4:	89 50 0c             	mov    %edx,0xc(%eax)
				tmp->size=0;
  802fb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fba:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				tmp->sva=0;
  802fc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  802fcb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fcf:	75 17                	jne    802fe8 <insert_sorted_with_merge_freeList+0x6b8>
  802fd1:	83 ec 04             	sub    $0x4,%esp
  802fd4:	68 65 3d 80 00       	push   $0x803d65
  802fd9:	68 86 01 00 00       	push   $0x186
  802fde:	68 f3 3c 80 00       	push   $0x803cf3
  802fe3:	e8 5b 01 00 00       	call   803143 <_panic>
  802fe8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802feb:	8b 00                	mov    (%eax),%eax
  802fed:	85 c0                	test   %eax,%eax
  802fef:	74 10                	je     803001 <insert_sorted_with_merge_freeList+0x6d1>
  802ff1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff4:	8b 00                	mov    (%eax),%eax
  802ff6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ff9:	8b 52 04             	mov    0x4(%edx),%edx
  802ffc:	89 50 04             	mov    %edx,0x4(%eax)
  802fff:	eb 0b                	jmp    80300c <insert_sorted_with_merge_freeList+0x6dc>
  803001:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803004:	8b 40 04             	mov    0x4(%eax),%eax
  803007:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80300c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300f:	8b 40 04             	mov    0x4(%eax),%eax
  803012:	85 c0                	test   %eax,%eax
  803014:	74 0f                	je     803025 <insert_sorted_with_merge_freeList+0x6f5>
  803016:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803019:	8b 40 04             	mov    0x4(%eax),%eax
  80301c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80301f:	8b 12                	mov    (%edx),%edx
  803021:	89 10                	mov    %edx,(%eax)
  803023:	eb 0a                	jmp    80302f <insert_sorted_with_merge_freeList+0x6ff>
  803025:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803028:	8b 00                	mov    (%eax),%eax
  80302a:	a3 38 41 80 00       	mov    %eax,0x804138
  80302f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803032:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803042:	a1 44 41 80 00       	mov    0x804144,%eax
  803047:	48                   	dec    %eax
  803048:	a3 44 41 80 00       	mov    %eax,0x804144
				LIST_INSERT_HEAD(&AvailableMemBlocksList,tmp);
  80304d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803051:	75 17                	jne    80306a <insert_sorted_with_merge_freeList+0x73a>
  803053:	83 ec 04             	sub    $0x4,%esp
  803056:	68 d0 3c 80 00       	push   $0x803cd0
  80305b:	68 87 01 00 00       	push   $0x187
  803060:	68 f3 3c 80 00       	push   $0x803cf3
  803065:	e8 d9 00 00 00       	call   803143 <_panic>
  80306a:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803070:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803073:	89 10                	mov    %edx,(%eax)
  803075:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803078:	8b 00                	mov    (%eax),%eax
  80307a:	85 c0                	test   %eax,%eax
  80307c:	74 0d                	je     80308b <insert_sorted_with_merge_freeList+0x75b>
  80307e:	a1 48 41 80 00       	mov    0x804148,%eax
  803083:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803086:	89 50 04             	mov    %edx,0x4(%eax)
  803089:	eb 08                	jmp    803093 <insert_sorted_with_merge_freeList+0x763>
  80308b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803093:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803096:	a3 48 41 80 00       	mov    %eax,0x804148
  80309b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030a5:	a1 54 41 80 00       	mov    0x804154,%eax
  8030aa:	40                   	inc    %eax
  8030ab:	a3 54 41 80 00       	mov    %eax,0x804154
				blockToInsert->sva=0;
  8030b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size=0;
  8030ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8030bd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8030c4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030c8:	75 17                	jne    8030e1 <insert_sorted_with_merge_freeList+0x7b1>
  8030ca:	83 ec 04             	sub    $0x4,%esp
  8030cd:	68 d0 3c 80 00       	push   $0x803cd0
  8030d2:	68 8a 01 00 00       	push   $0x18a
  8030d7:	68 f3 3c 80 00       	push   $0x803cf3
  8030dc:	e8 62 00 00 00       	call   803143 <_panic>
  8030e1:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8030e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ea:	89 10                	mov    %edx,(%eax)
  8030ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ef:	8b 00                	mov    (%eax),%eax
  8030f1:	85 c0                	test   %eax,%eax
  8030f3:	74 0d                	je     803102 <insert_sorted_with_merge_freeList+0x7d2>
  8030f5:	a1 48 41 80 00       	mov    0x804148,%eax
  8030fa:	8b 55 08             	mov    0x8(%ebp),%edx
  8030fd:	89 50 04             	mov    %edx,0x4(%eax)
  803100:	eb 08                	jmp    80310a <insert_sorted_with_merge_freeList+0x7da>
  803102:	8b 45 08             	mov    0x8(%ebp),%eax
  803105:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80310a:	8b 45 08             	mov    0x8(%ebp),%eax
  80310d:	a3 48 41 80 00       	mov    %eax,0x804148
  803112:	8b 45 08             	mov    0x8(%ebp),%eax
  803115:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80311c:	a1 54 41 80 00       	mov    0x804154,%eax
  803121:	40                   	inc    %eax
  803122:	a3 54 41 80 00       	mov    %eax,0x804154
				break;
  803127:	eb 14                	jmp    80313d <insert_sorted_with_merge_freeList+0x80d>
			}//merge with next and previous
			tmp=tmp->prev_next_info.le_next;
  803129:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80312c:	8b 00                	mov    (%eax),%eax
  80312e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
		while(tmp!=NULL)
  803131:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803135:	0f 85 72 fb ff ff    	jne    802cad <insert_sorted_with_merge_freeList+0x37d>
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  80313b:	eb 00                	jmp    80313d <insert_sorted_with_merge_freeList+0x80d>
  80313d:	90                   	nop
  80313e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803141:	c9                   	leave  
  803142:	c3                   	ret    

00803143 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803143:	55                   	push   %ebp
  803144:	89 e5                	mov    %esp,%ebp
  803146:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803149:	8d 45 10             	lea    0x10(%ebp),%eax
  80314c:	83 c0 04             	add    $0x4,%eax
  80314f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803152:	a1 5c 41 80 00       	mov    0x80415c,%eax
  803157:	85 c0                	test   %eax,%eax
  803159:	74 16                	je     803171 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80315b:	a1 5c 41 80 00       	mov    0x80415c,%eax
  803160:	83 ec 08             	sub    $0x8,%esp
  803163:	50                   	push   %eax
  803164:	68 84 3d 80 00       	push   $0x803d84
  803169:	e8 b4 d4 ff ff       	call   800622 <cprintf>
  80316e:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  803171:	a1 00 40 80 00       	mov    0x804000,%eax
  803176:	ff 75 0c             	pushl  0xc(%ebp)
  803179:	ff 75 08             	pushl  0x8(%ebp)
  80317c:	50                   	push   %eax
  80317d:	68 89 3d 80 00       	push   $0x803d89
  803182:	e8 9b d4 ff ff       	call   800622 <cprintf>
  803187:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80318a:	8b 45 10             	mov    0x10(%ebp),%eax
  80318d:	83 ec 08             	sub    $0x8,%esp
  803190:	ff 75 f4             	pushl  -0xc(%ebp)
  803193:	50                   	push   %eax
  803194:	e8 1e d4 ff ff       	call   8005b7 <vcprintf>
  803199:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80319c:	83 ec 08             	sub    $0x8,%esp
  80319f:	6a 00                	push   $0x0
  8031a1:	68 a5 3d 80 00       	push   $0x803da5
  8031a6:	e8 0c d4 ff ff       	call   8005b7 <vcprintf>
  8031ab:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8031ae:	e8 8d d3 ff ff       	call   800540 <exit>

	// should not return here
	while (1) ;
  8031b3:	eb fe                	jmp    8031b3 <_panic+0x70>

008031b5 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8031b5:	55                   	push   %ebp
  8031b6:	89 e5                	mov    %esp,%ebp
  8031b8:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8031bb:	a1 20 40 80 00       	mov    0x804020,%eax
  8031c0:	8b 50 74             	mov    0x74(%eax),%edx
  8031c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031c6:	39 c2                	cmp    %eax,%edx
  8031c8:	74 14                	je     8031de <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8031ca:	83 ec 04             	sub    $0x4,%esp
  8031cd:	68 a8 3d 80 00       	push   $0x803da8
  8031d2:	6a 26                	push   $0x26
  8031d4:	68 f4 3d 80 00       	push   $0x803df4
  8031d9:	e8 65 ff ff ff       	call   803143 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8031de:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8031e5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8031ec:	e9 c2 00 00 00       	jmp    8032b3 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8031f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031f4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8031fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8031fe:	01 d0                	add    %edx,%eax
  803200:	8b 00                	mov    (%eax),%eax
  803202:	85 c0                	test   %eax,%eax
  803204:	75 08                	jne    80320e <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  803206:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803209:	e9 a2 00 00 00       	jmp    8032b0 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80320e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803215:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80321c:	eb 69                	jmp    803287 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80321e:	a1 20 40 80 00       	mov    0x804020,%eax
  803223:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803229:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80322c:	89 d0                	mov    %edx,%eax
  80322e:	01 c0                	add    %eax,%eax
  803230:	01 d0                	add    %edx,%eax
  803232:	c1 e0 03             	shl    $0x3,%eax
  803235:	01 c8                	add    %ecx,%eax
  803237:	8a 40 04             	mov    0x4(%eax),%al
  80323a:	84 c0                	test   %al,%al
  80323c:	75 46                	jne    803284 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80323e:	a1 20 40 80 00       	mov    0x804020,%eax
  803243:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803249:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80324c:	89 d0                	mov    %edx,%eax
  80324e:	01 c0                	add    %eax,%eax
  803250:	01 d0                	add    %edx,%eax
  803252:	c1 e0 03             	shl    $0x3,%eax
  803255:	01 c8                	add    %ecx,%eax
  803257:	8b 00                	mov    (%eax),%eax
  803259:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80325c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80325f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803264:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803266:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803269:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803270:	8b 45 08             	mov    0x8(%ebp),%eax
  803273:	01 c8                	add    %ecx,%eax
  803275:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803277:	39 c2                	cmp    %eax,%edx
  803279:	75 09                	jne    803284 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  80327b:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803282:	eb 12                	jmp    803296 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803284:	ff 45 e8             	incl   -0x18(%ebp)
  803287:	a1 20 40 80 00       	mov    0x804020,%eax
  80328c:	8b 50 74             	mov    0x74(%eax),%edx
  80328f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803292:	39 c2                	cmp    %eax,%edx
  803294:	77 88                	ja     80321e <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803296:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80329a:	75 14                	jne    8032b0 <CheckWSWithoutLastIndex+0xfb>
			panic(
  80329c:	83 ec 04             	sub    $0x4,%esp
  80329f:	68 00 3e 80 00       	push   $0x803e00
  8032a4:	6a 3a                	push   $0x3a
  8032a6:	68 f4 3d 80 00       	push   $0x803df4
  8032ab:	e8 93 fe ff ff       	call   803143 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8032b0:	ff 45 f0             	incl   -0x10(%ebp)
  8032b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032b6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8032b9:	0f 8c 32 ff ff ff    	jl     8031f1 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8032bf:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8032c6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8032cd:	eb 26                	jmp    8032f5 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8032cf:	a1 20 40 80 00       	mov    0x804020,%eax
  8032d4:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8032da:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8032dd:	89 d0                	mov    %edx,%eax
  8032df:	01 c0                	add    %eax,%eax
  8032e1:	01 d0                	add    %edx,%eax
  8032e3:	c1 e0 03             	shl    $0x3,%eax
  8032e6:	01 c8                	add    %ecx,%eax
  8032e8:	8a 40 04             	mov    0x4(%eax),%al
  8032eb:	3c 01                	cmp    $0x1,%al
  8032ed:	75 03                	jne    8032f2 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8032ef:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8032f2:	ff 45 e0             	incl   -0x20(%ebp)
  8032f5:	a1 20 40 80 00       	mov    0x804020,%eax
  8032fa:	8b 50 74             	mov    0x74(%eax),%edx
  8032fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803300:	39 c2                	cmp    %eax,%edx
  803302:	77 cb                	ja     8032cf <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803304:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803307:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80330a:	74 14                	je     803320 <CheckWSWithoutLastIndex+0x16b>
		panic(
  80330c:	83 ec 04             	sub    $0x4,%esp
  80330f:	68 54 3e 80 00       	push   $0x803e54
  803314:	6a 44                	push   $0x44
  803316:	68 f4 3d 80 00       	push   $0x803df4
  80331b:	e8 23 fe ff ff       	call   803143 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803320:	90                   	nop
  803321:	c9                   	leave  
  803322:	c3                   	ret    
  803323:	90                   	nop

00803324 <__udivdi3>:
  803324:	55                   	push   %ebp
  803325:	57                   	push   %edi
  803326:	56                   	push   %esi
  803327:	53                   	push   %ebx
  803328:	83 ec 1c             	sub    $0x1c,%esp
  80332b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80332f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803333:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803337:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80333b:	89 ca                	mov    %ecx,%edx
  80333d:	89 f8                	mov    %edi,%eax
  80333f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803343:	85 f6                	test   %esi,%esi
  803345:	75 2d                	jne    803374 <__udivdi3+0x50>
  803347:	39 cf                	cmp    %ecx,%edi
  803349:	77 65                	ja     8033b0 <__udivdi3+0x8c>
  80334b:	89 fd                	mov    %edi,%ebp
  80334d:	85 ff                	test   %edi,%edi
  80334f:	75 0b                	jne    80335c <__udivdi3+0x38>
  803351:	b8 01 00 00 00       	mov    $0x1,%eax
  803356:	31 d2                	xor    %edx,%edx
  803358:	f7 f7                	div    %edi
  80335a:	89 c5                	mov    %eax,%ebp
  80335c:	31 d2                	xor    %edx,%edx
  80335e:	89 c8                	mov    %ecx,%eax
  803360:	f7 f5                	div    %ebp
  803362:	89 c1                	mov    %eax,%ecx
  803364:	89 d8                	mov    %ebx,%eax
  803366:	f7 f5                	div    %ebp
  803368:	89 cf                	mov    %ecx,%edi
  80336a:	89 fa                	mov    %edi,%edx
  80336c:	83 c4 1c             	add    $0x1c,%esp
  80336f:	5b                   	pop    %ebx
  803370:	5e                   	pop    %esi
  803371:	5f                   	pop    %edi
  803372:	5d                   	pop    %ebp
  803373:	c3                   	ret    
  803374:	39 ce                	cmp    %ecx,%esi
  803376:	77 28                	ja     8033a0 <__udivdi3+0x7c>
  803378:	0f bd fe             	bsr    %esi,%edi
  80337b:	83 f7 1f             	xor    $0x1f,%edi
  80337e:	75 40                	jne    8033c0 <__udivdi3+0x9c>
  803380:	39 ce                	cmp    %ecx,%esi
  803382:	72 0a                	jb     80338e <__udivdi3+0x6a>
  803384:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803388:	0f 87 9e 00 00 00    	ja     80342c <__udivdi3+0x108>
  80338e:	b8 01 00 00 00       	mov    $0x1,%eax
  803393:	89 fa                	mov    %edi,%edx
  803395:	83 c4 1c             	add    $0x1c,%esp
  803398:	5b                   	pop    %ebx
  803399:	5e                   	pop    %esi
  80339a:	5f                   	pop    %edi
  80339b:	5d                   	pop    %ebp
  80339c:	c3                   	ret    
  80339d:	8d 76 00             	lea    0x0(%esi),%esi
  8033a0:	31 ff                	xor    %edi,%edi
  8033a2:	31 c0                	xor    %eax,%eax
  8033a4:	89 fa                	mov    %edi,%edx
  8033a6:	83 c4 1c             	add    $0x1c,%esp
  8033a9:	5b                   	pop    %ebx
  8033aa:	5e                   	pop    %esi
  8033ab:	5f                   	pop    %edi
  8033ac:	5d                   	pop    %ebp
  8033ad:	c3                   	ret    
  8033ae:	66 90                	xchg   %ax,%ax
  8033b0:	89 d8                	mov    %ebx,%eax
  8033b2:	f7 f7                	div    %edi
  8033b4:	31 ff                	xor    %edi,%edi
  8033b6:	89 fa                	mov    %edi,%edx
  8033b8:	83 c4 1c             	add    $0x1c,%esp
  8033bb:	5b                   	pop    %ebx
  8033bc:	5e                   	pop    %esi
  8033bd:	5f                   	pop    %edi
  8033be:	5d                   	pop    %ebp
  8033bf:	c3                   	ret    
  8033c0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8033c5:	89 eb                	mov    %ebp,%ebx
  8033c7:	29 fb                	sub    %edi,%ebx
  8033c9:	89 f9                	mov    %edi,%ecx
  8033cb:	d3 e6                	shl    %cl,%esi
  8033cd:	89 c5                	mov    %eax,%ebp
  8033cf:	88 d9                	mov    %bl,%cl
  8033d1:	d3 ed                	shr    %cl,%ebp
  8033d3:	89 e9                	mov    %ebp,%ecx
  8033d5:	09 f1                	or     %esi,%ecx
  8033d7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8033db:	89 f9                	mov    %edi,%ecx
  8033dd:	d3 e0                	shl    %cl,%eax
  8033df:	89 c5                	mov    %eax,%ebp
  8033e1:	89 d6                	mov    %edx,%esi
  8033e3:	88 d9                	mov    %bl,%cl
  8033e5:	d3 ee                	shr    %cl,%esi
  8033e7:	89 f9                	mov    %edi,%ecx
  8033e9:	d3 e2                	shl    %cl,%edx
  8033eb:	8b 44 24 08          	mov    0x8(%esp),%eax
  8033ef:	88 d9                	mov    %bl,%cl
  8033f1:	d3 e8                	shr    %cl,%eax
  8033f3:	09 c2                	or     %eax,%edx
  8033f5:	89 d0                	mov    %edx,%eax
  8033f7:	89 f2                	mov    %esi,%edx
  8033f9:	f7 74 24 0c          	divl   0xc(%esp)
  8033fd:	89 d6                	mov    %edx,%esi
  8033ff:	89 c3                	mov    %eax,%ebx
  803401:	f7 e5                	mul    %ebp
  803403:	39 d6                	cmp    %edx,%esi
  803405:	72 19                	jb     803420 <__udivdi3+0xfc>
  803407:	74 0b                	je     803414 <__udivdi3+0xf0>
  803409:	89 d8                	mov    %ebx,%eax
  80340b:	31 ff                	xor    %edi,%edi
  80340d:	e9 58 ff ff ff       	jmp    80336a <__udivdi3+0x46>
  803412:	66 90                	xchg   %ax,%ax
  803414:	8b 54 24 08          	mov    0x8(%esp),%edx
  803418:	89 f9                	mov    %edi,%ecx
  80341a:	d3 e2                	shl    %cl,%edx
  80341c:	39 c2                	cmp    %eax,%edx
  80341e:	73 e9                	jae    803409 <__udivdi3+0xe5>
  803420:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803423:	31 ff                	xor    %edi,%edi
  803425:	e9 40 ff ff ff       	jmp    80336a <__udivdi3+0x46>
  80342a:	66 90                	xchg   %ax,%ax
  80342c:	31 c0                	xor    %eax,%eax
  80342e:	e9 37 ff ff ff       	jmp    80336a <__udivdi3+0x46>
  803433:	90                   	nop

00803434 <__umoddi3>:
  803434:	55                   	push   %ebp
  803435:	57                   	push   %edi
  803436:	56                   	push   %esi
  803437:	53                   	push   %ebx
  803438:	83 ec 1c             	sub    $0x1c,%esp
  80343b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80343f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803443:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803447:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80344b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80344f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803453:	89 f3                	mov    %esi,%ebx
  803455:	89 fa                	mov    %edi,%edx
  803457:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80345b:	89 34 24             	mov    %esi,(%esp)
  80345e:	85 c0                	test   %eax,%eax
  803460:	75 1a                	jne    80347c <__umoddi3+0x48>
  803462:	39 f7                	cmp    %esi,%edi
  803464:	0f 86 a2 00 00 00    	jbe    80350c <__umoddi3+0xd8>
  80346a:	89 c8                	mov    %ecx,%eax
  80346c:	89 f2                	mov    %esi,%edx
  80346e:	f7 f7                	div    %edi
  803470:	89 d0                	mov    %edx,%eax
  803472:	31 d2                	xor    %edx,%edx
  803474:	83 c4 1c             	add    $0x1c,%esp
  803477:	5b                   	pop    %ebx
  803478:	5e                   	pop    %esi
  803479:	5f                   	pop    %edi
  80347a:	5d                   	pop    %ebp
  80347b:	c3                   	ret    
  80347c:	39 f0                	cmp    %esi,%eax
  80347e:	0f 87 ac 00 00 00    	ja     803530 <__umoddi3+0xfc>
  803484:	0f bd e8             	bsr    %eax,%ebp
  803487:	83 f5 1f             	xor    $0x1f,%ebp
  80348a:	0f 84 ac 00 00 00    	je     80353c <__umoddi3+0x108>
  803490:	bf 20 00 00 00       	mov    $0x20,%edi
  803495:	29 ef                	sub    %ebp,%edi
  803497:	89 fe                	mov    %edi,%esi
  803499:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80349d:	89 e9                	mov    %ebp,%ecx
  80349f:	d3 e0                	shl    %cl,%eax
  8034a1:	89 d7                	mov    %edx,%edi
  8034a3:	89 f1                	mov    %esi,%ecx
  8034a5:	d3 ef                	shr    %cl,%edi
  8034a7:	09 c7                	or     %eax,%edi
  8034a9:	89 e9                	mov    %ebp,%ecx
  8034ab:	d3 e2                	shl    %cl,%edx
  8034ad:	89 14 24             	mov    %edx,(%esp)
  8034b0:	89 d8                	mov    %ebx,%eax
  8034b2:	d3 e0                	shl    %cl,%eax
  8034b4:	89 c2                	mov    %eax,%edx
  8034b6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034ba:	d3 e0                	shl    %cl,%eax
  8034bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8034c0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034c4:	89 f1                	mov    %esi,%ecx
  8034c6:	d3 e8                	shr    %cl,%eax
  8034c8:	09 d0                	or     %edx,%eax
  8034ca:	d3 eb                	shr    %cl,%ebx
  8034cc:	89 da                	mov    %ebx,%edx
  8034ce:	f7 f7                	div    %edi
  8034d0:	89 d3                	mov    %edx,%ebx
  8034d2:	f7 24 24             	mull   (%esp)
  8034d5:	89 c6                	mov    %eax,%esi
  8034d7:	89 d1                	mov    %edx,%ecx
  8034d9:	39 d3                	cmp    %edx,%ebx
  8034db:	0f 82 87 00 00 00    	jb     803568 <__umoddi3+0x134>
  8034e1:	0f 84 91 00 00 00    	je     803578 <__umoddi3+0x144>
  8034e7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8034eb:	29 f2                	sub    %esi,%edx
  8034ed:	19 cb                	sbb    %ecx,%ebx
  8034ef:	89 d8                	mov    %ebx,%eax
  8034f1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8034f5:	d3 e0                	shl    %cl,%eax
  8034f7:	89 e9                	mov    %ebp,%ecx
  8034f9:	d3 ea                	shr    %cl,%edx
  8034fb:	09 d0                	or     %edx,%eax
  8034fd:	89 e9                	mov    %ebp,%ecx
  8034ff:	d3 eb                	shr    %cl,%ebx
  803501:	89 da                	mov    %ebx,%edx
  803503:	83 c4 1c             	add    $0x1c,%esp
  803506:	5b                   	pop    %ebx
  803507:	5e                   	pop    %esi
  803508:	5f                   	pop    %edi
  803509:	5d                   	pop    %ebp
  80350a:	c3                   	ret    
  80350b:	90                   	nop
  80350c:	89 fd                	mov    %edi,%ebp
  80350e:	85 ff                	test   %edi,%edi
  803510:	75 0b                	jne    80351d <__umoddi3+0xe9>
  803512:	b8 01 00 00 00       	mov    $0x1,%eax
  803517:	31 d2                	xor    %edx,%edx
  803519:	f7 f7                	div    %edi
  80351b:	89 c5                	mov    %eax,%ebp
  80351d:	89 f0                	mov    %esi,%eax
  80351f:	31 d2                	xor    %edx,%edx
  803521:	f7 f5                	div    %ebp
  803523:	89 c8                	mov    %ecx,%eax
  803525:	f7 f5                	div    %ebp
  803527:	89 d0                	mov    %edx,%eax
  803529:	e9 44 ff ff ff       	jmp    803472 <__umoddi3+0x3e>
  80352e:	66 90                	xchg   %ax,%ax
  803530:	89 c8                	mov    %ecx,%eax
  803532:	89 f2                	mov    %esi,%edx
  803534:	83 c4 1c             	add    $0x1c,%esp
  803537:	5b                   	pop    %ebx
  803538:	5e                   	pop    %esi
  803539:	5f                   	pop    %edi
  80353a:	5d                   	pop    %ebp
  80353b:	c3                   	ret    
  80353c:	3b 04 24             	cmp    (%esp),%eax
  80353f:	72 06                	jb     803547 <__umoddi3+0x113>
  803541:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803545:	77 0f                	ja     803556 <__umoddi3+0x122>
  803547:	89 f2                	mov    %esi,%edx
  803549:	29 f9                	sub    %edi,%ecx
  80354b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80354f:	89 14 24             	mov    %edx,(%esp)
  803552:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803556:	8b 44 24 04          	mov    0x4(%esp),%eax
  80355a:	8b 14 24             	mov    (%esp),%edx
  80355d:	83 c4 1c             	add    $0x1c,%esp
  803560:	5b                   	pop    %ebx
  803561:	5e                   	pop    %esi
  803562:	5f                   	pop    %edi
  803563:	5d                   	pop    %ebp
  803564:	c3                   	ret    
  803565:	8d 76 00             	lea    0x0(%esi),%esi
  803568:	2b 04 24             	sub    (%esp),%eax
  80356b:	19 fa                	sbb    %edi,%edx
  80356d:	89 d1                	mov    %edx,%ecx
  80356f:	89 c6                	mov    %eax,%esi
  803571:	e9 71 ff ff ff       	jmp    8034e7 <__umoddi3+0xb3>
  803576:	66 90                	xchg   %ax,%ax
  803578:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80357c:	72 ea                	jb     803568 <__umoddi3+0x134>
  80357e:	89 d9                	mov    %ebx,%ecx
  803580:	e9 62 ff ff ff       	jmp    8034e7 <__umoddi3+0xb3>
