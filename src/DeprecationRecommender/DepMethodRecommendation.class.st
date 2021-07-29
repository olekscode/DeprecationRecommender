Class {
	#name : #DepMethodRecommendation,
	#superclass : #Object,
	#instVars : [
		'method',
		'replacements',
		'refactorings',
		'frequentMethodCallReplacements'
	],
	#category : #'DeprecationRecommender-Models'
}

{ #category : #accessing }
DepMethodRecommendation >> frequentMethodCallReplacements [

	^ frequentMethodCallReplacements
]

{ #category : #accessing }
DepMethodRecommendation >> frequentMethodCallReplacements: anObject [

	frequentMethodCallReplacements := anObject
]

{ #category : #accessing }
DepMethodRecommendation >> method [

	^ method
]

{ #category : #accessing }
DepMethodRecommendation >> method: anObject [

	method := anObject
]

{ #category : #accessing }
DepMethodRecommendation >> refactorings [

	^ refactorings
]

{ #category : #accessing }
DepMethodRecommendation >> refactorings: anObject [

	refactorings := anObject
]

{ #category : #accessing }
DepMethodRecommendation >> replacements [

	^ replacements
]

{ #category : #accessing }
DepMethodRecommendation >> replacements: anObject [

	replacements := anObject
]
