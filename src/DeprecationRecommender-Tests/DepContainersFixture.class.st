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

	^ #()
]
