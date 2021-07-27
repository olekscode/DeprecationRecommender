Extension { #name : #ClioMethod }

{ #category : #'*DeprecationRecommender' }
ClioMethod >> tokens [ 
	| visitor |
	visitor := TokensCollectingVisitor new.
	self ast acceptVisitor: visitor.
	^ visitor tokens
]
