Class {
	#name : #DepRecommendations,
	#superclass : #OrderedCollection,
	#category : #'DeprecationRecommender-Models'
}

{ #category : #converting }
DepRecommendations >> saveToJsonFile: aFileReference [

	| object |
	object := (self collect: [ :each | each asDictionary ]) asArray.
	
	aFileReference writeStreamDo: [ :stream |
		STONJSON put: object onStreamPretty: stream ].
]
