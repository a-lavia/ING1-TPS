!classDefinition: #TusLibrosTEST category: #'TusLibros.com'!
TestCase subclass: #TusLibrosTEST
	instanceVariableNames: 'aCart aCatalog anItem'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros.com'!

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/26/2017 23:44:41'!
setUp
	aCatalog _ Set new.
	aCart _ Cart with: aCatalog.
	anItem _ 'testItem'.! !

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/26/2017 23:37:03'!
test01whenACartIsCreatedIsEmpty
	
	self assert: aCart isEmpty.! !

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/26/2017 23:45:29'!
test02whenAnItemIsAddedCartIsNotEmpty

	aCatalog add: anItem.
	aCart add: anItem.

	self deny: aCart isEmpty. ! !

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/26/2017 23:57:04'!
test03cantAddAnItemFromOtherStoreToTheCart

	self 
		should: [ aCart add: anItem. ]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: aCart isEmpty.
		].! !

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/26/2017 23:38:25'!
test04canAddSereveralItemsToTheCart

	aCatalog add: anItem.
	aCart add: anItem quantity: 3.

	self deny: aCart isEmpty.
	self assert: (aCart quantityOf: anItem) = 3! !


!classDefinition: #Cart category: #'TusLibros.com'!
Object subclass: #Cart
	instanceVariableNames: 'content catalog'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros.com'!

!Cart methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/26/2017 23:57:49'!
add: anItem
	(catalog includes: anItem) ifFalse: [ self error ]. 
	content add: anItem.! !

!Cart methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/26/2017 23:59:50'!
add: anItem quantity: aQuantity 
	(aQuantity > 0) ifFalse: [ self error ].
	aQuantity timesRepeat: [ self add: anItem ].! !

!Cart methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/26/2017 23:43:55'!
initializeWith: aCatalog
	content := OrderedCollection new. 
	catalog := aCatalog.! !

!Cart methodsFor: 'as yet unclassified' stamp: 'yn 10/26/2017 20:07:47'!
isEmpty
	^content isEmpty.! !

!Cart methodsFor: 'as yet unclassified' stamp: 'yn 10/26/2017 21:10:55'!
quantityOf: anItem 
	| quantity |
	quantity := 0.
	content do: [ :aContainedItem | (anItem = aContainedItem) ifTrue: [ quantity := quantity + 1 ] ].
	^quantity.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cart class' category: #'TusLibros.com'!
Cart class
	instanceVariableNames: 'catalog'!

!Cart class methodsFor: 'as yet unclassified' stamp: 'yn 10/26/2017 20:17:48'!
with: aCatalog 
	^self new initializeWith: aCatalog.! !
