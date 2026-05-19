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
	self assert: CodeAnalysisRunner classesPerPackageTexFileName equals: 'all_classes_per_package.tex'.
	self assert: CodeAnalysisRunner locPerNonDataMethodTexFileName equals: 'all_loc_per_non_data_method.tex'.
	self assert: CodeAnalysisRunner methodsPerClassTexFileName equals: 'all_methods_per_class.tex'.
	self assert: CodeAnalysisRunner pharoIdentifierNamesDistributionTexFileName equals: 'pharo_identifier_names_distribution.tex'.
	self assert: CodeAnalysisRunner pharoLiteralDistributionTexFileName equals: 'pharo_literal_distribution.tex'.
	self assert: CodeAnalysisRunner pharoTokenTypeDistributionTexFileName equals: 'pharo_token_type_distribution.tex'.
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
		latexRowForCountsLabel: 'Default packages'
		values: (Dictionary newFrom: {
			#packages -> 12.
			#classes -> 1234.
			#methods -> 56789.
			#linesOfCode -> 101112.
			#tokens -> 131415 }).

	self assert: (row includesSubstring: 'Default packages & 12 & 1,234 & 56,789 & 101,112 & 131,415').
	self assert: (row endsWith: ' \\')
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
