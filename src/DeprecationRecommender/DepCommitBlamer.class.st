Class {
	#name : #DepCommitBlamer,
	#superclass : #Object,
	#instVars : [
		'data'
	],
	#category : #'DeprecationRecommender-Controllers'
}

{ #category : #'instance creation' }
DepCommitBlamer class >> in: aData [
	^ self new
		data: aData;
		yourself
]

{ #category : #'history search' }
DepCommitBlamer >> commitThatAddedClass: aClass [
	^ self commitThatAddedClassNamed: aClass name
]

{ #category : #'history search' }
DepCommitBlamer >> commitThatAddedClassNamed: aName [
	^ data commits reversed
		detect: [ :aCommit |
			aCommit addedClasses anySatisfy: [ :each |
				each name = aName and: [ (self isMergeCommit: aCommit) not ] ] ]
		ifNone: [ nil ].
]

{ #category : #'history search' }
DepCommitBlamer >> commitThatAddedMethod: aMethod [
	^ self commitThatAddedMethodWithSignature: aMethod signature
]

{ #category : #'history search' }
DepCommitBlamer >> commitThatAddedMethodWithSignature: aSignature [
	^ data commits reversed
		detect: [ :aCommit |
			aCommit addedMethods anySatisfy: [ :each |
				each signature = aSignature and: [ (self isMergeCommit: aCommit) not ] ] ]
		ifNone: [ nil ].
]

{ #category : #'history search' }
DepCommitBlamer >> commitThatRemovedClass: aClass [
	^ self commitThatRemovedClassNamed: aClass name
]

{ #category : #'history search' }
DepCommitBlamer >> commitThatRemovedClassNamed: aName [
	^ data commits reversed
		detect: [ :aCommit |
			aCommit removedClasses anySatisfy: [ :each |
				each name = aName and: [ (self isMergeCommit: aCommit) not ] ] ]
		ifNone: [ nil ].
]

{ #category : #'history search' }
DepCommitBlamer >> commitThatRemovedMethod: aMethod [
	^ self commitThatRemovedMethodWithSignature: aMethod signature
]

{ #category : #'history search' }
DepCommitBlamer >> commitThatRemovedMethodWithSignature: aSignature [
	^ data commits reversed
		detect: [ :aCommit |
			aCommit removedMethods anySatisfy: [ :each |
				each signature = aSignature and: [ (self isMergeCommit: aCommit) not ] ] ]
		ifNone: [ nil ].
]

{ #category : #accessing }
DepCommitBlamer >> data [

	^ data
]

{ #category : #accessing }
DepCommitBlamer >> data: anObject [

	data := anObject
]

{ #category : #private }
DepCommitBlamer >> isMergeCommit: aCommit [
	^ aCommit comment beginsWith: 'Merge'
]
