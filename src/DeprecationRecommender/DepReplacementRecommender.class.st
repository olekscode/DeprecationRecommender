Class {
	#name : #DepReplacementRecommender,
	#superclass : #Object,
	#instVars : [
		'data'
	],
	#category : #'DeprecationRecommender-Controllers'
}

{ #category : #'as yet unclassified' }
DepReplacementRecommender >> allCombinationsOfReplacements: aCollection withSelectors: selectors [

	| methodsWithFirstSelector replacements |
	selectors ifEmpty: [ ^ aCollection ].
	
	methodsWithFirstSelector := data newImplementedMethods select: [ :method |
		method selector = selectors first ].
	
	replacements := aCollection
		ifEmpty: [ methodsWithFirstSelector collect: [ :each | OrderedCollection with: each ] ]
		ifNotEmpty: [ 
			aCollection flatCollect: [ :replacement |
				methodsWithFirstSelector collect: [ :method |
					replacement copyWith: method ] ] ].
		
	^ self allCombinationsOfReplacements: replacements withSelectors: selectors allButFirst.
	
]

{ #category : #'history search' }
DepReplacementRecommender >> commitThatRemovedMethod: aMethod [

	| blamer |
	blamer := DepCommitBlamer in: data.
	^ blamer commitThatRemovedMethod: aMethod.
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
DepReplacementRecommender >> detectRefactoringsThatRemoved: aMethod [

	| strategy |
		
	strategy := DepRefactoringDetector new
		data: data;
		yourself.
		
	^ strategy detectRefactoringsThatRemoved: aMethod.
]

{ #category : #'as yet unclassified' }
DepReplacementRecommender >> mineFrequentMethodCallReplacementsFor: aMethod [

	| strategy |
		
	strategy := DepMethodCallMiner new
		data: data;
		yourself.
		
	^ strategy mineFrequentMethodCallReplacementsFor: aMethod.
]

{ #category : #'as yet unclassified' }
DepReplacementRecommender >> recommendReplacementsFor: aMethod [
	
	| blamedCommit refactorings methodCallReplacements replacements |
	
	blamedCommit := self commitThatRemovedMethod: aMethod.
	
	refactorings := self detectRefactoringsThatRemoved: aMethod.
	methodCallReplacements := self mineFrequentMethodCallReplacementsFor: aMethod.
		
	replacements := self
		suggestReplacementsFor: aMethod
		basedOn: refactorings
		and: methodCallReplacements.
		
	^ DepRecommendation new
		method: aMethod;
		blamedCommit: blamedCommit;
		replacements: replacements;
		yourself.
]

{ #category : #'as yet unclassified' }
DepReplacementRecommender >> suggestReplacementsFor: aMethod basedOn: aCollectionOfRefactorings and: aCollectionOfMethodCallReplacements [

	| replacementDictionary replacements |
	
	replacementDictionary := Dictionary new.
	
	aCollectionOfRefactorings do: [ :refactoringChain |
		replacementDictionary
			at: refactoringChain addedMethod signature
			ifPresent: [ :replacement | replacement refactorings add: refactoringChain ]
			ifAbsentPut: [
				DepReplacement new
					oldMethod: aMethod;
					newMethods: (OrderedCollection with: refactoringChain addedMethod);
					refactorings: (OrderedCollection with: refactoringChain);
					yourself ] ].
			
	replacements := replacementDictionary values asOrderedCollection.
	
	aCollectionOfMethodCallReplacements
		select: [ :each | each removedSelectors size = 1
			and: [ each removedSelectors anyOne = aMethod selector ] ]
		thenDo: [ :each |
			replacements
				select: [ :replacement |
					replacement newMethods first selector = each addedSelectors anyOne ]
				thenDo: [ :replacement | replacement frequentMethodCallReplacement: each ] ].
			
	replacements ifEmpty: [ 
		replacements := aCollectionOfMethodCallReplacements flatCollect: [ :each |
			(self allCombinationsOfReplacements: #() withSelectors: each addedSelectors)
				collect: [ :methods |
					DepReplacement new
						oldMethod: aMethod;
						newMethods: methods;
						frequentMethodCallReplacement: each;
						yourself ] ] ].
			
	^ replacements
]
