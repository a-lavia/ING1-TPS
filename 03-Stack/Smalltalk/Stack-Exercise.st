!classDefinition: #OOStackTest category: #'Stack-Exercise'!
TestCase subclass: #OOStackTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!OOStackTest methodsFor: 'test' stamp: 'HernanWilkinson 5/7/2012 11:30'!
test01StackShouldBeEmptyWhenCreated

	| stack |
	
	stack := OOStack new.
	
	self assert: stack isEmpty! !

!OOStackTest methodsFor: 'test' stamp: 'HernanWilkinson 5/7/2012 11:30'!
test02PushAddElementsToTheStack

	| stack |
	
	stack := OOStack new.
	stack push: 'Something'.
	
	self deny: stack isEmpty! !

!OOStackTest methodsFor: 'test' stamp: 'HernanWilkinson 5/7/2012 11:31'!
test03PopRemovesElementsFromTheStack

	| stack |
	
	stack := OOStack new.
	stack push: 'Something'.
	stack pop.
	
	self assert: stack isEmpty! !

!OOStackTest methodsFor: 'test' stamp: 'HernanWilkinson 5/8/2012 08:20'!
test04PopReturnsLastPushedObject

	| stack pushedObject |
	
	stack := OOStack new.
	pushedObject := 'Something'.
	stack push: pushedObject.
	
	self assert: stack pop = pushedObject! !

!OOStackTest methodsFor: 'test' stamp: 'HernanWilkinson 5/7/2012 11:33'!
test05StackBehavesLIFO

	| stack firstPushedObject secondPushedObject |
	
	stack := OOStack new.
	firstPushedObject := 'First'.
	secondPushedObject := 'Second'.
	
	stack push: firstPushedObject.
	stack push: secondPushedObject.
	
	self assert: stack pop = secondPushedObject.
	self assert: stack pop = firstPushedObject.
	self assert: stack isEmpty 
	! !

!OOStackTest methodsFor: 'test' stamp: 'HernanWilkinson 5/7/2012 11:35'!
test06TopReturnsLastPushedObject

	| stack pushedObject |
	
	stack := OOStack new.
	pushedObject := 'Something'.
	
	stack push: pushedObject.
	
	self assert: stack top = pushedObject.
	! !

!OOStackTest methodsFor: 'test' stamp: 'HernanWilkinson 5/7/2012 11:36'!
test07TopDoesNotRemoveObjectFromStack

	| stack pushedObject |
	
	stack := OOStack new.
	pushedObject := 'Something'.
	
	stack push: pushedObject.
	
	self assert: stack size = 1.
	stack top.
	self assert: stack size = 1.
	! !

!OOStackTest methodsFor: 'test' stamp: 'HAW 4/14/2017 22:48:26'!
test08CanNotPopWhenThereAreNoObjectsInTheStack

	| stack  |
	
	stack := OOStack new.
	self
		should: [ stack pop ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: anError messageText = OOStack stackEmptyErrorDescription ]
		
! !

!OOStackTest methodsFor: 'test' stamp: 'HAW 4/14/2017 22:48:36'!
test09CanNotPopWhenThereAreNoObjectsInTheStackAndTheStackHadObjects

	| stack  |
	
	stack := OOStack new.
	stack push: 'Something'.
	stack pop.
	
	self
		should: [ stack pop ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: anError messageText = OOStack stackEmptyErrorDescription ]
		
! !

!OOStackTest methodsFor: 'test' stamp: 'HAW 4/14/2017 22:48:44'!
test10CanNotTopWhenThereAreNoObjectsInTheStack

	| stack  |
	
	stack := OOStack new.
	self
		should: [ stack top ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: anError messageText = OOStack stackEmptyErrorDescription ]
		
! !


!classDefinition: #EmptyStack category: #'Stack-Exercise'!
Object subclass: #EmptyStack
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!EmptyStack methodsFor: 'as yet unclassified' stamp: 'a-lavia 9/15/2017 19:43:41'!
size
	^0! !

!EmptyStack methodsFor: 'as yet unclassified' stamp: 'a-lavia 9/15/2017 19:46:24'!
top
	^self error: OOStack stackEmptyErrorDescription.! !


!classDefinition: #OOStack category: #'Stack-Exercise'!
Object subclass: #OOStack
	instanceVariableNames: 'stack'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!OOStack methodsFor: 'initialization' stamp: 'a-lavia 9/15/2017 19:35:18'!
initialize
	stack := EmptyStack new.! !


!OOStack methodsFor: 'operations' stamp: 'a-lavia 9/15/2017 20:54:06'!
isEmpty
	^stack size = 0.! !

!OOStack methodsFor: 'operations' stamp: 'a-lavia 9/15/2017 19:36:39'!
pop
	| anObject |
	
	anObject := stack top.
	stack := stack tail.
	^anObject.! !

!OOStack methodsFor: 'operations' stamp: 'a-lavia 9/15/2017 19:39:06'!
push: anObject 
	stack := PopulatedStack with: anObject tail: stack! !

!OOStack methodsFor: 'operations' stamp: 'a-lavia 9/15/2017 19:41:45'!
size
	^stack size.! !

!OOStack methodsFor: 'operations' stamp: 'a-lavia 9/15/2017 20:08:37'!
top
	^stack top.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OOStack class' category: #'Stack-Exercise'!
OOStack class
	instanceVariableNames: ''!

!OOStack class methodsFor: 'initialization' stamp: 'a-lavia 9/14/2017 04:19:56'!
new
	^super new initialize! !


!OOStack class methodsFor: 'error descriptions' stamp: 'HernanWilkinson 5/7/2012 11:51'!
stackEmptyErrorDescription
	
	^ 'Stack is empty'! !


!classDefinition: #PopulatedStack category: #'Stack-Exercise'!
Object subclass: #PopulatedStack
	instanceVariableNames: 'top tail'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!PopulatedStack methodsFor: 'as yet unclassified' stamp: 'a-lavia 9/15/2017 20:52:41'!
initializeWith: anObject tail: aStack
	top := anObject.
	tail := aStack.! !

!PopulatedStack methodsFor: 'as yet unclassified' stamp: 'a-lavia 9/15/2017 20:14:07'!
size
	^1 + tail size.! !

!PopulatedStack methodsFor: 'as yet unclassified' stamp: 'a-lavia 9/15/2017 20:11:10'!
tail
	^tail! !

!PopulatedStack methodsFor: 'as yet unclassified' stamp: 'a-lavia 9/15/2017 20:12:33'!
top
	^top! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PopulatedStack class' category: #'Stack-Exercise'!
PopulatedStack class
	instanceVariableNames: ''!

!PopulatedStack class methodsFor: 'as yet unclassified' stamp: 'a-lavia 9/15/2017 20:53:17'!
with: anObject tail: aStack
	^PopulatedStack new initializeWith: anObject tail: aStack.! !
