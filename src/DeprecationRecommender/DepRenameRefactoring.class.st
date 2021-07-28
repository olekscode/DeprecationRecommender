Class {
	#name : #DepRenameRefactoring,
	#superclass : #DepRefactoring,
	#category : #'DeprecationRecommender-Models'
}

{ #category : #testing }
DepRenameRefactoring class >> canExplainReplacementOf: aMethod with: aReplacementMethod [

	^ aReplacementMethod fullClassName = aMethod fullClassName
		and: [ aReplacementMethod selector ~= aMethod selector
			and: [ aReplacementMethod numberOfArguments = aMethod numberOfArguments ] ]
]

{ #category : #accessing }
DepRenameRefactoring >> name [
	
	^ 'RenameMethod'
]

{ #category : #printing }
DepRenameRefactoring >> printOn: aStream [

	aStream
		nextPutAll: self name;
		nextPut: $(;
		nextPutAll: removedMethod name;
		nextPutAll: '->';
		nextPutAll: addedMethod name;
		nextPut: $).
]
