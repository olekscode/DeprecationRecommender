Class {
	#name : #DepRefactoringChain,
	#superclass : #OrderedCollection,
	#category : #'DeprecationRecommender-Models'
}

{ #category : #'as yet unclassified' }
DepRefactoringChain >> addedMethod [
	
	^ self last addedMethod
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
