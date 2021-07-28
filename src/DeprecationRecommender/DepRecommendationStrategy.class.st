Class {
	#name : #DepRecommendationStrategy,
	#superclass : #Object,
	#instVars : [
		'projectHistory',
		'newVersionSnapshot'
	],
	#category : #'DeprecationRecommender-Controllers'
}

{ #category : #'history search' }
DepRecommendationStrategy >> commitThatRemovedMethod: aMethod [

	| blamer |
	blamer := DepCommitBlamer in: projectHistory.
	^ blamer commitThatRemovedMethod: aMethod.
]

{ #category : #'history search' }
DepRecommendationStrategy >> commitsSurrounding: aCommit [

	| commitIndex windowSize |
	commitIndex := projectHistory commits indexOf: aCommit.
	
	windowSize := 10.
	
	^ projectHistory commits
		copyFrom: commitIndex
		to: ((commitIndex + windowSize) min: projectHistory commits size).
]

{ #category : #testing }
DepRecommendationStrategy >> isInNewVersion: aMethod [

	^ newVersionSnapshot methods anySatisfy: [ :method |
		method signature = aMethod signature ].
]

{ #category : #accessing }
DepRecommendationStrategy >> newVersionSnapshot: anObject [

	newVersionSnapshot := anObject
]

{ #category : #accessing }
DepRecommendationStrategy >> projectHistory: anObject [

	projectHistory := anObject
]
