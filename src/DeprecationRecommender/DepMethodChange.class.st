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
DepMethodChange class >> fromJsonDictionary: aDictionary [

	| removedMethodCalls addedMethodCalls |
	
	removedMethodCalls := ((aDictionary at: 'removedMethodCalls') collect: [ :each |
		ClioMethodCall fromJsonDictionary: each ]) asOrderedCollection.
	
	addedMethodCalls := ((aDictionary at: 'addedMethodCalls') collect: [ :each |
		ClioMethodCall fromJsonDictionary: each ]) asOrderedCollection.
	
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
DepMethodChange >> asItemset [

	| addedCalls removedCalls |
	
	addedCalls := self addedMethodCalls collect: [ :each |
		DepMethodCall newAdded: each selector ].
		
	removedCalls := self removedMethodCalls collect: [ :each |
		DepMethodCall newRemoved: each selector ].
		
	^ addedCalls asSet union: removedCalls asSet
]

{ #category : #converting }
DepMethodChange >> asJsonDictionary [

	^ { 
		'signature' -> signature .
		'commitId' -> commitId .
		'removedMethodCalls' -> (removedMethodCalls collect: [ :each | each asJsonDictionary ]) asArray .
		'addedMethodCalls' -> (addedMethodCalls collect: [ :each | each asJsonDictionary ]) asArray .
	} asDictionary
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
