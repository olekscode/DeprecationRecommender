Class {
	#name : #DepReplacementRecommender,
	#superclass : #Object,
	#instVars : [
		'data'
	],
	#category : #'DeprecationRecommender-Controllers'
}

{ #category : #'as yet unclassified' }
DepReplacementRecommender >> addFrequentMethodCallReplacements: methodCallReplacements toMethodReplacements: methodReplacements [

	methodCallReplacements do: [ :each |
		methodReplacements
			select: [ :replacement |
				replacement newMethods first selector = each addedSelectors anyOne ]
			thenDo: [ :replacement | replacement frequentMethodCallReplacement: each ] ].
]

{ #category : #'as yet unclassified' }
DepReplacementRecommender >> allCombinationsOfMethodReplacements: aCollection withSelectors: selectors [
	"Recursively builds all possible combinations of actual methods in the new version of the project that match the itemset of selectors"

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
		
	^ self
		allCombinationsOfMethodReplacements: replacements
		withSelectors: selectors allButFirst.
	
]

{ #category : #'as yet unclassified' }
DepReplacementRecommender >> allCombinationsOfMethodReplacementsWithSelectors: selectors [
	
	^ self allCombinationsOfMethodReplacements: #() withSelectors: selectors
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
DepReplacementRecommender >> suggestReplacementsFor: aMethod basedOn: refactorings and: methodCallReplacements [

	| replacements |
	
	replacements := self
		suggestReplacementsFor: aMethod
		basedOnRefactorings: refactorings.
	
	self
		addFrequentMethodCallReplacements: methodCallReplacements
		toMethodReplacements: replacements.
	
	replacements ifEmpty: [ 
		replacements := self
			suggestReplacementsFor: aMethod
			basedOnMethodCallReplacements: methodCallReplacements ].
			
	^ replacements
]

{ #category : #'as yet unclassified' }
DepReplacementRecommender >> suggestReplacementsFor: aMethod basedOnMethodCallReplacements: methodCallReplacements [

	^ methodCallReplacements flatCollect: [ :each |
		(self allCombinationsOfMethodReplacementsWithSelectors: each addedSelectors)
			collect: [ :methods |
				DepReplacement new
					oldMethod: aMethod;
					newMethods: methods;
					frequentMethodCallReplacement: each;
					yourself ] ]
]

{ #category : #'as yet unclassified' }
DepReplacementRecommender >> suggestReplacementsFor: aMethod basedOnRefactorings: refactorings [

	| replacementDictionary |
	
	replacementDictionary := Dictionary new.
	
	refactorings do: [ :refactoringChain |
		replacementDictionary
			at: refactoringChain addedMethod signature
			ifPresent: [ :replacement | replacement refactorings add: refactoringChain ]
			ifAbsentPut: [
				DepReplacement new
					oldMethod: aMethod;
					newMethods: (OrderedCollection with: refactoringChain addedMethod);
					refactorings: (OrderedCollection with: refactoringChain);
					yourself ] ].
			
	^ replacementDictionary values asOrderedCollection.
]
