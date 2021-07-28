Class {
	#name : #DepMoveRefactoring,
	#superclass : #DepRefactoring,
	#category : #'DeprecationRecommender-Models'
}

{ #category : #testing }
DepMoveRefactoring class >> canExplainReplacementOf: aMethod with: aReplacementMethod [

	^ aReplacementMethod fullClassName ~= aMethod fullClassName
		and: [ aReplacementMethod selector = aMethod selector ]
]

{ #category : #accessing }
DepMoveRefactoring >> name [
	
	^ 'MoveMethod'
]

{ #category : #printing }
DepMoveRefactoring >> printOn: aStream [

	aStream
		nextPutAll: self name;
		nextPut: $(;
		nextPutAll: removedMethod fullClassName;
		nextPutAll: '->';
		nextPutAll: addedMethod fullClassName;
		nextPut: $).
]
