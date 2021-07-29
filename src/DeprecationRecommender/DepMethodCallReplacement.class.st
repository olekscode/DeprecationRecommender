Class {
	#name : #DepMethodCallReplacement,
	#superclass : #Object,
	#instVars : [
		'removedSelectors',
		'addedSelectors',
		'methodChanges',
		'count',
		'support',
		'confidence',
		'lift'
	],
	#category : #'DeprecationRecommender-Models'
}

{ #category : #accessing }
DepMethodCallReplacement >> addedSelectors [

	^ addedSelectors
]

{ #category : #accessing }
DepMethodCallReplacement >> addedSelectors: anObject [

	addedSelectors := anObject
]

{ #category : #converting }
DepMethodCallReplacement >> asDictionary [

	^ { 
		'removedSelectors' -> removedSelectors asArray .
		'addedSelectors' -> addedSelectors asArray .
		'methodChanges' -> (methodChanges collect: [ :each | each asDictionary ]) asArray .
		'count' -> count .
		'support' -> support .
		'confidence' -> confidence .
		'lift' -> lift
	} asDictionary
]

{ #category : #accessing }
DepMethodCallReplacement >> confidence [

	^ confidence
]

{ #category : #accessing }
DepMethodCallReplacement >> confidence: anObject [

	confidence := anObject
]

{ #category : #accessing }
DepMethodCallReplacement >> count [

	^ count
]

{ #category : #accessing }
DepMethodCallReplacement >> count: anObject [

	count := anObject
]

{ #category : #accessing }
DepMethodCallReplacement >> lift [

	^ lift
]

{ #category : #accessing }
DepMethodCallReplacement >> lift: anObject [

	lift := anObject
]

{ #category : #accessing }
DepMethodCallReplacement >> methodChanges [

	^ methodChanges
]

{ #category : #accessing }
DepMethodCallReplacement >> methodChanges: anObject [

	methodChanges := anObject
]

{ #category : #accessing }
DepMethodCallReplacement >> removedSelectors [

	^ removedSelectors
]

{ #category : #accessing }
DepMethodCallReplacement >> removedSelectors: anObject [

	removedSelectors := anObject
]

{ #category : #accessing }
DepMethodCallReplacement >> support [

	^ support
]

{ #category : #accessing }
DepMethodCallReplacement >> support: anObject [

	support := anObject
]
