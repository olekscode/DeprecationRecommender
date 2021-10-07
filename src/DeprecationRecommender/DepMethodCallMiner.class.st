Class {
	#name : #DepMethodCallMiner,
	#superclass : #DepRecommendationStrategy,
	#category : #'DeprecationRecommender-Controllers'
}

{ #category : #'as yet unclassified' }
DepMethodCallMiner >> extractAddedMethodCallsFrom: aMethodModification [
	"Added method call is relevant if it is present in the new version of a library"
	
	| oldSelectors newSelectors addedSelectors |
	
	oldSelectors := aMethodModification oldDefinition methodCalls asSet.
	newSelectors := aMethodModification newDefinition methodCalls asSet.
	
	addedSelectors := newSelectors difference: oldSelectors.
	
	^ addedSelectors asOrderedCollection select: [ :each |
		newVersionSelectors includes: each ].
]

{ #category : #'as yet unclassified' }
DepMethodCallMiner >> extractRemovedMethodCallsFrom: aMethodModification [
	"Removed method call is relevant if it was present in the old version of a library"
	
	| oldSelectors newSelectors removedSelectors |
	
	oldSelectors := aMethodModification oldDefinition methodCalls asSet.
	newSelectors := aMethodModification newDefinition methodCalls asSet.
	
	removedSelectors := oldSelectors difference: newSelectors.
	
	^ removedSelectors asOrderedCollection select: [ :each |
		oldVersionSelectors includes: each ].
]

{ #category : #'as yet unclassified' }
DepMethodCallMiner >> methodChangesThatRemoveCallsTo: aMethod [

	| blamedCommit surroundingCommits methodChanges |
	
	blamedCommit := self commitThatRemovedMethod: aMethod.
	blamedCommit ifNil: [ ^ OrderedCollection new ].
	
	surroundingCommits := self commitsSurrounding: blamedCommit.
	
	methodChanges := surroundingCommits flatCollect: [ :commit | 
		commit modifiedMethods collect: [ :modification |
			DepMethodChange new
				signature: modification oldDefinition signature;
				commitId: commit id;
				removedMethodCalls: (self extractRemovedMethodCallsFrom: modification);
				addedMethodCalls: (self extractAddedMethodCallsFrom: modification);
				yourself ] ].
	
	^ methodChanges select: [ :each |
		each addedMethodCalls isNotEmpty and: [
			each removedMethodCalls anySatisfy: [ :methodCall |
				methodCall = aMethod selector ] ] ].
]

{ #category : #accessing }
DepMethodCallMiner >> minNumberOfRepetitions [

	^ 2
]

{ #category : #'as yet unclassified' }
DepMethodCallMiner >> mineAssociationRulesFrom: aCollectionOfTransactions for: aMethod [

	| transactionsSource apriori |
	
	transactionsSource := APrioriTransactionsArray from: aCollectionOfTransactions.
	
	apriori := (DepAPriori forTransactions: transactionsSource)
		removedMethod: aMethod;
		yourself.

	apriori minCount: self minNumberOfRepetitions.
	apriori findFrequentItemsets.
	apriori buildAssociationRules.
	
	apriori calculateAssociationRuleMetrics: { 
		APrioriCountMetric .
		APrioriSupportMetric .
		APrioriConfidenceMetric .
		APrioriLiftMetric }.
		
	^ apriori associationRules
]

{ #category : #'as yet unclassified' }
DepMethodCallMiner >> mineFrequentMethodCallReplacementsFor: aMethod [

	| methodChanges transactions rules replacements |
	
	methodChanges := self methodChangesThatRemoveCallsTo: aMethod.
	methodChanges ifEmpty: [ ^ OrderedCollection new ].
	
	transactions := methodChanges collect: [ :each | each asItemset ].
	rules := self mineAssociationRulesFrom: transactions for: aMethod.
	
	replacements := rules collect: [ :rule |
		DepMethodCallReplacement new
			removedSelectors: (rule key asOrderedCollection collect: [ :each | each selector ]);
			addedSelectors: (rule value asOrderedCollection collect: [ :each | each selector ]);
			count: rule count;
			support: rule support;
			confidence: rule confidence;
			lift: rule lift;
			yourself ].
		
	replacements do: [ :replacement |
		replacement methodChanges: (methodChanges select: [ :methodChange |
			(replacement removedSelectors allSatisfy: [ :selector |
				methodChange removedMethodCalls anySatisfy: [ :methodCall |
					methodCall selector = selector ] ]) and: [ 
			(replacement addedSelectors allSatisfy: [ :selector |
				methodChange addedMethodCalls anySatisfy: [ :methodCall |
					methodCall selector = selector ] ]) ] ]) ].
	
	^ replacements
]
