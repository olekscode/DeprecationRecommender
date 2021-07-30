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

{ #category : #'instance creation' }
DepRecommendation class >> fromDictionary: aDictionary [

	^ self new
		method: (ClioMethod fromDictionary: (aDictionary at: 'method'));
		replacements: ((aDictionary at: 'replacements') collect: [ :each |
			ClioMethod fromDictionary: each ]) asOrderedCollection;
		refactorings: ((aDictionary at: 'refactorings') collect: [ :each |
			DepRefactoringChain fromJsonArray: each ]) asOrderedCollection;
		frequentMethodCallReplacements: ((aDictionary at: 'frequentMethodCallReplacements') collect: [ :each |
			DepMethodCallReplacement fromDictionary: each ]) asOrderedCollection;
		yourself.
]

{ #category : #converting }
DepRecommendation >> asDictionary [
	
	^ {
		'method' -> method asDictionary .
		'replacements' -> (replacements collect: [ :each | each asDictionary ]) asArray .
		'refactorings' -> (refactorings collect: [ :each | each asJsonArray ]) asArray .
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
