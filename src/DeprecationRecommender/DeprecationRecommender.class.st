Class {
	#name : #DeprecationRecommender,
	#superclass : #Object,
	#instVars : [
		'oldVersionSnapshot',
		'newVersionSnapshot',
		'projectHistory'
	],
	#category : #DeprecationRecommender
}

{ #category : #'as yet unclassified' }
DeprecationRecommender >> candidateReplacementsFor: aMethod [
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

{ #category : #'deprecation - recommendation' }
DeprecationRecommender >> classesToDeprecate [
	^ self deletedPublicClasses
]

{ #category : #private }
DeprecationRecommender >> deletedPublicClasses [
	| oldPublicClasses newPublicClasses oldClassDictionary oldNames newNames deletedNames |
	
	oldPublicClasses := oldVersionSnapshot classes select: [ :each |
		VisibilityDeductor new isClassPublic: each ].
	
	newPublicClasses := newVersionSnapshot classes select: [ :each |
		VisibilityDeductor new isClassPublic: each ].
	
	oldClassDictionary := Dictionary new.
	
	oldPublicClasses do: [ :each |
		oldClassDictionary at: each name ifAbsentPut: each ].
	
	oldNames := oldClassDictionary keys asSet.
	newNames := (newPublicClasses collect: [ :each | each name ]) asSet.
	
	deletedNames := oldNames difference: newNames.
	
	^ deletedNames asOrderedCollection collect: [ :each |
		oldClassDictionary at: each ]
]

{ #category : #private }
DeprecationRecommender >> deletedPublicMethods [
	| oldPublicMethods newPublicMethods oldMethodDictionary oldSignatures newSignatures deletedSignatures |
	
	oldPublicMethods := oldVersionSnapshot methods select: [ :each |
		VisibilityDeductor new isMethodPublic: each ].
	
	newPublicMethods := newVersionSnapshot methods select: [ :each |
		VisibilityDeductor new isMethodPublic: each ].
	
	oldMethodDictionary := (oldPublicMethods collect: [ :each |
		each signature -> each ]) asDictionary.
	
	oldSignatures := oldMethodDictionary keys asSet.
	newSignatures := (newPublicMethods collect: [ :each | each signature ]) asSet.
	
	deletedSignatures := oldSignatures difference: newSignatures.
	
	^ deletedSignatures asOrderedCollection collect: [ :each |
		oldMethodDictionary at: each ]
]

{ #category : #'deprecation - recommendation' }
DeprecationRecommender >> methodsToDeprecate [
	| methods deletedClassNames |
	
	methods := self deletedPublicMethods.
	deletedClassNames := self classesToDeprecate collect: [ :aClass | aClass name ].
	
	^ methods reject: [ :method |
		method isEmpty or: [
			method isAbstract or: [
				method selector = 'initialize' or: [
					deletedClassNames includes: method methodClass name ] ] ] ].
]

{ #category : #accessing }
DeprecationRecommender >> newVersionSnapshot [

	^ newVersionSnapshot
]

{ #category : #accessing }
DeprecationRecommender >> newVersionSnapshot: anObject [

	newVersionSnapshot := anObject
]

{ #category : #accessing }
DeprecationRecommender >> oldVersionSnapshot [

	^ oldVersionSnapshot
]

{ #category : #accessing }
DeprecationRecommender >> oldVersionSnapshot: anObject [

	oldVersionSnapshot := anObject
]

{ #category : #accessing }
DeprecationRecommender >> projectHistory [

	^ projectHistory
]

{ #category : #accessing }
DeprecationRecommender >> projectHistory: anObject [

	projectHistory := anObject
]

{ #category : #'as yet unclassified' }
DeprecationRecommender >> recommendReplacementsFor: aMethod [
	| candidateReplacements recommendation |
	
	({
		#('^' 'true' '.') asOrderedCollection .
		#('^' 'false' '.') asOrderedCollection .
		#('^' 'nil' '.') asOrderedCollection .
	} includes: aMethod tokens)
		ifTrue: [ ^ OrderedCollection new ].
	
	candidateReplacements := self candidateReplacementsFor: aMethod.
	
	^ candidateReplacements collect: [ :replacementMethod |
		recommendation := ReplacementRecommendation new
			method: aMethod;
			yourself.
		
		recommendation replacements add: replacementMethod.
		recommendation ]
]

{ #category : #'as yet unclassified' }
DeprecationRecommender >> transactionsFor: aMethod [
	| spy blamedCommit blamedCommitIndex windowSize closestCommits |
	spy := DepCommitBlamer in: projectHistory.

	blamedCommit := spy commitThatRemovedMethod: aMethod.
	blamedCommitIndex := projectHistory commits indexOf: blamedCommit.
	
	windowSize := 10.
	
	closestCommits := projectHistory commits
		copyFrom: ((blamedCommitIndex - windowSize) max: 1)
		to: ((blamedCommitIndex + windowSize) min: projectHistory commits size).
	
	^ (closestCommits flatCollect: [ :commit |
		commit modifiedMethods select: [ :modification |
			(modification oldDefinition methodCalls
				anySatisfy: [ :call | call selector = aMethod selector ]) and: [ 
					modification newDefinition methodCalls
						noneSatisfy: [ :call | call selector = aMethod selector ] ] ] ])

]
