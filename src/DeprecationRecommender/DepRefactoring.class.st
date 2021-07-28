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