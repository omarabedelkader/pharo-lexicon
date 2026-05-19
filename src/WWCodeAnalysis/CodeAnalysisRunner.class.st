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
	| table |
	table := self latexTableForAllClassesPerPackage.
	self write: table to: self classesPerPackageTexFileName.
	^ table
]

{ #category : 'running' }
CodeAnalysisRunner class >> allclassesperpackage [
	^ self allClassesPerPackage
]

{ #category : 'running' }
CodeAnalysisRunner class >> allLocPerNonDataMethod [
	| table |
	table := self latexTableForAllLocPerNonDataMethod.
	self write: table to: self locPerNonDataMethodTexFileName.
	^ table
]

{ #category : 'running' }
CodeAnalysisRunner class >> alllocpernondatamethod [
	^ self allLocPerNonDataMethod
]

{ #category : 'running' }
CodeAnalysisRunner class >> allMethodsPerClass [
	| table |
	table := self latexTableForAllMethodsPerClass.
	self write: table to: self methodsPerClassTexFileName.
	^ table
]

{ #category : 'running' }
CodeAnalysisRunner class >> allmethodsperclass [
	^ self allMethodsPerClass
]

{ #category : 'running' }
CodeAnalysisRunner class >> allTokensPerMethod [
	| table |
	table := self latexTableForAllTokensPerMethod.
	self write: table to: self tokensPerMethodTexFileName.
	^ table
]

{ #category : 'running' }
CodeAnalysisRunner class >> alltokenspermethod [
	^ self allTokensPerMethod
]

{ #category : 'running' }
CodeAnalysisRunner class >> allClassesPerPackageForPackagesNamed: aCollection [
	self defaultPackages: aCollection.
	^ self allClassesPerPackage
]

{ #category : 'running' }
CodeAnalysisRunner class >> counts [
	| table |
	table := self latexTableForCounts.
	self write: table to: self countsTexFileName.
	^ table
]

{ #category : 'running' }
CodeAnalysisRunner class >> pharoIdentifierNamesDistribution [
	| table |
	table := self latexTableForPharoIdentifierNamesDistribution.
	self write: table to: self pharoIdentifierNamesDistributionTexFileName.
	^ table
]

{ #category : 'running' }
CodeAnalysisRunner class >> pharoLiteralDistribution [
	| table |
	table := self latexTableForPharoLiteralDistribution.
	self write: table to: self pharoLiteralDistributionTexFileName.
	^ table
]

{ #category : 'running' }
CodeAnalysisRunner class >> pharoTokenTypeDistribution [
	| table |
	table := self latexTableForPharoTokenTypeDistribution.
	self write: table to: self pharoTokenTypeDistributionTexFileName.
	^ table
]

{ #category : 'running' }
CodeAnalysisRunner class >> wordcounts [
	| table |
	table := self latexTableForWordCounts.
	self write: table to: self wordCountsTexFileName.
	^ table
]

{ #category : 'private' }
CodeAnalysisRunner class >> classCountsFor: aCollectionOfPackages [
	^ aCollectionOfPackages collect: [ :each | self classCountOf: each ]
]

{ #category : 'private' }
CodeAnalysisRunner class >> classCountOf: aPackage [
	(aPackage respondsTo: #definedClasses) ifTrue: [ ^ aPackage definedClasses size ].
	(aPackage respondsTo: #classes) ifTrue: [ ^ aPackage classes size ].
	self error: 'Unsupported package object: ', aPackage class name
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
CodeAnalysisRunner class >> classesPerPackageTexFileName [
	^ 'all_classes_per_package.tex'
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
CodeAnalysisRunner class >> delimiterTokensInSelectedPackages [
	^ self methodsInSelectedPackages flatCollect: [ :each |
		self delimiterTokensOfMethod: each ]
]

{ #category : 'private' }
CodeAnalysisRunner class >> englishWordsFrom: aCollectionOfWords [
	| dictionary |
	dictionary := self englishWordSet.
	dictionary ifNil: [ ^ aCollectionOfWords ].
	^ aCollectionOfWords select: [ :each | dictionary includes: each asLowercase ]
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

{ #category : 'accessing' }
CodeAnalysisRunner class >> countsTexFileName [
	^ 'counts.tex'
]

{ #category : 'private' }
CodeAnalysisRunner class >> characterCountOfWords: aCollectionOfWords [
	^ self sum: (aCollectionOfWords collect: [ :each | each size ])
]

{ #category : 'private' }
CodeAnalysisRunner class >> characterCountsOfLiterals: aCollectionOfLiterals [
	^ self sum: (aCollectionOfLiterals collect: [ :each | self literalCharacterCount: each ])
]

{ #category : 'accessing' }
CodeAnalysisRunner class >> defaultPackages [
	"Define the package names to analyze here, for example:
	#('Kernel' 'Collections-Sequenceable')"
	^ #()
]

{ #category : 'accessing' }
CodeAnalysisRunner class >> defaultpackages [
	^ self defaultPackages
]

{ #category : 'accessing' }
CodeAnalysisRunner class >> defaultPackages: aCollection [
	self packageNames: aCollection
]

{ #category : 'accessing' }
CodeAnalysisRunner class >> defaultpackages: aCollection [
	^ self defaultPackages: aCollection
]

{ #category : 'private' }
CodeAnalysisRunner class >> formatMean: aNumber [
	| rounded |
	rounded := ((aNumber asFloat * 10) rounded / 10.0).
	^ rounded printString
]

{ #category : 'private' }
CodeAnalysisRunner class >> formatStatistic: aKey value: aValue [
	aKey = #mean ifTrue: [ ^ self formatMean: aValue ].
	^ aValue asInteger printString
]

{ #category : 'private' }
CodeAnalysisRunner class >> formatPercentage: aNumerator over: aDenominator [
	aDenominator = 0 ifTrue: [ ^ '0' ].
	^ self formatMean: ((aNumerator asFloat / aDenominator asFloat) * 100)
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
CodeAnalysisRunner class >> isTestPackage: aPackage [
	^ (aPackage name asLowercase includesSubstring: 'test')
]

{ #category : 'private' }
CodeAnalysisRunner class >> isGlobalVariableNode: aNode [
	((aNode respondsTo: #isGlobalVariable) and: [ aNode isGlobalVariable ]) ifTrue: [ ^ true ].
	((aNode respondsTo: #isGlobal) and: [ aNode isGlobal ]) ifTrue: [ ^ true ].
	^ false
]

{ #category : 'private' }
CodeAnalysisRunner class >> isLiteralArrayNode: aNode [
	^ aNode class name = 'RBLiteralArrayNode'
]

{ #category : 'private' }
CodeAnalysisRunner class >> isDelimiterToken: aString [
	aString isEmpty ifTrue: [ ^ false ].
	^ aString allSatisfy: [ :each | each isLetter not and: [ each isDigit not ] ]
]

{ #category : 'private' }
CodeAnalysisRunner class >> isTestMethod: aCompiledMethod [
	^ aCompiledMethod methodClass isTestCase
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
CodeAnalysisRunner class >> isTestClass: aClass [
	^ aClass isTestCase
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
CodeAnalysisRunner class >> latexTableForCounts [
	| counts |
	counts := self countsForSelectedPackages.

	^ String streamContents: [ :stream |
		stream nextPutAll: '\begin{tabular}{lrrrrr}'; cr.
		stream nextPutAll: '\hline'; cr.
		stream nextPutAll: '\bfseries Project & \bfseries Packages & \bfseries Classes & \bfseries Methods & \bfseries Lines of Code & \bfseries Tokens \\' ; cr.
		stream nextPutAll: '\hline'; cr.
		stream nextPutAll: (self latexRowForCountsLabel: 'Default packages' values: counts); cr.
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
	totalCharacters := self sum: (self methodsInSelectedPackages collect: [ :each | self tokenCharacterCountOfMethod: each ]).

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
CodeAnalysisRunner class >> saveDefaultPackagesAnalysisToTex [
	^ self allClassesPerPackage
]

{ #category : 'private' }
CodeAnalysisRunner class >> linesOfCodeForMethods: aCollectionOfMethods [
	^ aCollectionOfMethods collect: [ :each | each linesOfCode ]
]

{ #category : 'accessing' }
CodeAnalysisRunner class >> locPerNonDataMethodTexFileName [
	^ 'all_loc_per_non_data_method.tex'
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
CodeAnalysisRunner class >> methodsInSelectedPackages [
	^ self selectedPackages flatCollect: [ :each | each methods ]
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

{ #category : 'accessing' }
CodeAnalysisRunner class >> methodsPerClassTexFileName [
	^ 'all_methods_per_class.tex'
]

{ #category : 'private' }
CodeAnalysisRunner class >> nonDataMethodsInSelectedPackages [
	^ self methodsInSelectedPackages reject: [ :each | self isDataMethod: each ]
]

{ #category : 'accessing' }
CodeAnalysisRunner class >> pharoIdentifierNamesDistributionTexFileName [
	^ 'pharo_identifier_names_distribution.tex'
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

{ #category : 'private' }
CodeAnalysisRunner class >> tokenCountOfMethod: aCompiledMethod [
	^ aCompiledMethod tokens size
]

{ #category : 'private' }
CodeAnalysisRunner class >> tokenCountsForMethods: aCollectionOfMethods [
	^ aCollectionOfMethods collect: [ :each | self tokenCountOfMethod: each ]
]

{ #category : 'private' }
CodeAnalysisRunner class >> allIdentifierNameWordsInSelectedPackages [
	^ self methodsInSelectedPackages flatCollect: [ :each | each wordsFromIdentifierNames ]
]

{ #category : 'private' }
CodeAnalysisRunner class >> allSourceWordsInSelectedPackages [
	^ self methodsInSelectedPackages flatCollect: [ :each | each wordsFromSourceCode ]
]

{ #category : 'private' }
CodeAnalysisRunner class >> allWordsInCorpus: aCollection [
	^ aCollection collect: [ :each | each asLowercase ]
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
CodeAnalysisRunner class >> classNameWordsInSelectedPackages [
	^ self identifierWordsFromNames: (self classesInSelectedPackages collect: [ :each | each name ])
]

{ #category : 'private' }
CodeAnalysisRunner class >> classVariableWordsInSelectedPackages [
	^ self identifierWordsFromNames: (self classesInSelectedPackages flatCollect: [ :each | each classVarNames ])
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
CodeAnalysisRunner class >> globalNamedAnyOf: aCollectionOfNames [
	^ aCollectionOfNames
		detect: [ :each | Smalltalk globals includesKey: each asSymbol ]
		ifFound: [ :each | Smalltalk globals at: each asSymbol ]
		ifNone: [ nil ]
]

{ #category : 'private' }
CodeAnalysisRunner class >> gutenbergCorpusWords [
	^ self wordsFromCorpusProviderNamedAnyOf: #('GutenbergCorpus' 'Gutenberg' 'CorpusGutenberg')
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
		((node class name = 'RBLiteralValueNode' or: [ node class name = 'RBLiteralNode' ])
			and: [ #(nil true false) includes: node value ]) ifTrue: [
				words add: node value printString ] ].
	^ words asArray
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
		(node class name = 'RBLiteralValueNode' or: [ node class name = 'RBLiteralNode' ]) ifTrue: [
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
CodeAnalysisRunner class >> sum: aCollectionOfNumbers [
	^ aCollectionOfNumbers
		inject: 0
		into: [ :total :each | total + each ]
]

{ #category : 'private' }
CodeAnalysisRunner class >> selectorWordsFromSelector: aString [
	^ (aString splitIdentifierName
		select: [ :each | each isAllLetters ])
		collect: [ :each | each asLowercase ]
]

{ #category : 'private' }
CodeAnalysisRunner class >> stemsOf: aCollectionOfWords [
	^ aCollectionOfWords collect: [ :each | self stemFor: each ]
]

{ #category : 'private' }
CodeAnalysisRunner class >> temporaryVariableWordsInSelectedPackages [
	^ self methodsInSelectedPackages flatCollect: [ :each |
		self methodTemporaryWordsOfMethod: each ]
]

{ #category : 'private' }
CodeAnalysisRunner class >> tokenCharacterCountOfMethod: aCompiledMethod [
	^ self characterCountOfWords: aCompiledMethod tokens
]

{ #category : 'private' }
CodeAnalysisRunner class >> delimiterTokensOfMethod: aCompiledMethod [
	^ aCompiledMethod tokens select: [ :each | self isDelimiterToken: each ]
]

{ #category : 'accessing' }
CodeAnalysisRunner class >> tokensPerMethodTexFileName [
	^ 'all_tokens_per_method.tex'
]

{ #category : 'private' }
CodeAnalysisRunner class >> allLiteralsInSelectedPackages [
	^ self methodsInSelectedPackages flatCollect: [ :each | self literalEntriesOfMethod: each ]
]

{ #category : 'accessing' }
CodeAnalysisRunner class >> pharoLiteralDistributionTexFileName [
	^ 'pharo_literal_distribution.tex'
]

{ #category : 'accessing' }
CodeAnalysisRunner class >> pharoTokenTypeDistributionTexFileName [
	^ 'pharo_token_type_distribution.tex'
]

{ #category : 'accessing' }
CodeAnalysisRunner class >> wordCountsTexFileName [
	^ 'word_counts.tex'
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

{ #category : 'private' }
CodeAnalysisRunner class >> wordsFromCorpusProvider: anObject [
	(anObject respondsTo: #words) ifTrue: [ ^ anObject words ].
	(anObject respondsTo: #allWords) ifTrue: [ ^ anObject allWords ].
	(anObject respondsTo: #tokens) ifTrue: [ ^ anObject tokens ].
	(anObject respondsTo: #corpus) ifTrue: [ ^ self wordsFromCorpusProvider: anObject corpus ].
	(anObject respondsTo: #new) ifTrue: [ ^ self wordsFromCorpusProvider: anObject new ].
	^ nil
]

{ #category : 'private' }
CodeAnalysisRunner class >> wordsFromCorpusProviderNamedAnyOf: aCollectionOfNames [
	| provider words |
	provider := self globalNamedAnyOf: aCollectionOfNames.
	provider ifNil: [ ^ #() ].
	words := self wordsFromCorpusProvider: provider.
	^ words ifNil: [ #() ] ifNotNil: [ words ]
]

{ #category : 'accessing' }
CodeAnalysisRunner class >> outputDirectory [
	^ outputDirectory ifNil: [ FileSystem disk workingDirectory ]
]

{ #category : 'accessing' }
CodeAnalysisRunner class >> outputDirectory: aFileReference [
	outputDirectory := aFileReference
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
CodeAnalysisRunner class >> packageNamed: aString [
	^ Smalltalk image packages
		detect: [ :each | each name = aString ]
		ifNone: [ self error: 'Unknown package: ', aString ]
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
CodeAnalysisRunner class >> selectedPackages [
	| configuredPackageNames |
	configuredPackageNames := self selectedPackageNames.
	configuredPackageNames ifEmpty: [ self error: 'No package names configured' ].
	^ configuredPackageNames collect: [ :each | self packageNamed: each ]
]

{ #category : 'private' }
CodeAnalysisRunner class >> selectedPackageNames [
	^ self packageNames ifEmpty: [ self defaultPackages ]
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

{ #category : 'saving' }
CodeAnalysisRunner class >> write: aString to: aFileName [
	| file |
	file := self outputDirectory / aFileName.
	file exists ifTrue: [ file delete ].
	file writeStreamDo: [ :stream | stream nextPutAll: aString ]
]
