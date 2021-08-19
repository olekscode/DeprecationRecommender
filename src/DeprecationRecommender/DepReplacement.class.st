Class {
	#name : #DepReplacement,
	#superclass : #Object,
	#instVars : [
		'oldMethod',
		'newMethods',
		'refactorings',
		'frequentMethodCallReplacement'
	],
	#category : #'DeprecationRecommender-Models'
}

{ #category : #converting }
DepReplacement >> asJsonDictionary [

	^ { 
		'oldMethod' -> oldMethod asJsonDictionary .
		'newMethods' -> (newMethods collect: [ :each | each asJsonDictionary ]) asArray .
		'refactorings' -> (refactorings collect: [ :each | each asJsonArray ]) asArray .
		'frequentMethodCallReplacement' -> (frequentMethodCallReplacement
			ifNotNil: [ :each | each asJsonDictionary ]
			ifNil: [ nil ])
	} asDictionary
]

{ #category : #accessing }
DepReplacement >> frequentMethodCallReplacement [

	^ frequentMethodCallReplacement
]

{ #category : #accessing }
DepReplacement >> frequentMethodCallReplacement: anObject [

	frequentMethodCallReplacement := anObject
]

{ #category : #initialization }
DepReplacement >> initialize [
	super initialize.
	refactorings := OrderedCollection new.
]

{ #category : #accessing }
DepReplacement >> newMethods [

	^ newMethods
]

{ #category : #accessing }
DepReplacement >> newMethods: anObject [

	newMethods := anObject
]

{ #category : #accessing }
DepReplacement >> oldMethod [

	^ oldMethod
]

{ #category : #accessing }
DepReplacement >> oldMethod: anObject [

	oldMethod := anObject
]

{ #category : #printing }
DepReplacement >> printOn: aStream [

	aStream nextPutAll: (' + ' join: (newMethods collect: [ :method | method signature ]))
]

{ #category : #accessing }
DepReplacement >> refactorings [

	^ refactorings
]

{ #category : #accessing }
DepReplacement >> refactorings: anObject [

	refactorings := anObject
]
