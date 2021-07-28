Class {
	#name : #DepMoveRenameRefactoring,
	#superclass : #DepRefactoring,
	#category : #'DeprecationRecommender-Models'
}

{ #category : #testing }
DepMoveRenameRefactoring class >> canExplainReplacementOf: aMethod with: aReplacementMethod [

	^ aReplacementMethod methodClass ~= aMethod methodClass
		and: [ aReplacementMethod selector ~= aMethod selector
			and: [ aReplacementMethod numberOfArguments = aMethod numberOfArguments ] ]
]

{ #category : #accessing }
DepMoveRenameRefactoring >> name [
	
	^ 'MoveRenameMethod'
]

{ #category : #printing }
DepMoveRenameRefactoring >> printOn: aStream [

	aStream
		nextPutAll: DepMoveRefactoring new name;
		nextPut: $(;
		nextPutAll: removedMethod fullClassName;
		nextPutAll: '->';
		nextPutAll: addedMethod fullClassName;
		nextPutAll: ') + ';
		nextPutAll: DepRenameRefactoring new name;
		nextPut: $(;
		nextPutAll: removedMethod name;
		nextPutAll: '->';
		nextPutAll: addedMethod name;
		nextPut: $).
]
