Class {
	#name : #DepMoveChangeSignatureRefactoring,
	#superclass : #DepRefactoring,
	#category : #'DeprecationRecommender-Models'
}

{ #category : #testing }
DepMoveChangeSignatureRefactoring class >> canExplainReplacementOf: aMethod with: aReplacementMethod [

	^ aReplacementMethod methodClass ~= aMethod methodClass
		and: [ aReplacementMethod selector ~= aMethod selector
			and: [ aReplacementMethod numberOfArguments ~= aMethod numberOfArguments ] ]
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
