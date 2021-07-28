Class {
	#name : #DepAPrioriCandidateGenerator,
	#superclass : #APrioriCandidateGenerator,
	#instVars : [
		'removedMethod'
	],
	#category : #'DeprecationRecommender-APriori'
}

{ #category : #'as yet unclassified' }
DepAPrioriCandidateGenerator >> pruneItemsets: itemsets basedOn: previousFrequentItemsets [

	| prunedItemsets |
	prunedItemsets := super pruneItemsets: itemsets basedOn: previousFrequentItemsets.
	
	^ prunedItemsets select: [ :itemset |
		itemset anySatisfy: [ :methodCall |
			methodCall isRemoved and: [ methodCall selector = removedMethod selector ] ] ]
]

{ #category : #accessing }
DepAPrioriCandidateGenerator >> removedMethod [

	^ removedMethod
]

{ #category : #accessing }
DepAPrioriCandidateGenerator >> removedMethod: anObject [

	removedMethod := anObject
]
