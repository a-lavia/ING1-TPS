!classDefinition: #NotFound category: #'CodigoRepetido-Ejercicio'!
Error subclass: #NotFound
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CodigoRepetido-Ejercicio'!


!classDefinition: #IdiomTest category: #'CodigoRepetido-Ejercicio'!
TestCase subclass: #IdiomTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CodigoRepetido-Ejercicio'!

!IdiomTest methodsFor: 'helpers' stamp: 'a-lavia 9/7/2017 14:58:04'!
assertRunTimeOf: aBlock  isLessThan: milliseconds
	| millisecondsTime |
	
	millisecondsTime := self runTimeOfBlock: aBlock.
	
	self assert: millisecondsTime < milliseconds! !

!IdiomTest methodsFor: 'helpers' stamp: 'a-lavia 9/7/2017 15:31:59'!
forMethod: method onError: error  withCondition: errorCondition assert: sanityCondition
	[ method value. self fail ]
	on: error
	do: [ :anError | self assert: (errorCondition value: anError). self assert: sanityCondition value.]! !

!IdiomTest methodsFor: 'helpers' stamp: 'rok 9/7/2017 14:37:41'!
runTimeOfBlock: aBlock

	|millisecondsBeforeRunning millisecondsAfterRunning|
	
	millisecondsBeforeRunning := Time millisecondClockValue.
	aBlock value.
	millisecondsAfterRunning := Time millisecondClockValue.
	
	^(millisecondsAfterRunning - millisecondsBeforeRunning).! !


!IdiomTest methodsFor: 'testing' stamp: 'a-lavia 9/5/2017 01:13:12'!
test01AddingCustomerShouldNotTakeMoreThan50Milliseconds

	| customerBook |
	
	customerBook := CustomerBook  new.
	
	self assertRunTimeOf: [customerBook addCustomerNamed: 'John Lennon'.] isLessThan: 50.
	
! !

!IdiomTest methodsFor: 'testing' stamp: 'a-lavia 9/5/2017 01:14:02'!
test02RemovingCustomerShouldNotTakeMoreThan100Milliseconds

	| customerBook paulMcCartney |
	
	customerBook := CustomerBook  new.
	paulMcCartney := 'Paul McCartney'.
	
	customerBook addCustomerNamed: paulMcCartney.
	  
	self assertRunTimeOf: [customerBook removeCustomerNamed: paulMcCartney.] isLessThan: 100.
	
! !

!IdiomTest methodsFor: 'testing' stamp: 'a-lavia 9/7/2017 15:32:30'!
test03CanNotAddACustomerWithEmptyName 

	| customerBook |
			
	customerBook := CustomerBook new.
	
	self forMethod: [ customerBook addCustomerNamed: ''. ] 
	onError: Error
	withCondition: [:anError | anError messageText = CustomerBook customerCanNotBeEmptyErrorMessage.] 
	assert: [customerBook isEmpty.]! !

!IdiomTest methodsFor: 'testing' stamp: 'a-lavia 9/7/2017 15:33:05'!
test04CanNotRemoveAnInvalidCustomer
	
	| customerBook johnLennon |
			
	customerBook := CustomerBook new.
	johnLennon := 'John Lennon'.
	customerBook addCustomerNamed: johnLennon.
	
	self forMethod: [ customerBook removeCustomerNamed: 'Paul McCartney'. ]
	onError: NotFound
	withCondition: [:anError | customerBook numberOfCustomers = 1.]
	assert: [customerBook includesCustomerNamed: johnLennon.]! !


!classDefinition: #CustomerBook category: #'CodigoRepetido-Ejercicio'!
Object subclass: #CustomerBook
	instanceVariableNames: 'customers'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CodigoRepetido-Ejercicio'!

!CustomerBook methodsFor: 'testing' stamp: 'HernanWilkinson 7/6/2011 17:56'!
includesCustomerNamed: aName

	^customers includes: aName ! !

!CustomerBook methodsFor: 'testing' stamp: 'HernanWilkinson 7/6/2011 17:48'!
isEmpty
	
	^customers isEmpty  ! !


!CustomerBook methodsFor: 'initialization' stamp: 'HernanWilkinson 7/6/2011 17:42'!
initialize

	super initialize.
	customers := OrderedCollection new! !


!CustomerBook methodsFor: 'customer management' stamp: 'HernanWilkinson 7/6/2011 17:42'!
addCustomerNamed: aName

	aName isEmpty ifTrue: [ self signalCustomerNameCannotBeEmpty ].
	(customers includes: aName) ifTrue: [ self signalCustomerAlreadyExists ].
	
	customers add: aName ! !

!CustomerBook methodsFor: 'customer management' stamp: 'HernanWilkinson 7/6/2011 17:56'!
numberOfCustomers
	
	^customers size! !

!CustomerBook methodsFor: 'customer management' stamp: 'HAW 4/14/2017 16:55:43'!
removeCustomerNamed: aName
 
	customers remove: aName ifAbsent: [ NotFound signal ]! !

!CustomerBook methodsFor: 'customer management' stamp: 'HernanWilkinson 7/6/2011 17:52'!
signalCustomerAlreadyExists 

	self error: self class customerAlreadyExistsErrorMessage! !

!CustomerBook methodsFor: 'customer management' stamp: 'HernanWilkinson 7/6/2011 17:51'!
signalCustomerNameCannotBeEmpty 

	self error: self class customerCanNotBeEmptyErrorMessage ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CustomerBook class' category: #'CodigoRepetido-Ejercicio'!
CustomerBook class
	instanceVariableNames: ''!

!CustomerBook class methodsFor: 'error messages' stamp: 'HernanWilkinson 7/6/2011 17:57'!
customerAlreadyExistsErrorMessage

	^'Customer already exists'! !

!CustomerBook class methodsFor: 'error messages' stamp: 'HernanWilkinson 7/6/2011 17:53'!
customerCanNotBeEmptyErrorMessage

	^'Customer name cannot be empty'! !
