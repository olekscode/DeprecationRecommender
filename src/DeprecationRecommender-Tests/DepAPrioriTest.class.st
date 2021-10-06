Class {
	#name : #DepAPrioriTest,
	#superclass : #TestCase,
	#instVars : [
		'fixture',
		'apriori'
	],
	#category : #'DeprecationRecommender-Tests'
}

{ #category : #initialization }
DepAPrioriTest >> setUp [ 

	| transactionsSource |
	super setUp.
	
	fixture := DepAPrioriFixture new.

	transactionsSource := APrioriTransactionsArray from: fixture transactions.
	apriori := DepAPriori forTransactions: transactionsSource.
]

{ #category : #tests }
DepAPrioriTest >> testAssociationRules [

	apriori removedMethod: (DepMethodCall newRemoved: #saveAndSubmit).
	apriori minCount: 2.

	apriori findFrequentItemsets.
	apriori buildAssociationRules.
	
	self
		assert: apriori associationRules asSet
		equals: fixture expectedRules asSet.
]
