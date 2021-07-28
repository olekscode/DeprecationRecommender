Class {
	#name : #DepCommitBlamer,
	#superclass : #Object,
	#instVars : [
		'projectHistory'
	],
	#category : #'DeprecationRecommender-Controllers'
}

{ #category : #'instance creation' }
DepCommitBlamer class >> in: aProjectHistory [
	^ self new
		projectHistory: aProjectHistory;
		yourself
]

{ #category : #'history search' }
DepCommitBlamer >> commitThatAddedClass: aClass [
	^ self commitThatAddedClassNamed: aClass name
]

{ #category : #'history search' }
DepCommitBlamer >> commitThatAddedClassNamed: aName [
	^ projectHistory commits reversed
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
	^ projectHistory commits reversed
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
	^ projectHistory commits reversed
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
	^ projectHistory commits reversed
		detect: [ :aCommit |
			aCommit removedMethods anySatisfy: [ :each |
				each signature = aSignature and: [ (self isMergeCommit: aCommit) not ] ] ]
		ifNone: [ nil ].
]

{ #category : #private }
DepCommitBlamer >> isMergeCommit: aCommit [
	^ aCommit comment beginsWith: 'Merge'
]

{ #category : #accessing }
DepCommitBlamer >> projectHistory [

	^ projectHistory
]

{ #category : #accessing }
DepCommitBlamer >> projectHistory: anObject [

	projectHistory := anObject
]
