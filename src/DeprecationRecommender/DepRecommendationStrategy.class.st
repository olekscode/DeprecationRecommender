Class {
	#name : #DepRecommendationStrategy,
	#superclass : #Object,
	#instVars : [
		'data',
		'newVersionSelectors',
		'oldVersionSelectors',
		'windowSize'
	],
	#category : #'DeprecationRecommender-Controllers'
}

{ #category : #'as yet unclassified' }
DepRecommendationStrategy class >> defaultWindowSize [
	
	^ 10
]

{ #category : #'history search' }
DepRecommendationStrategy >> commitThatRemovedMethod: aMethod [

	| blamer |
	blamer := DepCommitBlamer in: data.
	^ blamer commitThatRemovedMethod: aMethod.
]

{ #category : #'history search' }
DepRecommendationStrategy >> commitsSurrounding: aCommit [

	| commitIndex |
	commitIndex := data commits indexOf: aCommit.
	
	^ data commits
		copyFrom: commitIndex
		to: ((commitIndex + windowSize) min: data commits size).
]

{ #category : #accessing }
DepRecommendationStrategy >> data: anObject [

	data := anObject.
	
	oldVersionSelectors := data oldImplementedMethods collect: [ :each | each selector ].
	newVersionSelectors := data newImplementedMethods collect: [ :each | each selector ].
]

{ #category : #initialization }
DepRecommendationStrategy >> initialize [
	super initialize.
	windowSize := self class defaultWindowSize.
]

{ #category : #testing }
DepRecommendationStrategy >> isInNewVersion: aMethod [

	^ data newImplementedMethods anySatisfy: [ :method |
		method signature = aMethod signature ].
]

{ #category : #accessing }
DepRecommendationStrategy >> windowSize: aNumber [

	windowSize := aNumber 
]
