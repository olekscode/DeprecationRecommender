Class {
	#name : #DepRefactoringDetector,
	#superclass : #DepRecommendationStrategy,
	#category : #'DeprecationRecommender-Controllers'
}

{ #category : #testing }
DepRefactoringDetector >> canBeAppliedTo: aMethod [

	^ ({
		#('^' 'true' '.') asOrderedCollection .
		#('^' 'false' '.') asOrderedCollection .
		#('^' 'nil' '.') asOrderedCollection .
	} includes: aMethod tokens) not.
]

{ #category : #'history search' }
DepRefactoringDetector >> candidateReplacementsFor: aMethod in: aCollectionOfCommits [

	| candidateReplacements metric threshold |
	
	candidateReplacements := aCollectionOfCommits flatCollect: [ :commit |
		commit addedMethods collect: [ :each |
			DepCandidateReplacement new
				method: each;
				commit: commit;
				yourself ] ].
	
	metric := AIShinglesSimilarity
		slidingWindowSize: 2
		maxEncodingSize: 10.
		
	threshold := 0.7.
	
	candidateReplacements do: [ :replacement |
		replacement similarity: (
			metric
				distanceBetween: replacement method tokens
				and: aMethod tokens) ].
	
	^ candidateReplacements select: [ :replacement |
		replacement similarity >= threshold ].
]

{ #category : #'as yet unclassified' }
DepRefactoringDetector >> detectRefactoringChainsThatCouldHaveRemoved: aMethod [

	^ self
		detectRefactoringChainsThatCouldHaveRemoved: aMethod
		after: (data commits first datetime - 1 day).
]

{ #category : #'as yet unclassified' }
DepRefactoringDetector >> detectRefactoringChainsThatCouldHaveRemoved: aMethod after: aDateAndTime [

	| refactorings refactoringChains validChains |
	
	(self canBeAppliedTo: aMethod) ifFalse: [ ^ OrderedCollection new ].
	
	refactorings := self detectRefactoringsThatCouldHaveRemoved: aMethod after: aDateAndTime.	
	refactoringChains := refactorings collect: [ :each | DepRefactoringChain with: each ].
	
	validChains := OrderedCollection new.
	
	refactoringChains do: [ :chain |
		(self isInNewVersion: chain addedMethod)
			ifTrue: [ validChains add: chain ]
			ifFalse: [ 
				(self detectRefactoringChainsThatCouldHaveRemoved: chain addedMethod after: chain last additionCommit datetime) do: [ :chainExtension |
					validChains add: (chain copyWithAll: chainExtension) ] ] ].
		
	^ validChains
]

{ #category : #'as yet unclassified' }
DepRefactoringDetector >> detectRefactoringsThatCouldHaveRemoved: aMethod after: aDateAndTime [

	| blamedCommit |
	
	blamedCommit := self commitThatRemovedMethod: aMethod.
	
	(blamedCommit isNil or: [ blamedCommit datetime <= aDateAndTime ])
		ifTrue: [ ^ OrderedCollection new ].
	
	^ self detectRefactoringsThatCouldHaveRemoved: aMethod inCommit: blamedCommit.
]

{ #category : #'as yet unclassified' }
DepRefactoringDetector >> detectRefactoringsThatCouldHaveRemoved: aMethod inCommit: aCommit [

	| surroundingCommits candidateReplacements candidateRefactorings refactorings |
	
	surroundingCommits := self commitsSurrounding: aCommit.
	candidateReplacements := self candidateReplacementsFor: aMethod in: surroundingCommits.
	
	refactorings := candidateReplacements collect: [ :replacement |
		candidateRefactorings := self refactoringsList collect: [ :aRefactoringClass |
			aRefactoringClass new
				removedMethod: aMethod;
				addedMethod: replacement method;
				removalCommit: aCommit;
				additionCommit: replacement commit;
				similarity: replacement similarity;
				yourself ].
			
		candidateRefactorings
			detect: [ :each | each canExplainReplacement ]
			ifNone: [ nil ] ].
	
	^ refactorings reject: [ :each | each isNil ].	
]

{ #category : #accessing }
DepRefactoringDetector >> refactoringsList [

	^ { 
		DepRenameMethodRefactoring .
		DepRenameClassRefactoring .
		DepChangeSignatureRefactoring .
		DepMoveRefactoring .
		DepMoveRenameRefactoring .
		DepMoveChangeSignatureRefactoring 
	}
]
