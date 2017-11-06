!classDefinition: #TusLibrosTEST category: #'TusLibros.com'!
TestCase subclass: #TusLibrosTEST
	instanceVariableNames: 'aCart aCatalog aBook1ISBN aBook2ISBN aBook3ISBN aValidCreditCard anExpiredCreditCard aSalesBook aMerchantProcessorBehaviour aCashier aClientsBook aCartsAdministrator aREST currentTime aClient aClientPassword aClientWrongPassword aUnregisteredClient aClientRecord'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros.com'!

!TusLibrosTEST methodsFor: 'tests' stamp: 'a-lavia 10/26/2017 23:37:03'!
test01whenACartIsCreatedIsEmpty
	
	self assert: aCart isEmpty.! !

!TusLibrosTEST methodsFor: 'tests' stamp: 'a-lavia 10/30/2017 01:43:46'!
test02whenAnItemIsAddedToACartIsNotEmpty

	self addItemsToCatalog.
	self addItemsToCart.

	self deny: aCart isEmpty. ! !

!TusLibrosTEST methodsFor: 'tests' stamp: 'a-lavia 10/30/2017 01:43:27'!
test03canNotAddAnItemOutsideTheCatalogToACart

	self 
		should: [ self addItemsToCart. ]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: Cart canNotAddItemFromOtherStoreErrorDescription.
			self assert: aCart isEmpty.
		].! !

!TusLibrosTEST methodsFor: 'tests' stamp: 'a-lavia 11/6/2017 03:02:33'!
test04aCartRecordsItemsAdded

	self addItemsToCatalog.
	self addItemsToCart .
	
	self deny: aCart isEmpty.
	self assert: (aCart includes: aBook1ISBN ).
	self assert: (aCart includes: aBook3ISBN ).! !

!TusLibrosTEST methodsFor: 'tests' stamp: 'a-lavia 11/6/2017 03:01:42'!
test05aCartDoesNotRecordsNotAddedItems

	self addItemsToCatalog.
	aCart add: aBook1ISBN .
	
	self deny: aCart isEmpty.
	self assert: (aCart includes: aBook1ISBN ).
	self deny: (aCart includes: aBook2ISBN ).! !

!TusLibrosTEST methodsFor: 'tests' stamp: 'a-lavia 11/6/2017 03:01:50'!
test06aCartRecordsQuantityOfItemsAdded

	self addItemsToCatalog.
	aCart add: aBook1ISBN quantity: 3.

	self deny: aCart isEmpty.
	self assert: (aCart quantityOf: aBook1ISBN ) = 3.! !

!TusLibrosTEST methodsFor: 'tests' stamp: 'a-lavia 11/6/2017 05:45:34'!
test07canNotAddNonPositiveQuantityOfItemsToACart

	self addItemsToCatalog.
	
	self 
		should: [ aCart add: aBook1ISBN quantity: -8. ]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: Cart canNotAddNonPositiveQuantityOfItemsErrorDescription.
			self assert: aCart isEmpty.
		].! !

!TusLibrosTEST methodsFor: 'tests' stamp: 'a-lavia 11/6/2017 15:36:33'!
test08canNotCheckoutAnEmptyCart

	self addItemsToCatalog.
	
	self
		should: [aCashier checkout: aCart with: aValidCreditCard for: aClient ]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: Cashier canNotCheckoutAnEmptyCartErrorDescription.
			self assert: aSalesBook isEmpty ].! !

!TusLibrosTEST methodsFor: 'tests' stamp: 'a-lavia 11/6/2017 15:36:39'!
test09canNotCheckoutWithAnExpiredCreditCard

	self addItemsToCatalog.
	self addItemsToCart.
	
	self
		should: [ aCashier checkout: aCart with: anExpiredCreditCard for: aClient ]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: anError messageText	equals: Cashier canNotCheckoutWithAnExpiredCreditCardErrorDescription.
			self assert: aSalesBook isEmpty ].! !

!TusLibrosTEST methodsFor: 'tests' stamp: 'a-lavia 11/6/2017 15:36:24'!
test10aCashierCheckoutACartWithItemsAndReturnsTicketWithCorrectAmount

	| aTransaction debitedAmount debitedCard |
	self addItemsToCatalog.
	self addItemsToCart.
	
	aMerchantProcessorBehaviour := [:anAmount :aCreditCard | debitedAmount := anAmount . debitedCard := aCreditCard .].
	
	aTransaction _ aCashier checkout: aCart with: aValidCreditCard for: aClient .
	
	self assert: aTransaction total = (20.0 * peso).
	
	self deny: aSalesBook isEmpty .
	self assert: aSalesBook size = 1.
	
	self assert: (aTransaction = (aSalesBook obtain: (aTransaction id))).
	
	self assert: aTransaction total = debitedAmount .
	self assert: aValidCreditCard = debitedCard .! !

!TusLibrosTEST methodsFor: 'tests' stamp: 'a-lavia 11/6/2017 15:36:45'!
test11aCashierCanNotCheckoutACartWithItemsUsingStolenCreditCard

	self addItemsToCatalog.
	self addItemsToCart.
	
	aMerchantProcessorBehaviour := [:anAmount :aCreditCard | self error: Cashier stolenCreditCardErrorDescription ].
	
	self should: [ aCashier checkout: aCart with: aValidCreditCard for: aClient ]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: Cashier stolenCreditCardErrorDescription .
			self assert: aSalesBook isEmpty ].! !

!TusLibrosTEST methodsFor: 'tests' stamp: 'a-lavia 11/6/2017 15:47:04'!
test12aCashierCanNotCheckoutACartWithItemsUsinACreditCardWithoutFunds

	self addItemsToCatalog.
	self addItemsToCart.
	
	aMerchantProcessorBehaviour := [:anAmount :aCreditCard | self error: Cashier cardWithoutFundsErrorDescription ].
		
	self should: [ aCashier checkout: aCart with: aValidCreditCard for: aClient ]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: Cashier cardWithoutFundsErrorDescription.
			self assert: aSalesBook isEmpty ].! !

!TusLibrosTEST methodsFor: 'tests' stamp: 'a-lavia 11/6/2017 14:49:54'!
test13anUnregisteredClientCantCreateACart

	self should: [aREST createCartwith: aUnregisteredClient and: 'xxx'.]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: REST userOrPasswordInvalidErrorDescription .
			].! !

!TusLibrosTEST methodsFor: 'tests' stamp: 'a-lavia 11/6/2017 14:50:04'!
test14aRegisteredClientCreateACartAndObtainACartIDOfAnEmptyCart
	| aCartID |
	
	aCartID := aREST createCartwith: aClient and: aClientPassword .
	self assert: ((aREST contentOf: aCartID) isEmpty).! !

!TusLibrosTEST methodsFor: 'tests' stamp: 'a-lavia 11/6/2017 14:50:15'!
test15aRegisteredClientWithInvalidPasswordCantCreateACart
	self should: [aREST createCartwith: aClient and: aClientWrongPassword .]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: REST userOrPasswordInvalidErrorDescription .
			].! !

!TusLibrosTEST methodsFor: 'tests' stamp: 'a-lavia 11/6/2017 14:50:31'!
test16severalsCreatedCartsHaveDifferentsID
	| aCartID1 aCartID2 |
		
	aCartID1 := aREST createCartwith: aClient and: aClientPassword .
	aCartID2 := aREST createCartwith: aClient and: aClientPassword .
	
	self deny: (aCartID1 = aCartID2) .! !

!TusLibrosTEST methodsFor: 'tests' stamp: 'a-lavia 11/6/2017 15:46:36'!
test17cantAddBookISBNToUnexistentCartID
	| aUnexistenteCartID |
	
	aUnexistenteCartID _ 'invalidCartID'.
	self
		should: [ aREST addTo: aUnexistenteCartID isbn: aBook1ISBN quantity: 1 ]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: CartSessionAdministrator unexistentCartIDErrorDescription 
			].! !

!TusLibrosTEST methodsFor: 'tests' stamp: 'a-lavia 11/6/2017 16:25:35'!
test18cantAddToExistentCartIDaBookISBNOutsideTheCatalog
	| aCartID |
	
	aCartID := aREST createCartwith: aClient and: aClientPassword .
		
	self should: [aREST addTo: aCartID isbn: aBook1ISBN quantity: 1.]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: Cart canNotAddItemFromOtherStoreErrorDescription .
			self assert: ((aREST contentOf: aCartID) isEmpty)
			].! !

!TusLibrosTEST methodsFor: 'tests' stamp: 'a-lavia 11/6/2017 14:51:30'!
test19aExistentCartIDHoldsACartThatRecordsAddedsBookISBN
	| aCartID aCartContent |
	
	self addItemsToCatalog .
	
	aCartID := aREST createCartwith: aClient and: aClientPassword .
	aREST addTo: aCartID isbn: aBook1ISBN quantity: 3.
	
	aCartContent := aREST contentOf: aCartID.
	
	self assert: aCartContent size = 3.
	self assert: (aCartContent includes: aBook1ISBN ).! !

!TusLibrosTEST methodsFor: 'tests' stamp: 'a-lavia 11/6/2017 16:28:12'!
test20aClientCanNotCheckoutAnEmptyCart
	| aCartID |
	
	self addItemsToCatalog .
	
	aCartID := aREST createCartwith: aClient and: aClientPassword .	
			
	self should: [aREST checkout: aCartID with: aValidCreditCard ]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: Cashier canNotCheckoutAnEmptyCartErrorDescription .
			self assert: (aSalesBook isEmpty).
			].! !

!TusLibrosTEST methodsFor: 'tests' stamp: 'a-lavia 11/6/2017 14:51:39'!
test21aRegisteredClientCheckoutACartWithBooksAndObtainsTransactionID
	| aCartID aTransactionID aTransaction |
	
	self addItemsToCatalog .
	
	aCartID := aREST createCartwith: aClient and: aClientPassword .
	
	aREST addTo: aCartID isbn: aBook1ISBN quantity: 1.
	
	aTransactionID := aREST checkout: aCartID with: aValidCreditCard .
	
	aTransaction := aSalesBook obtain: aTransactionID .
	
	self assert: ((aTransaction total) = (10 * peso)).
	self assert: (aTransaction includes: aBook1ISBN).
	self deny: (aTransaction includes: aBook2ISBN).
	
	
	! !

!TusLibrosTEST methodsFor: 'tests' stamp: 'a-lavia 11/6/2017 14:51:48'!
test22severalsTransactionsHaveDifferentsID
	| aCartID aTransactionID1 aTransactionID2 |
	
	self addItemsToCatalog .
	
	aCartID := aREST createCartwith: aClient and: aClientPassword .
	aREST addTo: aCartID isbn: aBook1ISBN quantity: 1.
	aTransactionID1 := aREST checkout: aCartID  with: aValidCreditCard .
	
	aCartID := aREST createCartwith: aClient and: aClientPassword .
	aREST addTo: aCartID isbn: aBook1ISBN quantity: 1.
	aTransactionID2 := aREST checkout: aCartID with: aValidCreditCard .
	
	self deny: (aTransactionID1 = aTransactionID2).
	! !

!TusLibrosTEST methodsFor: 'tests' stamp: 'a-lavia 11/6/2017 14:51:56'!
test23listingPucharsesOfARegisteredClientWithoutAnyGetAnEmptyList
	| aListOfPucharses |
	
	aListOfPucharses := aREST pucharsesOf: aClient and: aClientPassword .
	
	self assert: (aListOfPucharses isEmpty ).
	! !

!TusLibrosTEST methodsFor: 'tests' stamp: 'a-lavia 11/6/2017 14:52:05'!
test24listingPucharsesOfaRegisteredClientGetAllTheTransactions

	| aCartID aTransactionID aListOfPucharses |
	
	self addItemsToCatalog .
	
	aCartID := aREST createCartwith: aClient and: aClientPassword .
	aREST addTo: aCartID isbn: aBook1ISBN quantity: 3.
	aTransactionID := aREST checkout: aCartID with: aValidCreditCard.
	
	aListOfPucharses := aREST pucharsesOf: aClient and: aClientPassword .
	
	self assert: (aListOfPucharses size = 1 ).
	self assert: (aListOfPucharses first id) = aTransactionID.
	self assert: ((aSalesBook obtain: aTransactionID) includes: aBook1ISBN ).
	self assert:  (((aSalesBook obtain: aTransactionID) quantityOf: aBook1ISBN ) = 3)! !

!TusLibrosTEST methodsFor: 'tests' stamp: 'a-lavia 11/6/2017 15:44:27'!
test25cantOperateWithACartUnusedFor30Minutes
	| aCartID |
	self addItemsToCatalog.
	
	aCartID _ aREST createCartwith: aClient and: aClientPassword.
	
	self advance: 18 * minute.
	
	aREST addTo: aCartID isbn: aBook1ISBN quantity: 3.
	
	self advance: 30 * minute.
	
	self
		should: [ aREST checkout: aCartID with: aValidCreditCard ]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: CartSessionAdministrator cartTimeOutErrorDescription 
			].! !


!TusLibrosTEST methodsFor: 'setUp' stamp: 'a-lavia 11/6/2017 06:11:06'!
addItemsToCart

	aCart add: aBook1ISBN .
	aCart add: aBook2ISBN.
	aCart add: aBook3ISBN quantity: 2.
! !

!TusLibrosTEST methodsFor: 'setUp' stamp: 'a-lavia 11/6/2017 02:59:57'!
addItemsToCatalog

	aCatalog add: aBook1ISBN with: 10 * peso.
	aCatalog add: aBook2ISBN with: 5 * peso.
	aCatalog add: aBook3ISBN with: 2.5 * peso.
	! !

!TusLibrosTEST methodsFor: 'setUp' stamp: 'a-lavia 11/6/2017 16:30:47'!
setUp

	"el setup fue ampliandose a medida que avanzamos con los tests, inicializa cosas demas para algunos tests, futuro refactor recategorizar los tests e incluir factory que inicializa solo lo necesario"
	
	currentTime _ 32423324 * millisecond.
	
	aCatalog _ Catalog new.
	
	aCart _ Cart with: aCatalog.
	
	aBook1ISBN _ '978-3-16-148410-0'.
	aBook2ISBN _ '978-3-16-148411-0'.
	aBook3ISBN _ '978-3-16-148412-0'.
	
	aSalesBook _ SalesBook new.
	aClientRecord _ Dictionary new.
	
	aMerchantProcessorBehaviour _ [ :anAmount :aCreditCard | ].
	
	aCashier _ Cashier with: self and: aSalesBook and: self and: aClientRecord.
		
	aValidCreditCard _ CreditCard with: '5400000000000001' and: December , 2018 and: 'Rodrigo '.
		
	anExpiredCreditCard _ CreditCard with: '5400000000000002' and: March , 2017 and: 'Alejandro'.
		
	aClient _ 'Alejandro'.
	aClientPassword _ 'validPassword'.
	
	aClientsBook _ Dictionary new.
	aClientsBook at: aClient put: aClientPassword.
	
	aClientWrongPassword _ 'wrongPassword'.
	
	aUnregisteredClient _ 'Pedro'.
	
	aCartsAdministrator _ CartSessionAdministrator with: aCatalog and: self.
		
	aREST _ REST with: aClientsBook and: aCashier and: aCartsAdministrator.! !


!TusLibrosTEST methodsFor: 'simulator' stamp: 'a-lavia 11/6/2017 14:47:00'!
advance: milliseconds

	currentTime := currentTime + milliseconds .! !

!TusLibrosTEST methodsFor: 'simulator' stamp: 'a-lavia 11/6/2017 14:46:56'!
debit: anAmount from: aCreditCard

	^aMerchantProcessorBehaviour value: anAmount value: aCreditCard .! !

!TusLibrosTEST methodsFor: 'simulator' stamp: 'a-lavia 11/6/2017 14:47:04'!
now

	^currentTime.! !

!TusLibrosTEST methodsFor: 'simulator' stamp: 'a-lavia 10/30/2017 04:09:52'!
today

	^FixedGregorianDate yearNumber: 2017 monthNumber: 10 dayNumber: 30.! !


!classDefinition: #Cart category: #'TusLibros.com'!
Object subclass: #Cart
	instanceVariableNames: 'catalog content'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros.com'!

!Cart methodsFor: 'actions' stamp: 'a-lavia 10/29/2017 00:08:45'!
add: anItem

	(catalog includes: anItem) ifFalse: [ self error: Cart canNotAddItemFromOtherStoreErrorDescription ].
	content add: anItem.! !

!Cart methodsFor: 'actions' stamp: 'a-lavia 10/29/2017 00:08:50'!
add: anItem quantity: aQuantity 

	(aQuantity > 0) ifFalse: [ self error: Cart canNotAddNonPositiveQuantityOfItemsErrorDescription ].
	aQuantity timesRepeat: [ self add: anItem ].! !


!Cart methodsFor: 'accessing' stamp: 'a-lavia 11/6/2017 00:18:45'!
contents

	^content copy.! !

!Cart methodsFor: 'accessing' stamp: 'a-lavia 10/29/2017 00:09:13'!
quantityOf: anItem 
	| quantity |
	
	quantity := 0.
	content do: [ :aContainedItem | (anItem = aContainedItem) ifTrue: [ quantity := quantity + 1 ] ].
	^quantity.! !

!Cart methodsFor: 'accessing' stamp: 'a-lavia 11/6/2017 15:49:26'!
resume
	|aCartResume|
	
	aCartResume := Dictionary new.
	content do: [ :aContainedItem | aCartResume at: aContainedItem put: { (catalog priceOf: aContainedItem) . (self quantityOf: aContainedItem) }].
	^aCartResume .! !

!Cart methodsFor: 'accessing' stamp: 'a-lavia 10/30/2017 18:53:45'!
total
	| totalPrice |
	
	totalPrice := 0.
	content do: [ :aContainedItem | totalPrice := totalPrice + (catalog priceOf: aContainedItem) ].
	^totalPrice.! !


!Cart methodsFor: 'check' stamp: 'a-lavia 10/30/2017 01:48:34'!
includes: anItem 

	^content includes: anItem.! !

!Cart methodsFor: 'check' stamp: 'a-lavia 10/29/2017 00:09:05'!
isEmpty

	^content isEmpty.! !


!Cart methodsFor: 'initialization' stamp: 'a-lavia 11/6/2017 15:57:13'!
initializeWith: aCatalog

	catalog := aCatalog.
	content := OrderedCollection new. ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cart class' category: #'TusLibros.com'!
Cart class
	instanceVariableNames: 'catalog'!

!Cart class methodsFor: 'new' stamp: 'yn 10/26/2017 20:17:48'!
with: aCatalog 
	^self new initializeWith: aCatalog.! !


!Cart class methodsFor: 'messages' stamp: 'a-lavia 10/28/2017 23:45:57'!
canNotAddItemFromOtherStoreErrorDescription
	^'invalid item'! !

!Cart class methodsFor: 'messages' stamp: 'a-lavia 10/29/2017 00:07:54'!
canNotAddNonPositiveQuantityOfItemsErrorDescription
	^'invalid quantity'! !


!classDefinition: #CartSessionAdministrator category: #'TusLibros.com'!
Object subclass: #CartSessionAdministrator
	instanceVariableNames: 'catalog timeProvider cartsIDRegister cartsOwners cartsLastAccessedTime'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros.com'!

!CartSessionAdministrator methodsFor: 'actions' stamp: 'a-lavia 11/6/2017 15:45:12'!
cartAccess: aCartID
	| lastAccesedTime |
	
	lastAccesedTime _ cartsLastAccessedTime at: aCartID ifAbsentPut: timeProvider now.
	timeProvider now - lastAccesedTime >= (30 * minute) ifTrue: [ self error: CartSessionAdministrator cartTimeOutErrorDescription ].
	cartsLastAccessedTime at: aCartID put: timeProvider now.! !

!CartSessionAdministrator methodsFor: 'actions' stamp: 'a-lavia 11/6/2017 15:29:22'!
createCartFor: aClientID
	| aCart aCartID |

	aCart := (Cart with: catalog).
	aCartID := aCart hash.
	cartsIDRegister at: aCartID  put: aCart.
	cartsOwners at: aCartID put: aClientID .
	
	^aCartID.! !


!CartSessionAdministrator methodsFor: 'accessing' stamp: 'a-lavia 11/6/2017 15:29:32'!
clientOf: aCartID

	^cartsOwners at: aCartID ! !

!CartSessionAdministrator methodsFor: 'accessing' stamp: 'a-lavia 11/6/2017 15:45:22'!
obtain: aCartID

	self cartAccess: aCartID.
	^cartsIDRegister at: aCartID ifAbsent: [ self error: CartSessionAdministrator unexistentCartIDErrorDescription ].! !


!CartSessionAdministrator methodsFor: 'initialization' stamp: 'a-lavia 11/6/2017 15:28:52'!
initializeWith: aCatalog and: aTimeProvider
	catalog := aCatalog.
	timeProvider := aTimeProvider .
			
	cartsIDRegister := Dictionary new.
	cartsOwners := Dictionary new.
	cartsLastAccessedTime := Dictionary new.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CartSessionAdministrator class' category: #'TusLibros.com'!
CartSessionAdministrator class
	instanceVariableNames: ''!

!CartSessionAdministrator class methodsFor: 'new' stamp: 'a-lavia 11/6/2017 15:32:23'!
with: aCatalog and: aTimeProvider
	^self new initializeWith: aCatalog and: aTimeProvider .! !


!CartSessionAdministrator class methodsFor: 'messages' stamp: 'a-lavia 11/6/2017 15:20:21'!
cartTimeOutErrorDescription
	^'cart time out'! !

!CartSessionAdministrator class methodsFor: 'messages' stamp: 'a-lavia 11/6/2017 15:38:46'!
unexistentCartIDErrorDescription

	^'unexistent cart id'.! !


!classDefinition: #Cashier category: #'TusLibros.com'!
Object subclass: #Cashier
	instanceVariableNames: 'calendar salesBook clientPucharsesRecord merchantProcessor'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros.com'!

!Cashier methodsFor: 'actions' stamp: 'a-lavia 11/6/2017 14:19:27'!
checkout: aCart with: aCreditCard for: aClient
	| aTransaction aClientRecord |
	
	aCart isEmpty ifTrue: [ self error: Cashier canNotCheckoutAnEmptyCartErrorDescription ].
	(aCreditCard isExpired: calendar today monthOfYear) ifTrue: [ self error: Cashier canNotCheckoutWithAnExpiredCreditCardErrorDescription ].
	
	merchantProcessor debit: aCart total from: aCreditCard.
	
	aTransaction := Transaction with: (salesBook nextID) and: (aCart resume).
	
	salesBook add: aTransaction .
	
	aClientRecord := self obtainTransactionsRecord: aClient .
	aClientRecord add: aTransaction .
	
	^aTransaction .! !


!Cashier methodsFor: 'initialization' stamp: 'a-lavia 11/6/2017 14:18:13'!
initializeWith: aCalendar and: aSalesBook and: aMerchantProcessor and: aPucharsesRecord

	calendar := aCalendar .
	salesBook := aSalesBook .
	merchantProcessor := aMerchantProcessor.
	clientPucharsesRecord :=  aPucharsesRecord .! !


!Cashier methodsFor: 'accessing' stamp: 'a-lavia 11/6/2017 14:19:55'!
obtainTransactionsRecord: aClient

	^clientPucharsesRecord at: aClient ifAbsentPut: [OrderedCollection new.]. ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cashier class' category: #'TusLibros.com'!
Cashier class
	instanceVariableNames: ''!

!Cashier class methodsFor: 'messages' stamp: 'a-lavia 10/29/2017 06:13:03'!
canNotCheckoutAnEmptyCartErrorDescription

	^'cant checkout empty cart'.! !

!Cashier class methodsFor: 'messages' stamp: 'a-lavia 10/30/2017 03:25:21'!
canNotCheckoutWithAnExpiredCreditCardErrorDescription
	^'cant checkout with expired credit card'! !

!Cashier class methodsFor: 'messages' stamp: 'a-lavia 11/2/2017 04:45:10'!
cardWithoutFundsErrorDescription
	^'card without funds'! !

!Cashier class methodsFor: 'messages' stamp: 'a-lavia 11/6/2017 16:04:12'!
stolenCreditCardErrorDescription

	^'stolen card'.! !


!Cashier class methodsFor: 'new' stamp: 'a-lavia 11/6/2017 15:06:03'!
with: aCalendar and: aSalesBook and: aMerchanProcessor and: aClientRecord

	^self new initializeWith: aCalendar and: aSalesBook and: aMerchanProcessor and: aClientRecord .! !


!classDefinition: #Catalog category: #'TusLibros.com'!
Object subclass: #Catalog
	instanceVariableNames: 'content'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros.com'!

!Catalog methodsFor: 'actions' stamp: 'a-lavia 11/6/2017 00:28:32'!
add: anItem with: aPrice

	aPrice < 0 ifTrue: [ self error: Catalog canNotRegisterAnItemWithNonPositivePriceErrorDescription ].
	content at: anItem  put: aPrice.! !


!Catalog methodsFor: 'check' stamp: 'a-lavia 10/30/2017 18:51:17'!
includes: anItem

	^content includesKey: anItem.! !

!Catalog methodsFor: 'check' stamp: 'a-lavia 10/30/2017 18:46:03'!
priceOf: anItem

	^content at: anItem .! !


!Catalog methodsFor: 'initialization' stamp: 'a-lavia 10/30/2017 18:44:47'!
initialize

	content := Dictionary new.! !

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

!CreditCard methodsFor: 'initialization' stamp: 'a-lavia 11/5/2017 23:28:41'!
initializeWith: aCreditCardNumber and: anExpirationMonthAndYear and: aCreditCardOwner

	number := aCreditCardNumber .
	expiration := anExpirationMonthAndYear.
	owner := aCreditCardOwner .! !


!CreditCard methodsFor: 'check' stamp: 'a-lavia 10/30/2017 03:38:48'!
isExpired: aMonthAndYear

	^expiration  < aMonthAndYear .! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CreditCard class' category: #'TusLibros.com'!
CreditCard class
	instanceVariableNames: ''!

!CreditCard class methodsFor: 'new' stamp: 'a-lavia 11/5/2017 23:41:11'!
with: aCreditCardNumber and: anExpirationMonthAndYear and: aCreditCardOwner 
	^self new initializeWith: aCreditCardNumber and: anExpirationMonthAndYear and: aCreditCardOwner! !


!classDefinition: #REST category: #'TusLibros.com'!
Object subclass: #REST
	instanceVariableNames: 'cashier clientsBook cartsAdministrator'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros.com'!

!REST methodsFor: 'actions' stamp: 'a-lavia 11/6/2017 03:18:10'!
authenticate: aClientID with: aPassword
	|aClientPassword|
	
	aClientPassword := clientsBook at: aClientID ifAbsent: [self error: REST userOrPasswordInvalidErrorDescription].
	aClientPassword  = aPassword ifFalse: [self error: REST userOrPasswordInvalidErrorDescription ].! !


!REST methodsFor: 'initialization' stamp: 'a-lavia 11/6/2017 15:31:11'!
initializeWith: aClientsBook and: aCashier and: aCartAdministrator

	clientsBook := aClientsBook .
	cashier := aCashier.
	cartsAdministrator := aCartAdministrator ! !


!REST methodsFor: 'operations' stamp: 'a-lavia 11/6/2017 15:30:18'!
addTo: aCartID isbn: aBookISBN quantity: aBookQuantity 
	| aCart |
	
	aCart := cartsAdministrator obtain: aCartID.
	aCart add: aBookISBN quantity: aBookQuantity.! !

!REST methodsFor: 'operations' stamp: 'a-lavia 11/6/2017 15:30:39'!
checkout: aCartID with: aCreditCard
	| aCart aClient aTransaction |
	
	aCart := cartsAdministrator obtain: aCartID .
	aClient := cartsAdministrator clientOf: aCartID.
	aTransaction := cashier checkout: aCart with: aCreditCard for: aClient.
	
	^aTransaction id.! !

!REST methodsFor: 'operations' stamp: 'a-lavia 11/6/2017 15:30:44'!
contentOf: aCartID 
	| aClientCart |
	
	aClientCart := cartsAdministrator obtain: aCartID .
	^aClientCart contents .! !

!REST methodsFor: 'operations' stamp: 'a-lavia 11/6/2017 15:31:27'!
createCartwith: aClientID and: aPassword
	| aCartID |
	
	self authenticate: aClientID with: aPassword .
	aCartID := cartsAdministrator createCartFor: aClientID .
	^aCartID .! !

!REST methodsFor: 'operations' stamp: 'a-lavia 11/6/2017 14:55:50'!
pucharsesOf: aClientID and: aClientPassword

	self authenticate: aClientID with: aClientPassword .
	^cashier obtainTransactionsRecord: aClientID .! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'REST class' category: #'TusLibros.com'!
REST class
	instanceVariableNames: ''!

!REST class methodsFor: 'messages' stamp: 'a-lavia 11/6/2017 03:41:50'!
userOrPasswordInvalidErrorDescription

	^'user or password invalid'.! !


!REST class methodsFor: 'new' stamp: 'a-lavia 11/6/2017 15:33:36'!
with: aClientsBook and: aCashier and: aCartAdministrator
	^self new initializeWith: aClientsBook and: aCashier and: aCartAdministrator .! !


!classDefinition: #SalesBook category: #'TusLibros.com'!
Object subclass: #SalesBook
	instanceVariableNames: 'transactions'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros.com'!

!SalesBook methodsFor: 'actions' stamp: 'a-lavia 11/6/2017 00:33:27'!
add: aTransaction 

	transactions at: (aTransaction id) put: aTransaction.! !


!SalesBook methodsFor: 'initialization' stamp: 'a-lavia 11/6/2017 00:33:24'!
initialize

	transactions := Dictionary new.! !


!SalesBook methodsFor: 'check' stamp: 'a-lavia 11/6/2017 00:33:21'!
isEmpty

	^transactions isEmpty .! !


!SalesBook methodsFor: 'accessing' stamp: 'a-lavia 11/6/2017 00:32:33'!
nextID

	^transactions size.! !

!SalesBook methodsFor: 'accessing' stamp: 'a-lavia 11/6/2017 00:33:16'!
obtain: aTransactionID

	^transactions at: aTransactionID ! !

!SalesBook methodsFor: 'accessing' stamp: 'a-lavia 11/6/2017 00:33:13'!
size

	^transactions size.! !


!classDefinition: #Transaction category: #'TusLibros.com'!
Object subclass: #Transaction
	instanceVariableNames: 'id cartResume'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros.com'!

!Transaction methodsFor: 'accessing' stamp: 'a-lavia 11/6/2017 00:34:48'!
id

	^id.! !

!Transaction methodsFor: 'accessing' stamp: 'a-lavia 11/6/2017 06:18:06'!
quantityOf: anItem

	^(cartResume at: anItem) at: 2.! !

!Transaction methodsFor: 'accessing' stamp: 'a-lavia 11/6/2017 16:16:05'!
total
	| totalPrice |
	
	totalPrice := 0.
	"esto quedo medio confuso, haria falta hacer una abstraccion, el itemResume se compone de la tupla <precio, cantidad>"
	cartResume valuesDo: [ :itemResume | totalPrice := totalPrice + ((itemResume at: 1) * (itemResume at: 2))].
	^totalPrice.! !


!Transaction methodsFor: 'check' stamp: 'a-lavia 11/6/2017 00:34:51'!
includes: anItem 

	^cartResume includesKey: anItem .! !


!Transaction methodsFor: 'initialization' stamp: 'a-lavia 11/6/2017 00:03:50'!
initializeWith: aID and: aCartResume

	id := aID.
	cartResume := aCartResume! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Transaction class' category: #'TusLibros.com'!
Transaction class
	instanceVariableNames: ''!

!Transaction class methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/6/2017 00:07:54'!
with: aID and: aCartResume

	^self new initializeWith: aID and: aCartResume.! !
