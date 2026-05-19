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
	self assert: CodeAnalysisRunner classesPerPackageTexFileName equals: 'all_classes_per_package.tex'.
	self assert: CodeAnalysisRunner locPerMethodTexFileName equals: 'all_loc_per_method.tex'.
	self assert: CodeAnalysisRunner locPerNonDataMethodTexFileName equals: 'all_loc_per_non_data_method.tex'.
	self assert: CodeAnalysisRunner methodsPerClassTexFileName equals: 'all_methods_per_class.tex'.
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
