Class {
	#name : #DepReplacementRecommender,
	#superclass : #Object,
	#instVars : [
		'data'
	],
	#category : #'DeprecationRecommender-Controllers'
}

{ #category : #'as yet unclassified' }
DepReplacementRecommender >> candidateReplacementsFor: aMethod [
	| spy blamedCommit addedMethods metric |
	spy := DepCommitBlamer in: data.

	blamedCommit := spy commitThatRemovedMethod: aMethod.
	
	addedMethods := blamedCommit
		ifNotNil: [ blamedCommit addedMethods ]
		ifNil: [ #() ].
	
	metric := AIShinglesSimilarity
		slidingWindowSize: 2
		maxEncodingSize: 10.
	
	^ addedMethods select: [ :addedMethod |
		(metric similarityBetween: addedMethod tokens and: aMethod tokens) >= 0.7 ].
]

{ #category : #accessing }
DepReplacementRecommender >> data [

	^ data
]

{ #category : #accessing }
DepReplacementRecommender >> data: anObject [

	data := anObject
]

{ #category : #'as yet unclassified' }
DepReplacementRecommender >> recommendReplacementsFor: aMethod [
	
	| strategy1 strategy2 refactorings methodCallReplacements |
	
	strategy1 := DepRefactoringDetector new
		data: data;
		yourself.
		
	strategy2 := DepMethodCallMiner new
		data: data;
		yourself.
		
	refactorings := strategy1 detectRefactoringsThatRemoved: aMethod.
	methodCallReplacements := strategy2 mineFrequentMethodCallReplacementsFor: aMethod.
		
	^ DepRecommendation new
		method: aMethod;
		refactorings: refactorings;
		frequentMethodCallReplacements: methodCallReplacements;
		replacements: (refactorings collect: [ :each | each addedMethod ]) asSet asOrderedCollection;
		yourself.
]
