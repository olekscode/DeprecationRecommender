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
	
	^ refactoringClass new
		removedMethod: (ClioMethod fromJsonDictionary: (aDictionary at: 'removedMethod'));
		addedMethod: (ClioMethod fromJsonDictionary: (aDictionary at: 'addedMethod'));
		similarity: (aDictionary at: 'similarity');
		removalCommitId: (aDictionary at: 'removalCommitId');
		additionCommitId: (aDictionary at: 'additionCommitId');
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
