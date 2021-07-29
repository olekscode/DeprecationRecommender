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
			
		spec
			baseline: 'VisibilityDeductor'
			with: [ spec repository: 'github://olekscode/VisibilityDeductor/src' ].
			
		spec
			baseline: 'PharoCodeTokenizer'
			with: [ spec repository: 'github://olekscode/PharoCodeTokenizer/src' ].
			
		spec
			baseline: 'AIShinglesSimilarity'
			with: [ spec repository: 'github://pharo-ai/shingles-similarity/src' ].
			
		spec
			baseline: 'APriori'
			with: [ spec repository: 'github://pharo-ai/APriori/src' ].
		
		"Packages"
		spec 
			package: 'DeprecationRecommender' with: [ spec requires: #(Clio VisibilityDeductor PharoCodeTokenizer AIShinglesSimilarity APriori) ];
			package: 'DeprecationRecommender-Tests' with: [ spec requires: #(DeprecationRecommender) ] ].
]
