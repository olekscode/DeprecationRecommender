Class {
	#name : #DepRecommendation,
	#superclass : #Object,
	#instVars : [
		'method',
		'replacements',
		'refactorings',
		'frequentMethodCallReplacements'
	],
	#category : #'DeprecationRecommender-Models'
}

{ #category : #converting }
DepRecommendation >> asDictionary [
	
	^ {
		'method' -> method asDictionary .
		'replacements' -> (replacements collect: [ :each | each asDictionary ]) asArray .
		'refactorings' -> (refactorings collect: [ :each | each asDictionary ]) asArray .
		'frequentMethodCallReplacements'  -> (frequentMethodCallReplacements collect: [ :each | each asDictionary ]) asArray .
	} asDictionary
]

{ #category : #accessing }
DepRecommendation >> frequentMethodCallReplacements [

	^ frequentMethodCallReplacements
]

{ #category : #accessing }
DepRecommendation >> frequentMethodCallReplacements: anObject [

	frequentMethodCallReplacements := anObject
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
DepRecommendation >> refactorings [

	^ refactorings
]

{ #category : #accessing }
DepRecommendation >> refactorings: anObject [

	refactorings := anObject
]

{ #category : #accessing }
DepRecommendation >> replacements [

	^ replacements
]

{ #category : #accessing }
DepRecommendation >> replacements: anObject [

	replacements := anObject
]
