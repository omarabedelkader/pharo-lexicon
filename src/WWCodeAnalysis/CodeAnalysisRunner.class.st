Class {
	#name : 'CodeAnalysisRunner',
	#superclass : 'Object',
	#classInstVars : [
		'outputDirectory',
		'packageNames'
	],
	#category : 'WWCodeAnalysis-Runners',
	#package : 'WWCodeAnalysis',
	#tag : 'Runners'
}

{ #category : 'running' }
CodeAnalysisRunner class >> allClassesPerPackage [
	^ self
		saveReportNamed: self classesPerPackageTexFileName
		generatedBy: [ self latexTableForAllClassesPerPackage ]
]

{ #category : 'running' }
CodeAnalysisRunner class >> allClassesPerPackageForPackagesNamed: aCollection [
	self defaultPackages: aCollection.
	^ self allClassesPerPackage
]

{ #category : 'private' }
CodeAnalysisRunner class >> allIdentifierNameWordsInSelectedPackages [
	^ self methodsInSelectedPackages flatCollect: [ :each | each wordsFromIdentifierNames ]
]

{ #category : 'private' }
CodeAnalysisRunner class >> allLiteralsInSelectedPackages [
	^ self methodsInSelectedPackages flatCollect: [ :each | self literalEntriesOfMethod: each ]
]

{ #category : 'running' }
CodeAnalysisRunner class >> allLocPerNonDataMethod [
	^ self
		saveReportNamed: self locPerNonDataMethodTexFileName
		generatedBy: [ self latexTableForAllLocPerNonDataMethod ]
]

{ #category : 'running' }
CodeAnalysisRunner class >> allMethodsPerClass [
	^ self
		saveReportNamed: self methodsPerClassTexFileName
		generatedBy: [ self latexTableForAllMethodsPerClass ]
]

{ #category : 'private' }
CodeAnalysisRunner class >> allSourceWordsInSelectedPackages [
	^ self methodsInSelectedPackages flatCollect: [ :each | each wordsFromSourceCode ]
]

{ #category : 'running' }
CodeAnalysisRunner class >> allTokensPerMethod [
	^ self
		saveReportNamed: self tokensPerMethodTexFileName
		generatedBy: [ self latexTableForAllTokensPerMethod ]
]

{ #category : 'running' }
CodeAnalysisRunner class >> boxplotdistributionplot [
	^ self
		saveReportNamed: self boxplotDistributionPlotCsvFileName
		generatedBy: [ self sizeDistributionPlotCsv ]
]

{ #category : 'running' }
CodeAnalysisRunner class >> boxplotditributionplot [
	^ self boxplotdistributionplot
]

{ #category : 'private' }
CodeAnalysisRunner class >> allWordsInCorpus: aCollection [
	^ aCollection flatCollect: [ :each | self wordsFromCorpusValue: each ]
]

{ #category : 'running' }
CodeAnalysisRunner class >> allclassesperpackage [
	^ self allClassesPerPackage
]

{ #category : 'running' }
CodeAnalysisRunner class >> alllocpernondatamethod [
	^ self allLocPerNonDataMethod
]

{ #category : 'running' }
CodeAnalysisRunner class >> allmethodsperclass [
	^ self allMethodsPerClass
]

{ #category : 'running' }
CodeAnalysisRunner class >> alltokenspermethod [
	^ self allTokensPerMethod
]

{ #category : 'private' }
CodeAnalysisRunner class >> argumentWordsInSelectedPackages [
	^ self methodsInSelectedPackages flatCollect: [ :each |
		self methodArgumentWordsOfMethod: each ]
]

{ #category : 'private' }
CodeAnalysisRunner class >> brownCorpusWords [
	^ self wordsFromCorpusProviderNamedAnyOf: #('BrownCorpus' 'Brown' 'CorpusBrown')
]

{ #category : 'private' }
CodeAnalysisRunner class >> characterCountOfWords: aCollectionOfWords [
	^ self sum: (aCollectionOfWords collect: [ :each | each size ])
]

{ #category : 'private' }
CodeAnalysisRunner class >> characterCountsOfLiterals: aCollectionOfLiterals [
	^ self sum: (aCollectionOfLiterals collect: [ :each | self literalCharacterCount: each ])
]

{ #category : 'private' }
CodeAnalysisRunner class >> classCountOf: aPackage [
	(aPackage respondsTo: #definedClasses) ifTrue: [ ^ aPackage definedClasses size ].
	(aPackage respondsTo: #classes) ifTrue: [ ^ aPackage classes size ].
	self error: 'Unsupported package object: ', aPackage class name
]

{ #category : 'private' }
CodeAnalysisRunner class >> classCountsFor: aCollectionOfPackages [
	^ aCollectionOfPackages collect: [ :each | self classCountOf: each ]
]

{ #category : 'private' }
CodeAnalysisRunner class >> classNameWordsInSelectedPackages [
	^ self identifierWordsFromNames: (self classesInSelectedPackages collect: [ :each | each name ])
]

{ #category : 'private' }
CodeAnalysisRunner class >> classVariableWordsInSelectedPackages [
	^ self identifierWordsFromNames: (self classesInSelectedPackages flatCollect: [ :each | each classVarNames ])
]

{ #category : 'private' }
CodeAnalysisRunner class >> classesInSelectedPackages [
	^ self selectedPackages flatCollect: [ :each | self classesOfPackage: each ]
]

{ #category : 'private' }
CodeAnalysisRunner class >> classesOfPackage: aPackage [
	(aPackage respondsTo: #definedClasses) ifTrue: [ ^ aPackage definedClasses ].
	(aPackage respondsTo: #classes) ifTrue: [ ^ aPackage classes ].
	self error: 'Unsupported package object: ', aPackage class name
]

{ #category : 'accessing' }
CodeAnalysisRunner class >> boxplotDistributionPlotCsvFileName [
	^ 'size_distribution_plot.csv'
]

{ #category : 'accessing' }
CodeAnalysisRunner class >> classesPerPackageTexFileName [
	^ 'all_classes_per_package.tex'
]

{ #category : 'running' }
CodeAnalysisRunner class >> counts [
	^ self
		saveReportNamed: self countsTexFileName
		generatedBy: [ self latexTableForCounts ]
]

{ #category : 'private' }
CodeAnalysisRunner class >> countsForSelectedPackages [
	| packages classes methods |
	packages := self selectedPackages.
	classes := self classesInSelectedPackages.
	methods := self methodsInSelectedPackages.

	^ Dictionary newFrom: {
		#packages -> packages size.
		#classes -> classes size.
		#methods -> methods size.
		#linesOfCode -> (self sum: (self linesOfCodeForMethods: methods)).
		#tokens -> (self sum: (self tokenCountsForMethods: methods)) }
]

{ #category : 'private' }
CodeAnalysisRunner class >> csvEscape: anObject [
	| string escaped |
	string := anObject
		ifNil: [ '' ]
		ifNotNil: [ anObject asString ].
	escaped := string copyReplaceAll: '"' with: '""'.
	^ '"', escaped, '"'
]

{ #category : 'private' }
CodeAnalysisRunner class >> csvLineFrom: aCollection [
	^ String streamContents: [ :stream |
		aCollection doWithIndex: [ :each :index |
			index > 1 ifTrue: [ stream nextPut: $, ].
			stream nextPutAll: (self csvEscape: each) ] ]
]

{ #category : 'accessing' }
CodeAnalysisRunner class >> countsTexFileName [
	^ 'counts.tex'
]

{ #category : 'accessing' }
CodeAnalysisRunner class >> defaultPackages [
	"By default analyze every package loaded in the current image."
	^ self imagePackageNames
]

{ #category : 'accessing' }
CodeAnalysisRunner class >> defaultPackages: aCollection [
	self packageNames: aCollection
]

{ #category : 'accessing' }
CodeAnalysisRunner class >> defaultpackages [
	^ self defaultPackages
]

{ #category : 'accessing' }
CodeAnalysisRunner class >> defaultpackages: aCollection [
	^ self defaultPackages: aCollection
]

{ #category : 'private' }
CodeAnalysisRunner class >> delimiterTokensInSelectedPackages [
	^ self methodsInSelectedPackages flatCollect: [ :each |
		self delimiterTokensOfMethod: each ]
]

{ #category : 'private' }
CodeAnalysisRunner class >> delimiterTokensOfMethod: aCompiledMethod [
	^ aCompiledMethod tokens select: [ :each | self isDelimiterToken: each ]
]

{ #category : 'private' }
CodeAnalysisRunner class >> englishWordSet [
	| provider words |
	provider := self globalNamedAnyOf: #('EnglishWords' 'EnglishDictionary' 'DictionaryWords' 'WordList').
	provider ifNil: [ ^ nil ].
	words := self wordsFromCorpusProvider: provider.
	words ifNil: [ ^ nil ].
	^ (words collect: [ :each | each asLowercase ]) asSet
]

{ #category : 'private' }
CodeAnalysisRunner class >> englishWordsFrom: aCollectionOfWords [
	| dictionary |
	dictionary := self englishWordSet.
	dictionary ifNil: [ ^ aCollectionOfWords ].
	^ aCollectionOfWords select: [ :each | dictionary includes: each asLowercase ]
]

{ #category : 'private' }
CodeAnalysisRunner class >> formatMean: aNumber [
	| rounded |
	rounded := ((aNumber asFloat * 10) rounded / 10.0).
	^ rounded printString
]

{ #category : 'private' }
CodeAnalysisRunner class >> formatPercentage: aNumerator over: aDenominator [
	aDenominator = 0 ifTrue: [ ^ '0' ].
	^ self formatMean: ((aNumerator asFloat / aDenominator asFloat) * 100)
]

{ #category : 'private' }
CodeAnalysisRunner class >> formatStatistic: aKey value: aValue [
	aKey = #mean ifTrue: [ ^ self formatMean: aValue ].
	^ aValue asInteger printString
]

{ #category : 'private' }
CodeAnalysisRunner class >> formatTablePercentage: aNumerator over: aDenominator [
	^ (self formatPercentage: aNumerator over: aDenominator), '%'
]

{ #category : 'private' }
CodeAnalysisRunner class >> formatTableCount: anInteger [
	| digits |
	digits := anInteger asInteger printString.
	digits size <= 3 ifTrue: [ ^ digits ].

	^ String streamContents: [ :stream |
		digits withIndexDo: [ :character :index |
			stream nextPut: character.
			(((digits size - index) \\ 3) = 0 and: [ index < digits size ])
				ifTrue: [ stream nextPutAll: ',' ] ] ]
]

{ #category : 'private' }
CodeAnalysisRunner class >> globalNamedAnyOf: aCollectionOfNames [
	^ aCollectionOfNames
		detect: [ :each | Smalltalk globals includesKey: each asSymbol ]
		ifFound: [ :each | Smalltalk globals at: each asSymbol ]
		ifNone: [ nil ]
]

{ #category : 'private' }
CodeAnalysisRunner class >> globalVariableWordsInSelectedPackages [
	^ self methodsInSelectedPackages flatCollect: [ :each |
		self globalVariableWordsOfMethod: each ]
]

{ #category : 'private' }
CodeAnalysisRunner class >> globalVariableWordsOfMethod: aCompiledMethod [
	| parseTree words |
	parseTree := aCompiledMethod codeAnalysisParseTree.
	(parseTree respondsTo: #nodesDo:) ifFalse: [ ^ #() ].

	words := OrderedCollection new.
	parseTree nodesDo: [ :node |
		(self isGlobalVariableNode: node) ifTrue: [
			(node respondsTo: #name) ifTrue: [
				words addAll: (self identifierWordsFromName: node name) ] ] ].
	^ words asArray
]

{ #category : 'private' }
CodeAnalysisRunner class >> gutenbergCorpusWords [
	^ self wordsFromCorpusProviderNamedAnyOf: #('GutenbergCorpus' 'Gutenberg' 'CorpusGutenberg')
]

{ #category : 'private' }
CodeAnalysisRunner class >> identifierWordsFromName: aString [
	^ (aString splitIdentifierName
		select: [ :each | each isAllLetters ])
		collect: [ :each | each asLowercase ]
]

{ #category : 'private' }
CodeAnalysisRunner class >> identifierWordsFromNames: aCollectionOfNames [
	^ aCollectionOfNames flatCollect: [ :each | self identifierWordsFromName: each ]
]

{ #category : 'private' }
CodeAnalysisRunner class >> instanceVariableWordsInSelectedPackages [
	^ self identifierWordsFromNames: (self classesInSelectedPackages flatCollect: [ :each | each instVarNames ])
]

{ #category : 'private' }
CodeAnalysisRunner class >> imagePackageNames [
	^ Smalltalk image packages collect: [ :each | each name ]
]

{ #category : 'private' }
CodeAnalysisRunner class >> imageWorkingDirectory [
	(Smalltalk image respondsTo: #imageDirectory) ifTrue: [
		^ Smalltalk image imageDirectory asFileReference ].
	(Smalltalk globals includesKey: #FileLocator) ifTrue: [
		| fileLocator |
		fileLocator := Smalltalk globals at: #FileLocator.
		(fileLocator respondsTo: #imageDirectory) ifTrue: [
			^ fileLocator imageDirectory asFileReference ] ].
	^ FileSystem disk workingDirectory
]

{ #category : 'private' }
CodeAnalysisRunner class >> isDataMethod: aCompiledMethod [
	| protocolName |
	protocolName := aCompiledMethod protocol
		ifNil: [ '' ]
		ifNotNil: [ :protocol | protocol asString asLowercase ].
	^ protocolName includesSubstring: 'accessing'
]

{ #category : 'private' }
CodeAnalysisRunner class >> isDelimiterToken: aString [
	aString isEmpty ifTrue: [ ^ false ].
	^ aString allSatisfy: [ :each | each isLetter not and: [ each isDigit not ] ]
]

{ #category : 'private' }
CodeAnalysisRunner class >> isGlobalVariableNode: aNode [
	((aNode respondsTo: #isGlobalVariable) and: [ aNode isGlobalVariable ]) ifTrue: [ ^ true ].
	((aNode respondsTo: #isGlobal) and: [ aNode isGlobal ]) ifTrue: [ ^ true ].
	^ false
]

{ #category : 'private' }
CodeAnalysisRunner class >> isLiteralArrayNode: aNode [
	((aNode respondsTo: #isLiteralArray) and: [ aNode isLiteralArray ]) ifTrue: [ ^ true ].
	^ aNode class name = 'RBLiteralArrayNode'
]

{ #category : 'private' }
CodeAnalysisRunner class >> isLiteralNode: aNode [
	((aNode respondsTo: #isLiteralNode) and: [ aNode isLiteralNode ]) ifTrue: [ ^ true ].
	((aNode respondsTo: #isLiteral) and: [ aNode isLiteral ]) ifTrue: [ ^ true ].
	^ #('RBLiteralValueNode' 'RBLiteralNode') includes: aNode class name
]

{ #category : 'private' }
CodeAnalysisRunner class >> isTestClass: aClass [
	^ aClass isTestCase
]

{ #category : 'private' }
CodeAnalysisRunner class >> isTestMethod: aCompiledMethod [
	^ aCompiledMethod methodClass isTestCase
]

{ #category : 'private' }
CodeAnalysisRunner class >> isTestPackage: aPackage [
	^ (aPackage name asLowercase includesSubstring: 'test')
]

{ #category : 'private' }
CodeAnalysisRunner class >> keywordTokensInSelectedPackages [
	^ self methodsInSelectedPackages flatCollect: [ :each |
		self keywordTokensOfMethod: each ]
]

{ #category : 'private' }
CodeAnalysisRunner class >> keywordTokensOfMethod: aCompiledMethod [
	| parseTree words |
	parseTree := aCompiledMethod codeAnalysisParseTree.
	words := OrderedCollection new.
	words addAll: (self selectorWordsFromSelector: aCompiledMethod selector asString).

	(parseTree respondsTo: #nodesDo:) ifFalse: [ ^ words asArray ].
	parseTree nodesDo: [ :node |
		(node class name = 'RBMessageNode') ifTrue: [
			words addAll: (self selectorWordsFromSelector: node selector asString) ].
		(node class name = 'RBSelfNode') ifTrue: [ words add: 'self' ].
		(node class name = 'RBSuperNode') ifTrue: [ words add: 'super' ].
		(node class name = 'RBThisContextNode') ifTrue: [ words add: 'thisContext' ].
		((self isLiteralNode: node)
			and: [ #(nil true false) includes: node value ]) ifTrue: [
				words add: node value printString ] ].
	^ words asArray
]

{ #category : 'private' }
CodeAnalysisRunner class >> latexRowFor: aLabel counts: counts [
	| summary |
	summary := self statisticsForCounts: counts.
	^ String streamContents: [ :stream |
		stream
			nextPutAll: '\bfseries ';
			nextPutAll: aLabel;
			nextPutAll: ' & '.
		#(count min q25 median mean q75 max) doWithIndex: [ :key :index |
			index > 1 ifTrue: [ stream nextPutAll: ' & ' ].
			stream nextPutAll: (self formatStatistic: key value: (summary at: key)) ].
		stream nextPutAll: ' \\' ]
]

{ #category : 'private' }
CodeAnalysisRunner class >> latexRowForCountsLabel: aLabel values: aDictionary [
	^ String streamContents: [ :stream |
		stream
			nextPutAll: aLabel;
			nextPutAll: ' & ';
			nextPutAll: (self formatTableCount: (aDictionary at: #packages));
			nextPutAll: ' & ';
			nextPutAll: (self formatTableCount: (aDictionary at: #classes));
			nextPutAll: ' & ';
			nextPutAll: (self formatTableCount: (aDictionary at: #methods));
			nextPutAll: ' & ';
			nextPutAll: (self formatTableCount: (aDictionary at: #linesOfCode));
			nextPutAll: ' & ';
			nextPutAll: (self formatTableCount: (aDictionary at: #tokens));
			nextPutAll: ' \\' ]
]

{ #category : 'private' }
CodeAnalysisRunner class >> latexRowForIdentifierType: aLabel words: aCollectionOfWords totalWords: totalWords totalCharacters: totalCharacters [
	| count characterCount |
	count := aCollectionOfWords size.
	characterCount := self characterCountOfWords: aCollectionOfWords.

	^ String streamContents: [ :stream |
		stream
			nextPutAll: aLabel;
			nextPutAll: ' & ';
			nextPutAll: (self formatTableCount: count);
			nextPutAll: ' & ';
			nextPutAll: (self formatPercentage: count over: totalWords);
			nextPutAll: ' & ';
			nextPutAll: (self formatTableCount: characterCount);
			nextPutAll: ' & ';
			nextPutAll: (self formatPercentage: characterCount over: totalCharacters);
			nextPutAll: ' \\' ]
]

{ #category : 'private' }
CodeAnalysisRunner class >> latexRowForLiteralType: aLabel literals: aCollectionOfLiterals totalLiterals: totalLiterals totalCharacters: totalCharacters [
	| count characterCount |
	count := aCollectionOfLiterals size.
	characterCount := self characterCountsOfLiterals: aCollectionOfLiterals.

	^ String streamContents: [ :stream |
		stream
			nextPutAll: aLabel;
			nextPutAll: ' & ';
			nextPutAll: (self formatTableCount: count);
			nextPutAll: ' & ';
			nextPutAll: (self formatPercentage: count over: totalLiterals);
			nextPutAll: ' & ';
			nextPutAll: (self formatTableCount: characterCount);
			nextPutAll: ' & ';
			nextPutAll: (self formatPercentage: characterCount over: totalCharacters);
			nextPutAll: ' \\' ]
]

{ #category : 'private' }
CodeAnalysisRunner class >> latexRowForTypeTotalsLabel: aLabel values: aDictionary totalCount: totalCount totalCharacters: totalCharacters [
	| count characters |
	count := aDictionary at: #count.
	characters := aDictionary at: #characters.

	^ String streamContents: [ :stream |
		stream
			nextPutAll: aLabel;
			nextPutAll: ' & ';
			nextPutAll: (self formatTableCount: count);
			nextPutAll: ' & ';
			nextPutAll: (self formatPercentage: count over: totalCount);
			nextPutAll: ' & ';
			nextPutAll: (self formatTableCount: characters);
			nextPutAll: ' & ';
			nextPutAll: (self formatPercentage: characters over: totalCharacters);
			nextPutAll: ' \\' ]
]

{ #category : 'private' }
CodeAnalysisRunner class >> latexRowForWordCountLabel: aLabel pharo: pharoCounts pharoStar: pharoStarCounts brown: brownCounts gutenberg: gutenbergCounts selector: aSelector [
	^ String streamContents: [ :stream |
		stream
			nextPutAll: '\bfseries ';
			nextPutAll: aLabel;
			nextPutAll: ' & ';
			nextPutAll: (self formatTableCount: (pharoCounts at: aSelector));
			nextPutAll: ' & ';
			nextPutAll: (self formatTableCount: (pharoStarCounts at: aSelector));
			nextPutAll: ' & ';
			nextPutAll: (self formatTableCount: (brownCounts at: aSelector));
			nextPutAll: ' & ';
			nextPutAll: (self formatTableCount: (gutenbergCounts at: aSelector));
			nextPutAll: ' \\' ]
]

{ #category : 'private' }
CodeAnalysisRunner class >> latexRowForTestTableLabel: aLabel total: totalCount test: testCount nonTest: nonTestCount [
	^ String streamContents: [ :stream |
		stream
			nextPutAll: aLabel;
			nextPutAll: ' & ';
			nextPutAll: (self formatTableCount: totalCount);
			nextPutAll: ' & ';
			nextPutAll: (self formatTableCount: testCount);
			nextPutAll: ' & ';
			nextPutAll: (self formatTableCount: nonTestCount);
			nextPutAll: ' & ';
			nextPutAll: (self formatTablePercentage: testCount over: totalCount);
			nextPutAll: ' \\' ]
]

{ #category : 'running' }
CodeAnalysisRunner class >> latexTableForAllClassesPerPackage [
	| packages testPackages nonTestPackages |
	packages := self selectedPackages.
	testPackages := packages select: [ :each | self isTestPackage: each ].
	nonTestPackages := packages reject: [ :each | self isTestPackage: each ].

	^ String streamContents: [ :stream |
		stream nextPutAll: '\begin{tabular}{rr|rrrrrr}'; cr.
		stream nextPutAll: '\hline'; cr.
		stream nextPutAll: '& \bfseries count & \bfseries min & \bfseries 25\% & \bfseries median & \bfseries mean & \bfseries 75\% & \bfseries max \\' ; cr.
		stream nextPutAll: '\hline'; cr.
		stream nextPutAll: (self latexRowFor: 'All packages' counts: (self classCountsFor: packages)); cr.
		stream nextPutAll: (self latexRowFor: 'Test packages' counts: (self classCountsFor: testPackages)); cr.
		stream nextPutAll: (self latexRowFor: 'Non-test packages' counts: (self classCountsFor: nonTestPackages)); cr.
		stream nextPutAll: '\hline'; cr.
		stream nextPutAll: '\end{tabular}'
	]
]

{ #category : 'running' }
CodeAnalysisRunner class >> latexTableForAllLocPerNonDataMethod [
	| methods testMethods nonTestMethods |
	methods := self nonDataMethodsInSelectedPackages.
	testMethods := methods select: [ :each | self isTestMethod: each ].
	nonTestMethods := methods reject: [ :each | self isTestMethod: each ].

	^ String streamContents: [ :stream |
		stream nextPutAll: '\begin{tabular}{rr|rrrrrr}'; cr.
		stream nextPutAll: '\hline'; cr.
		stream nextPutAll: '& \bfseries count & \bfseries min & \bfseries 25\% & \bfseries median & \bfseries mean & \bfseries 75\% & \bfseries max \\' ; cr.
		stream nextPutAll: '\hline'; cr.
		stream nextPutAll: (self latexRowFor: 'All methods' counts: (self linesOfCodeForMethods: methods)); cr.
		stream nextPutAll: (self latexRowFor: 'Test methods' counts: (self linesOfCodeForMethods: testMethods)); cr.
		stream nextPutAll: (self latexRowFor: 'Non-test methods' counts: (self linesOfCodeForMethods: nonTestMethods)); cr.
		stream nextPutAll: '\hline'; cr.
		stream nextPutAll: '\end{tabular}'
	]
]

{ #category : 'running' }
CodeAnalysisRunner class >> latexTableForAllMethodsPerClass [
	| classes testClasses nonTestClasses |
	classes := self classesInSelectedPackages.
	testClasses := classes select: [ :each | self isTestClass: each ].
	nonTestClasses := classes reject: [ :each | self isTestClass: each ].

	^ String streamContents: [ :stream |
		stream nextPutAll: '\begin{tabular}{rr|rrrrrr}'; cr.
		stream nextPutAll: '\hline'; cr.
		stream nextPutAll: '& \bfseries count & \bfseries min & \bfseries 25\% & \bfseries median & \bfseries mean & \bfseries 75\% & \bfseries max \\' ; cr.
		stream nextPutAll: '\hline'; cr.
		stream nextPutAll: (self latexRowFor: 'All classes' counts: (self methodCountsForClasses: classes)); cr.
		stream nextPutAll: (self latexRowFor: 'Test classes' counts: (self methodCountsForClasses: testClasses)); cr.
		stream nextPutAll: (self latexRowFor: 'Non-test classes' counts: (self methodCountsForClasses: nonTestClasses)); cr.
		stream nextPutAll: '\hline'; cr.
		stream nextPutAll: '\end{tabular}'
	]
]

{ #category : 'running' }
CodeAnalysisRunner class >> latexTableForAllTokensPerMethod [
	| methods testMethods nonTestMethods |
	methods := self methodsInSelectedPackages.
	testMethods := methods select: [ :each | self isTestMethod: each ].
	nonTestMethods := methods reject: [ :each | self isTestMethod: each ].

	^ String streamContents: [ :stream |
		stream nextPutAll: '\begin{tabular}{rr|rrrrrr}'; cr.
		stream nextPutAll: '\hline'; cr.
		stream nextPutAll: '& \bfseries count & \bfseries min & \bfseries 25\% & \bfseries median & \bfseries mean & \bfseries 75\% & \bfseries max \\' ; cr.
		stream nextPutAll: '\hline'; cr.
		stream nextPutAll: (self latexRowFor: 'All methods' counts: (self tokenCountsForMethods: methods)); cr.
		stream nextPutAll: (self latexRowFor: 'Test methods' counts: (self tokenCountsForMethods: testMethods)); cr.
		stream nextPutAll: (self latexRowFor: 'Non-test methods' counts: (self tokenCountsForMethods: nonTestMethods)); cr.
		stream nextPutAll: '\hline'; cr.
		stream nextPutAll: '\end{tabular}'
	]
]

{ #category : 'running' }
CodeAnalysisRunner class >> latexTableForCounts [
	| counts |
	counts := self countsForSelectedPackages.

	^ String streamContents: [ :stream |
		stream nextPutAll: '\begin{tabular}{lrrrrr}'; cr.
		stream nextPutAll: '\hline'; cr.
		stream nextPutAll: '\bfseries Project & \bfseries Packages & \bfseries Classes & \bfseries Methods & \bfseries Lines of Code & \bfseries Tokens \\' ; cr.
		stream nextPutAll: '\hline'; cr.
		stream nextPutAll: (self latexRowForCountsLabel: self selectedPackagesLabel values: counts); cr.
		stream nextPutAll: '\hline'; cr.
		stream nextPutAll: (self latexRowForCountsLabel: 'Total' values: counts); cr.
		stream nextPutAll: '\hline'; cr.
		stream nextPutAll: '\end{tabular}'
	]
]

{ #category : 'running' }
CodeAnalysisRunner class >> latexTableForPharoIdentifierNamesDistribution [
	| entries totalWords totalCharacters |
	entries := self pharoIdentifierNameEntries.
	totalWords := self allIdentifierNameWordsInSelectedPackages size.
	totalCharacters := self characterCountOfWords: self allIdentifierNameWordsInSelectedPackages.

	^ String streamContents: [ :stream |
		stream nextPutAll: '\begin{tabular}{lrrrr}'; cr.
		stream nextPutAll: '\hline'; cr.
		stream nextPutAll: '\bfseries Type & \bfseries \# & \bfseries \% & \bfseries characters & \bfseries \% \\' ; cr.
		stream nextPutAll: '\hline'; cr.
		entries do: [ :each |
			stream
				nextPutAll: (self
					latexRowForIdentifierType: each key
					words: each value
					totalWords: totalWords
					totalCharacters: totalCharacters);
				cr ].
		stream nextPutAll: '\hline'; cr.
		stream
			nextPutAll: (self
				latexTotalRowForIdentifierEntries: entries
				totalWords: totalWords
				totalCharacters: totalCharacters);
			cr.
		stream nextPutAll: '\hline'; cr.
		stream nextPutAll: '\end{tabular}'
	]
]

{ #category : 'running' }
CodeAnalysisRunner class >> latexTableForPharoLiteralDistribution [
	| entries totalLiterals totalCharacters |
	entries := self pharoLiteralEntries.
	totalLiterals := self allLiteralsInSelectedPackages size.
	totalCharacters := self characterCountsOfLiterals: self allLiteralsInSelectedPackages.

	^ String streamContents: [ :stream |
		stream nextPutAll: '\begin{tabular}{lrrrr}'; cr.
		stream nextPutAll: '\hline'; cr.
		stream nextPutAll: '\bfseries Type & \bfseries \# & \bfseries \% & \bfseries characters & \bfseries \% \\' ; cr.
		stream nextPutAll: '\hline'; cr.
		entries do: [ :each |
			stream
				nextPutAll: (self
					latexRowForLiteralType: each key
					literals: each value
					totalLiterals: totalLiterals
					totalCharacters: totalCharacters);
				cr ].
		stream nextPutAll: '\hline'; cr.
		stream
			nextPutAll: (self
				latexTotalRowForLiteralEntries: entries
				totalLiterals: totalLiterals
				totalCharacters: totalCharacters);
			cr.
		stream nextPutAll: '\hline'; cr.
		stream nextPutAll: '\end{tabular}'
	]
]

{ #category : 'running' }
CodeAnalysisRunner class >> latexTableForPharoTokenTypeDistribution [
	| entries totalCount totalCharacters |
	entries := self pharoTokenTypeEntries.
	totalCount := self sum: (entries collect: [ :each | each value at: #count ]).
	totalCharacters := self sum: (entries collect: [ :each | each value at: #characters ]).

	^ String streamContents: [ :stream |
		stream nextPutAll: '\begin{tabular}{lrrrr}'; cr.
		stream nextPutAll: '\hline'; cr.
		stream nextPutAll: '\bfseries Type & \bfseries \# & \bfseries \% & \bfseries characters & \bfseries \% \\' ; cr.
		stream nextPutAll: '\hline'; cr.
		entries do: [ :each |
			stream
				nextPutAll: (self
					latexRowForTypeTotalsLabel: each key
					values: each value
					totalCount: totalCount
					totalCharacters: totalCharacters);
				cr ].
		stream nextPutAll: '\hline'; cr.
		stream
			nextPutAll: (self
				latexRowForTypeTotalsLabel: 'Total'
				values: (Dictionary newFrom: {
					#count -> totalCount.
					#characters -> totalCharacters })
				totalCount: totalCount
				totalCharacters: totalCharacters);
			cr.
		stream nextPutAll: '\hline'; cr.
		stream nextPutAll: '\end{tabular}'
	]
]

{ #category : 'running' }
CodeAnalysisRunner class >> latexTableForWordCounts [
	| pharoCounts pharoStarCounts brownCounts gutenbergCounts |
	pharoCounts := self wordStatisticsFor: self allIdentifierNameWordsInSelectedPackages.
	pharoStarCounts := self wordStatisticsFor: self allSourceWordsInSelectedPackages.
	brownCounts := self wordStatisticsFor: self brownCorpusWords.
	gutenbergCounts := self wordStatisticsFor: self gutenbergCorpusWords.

	^ String streamContents: [ :stream |
		stream nextPutAll: '\begin{tabular}{lrrrr}'; cr.
		stream nextPutAll: '\hline'; cr.
		stream nextPutAll: '& \bfseries Pharo & \bfseries Pharo* & \bfseries Brown & \bfseries Gutenberg \\' ; cr.
		stream nextPutAll: '\hline'; cr.
		stream nextPutAll: (self latexRowForWordCountLabel: 'Words' pharo: pharoCounts pharoStar: pharoStarCounts brown: brownCounts gutenberg: gutenbergCounts selector: #words); cr.
		stream nextPutAll: (self latexRowForWordCountLabel: 'Unique words' pharo: pharoCounts pharoStar: pharoStarCounts brown: brownCounts gutenberg: gutenbergCounts selector: #uniqueWords); cr.
		stream nextPutAll: (self latexRowForWordCountLabel: 'Unique stems' pharo: pharoCounts pharoStar: pharoStarCounts brown: brownCounts gutenberg: gutenbergCounts selector: #uniqueStems); cr.
		stream nextPutAll: '\hline'; cr.
		stream nextPutAll: (self latexRowForWordCountLabel: 'English words' pharo: pharoCounts pharoStar: pharoStarCounts brown: brownCounts gutenberg: gutenbergCounts selector: #englishWords); cr.
		stream nextPutAll: (self latexRowForWordCountLabel: 'Unique English words' pharo: pharoCounts pharoStar: pharoStarCounts brown: brownCounts gutenberg: gutenbergCounts selector: #uniqueEnglishWords); cr.
		stream nextPutAll: (self latexRowForWordCountLabel: 'Unique English stems' pharo: pharoCounts pharoStar: pharoStarCounts brown: brownCounts gutenberg: gutenbergCounts selector: #uniqueEnglishStems); cr.
		stream nextPutAll: '\hline'; cr.
		stream nextPutAll: '\end{tabular}'
	]
]

{ #category : 'private' }
CodeAnalysisRunner class >> latexTableForTestTable [
	| counts |
	counts := self testTableCountsForSelectedPackages.

	^ String streamContents: [ :stream |
		stream nextPutAll: '\begin{tabular}{lrrrr}'; cr.
		stream nextPutAll: '\hline'; cr.
		stream nextPutAll: 'Entity & \bfseries Total & \bfseries Test & \bfseries Non-test & \bfseries Test \%' ; cr.
		stream nextPutAll: '\hline'; cr.
		stream nextPutAll: (self latexRowForTestTableLabel: 'Packages' total: (counts at: #packageTotal) test: (counts at: #packageTest) nonTest: (counts at: #packageNonTest)); cr.
		stream nextPutAll: (self latexRowForTestTableLabel: 'Classes' total: (counts at: #classTotal) test: (counts at: #classTest) nonTest: (counts at: #classNonTest)); cr.
		stream nextPutAll: (self latexRowForTestTableLabel: 'Methods' total: (counts at: #methodTotal) test: (counts at: #methodTest) nonTest: (counts at: #methodNonTest)); cr.
		stream nextPutAll: (self latexRowForTestTableLabel: 'LOC' total: (counts at: #locTotal) test: (counts at: #locTest) nonTest: (counts at: #locNonTest)); cr.
		stream nextPutAll: (self latexRowForTestTableLabel: 'Tokens' total: (counts at: #tokenTotal) test: (counts at: #tokenTest) nonTest: (counts at: #tokenNonTest)); cr.
		stream nextPutAll: '\hline'; cr.
		stream nextPutAll: '\end{tabular}'
	]
]

{ #category : 'private' }
CodeAnalysisRunner class >> sizeDistributionPlotCsv [
	^ self sizeDistributionPlotCsvFromRows: self sizeDistributionPlotRows
]

{ #category : 'private' }
CodeAnalysisRunner class >> sizeDistributionPlotCsvFromRows: rows [
	^ String streamContents: [ :stream |
		stream
			nextPutAll: (self csvLineFrom: #('level' 'metric' 'size'));
			cr.
		rows do: [ :row |
			stream
				nextPutAll: (self csvLineFrom: {
					row at: 'level'.
					row at: 'metric'.
					row at: 'size' });
				cr ] ]
]

{ #category : 'private' }
CodeAnalysisRunner class >> sizeDistributionPlotRows [
	^ self
		sizeDistributionPlotRowsForPackages: self selectedPackages
		classes: self classesInSelectedPackages
		methods: self methodsInSelectedPackages
]

{ #category : 'private' }
CodeAnalysisRunner class >> sizeDistributionPlotRowsForPackages: packages classes: classes methods: methods [
	| rows |
	rows := OrderedCollection new.

	(self classCountsFor: packages) do: [ :each |
		rows add: (Dictionary newFrom: {
			'level' -> 'package'.
			'metric' -> 'classes_per_package'.
			'size' -> each }) ].

	(self methodCountsForClasses: classes) do: [ :each |
		rows add: (Dictionary newFrom: {
			'level' -> 'class'.
			'metric' -> 'methods_per_class'.
			'size' -> each }) ].

	(self tokenCountsForMethods: methods) do: [ :each |
		rows add: (Dictionary newFrom: {
			'level' -> 'method'.
			'metric' -> 'tokens_per_method'.
			'size' -> each }) ].

	^ rows asArray
]

{ #category : 'private' }
CodeAnalysisRunner class >> latexTotalRowForIdentifierEntries: entries totalWords: totalWords totalCharacters: totalCharacters [
	| entryWords |
	entryWords := entries flatCollect: [ :each | each value ].
	^ self
		latexRowForIdentifierType: 'Total'
		words: entryWords
		totalWords: totalWords
		totalCharacters: totalCharacters
]

{ #category : 'private' }
CodeAnalysisRunner class >> latexTotalRowForLiteralEntries: entries totalLiterals: totalLiterals totalCharacters: totalCharacters [
	| literals |
	literals := entries flatCollect: [ :each | each value ].
	^ self
		latexRowForLiteralType: 'Total'
		literals: literals
		totalLiterals: totalLiterals
		totalCharacters: totalCharacters
]

{ #category : 'private' }
CodeAnalysisRunner class >> linesOfCodeForMethods: aCollectionOfMethods [
	^ aCollectionOfMethods collect: [ :each | each linesOfCode ]
]

{ #category : 'private' }
CodeAnalysisRunner class >> literalCharacterCount: anAssociation [
	| type value |
	type := anAssociation key.
	value := anAssociation value.
	type = 'Characters' ifTrue: [ ^ 1 ].
	type = 'Strings' ifTrue: [ ^ value size ].
	type = 'Symbols' ifTrue: [ ^ value asString size ].
	type = 'Numbers' ifTrue: [ ^ value asString size ].
	type = 'Literal arrays' ifTrue: [ ^ value fullPrintString size ].
	^ value asString size
]

{ #category : 'private' }
CodeAnalysisRunner class >> literalEntriesOfMethod: aCompiledMethod [
	| parseTree literals |
	parseTree := aCompiledMethod codeAnalysisParseTree.
	(parseTree respondsTo: #nodesDo:) ifFalse: [ ^ #() ].

	literals := OrderedCollection new.
	parseTree nodesDo: [ :node |
		(self isLiteralArrayNode: node) ifTrue: [
			literals add: ('Literal arrays' -> node value) ].
		(self isLiteralNode: node) ifTrue: [
			(self literalTypeFor: node value)
				ifNotNil: [ :type | literals add: (type -> node value) ] ] ].
	^ literals asArray
]

{ #category : 'private' }
CodeAnalysisRunner class >> literalTypeFor: anObject [
	anObject isNumber ifTrue: [ ^ 'Numbers' ].
	anObject isString ifTrue: [ ^ 'Strings' ].
	anObject isSymbol ifTrue: [ ^ 'Symbols' ].
	anObject isCharacter ifTrue: [ ^ 'Characters' ].
	^ nil
]

{ #category : 'accessing' }
CodeAnalysisRunner class >> locPerNonDataMethodTexFileName [
	^ 'all_loc_per_non_data_method.tex'
]

{ #category : 'private' }
CodeAnalysisRunner class >> methodArgumentWordsOfMethod: aCompiledMethod [
	| parseTree argumentNames |
	parseTree := aCompiledMethod codeAnalysisParseTree.
	(parseTree respondsTo: #arguments) ifFalse: [ ^ #() ].
	argumentNames := parseTree arguments collect: [ :each | each name ].
	^ self identifierWordsFromNames: argumentNames
]

{ #category : 'private' }
CodeAnalysisRunner class >> methodCountOfClass: aClass [
	^ aClass methods size
]

{ #category : 'private' }
CodeAnalysisRunner class >> methodCountsForClasses: aCollectionOfClasses [
	^ aCollectionOfClasses collect: [ :each | self methodCountOfClass: each ]
]

{ #category : 'private' }
CodeAnalysisRunner class >> methodNameWordsInSelectedPackages [
	^ self methodsInSelectedPackages flatCollect: [ :each |
		self identifierWordsFromName: each selector asString ]
]

{ #category : 'private' }
CodeAnalysisRunner class >> methodTemporaryWordsOfMethod: aCompiledMethod [
	| parseTree temporaryNames |
	parseTree := aCompiledMethod codeAnalysisParseTree.
	(parseTree respondsTo: #temporaries) ifFalse: [ ^ #() ].
	temporaryNames := parseTree temporaries collect: [ :each | each name ].
	^ self identifierWordsFromNames: temporaryNames
]

{ #category : 'private' }
CodeAnalysisRunner class >> methodsInSelectedPackages [
	^ self selectedPackages flatCollect: [ :each | each methods ]
]

{ #category : 'accessing' }
CodeAnalysisRunner class >> methodsPerClassTexFileName [
	^ 'all_methods_per_class.tex'
]

{ #category : 'private' }
CodeAnalysisRunner class >> nonDataMethodsInSelectedPackages [
	^ self methodsInSelectedPackages reject: [ :each | self isDataMethod: each ]
]

{ #category : 'accessing' }
CodeAnalysisRunner class >> outputDirectory [
	^ outputDirectory ifNil: [ self imageWorkingDirectory ]
]

{ #category : 'accessing' }
CodeAnalysisRunner class >> outputDirectory: aFileReference [
	outputDirectory := aFileReference asFileReference
]

{ #category : 'private' }
CodeAnalysisRunner class >> outputFileFor: aFileName [
	^ self outputDirectory asFileReference / aFileName
]

{ #category : 'private' }
CodeAnalysisRunner class >> packageNamed: aString [
	^ Smalltalk image packages
		detect: [ :each | each name = aString ]
		ifNone: [ self error: 'Unknown package: ', aString ]
]

{ #category : 'accessing' }
CodeAnalysisRunner class >> packageNames [
	^ packageNames ifNil: [ #() ]
]

{ #category : 'accessing' }
CodeAnalysisRunner class >> packageNames: aCollection [
	packageNames := aCollection asArray
]

{ #category : 'private' }
CodeAnalysisRunner class >> percentile: aFraction ofSorted: aSortedCollection [
	| index lowerIndex upperIndex lowerValue upperValue weight |
	aSortedCollection isEmpty ifTrue: [ ^ 0 ].
	aSortedCollection size = 1 ifTrue: [ ^ aSortedCollection first ].

	index := (aSortedCollection size - 1) * aFraction + 1.
	lowerIndex := index floor.
	upperIndex := index ceiling.
	lowerValue := aSortedCollection at: lowerIndex.
	upperValue := aSortedCollection at: upperIndex.
	weight := index - lowerIndex.

	^ lowerValue + ((upperValue - lowerValue) * weight)
]

{ #category : 'private' }
CodeAnalysisRunner class >> pharoIdentifierNameEntries [
	^ OrderedCollection new
		add: 'Method names' -> self methodNameWordsInSelectedPackages;
		add: 'Temporary variable names' -> self temporaryVariableWordsInSelectedPackages;
		add: 'Argument names' -> self argumentWordsInSelectedPackages;
		add: 'Instance variable names' -> self instanceVariableWordsInSelectedPackages;
		add: 'Class names' -> self classNameWordsInSelectedPackages;
		add: 'Class variable names' -> self classVariableWordsInSelectedPackages;
		add: 'Global variable names' -> self globalVariableWordsInSelectedPackages;
		yourself
]

{ #category : 'running' }
CodeAnalysisRunner class >> pharoIdentifierNamesDistribution [
	^ self
		saveReportNamed: self pharoIdentifierNamesDistributionTexFileName
		generatedBy: [ self latexTableForPharoIdentifierNamesDistribution ]
]

{ #category : 'accessing' }
CodeAnalysisRunner class >> pharoIdentifierNamesDistributionTexFileName [
	^ 'pharo_identifier_names_distribution.tex'
]

{ #category : 'running' }
CodeAnalysisRunner class >> pharoLiteralDistribution [
	^ self
		saveReportNamed: self pharoLiteralDistributionTexFileName
		generatedBy: [ self latexTableForPharoLiteralDistribution ]
]

{ #category : 'accessing' }
CodeAnalysisRunner class >> pharoLiteralDistributionTexFileName [
	^ 'pharo_literal_distribution.tex'
]

{ #category : 'private' }
CodeAnalysisRunner class >> pharoLiteralEntries [
	| literals |
	literals := self allLiteralsInSelectedPackages.
	^ OrderedCollection new
		add: 'Numbers' -> (literals select: [ :each | each key = 'Numbers' ]);
		add: 'Strings' -> (literals select: [ :each | each key = 'Strings' ]);
		add: 'Symbols' -> (literals select: [ :each | each key = 'Symbols' ]);
		add: 'Literal arrays' -> (literals select: [ :each | each key = 'Literal arrays' ]);
		add: 'Characters' -> (literals select: [ :each | each key = 'Characters' ]);
		yourself
]

{ #category : 'running' }
CodeAnalysisRunner class >> pharoTokenTypeDistribution [
	^ self
		saveReportNamed: self pharoTokenTypeDistributionTexFileName
		generatedBy: [ self latexTableForPharoTokenTypeDistribution ]
]

{ #category : 'accessing' }
CodeAnalysisRunner class >> pharoTokenTypeDistributionTexFileName [
	^ 'pharo_token_type_distribution.tex'
]

{ #category : 'private' }
CodeAnalysisRunner class >> pharoTokenTypeEntries [
	| identifiers literals keywords delimiters |
	identifiers := self allIdentifierNameWordsInSelectedPackages.
	literals := self allLiteralsInSelectedPackages.
	keywords := self keywordTokensInSelectedPackages.
	delimiters := self delimiterTokensInSelectedPackages.

	^ OrderedCollection new
		add: 'Keywords' -> (Dictionary newFrom: {
			#count -> keywords size.
			#characters -> (self characterCountOfWords: keywords) });
		add: 'Identifiers' -> (Dictionary newFrom: {
			#count -> identifiers size.
			#characters -> (self characterCountOfWords: identifiers) });
		add: 'Literals' -> (Dictionary newFrom: {
			#count -> literals size.
			#characters -> (self characterCountsOfLiterals: literals) });
		add: 'Delimiters' -> (Dictionary newFrom: {
			#count -> delimiters size.
			#characters -> (self characterCountOfWords: delimiters) });
		yourself
]

{ #category : 'running' }
CodeAnalysisRunner class >> saveDefaultPackagesAnalysisToTex [
	^ self allClassesPerPackage
]

{ #category : 'private' }
CodeAnalysisRunner class >> saveReportNamed: aFileName generatedBy: aBlock [
	| contents |
	contents := [ aBlock value ]
		on: Error
		do: [ :ex | self textReportForError: ex ].
	self write: contents to: aFileName.
	^ contents
]

{ #category : 'private' }
CodeAnalysisRunner class >> selectedPackagesLabel [
	^ self packageNames
		ifEmpty: [ 'All image packages' ]
		ifNotEmpty: [ 'Selected packages' ]
]

{ #category : 'private' }
CodeAnalysisRunner class >> selectedPackageNames [
	^ self packageNames ifEmpty: [ self defaultPackages ]
]

{ #category : 'private' }
CodeAnalysisRunner class >> selectedPackages [
	| configuredPackageNames |
	configuredPackageNames := self selectedPackageNames.
	configuredPackageNames ifEmpty: [ self error: 'No package names configured' ].
	^ configuredPackageNames collect: [ :each | self packageNamed: each ]
]

{ #category : 'private' }
CodeAnalysisRunner class >> selectorWordsFromSelector: aString [
	^ (aString splitIdentifierName
		select: [ :each | each isAllLetters ])
		collect: [ :each | each asLowercase ]
]

{ #category : 'private' }
CodeAnalysisRunner class >> sorted: aCollection [
	^ aCollection asSortedCollection asArray
]

{ #category : 'private' }
CodeAnalysisRunner class >> statisticsForCounts: counts [
	| sorted sum |
	counts ifEmpty: [
		^ Dictionary newFrom: {
			#count -> 0.
			#min -> 0.
			#q25 -> 0.
			#median -> 0.
			#mean -> 0.
			#q75 -> 0.
			#max -> 0 } ].

	sorted := self sorted: counts.
	sum := counts inject: 0 into: [ :total :each | total + each ].

	^ Dictionary newFrom: {
		#count -> counts size.
		#min -> sorted first.
		#q25 -> (self percentile: 0.25 ofSorted: sorted).
		#median -> (self percentile: 0.5 ofSorted: sorted).
		#mean -> (sum / counts size asFloat).
		#q75 -> (self percentile: 0.75 ofSorted: sorted).
		#max -> sorted last }
]

{ #category : 'running' }
CodeAnalysisRunner class >> testtable [
	^ self
		saveReportNamed: self testTableTexFileName
		generatedBy: [ self latexTableForTestTable ]
]

{ #category : 'private' }
CodeAnalysisRunner class >> testTableCountsForSelectedPackages [
	| packages classes methods testPackages testClasses testMethods nonTestMethods |
	packages := self selectedPackages.
	classes := self classesInSelectedPackages.
	methods := self methodsInSelectedPackages.
	testPackages := packages select: [ :each | self isTestPackage: each ].
	testClasses := classes select: [ :each | self isTestClass: each ].
	testMethods := methods select: [ :each | self isTestMethod: each ].
	nonTestMethods := methods reject: [ :each | self isTestMethod: each ].

	^ Dictionary newFrom: {
		#packageTotal -> packages size.
		#packageTest -> testPackages size.
		#packageNonTest -> packages size - testPackages size.
		#classTotal -> classes size.
		#classTest -> testClasses size.
		#classNonTest -> classes size - testClasses size.
		#methodTotal -> methods size.
		#methodTest -> testMethods size.
		#methodNonTest -> nonTestMethods size.
		#locTotal -> (self sum: (self linesOfCodeForMethods: methods)).
		#locTest -> (self sum: (self linesOfCodeForMethods: testMethods)).
		#locNonTest -> (self sum: (self linesOfCodeForMethods: nonTestMethods)).
		#tokenTotal -> (self sum: (self tokenCountsForMethods: methods)).
		#tokenTest -> (self sum: (self tokenCountsForMethods: testMethods)).
		#tokenNonTest -> (self sum: (self tokenCountsForMethods: nonTestMethods)) }
]

{ #category : 'accessing' }
CodeAnalysisRunner class >> testTableTexFileName [
	^ 'test_table.tex'
]

{ #category : 'private' }
CodeAnalysisRunner class >> stemFor: aString [
	| porter stemmer |
	porter := self globalNamedAnyOf: #('PorterStemmer' 'SnowballStemmer' 'EnglishStemmer').
	porter ifNotNil: [
		(porter respondsTo: #stem:) ifTrue: [ ^ (porter stem: aString) asLowercase ].
		(porter respondsTo: #new) ifTrue: [
			stemmer := porter new.
			(stemmer respondsTo: #stem:) ifTrue: [ ^ (stemmer stem: aString) asLowercase ] ] ].
	^ aString asLowercase
]

{ #category : 'private' }
CodeAnalysisRunner class >> stemsOf: aCollectionOfWords [
	^ aCollectionOfWords collect: [ :each | self stemFor: each ]
]

{ #category : 'private' }
CodeAnalysisRunner class >> sum: aCollectionOfNumbers [
	^ aCollectionOfNumbers
		inject: 0
		into: [ :total :each | total + each ]
]

{ #category : 'private' }
CodeAnalysisRunner class >> temporaryVariableWordsInSelectedPackages [
	^ self methodsInSelectedPackages flatCollect: [ :each |
		self methodTemporaryWordsOfMethod: each ]
]

{ #category : 'private' }
CodeAnalysisRunner class >> textReportForError: anError [
	^ String streamContents: [ :stream |
		stream
			nextPutAll: 'Error generating report';
			cr;
			nextPutAll: anError class name;
			nextPutAll: ': ';
			nextPutAll: anError description ]
]

{ #category : 'private' }
CodeAnalysisRunner class >> tokenCharacterCountOfMethod: aCompiledMethod [
	^ self characterCountOfWords: aCompiledMethod tokens
]

{ #category : 'private' }
CodeAnalysisRunner class >> tokenCountOfMethod: aCompiledMethod [
	^ aCompiledMethod tokens size
]

{ #category : 'private' }
CodeAnalysisRunner class >> tokenCountsForMethods: aCollectionOfMethods [
	^ aCollectionOfMethods collect: [ :each | self tokenCountOfMethod: each ]
]

{ #category : 'accessing' }
CodeAnalysisRunner class >> tokensPerMethodTexFileName [
	^ 'all_tokens_per_method.tex'
]

{ #category : 'accessing' }
CodeAnalysisRunner class >> wordCountsTexFileName [
	^ 'word_counts.tex'
]

{ #category : 'private' }
CodeAnalysisRunner class >> wordStatisticsFor: aCollectionOfWords [
	| words englishWords uniqueWords uniqueEnglishWords uniqueStems uniqueEnglishStems |
	words := self allWordsInCorpus: aCollectionOfWords.
	englishWords := self englishWordsFrom: words.
	uniqueWords := words asSet.
	uniqueEnglishWords := englishWords asSet.
	uniqueStems := (self stemsOf: uniqueWords) asSet.
	uniqueEnglishStems := (self stemsOf: uniqueEnglishWords) asSet.

	^ Dictionary newFrom: {
		#words -> words size.
		#uniqueWords -> uniqueWords size.
		#uniqueStems -> uniqueStems size.
		#englishWords -> englishWords size.
		#uniqueEnglishWords -> uniqueEnglishWords size.
		#uniqueEnglishStems -> uniqueEnglishStems size }
]

{ #category : 'running' }
CodeAnalysisRunner class >> wordcounts [
	^ self
		saveReportNamed: self wordCountsTexFileName
		generatedBy: [ self latexTableForWordCounts ]
]

{ #category : 'private' }
CodeAnalysisRunner class >> wordsFromCorpusProvider: anObject [
	| selectors |
	anObject ifNil: [ ^ #() ].
	(anObject respondsTo: #words) ifTrue: [ ^ anObject words ].
	(anObject respondsTo: #allWords) ifTrue: [ ^ anObject allWords ].
	(anObject respondsTo: #tokens) ifTrue: [ ^ anObject tokens ].
	(anObject respondsTo: #corpus) ifTrue: [ ^ self wordsFromCorpusProvider: anObject corpus ].
	(anObject respondsTo: #new) ifTrue: [ ^ self wordsFromCorpusProvider: anObject new ].
	selectors := #(documents sentences paragraphs entries items contents data texts strings values).
	selectors
		detect: [ :each | anObject respondsTo: each ]
		ifFound: [ :each | ^ anObject perform: each ]
		ifNone: [ ^ anObject ]
]

{ #category : 'private' }
CodeAnalysisRunner class >> wordsFromCorpusProviderNamedAnyOf: aCollectionOfNames [
	| provider words |
	provider := self globalNamedAnyOf: aCollectionOfNames.
	provider ifNil: [ ^ #() ].
	words := self wordsFromCorpusProvider: provider.
	^ self allWordsInCorpus: (words ifNil: [ #() ] ifNotNil: [ words ])
]

{ #category : 'private' }
CodeAnalysisRunner class >> wordsFromCorpusValue: anObject [
	| providerValue |
	anObject ifNil: [ ^ #() ].
	((anObject isString) or: [ anObject isSymbol ]) ifTrue: [
		^ { anObject asString asLowercase } ].
	(anObject isCharacter or: [ anObject isNumber ]) ifTrue: [ ^ #() ].
	(anObject isCollection and: [ anObject isString not ]) ifTrue: [
		^ anObject flatCollect: [ :each | self wordsFromCorpusValue: each ] ].
	providerValue := self wordsFromCorpusProvider: anObject.
	providerValue == anObject ifTrue: [ ^ #() ].
	^ self wordsFromCorpusValue: providerValue
]

{ #category : 'saving' }
CodeAnalysisRunner class >> write: aString to: aFileName [
	| directory file |
	directory := self outputDirectory asFileReference.
	directory ensureCreateDirectory.
	file := self outputFileFor: aFileName.
	file exists ifTrue: [ file delete ].
	file writeStreamDo: [ :stream | stream nextPutAll: aString ]
]
