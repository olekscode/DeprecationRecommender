Class {
	#name : #DepRefactoring,
	#superclass : #Object,
	#instVars : [
		'removedMethod',
		'addedMethod',
		'similarity',
		'removalCommit',
		'additionCommit',
		'commitDistance'
	],
	#category : #'DeprecationRecommender-Models'
}

{ #category : #testing }
DepRefactoring class >> canExplainReplacementOf: aMethod with: aReplacementMethod [

	self subclassResponsibility
]

{ #category : #'instance creation' }
DepRefactoring class >> fromDictionary: aDictionary [
	
	| refactoringClass |
	refactoringClass := self allSubclasses detect: [ :each | each new name = (aDictionary at: 'name') ].
	
	^ refactoringClass new
		removedMethod: (ClioMethod fromDictionary: (aDictionary at: 'removedMethod'));
		addedMethod: (ClioMethod fromDictionary: (aDictionary at: 'addedMethod'));
		similarity: (aDictionary at: 'similarity');
		removalCommit: (ClioCommit fromDictionary: (aDictionary at: 'removalCommit'));
		additionCommit: (ClioCommit fromDictionary: (aDictionary at: 'additionCommit'));
		commitDistance: (aDictionary at: 'commitDistance');
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
DepRefactoring >> asDictionary [

	^ { 
		'name' -> self name .
		'removedMethod' -> removedMethod asDictionary .
		'addedMethod' -> addedMethod asDictionary .
		'similarity' -> similarity .
		'removalCommit' -> removalCommit asDictionary .
		'additionCommit' -> additionCommit asDictionary .
		'commitDistance' -> commitDistance
	} asDictionary
]

{ #category : #accessing }
DepRefactoring >> commitDistance [

	^ commitDistance
]

{ #category : #accessing }
DepRefactoring >> commitDistance: anObject [

	commitDistance := anObject
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
