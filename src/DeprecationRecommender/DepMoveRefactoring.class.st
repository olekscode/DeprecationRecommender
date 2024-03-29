Class {
	#name : #DepMoveRefactoring,
	#superclass : #DepRefactoring,
	#category : #'DeprecationRecommender-Models'
}

{ #category : #testing }
DepMoveRefactoring >> canExplainReplacement [

	^ addedMethod fullClassName ~= removedMethod fullClassName
		and: [ addedMethod selector = removedMethod selector ]
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
