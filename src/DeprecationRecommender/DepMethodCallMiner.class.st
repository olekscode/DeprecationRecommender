Class {
	#name : #DepMethodCallMiner,
	#superclass : #DepRecommendationStrategy,
	#category : #'DeprecationRecommender-Controllers'
}

{ #category : #'as yet unclassified' }
DepMethodCallMiner >> extractRelevantMethodCallsFrom: aMethodChange [
	"Removed method call is relevant if it was present in the old version of a library. Added method call is relevant if it is present in the new version"
	
	| oldMethodCalls newMethodCalls oldSelectors newSelectors removedSelectors addedSelectors removedMethodCalls addedMethodCalls |
	
	oldMethodCalls := aMethodChange oldMethod methodCalls asSet.
	newMethodCalls := aMethodChange newMethod methodCalls asSet.
	
	oldSelectors := oldMethodCalls collect: [ :each | each selector ].
	newSelectors := newMethodCalls collect: [ :each | each selector ].
	
	removedSelectors := oldSelectors difference: newSelectors.		
	addedSelectors := newSelectors difference: oldSelectors.
	
	removedMethodCalls := oldMethodCalls select: [ :each | removedSelectors includes: each selector ].		
	addedMethodCalls := newMethodCalls select: [ :each | addedSelectors includes: each selector ].
	
	removedMethodCalls := removedMethodCalls select: [ :methodCall |
		oldVersionSelectors includes: methodCall selector ].
	
	addedMethodCalls := addedMethodCalls select: [ :methodCall |
		newVersionSelectors includes: methodCall selector ].
	
	aMethodChange
		removedMethodCalls: removedMethodCalls;
		addedMethodCalls: addedMethodCalls.
]

{ #category : #'as yet unclassified' }
DepMethodCallMiner >> methodChangesThatRemoveCallsTo: aMethod [

	| blamedCommit surroundingCommits methodChanges removedMethodCalls addedMethodCalls |
	
	blamedCommit := self commitThatRemovedMethod: aMethod.
	blamedCommit ifNil: [ ^ OrderedCollection new ].
	
	surroundingCommits := self commitsSurrounding: blamedCommit.
	
	methodChanges := surroundingCommits flatCollect: [ :commit | 
		commit modifiedMethods collect: [ :modification |
			DepMethodChange new
				oldMethod: modification oldDefinition;
				newMethod: modification newDefinition;
				commit: commit;
				yourself ] ].
		
	methodChanges do: [ :methodChange |
		self extractRelevantMethodCallsFrom: methodChange ].
	
	^ methodChanges select: [ :each |
		each addedMethodCalls isNotEmpty and: [
			each removedMethodCalls anySatisfy: [ :methodCall |
				methodCall selector = aMethod selector ] ] ].
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
