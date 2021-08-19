Class {
	#name : #DepRenameClassRefactoring,
	#superclass : #DepRefactoring,
	#category : #'DeprecationRecommender-Models'
}

{ #category : #testing }
DepRenameClassRefactoring >> canExplainReplacement [

	^ addedMethod fullClassName ~= removedMethod fullClassName
		and: [ addedMethod selector = removedMethod selector ]
]

{ #category : #accessing }
DepRenameClassRefactoring >> name [
	
	^ 'RenameMethod'
]

{ #category : #printing }
DepRenameClassRefactoring >> printOn: aStream [

	aStream
		nextPutAll: self name;
		nextPut: $(;
		nextPutAll: removedMethod fullClassName;
		nextPutAll: '->';
		nextPutAll: addedMethod fullClassName;
		nextPut: $).
]
