Class {
	#name : #BaselineOfDeprecationRecommender,
	#superclass : #BaselineOf,
	#category : #BaselineOfDeprecationRecommender
}

{ #category : #baselines }
BaselineOfDeprecationRecommender >> baseline: spec [
	<baseline>
	spec for: #common do: [	
		"External dependencies"
		spec
			baseline: 'Clio'
			with: [ spec repository: 'github://olekscode/Clio/src' ].
		
		"Packages"
		spec 
			package: 'DeprecationRecommender' with: [ spec requires: #(Clio) ];
			package: 'DeprecationRecommender-Tests' with: [ spec requires: #(DeprecationRecommender) ] ].
]
