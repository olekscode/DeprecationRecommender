Class {
	#name : #DepRefactoringChain,
	#superclass : #OrderedCollection,
	#category : #'DeprecationRecommender-Models'
}

{ #category : #'instance creation' }
DepRefactoringChain class >> fromJsonArray: anArray [

	^ self withAll: (anArray collect: [ :each | DepRefactoring fromJsonDictionary: each ])
]

{ #category : #'as yet unclassified' }
DepRefactoringChain >> addedMethod [
	
	^ self last addedMethod
]

{ #category : #converting }
DepRefactoringChain >> asJsonArray [
	
	^ (self collect: [ :each | each asJsonDictionary ]) asArray
]

{ #category : #copying }
DepRefactoringChain >> copyWithAll: aCollection [

	| newCollection |
	newCollection := self copy.
	newCollection addAll: aCollection.
	^ newCollection
]

{ #category : #printing }
DepRefactoringChain >> printOn: aStream [

	aStream nextPutAll: ('+' join: (self collect: [ :each | each asString ])).
]

{ #category : #'as yet unclassified' }
DepRefactoringChain >> removedMethod [
	
	^ self first removedMethod
]
