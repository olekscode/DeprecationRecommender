Class {
	#name : #RefactoringSpy,
	#superclass : #Object,
	#instVars : [
		'projectHistory'
	],
	#category : #DeprecationRecommender
}

{ #category : #'instance creation' }
RefactoringSpy class >> in: aProjectHistory [
	^ self new
		projectHistory: aProjectHistory;
		yourself
]

{ #category : #'history search' }
RefactoringSpy >> commitThatAddedClass: aClass [
	^ self commitThatAddedClassNamed: aClass name
]

{ #category : #'history search' }
RefactoringSpy >> commitThatAddedClassNamed: aName [
	^ projectHistory commits reversed
		detect: [ :aCommit |
			aCommit addedClasses anySatisfy: [ :each |
				each name = aName and: [ (self isMergeCommit: aCommit) not ] ] ]
		ifNone: [ nil ].
]

{ #category : #'history search' }
RefactoringSpy >> commitThatAddedMethod: aMethod [
	^ self commitThatAddedMethodWithSignature: aMethod signature
]

{ #category : #'history search' }
RefactoringSpy >> commitThatAddedMethodWithSignature: aSignature [
	^ projectHistory commits reversed
		detect: [ :aCommit |
			aCommit addedMethods anySatisfy: [ :each |
				each signature = aSignature and: [ (self isMergeCommit: aCommit) not ] ] ]
		ifNone: [ nil ].
]

{ #category : #'history search' }
RefactoringSpy >> commitThatRemovedClass: aClass [
	^ self commitThatRemovedClassNamed: aClass name
]

{ #category : #'history search' }
RefactoringSpy >> commitThatRemovedClassNamed: aName [
	^ projectHistory commits reversed
		detect: [ :aCommit |
			aCommit removedClasses anySatisfy: [ :each |
				each name = aName and: [ (self isMergeCommit: aCommit) not ] ] ]
		ifNone: [ nil ].
]

{ #category : #'history search' }
RefactoringSpy >> commitThatRemovedMethod: aMethod [
	^ self commitThatRemovedMethodWithSignature: aMethod signature
]

{ #category : #'history search' }
RefactoringSpy >> commitThatRemovedMethodWithSignature: aSignature [
	^ projectHistory commits reversed
		detect: [ :aCommit |
			aCommit removedMethods anySatisfy: [ :each |
				each signature = aSignature and: [ (self isMergeCommit: aCommit) not ] ] ]
		ifNone: [ nil ].
]

{ #category : #private }
RefactoringSpy >> isMergeCommit: aCommit [
	^ aCommit comment beginsWith: 'Merge'
]

{ #category : #accessing }
RefactoringSpy >> projectHistory [

	^ projectHistory
]

{ #category : #accessing }
RefactoringSpy >> projectHistory: anObject [

	projectHistory := anObject
]
