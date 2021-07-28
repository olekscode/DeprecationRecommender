Class {
	#name : #DepRefactoringDetector,
	#superclass : #Object,
	#instVars : [
		'projectHistory',
		'newVersionSnapshot'
	],
	#category : #'DeprecationRecommender-Controllers'
}

{ #category : #'history search' }
DepRefactoringDetector >> candidateReplacementsFor: aMethod in: aCollectionOfCommits [

	| addedMethods metric threshold |
	
	addedMethods := aCollectionOfCommits flatCollect: [ :commit |
		commit addedMethods ].
	
	metric := AIShinglesSimilarity
		slidingWindowSize: 2
		maxEncodingSize: 10.
		
	threshold := 0.7.
	
	^ addedMethods select: [ :addedMethod |
		(metric similarityBetween: addedMethod tokens and: aMethod tokens) >= threshold ].
]

{ #category : #'history search' }
DepRefactoringDetector >> commitThatRemovedMethod: aMethod [

	| blamer |
	blamer := DepCommitBlamer in: projectHistory.
	^ blamer commitThatRemovedMethod: aMethod.
]

{ #category : #'history search' }
DepRefactoringDetector >> commitsSurrounding: aCommit [

	| commitIndex windowSize |
	commitIndex := projectHistory commits indexOf: aCommit.
	
	windowSize := 10.
	
	^ projectHistory commits
		copyFrom: commitIndex
		to: ((commitIndex + windowSize) min: projectHistory commits size).
]

{ #category : #'as yet unclassified' }
DepRefactoringDetector >> detectRefactoringsThatRemoved: aMethod [

	| blamedCommit surroundingCommits candidateReplacements refactorings refactoringChains |
	
	blamedCommit := self commitThatRemovedMethod: aMethod.
	blamedCommit ifNil: [ ^ OrderedCollection new ].
	
	surroundingCommits := self commitsSurrounding: blamedCommit.
	candidateReplacements := self candidateReplacementsFor: aMethod in: surroundingCommits.
	
	refactorings := candidateReplacements collect: [ :replacement |
		self refactoringsList
			detect: [ :each | each canExplainReplacementOf: aMethod with: replacement ]
			ifFound: [ :aRefactoringClass |
				aRefactoringClass new
					removedMethod: aMethod;
					addedMethod: replacement;
					yourself ]
			ifNone: [ nil ] ].
	
	refactorings := refactorings reject: [ :each | each isNil ].	
	refactoringChains := refactorings collect: [ :each | DepRefactoringChain with: each ].
	
	refactoringChains do: [ :chain |
		(self isInNewVersion: chain addedMethod)
			ifFalse: [ chain addAll: (self detectRefactoringsThatRemoved: chain addedMethod) ] ].
		
	^ refactoringChains select: [ :chain | self isInNewVersion: chain addedMethod ].
]

{ #category : #testing }
DepRefactoringDetector >> isInNewVersion: aMethod [

	^ newVersionSnapshot methods anySatisfy: [ :method |
		method signature = aMethod signature ].
]

{ #category : #accessing }
DepRefactoringDetector >> newVersionSnapshot: anObject [

	newVersionSnapshot := anObject
]

{ #category : #accessing }
DepRefactoringDetector >> projectHistory: anObject [

	projectHistory := anObject
]

{ #category : #accessing }
DepRefactoringDetector >> refactoringsList [

	^ { 
		DepRenameRefactoring .
		DepChangeSignatureRefactoring
	}
]
