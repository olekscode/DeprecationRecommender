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
				similarityBetween: replacement method tokens
				and: aMethod tokens) ].
	
	^ candidateReplacements select: [ :replacement |
		replacement similarity >= threshold ].
]

{ #category : #'as yet unclassified' }
DepRefactoringDetector >> detectRefactoringsThatRemoved: aMethod [

	| blamedCommit surroundingCommits candidateReplacements candidateRefactorings refactorings refactoringChains validChains |
	
	(self canBeAppliedTo: aMethod) ifFalse: [ ^ OrderedCollection new ].
	
	blamedCommit := self commitThatRemovedMethod: aMethod.
	blamedCommit ifNil: [ ^ OrderedCollection new ].
	
	surroundingCommits := self commitsSurrounding: blamedCommit.
	candidateReplacements := self candidateReplacementsFor: aMethod in: surroundingCommits.
	
	refactorings := candidateReplacements collect: [ :replacement |
		candidateRefactorings := self refactoringsList collect: [ :aRefactoringClass |
			aRefactoringClass new
				removedMethod: aMethod;
				addedMethod: replacement method;
				removalCommit: blamedCommit;
				additionCommit: replacement commit;
				similarity: replacement similarity;
				yourself ].
			
		candidateRefactorings
			detect: [ :each | each canExplainReplacement ]
			ifNone: [ nil ] ].
	
	refactorings := refactorings reject: [ :each | each isNil ].	
	refactoringChains := refactorings collect: [ :each | DepRefactoringChain with: each ].
	
	validChains := OrderedCollection new.
	
	refactoringChains do: [ :chain |
		(self isInNewVersion: chain addedMethod)
			ifTrue: [ validChains add: chain ]
			ifFalse: [ 
				(self detectRefactoringsThatRemoved: chain addedMethod) do: [ :chainExtension |
					validChains add: (chain copyWithAll: chainExtension) ] ] ].
		
	^ validChains
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
