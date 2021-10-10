Class {
	#name : #DepBreakingChangeDetector,
	#superclass : #Object,
	#instVars : [
		'data'
	],
	#category : #'DeprecationRecommender-Controllers'
}

{ #category : #'instance creation' }
DepBreakingChangeDetector class >> in: aData [

	^ self new 
		data: aData;
		yourself
]

{ #category : #recommendation }
DepBreakingChangeDetector >> breakingChangeMethods [
	
	| missingMethods |
	missingMethods := self missingMethods.
	
	missingMethods := missingMethods select: [ :method |
		VisibilityDeductor new isMethodPublic: method ].
	
	^ missingMethods asSet reject: [ :method |
		method isAbstract or: [ method isEmpty ] ].
]

{ #category : #accessing }
DepBreakingChangeDetector >> data: anObject [

	data := anObject
]

{ #category : #testing }
DepBreakingChangeDetector >> doesClassExistInNewVersion: aClass [

	^ data newClasses anySatisfy: [ :each | each name = aClass name ]
]

{ #category : #'as yet unclassified' }
DepBreakingChangeDetector >> findActualClass: aClass [
	"Locate aClass in the image (the version of a project that is currently loaded)"
	^ self class environment at: aClass name asSymbol
]

{ #category : #testing }
DepBreakingChangeDetector >> isMethodUnderstoodInNewVersion: aMethod [
	
	| systemClass |
	systemClass := self findActualClass: aMethod methodClass.
	
	^ aMethod isClassSide
		ifTrue: [ systemClass class canUnderstand: aMethod selector ]
		ifFalse: [ systemClass canUnderstand: aMethod selector ].
]

{ #category : #testing }
DepBreakingChangeDetector >> missingClasses [

	^ data oldClasses reject: [ :aClass |
		self doesClassExistInNewVersion: aClass ]
]

{ #category : #testing }
DepBreakingChangeDetector >> missingMethods [

	| methodsFromMissingClasses |
	
	methodsFromMissingClasses :=  self missingClasses
		flatCollect: [ :aClass | aClass methods ].
		
	^ self missingMethodsFromExistingClasses, methodsFromMissingClasses
]

{ #category : #testing }
DepBreakingChangeDetector >> missingMethodsFromExistingClasses [

	| classes |
	
	classes := data oldClasses select: [ :aClass |
		self doesClassExistInNewVersion: aClass ].
	
	^ classes flatCollect: [ :aClass |
		aClass methods reject: [ :method |
			self isMethodUnderstoodInNewVersion: method ] ].
]
