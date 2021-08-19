Class {
	#name : #DepChangeSignatureRefactoring,
	#superclass : #DepRefactoring,
	#category : #'DeprecationRecommender-Models'
}

{ #category : #testing }
DepChangeSignatureRefactoring >> canExplainReplacement [

	^ addedMethod methodClass = removedMethod methodClass
		and: [ addedMethod selector ~= removedMethod selector
			and: [ addedMethod numberOfArguments ~= removedMethod numberOfArguments ] ]
]

{ #category : #accessing }
DepChangeSignatureRefactoring >> name [
	
	^ 'ChangeSignature'
]

{ #category : #printing }
DepChangeSignatureRefactoring >> printOn: aStream [

	aStream
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
		nextPut: $).
]
