Class {
	#name : #DepMoveChangeSignatureRefactoring,
	#superclass : #DepRefactoring,
	#category : #'DeprecationRecommender-Models'
}

{ #category : #testing }
DepMoveChangeSignatureRefactoring >> canExplainReplacement [

	^ addedMethod methodClass ~= removedMethod methodClass
		and: [ addedMethod selector ~= removedMethod selector
			and: [ addedMethod numberOfArguments ~= removedMethod numberOfArguments ] ]
]

{ #category : #accessing }
DepMoveChangeSignatureRefactoring >> name [
	
	^ 'MoveChangeSignature'
]

{ #category : #printing }
DepMoveChangeSignatureRefactoring >> printOn: aStream [

	aStream
		nextPutAll: '[';
		nextPutAll: DepMoveRefactoring new name;
		nextPut: $(;
		nextPutAll: removedMethod fullClassName;
		nextPutAll: '->';
		nextPutAll: addedMethod fullClassName;
		nextPutAll: ') + ';
		nextPutAll: DepChangeSignatureRefactoring new name;
		nextPut: $(;
		nextPutAll: removedMethod name;
		nextPutAll: '->';
		nextPutAll: addedMethod name;
		nextPutAll: ')]'.
]
