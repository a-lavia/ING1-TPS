!classDefinition: #TusLibrosTEST category: #'TusLibros.com'!
TestCase subclass: #TusLibrosTEST
	instanceVariableNames: 'aCart aCatalog aBook1ISBN aBook2ISBN aBook3ISBN aValidCreditCard anExpiredCreditCard aSalesBook aMerchantProcessorBehaviour aCashier aClientsBook aValidUser aValidUserPassword aValidUserWrongPassword aUnregisteredUser aREST aStore currentTime'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros.com'!

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/6/2017 06:11:06'!
addItemsToCart

	aCart add: aBook1ISBN .
	aCart add: aBook2ISBN.
	aCart add: aBook3ISBN quantity: 2.
! !

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/6/2017 02:59:57'!
addItemsToCatalog

	aCatalog add: aBook1ISBN with: 10 * peso.
	aCatalog add: aBook2ISBN with: 5 * peso.
	aCatalog add: aBook3ISBN with: 2.5 * peso.
	! !

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/6/2017 06:59:11'!
advance: milliseconds
	currentTime := currentTime + milliseconds .! !

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/2/2017 20:04:54'!
debit: anAmount from: aCreditCard
	^aMerchantProcessorBehaviour value: anAmount value: aCreditCard .! !

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/6/2017 06:59:25'!
now
	^currentTime.! !

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/6/2017 06:59:47'!
setUp

	currentTime _ 32423324 * millisecond .
	
	aCatalog _ Catalog new.
	
	aCart _ Cart with: aCatalog.
	
	aBook1ISBN _ '978-3-16-148410-0'.
	aBook2ISBN _ '978-3-16-148411-0'.
	aBook3ISBN _ '978-3-16-148412-0'.
	
	aSalesBook _ SalesBook new.

	aMerchantProcessorBehaviour :=  [:anAmount :aCreditCard | ].
	aCashier _ Cashier with: self and: aSalesBook and: self.
	
	aValidCreditCard _ CreditCard with: '5400000000000001' and: (December, 2018)  and: 'Rodrigo '.
	anExpiredCreditCard _ CreditCard with: '5400000000000002' and: (March, 2017)  and: 'Alejandro'.

	aValidUser := 'validUser'.
	aValidUserPassword := 'validPassword'.
	
	aClientsBook := Dictionary new.
	aClientsBook at: aValidUser put:  aValidUserPassword.
	
	aValidUserWrongPassword := 'wrongPassword'.	
	aUnregisteredUser := 'invalidUser'.

	aStore _ Store with: aCatalog and: aCashier.
	
	aREST := REST with: aClientsBook and: aStore and: self.! !

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

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/6/2017 03:02:33'!
test04aCartRecordsItemsAdded

	self addItemsToCatalog.
	self addItemsToCart .
	
	self deny: aCart isEmpty.
	self assert: (aCart includes: aBook1ISBN ).
	self assert: (aCart includes: aBook3ISBN ).! !

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/6/2017 03:01:42'!
test05aCartDoesNotRecordsNotAddedItems

	self addItemsToCatalog.
	aCart add: aBook1ISBN .
	
	self deny: aCart isEmpty.
	self assert: (aCart includes: aBook1ISBN ).
	self deny: (aCart includes: aBook2ISBN ).! !

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/6/2017 03:01:50'!
test06aCartRecordsQuantityOfItemsAdded

	self addItemsToCatalog.
	aCart add: aBook1ISBN quantity: 3.

	self deny: aCart isEmpty.
	self assert: (aCart quantityOf: aBook1ISBN ) = 3.! !

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/6/2017 05:45:34'!
test07canNotAddNonPositiveQuantityOfItemsToACart

	self addItemsToCatalog.
	
	self 
		should: [ aCart add: aBook1ISBN quantity: -8. ]
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

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/6/2017 06:15:21'!
test10aCashierCheckoutACartWithItemsAndReturnsTicketWithCorrectAmount

	| aTransaction debitedAmount debitedCard |
	self addItemsToCatalog.
	self addItemsToCart.
	
	aMerchantProcessorBehaviour := [:anAmount :aCreditCard | debitedAmount := anAmount . debitedCard := aCreditCard .].
	
	aTransaction _ aCashier checkout: aCart with: aValidCreditCard.
	
	self assert: aTransaction total = (20.0 * peso).
	
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

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/6/2017 03:35:55'!
test13anUnregisteredClientCantCreateACart

	self should: [aREST createCartwith: aUnregisteredUser and: 'xxx'.]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: REST userOrPasswordInvalidErrorDescription .
			].! !

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/6/2017 05:46:12'!
test14aRegisteredClientCreateACartAndObtainACartIDOfAnEmptyCart
	| aCartID |
	
	aCartID := aREST createCartwith: aValidUser and: aValidUserPassword .
	self assert: ((aREST contentOf: aCartID) isEmpty).! !

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/6/2017 03:42:37'!
test15aRegisteredClientWithInvalidPasswordCantCreateACart
	self should: [aREST createCartwith: aValidUser and: aValidUserWrongPassword .]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: REST userOrPasswordInvalidErrorDescription .
			].! !

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/6/2017 03:42:44'!
test16severalsCreatedCartsHaveDifferentsID
	| aCartID1 aCartID2 |
		
	aCartID1 := aREST createCartwith: aValidUser and: aValidUserPassword .
	aCartID2 := aREST createCartwith: aValidUser and: aValidUserPassword.
	
	self deny: (aCartID1 = aCartID2) .! !

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/6/2017 05:46:29'!
test17cantAddBookISBNToUnexistentCartID
	| aUnexistenteCartID |
	
	aUnexistenteCartID := 'invalidCartID'.
		
	self should: [aREST addTo: aUnexistenteCartID isbn: aBook1ISBN quantity: 1.]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: Store unexistentCartIDErrorDescription .
			].! !

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/6/2017 05:46:59'!
test18cantAddToExistentCartIDaBookISBNOutsideTheCatalog
	| aCartID |
	
	aCartID := aREST createCartwith: aValidUser and: aValidUserPassword .
		
	self should: [aREST addTo: aCartID isbn: aBook1ISBN quantity: 1.]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: Store invalidISBNErrorDescription.
			].! !

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/6/2017 05:51:07'!
test19aExistentCartIDHoldsACartThatRecordsAddedsBookISBN
	| aCartID aCartContent |
	
	self addItemsToCatalog .
	
	aCartID := aREST createCartwith: aValidUser and: aValidUserPassword .
	aREST addTo: aCartID isbn: aBook1ISBN quantity: 3.
	
	aCartContent := aREST contentOf: aCartID.
	
	self assert: aCartContent size = 3.
	self assert: (aCartContent includes: aBook1ISBN ).! !

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/6/2017 03:49:17'!
test20aClientCanNotCheckoutAnEmptyCart
	| aCartID |
	
	self addItemsToCatalog .
	
	aCartID := aREST createCartwith: aValidUser and: aValidUserPassword .	
			
	self should: [aREST checkout: aCartID with: aValidCreditCard ]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: Store emptyCartErrorDescription.
			].! !

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/6/2017 05:51:53'!
test21aRegisteredClientCheckoutACartWithBooksAndObtainsTransactionID
	| aCartID aTransactionID aTransaction |
	
	self addItemsToCatalog .
	
	aCartID := aREST createCartwith: aValidUser and: aValidUserPassword.
	
	aREST addTo: aCartID isbn: aBook1ISBN quantity: 1.
	
	aTransactionID := aREST checkout: aCartID with: aValidCreditCard .
	
	aTransaction := aSalesBook obtain: aTransactionID .
	
	self assert: ((aTransaction total) = (10 * peso)).
	self assert: (aTransaction includes: aBook1ISBN).
	self deny: (aTransaction includes: aBook2ISBN).
	
	
	! !

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/6/2017 04:09:09'!
test22severalsTransactionsHaveDifferentsID
	| aCartID aTransactionID1 aTransactionID2 |
	
	self addItemsToCatalog .
	
	aCartID := aREST createCartwith: aValidUser and: aValidUserPassword.
	aREST addTo: aCartID isbn: aBook1ISBN quantity: 1.
	aTransactionID1 := aREST checkout: aCartID  with: aValidCreditCard .
	
	aCartID := aREST createCartwith: aValidUser and: aValidUserPassword.
	aREST addTo: aCartID isbn: aBook1ISBN quantity: 1.
	aTransactionID2 := aREST checkout: aCartID with: aValidCreditCard .
	
	self deny: (aTransactionID1 = aTransactionID2).
	! !

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/6/2017 05:53:44'!
test23listingPucharsesOfARegisteredClientWithoutAnyGetAnEmptyList
	| aListOfPucharses |
	
	aListOfPucharses := aREST pucharsesOf: aValidUser and: aValidUserPassword .
	
	self assert: (aListOfPucharses isEmpty ).
	! !

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/6/2017 06:09:11'!
test24listingPucharsesOfaRegisteredClientGetAllTheTransactions

	| aCartID aTransactionID aListOfPucharses |
	
	self addItemsToCatalog .
	
	aCartID := aREST createCartwith: aValidUser and: aValidUserPassword.
	aREST addTo: aCartID isbn: aBook1ISBN quantity: 3.
	aTransactionID := aREST checkout: aCartID with: aValidCreditCard.
	
	aListOfPucharses := aREST pucharsesOf: aValidUser and: aValidUserPassword .
	
	self assert: (aListOfPucharses size = 1 ).
	self assert: (aListOfPucharses first id) = aTransactionID.
	self assert: ((aSalesBook obtain: aTransactionID) includes: aBook1ISBN ).
	self assert:  (((aSalesBook obtain: aTransactionID) quantityOf: aBook1ISBN ) = 3)! !

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/6/2017 07:08:02'!
test25cantOperateWithACartUnusedFor30Minutes

	| aCartID |
	
	self addItemsToCatalog .
	
	aCartID := aREST createCartwith: aValidUser and: aValidUserPassword.
	
	self advance: (18 * minute ).
	
	aREST addTo: aCartID isbn: aBook1ISBN quantity: 3.
	
	self advance: (32 * minute ).
	
	self should: [aREST checkout: aCartID with: aValidCreditCard ]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: REST cartTimeOutErrorDescription .
			].! !

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

!Cart methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/6/2017 06:06:54'!
resume
	|aCartResume|
	
	aCartResume := Dictionary new.
	content do: [ :aContainedItem | aCartResume at: aContainedItem put: { (catalog priceOf: aContainedItem) . (self quantityOf: aContainedItem) }].
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


!classDefinition: #REST category: #'TusLibros.com'!
Object subclass: #REST
	instanceVariableNames: 'store clientsBook cartsLastAccessedTime timeProvider'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros.com'!

!REST methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/6/2017 06:33:02'!
addTo: aCartID isbn: aBookISBN quantity: aBookQuantity 
	self cartAccess: aCartID .
	store addTo: aCartID isbn: aBookISBN quantity: aBookQuantity .! !

!REST methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/6/2017 03:18:10'!
authenticate: aClientID with: aPassword
	|aClientPassword|
	
	aClientPassword := clientsBook at: aClientID ifAbsent: [self error: REST userOrPasswordInvalidErrorDescription].
	aClientPassword  = aPassword ifFalse: [self error: REST userOrPasswordInvalidErrorDescription ].! !

!REST methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/6/2017 07:04:08'!
cartAccess: aCartID
	| lastAccesedTime |
	lastAccesedTime := 	cartsLastAccessedTime at: aCartID ifAbsentPut: timeProvider now.
	((timeProvider now-lastAccesedTime ) > (30 * minute)) ifTrue: [self error: REST cartTimeOutErrorDescription].
	cartsLastAccessedTime at: aCartID put: (timeProvider now).! !

!REST methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/6/2017 06:32:55'!
checkout: aCartID with: aCreditCard
	| aTransactionID |
	self cartAccess: aCartID .
	aTransactionID := store checkout: aCartID with: aCreditCard.
	^aTransactionID.! !

!REST methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/6/2017 06:32:49'!
contentOf: aCartID 
	| aClientCart |
	self cartAccess: aCartID .
	aClientCart := store obtainCart: aCartID .
	^aClientCart contents .! !

!REST methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/6/2017 06:32:35'!
createCartwith: aClientID and: aPassword
	| aCartID |
	
	self authenticate: aClientID with: aPassword .
	aCartID := store createCartFor: aClientID.
	
	self cartAccess: aCartID .
	
	^aCartID .! !

!REST methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/6/2017 06:33:38'!
initializeWith: aClientsBook and: aStore and: aTimeProvider

	clientsBook := aClientsBook .
	store := aStore .
	timeProvider := aTimeProvider .
	cartsLastAccessedTime := Dictionary new.! !

!REST methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/6/2017 05:54:51'!
pucharsesOf: aClientID and: aClientPassword

	self authenticate: aClientID with: aClientPassword .
	^store obtainTransactionsRecord: aClientID .! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'REST class' category: #'TusLibros.com'!
REST class
	instanceVariableNames: ''!

!REST class methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/6/2017 06:37:25'!
cartTimeOutErrorDescription
	^'cart time out'! !

!REST class methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/6/2017 03:41:50'!
userOrPasswordInvalidErrorDescription

	^'user or password invalid'.! !

!REST class methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/6/2017 06:33:51'!
with: aClientsBook and: aStore and: aTimeProvider
	^self new initializeWith: aClientsBook and: aStore and: aTimeProvider .! !


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


!classDefinition: #Store category: #'TusLibros.com'!
Object subclass: #Store
	instanceVariableNames: 'catalog cashier clientPucharsesRecord cartsRegister cartsOwners'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros.com'!

!Store methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/6/2017 03:10:53'!
addTo: aCartID isbn: aBookISBN quantity: aBookQuantity 
	| aClientCart |
	
	aClientCart := self obtainCart: aCartID .
	aClientCart add: aBookISBN quantity: aBookQuantity .! !

!Store methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/6/2017 05:55:27'!
checkout: aCartID with: aCreditCard
	| aClientCart aTransaction aCartOwnerID aClientRecord |
	
	aClientCart := self obtainCart: aCartID .
	
	aTransaction := cashier checkout: aClientCart with: aCreditCard.
	
	aCartOwnerID := cartsOwners at: aCartID .
	aClientRecord := self obtainTransactionsRecord: aCartOwnerID .
	aClientRecord add: aTransaction .
	
	^aTransaction id.! !

!Store methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/6/2017 03:34:02'!
createCartFor: aClientID
	| aCartID |
	
	aCartID := cartsRegister size.
	cartsRegister at: aCartID  put: (Cart with: catalog).
	cartsOwners at: aCartID put: aClientID .
	
	^aCartID.! !

!Store methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/6/2017 03:32:53'!
initializeWith: aCatalog and: aCashier
	catalog := aCatalog.
	cashier := aCashier.
	
	clientPucharsesRecord := Dictionary new.
	
	cartsRegister := Dictionary new.
	cartsOwners := Dictionary new.! !

!Store methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/6/2017 05:55:20'!
obtainCart: aCartID

	^cartsRegister at: aCartID ifAbsent: [self error: Store unexistentCartIDErrorDescription.].! !

!Store methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/6/2017 05:55:16'!
obtainTransactionsRecord: aClientID

	^clientPucharsesRecord at: aClientID ifAbsentPut: [OrderedCollection new.]. ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Store class' category: #'TusLibros.com'!
Store class
	instanceVariableNames: ''!

!Store class methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/6/2017 03:50:49'!
emptyCartErrorDescription
	^Cashier canNotCheckoutAnEmptyCartErrorDescription .! !

!Store class methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/6/2017 03:45:20'!
invalidISBNErrorDescription

	^Cart canNotAddItemFromOtherStoreErrorDescription.! !

!Store class methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/6/2017 03:43:16'!
unexistentCartIDErrorDescription

	^'unexistent cart id'.! !

!Store class methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/6/2017 03:34:52'!
with: aCatalog and: aCashier
	^self new initializeWith: aCatalog and: aCashier.! !


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

!Transaction methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/6/2017 06:18:06'!
quantityOf: anItem

	^(cartResume at: anItem) at: 2.! !

!Transaction methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/6/2017 06:16:54'!
total
	| totalPrice |
	
	totalPrice := 0.
	cartResume valuesDo: [ :itemResume | totalPrice := totalPrice + ((itemResume at: 1) * (itemResume at: 2))].
	^totalPrice.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Transaction class' category: #'TusLibros.com'!
Transaction class
	instanceVariableNames: ''!

!Transaction class methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/6/2017 00:07:54'!
with: aID and: aCartResume

	^self new initializeWith: aID and: aCartResume.! !
