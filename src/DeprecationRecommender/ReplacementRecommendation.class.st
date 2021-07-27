Class {
	#name : #ReplacementRecommendation,
	#superclass : #Object,
	#instVars : [
		'method',
		'replacements',
		'refactorings'
	],
	#category : #DeprecationRecommender
}

{ #category : #initialization }
ReplacementRecommendation >> initialize [ 
	super initialize.
	replacements := OrderedCollection new.
]

{ #category : #accessing }
ReplacementRecommendation >> method [

	^ method
]

{ #category : #accessing }
ReplacementRecommendation >> method: anObject [

	method := anObject
]

{ #category : #accessing }
ReplacementRecommendation >> replacements [

	^ replacements
]
