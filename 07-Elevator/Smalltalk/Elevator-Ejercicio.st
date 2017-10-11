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


!classDefinition: #CabinState category: #'Elevator-Ejercicio'!
Object subclass: #CabinState
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!CabinState methodsFor: 'actions' stamp: 'rok 10/10/2017 19:50:49'!
cabinOnFloor: aFloor with: aController

	self subclassResponsibility .! !

!CabinState methodsFor: 'actions' stamp: 'rok 10/10/2017 20:00:49'!
closeCabinDoorWith: aDoorState

	self subclassResponsibility .! !

!CabinState methodsFor: 'actions' stamp: 'rok 10/10/2017 19:39:44'!
openCabinDoorWith: aDoorState

	self subclassResponsibility .! !


!CabinState methodsFor: 'queries' stamp: 'rok 10/10/2017 01:46:18'!
isCabinMoving

	self subclassResponsibility .! !

!CabinState methodsFor: 'queries' stamp: 'rok 10/10/2017 01:46:13'!
isCabinStopped

	self subclassResponsibility .! !


!classDefinition: #CabinStateMoving category: #'Elevator-Ejercicio'!
CabinState subclass: #CabinStateMoving
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!CabinStateMoving methodsFor: 'actions' stamp: 'rok 10/10/2017 19:57:47'!
cabinOnFloor: aFloor with: aController

	aController onFloor: aFloor .
	
	^CabinStateStopped new! !

!CabinStateMoving methodsFor: 'actions' stamp: 'rok 10/10/2017 20:04:27'!
closeCabinDoorWith: aDoorState

	^aDoorState ! !

!CabinStateMoving methodsFor: 'actions' stamp: 'rok 10/10/2017 19:45:43'!
openCabinDoorWith: aDoorState

	^aDoorState 

	! !


!CabinStateMoving methodsFor: 'queries' stamp: 'rok 10/10/2017 01:48:14'!
isCabinMoving

	^true! !

!CabinStateMoving methodsFor: 'queries' stamp: 'rok 10/10/2017 19:11:20'!
isCabinStopped

	^false! !


!classDefinition: #CabinStateStopped category: #'Elevator-Ejercicio'!
CabinState subclass: #CabinStateStopped
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!CabinStateStopped methodsFor: 'actions' stamp: 'rok 10/10/2017 23:05:12'!
cabinOnFloor: aFloor with: aController

	ElevatorEmergency doorSensorNotSync .! !

!CabinStateStopped methodsFor: 'actions' stamp: 'rok 10/10/2017 20:08:46'!
closeCabinDoorWith: aDoorState

	^aDoorState cabinDoorClosing ! !

!CabinStateStopped methodsFor: 'actions' stamp: 'rok 10/10/2017 19:45:07'!
openCabinDoorWith: aDoorState

	^ aDoorState cabinDoorOpening ! !


!CabinStateStopped methodsFor: 'queries' stamp: 'rok 10/10/2017 01:47:13'!
isCabinMoving

	^false! !

!CabinStateStopped methodsFor: 'queries' stamp: 'rok 10/10/2017 19:11:32'!
isCabinStopped

	^true! !


!classDefinition: #DoorState category: #'Elevator-Ejercicio'!
Object subclass: #DoorState
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!DoorState methodsFor: 'actions' stamp: 'rok 10/10/2017 01:37:36'!
cabinDoorClosed

	self subclassResponsibility .! !

!DoorState methodsFor: 'actions' stamp: 'rok 10/10/2017 02:06:40'!
cabinDoorClosing

	^self subclassResponsibility .! !

!DoorState methodsFor: 'actions' stamp: 'rok 10/10/2017 01:37:32'!
cabinDoorOpened

	self subclassResponsibility .! !

!DoorState methodsFor: 'actions' stamp: 'rok 10/10/2017 02:06:28'!
cabinDoorOpening

	self subclassResponsibility .! !


!DoorState methodsFor: 'queries' stamp: 'rok 10/10/2017 01:51:09'!
isCabinDoorClosed

	self subclassResponsibility .! !

!DoorState methodsFor: 'queries' stamp: 'rok 10/10/2017 01:51:25'!
isCabinDoorClosing

	self subclassResponsibility .! !

!DoorState methodsFor: 'queries' stamp: 'rok 10/10/2017 01:51:14'!
isCabinDoorOpened

	self subclassResponsibility .! !

!DoorState methodsFor: 'queries' stamp: 'rok 10/10/2017 01:51:29'!
isCabinDoorOpening

	self subclassResponsibility .! !


!classDefinition: #DoorStateClosed category: #'Elevator-Ejercicio'!
DoorState subclass: #DoorStateClosed
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!DoorStateClosed methodsFor: 'as yet unclassified' stamp: 'rok 10/10/2017 23:04:57'!
cabinDoorClosed

	ElevatorEmergency doorSensorNotSync .! !

!DoorStateClosed methodsFor: 'as yet unclassified' stamp: 'rok 10/10/2017 20:06:18'!
cabinDoorClosing

	^self! !

!DoorStateClosed methodsFor: 'as yet unclassified' stamp: 'rok 10/10/2017 02:05:25'!
cabinDoorOpened

	^DoorStateOpened new! !

!DoorStateClosed methodsFor: 'as yet unclassified' stamp: 'rok 10/10/2017 02:20:53'!
cabinDoorOpening

	^DoorStateOpening new! !

!DoorStateClosed methodsFor: 'as yet unclassified' stamp: 'rok 10/10/2017 01:51:52'!
isCabinDoorClosed

	^true! !

!DoorStateClosed methodsFor: 'as yet unclassified' stamp: 'rok 10/10/2017 01:52:05'!
isCabinDoorClosing

	^false! !

!DoorStateClosed methodsFor: 'as yet unclassified' stamp: 'rok 10/10/2017 01:52:02'!
isCabinDoorOpened

	^false! !

!DoorStateClosed methodsFor: 'as yet unclassified' stamp: 'rok 10/10/2017 01:52:10'!
isCabinDoorOpening

	^false! !


!classDefinition: #DoorStateClosing category: #'Elevator-Ejercicio'!
DoorState subclass: #DoorStateClosing
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!DoorStateClosing methodsFor: 'as yet unclassified' stamp: 'rok 10/10/2017 20:16:54'!
cabinDoorClosed

	^DoorStateClosed new! !

!DoorStateClosing methodsFor: 'as yet unclassified' stamp: 'rok 10/10/2017 20:06:36'!
cabinDoorClosing

	^self! !

!DoorStateClosing methodsFor: 'as yet unclassified' stamp: 'rok 10/10/2017 02:14:18'!
cabinDoorOpened

	^DoorStateOpened new! !

!DoorStateClosing methodsFor: 'as yet unclassified' stamp: 'rok 10/10/2017 02:21:21'!
cabinDoorOpening

	^DoorStateOpening new! !

!DoorStateClosing methodsFor: 'as yet unclassified' stamp: 'rok 10/10/2017 01:52:53'!
isCabinDoorClosed

	^false! !

!DoorStateClosing methodsFor: 'as yet unclassified' stamp: 'rok 10/10/2017 01:52:35'!
isCabinDoorClosing

	^true! !

!DoorStateClosing methodsFor: 'as yet unclassified' stamp: 'rok 10/10/2017 01:52:45'!
isCabinDoorOpened

	^false! !

!DoorStateClosing methodsFor: 'as yet unclassified' stamp: 'rok 10/10/2017 01:53:08'!
isCabinDoorOpening

	^false! !


!classDefinition: #DoorStateOpened category: #'Elevator-Ejercicio'!
DoorState subclass: #DoorStateOpened
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!DoorStateOpened methodsFor: 'as yet unclassified' stamp: 'rok 10/10/2017 01:43:03'!
cabinDoorClosed! !

!DoorStateOpened methodsFor: 'as yet unclassified' stamp: 'rok 10/10/2017 22:43:37'!
cabinDoorClosing

	^DoorStateClosing new! !

!DoorStateOpened methodsFor: 'as yet unclassified' stamp: 'rok 10/10/2017 02:14:57'!
cabinDoorOpened

	^self! !

!DoorStateOpened methodsFor: 'as yet unclassified' stamp: 'rok 10/10/2017 19:47:17'!
cabinDoorOpening

	^self! !

!DoorStateOpened methodsFor: 'as yet unclassified' stamp: 'rok 10/10/2017 01:53:30'!
isCabinDoorClosed

	^false! !

!DoorStateOpened methodsFor: 'as yet unclassified' stamp: 'rok 10/10/2017 01:53:45'!
isCabinDoorClosing

	^false! !

!DoorStateOpened methodsFor: 'as yet unclassified' stamp: 'rok 10/10/2017 01:53:23'!
isCabinDoorOpened

	^true! !

!DoorStateOpened methodsFor: 'as yet unclassified' stamp: 'rok 10/10/2017 01:54:26'!
isCabinDoorOpening

	^false! !


!classDefinition: #DoorStateOpening category: #'Elevator-Ejercicio'!
DoorState subclass: #DoorStateOpening
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!DoorStateOpening methodsFor: 'as yet unclassified' stamp: 'rok 10/10/2017 23:05:25'!
cabinDoorClosed

	ElevatorEmergency doorSensorNotSync .! !

!DoorStateOpening methodsFor: 'as yet unclassified' stamp: 'rok 10/10/2017 22:49:19'!
cabinDoorClosing

	^self! !

!DoorStateOpening methodsFor: 'as yet unclassified' stamp: 'rok 10/10/2017 02:15:30'!
cabinDoorOpened

	^DoorStateOpened new! !

!DoorStateOpening methodsFor: 'as yet unclassified' stamp: 'rok 10/10/2017 02:21:43'!
cabinDoorOpening

	^self! !

!DoorStateOpening methodsFor: 'as yet unclassified' stamp: 'rok 10/10/2017 01:55:04'!
isCabinDoorClosed

	^false! !

!DoorStateOpening methodsFor: 'as yet unclassified' stamp: 'rok 10/10/2017 01:54:55'!
isCabinDoorClosing

	^false! !

!DoorStateOpening methodsFor: 'as yet unclassified' stamp: 'rok 10/10/2017 01:55:09'!
isCabinDoorOpened

	^false! !

!DoorStateOpening methodsFor: 'as yet unclassified' stamp: 'rok 10/10/2017 01:54:44'!
isCabinDoorOpening

	^true! !


!classDefinition: #ElevatorController category: #'Elevator-Ejercicio'!
Object subclass: #ElevatorController
	instanceVariableNames: 'cabinState doorState floor requests'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!ElevatorController methodsFor: 'as yet unclassified' stamp: 'rok 10/10/2017 23:05:41'!
cabinDoorClosed

	( self isIdle ) ifTrue: [ ElevatorEmergency doorSensorNotSync . ].

	doorState := doorState cabinDoorClosed .
	cabinState := CabinStateMoving new .! !

!ElevatorController methodsFor: 'as yet unclassified' stamp: 'rok 10/10/2017 02:13:08'!
cabinDoorOpened
	
	requests removeFirst.
	doorState := doorState cabinDoorOpened .
	! !

!ElevatorController methodsFor: 'as yet unclassified' stamp: 'rok 10/2/2017 19:17:08'!
cabinFloorNumber

	^floor! !

!ElevatorController methodsFor: 'as yet unclassified' stamp: 'rok 10/10/2017 23:05:53'!
cabinOnFloor: aFloor 
	
	( ( floor + 1 = aFloor ) not ) ifTrue: [ ElevatorEmergency doorSensorNotSync . ].
	
	doorState := doorState cabinDoorOpening .
	cabinState := cabinState cabinOnFloor: aFloor with: self . ! !

!ElevatorController methodsFor: 'as yet unclassified' stamp: 'rok 10/10/2017 20:19:54'!
closeCabinDoor

	"((self isIdle) or: (self isCabinMoving) or: (self isCabinWaitingForPeople) not) ifFalse: [doorState  := #closing]."
	( self isIdle ) ifFalse: [ doorState := cabinState closeCabinDoorWith: doorState . ].! !

!ElevatorController methodsFor: 'as yet unclassified' stamp: 'rok 10/10/2017 19:07:49'!
goUpPushedFromFloor: aFloor

	doorState := DoorStateClosing new .	
	requests add: aFloor.! !

!ElevatorController methodsFor: 'as yet unclassified' stamp: 'rok 10/10/2017 20:11:30'!
initialize

	floor _ 0.
	cabinState _ CabinStateStopped new.
	doorState _ DoorStateOpened new.
	requests _ OrderedCollection new.! !

!ElevatorController methodsFor: 'as yet unclassified' stamp: 'rok 10/10/2017 19:08:26'!
isCabinDoorClosed
	
	^doorState isCabinDoorClosed ! !

!ElevatorController methodsFor: 'as yet unclassified' stamp: 'rok 10/10/2017 19:08:44'!
isCabinDoorClosing
	
	^doorState isCabinDoorClosing ! !

!ElevatorController methodsFor: 'as yet unclassified' stamp: 'rok 10/10/2017 19:08:57'!
isCabinDoorOpened

	^doorState isCabinDoorOpened ! !

!ElevatorController methodsFor: 'as yet unclassified' stamp: 'rok 10/10/2017 19:09:07'!
isCabinDoorOpening
	
	^doorState isCabinDoorOpening ! !

!ElevatorController methodsFor: 'as yet unclassified' stamp: 'rok 10/10/2017 19:10:31'!
isCabinMoving

	^cabinState isCabinMoving ! !

!ElevatorController methodsFor: 'as yet unclassified' stamp: 'rok 10/10/2017 19:11:47'!
isCabinStopped

	^cabinState isCabinStopped ! !

!ElevatorController methodsFor: 'as yet unclassified' stamp: 'rok 10/5/2017 18:37:39'!
isCabinWaitingForPeople

	^self isCabinDoorOpened.! !

!ElevatorController methodsFor: 'as yet unclassified' stamp: 'rok 10/2/2017 21:09:15'!
isIdle
	
	^requests size = 0
	! !

!ElevatorController methodsFor: 'as yet unclassified' stamp: 'rok 10/6/2017 00:42:19'!
isNext: aFloor

	requests first = aFloor.! !

!ElevatorController methodsFor: 'as yet unclassified' stamp: 'rok 10/2/2017 20:00:56'!
isWorking

	^(self isIdle) not! !

!ElevatorController methodsFor: 'as yet unclassified' stamp: 'rok 10/10/2017 19:55:06'!
onFloor: aFloor

	floor := aFloor ! !

!ElevatorController methodsFor: 'as yet unclassified' stamp: 'rok 10/10/2017 19:46:16'!
openCabinDoor
	
	"(self isCabinMoving or: self isCabinDoorOpened) ifFalse: [ doorState := #opening. ]."
	doorState := cabinState openCabinDoorWith: doorState .! !

!ElevatorController methodsFor: 'as yet unclassified' stamp: 'rok 10/10/2017 19:17:58'!
waitForPeopleTimedOut

	doorState := DoorStateClosing new.
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
