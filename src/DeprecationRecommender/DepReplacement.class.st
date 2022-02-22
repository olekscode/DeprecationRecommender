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

{ #category : #'instance creation' }
DepReplacement class >> fromJsonDictionary: aDictionary [
	| methodCallReplacement |
	
	methodCallReplacement := (aDictionary at: 'frequentMethodCallReplacement')
		ifNil: [ nil ]
		ifNotNil: [ :dict | DepMethodCallReplacement fromJsonDictionary: dict ].

	^ self new
		oldMethod: (ClioMethod fromJsonDictionary: (aDictionary at: 'oldMethod'));
		newMethods: ((aDictionary at: 'newMethods') collect: [ :each | (ClioMethod fromJsonDictionary: each) ]) asOrderedCollection;
		refactorings: ((aDictionary at: 'refactorings') collect: [ :each | DepRefactoringChain fromJsonArray: each]) asOrderedCollection;
		frequentMethodCallReplacement: methodCallReplacement;
		yourself.

]

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
