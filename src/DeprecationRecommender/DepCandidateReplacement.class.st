Class {
	#name : #DepCandidateReplacement,
	#superclass : #Object,
	#instVars : [
		'method',
		'similarity',
		'commitId'
	],
	#category : #'DeprecationRecommender-Models'
}

{ #category : #accessing }
DepCandidateReplacement >> commitId [

	^ commitId
]

{ #category : #accessing }
DepCandidateReplacement >> commitId: anObject [

	commitId := anObject
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
