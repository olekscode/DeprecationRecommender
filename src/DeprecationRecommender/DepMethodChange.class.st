Class {
	#name : #DepMethodChange,
	#superclass : #Object,
	#instVars : [
		'oldMethod',
		'newMethod',
		'removedMethodCalls',
		'addedMethodCalls',
		'commit',
		'commitDistance'
	],
	#category : #'DeprecationRecommender-Models'
}

{ #category : #'instance creation' }
DepMethodChange class >> fromDictionary: aDictionary [

	| removedMethodCalls addedMethodCalls |
	
	removedMethodCalls := ((aDictionary at: 'removedMethodCalls') collect: [ :each |
		ClioMethodCall fromDictionary: each ]) asOrderedCollection.
	
	addedMethodCalls := ((aDictionary at: 'addedMethodCalls') collect: [ :each |
		ClioMethodCall fromDictionary: each ]) asOrderedCollection.
	
	^ self new 
		oldMethod: (ClioMethod fromDictionary: (aDictionary at: 'oldMethod'));
		newMethod: (ClioMethod fromDictionary: (aDictionary at: 'newMethod'));
		removedMethodCalls: removedMethodCalls;
		addedMethodCalls: addedMethodCalls;
		commit: (ClioCommit fromDictionary: (aDictionary at: 'commit'));
		commitDistance: (aDictionary at: 'commitDistance');
		yourself.
]

{ #category : #'as yet unclassified' }
DepMethodChange >> addedMethodCalls [
	
	^ addedMethodCalls
]

{ #category : #accessing }
DepMethodChange >> addedMethodCalls: anObject [

	addedMethodCalls := anObject
]

{ #category : #converting }
DepMethodChange >> asDictionary [

	^ { 
		'oldMethod' -> oldMethod asDictionary .
		'newMethod' -> newMethod asDictionary .
		'removedMethodCalls' -> (removedMethodCalls collect: [ :each | each asDictionary ]) asArray .
		'addedMethodCalls' -> (addedMethodCalls collect: [ :each | each asDictionary ]) asArray .
		'commit' -> commit asDictionary .
		'commitDistance' -> commitDistance
	} asDictionary
]

{ #category : #converting }
DepMethodChange >> asItemset [

	| addedCalls removedCalls |
	
	addedCalls := self addedMethodCalls collect: [ :each |
		DepMethodCall new
			selector: each selector;
			markAsAdded;
			yourself ].
		
	removedCalls := self removedMethodCalls collect: [ :each |
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
	
	^ removedMethodCalls
]

{ #category : #accessing }
DepMethodChange >> removedMethodCalls: anObject [

	removedMethodCalls := anObject
]
