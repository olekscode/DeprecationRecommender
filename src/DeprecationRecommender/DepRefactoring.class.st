Class {
	#name : #DepRefactoring,
	#superclass : #Object,
	#instVars : [
		'removedMethod',
		'addedMethod',
		'similarity',
		'removalCommitId',
		'additionCommitId'
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
DepRefactoring >> additionCommitId [

	^ additionCommitId
]

{ #category : #accessing }
DepRefactoring >> additionCommitId: anObject [

	additionCommitId := anObject
]

{ #category : #converting }
DepRefactoring >> asJsonDictionary [

	^ { 
		'name' -> self name .
		'removedMethod' -> removedMethod asJsonDictionary .
		'addedMethod' -> addedMethod asJsonDictionary .
		'similarity' -> similarity .
		'removalCommitId' -> removalCommitId .
		'additionCommitId' -> additionCommitId
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
DepRefactoring >> removalCommitId [

	^ removalCommitId
]

{ #category : #accessing }
DepRefactoring >> removalCommitId: anObject [

	removalCommitId := anObject
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
