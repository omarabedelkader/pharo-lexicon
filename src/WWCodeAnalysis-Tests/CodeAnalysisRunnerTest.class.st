Class {
	#name : 'CodeAnalysisRunnerTest',
	#superclass : 'TestCase',
	#category : 'WWCodeAnalysis-Tests',
	#package : 'WWCodeAnalysis-Tests'
}

{ #category : 'tests' }
CodeAnalysisRunnerTest >> testLatexRowForFormatsExpectedCells [
	| row |
	row := CodeAnalysisRunner
		latexRowFor: 'All packages'
		counts: #(1 2 3 4).

	self assert: (row includesSubstring: '\bfseries All packages').
	self assert: (row includesSubstring: '4 & 1').
	self assert: (row includesSubstring: ' & 2.5 & ').
	self assert: (row endsWith: ' \\')
]

{ #category : 'tests' }
CodeAnalysisRunnerTest >> testStatisticsForCounts [
	| stats |
	stats := CodeAnalysisRunner statisticsForCounts: #(1 2 3 4).

	self assert: (stats at: #count) equals: 4.
	self assert: (stats at: #min) equals: 1.
	self assert: (stats at: #q25) equals: 1.75.
	self assert: (stats at: #median) equals: 2.5.
	self assert: (stats at: #mean) equals: 2.5.
	self assert: (stats at: #q75) equals: 3.25.
	self assert: (stats at: #max) equals: 4
]

{ #category : 'tests' }
CodeAnalysisRunnerTest >> testTexFileName [
	self assert: CodeAnalysisRunner countsTexFileName equals: 'counts.tex'.
	self assert: CodeAnalysisRunner boxplotDistributionPlotCsvFileName equals: 'size_distribution_plot.csv'.
	self assert: CodeAnalysisRunner classesPerPackageTexFileName equals: 'all_classes_per_package.tex'.
	self assert: CodeAnalysisRunner locPerNonDataMethodTexFileName equals: 'all_loc_per_non_data_method.tex'.
	self assert: CodeAnalysisRunner methodsPerClassTexFileName equals: 'all_methods_per_class.tex'.
	self assert: CodeAnalysisRunner pharoIdentifierNamesDistributionTexFileName equals: 'pharo_identifier_names_distribution.tex'.
	self assert: CodeAnalysisRunner pharoLiteralDistributionTexFileName equals: 'pharo_literal_distribution.tex'.
	self assert: CodeAnalysisRunner pharoTokenTypeDistributionTexFileName equals: 'pharo_token_type_distribution.tex'.
	self assert: CodeAnalysisRunner testTableTexFileName equals: 'test_table.tex'.
	self assert: CodeAnalysisRunner wordCountsTexFileName equals: 'word_counts.tex'.
	self assert: CodeAnalysisRunner tokensPerMethodTexFileName equals: 'all_tokens_per_method.tex'
]

{ #category : 'tests' }
CodeAnalysisRunnerTest >> testLatexRowForAllMethodsFormatsExpectedCells [
	| row |
	row := CodeAnalysisRunner
		latexRowFor: 'All methods'
		counts: #(1 2 3 4).

	self assert: (row includesSubstring: '\bfseries All methods').
	self assert: (row includesSubstring: '4 & 1').
	self assert: (row includesSubstring: ' & 2.5 & ').
	self assert: (row endsWith: ' \\')
]

{ #category : 'tests' }
CodeAnalysisRunnerTest >> testLatexRowForCountsFormatsExpectedCells [
	| row |
	row := CodeAnalysisRunner
		latexRowForCountsLabel: 'All image packages'
		values: (Dictionary newFrom: {
			#packages -> 12.
			#classes -> 1234.
			#methods -> 56789.
			#linesOfCode -> 101112.
			#tokens -> 131415 }).

	self assert: (row includesSubstring: 'All image packages & 12 & 1,234 & 56,789 & 101,112 & 131,415').
	self assert: (row endsWith: ' \\')
]

{ #category : 'tests' }
CodeAnalysisRunnerTest >> testSizeDistributionPlotCsvFromRowsFormatsExpectedColumns [
	| csv |
	csv := CodeAnalysisRunner sizeDistributionPlotCsvFromRows: {
		Dictionary newFrom: {
			'level' -> 'package'.
			'metric' -> 'classes_per_package'.
			'size' -> 12 }.
		Dictionary newFrom: {
			'level' -> 'method'.
			'metric' -> 'tokens_per_method'.
			'size' -> 34 } }.

	self assert: (csv includesSubstring: '"level","metric","size"').
	self assert: (csv includesSubstring: '"package","classes_per_package","12"').
	self assert: (csv includesSubstring: '"method","tokens_per_method","34"')
]

{ #category : 'tests' }
CodeAnalysisRunnerTest >> testSizeDistributionPlotRowsForPackagesClassesMethodsIncludesAllLevels [
	| package class method rows |
	package := Smalltalk image packages
		detect: [ :each | (CodeAnalysisRunner classesOfPackage: each) isNotEmpty ]
		ifNone: [ self fail ].
	class := (CodeAnalysisRunner classesOfPackage: package) detect: [ :each | each methods isNotEmpty ] ifNone: [ self fail ].
	method := class methods anyOne.

	rows := CodeAnalysisRunner
		sizeDistributionPlotRowsForPackages: { package }
		classes: { class }
		methods: { method }.

	self assert: ((rows select: [ :each | (each at: 'level') = 'package' ]) size) equals: 1.
	self assert: ((rows select: [ :each | (each at: 'level') = 'class' ]) size) equals: 1.
	self assert: ((rows select: [ :each | (each at: 'level') = 'method' ]) size) equals: 1.
	self assert: ((rows collect: [ :each | each at: 'metric' ]) asSet)
		equals: #('classes_per_package' 'methods_per_class' 'tokens_per_method') asSet
]

{ #category : 'tests' }
CodeAnalysisRunnerTest >> testSelectedPackagesDefaultsToAllPackagesInImage [
	| originalPackageNames selectedPackageNames imagePackageNames |
	originalPackageNames := CodeAnalysisRunner packageNames.
	[
		CodeAnalysisRunner packageNames: #().
		selectedPackageNames := (CodeAnalysisRunner selectedPackages collect: [ :each | each name ]) asSet.
		imagePackageNames := (Smalltalk image packages collect: [ :each | each name ]) asSet.

		self assert: selectedPackageNames equals: imagePackageNames
	] ensure: [
		CodeAnalysisRunner packageNames: originalPackageNames ]
]

{ #category : 'tests' }
CodeAnalysisRunnerTest >> testOutputDirectorySetterCoercesToFileReference [
	| originalOutputDirectory |
	originalOutputDirectory := CodeAnalysisRunner outputDirectory.
	[
		CodeAnalysisRunner outputDirectory: '/tmp/pharo-lexicon-test-output'.
		self assert: CodeAnalysisRunner outputDirectory class name equals: 'FileReference'
	] ensure: [
		CodeAnalysisRunner outputDirectory: originalOutputDirectory ]
]

{ #category : 'tests' }
CodeAnalysisRunnerTest >> testSaveReportNamedReturnsErrorReportWhenGenerationFails [
	| contents |
	contents := CodeAnalysisRunner
		saveReportNamed: 'ignored.tex'
		generatedBy: [ Error signal: 'boom' ].

	self assert: (contents includesSubstring: 'Error generating report').
	self assert: (contents includesSubstring: 'boom')
]

{ #category : 'tests' }
CodeAnalysisRunnerTest >> testLatexRowForIdentifierTypeFormatsExpectedCells [
	| row |
	row := CodeAnalysisRunner
		latexRowForIdentifierType: 'Method names'
		words: #('alpha' 'beta' 'gamma')
		totalWords: 10
		totalCharacters: 20.

	self assert: (row includesSubstring: 'Method names & 3 & 30.0 & 14 & 70.0').
	self assert: (row endsWith: ' \\')
]

{ #category : 'tests' }
CodeAnalysisRunnerTest >> testLatexRowForLiteralTypeFormatsExpectedCells [
	| row |
	row := CodeAnalysisRunner
		latexRowForLiteralType: 'Numbers'
		literals: { 'Numbers' -> 123. 'Numbers' -> 4567 }
		totalLiterals: 10
		totalCharacters: 20.

	self assert: (row includesSubstring: 'Numbers & 2 & 20.0 & 7 & 35.0').
	self assert: (row endsWith: ' \\')
]

{ #category : 'tests' }
CodeAnalysisRunnerTest >> testLiteralEntriesOfMethodCollectsLiteralKindsRobustly [
	| selector method entries |
	selector := #codeAnalysisLiteralDistributionExample.

	[
		self class compile: 'codeAnalysisLiteralDistributionExample
	^ #(1 ''two'' #three $c) -> { 4. ''five''. #six. $z. true. false. nil }'.

		method := self class compiledMethodAt: selector.
		entries := CodeAnalysisRunner literalEntriesOfMethod: method.

		self assert: ((entries select: [ :each | each key = 'Numbers' ]) size) equals: 2.
		self assert: ((entries select: [ :each | each key = 'Strings' ]) size) equals: 2.
		self assert: ((entries select: [ :each | each key = 'Symbols' ]) size) equals: 2.
		self assert: ((entries select: [ :each | each key = 'Characters' ]) size) equals: 2.
		self assert: ((entries select: [ :each | each key = 'Literal arrays' ]) size) equals: 1.
		self assert: ((entries anySatisfy: [ :each | #(nil true false) includes: each value ]) not)
	] ensure: [
		(self class includesSelector: selector)
			ifTrue: [ self class removeSelector: selector ] ]
]

{ #category : 'tests' }
CodeAnalysisRunnerTest >> testLatexRowForTypeTotalsFormatsExpectedCells [
	| row |
	row := CodeAnalysisRunner
		latexRowForTypeTotalsLabel: 'Keywords'
		values: (Dictionary newFrom: {
			#count -> 25.
			#characters -> 40 })
		totalCount: 100
		totalCharacters: 80.

	self assert: (row includesSubstring: 'Keywords & 25 & 25.0 & 40 & 50.0').
	self assert: (row endsWith: ' \\')
]

{ #category : 'tests' }
CodeAnalysisRunnerTest >> testLatexRowForWordCountFormatsExpectedCells [
	| counts row |
	counts := Dictionary newFrom: {
		#words -> 10.
		#uniqueWords -> 7.
		#uniqueStems -> 5.
		#englishWords -> 8.
		#uniqueEnglishWords -> 6.
		#uniqueEnglishStems -> 4 }.
	row := CodeAnalysisRunner
		latexRowForWordCountLabel: 'Words'
		pharo: counts
		pharoStar: counts
		brown: counts
		gutenberg: counts
		selector: #words.

	self assert: (row includesSubstring: '\bfseries Words & 10 & 10 & 10 & 10').
	self assert: (row endsWith: ' \\')
]

{ #category : 'tests' }
CodeAnalysisRunnerTest >> testAllWordsInCorpusFlattensNestedValues [
	| words |
	words := CodeAnalysisRunner allWordsInCorpus: {
		'Alpha'.
		#Beta.
		{ 'Gamma'. #Delta }.
		123.
		$c }.

	self assert: words equals: #('alpha' 'beta' 'gamma' 'delta')
]

{ #category : 'tests' }
CodeAnalysisRunnerTest >> testLatexRowForTestTableFormatsExpectedCells [
	| row |
	row := CodeAnalysisRunner
		latexRowForTestTableLabel: 'Methods'
		total: 164914
		test: 31191
		nonTest: 133723.

	self assert: (row includesSubstring: 'Methods & 164,914 & 31,191 & 133,723 & 18.9%').
	self assert: (row endsWith: ' \\')
]

{ #category : 'tests' }
CodeAnalysisRunnerTest >> testWordsFromCorpusValueExtractsTaggedAssociationKey [
	| words |
	words := CodeAnalysisRunner wordsFromCorpusValue: ('dog' -> 'NN').

	self assert: words equals: #('dog')
]

{ #category : 'tests' }
CodeAnalysisRunnerTest >> testWordsFromCorpusValueSplitsPlainTextIntoWords [
	| words |
	words := CodeAnalysisRunner wordsFromCorpusValue: 'Hello, Gutenberg world!'.

	self assert: words equals: #('hello' 'gutenberg' 'world')
]
