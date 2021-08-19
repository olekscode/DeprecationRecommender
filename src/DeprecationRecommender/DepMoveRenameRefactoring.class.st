Class {
	#name : #DepMoveRenameRefactoring,
	#superclass : #DepRefactoring,
	#category : #'DeprecationRecommender-Models'
}

{ #category : #testing }
DepMoveRenameRefactoring >> canExplainReplacement [

	^ addedMethod methodClass ~= removedMethod methodClass
		and: [ addedMethod selector ~= removedMethod selector
			and: [ addedMethod numberOfArguments = removedMethod numberOfArguments ] ]
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
		nextPutAll: DepRenameMethodRefactoring new name;
		nextPut: $(;
		nextPutAll: removedMethod name;
		nextPutAll: '->';
		nextPutAll: addedMethod name;
		nextPut: $).
]
