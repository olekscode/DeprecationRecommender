Class {
	#name : #RenameAssumption,
	#superclass : #RefactoringAssumption,
	#category : #DeprecationRecommender
}

{ #category : #testing }
RenameAssumption >> explanation [
	^ 'Method {1} was renamed to {2} by {3} on {4}' format: { 
		method signature .
		potentialReplacements first selector .
		blamedCommit author .
		blamedCommit datetime asDate }
]

{ #category : #testing }
RenameAssumption >> tryToExplain [

	blamedCommit := spy commitThatRemovedMethod: method.
	blamedCommit ifNil: [ ^ self ].
	
	potentialReplacements := blamedCommit addedMethods select: [ :addedMethod |
		addedMethod className = method className and: [ 
			addedMethod selector ~= method selector and: [
				addedMethod sourceCode lines copyWithoutFirst = method sourceCode lines copyWithoutFirst ] ] ].
]
