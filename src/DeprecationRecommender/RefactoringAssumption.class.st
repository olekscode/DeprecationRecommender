Class {
	#name : #RefactoringAssumption,
	#superclass : #Object,
	#instVars : [
		'projectHistory',
		'method',
		'spy',
		'blamedCommit',
		'potentialReplacements'
	],
	#category : #DeprecationRecommender
}

{ #category : #'as yet unclassified' }
RefactoringAssumption class >> for: aMethod basedOn: aProjectHistory [
	^ self new
		method: aMethod;
		projectHistory: aProjectHistory;
		yourself
]

{ #category : #accessing }
RefactoringAssumption >> blamedCommit [

	^ blamedCommit
]

{ #category : #accessing }
RefactoringAssumption >> canExplain [
	
	^ potentialReplacements isNotEmpty
]

{ #category : #'as yet unclassified' }
RefactoringAssumption >> explanation [

	self subclassResponsibility
]

{ #category : #initialization }
RefactoringAssumption >> initialize [
	super initialize.
	potentialReplacements := OrderedCollection new.
]

{ #category : #accessing }
RefactoringAssumption >> method [

	^ method
]

{ #category : #accessing }
RefactoringAssumption >> method: anObject [

	method := anObject
]

{ #category : #accessing }
RefactoringAssumption >> potentialReplacements [

	^ potentialReplacements
]

{ #category : #accessing }
RefactoringAssumption >> projectHistory: anObject [

	projectHistory := anObject.
	spy := RefactoringSpy in: projectHistory.
]

{ #category : #testing }
RefactoringAssumption >> tryToExplain [

	self subclassResponsibility.
	
	
]
