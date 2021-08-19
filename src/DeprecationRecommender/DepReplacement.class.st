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

{ #category : #accessing }
DepReplacement >> frequentMethodCallReplacement [

	^ frequentMethodCallReplacement
]

{ #category : #accessing }
DepReplacement >> frequentMethodCallReplacement: anObject [

	frequentMethodCallReplacement := anObject
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
