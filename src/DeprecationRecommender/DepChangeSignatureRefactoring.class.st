Class {
	#name : #DepChangeSignatureRefactoring,
	#superclass : #DepRefactoring,
	#category : #'DeprecationRecommender-Models'
}

{ #category : #testing }
DepChangeSignatureRefactoring class >> canExplainReplacementOf: aMethod with: aReplacementMethod [

	^ aReplacementMethod methodClass = aMethod methodClass
		and: [ aReplacementMethod selector ~= aMethod selector
			and: [ aReplacementMethod numberOfArguments ~= aMethod numberOfArguments ] ]
]

{ #category : #accessing }
DepChangeSignatureRefactoring >> name [
	
	^ 'ChangeSignature'
]

{ #category : #printing }
DepChangeSignatureRefactoring >> printOn: aStream [

	aStream
		nextPutAll: self name;
		nextPut: $(;
		nextPutAll: removedMethod name;
		nextPutAll: '->';
		nextPutAll: addedMethod name;
		nextPut: $).
]
