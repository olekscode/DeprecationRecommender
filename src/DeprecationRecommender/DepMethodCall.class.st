Class {
	#name : #DepMethodCall,
	#superclass : #Object,
	#instVars : [
		'selector',
		'isAdded'
	],
	#category : #'DeprecationRecommender-Models'
}

{ #category : #comparing }
DepMethodCall >> < anObject [
	"TODO: Fix APriori and remove this"
	^ self hash < anObject hash
]

{ #category : #accessing }
DepMethodCall >> = anObject [

	self class = anObject class
		ifFalse: [ ^ false ].
		
	^ selector = anObject selector and: [ 
		isAdded = anObject isAdded ].
]

{ #category : #accessing }
DepMethodCall >> hash [

	^ selector hash bitXor: isAdded hash
]

{ #category : #accessing }
DepMethodCall >> isAdded [

	^ isAdded
]

{ #category : #testing }
DepMethodCall >> isRemoved [
	
	^ isAdded not
]

{ #category : #testing }
DepMethodCall >> markAsAdded [
	
	isAdded := true
]

{ #category : #testing }
DepMethodCall >> markAsRemoved [
	
	isAdded := false
]

{ #category : #printing }
DepMethodCall >> printOn: aStream [

	aStream
		nextPutAll: (isAdded ifTrue: [ 'added(' ] ifFalse: [ 'removed(' ]);
		nextPutAll: self selector;
		nextPut: $).
]

{ #category : #accessing }
DepMethodCall >> selector [

	^ selector
]

{ #category : #accessing }
DepMethodCall >> selector: anObject [

	selector := anObject
]
