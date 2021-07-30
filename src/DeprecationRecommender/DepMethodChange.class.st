Class {
	#name : #DepMethodChange,
	#superclass : #Object,
	#instVars : [
		'signature',
		'commitId',
		'removedMethodCalls',
		'addedMethodCalls'
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
		signature: (aDictionary at: 'signature');
		commitId: (aDictionary at: 'commitId');
		removedMethodCalls: removedMethodCalls;
		addedMethodCalls: addedMethodCalls;
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
		'signature' -> signature .
		'commitId' -> commitId .
		'removedMethodCalls' -> (removedMethodCalls collect: [ :each | each asDictionary ]) asArray .
		'addedMethodCalls' -> (addedMethodCalls collect: [ :each | each asDictionary ]) asArray .
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
DepMethodChange >> commitId [

	^ commitId
]

{ #category : #accessing }
DepMethodChange >> commitId: anObject [

	commitId := anObject
]

{ #category : #'as yet unclassified' }
DepMethodChange >> removedMethodCalls [
	
	^ removedMethodCalls
]

{ #category : #accessing }
DepMethodChange >> removedMethodCalls: anObject [

	removedMethodCalls := anObject
]

{ #category : #accessing }
DepMethodChange >> signature [

	^ signature
]

{ #category : #accessing }
DepMethodChange >> signature: anObject [

	signature := anObject
]
