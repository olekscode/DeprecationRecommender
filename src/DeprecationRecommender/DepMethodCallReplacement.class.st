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

{ #category : #'instance creation' }
DepMethodCallReplacement class >> fromJsonDictionary: aDictionary [

	^ self new
		removedSelectors: (aDictionary at: 'removedSelectors') asOrderedCollection;
		addedSelectors: (aDictionary at: 'addedSelectors') asOrderedCollection;
		methodChanges: ((aDictionary at: 'methodChanges') collect: [ :each | DepMethodChange fromJsonDictionary: each ]) asOrderedCollection;
		count: (aDictionary at: 'count');
		support: (aDictionary at: 'support');
		confidence: (aDictionary at: 'confidence');
		lift: (aDictionary at: 'lift');
		yourself.
]

{ #category : #accessing }
DepMethodCallReplacement >> addedSelectors [

	^ addedSelectors
]

{ #category : #accessing }
DepMethodCallReplacement >> addedSelectors: anObject [

	addedSelectors := anObject
]

{ #category : #converting }
DepMethodCallReplacement >> asJsonDictionary [

	^ { 
		'removedSelectors' -> removedSelectors asArray .
		'addedSelectors' -> addedSelectors asArray .
		'methodChanges' -> (methodChanges collect: [ :each | each asJsonDictionary ]) asArray .
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
