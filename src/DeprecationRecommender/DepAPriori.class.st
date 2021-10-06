Class {
	#name : #DepAPriori,
	#superclass : #APriori,
	#instVars : [
		'removedMethod'
	],
	#category : #'DeprecationRecommender-APriori'
}

{ #category : #'as yet unclassified' }
DepAPriori >> allAssociationRulesFromItemset: anItemset [

	| key value |
	
	key := anItemset select: [ :each | each isRemoved ].
	value := anItemset select: [ :each | each isAdded ].
	
	(key isEmpty or: [ value isEmpty ])
		ifTrue: [ ^ OrderedCollection new ].
		
	(key includes: removedMethod)
		ifFalse: [ ^ OrderedCollection new ].
	
	"We need to get counts of those itemsets"
	key := frequentItemsets detect: [ :itemsetWithCount |
		key = itemsetWithCount ].
	
	value := frequentItemsets detect: [ :itemsetWithCount |
		value = itemsetWithCount ].
	
	^ { (key => value)
		parentItemset: anItemset;
		yourself }
]

{ #category : #accessing }
DepAPriori >> removedMethod [

	^ removedMethod
]

{ #category : #accessing }
DepAPriori >> removedMethod: anObject [

	removedMethod := anObject
]
