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
	
	| strategy1 strategy2 refactorings methodCallReplacements replacements |
	
	strategy1 := DepRefactoringDetector new
		data: data;
		yourself.
		
	strategy2 := DepMethodCallMiner new
		data: data;
		yourself.
		
	refactorings := strategy1 detectRefactoringsThatRemoved: aMethod.
	methodCallReplacements := strategy2 mineFrequentMethodCallReplacementsFor: aMethod.
	
	replacements := Dictionary new.
	
	refactorings do: [ :refactoringChain |
		replacements
			at: refactoringChain addedMethod signature
			ifPresent: [ :replacement | replacement refactorings add: refactoringChain ]
			ifAbsentPut: [
				DepReplacement new
					oldMethod: aMethod;
					newMethods: (OrderedCollection with: refactoringChain addedMethod);
					refactorings: (OrderedCollection with: refactoringChain);
					yourself ] ].
			
	replacements := replacements values.
	
	methodCallReplacements
		select: [ :each | each removedSelectors size = 1
			and: [ each removedSelectors anyOne = aMethod selector ] ]
		thenDo: [ :each |
			replacements
				select: [ :replacement |
					replacement newMethods first selector = each addedSelectors anyOne ]
				thenDo: [ :replacement | replacement frequentMethodCallReplacement: each ] ].
		
	^ DepRecommendation new
		method: aMethod;
		refactorings: refactorings;
		frequentMethodCallReplacements: methodCallReplacements;
		replacements: replacements;
		yourself.
]
