Class {
	#name : #DepBreakingChangeDetector,
	#superclass : #Object,
	#instVars : [
		'data'
	],
	#category : #'DeprecationRecommender-Controllers'
}

{ #category : #recommendation }
DepBreakingChangeDetector >> breakingChangeMethods [
	
	| missingMethods systemClass instanceSideSelectors classSideSelectors missingPublicMethods |
	
	missingMethods := data oldClasses flatCollect: [ :aClass |
		systemClass := self findActualClass: aClass.
		
		instanceSideSelectors := self instanceSideSelectorsUnderstoodBy: systemClass.
		classSideSelectors := self classSideSelectorsUnderstoodBy: systemClass.
		
		aClass methods reject: [ :method |
			method isClassSide
				ifTrue: [ classSideSelectors includes: method selector ]
				ifFalse: [ instanceSideSelectors includes: method selector ] ] ].
	
	missingPublicMethods := missingMethods select: [ :method |
		VisibilityDeductor new isMethodPublic: method ].
	
	^ missingPublicMethods asSet reject: [ :method |
		method isAbstract or: [ method isEmpty ] ].
]

{ #category : #'as yet unclassified' }
DepBreakingChangeDetector >> classSideSelectorsUnderstoodBy: aClass [
	"Find all class side selectors that are understood by this class (implemented by it or by its superclasses). aClass must be an actual class in the image"
	^ aClass class allMethods collect: [ :each | each selector ]
]

{ #category : #accessing }
DepBreakingChangeDetector >> data: anObject [

	data := anObject
]

{ #category : #private }
DepBreakingChangeDetector >> deletedPublicClasses [
	| oldPublicClasses newPublicClasses oldClassDictionary oldNames newNames deletedNames |
	
	oldPublicClasses := data oldClasses select: [ :each |
		VisibilityDeductor new isClassPublic: each ].
	
	newPublicClasses := data newClasses select: [ :each |
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
DepBreakingChangeDetector >> deletedSupportedSelectors [
	| oldSelectorDictionary oldSignatures newSignatures deletedSignatures |

	oldSelectorDictionary := Dictionary new.
	
	data oldSupportedSelectors do: [ :each |
		oldSelectorDictionary at: each signature put: each ].
	
	oldSignatures := oldSelectorDictionary keys asSet.
	newSignatures := (data newSupportedSelectors collect: [ :each | each signature ]) asSet.
	
	deletedSignatures := oldSignatures difference: newSignatures.
	
	^ deletedSignatures asOrderedCollection collect: [ :each |
		oldSelectorDictionary at: each ]
]

{ #category : #'as yet unclassified' }
DepBreakingChangeDetector >> findActualClass: aClass [
	"Locate aClass in the image (the version of a project that is currently loaded)"
	^ self class environment at: aClass name asSymbol
]

{ #category : #'as yet unclassified' }
DepBreakingChangeDetector >> instanceSideSelectorsUnderstoodBy: aClass [
	"Find all instance side selectors that are understood by this class (implemented by it or by its superclasses). aClass must be an actual class in the image"
	^ aClass allMethods collect: [ :each | each selector ]
]
