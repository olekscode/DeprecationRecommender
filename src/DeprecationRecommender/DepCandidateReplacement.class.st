Class {
	#name : #DepCandidateReplacement,
	#superclass : #Object,
	#instVars : [
		'method',
		'similarity',
		'commit',
		'commitDistance'
	],
	#category : #'DeprecationRecommender-Models'
}

{ #category : #accessing }
DepCandidateReplacement >> commit [

	^ commit
]

{ #category : #accessing }
DepCandidateReplacement >> commit: anObject [

	commit := anObject
]

{ #category : #accessing }
DepCandidateReplacement >> commitDistance [

	^ commitDistance
]

{ #category : #accessing }
DepCandidateReplacement >> commitDistance: anObject [

	commitDistance := anObject
]

{ #category : #accessing }
DepCandidateReplacement >> method [

	^ method
]

{ #category : #accessing }
DepCandidateReplacement >> method: anObject [

	method := anObject
]

{ #category : #accessing }
DepCandidateReplacement >> similarity [

	^ similarity
]

{ #category : #accessing }
DepCandidateReplacement >> similarity: anObject [

	similarity := anObject
]
