Class {
	#name : #DepRecommendations,
	#superclass : #OrderedCollection,
	#category : #'DeprecationRecommender-Models'
}

{ #category : #'as yet unclassified' }
DepRecommendations class >> readFromJsonFile: aFileReference [

	| array |
	
	array := aFileReference readStreamDo: [ :stream |
		STONJSON fromStream: stream ].
	
	^ self withAll: (array collect: [ :each | DepRecommendation fromJsonDictionary: each ]).
]

{ #category : #converting }
DepRecommendations >> saveToJsonFile: aFileReference [

	| object |
	object := (self collect: [ :each | each asJsonDictionary ]) asArray.
	
	aFileReference writeStreamDo: [ :stream |
		STONJSON put: object onStreamPretty: stream ].
]
