Class {
	#name : #DepRefactoring,
	#superclass : #Object,
	#instVars : [
		'removedMethod',
		'addedMethod',
		'similarity',
		'removalCommit',
		'additionCommit'
	],
	#category : #'DeprecationRecommender-Models'
}

{ #category : #'instance creation' }
DepRefactoring class >> fromJsonDictionary: aDictionary [
	
	| refactoringClass |
	refactoringClass := self allSubclasses detect: [ :each | each new name = (aDictionary at: 'name') ].
	
	"We temporarily store commit ids instead of actual commits"
	^ refactoringClass new
		removedMethod: (ClioMethod fromJsonDictionary: (aDictionary at: 'removedMethod'));
		addedMethod: (ClioMethod fromJsonDictionary: (aDictionary at: 'addedMethod'));
		similarity: (aDictionary at: 'similarity');
		removalCommit: (aDictionary at: 'removalCommitId');
		additionCommit: (aDictionary at: 'additionCommitId');
		yourself.

]

{ #category : #accessing }
DepRefactoring >> addedMethod [

	^ addedMethod
]

{ #category : #accessing }
DepRefactoring >> addedMethod: anObject [

	addedMethod := anObject
]

{ #category : #accessing }
DepRefactoring >> additionCommit [

	^ additionCommit
]

{ #category : #accessing }
DepRefactoring >> additionCommit: anObject [

	additionCommit := anObject
]

{ #category : #converting }
DepRefactoring >> asJsonDictionary [

	^ { 
		'name' -> self name .
		'removedMethod' -> removedMethod asJsonDictionary .
		'addedMethod' -> addedMethod asJsonDictionary .
		'similarity' -> similarity .
		'removalCommitId' -> removalCommit id .
		'additionCommitId' -> additionCommit id
	} asDictionary
]

{ #category : #testing }
DepRefactoring >> canExplainReplacement [

	self subclassResponsibility
]

{ #category : #accessing }
DepRefactoring >> name [

	self subclassResponsibility
]

{ #category : #accessing }
DepRefactoring >> removalCommit [

	^ removalCommit
]

{ #category : #accessing }
DepRefactoring >> removalCommit: anObject [

	removalCommit := anObject
]

{ #category : #accessing }
DepRefactoring >> removedMethod [

	^ removedMethod
]

{ #category : #accessing }
DepRefactoring >> removedMethod: anObject [

	removedMethod := anObject
]

{ #category : #accessing }
DepRefactoring >> similarity [

	^ similarity
]

{ #category : #accessing }
DepRefactoring >> similarity: anObject [

	similarity := anObject
]

{ #category : #testing }
DepRefactoring >> wasClassAdded [
	"Answer true if the same commit that added the method also added the class to which this method belongs"

	^ additionCommit addedClasses
		anySatisfy: [ :aClass | aClass name = addedMethod className ].
]

{ #category : #testing }
DepRefactoring >> wasClassRemoved [
	"Answer true if the same commit that removed the method also removed the class to which this method belongs"

	^ removalCommit removedClasses
		anySatisfy: [ :aClass | aClass name = removedMethod className ].
]

{ #category : #testing }
DepRefactoring >> wasClassRenamed [

	^ self wasClassRemoved and: [
		self wasClassAdded and: [
			self wereAllMethodsOfOldClassMovedToNewClass ] ]
]

{ #category : #testing }
DepRefactoring >> wasMethodMovedToAnotherClass [

	^ addedMethod fullClassName ~= removedMethod fullClassName
		and: [ addedMethod selector = removedMethod selector ].
]

{ #category : #testing }
DepRefactoring >> wereAllMethodsOfOldClassMovedToNewClass [

	| removedSelectors addedSelectors |
	
	removedSelectors := removalCommit removedMethods
		select: [ :each | each className = removedMethod className ]
		thenCollect: [ :each | each name ].
		
	addedSelectors := additionCommit addedMethods
		select: [ :each | each className = addedMethod className ]
		thenCollect: [ :each | each name ].
		
	^ removedSelectors asSet = addedSelectors asSet.
]
