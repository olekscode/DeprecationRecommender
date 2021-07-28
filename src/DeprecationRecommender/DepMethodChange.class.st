Class {
	#name : #DepMethodChange,
	#superclass : #Object,
	#instVars : [
		'oldMethod',
		'newMethod',
		'commit',
		'commitDistance'
	],
	#category : #'DeprecationRecommender-Models'
}

{ #category : #'as yet unclassified' }
DepMethodChange >> addedMethodCalls [
	
	^ newMethod methodCalls asSet difference: (oldMethod methodCalls asSet)
]

{ #category : #converting }
DepMethodChange >> asItemset [

	| addedCalls removedCalls |
	
	addedCalls := self addedMethodCalls collect: [ :each |
		DepMethodCall new
			selector: each selector;
			markAsAdded;
			yourself ].
		
	removedCalls := self addedMethodCalls collect: [ :each |
		DepMethodCall new
			selector: each selector;
			markAsRemoved;
			yourself ].
		
	^ addedCalls asSet union: removedCalls asSet
]

{ #category : #accessing }
DepMethodChange >> commit [

	^ commit
]

{ #category : #accessing }
DepMethodChange >> commit: anObject [

	commit := anObject
]

{ #category : #accessing }
DepMethodChange >> commitDistance [

	^ commitDistance
]

{ #category : #accessing }
DepMethodChange >> commitDistance: anObject [

	commitDistance := anObject
]

{ #category : #accessing }
DepMethodChange >> newMethod [

	^ newMethod
]

{ #category : #accessing }
DepMethodChange >> newMethod: anObject [

	newMethod := anObject
]

{ #category : #accessing }
DepMethodChange >> oldMethod [

	^ oldMethod
]

{ #category : #accessing }
DepMethodChange >> oldMethod: anObject [

	oldMethod := anObject
]

{ #category : #'as yet unclassified' }
DepMethodChange >> removedMethodCalls [
	
	^ oldMethod methodCalls asSet difference: (newMethod methodCalls asSet)
]
