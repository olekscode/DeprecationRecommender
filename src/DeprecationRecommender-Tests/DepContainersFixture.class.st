Class {
	#name : #DepContainersFixture,
	#superclass : #Object,
	#instVars : [
		'data'
	],
	#category : #'DeprecationRecommender-Tests'
}

{ #category : #accessing }
DepContainersFixture >> data [
	
	^ data
]

{ #category : #initialization }
DepContainersFixture >> initialize [

	super initialize.
	
	data := ClioData new
		repositoryOwner: 'olekscode';
		repositoryName: 'FakeContainers';
		baselineName: 'Containers';
		imageVersion: 'Pharo-10.0.0+build.179.sha.4a71dad3a784055c53137ba42251ebd58595cd8c (64 Bit)';
		datetime: '2021-10-07T14:05:18.921934+02:00' asDateAndTime;
		yourself.
		
	data commits: self initializeCommits.
	data oldPackages: self initializeOldPackages.
	data newPackages: self initializeNewPackages.
		
		
]

{ #category : #initialization }
DepContainersFixture >> initializeCommits [

	^ #()
]

{ #category : #initialization }
DepContainersFixture >> initializeNewPackages [

	^ #()
]

{ #category : #initialization }
DepContainersFixture >> initializeOldPackages [

	^ {
		self oldPackageBaselineOfContainers .
		self oldPackageContainers .
		self oldPackageContainersTests
	} asOrderedCollection
]

{ #category : #'old source code' }
DepContainersFixture >> oldClassBaselineOfContainers [

	| aClass |
	
	aClass := ClioClass new
		name: 'BaselineOfContainers';
		superclassName: 'BaselineOf';
		yourself.
	
	aClass methods: {
		self oldMethodBaselineOfContainersBaseline
	} asOrderedCollection.
	
	^ aClass
]

{ #category : #'old source code' }
DepContainersFixture >> oldClassCTArray [

	| aClass |
	
	aClass := ClioClass new
		name: 'CTArray';
		superclassName: 'CTContainer';
		yourself.
	
	aClass methods: { } asOrderedCollection.
	
	^ aClass
]

{ #category : #'old source code' }
DepContainersFixture >> oldClassCTArrayTest [

	| aClass |
	
	aClass := ClioClass new
		name: 'CTArrayTest';
		superclassName: 'TestCase';
		yourself.
	
	aClass methods: { } asOrderedCollection.
	
	^ aClass
]

{ #category : #'old source code' }
DepContainersFixture >> oldClassCTContainer [

	| aClass |
	
	aClass := ClioClass new
		name: 'CTContainer';
		superclassName: 'Object';
		yourself.
	
	aClass methods: { } asOrderedCollection.
	
	^ aClass
]

{ #category : #'old source code' }
DepContainersFixture >> oldClassCTLink [

	| aClass |
	
	aClass := ClioClass new
		name: 'CTLink';
		superclassName: 'Object';
		yourself.
	
	aClass methods: { } asOrderedCollection.
	
	^ aClass
]

{ #category : #'old source code' }
DepContainersFixture >> oldClassCTLinkedList [

	| aClass |
	
	aClass := ClioClass new
		name: 'CTLinkedList';
		superclassName: 'CTContainer';
		yourself.
	
	aClass methods: { } asOrderedCollection.
	
	^ aClass
]

{ #category : #'old source code' }
DepContainersFixture >> oldClassCTLinkedListTest [

	| aClass |
	
	aClass := ClioClass new
		name: 'CTLinkedListTest';
		superclassName: 'TestCase';
		yourself.
	
	aClass methods: { } asOrderedCollection.
	
	^ aClass
]

{ #category : #'old source code' }
DepContainersFixture >> oldClassTContainerTests [

	| aClass |
	
	aClass := ClioClass new
		name: 'TContainerTests';
		isTrait: true;
		yourself.
	
	aClass methods: { } asOrderedCollection.
	
	^ aClass
]

{ #category : #'old source code' }
DepContainersFixture >> oldMethodBaselineOfContainersBaseline [

	| method |
	
	method := ClioMethod new
		name: 'baseline:';
		className: 'BaselineOfContainers';
		protocol: 'baselines';
		yourself.
		
	method sourceCode: 'baseline: spec
	<baseline>
	spec for: #common do: [	
		"Packages"
		spec 
			package: ''Containers'';
			package: ''Containers-Tests'' with: [ spec requires: #(Containers) ] ].'.
		
	method methodCalls: { } asOrderedCollection.
	
	^ method
]

{ #category : #'old source code' }
DepContainersFixture >> oldPackageBaselineOfContainers [

	| package |
	package := ClioPackage named: 'BaselineOfContainers'.
	
	package classes: {
		self oldClassBaselineOfContainers
	} asOrderedCollection.
	
	package classes do: [ :aClass | aClass package: package ].
	^ package
]

{ #category : #'old source code' }
DepContainersFixture >> oldPackageContainers [

	| package |
	package := ClioPackage named: 'Containers'.
	
	package classes: {
		self oldClassCTContainer .
		self oldClassCTArray .
		self oldClassCTLinkedList .
		self oldClassCTLink
	} asOrderedCollection.
	
	package classes do: [ :aClass | aClass package: package ].
	^ package
]

{ #category : #'old source code' }
DepContainersFixture >> oldPackageContainersTests [

	| package |
	package := ClioPackage named: 'Containers-Tests'.
	
	package classes: {
		self oldClassTContainerTests .
		self oldClassCTArrayTest .
		self oldClassCTLinkedListTest
	} asOrderedCollection.
	
	package classes do: [ :aClass | aClass package: package ].
	^ package
]
