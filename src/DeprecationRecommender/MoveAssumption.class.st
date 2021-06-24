Class {
	#name : #MoveAssumption,
	#superclass : #RefactoringAssumption,
	#category : #DeprecationRecommender
}

{ #category : #accessing }
MoveAssumption >> explanation [
	^ potentialReplacements size > 1
		ifFalse: [ self singleExplanation ]
		ifTrue: [ self multipleExplanations ]
]

{ #category : #accessing }
MoveAssumption >> multipleExplanations [
	^ 'Method {1} was moved to any of the class: {2} by {3} on {4}' format: { 
		method signature .
		potentialReplacements collect: [ :aMethod | aMethod className ] .
		blamedCommit author .
		blamedCommit datetime asDate }
]

{ #category : #accessing }
MoveAssumption >> singleExplanation [
	^ 'Method {1} was moved to class {2} by {3} on {4}' format: { 
		method signature .
		potentialReplacements first className .
		blamedCommit author .
		blamedCommit datetime asDate }
]

{ #category : #testing }
MoveAssumption >> tryToExplain [

	blamedCommit := spy commitThatRemovedMethod: method.
	blamedCommit ifNil: [ ^ self ].
	
	potentialReplacements := blamedCommit addedMethods select: [ :addedMethod |
		addedMethod selector = method selector and: [ 
			addedMethod className ~= method className and: [
				addedMethod sourceCode lines copyWithoutFirst = method sourceCode lines copyWithoutFirst ] ] ].
]
