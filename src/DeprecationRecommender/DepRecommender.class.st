Class {
	#name : #DepRecommender,
	#superclass : #Object,
	#instVars : [
		'oldVersionSnapshot',
		'newVersionSnapshot',
		'projectHistory'
	],
	#category : #'DeprecationRecommender-Controllers'
}

{ #category : #'as yet unclassified' }
DepRecommender >> candidateReplacementsFor: aMethod [
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
DepRecommender >> classesToDeprecate [
	^ self deletedPublicClasses
]

{ #category : #private }
DepRecommender >> deletedPublicClasses [
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
DepRecommender >> deletedPublicMethods [
	| oldPublicMethods newPublicMethods oldMethodDictionary oldSignatures newSignatures deletedSignatures |
	
	oldPublicMethods := oldVersionSnapshot methods select: [ :each |
		VisibilityDeductor new isMethodPublic: each ].
	
	newPublicMethods := newVersionSnapshot methods select: [ :each |
		VisibilityDeductor new isMethodPublic: each ].
	
	oldMethodDictionary := Dictionary new.
	
	oldPublicMethods do: [ :each |
		oldMethodDictionary at: each signature put: each ].
	
	oldSignatures := oldMethodDictionary keys asSet.
	newSignatures := (newPublicMethods collect: [ :each | each signature ]) asSet.
	
	deletedSignatures := oldSignatures difference: newSignatures.
	
	^ deletedSignatures asOrderedCollection collect: [ :each |
		oldMethodDictionary at: each ]
]

{ #category : #'deprecation - recommendation' }
DepRecommender >> methodsToDeprecate [
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
DepRecommender >> newVersionSnapshot [

	^ newVersionSnapshot
]

{ #category : #accessing }
DepRecommender >> newVersionSnapshot: anObject [

	newVersionSnapshot := anObject
]

{ #category : #accessing }
DepRecommender >> oldVersionSnapshot [

	^ oldVersionSnapshot
]

{ #category : #accessing }
DepRecommender >> oldVersionSnapshot: anObject [

	oldVersionSnapshot := anObject
]

{ #category : #accessing }
DepRecommender >> projectHistory [

	^ projectHistory
]

{ #category : #accessing }
DepRecommender >> projectHistory: anObject [

	projectHistory := anObject
]

{ #category : #'as yet unclassified' }
DepRecommender >> recommendReplacementsFor: aMethod [
	
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
		
	^ DepMethodRecommendation new
		method: aMethod;
		refactorings: refactorings;
		frequentMethodCallReplacements: methodCallReplacements;
		replacements: (refactorings collect: [ :each | each addedMethod ]) asSet;
		yourself.
]
