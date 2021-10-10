Class {
	#name : #DepBreakingChangeDetectorTest,
	#superclass : #TestCase,
	#instVars : [
		'detector',
		'data'
	],
	#category : #'DeprecationRecommender-Tests'
}

{ #category : #initialization }
DepBreakingChangeDetectorTest >> setUp [

	super setUp.
	data := ContainersProjectFixture new data.
	detector := DepBreakingChangeDetector in: data.
]

{ #category : #tests }
DepBreakingChangeDetectorTest >> testBreakingChangeMethods [

	| expectedSignatures actualSignatures |
	
	expectedSignatures := #(
		'CTContainer>>addAll:'
		'CTContainer>>isEmpty'
		'CTArray>>add:'
		'CTArray>>remove:'
		'CTArray>>at:'
		'CTArray>>size'
		'CTArray>>asArray'
		'CTLinkedList>>remove:'
		'CTLinkedList>>add:'
		'CTLinkedList>>at:'
		'CTLinkedList>>size'
		'CTLinkedList>>asArray'
		'CTLink>>value'
		'CTLink>>value:'
		'CTLink>>nextLink'
		'CTLink>>nextLink:'
	) asSet.
	
	actualSignatures := detector breakingChangeMethods
		collect: [ :each | each signature ].
		
	self assert: actualSignatures equals: expectedSignatures
]
