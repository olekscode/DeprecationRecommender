Class {
	#name : #DepCandidateReplacement,
	#superclass : #Object,
	#instVars : [
		'method',
		'similarity',
		'commit'
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
