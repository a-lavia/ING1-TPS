!classDefinition: #TusLibrosTEST category: #'TusLibros.com'!
TestCase subclass: #TusLibrosTEST
	instanceVariableNames: 'aCart aCatalog aCashier anItem1 anItem2 anItem3 aValidCreditCard anExpiredCreditCard'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros.com'!

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/30/2017 01:51:17'!
addItemsToCart

	aCart add: anItem1.
	aCart add: anItem2.
	aCart add: anItem3.! !

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/30/2017 01:51:07'!
addItemsToCatalog

	aCatalog add: anItem1.
	aCatalog add: anItem2.
	aCatalog add: anItem3.! !

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/30/2017 04:23:56'!
setUp

	aCatalog _ Set new.
	
	aCart _ Cart with: aCatalog.
	
	anItem1 _ Item withPrice: 10 * peso.
	anItem2 _ Item withPrice: 5 * peso.
	anItem3 _ Item withPrice: 2.5 * peso.
	
	aCashier _ Cashier with: self.
	
	aValidCreditCard _ CreditCard withExpiration: (December, 2018).
	anExpiredCreditCard _ CreditCard withExpiration: (March, 2017).! !

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/26/2017 23:37:03'!
test01whenACartIsCreatedIsEmpty
	
	self assert: aCart isEmpty.! !

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/30/2017 01:43:46'!
test02whenAnItemIsAddedToACartIsNotEmpty

	self addItemsToCatalog.
	self addItemsToCart.

	self deny: aCart isEmpty. ! !

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/30/2017 01:43:27'!
test03canNotAddAnItemOutsideTheCatalogToACart

	self 
		should: [ self addItemsToCart. ]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: Cart canNotAddItemFromOtherStoreErrorDescription.
			self assert: aCart isEmpty.
		].! !

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/30/2017 01:53:06'!
test04aCartRecordsItemsAdded

	self addItemsToCatalog.
	self addItemsToCart .
	
	self deny: aCart isEmpty.
	self assert: (aCart includes: anItem1).
	self assert: (aCart includes: anItem3).! !

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/30/2017 01:53:34'!
test05aCartRecordsQuantityOfItemsAdded

	self addItemsToCatalog.
	aCart add: anItem1 quantity: 3.

	self deny: aCart isEmpty.
	self assert: (aCart quantityOf: anItem1) = 3.! !

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/30/2017 03:24:06'!
test06canNotAddNonPositveQuantityOfItemsToACart

	self addItemsToCatalog.
	
	self 
		should: [ aCart add: anItem1 quantity: -8. ]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: Cart canNotAddNonPositiveQuantityOfItemsErrorDescription.
			self assert: aCart isEmpty.
		].! !

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/30/2017 03:23:09'!
test07canNotCheckoutAnEmptyCart

	self addItemsToCatalog.
	
	self 
		should: [ aCashier checkout: aCart with: aValidCreditCard]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: Cashier canNotCheckoutAnEmptyCartErrorDescription.
		].! !

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/30/2017 03:25:29'!
test08canNotCheckoutWithAnExpiredCreditCard

	self addItemsToCatalog.
	self addItemsToCart.
	
	self 
		should: [ aCashier checkout: aCart with: anExpiredCreditCard ]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: Cashier canNotCheckoutWithAnExpiredCreditCardErrorDescription .
		].! !

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/30/2017 04:31:13'!
test09aTransactionSumsOperationTotal

	| aTransaction |
	
	self addItemsToCatalog.
	self addItemsToCart.
	
	aTransaction := aCashier checkout: aCart with: aValidCreditCard .
	
	self assert: (aTransaction total = (17.5 * peso))! !

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/30/2017 04:09:52'!
today

	^FixedGregorianDate yearNumber: 2017 monthNumber: 10 dayNumber: 30.! !


!classDefinition: #Cart category: #'TusLibros.com'!
Object subclass: #Cart
	instanceVariableNames: 'content catalog'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros.com'!

!Cart methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/29/2017 00:08:45'!
add: anItem

	(catalog includes: anItem) ifFalse: [ self error: Cart canNotAddItemFromOtherStoreErrorDescription ].
	content add: anItem.! !

!Cart methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/29/2017 00:08:50'!
add: anItem quantity: aQuantity 

	(aQuantity > 0) ifFalse: [ self error: Cart canNotAddNonPositiveQuantityOfItemsErrorDescription ].
	aQuantity timesRepeat: [ self add: anItem ].! !

!Cart methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/30/2017 01:48:34'!
includes: anItem 

	^content includes: anItem.! !

!Cart methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/29/2017 00:08:57'!
initializeWith: aCatalog

	content := OrderedCollection new. 
	catalog := aCatalog.! !

!Cart methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/29/2017 00:09:05'!
isEmpty

	^content isEmpty.! !

!Cart methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/29/2017 00:09:13'!
quantityOf: anItem 
	| quantity |
	
	quantity := 0.
	content do: [ :aContainedItem | (anItem = aContainedItem) ifTrue: [ quantity := quantity + 1 ] ].
	^quantity.! !

!Cart methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/30/2017 04:29:30'!
total
	| totalPrice |
	
	totalPrice := 0.
	content do: [ :aContainedItem | totalPrice := totalPrice + aContainedItem price ].
	^totalPrice.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cart class' category: #'TusLibros.com'!
Cart class
	instanceVariableNames: 'catalog'!

!Cart class methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/28/2017 23:45:57'!
canNotAddItemFromOtherStoreErrorDescription
	^'invalid item'! !

!Cart class methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/29/2017 00:07:54'!
canNotAddNonPositiveQuantityOfItemsErrorDescription
	^'invalid quantity'! !

!Cart class methodsFor: 'as yet unclassified' stamp: 'yn 10/26/2017 20:17:48'!
with: aCatalog 
	^self new initializeWith: aCatalog.! !


!classDefinition: #Cashier category: #'TusLibros.com'!
Object subclass: #Cashier
	instanceVariableNames: 'calendar'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros.com'!

!Cashier methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/30/2017 04:32:34'!
checkout: aCart with: aCreditCard

	(aCart isEmpty) ifTrue: [self error: Cashier canNotCheckoutAnEmptyCartErrorDescription ].
	
	(aCreditCard isExpired: calendar today monthOfYear) ifTrue: [self error: Cashier canNotCheckoutWithAnExpiredCreditCardErrorDescription ].
	
	^Transaction with: (aCart total).! !

!Cashier methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/30/2017 03:40:01'!
initializeWith: aCalendar

	calendar := aCalendar ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cashier class' category: #'TusLibros.com'!
Cashier class
	instanceVariableNames: ''!

!Cashier class methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/29/2017 06:13:03'!
canNotCheckoutAnEmptyCartErrorDescription

	^'cant checkout empty cart'.! !

!Cashier class methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/30/2017 03:25:21'!
canNotCheckoutWithAnExpiredCreditCardErrorDescription
	^'cant checkout with expired credit card'! !

!Cashier class methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/30/2017 03:40:23'!
with: aCalendar

	^self new initializeWith: aCalendar .! !


!classDefinition: #CreditCard category: #'TusLibros.com'!
Object subclass: #CreditCard
	instanceVariableNames: 'expiration'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros.com'!

!CreditCard methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/30/2017 03:36:07'!
initializeWith: anExpirationMonthAndYear

	expiration := anExpirationMonthAndYear.! !

!CreditCard methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/30/2017 03:38:48'!
isExpired: aMonthAndYear

	^expiration  < aMonthAndYear .! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CreditCard class' category: #'TusLibros.com'!
CreditCard class
	instanceVariableNames: ''!

!CreditCard class methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/30/2017 03:36:01'!
withExpiration: anExpirationMonthAndYear

	^self new initializeWith: anExpirationMonthAndYear.! !


!classDefinition: #Item category: #'TusLibros.com'!
Object subclass: #Item
	instanceVariableNames: 'price'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros.com'!

!Item methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/30/2017 04:22:10'!
initializeWith: aPrice

	price := aPrice.! !

!Item methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/30/2017 04:29:41'!
price

	^price .! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Item class' category: #'TusLibros.com'!
Item class
	instanceVariableNames: ''!

!Item class methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/30/2017 04:24:09'!
withPrice: aPrice

	^self new initializeWith: aPrice.! !


!classDefinition: #Transaction category: #'TusLibros.com'!
Object subclass: #Transaction
	instanceVariableNames: 'total'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros.com'!

!Transaction methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/30/2017 04:31:26'!
initializeWith: aTotalTransactionCost

	total := aTotalTransactionCost ! !

!Transaction methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/30/2017 04:22:40'!
total

	^total.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Transaction class' category: #'TusLibros.com'!
Transaction class
	instanceVariableNames: ''!

!Transaction class methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/30/2017 04:30:53'!
with: aTotalTransactionCost

	^self new initializeWith: aTotalTransactionCost .! !
