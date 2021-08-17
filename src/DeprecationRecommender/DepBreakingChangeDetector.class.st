Class {
	#name : #DepBreakingChangeDetector,
	#superclass : #Object,
	#instVars : [
		'oldVersionSnapshot',
		'newVersionSnapshot'
	],
	#category : #'DeprecationRecommender-Controllers'
}

{ #category : #recommendation }
DepBreakingChangeDetector >> breakingChangeMethods [
	| methods deletedClassNames |
	
	methods := self deletedPublicMethods.
	"deletedClassNames := self deletedPublicClasses collect: [ :aClass | aClass name ]."
	
	^ methods reject: [ :method |
		method isEmpty or: [
			method isAbstract "or: [
				deletedClassNames includes: method methodClass name ]" ] ].
]

{ #category : #private }
DepBreakingChangeDetector >> deletedPublicClasses [
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
DepBreakingChangeDetector >> deletedPublicMethods [
	| oldPublicMethods newPublicMethods oldMethodDictionary oldSignatures newSignatures deletedSignatures |
	
	oldPublicMethods := oldVersionSnapshot methods select: [ :each |
		VisibilityDeductor new isMethodPublic: each ].
	
	newPublicMethods := newVersionSnapshot methods select: [ :each |
		VisibilityDeductor new isMethodPublic: each ].
	
	oldMethodDictionary := Dictionary new.
	
	oldPublicMethods do: [ :each |
		oldMethodDictionary at: each signature put: each ].
	
	oldSignatures := oldMethodDictionary keys asSet.
	newSignatures := (newPublicMethods collect: [ :each | each signature ]) asSet.
	
	deletedSignatures := oldSignatures difference: newSignatures.
	
	^ deletedSignatures asOrderedCollection collect: [ :each |
		oldMethodDictionary at: each ]
]

{ #category : #accessing }
DepBreakingChangeDetector >> newVersionSnapshot: anObject [

	newVersionSnapshot := anObject
]

{ #category : #accessing }
DepBreakingChangeDetector >> oldVersionSnapshot: anObject [

	oldVersionSnapshot := anObject
]
