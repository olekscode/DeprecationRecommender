Class {
	#name : #DepRecommendationStrategy,
	#superclass : #Object,
	#instVars : [
		'data',
		'newVersionSelectors',
		'oldVersionSelectors'
	],
	#category : #'DeprecationRecommender-Controllers'
}

{ #category : #'history search' }
DepRecommendationStrategy >> commitThatRemovedMethod: aMethod [

	| blamer |
	blamer := DepCommitBlamer in: data.
	^ blamer commitThatRemovedMethod: aMethod.
]

{ #category : #'history search' }
DepRecommendationStrategy >> commitsSurrounding: aCommit [

	| commitIndex windowSize |
	commitIndex := data commits indexOf: aCommit.
	
	windowSize := 10.
	
	^ data commits
		copyFrom: commitIndex
		to: ((commitIndex + windowSize) min: data commits size).
]

{ #category : #accessing }
DepRecommendationStrategy >> data [

	^ data
]

{ #category : #accessing }
DepRecommendationStrategy >> data: anObject [

	data := anObject.
	
	oldVersionSelectors := data oldImplementedMethods collect: [ :each | each selector ].
	newVersionSelectors := data newImplementedMethods collect: [ :each | each selector ].
]

{ #category : #testing }
DepRecommendationStrategy >> isInNewVersion: aMethod [

	^ data newImplementedMethods anySatisfy: [ :method |
		method signature = aMethod signature ].
]
