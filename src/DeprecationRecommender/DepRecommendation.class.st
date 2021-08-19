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
DepRecommendation class >> fromJsonDictionary: aDictionary [

	^ self new
		method: (ClioMethod fromJsonDictionary: (aDictionary at: 'method'));
		replacements: ((aDictionary at: 'replacements') collect: [ :each |
			ClioMethod fromJsonDictionary: each ]) asOrderedCollection;
		refactorings: ((aDictionary at: 'refactorings') collect: [ :each |
			DepRefactoringChain fromJsonArray: each ]) asOrderedCollection;
		frequentMethodCallReplacements: ((aDictionary at: 'frequentMethodCallReplacements') collect: [ :each |
			DepMethodCallReplacement fromJsonDictionary: each ]) asOrderedCollection;
		yourself.
]

{ #category : #converting }
DepRecommendation >> asJsonDictionary [
	
	^ {
		'method' -> method asJsonDictionary .
		'replacements' -> (replacements collect: [ :each | each asJsonDictionary ]) asArray .
		'refactorings' -> (refactorings collect: [ :each | each asJsonArray ]) asArray .
		'frequentMethodCallReplacements'  -> (frequentMethodCallReplacements collect: [ :each | each asJsonDictionary ]) asArray .
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
