Class {
	#name : #DepRenameClassRefactoring,
	#superclass : #DepRefactoring,
	#category : #'DeprecationRecommender-Models'
}

{ #category : #testing }
DepRenameClassRefactoring >> canExplainReplacement [

	^ self wasMethodMovedToAnotherClass and: [ 
		self wasClassRenamed ]
]

{ #category : #accessing }
DepRenameClassRefactoring >> name [
	
	^ 'RenameClass'
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
