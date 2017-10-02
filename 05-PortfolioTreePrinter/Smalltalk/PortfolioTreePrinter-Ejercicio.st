!classDefinition: #PortfolioTest category: #'PortfolioTreePrinter-Ejercicio'!
TestCase subclass: #PortfolioTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PortfolioTreePrinter-Ejercicio'!

!PortfolioTest methodsFor: 'tests' stamp: 'HernanWilkinson 7/13/2011 18:44'!
test01ReceptiveAccountHaveZeroAsBalanceWhenCreated 

	| account |
	account := ReceptiveAccount new.

	self assert: 0 = account balance .
! !

!PortfolioTest methodsFor: 'tests' stamp: 'HernanWilkinson 7/13/2011 18:45'!
test02DepositIncreasesBalanceOnTransactionValue 

	| account |
	account := ReceptiveAccount  new.
	Deposit register: 100 on: account.
		
	self assert: 100 = account balance .
! !

!PortfolioTest methodsFor: 'tests' stamp: 'HernanWilkinson 7/14/2011 05:34'!
test03WithdrawDecreasesBalanceOnTransactionValue 

	| account |
	
	account := ReceptiveAccount new.
	Deposit register: 100 on: account.
	Withdraw register: 50 on: account.
		
	self assert: 50 = account balance .
! !

!PortfolioTest methodsFor: 'tests' stamp: 'HernanWilkinson 7/13/2011 18:48'!
test04PortfolioBalanceIsSumOfManagedAccountsBalance

	| account1 account2 complexPortfolio |
	account1 := ReceptiveAccount new.
	account2 := ReceptiveAccount new.
	complexPortfolio := Portfolio with: account1 with: account2.
	 	
	Deposit register: 100 on: account1.
	Deposit register: 200 on: account2.
		
	self assert:300 = complexPortfolio balance .
! !

!PortfolioTest methodsFor: 'tests' stamp: 'HernanWilkinson 7/13/2011 18:53'!
test05PortfolioCanManagePortfolios

	| account1 account2 account3 complexPortfolio composedPortfolio |
	account1 := ReceptiveAccount new.
	account2 := ReceptiveAccount new.
	account3 := ReceptiveAccount new.
	complexPortfolio := Portfolio with: account1 with: account2.
	composedPortfolio := Portfolio with: complexPortfolio with: account3.
		
	Deposit register: 100 on:account1.
	Deposit register: 200 on: account2.
	Deposit register: 300 on: account3.

	self assert: 600 = composedPortfolio balance .! !

!PortfolioTest methodsFor: 'tests' stamp: 'rok 9/25/2017 20:17:05'!
test06ReceptiveAccountKnowsRegisteredTransactions 

	| account deposit withdraw |
	
	account := ReceptiveAccount new.
	deposit := Deposit register: 100 on: account.
	withdraw := Withdraw register: 50 on: account.
		
	self assert: (account registers: deposit).
	self assert: (account registers: withdraw).
! !

!PortfolioTest methodsFor: 'tests' stamp: 'rok 9/25/2017 20:17:11'!
test07ReceptiveAccountDoNotKnowNotRegisteredTransactions

	| account deposit withdraw |
	
	account := ReceptiveAccount new.
	deposit :=  Deposit for: 100.
	withdraw := Withdraw for: 50.
		
	self deny: (account registers: deposit).
	self deny: (account registers:withdraw).
! !

!PortfolioTest methodsFor: 'tests' stamp: 'HernanWilkinson 9/26/2011 16:51'!
test08PortfolioKnowsTransactionsRegisteredByItsManagedAccounts 

	| account1 account2 account3 complexPortfolio composedPortfolio deposit1 deposit2 deposit3 |
	
	account1 := ReceptiveAccount new.
	account2 := ReceptiveAccount new.
	account3 := ReceptiveAccount new.
	complexPortfolio := Portfolio with: account1 with: account2.
	composedPortfolio := Portfolio with: complexPortfolio with: account3.
		
	deposit1 := Deposit register: 100 on: account1.
	deposit2 := Deposit register: 200 on: account2.
	deposit3 := Deposit register: 300 on: account3.
		
 	self assert: (composedPortfolio registers: deposit1).
	self assert: (composedPortfolio registers: deposit2).
	self assert: (composedPortfolio registers: deposit3).! !

!PortfolioTest methodsFor: 'tests' stamp: 'HernanWilkinson 9/12/2011 13:25'!
test08PortofolioKnowsTransactionsRegisteredByItsManagedAccounts 

	| account1 account2 account3 complexPortfolio composedPortfolio deposit1 deposit2 deposit3 |
	
	account1 := ReceptiveAccount new.
	account2 := ReceptiveAccount new.
	account3 := ReceptiveAccount new.
	complexPortfolio := Portfolio with: account1 with: account2.
	composedPortfolio := Portfolio with: complexPortfolio with: account3.
		
	deposit1 := Deposit register: 100 on: account1.
	deposit2 := Deposit register: 200 on: account2.
	deposit3 := Deposit register: 300 on: account3.
		
 	self assert: (composedPortfolio registers: deposit1).
	self assert: (composedPortfolio registers: deposit2).
	self assert: (composedPortfolio registers: deposit3).! !

!PortfolioTest methodsFor: 'tests' stamp: 'HernanWilkinson 7/13/2011 19:00'!
test10ReceptiveAccountManageItSelf 

	| account1 |
	account1 := ReceptiveAccount new.
		
	self assert: (account1 manages:account1).
! !

!PortfolioTest methodsFor: 'tests' stamp: 'HernanWilkinson 7/13/2011 19:01'!
test11ReceptiveAccountDoNotManageOtherAccount

	| account1 account2 |
	account1 := ReceptiveAccount new.
	account2 := ReceptiveAccount new.
		
	self deny: (account1 manages: account2).
! !

!PortfolioTest methodsFor: 'tests' stamp: 'HernanWilkinson 7/13/2011 19:02'!
test12PortfolioManagesComposedAccounts

	| account1 account2 account3 complexPortfolio |
	account1 := ReceptiveAccount new.
	account2 := ReceptiveAccount new.
	account3 := ReceptiveAccount new.
	complexPortfolio := Portfolio with: account1 with: account2.
		
	self assert: (complexPortfolio manages: account1).
	self assert: (complexPortfolio manages: account2).
	self deny: (complexPortfolio manages: account3).
! !

!PortfolioTest methodsFor: 'tests' stamp: 'HernanWilkinson 7/13/2011 19:03'!
test13PortfolioManagesComposedAccountsAndPortfolios 

	| account1 account2 account3 complexPortfolio composedPortfolio |
	account1 := ReceptiveAccount new.
	account2 := ReceptiveAccount new.
	account3 := ReceptiveAccount new.
	complexPortfolio := Portfolio with: account1 with: account2.
	composedPortfolio := Portfolio with: complexPortfolio with: account3.
		
	self assert: (composedPortfolio manages: account1).
	self assert: (composedPortfolio manages: account2).
	self assert: (composedPortfolio manages: account3).
	self assert: (composedPortfolio manages: complexPortfolio).
! !

!PortfolioTest methodsFor: 'tests' stamp: 'HernanWilkinson 9/26/2011 16:28'!
test14AccountKnowsItsTransactions 

	| account1 deposit1 |
	
	account1 := ReceptiveAccount new.
	
	deposit1 := Deposit register: 100 on:account1.
		
	self assert: 1=account1 transactions size .
	self assert: (account1 transactions includes: deposit1).
! !

!PortfolioTest methodsFor: 'tests' stamp: 'HernanWilkinson 9/18/2011 17:15'!
test15PortfolioTransactionsIsTheUnionOftsAccountsTransactions 

	| account1 account2 account3 complexPortfolio account composedPortfolio deposit1 deposit2 deposit3 |
	
	account1 := ReceptiveAccount new.
	account2 := ReceptiveAccount new.
	account3 := ReceptiveAccount new.
	complexPortfolio := Portfolio with: account1 with: account2.
	composedPortfolio := Portfolio with: complexPortfolio with: account3.
		
	deposit1 := Deposit register: 100 on: account1.
	deposit2 := Deposit register: 200 on: account2.
	deposit3 := Deposit register: 300 on: account3.
		
	self assert: 3 = composedPortfolio transactions size .
	self assert: (composedPortfolio transactions includes: deposit1).
	self assert: (composedPortfolio transactions includes: deposit2).
	self assert: (composedPortfolio transactions includes: deposit3).
! !

!PortfolioTest methodsFor: 'tests' stamp: 'HernanWilkinson 9/12/2011 13:23'!
test16PortfolioKnowsItsAccountsTransactions 

	| account1 account2 account3 complexPortfolio composedPortfolio deposit1 |
	
	account1 := ReceptiveAccount new.
	account2 := ReceptiveAccount new.
	account3 := ReceptiveAccount new.
	complexPortfolio := Portfolio with: account1 with: account2.
	composedPortfolio := Portfolio with: complexPortfolio with: account3.
		
	deposit1 := Deposit register: 100 on: account1.
		
	self assert: 1= (composedPortfolio transactionsOf:account1) size .
	self assert: ((composedPortfolio transactionsOf: account1) includes:deposit1).! !

!PortfolioTest methodsFor: 'tests' stamp: 'HernanWilkinson 9/12/2011 13:23'!
test17PortfolioKnowsItsPortfoliosTransactions 

	| account1 account2 account3 complexPortfolio composedPortfolio deposit1 deposit2 |
	
	account1 := ReceptiveAccount new.
	account2 := ReceptiveAccount new.
	account3 := ReceptiveAccount new.
	complexPortfolio := Portfolio with: account1 with: account2.
	composedPortfolio := Portfolio with: complexPortfolio with: account3.
		
	deposit1 := Deposit register: 100 on: account1.
	deposit2 := Deposit register: 100 on: account2.
	Deposit register: 100 on: account3.
		
	self assert: 2 = (composedPortfolio transactionsOf:complexPortfolio) size .
	self assert: ((composedPortfolio transactionsOf:complexPortfolio) includes:deposit1).
	self assert: ((composedPortfolio transactionsOf:complexPortfolio) includes:deposit2).
! !

!PortfolioTest methodsFor: 'tests' stamp: 'HernanWilkinson 9/12/2011 13:24'!
test18PortfolioCanNotAnswerTransactionsOfNotManagedAccounts 

	| account1 account2 account3 complexPortfolio |
	
	account1 := ReceptiveAccount new.
	account2 := ReceptiveAccount new.
	account3 := ReceptiveAccount new.
	complexPortfolio := Portfolio with: account1 with: account2.
		
	self 
		should: [ complexPortfolio transactionsOf:account3 ] 
		raise: Error 
		withExceptionDo: [ :accountNotManaged |
			self assert: Portfolio accountNotManagedMessageDescription = accountNotManaged messageText ]
! !

!PortfolioTest methodsFor: 'tests' stamp: 'HernanWilkinson 7/13/2011 19:28'!
test19CanNotCreatePortfoliosWithRepeatedAccount 

	| account1 |
	account1 := ReceptiveAccount new.
	self 
		should: [ Portfolio with: account1 with: account1 ]
		raise: Error
		withExceptionDo: [ :invalidPortfolio |
			self assert: Portfolio accountAlreadyManagedErrorMessage  = invalidPortfolio messageText ]! !

!PortfolioTest methodsFor: 'tests' stamp: 'HernanWilkinson 7/13/2011 19:15'!
test20CanNotCreatePortfoliosWithAccountsManagedByOtherManagedPortfolio 

	| account1 account2 complexPortfolio |
	account1 := ReceptiveAccount new.
	account2 := ReceptiveAccount new.
	complexPortfolio := Portfolio with: account1 with: account2.

	self 
		should: [ Portfolio with: complexPortfolio with: account1 ]
		raise: Error
		withExceptionDo: [ :invalidPortfolio |
			self assert: Portfolio accountAlreadyManagedErrorMessage = invalidPortfolio messageText ]! !

!PortfolioTest methodsFor: 'tests' stamp: 'HernanWilkinson 7/14/2011 05:27'!
test21TransferShouldWithdrawFromFromAccountAndDepositIntoToAccount

	| fromAccount toAccount |

	fromAccount := ReceptiveAccount new. 
	toAccount := ReceptiveAccount new.

	Transfer register: 100 from: fromAccount to: toAccount.
		
	self assert: -100 = fromAccount balance.
	self assert:  100 = toAccount balance.! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 8/13/2017 18:37:06'!
test22AccountSummaryShouldProvideHumanReadableTransactionsDetail

	| fromAccount toAccount lines |
	fromAccount := ReceptiveAccount new.
	toAccount := ReceptiveAccount new.

	Deposit register: 100 on: fromAccount.
	Withdraw register: 50 on: fromAccount.
	Transfer register: 100 from: fromAccount to: toAccount.
		
	lines := self accountSummaryLinesOf: fromAccount.
		
	self assert: 3 = lines size.
	self assert: 'Deposito por 100' = (lines at: 1).
	self assert: 'Extraccion por 50' = (lines at: 2).
	self assert: 'Transferencia por -100' = (lines at: 3).! !

!PortfolioTest methodsFor: 'tests' stamp: 'HernanWilkinson 7/14/2011 06:58'!
test23ShouldBeAbleToBeQueryTransferNet

	| fromAccount toAccount |
	fromAccount := ReceptiveAccount new. 
	toAccount := ReceptiveAccount new. 

	Deposit register: 100 on: fromAccount.
	Withdraw register: 50 on: fromAccount.
	Transfer register: 100 from: fromAccount to: toAccount.
	Transfer register: 250 from: toAccount to: fromAccount.
		
	self assert: 150 = (self accountTransferNetOf: fromAccount).
	self assert: -150 = (self accountTransferNetOf: toAccount).! !

!PortfolioTest methodsFor: 'tests' stamp: 'HernanWilkinson 7/14/2011 06:58'!
test24CertificateOfDepositShouldWithdrawInvestmentValue

	| account toAccount |
	account := ReceptiveAccount new. 
	toAccount := ReceptiveAccount new. 

	Deposit register: 1000 on: account.
	Withdraw register: 50 on: account.
	Transfer register: 100 from: account to: toAccount.
	CertificateOfDeposit register: 100 during: 30 at: 1/10 on: account.
		
	self assert: 100 =(self investmentNetOf:account).
	self assert: 750 = account balance.! !

!PortfolioTest methodsFor: 'tests' stamp: 'HernanWilkinson 7/14/2011 06:58'!
test25ShouldBeAbleToQueryInvestmentEarnings

	| account investmentEarnings |
	account := ReceptiveAccount new. 
		
	CertificateOfDeposit register: 100 during: 30 at: 1/10 on: account.
	CertificateOfDeposit register: 100 during: 60 at: 15/100 on: account.

	investmentEarnings := 
		(100*((1/10)/360)*30) +
		(100*((15/100)/360)*60).
		
	self assert: investmentEarnings = (self investmentEarningsOf: account).! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 8/13/2017 18:37:21'!
test26AccountSummaryShouldWorkWithCertificateOfDeposit

	| fromAccount toAccount lines |
	fromAccount := ReceptiveAccount new. 
	toAccount := ReceptiveAccount new. 

	Deposit register: 100 on: fromAccount.
	Withdraw register: 50 on: fromAccount.
	Transfer register: 100 from: fromAccount to: toAccount.
	CertificateOfDeposit register: 1000 during: 30 at: 1/10 on: fromAccount.
		
	lines := self accountSummaryLinesOf: fromAccount.
		
	self assert: 4 = lines size.
	self assert: 'Deposito por 100' =  (lines at: 1).
	self assert: 'Extraccion por 50' =  (lines at: 2).
	self assert: 'Transferencia por -100' = (lines at: 3).
	self assert: 'Plazo fijo por 1000 durante 30 dias a una tna de 10%' = (lines at: 4).! !

!PortfolioTest methodsFor: 'tests' stamp: 'HernanWilkinson 7/14/2011 06:58'!
test27ShouldBeAbleToBeQueryTransferNetWithCertificateOfDeposit

	| fromAccount toAccount |
	fromAccount := ReceptiveAccount new. 
	toAccount := ReceptiveAccount new. 

	Deposit register: 100 on: fromAccount.
	Withdraw register: 50 on: fromAccount.
	Transfer register: 100 from: fromAccount to: toAccount.
	Transfer register: 250 from: toAccount to: fromAccount.
	CertificateOfDeposit register: 1000 during: 30 at: 1/10 on: fromAccount.
		
	self assert: 150 = (self accountTransferNetOf: fromAccount).
	self assert: -150 = (self accountTransferNetOf: toAccount).! !

!PortfolioTest methodsFor: 'tests' stamp: 'HernanWilkinson 9/26/2011 16:29'!
test28PortfolioTreePrinterPrintsTheCompositeInDepthFirstOrder

	| account1 account2 account3 complexPortfolio composedPortfolio accountNames lines |
	
	account1 := ReceptiveAccount new. 
	account2 := ReceptiveAccount new. 
	account3 := ReceptiveAccount new. 
	complexPortfolio := Portfolio with: account1 with: account2.
	composedPortfolio := Portfolio with: complexPortfolio with: account3.

	accountNames := Dictionary new.
	accountNames at: composedPortfolio put: 'composedPortfolio'.
	accountNames at: complexPortfolio put: 'complexPortfolio'.
	accountNames at: account1 put: 'account1'.
	accountNames at: account2 put: 'account2'.
	accountNames at: account3 put: 'account3'.
		
	lines := self portofolioTreeOf: composedPortfolio namingAccountWith: accountNames.
		
	self assert: 5 = lines size.
	self assert: 'composedPortfolio' = (lines at: 1).
	self assert: ' complexPortfolio' = (lines at: 2).
	self assert: '  account1' = (lines at: 3).
	self assert: '  account2' = (lines at: 4).
	self assert: ' account3' = (lines at: 5).! !

!PortfolioTest methodsFor: 'tests' stamp: 'HernanWilkinson 9/26/2011 16:30'!
test29ReversePortfolioTreePrinterPrintsTheCompositeStartingFromTheLeaves

	| account1 account2 account3 complexPortfolio composedPortfolio accountNames lines |
	account1 := ReceptiveAccount new. 
	account2 := ReceptiveAccount new. 
	account3 := ReceptiveAccount new. 
	complexPortfolio := Portfolio with: account1 with: account2.
	composedPortfolio := Portfolio with: complexPortfolio with: account3.

	accountNames := Dictionary new.
	accountNames at: composedPortfolio put: 'composedPortfolio'.
	accountNames at: complexPortfolio put: 'complexPortfolio'.
	accountNames at: account1 put: 'account1'.
	accountNames at: account2 put: 'account2'.
	accountNames at: account3 put: 'account3'.
		
	lines := self reversePortofolioTreeOf: composedPortfolio namingAccountWith: accountNames.
		
	self assert: 5 = lines size.
	self assert: ' account3' = (lines at: 1).
	self assert: '  account2' = (lines at: 2).
	self assert: '  account1' = (lines at: 3).
	self assert: ' complexPortfolio' = (lines at: 4).
	self assert: 'composedPortfolio' = (lines at: 5).
	! !


!PortfolioTest methodsFor: 'test support' stamp: 'a-lavia 9/28/2017 14:19:42'!
accountSummaryLinesOf: aReceptiveAccount 
	^SummaryLinesQuery for: aReceptiveAccount.! !

!PortfolioTest methodsFor: 'test support' stamp: 'a-lavia 9/28/2017 14:48:58'!
accountTransferNetOf: aReceptiveAccount 
	^TransferNetQuery for: aReceptiveAccount.! !

!PortfolioTest methodsFor: 'test support' stamp: 'a-lavia 9/28/2017 14:59:07'!
investmentEarningsOf: aReceptiveAccount 
	^InvestmentEarningQuery for: aReceptiveAccount.! !

!PortfolioTest methodsFor: 'test support' stamp: 'a-lavia 9/28/2017 14:57:11'!
investmentNetOf: aReceptiveAccount
	^InvestmentNetQuery for: aReceptiveAccount.! !

!PortfolioTest methodsFor: 'test support' stamp: 'HernanWilkinson 9/6/2016 19:43'!
portofolioTreeOf: aPortfolio namingAccountWith: aDictionary 
	
	self shouldBeImplemented ! !

!PortfolioTest methodsFor: 'test support' stamp: 'HernanWilkinson 9/6/2016 19:43'!
reversePortofolioTreeOf: aPortfolio namingAccountWith: aDictionary 
	
	self shouldBeImplemented ! !


!classDefinition: #AccountTransaction category: #'PortfolioTreePrinter-Ejercicio'!
Object subclass: #AccountTransaction
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PortfolioTreePrinter-Ejercicio'!

!AccountTransaction methodsFor: 'evaluating' stamp: 'HernanWilkinson 7/14/2011 06:48'!
value

	self subclassResponsibility ! !


!AccountTransaction methodsFor: 'as yet unclassified' stamp: 'rok 9/26/2017 01:54:53'!
imputeBalance: aBalance

	self subclassResponsibility.! !

!AccountTransaction methodsFor: 'as yet unclassified' stamp: 'a-lavia 9/28/2017 14:02:43'!
runQuery: aQuery
	^self subclassResponsibility ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'AccountTransaction class' category: #'PortfolioTreePrinter-Ejercicio'!
AccountTransaction class
	instanceVariableNames: ''!

!AccountTransaction class methodsFor: 'instance creation' stamp: 'rok 9/25/2017 23:31:55'!
register: aValue on: account

	self subclassResponsibility.! !


!classDefinition: #CertificateOfDeposit category: #'PortfolioTreePrinter-Ejercicio'!
AccountTransaction subclass: #CertificateOfDeposit
	instanceVariableNames: 'value tna numberOfDays'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PortfolioTreePrinter-Ejercicio'!

!CertificateOfDeposit methodsFor: 'as yet unclassified' stamp: 'a-lavia 9/28/2017 03:55:14'!
imputeBalance: aBalance

	^aBalance - value! !

!CertificateOfDeposit methodsFor: 'as yet unclassified' stamp: 'rok 9/26/2017 02:22:48'!
initializeFor: anAmmount during: aNumberOfDays at: anEarningAvg

	value := anAmmount.
	numberOfDays := aNumberOfDays.
	tna := anEarningAvg.	! !

!CertificateOfDeposit methodsFor: 'as yet unclassified' stamp: 'a-lavia 9/28/2017 14:14:00'!
numberOfDays
	^numberOfDays! !

!CertificateOfDeposit methodsFor: 'as yet unclassified' stamp: 'a-lavia 9/28/2017 14:24:33'!
runQuery: aQuery
	^aQuery computeCertificateOfDeposit: self.! !

!CertificateOfDeposit methodsFor: 'as yet unclassified' stamp: 'a-lavia 9/28/2017 14:13:47'!
tna
	^tna! !

!CertificateOfDeposit methodsFor: 'as yet unclassified' stamp: 'rok 9/26/2017 02:27:36'!
value

	^value! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CertificateOfDeposit class' category: #'PortfolioTreePrinter-Ejercicio'!
CertificateOfDeposit class
	instanceVariableNames: ''!

!CertificateOfDeposit class methodsFor: 'initialization' stamp: 'rok 9/26/2017 02:25:44'!
register: anAmmount during: aNumberOfDays at: anEarningAvg on: anAccount 
	
	| certificate |
	
	certificate := self for: anAmmount during: aNumberOfDays  at: anEarningAvg.
	
	anAccount register: certificate.! !


!CertificateOfDeposit class methodsFor: 'as yet unclassified' stamp: 'rok 9/26/2017 02:25:32'!
for: anAmmount during: aNumberOfDays at: anEarningAvg

	^self new initializeFor: anAmmount during: aNumberOfDays  at: anEarningAvg! !

!CertificateOfDeposit class methodsFor: 'as yet unclassified' stamp: 'rok 9/26/2017 02:23:37'!
register: anAmmount during: aNumberOfDays at: anEarningAvg

	^self new initializeFor: anAmmount during: aNumberOfDays  at: anEarningAvg! !


!classDefinition: #Deposit category: #'PortfolioTreePrinter-Ejercicio'!
AccountTransaction subclass: #Deposit
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PortfolioTreePrinter-Ejercicio'!

!Deposit methodsFor: 'initialization' stamp: 'HernanWilkinson 7/13/2011 18:45'!
initializeFor: aValue

	value := aValue ! !


!Deposit methodsFor: 'value' stamp: 'a-lavia 9/28/2017 14:24:48'!
runQuery: aQuery
	^aQuery computeDeposit: self.! !

!Deposit methodsFor: 'value' stamp: 'HernanWilkinson 7/13/2011 18:38'!
value

	^ value! !


!Deposit methodsFor: 'as yet unclassified' stamp: 'rok 9/26/2017 01:53:09'!
imputeBalance: aBalance
	
	^aBalance + value ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Deposit class' category: #'PortfolioTreePrinter-Ejercicio'!
Deposit class
	instanceVariableNames: ''!

!Deposit class methodsFor: 'instance creation' stamp: 'HernanWilkinson 7/13/2011 18:38'!
for: aValue

	^ self new initializeFor: aValue ! !

!Deposit class methodsFor: 'instance creation' stamp: 'rok 9/25/2017 23:32:53'!
register: aValue on: account

	| deposit |
	
	deposit := self for: aValue.
	account register: deposit.
		
	^ deposit! !


!classDefinition: #TransferDeposit category: #'PortfolioTreePrinter-Ejercicio'!
AccountTransaction subclass: #TransferDeposit
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PortfolioTreePrinter-Ejercicio'!

!TransferDeposit methodsFor: 'as yet unclassified' stamp: 'a-lavia 9/28/2017 14:10:08'!
imputeBalance: aBalance
	
	^aBalance + value! !

!TransferDeposit methodsFor: 'as yet unclassified' stamp: 'a-lavia 9/28/2017 14:10:18'!
initializeFor: aValue

	value := aValue! !

!TransferDeposit methodsFor: 'as yet unclassified' stamp: 'a-lavia 9/28/2017 14:25:16'!
runQuery: aQuery
	^aQuery computeTransferDeposit: self.! !

!TransferDeposit methodsFor: 'as yet unclassified' stamp: 'a-lavia 9/28/2017 14:11:20'!
value

	^value! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TransferDeposit class' category: #'PortfolioTreePrinter-Ejercicio'!
TransferDeposit class
	instanceVariableNames: ''!

!TransferDeposit class methodsFor: 'as yet unclassified' stamp: 'a-lavia 9/28/2017 14:42:07'!
for: anAmount

	^self new initializeFor: anAmount! !


!classDefinition: #TransferWithdraw category: #'PortfolioTreePrinter-Ejercicio'!
AccountTransaction subclass: #TransferWithdraw
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PortfolioTreePrinter-Ejercicio'!

!TransferWithdraw methodsFor: 'as yet unclassified' stamp: 'a-lavia 9/28/2017 14:09:11'!
imputeBalance: aBalance

	^aBalance - value! !

!TransferWithdraw methodsFor: 'as yet unclassified' stamp: 'a-lavia 9/28/2017 14:09:24'!
initializeFor: aValue

	value := aValue! !

!TransferWithdraw methodsFor: 'as yet unclassified' stamp: 'a-lavia 9/28/2017 14:25:26'!
runQuery: aQuery
	^aQuery computeTransferWithdraw: self.! !

!TransferWithdraw methodsFor: 'as yet unclassified' stamp: 'a-lavia 9/28/2017 14:42:29'!
value
	^value! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TransferWithdraw class' category: #'PortfolioTreePrinter-Ejercicio'!
TransferWithdraw class
	instanceVariableNames: ''!

!TransferWithdraw class methodsFor: 'as yet unclassified' stamp: 'a-lavia 9/28/2017 14:42:13'!
for: anAmount

	^self new initializeFor: anAmount! !


!classDefinition: #Withdraw category: #'PortfolioTreePrinter-Ejercicio'!
AccountTransaction subclass: #Withdraw
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PortfolioTreePrinter-Ejercicio'!

!Withdraw methodsFor: 'initialization' stamp: 'HernanWilkinson 7/13/2011 18:46'!
initializeFor: aValue

	value := aValue ! !


!Withdraw methodsFor: 'value' stamp: 'a-lavia 9/28/2017 14:25:35'!
runQuery: aQuery
	^aQuery computeWithdraw: self.! !

!Withdraw methodsFor: 'value' stamp: 'HernanWilkinson 7/14/2011 05:54'!
value

	^ value ! !


!Withdraw methodsFor: 'as yet unclassified' stamp: 'rok 9/26/2017 01:55:31'!
imputeBalance: aBalance

	^aBalance - value! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Withdraw class' category: #'PortfolioTreePrinter-Ejercicio'!
Withdraw class
	instanceVariableNames: ''!

!Withdraw class methodsFor: 'instance creation' stamp: 'HernanWilkinson 7/13/2011 18:33'!
for: aValue

	^ self new initializeFor: aValue ! !

!Withdraw class methodsFor: 'instance creation' stamp: 'HernanWilkinson 7/14/2011 05:32'!
register: aValue on: account

	| withdraw |
	
	withdraw := self for: aValue.
	account register: withdraw.
		
	^ withdraw! !


!classDefinition: #Query category: #'PortfolioTreePrinter-Ejercicio'!
Object subclass: #Query
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PortfolioTreePrinter-Ejercicio'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Query class' category: #'PortfolioTreePrinter-Ejercicio'!
Query class
	instanceVariableNames: ''!

!Query class methodsFor: 'as yet unclassified' stamp: 'a-lavia 9/28/2017 14:01:36'!
computeCertificateOfDeposit: aCertificateOfDeposit
	^self subclassResponsibility ! !

!Query class methodsFor: 'as yet unclassified' stamp: 'a-lavia 9/28/2017 14:00:33'!
computeDeposit: aDeposit
	^self subclassResponsibility ! !

!Query class methodsFor: 'as yet unclassified' stamp: 'a-lavia 9/28/2017 13:59:47'!
computeTransferDeposit: aTransferDeposit
	^self subclassResponsibility ! !

!Query class methodsFor: 'as yet unclassified' stamp: 'a-lavia 9/28/2017 14:00:13'!
computeTransferWithdraw: aTransferWithdraw
	^self subclassResponsibility ! !

!Query class methodsFor: 'as yet unclassified' stamp: 'a-lavia 9/28/2017 14:00:23'!
computeWithdraw: aWithdraw
	^self subclassResponsibility ! !

!Query class methodsFor: 'as yet unclassified' stamp: 'a-lavia 9/28/2017 14:20:14'!
for: anAccount
	^self subclassResponsibility ! !


!classDefinition: #InvestmentEarningQuery category: #'PortfolioTreePrinter-Ejercicio'!
Query subclass: #InvestmentEarningQuery
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PortfolioTreePrinter-Ejercicio'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'InvestmentEarningQuery class' category: #'PortfolioTreePrinter-Ejercicio'!
InvestmentEarningQuery class
	instanceVariableNames: ''!

!InvestmentEarningQuery class methodsFor: 'as yet unclassified' stamp: 'a-lavia 9/28/2017 14:58:40'!
computeCertificateOfDeposit: aCertificateOfDeposit
	^(100*((aCertificateOfDeposit tna)/360)* (aCertificateOfDeposit numberOfDays))! !

!InvestmentEarningQuery class methodsFor: 'as yet unclassified' stamp: 'a-lavia 9/28/2017 14:57:41'!
computeDeposit: aDeposit
	^0! !

!InvestmentEarningQuery class methodsFor: 'as yet unclassified' stamp: 'a-lavia 9/28/2017 14:57:41'!
computeTransferDeposit: aTransferDeposit
	^0! !

!InvestmentEarningQuery class methodsFor: 'as yet unclassified' stamp: 'a-lavia 9/28/2017 14:57:41'!
computeTransferWithdraw: aTransferWithdraw
	^0! !

!InvestmentEarningQuery class methodsFor: 'as yet unclassified' stamp: 'a-lavia 9/28/2017 14:57:41'!
computeWithdraw: aWithdraw
	^0! !

!InvestmentEarningQuery class methodsFor: 'as yet unclassified' stamp: 'a-lavia 9/28/2017 14:57:41'!
for: anAccount
	^anAccount transactions inject: 0 into: [:aInvestmentNet :aTransaction | aInvestmentNet + (aTransaction runQuery: self)]! !


!classDefinition: #InvestmentNetQuery category: #'PortfolioTreePrinter-Ejercicio'!
Query subclass: #InvestmentNetQuery
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PortfolioTreePrinter-Ejercicio'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'InvestmentNetQuery class' category: #'PortfolioTreePrinter-Ejercicio'!
InvestmentNetQuery class
	instanceVariableNames: ''!

!InvestmentNetQuery class methodsFor: 'as yet unclassified' stamp: 'a-lavia 9/28/2017 14:52:12'!
computeCertificateOfDeposit: aCertificateOfDeposit
	^aCertificateOfDeposit value.! !

!InvestmentNetQuery class methodsFor: 'as yet unclassified' stamp: 'a-lavia 9/28/2017 14:54:47'!
computeDeposit: aDeposit
	^0! !

!InvestmentNetQuery class methodsFor: 'as yet unclassified' stamp: 'a-lavia 9/28/2017 14:55:02'!
computeTransferDeposit: aTransferDeposit
	^0! !

!InvestmentNetQuery class methodsFor: 'as yet unclassified' stamp: 'a-lavia 9/28/2017 14:55:35'!
computeTransferWithdraw: aTransferWithdraw
	^0! !

!InvestmentNetQuery class methodsFor: 'as yet unclassified' stamp: 'a-lavia 9/28/2017 14:55:47'!
computeWithdraw: aWithdraw
	^0! !

!InvestmentNetQuery class methodsFor: 'as yet unclassified' stamp: 'a-lavia 9/28/2017 14:56:37'!
for: anAccount
	^anAccount transactions inject: 0 into: [:aInvestmentNet :aTransaction | aInvestmentNet + (aTransaction runQuery: self)]! !


!classDefinition: #SummaryLinesQuery category: #'PortfolioTreePrinter-Ejercicio'!
Query subclass: #SummaryLinesQuery
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PortfolioTreePrinter-Ejercicio'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SummaryLinesQuery class' category: #'PortfolioTreePrinter-Ejercicio'!
SummaryLinesQuery class
	instanceVariableNames: ''!

!SummaryLinesQuery class methodsFor: 'as yet unclassified' stamp: 'a-lavia 9/28/2017 14:15:00'!
computeCertificateOfDeposit: aCertificateOfDeposit
	^'Plazo fijo por ', (aCertificateOfDeposit value printString),  ' durante ', (aCertificateOfDeposit numberOfDays printString), ' dias a una tna de ', ((100*aCertificateOfDeposit tna) printString), '%'! !

!SummaryLinesQuery class methodsFor: 'as yet unclassified' stamp: 'a-lavia 9/28/2017 14:12:35'!
computeDeposit: aDeposit
	^'Deposito por ', (aDeposit value asString).! !

!SummaryLinesQuery class methodsFor: 'as yet unclassified' stamp: 'a-lavia 9/28/2017 14:37:46'!
computeTransferDeposit: aTransferDeposit
	^'Transferencia por ', ((aTransferDeposit value) asString)! !

!SummaryLinesQuery class methodsFor: 'as yet unclassified' stamp: 'a-lavia 9/28/2017 14:59:38'!
computeTransferWithdraw: aTransferWithdraw
	^'Transferencia por ', (aTransferWithdraw value negated) asString! !

!SummaryLinesQuery class methodsFor: 'as yet unclassified' stamp: 'a-lavia 9/28/2017 14:08:06'!
computeWithdraw: aWithdraw
	^'Extraccion por ' append: (aWithdraw value asString)! !

!SummaryLinesQuery class methodsFor: 'as yet unclassified' stamp: 'a-lavia 9/28/2017 14:21:55'!
for: anAccount
	| summaryLines |

	summaryLines := OrderedCollection  new.
	
	anAccount transactions do: [ :aTransaction | summaryLines add: (aTransaction runQuery: self)].
	
	^summaryLines! !


!classDefinition: #TransferNetQuery category: #'PortfolioTreePrinter-Ejercicio'!
Query subclass: #TransferNetQuery
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PortfolioTreePrinter-Ejercicio'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TransferNetQuery class' category: #'PortfolioTreePrinter-Ejercicio'!
TransferNetQuery class
	instanceVariableNames: ''!

!TransferNetQuery class methodsFor: 'as yet unclassified' stamp: 'a-lavia 9/28/2017 14:45:16'!
computeCertificateOfDeposit: aCertificateOfDeposit
	^0! !

!TransferNetQuery class methodsFor: 'as yet unclassified' stamp: 'a-lavia 9/28/2017 14:45:21'!
computeDeposit: aDeposit
	^0! !

!TransferNetQuery class methodsFor: 'as yet unclassified' stamp: 'a-lavia 9/28/2017 14:45:32'!
computeTransferDeposit: aTransferDeposit
	^aTransferDeposit value! !

!TransferNetQuery class methodsFor: 'as yet unclassified' stamp: 'a-lavia 9/28/2017 14:45:41'!
computeTransferWithdraw: aTransferWithdraw
	^aTransferWithdraw  value negated! !

!TransferNetQuery class methodsFor: 'as yet unclassified' stamp: 'a-lavia 9/28/2017 14:45:46'!
computeWithdraw: aWithdraw
	^0! !

!TransferNetQuery class methodsFor: 'as yet unclassified' stamp: 'a-lavia 9/28/2017 14:48:20'!
for: anAccount
	^anAccount transactions inject: 0 into: [:aTransferNet :aTransaction | aTransferNet + (aTransaction runQuery: self)]! !


!classDefinition: #SummarizingAccount category: #'PortfolioTreePrinter-Ejercicio'!
Object subclass: #SummarizingAccount
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PortfolioTreePrinter-Ejercicio'!

!SummarizingAccount methodsFor: 'testing' stamp: 'HernanWilkinson 7/13/2011 18:34'!
manages: anAccount

	self subclassResponsibility ! !

!SummarizingAccount methodsFor: 'testing' stamp: 'HernanWilkinson 7/13/2011 18:34'!
registers: aTransaction

	self subclassResponsibility ! !


!SummarizingAccount methodsFor: 'transactions' stamp: 'HernanWilkinson 7/13/2011 18:34'!
balance

	self subclassResponsibility ! !

!SummarizingAccount methodsFor: 'transactions' stamp: 'HernanWilkinson 7/13/2011 18:35'!
transactions

	self subclassResponsibility ! !


!classDefinition: #Portfolio category: #'PortfolioTreePrinter-Ejercicio'!
SummarizingAccount subclass: #Portfolio
	instanceVariableNames: 'accounts'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PortfolioTreePrinter-Ejercicio'!

!Portfolio methodsFor: 'testing' stamp: 'HernanWilkinson 7/13/2011 19:22'!
manages: anAccount

	^ self = anAccount  or: [ accounts anySatisfy: [ :managedAccount | managedAccount manages: anAccount  ]  ]! !

!Portfolio methodsFor: 'testing' stamp: 'HernanWilkinson 7/13/2011 19:20'!
registers: aTransaction

	^ accounts anySatisfy: [ :anAccount | anAccount registers: aTransaction ]  ! !


!Portfolio methodsFor: 'transactions' stamp: 'HAW 8/13/2017 17:47:44'!
balance

	^ accounts sum: [ :account | account balance ]
! !

!Portfolio methodsFor: 'transactions' stamp: 'HernanWilkinson 7/13/2011 19:23'!
transactions 

	^ accounts inject: OrderedCollection new into: [ :transactions :account | transactions addAll: account transactions. transactions ]
	! !

!Portfolio methodsFor: 'transactions' stamp: 'HernanWilkinson 7/13/2011 19:27'!
transactionsOf: anAccount 

	^ (self manages: anAccount)
		ifTrue: [ anAccount transactions ] 
		ifFalse: [ self error: self class accountNotManagedMessageDescription]
	! !


!Portfolio methodsFor: 'initialization' stamp: 'HernanWilkinson 7/13/2011 19:19'!
initializeWithAll: aCollectionOfAccounts

	accounts := aCollectionOfAccounts   ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Portfolio class' category: #'PortfolioTreePrinter-Ejercicio'!
Portfolio class
	instanceVariableNames: ''!

!Portfolio class methodsFor: 'instance creation' stamp: 'HernanWilkinson 7/13/2011 18:48'!
with: anAccount1 with: anAccount2

	^ self withAll: (Array with: anAccount1 with: anAccount2 )! !

!Portfolio class methodsFor: 'instance creation' stamp: 'HernanWilkinson 7/13/2011 19:40'!
withAll: aCollectionOfAccounts

	aCollectionOfAccounts asSet size = aCollectionOfAccounts size ifFalse: [ self error: self accountAlreadyManagedErrorMessage  ].
	
	aCollectionOfAccounts do: [ :sourceAccount | 
		aCollectionOfAccounts do: [ :targetAccount | 
			(sourceAccount = targetAccount) not ifTrue: [
				(sourceAccount manages: targetAccount) ifTrue: [ self error: self accountAlreadyManagedErrorMessage ]]]].
	
	^self new initializeWithAll: aCollectionOfAccounts ! !


!Portfolio class methodsFor: 'assertions' stamp: 'HernanWilkinson 9/18/2011 17:22'!
check: sourceAccount doesNotManagaAnyOf: aCollectionOfAccounts

	^ aCollectionOfAccounts do: [ :targetAccount | 
			(sourceAccount = targetAccount) not ifTrue: [ 
				(sourceAccount manages: targetAccount) ifTrue: [ self error: self accountAlreadyManagedErrorMessage ] ] ]! !

!Portfolio class methodsFor: 'assertions' stamp: 'HernanWilkinson 9/18/2011 17:21'!
checkAccountsAreUnique: aCollectionOfAccounts

	aCollectionOfAccounts asSet size = aCollectionOfAccounts size
		ifFalse: [ self error: self accountAlreadyManagedErrorMessage ]! !

!Portfolio class methodsFor: 'assertions' stamp: 'HernanWilkinson 9/18/2011 17:21'!
checkCreationPreconditions: aCollectionOfAccounts

	self checkAccountsAreUnique: aCollectionOfAccounts.
	self checkNoCircularReferencesIn: aCollectionOfAccounts! !

!Portfolio class methodsFor: 'assertions' stamp: 'HernanWilkinson 9/18/2011 17:22'!
checkNoCircularReferencesIn: aCollectionOfAccounts

	aCollectionOfAccounts do: [ :sourceAccount | self check: sourceAccount doesNotManagaAnyOf: aCollectionOfAccounts ]! !


!Portfolio class methodsFor: 'error messages' stamp: 'HernanWilkinson 7/13/2011 19:28'!
accountAlreadyManagedErrorMessage

	^ 'Account already managed'! !

!Portfolio class methodsFor: 'error messages' stamp: 'HernanWilkinson 7/13/2011 19:27'!
accountNotManagedMessageDescription
	
	^ 'Account not managed'! !


!classDefinition: #ReceptiveAccount category: #'PortfolioTreePrinter-Ejercicio'!
SummarizingAccount subclass: #ReceptiveAccount
	instanceVariableNames: 'transactions'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PortfolioTreePrinter-Ejercicio'!

!ReceptiveAccount methodsFor: 'initialization' stamp: 'HernanWilkinson 7/13/2011 18:35'!
initialize

	super initialize.
	transactions := OrderedCollection new.! !


!ReceptiveAccount methodsFor: 'transactions' stamp: 'rok 9/26/2017 01:54:41'!
balance

	^ transactions inject: 0 into: [ :balance :transaction | transaction imputeBalance: balance].! !

!ReceptiveAccount methodsFor: 'transactions' stamp: 'HernanWilkinson 7/13/2011 18:37'!
register: aTransaction

	transactions add: aTransaction 
! !

!ReceptiveAccount methodsFor: 'transactions' stamp: 'HernanWilkinson 7/13/2011 18:37'!
transactions 

	^ transactions copy! !


!ReceptiveAccount methodsFor: 'testing' stamp: 'HernanWilkinson 7/13/2011 18:37'!
manages: anAccount

	^ self = anAccount 
! !

!ReceptiveAccount methodsFor: 'testing' stamp: 'HernanWilkinson 7/13/2011 18:37'!
registers: aTtransaction

	^ transactions includes: aTtransaction 
! !



!classDefinition: #Transfer category: #'PortfolioTreePrinter-Ejercicio'!
Object subclass: #Transfer
	instanceVariableNames: 'value legTransferWithdraw legTransferDeposit'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PortfolioTreePrinter-Ejercicio'!

!Transfer methodsFor: 'as yet unclassified' stamp: 'rok 9/26/2017 00:59:48'!
initializeFor: aValue

	value := aValue ! !

!Transfer methodsFor: 'as yet unclassified' stamp: 'rok 9/26/2017 00:56:55'!
registerTransferWithdraw: aTransferWithdraw andTransferDeposit: aTransferDeposit

	legTransferWithdraw := aTransferWithdraw.
	legTransferDeposit := aTransferDeposit.! !

!Transfer methodsFor: 'as yet unclassified' stamp: 'rok 9/26/2017 00:07:00'!
value 

	^value! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Transfer class' category: #'PortfolioTreePrinter-Ejercicio'!
Transfer class
	instanceVariableNames: ''!

!Transfer class methodsFor: 'transactions' stamp: 'a-lavia 9/28/2017 14:41:34'!
register: anAmount from: sourceAccount to: destinyAccount 

	| transfer transferFrom transferTo |

	transfer := Transfer for: anAmount.
	transferFrom := TransferWithdraw for: anAmount.
	transferTo := TransferDeposit  for: anAmount.

	transfer registerTransferWithdraw: transferFrom andTransferDeposit: transferTo.
	
	sourceAccount register: transferFrom.
	destinyAccount register: transferTo.
	! !


!Transfer class methodsFor: 'as yet unclassified' stamp: 'rok 9/26/2017 01:00:02'!
for: aValue

	^self new initializeFor: aValue ! !
