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
	
	| projectClassNames breakingSelectors methods |
	
	projectClassNames := data oldClasses collect: [ :each | each name ].
	
	breakingSelectors := self deletedSupportedSelectors select: [ :each |
		projectClassNames includes: each implementorClassName ].
	
	methods := breakingSelectors collect: [ :selector |
		data oldImplementedMethods detect: [ :method |
			(method name = selector name) and: [ 
				(method methodClass name = selector implementorClassName) and: [ 
					method isClassSide = selector isClassSide ] ] ] ].
	
	methods := methods select: [ :method |
		VisibilityDeductor new isMethodPublic: method ].
	
	methods := methods reject: [ :method |
		method isAbstract or: [ method isEmpty ] ].
	
	^ methods asSet
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
