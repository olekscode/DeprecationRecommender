Class {
	#name : #DeprecationRecommender,
	#superclass : #Object,
	#instVars : [
		'clio'
	],
	#category : #DeprecationRecommender
}

{ #category : #'as yet unclassified' }
DeprecationRecommender >> classesToDeprecate [
	^ clio deletedPublicClasses
]

{ #category : #accessing }
DeprecationRecommender >> clio [
	
	^ clio
]

{ #category : #'as yet unclassified' }
DeprecationRecommender >> methodsToDeprecate [
	| methods deletedClassNames |
	
	methods := clio deletedPublicMethods.
	deletedClassNames := self classesToDeprecate collect: [ :aClass | aClass name ].
	
	^ methods reject: [ :method |
		deletedClassNames includes: method methodClass name ].
]

{ #category : #'as yet unclassified' }
DeprecationRecommender >> repositoryName: repositoryName oldVersion: oldCommitSha newVersion: newCommitSha [

	clio := Clio
		for: repositoryName
		between: oldCommitSha
		and: newCommitSha.
]
