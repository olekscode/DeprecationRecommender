Class {
	#name : #DeprecationRecommender,
	#superclass : #Object,
	#instVars : [
		'oldVersionSnapshot',
		'newVersionSnapshot',
		'projectHistory'
	],
	#category : #DeprecationRecommender
}

{ #category : #'deprecation - recommendation' }
DeprecationRecommender >> classesToDeprecate [
	^ self deletedPublicClasses
]

{ #category : #private }
DeprecationRecommender >> deletedPublicClasses [
	| oldPublicClasses newPublicClasses oldClassDictionary oldNames newNames deletedNames |
	
	oldPublicClasses := oldVersionSnapshot classes select: [ :each |
		VisibilityDeductor new isClassPublic: each ].
	
	newPublicClasses := newVersionSnapshot classes select: [ :each |
		VisibilityDeductor new isClassPublic: each ].
	
	oldClassDictionary := Dictionary new.
	
	oldPublicClasses do: [ :each |
		oldClassDictionary at: each name ifAbsentPut: each ].
	
	oldNames := oldClassDictionary keys asSet.
	newNames := (newPublicClasses collect: [ :each | each name ]) asSet.
	
	deletedNames := oldNames difference: newNames.
	
	^ deletedNames asOrderedCollection collect: [ :each |
		oldClassDictionary at: each ]
]

{ #category : #private }
DeprecationRecommender >> deletedPublicMethods [
	| oldPublicMethods newPublicMethods oldMethodDictionary oldSignatures newSignatures deletedSignatures |
	
	oldPublicMethods := oldVersionSnapshot methods select: [ :each |
		VisibilityDeductor new isMethodPublic: each ].
	
	newPublicMethods := newVersionSnapshot methods select: [ :each |
		VisibilityDeductor new isMethodPublic: each ].
	
	oldMethodDictionary := (oldPublicMethods collect: [ :each |
		each signature -> each ]) asDictionary.
	
	oldSignatures := oldMethodDictionary keys asSet.
	newSignatures := (newPublicMethods collect: [ :each | each signature ]) asSet.
	
	deletedSignatures := oldSignatures difference: newSignatures.
	
	^ deletedSignatures asOrderedCollection collect: [ :each |
		oldMethodDictionary at: each ]
]

{ #category : #'deprecation - recommendation' }
DeprecationRecommender >> methodsToDeprecate [
	| methods deletedClassNames |
	
	methods := self deletedPublicMethods.
	deletedClassNames := self classesToDeprecate collect: [ :aClass | aClass name ].
	
	^ methods reject: [ :method |
		deletedClassNames includes: method methodClass name ].
]

{ #category : #accessing }
DeprecationRecommender >> newVersionSnapshot [

	^ newVersionSnapshot
]

{ #category : #accessing }
DeprecationRecommender >> newVersionSnapshot: anObject [

	newVersionSnapshot := anObject
]

{ #category : #accessing }
DeprecationRecommender >> oldVersionSnapshot [

	^ oldVersionSnapshot
]

{ #category : #accessing }
DeprecationRecommender >> oldVersionSnapshot: anObject [

	oldVersionSnapshot := anObject
]

{ #category : #accessing }
DeprecationRecommender >> projectHistory [

	^ projectHistory
]

{ #category : #accessing }
DeprecationRecommender >> projectHistory: anObject [

	projectHistory := anObject
]
