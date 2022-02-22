Class {
	#name : #DepRecommendation,
	#superclass : #Object,
	#instVars : [
		'method',
		'replacements',
		'blamedCommit'
	],
	#category : #'DeprecationRecommender-Models'
}

{ #category : #'instance creation' }
DepRecommendation class >> fromJsonDictionary: aDictionary [

	^ self new
		method: (ClioMethod fromJsonDictionary: (aDictionary at: 'method'));
		replacements: ((aDictionary at: 'replacements') collect: [ :each |
			DepReplacement fromJsonDictionary: each ]) asOrderedCollection;
		blamedCommit: (aDictionary at: 'blamedCommitId');
		yourself.
]

{ #category : #converting }
DepRecommendation >> asJsonDictionary [
	
	^ {
		'method' -> method asJsonDictionary .
		'replacements' -> (replacements collect: [ :each | each asJsonDictionary ]) asArray .
		'blamedCommitId' -> (blamedCommit ifNotNil: [ :commit | commit id ] ifNil: [ nil ]) .
	} asDictionary
]

{ #category : #accessing }
DepRecommendation >> blamedCommit [

	^ blamedCommit
]

{ #category : #accessing }
DepRecommendation >> blamedCommit: anObject [

	blamedCommit := anObject
]

{ #category : #accessing }
DepRecommendation >> method [

	^ method
]

{ #category : #accessing }
DepRecommendation >> method: anObject [

	method := anObject
]

{ #category : #accessing }
DepRecommendation >> replacements [

	^ replacements
]

{ #category : #accessing }
DepRecommendation >> replacements: anObject [

	replacements := anObject
]
