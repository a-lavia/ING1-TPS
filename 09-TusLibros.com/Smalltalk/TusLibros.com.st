!classDefinition: #TusLibrosTEST category: #'TusLibros.com'!
TestCase subclass: #TusLibrosTEST
	instanceVariableNames: 'aCart aCatalog anItem1 anItem2 anItem3 aValidCreditCard anExpiredCreditCard aSalesBook aMerchantProcessorBehaviour aCashier aClientsBook aValidUser aValidUserPassword aValidUserWrongPassword aUnregisteredUser xxx aBook1ISBN aBook2ISBN aValidCCN aValidCCED aValidCCO'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros.com'!

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/30/2017 01:51:17'!
addItemsToCart

	aCart add: anItem1.
	aCart add: anItem2.
	aCart add: anItem3.! !

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/30/2017 18:46:48'!
addItemsToCatalog

	aCatalog add: anItem1 with: 10 * peso.
	aCatalog add: anItem2 with: 5 * peso.
	aCatalog add: anItem3 with: 2.5 * peso.
	! !

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/2/2017 20:04:54'!
debit: anAmount from: aCreditCard
	^aMerchantProcessorBehaviour value: anAmount value: aCreditCard .! !

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/6/2017 00:47:55'!
setUp

	aCatalog _ Catalog new.
	
	aCart _ Cart with: aCatalog.
	
	anItem1 _ 'anItem1'.
	anItem2 _ 'anItem2'.
	anItem3 _ 'anItem3'.
	
	aSalesBook _ SalesBook new.

	aMerchantProcessorBehaviour :=  [:anAmount :aCreditCard | ].
	aCashier _ Cashier with: self and: aSalesBook and: self.
	
	aValidCCN := '0000000000'.
	aValidCCED := 122018.
	aValidCCO := 'Rodrigo'.
	aValidCreditCard _ CreditCard with: aValidCCN and: (December, 2018)  and: aValidCCO.
	
	anExpiredCreditCard _ CreditCard with: '0000' and: (March, 2017)  and: 'Alejandro'.

	aClientsBook := Dictionary new.
	aClientsBook at: 'validUser' put:  'validPassword' .
	
	aValidUser := 'validUser'.
	aValidUserPassword := 'validPassword'.
	aValidUserWrongPassword := 'wrongPassword'.	
	aUnregisteredUser := 'invalidUser'.

	xxx := XXX with: aClientsBook and: aCatalog and: aCashier .
	
	aBook1ISBN := anItem1 .
	aBook2ISBN := anItem2 .! !

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

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/30/2017 20:42:12'!
test05aCartDoesNotRecordsNotAddedItems

	self addItemsToCatalog.
	aCart add: anItem1 .
	
	self deny: aCart isEmpty.
	self assert: (aCart includes: anItem1).
	self deny: (aCart includes: anItem2).! !

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/30/2017 20:44:32'!
test06aCartRecordsQuantityOfItemsAdded

	self addItemsToCatalog.
	aCart add: anItem1 quantity: 3.

	self deny: aCart isEmpty.
	self assert: (aCart quantityOf: anItem1) = 3.! !

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/30/2017 21:15:25'!
test07canNotAddNonPositiveQuantityOfItemsToACart

	self addItemsToCatalog.
	
	self 
		should: [ aCart add: anItem1 quantity: -8. ]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: Cart canNotAddNonPositiveQuantityOfItemsErrorDescription.
			self assert: aCart isEmpty.
		].! !

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/2/2017 19:44:24'!
test08canNotCheckoutAnEmptyCart

	self addItemsToCatalog.
	
	self
		should: [aCashier checkout: aCart with: aValidCreditCard ]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: Cashier canNotCheckoutAnEmptyCartErrorDescription.
			self assert: aSalesBook isEmpty ].! !

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/2/2017 19:44:39'!
test09canNotCheckoutWithAnExpiredCreditCard

	self addItemsToCatalog.
	self addItemsToCart.
	
	self
		should: [ aCashier checkout: aCart with: anExpiredCreditCard ]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: anError messageText	equals: Cashier canNotCheckoutWithAnExpiredCreditCardErrorDescription.
			self assert: aSalesBook isEmpty ].! !

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/5/2017 23:13:05'!
test10aCashierCheckoutACartWithItemsAndReturnsTicketWithCorrectAmount
"renombrar"
	| aTransaction debitedAmount debitedCard |
	self addItemsToCatalog.
	self addItemsToCart.
	
	aMerchantProcessorBehaviour := [:anAmount :aCreditCard | debitedAmount := anAmount . debitedCard := aCreditCard .].
	
	aTransaction _ aCashier checkout: aCart with: aValidCreditCard.
	
	self assert: aTransaction total = (17.5 * peso).
	
	self deny: aSalesBook isEmpty .
	self assert: aSalesBook size = 1.
	
	self assert: (aTransaction = (aSalesBook obtain: (aTransaction id))).
	
	self assert: aTransaction total = debitedAmount .
	self assert: aValidCreditCard = debitedCard .! !

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/2/2017 20:59:22'!
test11aCashierCanNotCheckoutACartWithItemsUsingStolenCreditCard

	self addItemsToCatalog.
	self addItemsToCart.
	
	aMerchantProcessorBehaviour := [:anAmount :aCreditCard | self error: Cashier stolenCreditCardErrorDescription ].
	
	self should: [ aCashier checkout: aCart with: aValidCreditCard ]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: Cashier stolenCreditCardErrorDescription .
			self assert: aSalesBook isEmpty ].! !

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/2/2017 20:18:36'!
test12aCashierCanNotCheckoutACartWithItemsUsinACreditCardWithoutFunds

	self addItemsToCatalog.
	self addItemsToCart.
	
	aMerchantProcessorBehaviour := [:anAmount :aCreditCard | self error: Cashier cardWithoutFundsErrorDescription ].
		
	self should: [aCashier checkout: aCart with: aValidCreditCard ]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: Cashier cardWithoutFundsErrorDescription.
			self assert: aSalesBook isEmpty ].! !

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/5/2017 17:18:39'!
test13anUnregisteredClientCantCreateACart

	self should: [xxx createCartwith: aUnregisteredUser and: 'xxx'.]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: XXX userOrPasswordInvalidErrorDescription .
			].! !

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/5/2017 17:20:29'!
test14aClientCreateACartAndObtainACartID
	| aCartID |
	
	aCartID := xxx createCartwith: aValidUser and: aValidUserPassword .
	self assert: aCartID = 1.! !

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/5/2017 17:20:40'!
test15aRegisteredClientWithInvalidPasswordCantCreateACart
	self should: [xxx createCartwith: aValidUser and: aValidUserWrongPassword .]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: XXX userOrPasswordInvalidErrorDescription .
			].! !

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/6/2017 00:56:09'!
test16severalsCreatedCartsHaveDifferentsID
	| aCartID1 aCartID2 |
		
	aCartID1 := xxx createCartwith: aValidUser and: aValidUserPassword .
	aCartID2 := xxx createCartwith: aValidUser and: aValidUserPassword.
	
	self deny: (aCartID1 = aCartID2) .! !

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/6/2017 00:22:35'!
test17addBookISBNToUnexistentCartID
	| aUnexistenteCartID |
	
	aUnexistenteCartID := 'invalidCartID'.
		
	self should: [xxx addToCart: aUnexistenteCartID with: aBook1ISBN and: 1.]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: XXX unexistentCartIDErrorDescription .
			].! !

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/6/2017 00:22:39'!
test18addToExistentCartIDanISBNOutsideTheCatalog
	| aCartID |
	
	aCartID := xxx createCartwith: aValidUser and: aValidUserPassword .
		
	self should: [xxx addToCart: aCartID with: aBook1ISBN and: 1.]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: XXX invalidISBNErrorDescription.
			].! !

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/6/2017 00:22:43'!
test19addToExistentCartIDanISBNYYYYYYYYY
	| aCartID aCartList |
	
	self addItemsToCatalog .
	
	aCartID := xxx createCartwith: aValidUser and: aValidUserPassword .
	xxx addToCart: aCartID with: aBook1ISBN and: 1.
	
	aCartList := xxx listCart: aCartID.
	
	self assert: aCartList size = 1.
	self assert: (aCartList includes: aBook1ISBN ).! !

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/6/2017 00:47:31'!
test20aClientCanNotCheckoutAnEmptyCart
	| aCartID |
	
	self addItemsToCatalog .
	
	aCartID := xxx createCartwith: aValidUser and: aValidUserPassword .	
			
	self should: [xxx checkOutCart: aCartID ccn: aValidCCN cced: aValidCCED cco: aValidCCO.]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: XXX emptyCartErrorDescription.
			].! !

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/6/2017 00:47:41'!
test21aClientCheckoutACartWithBooks
	| aCartID aTransactionID aTransaction |
	
	self addItemsToCatalog .
	
	aCartID := xxx createCartwith: aValidUser and: aValidUserPassword.
	
	xxx addToCart: aCartID with: aBook1ISBN and: 1.
	
	aTransactionID := xxx checkOutCart: aCartID ccn: aValidCCN cced: aValidCCED cco: aValidCCO.
	
	aTransaction := aSalesBook obtain: aTransactionID .
	
	self assert: ((aTransaction total) = (10 * peso)).
	self assert: (aTransaction includes: aBook1ISBN).
	self deny: (aTransaction includes: aBook2ISBN).
	
	
	! !

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/6/2017 00:47:48'!
test22severalsTransactionsHaveDifferentsID
	| aCartID aTransactionID1 aTransactionID2 |
	
	self addItemsToCatalog .
	
	aCartID := xxx createCartwith: aValidUser and: aValidUserPassword.
	xxx addToCart: aCartID with: aBook1ISBN and: 1.
	aTransactionID1 := xxx checkOutCart: aCartID  ccn: aValidCCN cced: aValidCCED cco: aValidCCO.
	
	aCartID := xxx createCartwith: aValidUser and: aValidUserPassword.
	xxx addToCart: aCartID with: aBook1ISBN and: 1.
	aTransactionID2 := xxx checkOutCart: aCartID ccn: aValidCCN cced: aValidCCED cco: aValidCCO.
	
	self deny: (aTransactionID1 = aTransactionID2).
	! !

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/6/2017 00:51:43'!
test23aClientWithoutPucharsesGetAnEmptyList
	| aListOfPucharses |
	
	aListOfPucharses := xxx listPucharses: aValidUser and: aValidUserPassword .
	
	self assert: (aListOfPucharses isEmpty ).
	! !

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/6/2017 01:00:32'!
test24aClientWithoutPucharsesGetAnEmptyList
	| aListOfPucharses |
	
	aListOfPucharses := xxx listPucharses: aValidUser and: aValidUserPassword .
	
	self assert: (aListOfPucharses isEmpty ).
	! !

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

!Cart methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/6/2017 00:18:45'!
contents

	^content copy.! !

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

!Cart methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/6/2017 00:17:39'!
resume
	|aCartResume|
	
	aCartResume := Dictionary new.
	content do: [ :aContainedItem | aCartResume at: aContainedItem put: (catalog priceOf: aContainedItem) ].
	^aCartResume .! !

!Cart methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/30/2017 18:53:45'!
total
	| totalPrice |
	
	totalPrice := 0.
	content do: [ :aContainedItem | totalPrice := totalPrice + (catalog priceOf: aContainedItem) ].
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
	instanceVariableNames: 'calendar salesBook merchantProcessor'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros.com'!

!Cashier methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/6/2017 00:08:19'!
checkout: aCart with: aCreditCard
	| aTransaction |
	
	aCart isEmpty ifTrue: [ self error: Cashier canNotCheckoutAnEmptyCartErrorDescription ].
	(aCreditCard isExpired: calendar today monthOfYear) ifTrue: [ self error: Cashier canNotCheckoutWithAnExpiredCreditCardErrorDescription ].
	
	merchantProcessor debit: aCart total from: aCreditCard.
	
	aTransaction := Transaction with: (salesBook nextID) and: (aCart resume).
	
	salesBook add: aTransaction .
	
	^aTransaction .! !

!Cashier methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/5/2017 22:47:59'!
initializeWith: aCalendar and: aSalesBook and: aMerchantProcessor

	calendar := aCalendar .
	salesBook := aSalesBook .
	merchantProcessor := aMerchantProcessor.! !

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

!Cashier class methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/2/2017 04:45:10'!
cardWithoutFundsErrorDescription
	^'card without funds'! !

!Cashier class methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/2/2017 04:43:43'!
stolenCreditCardErrorDescription
	^'stolen card'.! !

!Cashier class methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/5/2017 18:25:37'!
with: aCalendar and: aSalesBook and: aMerchanProcessor

	^self new initializeWith: aCalendar and: aSalesBook and: aMerchanProcessor.! !


!classDefinition: #Catalog category: #'TusLibros.com'!
Object subclass: #Catalog
	instanceVariableNames: 'content'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros.com'!

!Catalog methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/6/2017 00:28:32'!
add: anItem with: aPrice

	aPrice < 0 ifTrue: [ self error: Catalog canNotRegisterAnItemWithNonPositivePriceErrorDescription ].
	content at: anItem  put: aPrice.! !

!Catalog methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/30/2017 18:51:17'!
includes: anItem

	^content includesKey: anItem.! !

!Catalog methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/30/2017 18:44:47'!
initialize

	content := Dictionary new.! !

!Catalog methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/30/2017 18:46:03'!
priceOf: anItem

	^content at: anItem .! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Catalog class' category: #'TusLibros.com'!
Catalog class
	instanceVariableNames: ''!

!Catalog class methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/30/2017 19:05:36'!
canNotRegisterAnItemWithNonPositivePriceErrorDescription

	^'invalid price'! !


!classDefinition: #CreditCard category: #'TusLibros.com'!
Object subclass: #CreditCard
	instanceVariableNames: 'expiration number owner'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros.com'!

!CreditCard methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/5/2017 23:28:41'!
initializeWith: aCreditCardNumber and: anExpirationMonthAndYear and: aCreditCardOwner

	number := aCreditCardNumber .
	expiration := anExpirationMonthAndYear.
	owner := aCreditCardOwner .! !

!CreditCard methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/30/2017 03:38:48'!
isExpired: aMonthAndYear

	^expiration  < aMonthAndYear .! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CreditCard class' category: #'TusLibros.com'!
CreditCard class
	instanceVariableNames: ''!

!CreditCard class methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/5/2017 23:41:11'!
with: aCreditCardNumber and: anExpirationMonthAndYear and: aCreditCardOwner 
	^self new initializeWith: aCreditCardNumber and: anExpirationMonthAndYear and: aCreditCardOwner! !


!classDefinition: #SalesBook category: #'TusLibros.com'!
Object subclass: #SalesBook
	instanceVariableNames: 'transactions'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros.com'!

!SalesBook methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/6/2017 00:33:27'!
add: aTransaction 

	transactions at: (aTransaction id) put: aTransaction.! !

!SalesBook methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/6/2017 00:33:24'!
initialize

	transactions := Dictionary new.! !

!SalesBook methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/6/2017 00:33:21'!
isEmpty

	^transactions isEmpty .! !

!SalesBook methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/6/2017 00:32:33'!
nextID

	^transactions size.! !

!SalesBook methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/6/2017 00:33:16'!
obtain: aTransactionID

	^transactions at: aTransactionID ! !

!SalesBook methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/6/2017 00:33:13'!
size

	^transactions size.! !


!classDefinition: #Transaction category: #'TusLibros.com'!
Object subclass: #Transaction
	instanceVariableNames: 'id cartResume'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros.com'!

!Transaction methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/6/2017 00:34:48'!
id

	^id.! !

!Transaction methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/6/2017 00:34:51'!
includes: anItem 

	^cartResume includesKey: anItem .! !

!Transaction methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/6/2017 00:03:50'!
initializeWith: aID and: aCartResume

	id := aID.
	cartResume := aCartResume! !

!Transaction methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/6/2017 00:11:00'!
total
	| totalPrice |
	
	totalPrice := 0.
	cartResume valuesDo: [ :aPrice | totalPrice := totalPrice + aPrice].
	^totalPrice.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Transaction class' category: #'TusLibros.com'!
Transaction class
	instanceVariableNames: ''!

!Transaction class methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/6/2017 00:07:54'!
with: aID and: aCartResume

	^self new initializeWith: aID and: aCartResume.! !


!classDefinition: #XXX category: #'TusLibros.com'!
Object subclass: #XXX
	instanceVariableNames: 'clientsBook catalog cartsRegister cartCount cashier'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros.com'!

!XXX methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/5/2017 17:56:28'!
addToCart: aCartID with: aBookISBN and: aBookQuantity 
	| aClientCart |
	aClientCart := self obtainCart: aCartID .
	aClientCart add: aBookISBN quantity: aBookQuantity .! !

!XXX methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/5/2017 23:41:52'!
checkOutCart: aCartID ccn: aCreditCardNumber cced: aCreditCardExpirationDate cco: aCreditCardOwner
	| aClientCart aTransaction aCreditCard aMonthNumber aYearNumber |
	aClientCart := self obtainCart: aCartID .
	aClientCart isEmpty ifTrue: [^self error: XXX emptyCartErrorDescription .].
	
	aYearNumber := aCreditCardExpirationDate mod: 10000.
	aMonthNumber := aCreditCardExpirationDate div: 10000.
		
	aCreditCard := CreditCard with: aCreditCardNumber and: (GregorianMonthOfYear yearNumber: aYearNumber monthNumber: aMonthNumber ) and: aCreditCardOwner .
	
	aTransaction := cashier checkout: aClientCart with: aCreditCard.
	
	^aTransaction id.! !

!XXX methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/5/2017 17:14:22'!
createCartwith: aClientID and: aPassword
	|aClientPassword|
	aClientPassword := clientsBook at: aClientID ifAbsent: [self error: XXX userOrPasswordInvalidErrorDescription].
	aClientPassword  = aPassword ifFalse: [self error: XXX userOrPasswordInvalidErrorDescription ].
	
	cartCount := cartCount +1.
	
	cartsRegister at: cartCount  put: (Cart with: catalog).
	
	^cartCount.! !

!XXX methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/5/2017 23:43:17'!
initializeWith: aClientsBook and: aCatalog and: aCashier.
	clientsBook := aClientsBook.
	catalog := aCatalog.
	cashier := aCashier.
	cartsRegister := Dictionary new.
	cartCount := 0.! !

!XXX methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/5/2017 17:56:40'!
listCart: aCartID 
	| aClientCart |
	aClientCart := self obtainCart: aCartID .
	^aClientCart contents .! !

!XXX methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/6/2017 00:52:41'!
listPucharses: aClientID and: aClientPassword
	^OrderedCollection new.! !

!XXX methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/5/2017 17:56:06'!
obtainCart: aCartID
"esto es privado"

	^cartsRegister at: aCartID ifAbsent: [self error: XXX unexistentCartIDErrorDescription.].! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'XXX class' category: #'TusLibros.com'!
XXX class
	instanceVariableNames: ''!

!XXX class methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/5/2017 20:10:36'!
emptyCartErrorDescription
	^Cashier canNotCheckoutAnEmptyCartErrorDescription .! !

!XXX class methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/5/2017 17:30:40'!
invalidISBNErrorDescription
	^Cart canNotAddItemFromOtherStoreErrorDescription.! !

!XXX class methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/5/2017 16:52:53'!
unexistentCartIDErrorDescription
	^'unexistent cart id'.! !

!XXX class methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/5/2017 16:54:51'!
userOrPasswordInvalidErrorDescription
	^'user or password invalid'.! !

!XXX class methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/5/2017 23:44:13'!
with: aClientsBook and: aCatalog and: aCashier.
	^self new initializeWith: aClientsBook and: aCatalog and: aCashier.! !
