!classDefinition: #ElevatorEmergency category: #'Elevator-Ejercicio'!
Error subclass: #ElevatorEmergency
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ElevatorEmergency class' category: #'Elevator-Ejercicio'!
ElevatorEmergency class
	instanceVariableNames: ''!

!ElevatorEmergency class methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 06:24:58'!
cabinSensorNotSync

	self error: 'Sensor de cabina desincronizado'! !

!ElevatorEmergency class methodsFor: 'as yet unclassified' stamp: 'rok 10/10/2017 23:03:39'!
doorSensorNotSync

	self error: 'Sensor de puerta desincronizado'! !

!ElevatorEmergency class methodsFor: 'as yet unclassified' stamp: 'rok 10/5/2017 20:02:51'!
error: aString 
	"Throw a generic Error exception."

	^self new signal: aString! !


!classDefinition: #ElevatorTest category: #'Elevator-Ejercicio'!
TestCase subclass: #ElevatorTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!ElevatorTest methodsFor: 'tests 3' stamp: 'HernanWilkinson 7/10/2011 17:38'!
test09RequestToGoUpAreEnqueueWhenRequestedWhenCabinIsMoving

	| elevatorController |
	elevatorController := ElevatorController new.
	
	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinDoorClosed.
	elevatorController cabinOnFloor:1.
	elevatorController goUpPushedFromFloor:2.
	elevatorController cabinDoorOpened.

	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinWaitingForPeople.
	self assert: elevatorController isCabinDoorOpened.! !

!ElevatorTest methodsFor: 'tests 3' stamp: 'HernanWilkinson 7/10/2011 17:39'!
test10CabinDoorStartClosingAfterWaitingForPeople

	| elevatorController |
	elevatorController := ElevatorController new.
	
	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinDoorClosed.
	elevatorController cabinOnFloor:1.
	elevatorController goUpPushedFromFloor:2.
	elevatorController cabinDoorOpened.
	elevatorController waitForPeopleTimedOut.

	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorClosing.! !

!ElevatorTest methodsFor: 'tests 3' stamp: 'HernanWilkinson 7/10/2011 17:39'!
test11StopsWaitingForPeopleIfCloseDoorIsPressed

	| elevatorController |
	elevatorController := ElevatorController new.
	
	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinDoorClosed.
	elevatorController cabinOnFloor:1.
	elevatorController goUpPushedFromFloor:2.
	elevatorController cabinDoorOpened.

	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinWaitingForPeople.
	self assert: elevatorController isCabinDoorOpened.

	elevatorController closeCabinDoor.

	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorClosing.
! !

!ElevatorTest methodsFor: 'tests 3' stamp: 'HernanWilkinson 7/10/2011 17:39'!
test12CloseDoorDoesNothingIfIdle

	| elevatorController |
	elevatorController := ElevatorController new.
	
	elevatorController closeCabinDoor.

	self assert: elevatorController isIdle.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorOpened.! !

!ElevatorTest methodsFor: 'tests 3' stamp: 'HernanWilkinson 7/10/2011 17:40'!
test13CloseDoorDoesNothingWhenCabinIsMoving

	| elevatorController |
	elevatorController := ElevatorController new.
	
	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinDoorClosed.

	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinMoving.
	self assert: elevatorController isCabinDoorClosed.

	elevatorController closeCabinDoor.

	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinMoving.
	self assert: elevatorController isCabinDoorClosed.! !

!ElevatorTest methodsFor: 'tests 3' stamp: 'HernanWilkinson 7/10/2011 17:40'!
test14CloseDoorDoesNothingWhenOpeningTheDoorToWaitForPeople

	| elevatorController |
	elevatorController := ElevatorController new.
		
	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinDoorClosed.
	elevatorController cabinOnFloor:1.
	
	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorOpening.

	elevatorController closeCabinDoor.

	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorOpening.! !

!ElevatorTest methodsFor: 'tests 3' stamp: 'rok 10/5/2017 19:26:48'!
test15ElevatorHasToEnterEmergencyIfStoppedAndOtherFloorSensorTurnsOn

	| elevatorController |
	elevatorController := ElevatorController new.
	
	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinDoorClosed.
	elevatorController cabinOnFloor:1.
	self 
		should: [ elevatorController cabinOnFloor:0 ]
		raise: ElevatorEmergency 
		withExceptionDo: [ :elevatorEmergency | self assert: elevatorEmergency messageText = 'Sensor de cabina desincronizado' ]! !


!ElevatorTest methodsFor: 'tests 4' stamp: 'HernanWilkinson 7/10/2011 17:47'!
test16ElevatorHasToEnterEmergencyIfFalling

	| elevatorController |
	elevatorController := ElevatorController new.
	
	elevatorController goUpPushedFromFloor:2.
	elevatorController cabinDoorClosed.
	elevatorController cabinOnFloor:1.
	self 
		should: [ elevatorController cabinOnFloor:0 ]
		raise: ElevatorEmergency 
		withExceptionDo: [ :elevatorEmergency | self assert: elevatorEmergency messageText = 'Sensor de cabina desincronizado'. ]! !

!ElevatorTest methodsFor: 'tests 4' stamp: 'HernanWilkinson 7/10/2011 17:47'!
test17ElevatorHasToEnterEmergencyIfJumpsFloors

	| elevatorController |
	elevatorController := ElevatorController new.
	
	elevatorController goUpPushedFromFloor:3.
	elevatorController cabinDoorClosed.
	self 
		should: [ elevatorController cabinOnFloor: 3 ]
		raise: ElevatorEmergency 
		withExceptionDo: [ :elevatorEmergency | self assert: elevatorEmergency messageText = 'Sensor de cabina desincronizado'. ]! !

!ElevatorTest methodsFor: 'tests 4' stamp: 'HernanWilkinson 7/10/2011 17:48'!
test18ElevatorHasToEnterEmergencyIfDoorClosesAutomatically
	| elevatorController |
	elevatorController := ElevatorController new.
	
	self 
		should: [ elevatorController cabinDoorClosed.]
		raise: ElevatorEmergency 
		withExceptionDo: [ :elevatorEmergency | self assert: elevatorEmergency messageText = 'Sensor de puerta desincronizado' ]! !

!ElevatorTest methodsFor: 'tests 4' stamp: 'HernanWilkinson 7/10/2011 17:48'!
test19ElevatorHasToEnterEmergencyIfDoorClosedSensorTurnsOnWhenClosed

	| elevatorController |
	elevatorController := ElevatorController new.
	
	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinDoorClosed.
	self 
		should: [elevatorController cabinDoorClosed.]
		raise: ElevatorEmergency 
		withExceptionDo: [ :elevatorEmergency | self assert: elevatorEmergency messageText = 'Sensor de puerta desincronizado'. ]! !

!ElevatorTest methodsFor: 'tests 4' stamp: 'HernanWilkinson 7/10/2011 17:49'!
test20ElevatorHasToEnterEmergencyIfDoorClosesWhenOpening
	| elevatorController |
	elevatorController := ElevatorController new.
		
	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinDoorClosed.
	elevatorController cabinOnFloor:1.
	self 
		should: [elevatorController cabinDoorClosed.]
		raise: ElevatorEmergency 
		withExceptionDo: [ :elevatorEmergency | self assert: elevatorEmergency messageText = 'Sensor de puerta desincronizado'.]! !


!ElevatorTest methodsFor: 'tests 2' stamp: 'HernanWilkinson 7/10/2011 17:35'!
test06DoorKeepsOpenedWhenOpeningIsRequested

	| elevatorController |
	elevatorController := ElevatorController new.
	
	self assert: elevatorController isCabinDoorOpened.
	
	elevatorController openCabinDoor.

	self assert: elevatorController isCabinDoorOpened.! !

!ElevatorTest methodsFor: 'tests 2' stamp: 'HernanWilkinson 6/16/2014 13:24'!
test07DoorMustBeOpenedWhenCabinIsStoppedAndClosingDoors

	| elevatorController |
	elevatorController := ElevatorController new.

	elevatorController goUpPushedFromFloor:1.
		
	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorClosing.
		
	elevatorController openCabinDoor.
	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorOpening.
! !

!ElevatorTest methodsFor: 'tests 2' stamp: 'HernanWilkinson 7/10/2011 17:36'!
test08CanNotOpenDoorWhenCabinIsMoving

	| elevatorController |
	elevatorController := ElevatorController new.

	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinDoorClosed.
	
	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinMoving.
	self assert: elevatorController isCabinDoorClosed.

	elevatorController openCabinDoor.
	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinMoving.
	self assert: elevatorController isCabinDoorClosed.! !

!ElevatorTest methodsFor: 'tests 2' stamp: 'HernanWilkinson 7/10/2011 17:51'!
test09DoorKeepsOpeneingWhenItIsOpeneing

	| elevatorController |
	elevatorController := ElevatorController new.

	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinDoorClosed.
	elevatorController cabinOnFloor:1.

	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorOpening.

	elevatorController openCabinDoor.
	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorOpening.! !


!ElevatorTest methodsFor: 'tests 5' stamp: 'HernanWilkinson 7/10/2011 17:50'!
test21CabinHasToStopOnTheFloorsOnItsWay
	| elevatorController |
	elevatorController := ElevatorController new.
	
	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinDoorClosed.
	elevatorController goUpPushedFromFloor:2.
	elevatorController cabinOnFloor:1.

	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorOpening.! !

!ElevatorTest methodsFor: 'tests 5' stamp: 'HernanWilkinson 7/10/2011 17:50'!
test22ElevatorCompletesAllTheRequests
	| elevatorController |
	elevatorController := ElevatorController new.
	
	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinDoorClosed.
	elevatorController goUpPushedFromFloor:2.
	elevatorController cabinOnFloor:1.
	elevatorController cabinDoorOpened.
	elevatorController waitForPeopleTimedOut.
	elevatorController cabinDoorClosed.
	elevatorController cabinOnFloor:2.
	
	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorOpening.! !

!ElevatorTest methodsFor: 'tests 5' stamp: 'HernanWilkinson 7/10/2011 17:50'!
test23CabinHasToStopOnFloorsOnItsWayNoMatterHowTheyWellCalled

	| elevatorController |
	elevatorController := ElevatorController new.
		
	elevatorController goUpPushedFromFloor:2.
	elevatorController cabinDoorClosed.
	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinOnFloor:1.
		
	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorOpening.! !

!ElevatorTest methodsFor: 'tests 5' stamp: 'HernanWilkinson 7/10/2011 17:51'!
test24CabinHasToStopAndWaitForPeopleOnFloorsOnItsWayNoMatterHowTheyWellCalled

	| elevatorController |
	elevatorController := ElevatorController new.
	
	elevatorController goUpPushedFromFloor:2.
	elevatorController cabinDoorClosed.
	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinOnFloor:1.
	elevatorController cabinDoorOpened.
	elevatorController waitForPeopleTimedOut.
	
	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorClosing.! !


!ElevatorTest methodsFor: 'tests 1' stamp: 'HernanWilkinson 7/10/2011 17:33'!
test01ElevatorStartsIdleWithDoorOpenOnFloorZero

	| elevatorController |
		
	elevatorController := ElevatorController new.
		
	self assert: elevatorController isIdle.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorOpened.
	self assert: elevatorController cabinFloorNumber = 0
! !

!ElevatorTest methodsFor: 'tests 1' stamp: 'HernanWilkinson 7/15/2011 17:53'!
test02CabinDoorStartsClosingWhenElevatorGetsCalled

	| elevatorController |
	elevatorController := ElevatorController new.

	elevatorController goUpPushedFromFloor: 1.
	
	self deny: elevatorController isIdle.
	self assert: elevatorController isWorking.
	
	self assert: elevatorController isCabinStopped.
	self deny: elevatorController isCabinMoving.
	
	self deny: elevatorController isCabinDoorOpened.
	self deny: elevatorController isCabinDoorOpening.
	self assert: elevatorController isCabinDoorClosing.
	self deny: elevatorController isCabinDoorClosed.! !

!ElevatorTest methodsFor: 'tests 1' stamp: 'HernanWilkinson 7/15/2011 17:57'!
test03CabinStartsMovingWhenDoorGetsClosed

	| elevatorController |
	elevatorController := ElevatorController new.

	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinDoorClosed.
	
	self deny: elevatorController isIdle.
	self assert: elevatorController isWorking.

	self deny: elevatorController isCabinStopped.
	self assert: elevatorController isCabinMoving.
	
	self deny: elevatorController isCabinDoorOpened.
	self deny: elevatorController isCabinDoorOpening.
	self deny: elevatorController isCabinDoorClosing.
	self assert: elevatorController isCabinDoorClosed.! !

!ElevatorTest methodsFor: 'tests 1' stamp: 'HernanWilkinson 7/15/2011 18:00'!
test04CabinStopsAndStartsOpeningDoorWhenGetsToDestination

	| elevatorController |
	elevatorController := ElevatorController new.

	elevatorController goUpPushedFromFloor: 1.
	elevatorController cabinDoorClosed.
	elevatorController cabinOnFloor: 1.

	self deny: elevatorController isIdle.
	self assert: elevatorController isWorking.
	
	self assert: elevatorController isCabinStopped.
	self deny: elevatorController isCabinMoving.
			
	self deny: elevatorController isCabinDoorOpened.
	self assert: elevatorController isCabinDoorOpening.
	self deny: elevatorController isCabinDoorClosing.
	self deny: elevatorController isCabinDoorClosed.

	self assert: elevatorController cabinFloorNumber = 1
! !

!ElevatorTest methodsFor: 'tests 1' stamp: 'HernanWilkinson 7/15/2011 18:00'!
test05ElevatorGetsIdleWhenDoorGetOpened

	| elevatorController |
	elevatorController := ElevatorController new.
	
	elevatorController goUpPushedFromFloor: 1.
	elevatorController cabinDoorClosed.
	elevatorController cabinOnFloor: 1.
	elevatorController cabinDoorOpened.
		
	self assert: elevatorController isIdle.
	self deny: elevatorController isWorking.
		
	self assert: elevatorController isCabinStopped.
	self deny: elevatorController isCabinMoving.

	self assert: elevatorController isCabinDoorOpened.
	self deny: elevatorController isCabinDoorOpening.
	self deny: elevatorController isCabinDoorClosing.
	self deny: elevatorController isCabinDoorClosed.
		
	self assert: elevatorController cabinFloorNumber = 1! !


!classDefinition: #Cabin category: #'Elevator-Ejercicio'!
Object subclass: #Cabin
	instanceVariableNames: 'state door floor'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!Cabin methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 06:02:02'!
changeState: aState
	state := aState! !

!Cabin methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 06:03:57'!
closeDoor
	state closeDoor: self! !

!Cabin methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 05:49:17'!
door
	^door! !

!Cabin methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 06:06:36'!
doorClosed
	door closed.
	self changeState: CabinStateMoving new.! !

!Cabin methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 02:46:02'!
doorOpened
	door opened.! !

!Cabin methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 14:34:27'!
floorNumber
	^floor! !

!Cabin methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 15:06:56'!
goUpPushedFromFloor
	door close.! !

!Cabin methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 15:05:22'!
initialize
	door := Door new.
	self changeState: CabinStateStopped new.
	floor := 0.! !

!Cabin methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 03:45:00'!
isDoorClosed
	^door isClosed.! !

!Cabin methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 03:45:08'!
isDoorClosing
	^door isClosing.! !

!Cabin methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 03:26:52'!
isDoorOpened
	^door isOpened.! !

!Cabin methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 03:41:51'!
isDoorOpening
	^door isOpening.! !

!Cabin methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 03:21:39'!
isMoving
	^state isMoving.! !

!Cabin methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 03:20:36'!
isStopped
	^state isStopped.! !

!Cabin methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 06:32:09'!
isWaitingForPeople
	^door isOpened! !

!Cabin methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 15:08:32'!
onFloor: aFloor
	( floor + 1 = aFloor ) ifFalse: [ ElevatorEmergency cabinSensorNotSync . ].
	floor := aFloor.
	state arriveFloor: self! !

!Cabin methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 05:47:41'!
openDoor
	state openDoor: self! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cabin class' category: #'Elevator-Ejercicio'!
Cabin class
	instanceVariableNames: ''!

!Cabin class methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 03:14:42'!
new
	
	| instance |
	
	instance := super new.
	
	instance initialize.
	
	^instance! !


!classDefinition: #CabinState category: #'Elevator-Ejercicio'!
Object subclass: #CabinState
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!CabinState methodsFor: 'actions' stamp: 'a-lavia 10/12/2017 14:43:35'!
arriveFloor: aCabin
	self subclassResponsibility ! !

!CabinState methodsFor: 'actions' stamp: 'a-lavia 10/12/2017 14:33:18'!
closeDoor: aCabin
	self subclassResponsibility ! !

!CabinState methodsFor: 'actions' stamp: 'a-lavia 10/12/2017 06:33:12'!
openDoor: aCabin
	self subclassResponsibility ! !


!CabinState methodsFor: 'queries' stamp: 'a-lavia 10/12/2017 06:00:49'!
isMoving
	self subclassResponsibility! !

!CabinState methodsFor: 'queries' stamp: 'a-lavia 10/12/2017 06:00:46'!
isStopped
	self subclassResponsibility! !


!classDefinition: #CabinStateMoving category: #'Elevator-Ejercicio'!
CabinState subclass: #CabinStateMoving
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!CabinStateMoving methodsFor: 'actions' stamp: 'a-lavia 10/12/2017 15:09:34'!
arriveFloor: aCabin 
	aCabin changeState: CabinStateStopped new.
	aCabin door open.! !

!CabinStateMoving methodsFor: 'actions' stamp: 'a-lavia 10/12/2017 06:02:57'!
closeDoor: aCabin! !

!CabinStateMoving methodsFor: 'actions' stamp: 'a-lavia 10/12/2017 05:48:36'!
openDoor: aCabin
! !


!CabinStateMoving methodsFor: 'queries' stamp: 'a-lavia 10/12/2017 03:20:46'!
isMoving
	^true! !

!CabinStateMoving methodsFor: 'queries' stamp: 'a-lavia 10/12/2017 05:58:34'!
isStopped
	^false! !


!classDefinition: #CabinStateStopped category: #'Elevator-Ejercicio'!
CabinState subclass: #CabinStateStopped
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!CabinStateStopped methodsFor: 'actions' stamp: 'a-lavia 10/12/2017 06:25:19'!
arriveFloor: aCabin
	ElevatorEmergency cabinSensorNotSync! !

!CabinStateStopped methodsFor: 'actions' stamp: 'a-lavia 10/12/2017 05:53:15'!
closeDoor: aCabin
	aCabin door close! !

!CabinStateStopped methodsFor: 'actions' stamp: 'a-lavia 10/12/2017 05:52:51'!
openDoor: aCabin
	aCabin door open! !


!CabinStateStopped methodsFor: 'queries' stamp: 'a-lavia 10/12/2017 03:20:58'!
isMoving
	^false! !

!CabinStateStopped methodsFor: 'queries' stamp: 'a-lavia 10/12/2017 05:58:27'!
isStopped
	^true! !


!classDefinition: #Door category: #'Elevator-Ejercicio'!
Object subclass: #Door
	instanceVariableNames: 'state'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!Door methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 05:17:36'!
changeState: aDoorState
	state := aDoorState.! !

!Door methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 05:27:38'!
close
	state close: self.! !

!Door methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 05:27:36'!
closed
	state closed: self.! !

!Door methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 05:35:16'!
initialize
	self changeState: DoorStateOpened new.! !

!Door methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 03:49:21'!
isClosed
	^state isClosed.! !

!Door methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 03:49:25'!
isClosing
	^state isClosing.! !

!Door methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 03:23:37'!
isOpened
	^state isOpened.! !

!Door methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 03:49:00'!
isOpening
	^state isOpening.! !

!Door methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 05:16:04'!
open
	state open: self.! !

!Door methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 05:22:21'!
opened
	state opened: self.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Door class' category: #'Elevator-Ejercicio'!
Door class
	instanceVariableNames: ''!

!Door class methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 03:26:07'!
new
	
	| instance |
	
	instance := super new.
	
	instance initialize.
	
	^instance! !


!classDefinition: #DoorState category: #'Elevator-Ejercicio'!
Object subclass: #DoorState
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!DoorState methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 05:21:22'!
close: aDoor
	self subclassResponsibility ! !

!DoorState methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 05:21:33'!
closed: aDoor
	self subclassResponsibility ! !

!DoorState methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 05:22:55'!
isClosed
	self subclassResponsibility! !

!DoorState methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 05:22:57'!
isClosing
	self subclassResponsibility! !

!DoorState methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 05:23:00'!
isOpened
	self subclassResponsibility! !

!DoorState methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 05:23:02'!
isOpening
	self subclassResponsibility! !

!DoorState methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 05:22:46'!
open: aDoor
	self subclassResponsibility! !

!DoorState methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 05:21:30'!
opened: aDoor
	self subclassResponsibility ! !


!classDefinition: #DoorStateClosed category: #'Elevator-Ejercicio'!
DoorState subclass: #DoorStateClosed
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!DoorStateClosed methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 05:32:54'!
close: aDoor! !

!DoorStateClosed methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 05:23:18'!
closed: aDoor
	ElevatorEmergency doorSensorNotSync! !

!DoorStateClosed methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 05:23:23'!
isClosed
	^true! !

!DoorStateClosed methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 05:23:27'!
isClosing
	^false! !

!DoorStateClosed methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 05:23:29'!
isOpened
	^false! !

!DoorStateClosed methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 05:23:31'!
isOpening
	^false! !

!DoorStateClosed methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 05:24:23'!
open: aDoor
	aDoor changeState: DoorStateOpening new! !

!DoorStateClosed methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 05:24:09'!
opened: aDoor
	aDoor changeState: DoorStateOpened new! !


!classDefinition: #DoorStateClosing category: #'Elevator-Ejercicio'!
DoorState subclass: #DoorStateClosing
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!DoorStateClosing methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 05:26:17'!
close: aDoor! !

!DoorStateClosing methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 05:25:32'!
closed: aDoor
	aDoor changeState: DoorStateClosed new! !

!DoorStateClosing methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 03:43:39'!
isClosed
	^false! !

!DoorStateClosing methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 03:43:41'!
isClosing
	^true! !

!DoorStateClosing methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 03:43:44'!
isOpened
	^false! !

!DoorStateClosing methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 03:43:47'!
isOpening
	^false! !

!DoorStateClosing methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 05:26:43'!
open: aDoor
	aDoor changeState: DoorStateOpening new! !

!DoorStateClosing methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 05:26:30'!
opened: aDoor
	aDoor changeState: DoorStateOpened new! !


!classDefinition: #DoorStateOpened category: #'Elevator-Ejercicio'!
DoorState subclass: #DoorStateOpened
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!DoorStateOpened methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 05:32:31'!
close: aDoor
	aDoor changeState: DoorStateClosing new! !

!DoorStateOpened methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 05:28:03'!
closed: aDoor! !

!DoorStateOpened methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 15:08:06'!
isClosed
	^false! !

!DoorStateOpened methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 15:08:03'!
isClosing
	^false! !

!DoorStateOpened methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 15:07:58'!
isOpened
	^true! !

!DoorStateOpened methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 15:08:00'!
isOpening
	^false! !

!DoorStateOpened methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 05:32:37'!
open: aDoor! !

!DoorStateOpened methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 05:28:34'!
opened: aDoor! !


!classDefinition: #DoorStateOpening category: #'Elevator-Ejercicio'!
DoorState subclass: #DoorStateOpening
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!DoorStateOpening methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 05:33:03'!
close: aDoor! !

!DoorStateOpening methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 05:28:56'!
closed: aDoor
	ElevatorEmergency doorSensorNotSync! !

!DoorStateOpening methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 15:07:38'!
isClosed
	^false! !

!DoorStateOpening methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 15:07:41'!
isClosing
	^false! !

!DoorStateOpening methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 15:07:47'!
isOpened
	^false! !

!DoorStateOpening methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 15:07:33'!
isOpening
	^true! !

!DoorStateOpening methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 05:29:31'!
open: aDoor! !

!DoorStateOpening methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 05:29:21'!
opened: aDoor
	aDoor changeState: DoorStateOpened new! !


!classDefinition: #ElevatorController category: #'Elevator-Ejercicio'!
Object subclass: #ElevatorController
	instanceVariableNames: 'cabin requests'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!ElevatorController methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 02:47:18'!
cabinDoorClosed
	( self isIdle ) ifTrue: [ ElevatorEmergency doorSensorNotSync . ].
	cabin doorClosed.! !

!ElevatorController methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 02:45:43'!
cabinDoorOpened
	requests removeFirst.
	cabin doorOpened.
	! !

!ElevatorController methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 14:34:11'!
cabinFloorNumber
	^cabin floorNumber! !

!ElevatorController methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 14:36:29'!
cabinOnFloor: aFloor 
	cabin onFloor: aFloor! !

!ElevatorController methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 02:50:59'!
closeCabinDoor
	( self isIdle ) ifFalse: [ cabin closeDoor. ].! !

!ElevatorController methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 15:06:21'!
goUpPushedFromFloor: aFloor
	requests add: aFloor.
	cabin goUpPushedFromFloor.! !

!ElevatorController methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 15:05:48'!
initialize
	cabin _ Cabin new.
	requests _ OrderedCollection new.! !

!ElevatorController methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 03:07:37'!
isCabinDoorClosed
	^cabin isDoorClosed.! !

!ElevatorController methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 03:01:04'!
isCabinDoorClosing
	^cabin isDoorClosing.! !

!ElevatorController methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 03:01:09'!
isCabinDoorOpened
	^cabin isDoorOpened.! !

!ElevatorController methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 03:22:18'!
isCabinDoorOpening
	^cabin isDoorOpening.! !

!ElevatorController methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 03:22:22'!
isCabinMoving
	^cabin isMoving.! !

!ElevatorController methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 03:22:07'!
isCabinStopped
	^cabin isStopped.! !

!ElevatorController methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 03:22:28'!
isCabinWaitingForPeople
	^cabin isWaitingForPeople.! !

!ElevatorController methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 02:59:43'!
isIdle
	^requests size = 0
	! !

!ElevatorController methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 02:59:50'!
isNext: aFloor
	requests first = aFloor.! !

!ElevatorController methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 02:59:57'!
isWorking
	^(self isIdle) not! !

!ElevatorController methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 14:35:24'!
onFloor: aFloor
	cabin onFloor: aFloor! !

!ElevatorController methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 02:53:11'!
openCabinDoor
	cabin openDoor.! !

!ElevatorController methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/12/2017 03:36:38'!
waitForPeopleTimedOut
	cabin closeDoor.
! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ElevatorController class' category: #'Elevator-Ejercicio'!
ElevatorController class
	instanceVariableNames: ''!

!ElevatorController class methodsFor: 'as yet unclassified' stamp: 'rok 10/2/2017 18:42:48'!
new
	
	| instance |
	
	instance := super new.
	
	instance initialize.
	
	^instance! !
