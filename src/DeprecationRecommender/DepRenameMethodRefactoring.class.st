Class {
	#name : #DepRenameMethodRefactoring,
	#superclass : #DepRefactoring,
	#category : #'DeprecationRecommender-Models'
}

{ #category : #testing }
DepRenameMethodRefactoring >> canExplainReplacement [

	^ addedMethod fullClassName = removedMethod fullClassName
		and: [ addedMethod selector ~= removedMethod selector
			and: [ addedMethod numberOfArguments = removedMethod numberOfArguments ] ]
]

{ #category : #accessing }
DepRenameMethodRefactoring >> name [
	
	^ 'RenameMethod'
]

{ #category : #printing }
DepRenameMethodRefactoring >> printOn: aStream [

	aStream
		nextPutAll: self name;
		nextPut: $(;
		nextPutAll: removedMethod name;
		nextPutAll: '->';
		nextPutAll: addedMethod name;
		nextPut: $).
]
