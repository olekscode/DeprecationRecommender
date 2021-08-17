Class {
	#name : #DepReplacementRecommender,
	#superclass : #Object,
	#instVars : [
		'oldVersionSnapshot',
		'newVersionSnapshot',
		'projectHistory'
	],
	#category : #'DeprecationRecommender-Controllers'
}

{ #category : #'as yet unclassified' }
DepReplacementRecommender >> candidateReplacementsFor: aMethod [
	| spy blamedCommit addedMethods metric |
	spy := DepCommitBlamer in: projectHistory.

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
DepReplacementRecommender >> newVersionSnapshot [

	^ newVersionSnapshot
]

{ #category : #accessing }
DepReplacementRecommender >> newVersionSnapshot: anObject [

	newVersionSnapshot := anObject
]

{ #category : #accessing }
DepReplacementRecommender >> oldVersionSnapshot [

	^ oldVersionSnapshot
]

{ #category : #accessing }
DepReplacementRecommender >> oldVersionSnapshot: anObject [

	oldVersionSnapshot := anObject
]

{ #category : #accessing }
DepReplacementRecommender >> projectHistory [

	^ projectHistory
]

{ #category : #accessing }
DepReplacementRecommender >> projectHistory: anObject [

	projectHistory := anObject
]

{ #category : #'as yet unclassified' }
DepReplacementRecommender >> recommendReplacementsFor: aMethod [
	
	| strategy1 strategy2 refactorings methodCallReplacements |
	
	strategy1 := DepRefactoringDetector new
		projectHistory: projectHistory;
		oldVersionSnapshot: oldVersionSnapshot;
		newVersionSnapshot: newVersionSnapshot;
		yourself.
		
	strategy2 := DepMethodCallMiner new
		projectHistory: projectHistory;
		oldVersionSnapshot: oldVersionSnapshot;
		newVersionSnapshot: newVersionSnapshot;
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
