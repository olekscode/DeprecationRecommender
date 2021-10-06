Class {
	#name : #DepAPrioriFixture,
	#superclass : #Object,
	#instVars : [
		'transactions',
		'expectedRules',
		'frequentItemsetsForCandidates'
	],
	#category : #'DeprecationRecommender-Tests'
}

{ #category : #accessing }
DepAPrioriFixture >> expectedRules [

	^ expectedRules
]

{ #category : #accessing }
DepAPrioriFixture >> frequentItemsetsForCandidates [

	^ frequentItemsetsForCandidates
]

{ #category : #initialization }
DepAPrioriFixture >> initialize [

	| removedSaveAndSubmit addedSave addedSubmit addedDo removedSubmit removedSave removedIfTrue addedIfFalse |
	super initialize.
	
	removedSaveAndSubmit := DepMethodCall newRemoved: #saveAndSubmit.
	addedSave := DepMethodCall newAdded: #save.
	addedSubmit := DepMethodCall newAdded: #submit.
	addedDo := DepMethodCall newAdded: #do:.
	removedSubmit := DepMethodCall newRemoved: #send.
	removedSave := DepMethodCall newRemoved: #save.
	removedIfTrue := DepMethodCall newRemoved: #ifTrue.
	addedIfFalse := DepMethodCall newAdded: #ifFalse.
	
	transactions := {
		{ removedSaveAndSubmit . addedSave . addedSubmit } .
		{ removedSubmit . addedDo } .
		{ addedDo . removedSaveAndSubmit . addedSave . addedSubmit } .
		{ removedIfTrue . addedIfFalse . removedSubmit } .
		{ removedIfTrue . addedIfFalse } .
		{ addedDo . removedIfTrue . addedIfFalse } .
		{ removedSaveAndSubmit . addedSave . addedSubmit . removedIfTrue . addedIfFalse } .
		{ removedSaveAndSubmit . addedSave }
	} collect: [ :each | each asItemset ].
	
	expectedRules := { 
		{ removedSaveAndSubmit } asItemset => { addedSubmit . addedSave } asItemset .
		{ removedSaveAndSubmit } asItemset => { addedSave } asItemset .
		{ removedSaveAndSubmit } asItemset => { addedSubmit } asItemset
	}.
	
	frequentItemsetsForCandidates := { 
		{ removedSaveAndSubmit . addedSave } asItemset .
		{ removedSaveAndSubmit . addedSubmit } asItemset .
	}.
]

{ #category : #accessing }
DepAPrioriFixture >> transactions [

	^ transactions
]
