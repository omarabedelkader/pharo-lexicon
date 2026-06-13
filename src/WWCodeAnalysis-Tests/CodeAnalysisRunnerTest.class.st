Class {
	#name : 'CodeAnalysisRunnerTest',
	#superclass : 'TestCase',
	#category : 'WWCodeAnalysis-Tests',
	#package : 'WWCodeAnalysis-Tests'
}

{ #category : 'tests' }
CodeAnalysisRunnerTest >> testCalculateStatisticsFor [
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
	self assert: CodeAnalysisRunner familiesTexFileName equals: 'families.tex'.
	self assert: CodeAnalysisRunner locPerNonDataMethodTexFileName equals: 'all_loc_per_non_data_method.tex'.
	self assert: CodeAnalysisRunner methodsPerClassTexFileName equals: 'all_methods_per_class.tex'.
	self assert: CodeAnalysisRunner pharoIdentifierNamesDistributionTexFileName equals: 'pharo_identifier_names_distribution.tex'.
	self assert: CodeAnalysisRunner pharoLiteralDistributionTexFileName equals: 'pharo_literal_distribution.tex'.
	self assert: CodeAnalysisRunner pharoTokenTypeDistributionTexFileName equals: 'pharo_token_type_distribution.tex'.
	self assert: CodeAnalysisRunner testTableTexFileName equals: 'test_table.tex'.
	self assert: CodeAnalysisRunner wordCountsTexFileName equals: 'word_counts.tex'.
	self assert: CodeAnalysisRunner tokensPerMethodTexFileName equals: 'all_tokens_per_method.tex'.
	self assert: CodeAnalysisRunner top10PackagesByTheNumberOfClassesTexFileName equals: 'top_10_packages_by_class_count.tex'.
	self assert: CodeAnalysisRunner top10ClassesByTheNumberOfMethodsTexFileName equals: 'top_10_classes_by_method_count.tex'.
	self assert: CodeAnalysisRunner top10MethodsByLOCTexFileName equals: 'top_10_methods_by_loc.tex'.
	self assert: CodeAnalysisRunner top10MethodsByTokenTexFileName equals: 'top_10_methods_by_token_count.tex'.
	self assert: CodeAnalysisRunner listPackageMetricsTexFileName equals: 'list_package_metrics.tex'.
	self assert: CodeAnalysisRunner nameLocalitySummaryTexFileName equals: 'tables/name_locality_summary.tex'.
	self assert: CodeAnalysisRunner nameLocalityTop3LocalityTexFileName equals: 'tables/name_locality_top3_locality.tex'.
	self assert: CodeAnalysisRunner nameLocalityBottom3LocalityTexFileName equals: 'tables/name_locality_bottom3_locality.tex'.
	self assert: CodeAnalysisRunner nameLocalityTop3ExternalityTexFileName equals: 'tables/name_locality_top3_externality.tex'.
	self assert: CodeAnalysisRunner nameLocalityTop3LocallyUsedClassesTexFileName equals: 'tables/name_locality_top3_locally_used_classes.tex'.
	self assert: CodeAnalysisRunner nameLocalityBottom3LocallyUsedClassesTexFileName equals: 'tables/name_locality_bottom3_locally_used_classes.tex'.
	self assert: CodeAnalysisRunner nameLocalityTop3TestPackagesTexFileName equals: 'tables/name_locality_top3_test_packages.tex'.
	self assert: CodeAnalysisRunner nameLocalityCsvFileName equals: 'data/name_locality_by_package.csv'.
	self assert: CodeAnalysisRunner nameLocalityFigureTexFileName equals: 'figures/name-locality-ratios.tex'
]

{ #category : 'tests' }
CodeAnalysisRunnerTest >> testLatexTableForPackageMetricsSummary [
	| metrics latex |
	metrics := {
		Dictionary newFrom: { #name -> 'Pkg1'. #isTest -> false. #rInt -> 10. #rExt -> 5. #total -> 15 }.
		Dictionary newFrom: { #name -> 'Pkg1-Tests'. #isTest -> true. #rInt -> 20. #rExt -> 10. #total -> 30 }
	}.

	latex := CodeAnalysisRunner latexTableForPackageMetricsSummary: metrics.

	self assert: (latex includesSubstring: '\begin{tabular}{lrrrr}').
	self assert: (latex includesSubstring: 'Package kind & Packages & Class-name references & Local references & External references').
	self assert: (latex includesSubstring: 'Production packages & 1 & 15 & 10 & 5').
	self assert: (latex includesSubstring: 'Test packages & 1 & 30 & 20 & 10').
	self assert: (latex includesSubstring: 'All packages & 2 & 45 & 30 & 15')
]

{ #category : 'tests' }
CodeAnalysisRunnerTest >> testWriteTop10Table [
	| metrics stream latex |
	metrics := Dictionary newFrom: {
		'ProjA' -> (Dictionary newFrom: { #rInt -> 100. #rExt -> 50 }).
		'ProjB' -> (Dictionary newFrom: { #rInt -> 200. #rExt -> 20 }).
		'ProjC' -> (Dictionary newFrom: { #rInt -> 10. #rExt -> 300 })
	}.
	
	stream := WriteStream on: String new.
	CodeAnalysisRunner writeTop10Table: metrics by: [ :m | (m at: #rInt) + (m at: #rExt) ] label: 'Class-name references' on: stream.
	latex := stream contents.

	self assert: (latex includesSubstring: '\begin{table}[!htbp]').
	self assert: (latex includesSubstring: 'Rank & Project & \# of Class-name references').
	"ProjC should be rank 1 (310), ProjB rank 2 (220), ProjA rank 3 (150)"
	self assert: (latex includesSubstring: '1 & ProjC & 310').
	self assert: (latex includesSubstring: '2 & ProjB & 220').
	self assert: (latex includesSubstring: '3 & ProjA & 150').
	self assert: (latex includesSubstring: '\caption{Top 10 projects by Class-name references.}')
]

{ #category : 'tests' }
CodeAnalysisRunnerTest >> testFamilyNameForPackageName [
	self
		assert: (CodeAnalysisRunner familyNameForPackageName: 'Collections-Abstract')
		equals: 'Collections'.
	self
		assert: (CodeAnalysisRunner familyNameForPackageName: 'Kernel')
		equals: 'Kernel'.
	self
		assert: (CodeAnalysisRunner familyNameForPackageName: 'BaselineOfCollections')
		equals: 'Baseline'.
	self
		assert: (CodeAnalysisRunner familyNameForPackageName: 'BaselineOfSeaside3-Tests')
		equals: 'Baseline'
]

{ #category : 'tests' }
CodeAnalysisRunnerTest >> testLatexFamilyVisualizationShowsTopHundredFamilies [

	| counts latex |
	counts := Dictionary new.
	1 to: 105 do: [ :index | counts at: 'Family_' , index printString put: 106 - index ].

	latex := CodeAnalysisRunner latexFamilyVisualizationForCounts: counts totalPackages: 2000.

	self assert: (latex includesSubstring: '\bfseries Rank & \bfseries Family & \bfseries Count').
	self assert: (latex includesSubstring: '\scriptsize').
	self assert: (latex includesSubstring: '\setlength{\tabcolsep}{2pt}').
	self assert: (latex includesSubstring: '\renewcommand{\arraystretch}{0.85}').
	self assert: (latex includesSubstring: '1 & Family\_1 & 105').
	self assert: (latex includesSubstring: '35 & Family\_35 & 71').
	self assert: (latex includesSubstring: '69 & Family\_69 & 37').
	self assert: (latex includesSubstring: '100 & Family\_100 & 6').
	self assert: (latex includesSubstring: '\multicolumn{8}{r}{Other 5 families} & 15').
	self assert: (latex includesSubstring: '\bfseries 2,000').
	self deny: (latex includesSubstring: 'Family\_101 &')
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
CodeAnalysisRunnerTest >> testLatexTableForPackageMetricsSummary [
	| metrics latex |
	metrics := {
		Dictionary newFrom: { #name -> 'Pkg1'. #isTest -> false. #rInt -> 10. #rExt -> 5. #total -> 15 }.
		Dictionary newFrom: { #name -> 'Pkg1-Tests'. #isTest -> true. #rInt -> 20. #rExt -> 10. #total -> 30 }
	}.

	latex := CodeAnalysisRunner latexTableForPackageMetricsSummary: metrics.

	self assert: (latex includesSubstring: '\begin{tabular}{lrrrr}').
	self assert: (latex includesSubstring: 'Package kind & Packages & Class-name references & Local references & External references').
	self assert: (latex includesSubstring: 'Production packages & 1 & 15 & 10 & 5').
	self assert: (latex includesSubstring: 'Test packages & 1 & 30 & 20 & 10').
	self assert: (latex includesSubstring: 'All packages & 2 & 45 & 30 & 15')
]

{ #category : 'tests' }
CodeAnalysisRunnerTest >> testLatexTableForPackages [

	| metrics latex |
	metrics := Dictionary newFrom: {
			           ('Project1' -> (Dictionary newFrom: {
					             (#packages -> 2).
					             (#classes -> 10).
					             (#testClasses -> 3).
					             (#methods -> 100).
					             (#testMethods -> 25).
					             (#loc -> 500).
					             (#tokens -> 1000).
					             (#rInt -> 5).
					             (#rExt -> 2).
					             (#rhoInt -> 0.5) })).
			           ('Project2' -> (Dictionary newFrom: {
					             (#packages -> 1).
					             (#classes -> 5).
					             (#testClasses -> 1).
					             (#methods -> 50).
					             (#testMethods -> 10).
					             (#loc -> 250).
					             (#tokens -> 500).
					             (#rInt -> 3).
					             (#rExt -> 1).
					             (#rhoInt -> 0.75) })) }.

	latex := CodeAnalysisRunner latexTableForPackages: metrics.

	self assert: (latex includesSubstring: '\begin{longtable}{lrrrrrrrrrr}').
	self assert: (latex includesSubstring:
			 '\bfseries Project & \bfseries Packages & \bfseries Classes & \bfseries Test Classes & \bfseries Methods & \bfseries Test Methods & \bfseries LOC & \bfseries Tokens & \bfseries $R_{\text{int}}$ & \bfseries $R_{\text{ext}}$ & \bfseries $\rho_{\text{int}}$').
	self assert: (latex includesSubstring: 'Project1 & 2 & 10 & 3 & 100 & 25 & 500 & 1,000 & 5 & 2 & 0.5').
	self assert: (latex includesSubstring: 'Project2 & 1 & 5 & 1 & 50 & 10 & 250 & 500 & 3 & 1 & 0.75'). "Check alphabetical order"
	self assert: (latex findString: 'Project1') < (latex findString: 'Project2')
]

{ #category : 'tests' }
CodeAnalysisRunnerTest >> testLatexTableForPackagesTest [
	| metrics latex |
	metrics := {
		Dictionary newFrom: {
			#name -> 'Pkg1'.
			#classCount -> 10.
			#methodCount -> 100.
			#testClasses -> 2.
			#testMethods -> 20.
			#loc -> 500.
			#tokens -> 1000.
			#testPercentage -> '20%' }
	}.

	latex := CodeAnalysisRunner latexTableForPackagesTest: metrics.

	self assert: (latex includesSubstring: '\begin{longtable}{lrrrrrrr}').
	self assert: (latex includesSubstring: 'Test Package & \bfseries Classes & \bfseries Methods & \bfseries Test Classes & \bfseries Test Methods & \bfseries LOC & \bfseries Tokens & \bfseries Test \%').
]

{ #category : 'tests' }
CodeAnalysisRunnerTest >> testLatexTableForTop10ClassesByTheNumberOfMethods [

	| data latex |
	data := {
		        (Dictionary newFrom: {
				         (#package -> 'Pkg1').
				         (#class -> 'Class1').
				         (#methods -> 10) }).
		        (Dictionary newFrom: {
				         (#package -> 'Pkg2').
				         (#class -> 'Class2').
				         (#methods -> 20) }).
		        (Dictionary newFrom: {
				         (#package -> 'Pkg3').
				         (#class -> 'Class3').
				         (#methods -> 5) }) }.

	latex := CodeAnalysisRunner latexTableForTop10ClassesByTheNumberOfMethods: data.

	self assert: (latex includesSubstring: '\bfseries Package & \bfseries Class & \bfseries \# of methods').
	self assert: (latex includesSubstring: 'Pkg2 & Class2 & 20').
	self assert: (latex includesSubstring: 'Pkg1 & Class1 & 10').
	self assert: (latex includesSubstring: 'Pkg3 & Class3 & 5'). "Check order: P2 should come before P1"
	self assert: (latex findString: 'Class2') < (latex findString: 'Class1').
	self assert: (latex findString: 'Class1') < (latex findString: 'Class3')
]

{ #category : 'tests' }
CodeAnalysisRunnerTest >> testLatexTableForTop10MethodsByLOC [

	| data latex |
	data := {
		        (Dictionary newFrom: {
				         (#class -> 'Class1').
				         (#method -> 'M1').
				         (#loc -> 10) }).
		        (Dictionary newFrom: {
				         (#class -> 'Class2').
				         (#method -> 'M2').
				         (#loc -> 20) }).
		        (Dictionary newFrom: {
				         (#class -> 'Class3').
				         (#method -> 'M3').
				         (#loc -> 5) }) }.

	latex := CodeAnalysisRunner latexTableForTop10MethodsByLOC: data.

	self assert: (latex includesSubstring: '\bfseries Class & \bfseries Method & \bfseries LOC').
	self deny: (latex includesSubstring: 'Package').
	self assert: (latex includesSubstring: 'Class2 & M2 & 20').
	self assert: (latex includesSubstring: 'Class1 & M1 & 10').
	self assert: (latex includesSubstring: 'Class3 & M3 & 5').
	self assert: (latex findString: 'M2') < (latex findString: 'M1').
	self assert: (latex findString: 'M1') < (latex findString: 'M3')
]

{ #category : 'tests' }
CodeAnalysisRunnerTest >> testLatexTableForTop10MethodsByToken [
	| data latex |
	data := {
		Dictionary newFrom: { #class -> 'Class1'. #method -> 'M1'. #tokens -> 100 }.
		Dictionary newFrom: { #class -> 'Class2'. #method -> 'M2'. #tokens -> 200 }.
		Dictionary newFrom: { #class -> 'Class3'. #method -> 'M3'. #tokens -> 50 }
	}.

	latex := CodeAnalysisRunner latexTableForTop10MethodsByToken: data.

	self assert: (latex includesSubstring: '\bfseries Class & \bfseries Method & \bfseries \# of tokens').
	self deny: (latex includesSubstring: 'Package').
	self assert: (latex includesSubstring: 'Class2 & M2 & 200').
	self assert: (latex includesSubstring: 'Class1 & M1 & 100').
	self assert: (latex includesSubstring: 'Class3 & M3 & 50').
self assert: (latex findString: 'M2') < (latex findString: 'M1').
	self assert: (latex findString: 'M1') < (latex findString: 'M3')
]

{ #category : 'tests' }
CodeAnalysisRunnerTest >> testLatexTableForTop10PackagesByTheNumberOfClasses [

	| data latex |
	data := {
		        (Dictionary newFrom: {
				         (#project -> 'P1').
				         (#package -> 'Pkg1').
				         (#classes -> 10) }).
		        (Dictionary newFrom: {
				         (#project -> 'P2').
				         (#package -> 'Pkg2').
				         (#classes -> 20) }).
		        (Dictionary newFrom: {
				         (#project -> 'P3').
				         (#package -> 'Pkg3').
				         (#classes -> 5) }) }.

	latex := CodeAnalysisRunner latexTableForTop10PackagesByTheNumberOfClasses: data.

	self assert: (latex includesSubstring: '\bfseries Project & \bfseries Package & \bfseries \# of classes').
	self assert: (latex includesSubstring: 'P2 & Pkg2 & 20').
	self assert: (latex includesSubstring: 'P1 & Pkg1 & 10').
	self assert: (latex includesSubstring: 'P3 & Pkg3 & 5'). "Check order: P2 should come before P1"
	self assert: (latex findString: 'Pkg2') < (latex findString: 'Pkg1').
	self assert: (latex findString: 'Pkg1') < (latex findString: 'Pkg3')
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
		self assert: ((entries select: [ :each | each key = 'Symbols' ]) size) equals: 2.
		self assert: ((entries select: [ :each | each key = 'Strings' ]) size) equals: 2.
		
		self assert: ((entries select: [ :each | each key = 'Characters' ]) size) equals: 2.
		self assert: ((entries select: [ :each | each key = 'Literal arrays' ]) size) equals: 1.
		self assert: ((entries anySatisfy: [ :each | #(nil true false) includes: each value ]) not)
	] ensure: [
		(self class includesSelector: selector)
			ifTrue: [ self class removeSelector: selector ] ]
]

{ #category : 'tests' }
CodeAnalysisRunnerTest >> testOutputDirectorySetterCoercesToFileReference [
	| originalOutputDirectory |
	originalOutputDirectory := CodeAnalysisRunner outputDirectory.
	[
		CodeAnalysisRunner outputDirectory: '/tmp'.
		self assert: CodeAnalysisRunner outputDirectory equals: '/tmp' asFileReference.

		CodeAnalysisRunner outputDirectory: '/tmp' asFileReference.
		self assert: CodeAnalysisRunner outputDirectory equals: '/tmp' asFileReference.
	] ensure: [
		CodeAnalysisRunner outputDirectory: originalOutputDirectory ]
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
CodeAnalysisRunnerTest >> testSizeDistributionPlotCsvFromRowsFormatsExpectedColumns [

	| csv |
	csv := CodeAnalysisRunner sizeDistributionPlotCsvFromRows: {
			       (Dictionary newFrom: {
					        ('level' -> 'package').
					        ('metric' -> 'classes_per_package').
					        ('size' -> 12) }).
			       (Dictionary newFrom: {
					        ('level' -> 'class').
					        ('metric' -> 'methods_per_class').
					        ('size' -> 34) }).
			       (Dictionary newFrom: {
					        ('level' -> 'method').
					        ('metric' -> 'tokens_per_method').
					        ('size' -> 56) }) }.

	self assert: (csv includesSubstring: '"package","classes_per_package","12"').
	self assert: (csv includesSubstring: '"class","methods_per_class","34"').
	self assert: (csv includesSubstring: '"method","tokens_per_method","56"')
]

{ #category : 'tests' }
CodeAnalysisRunnerTest >> testTexFileName [
	self assert: CodeAnalysisRunner countsTexFileName equals: 'counts.tex'.
	self assert: CodeAnalysisRunner boxplotDistributionPlotCsvFileName equals: 'size_distribution_plot.csv'.
	self assert: CodeAnalysisRunner classesPerPackageTexFileName equals: 'all_classes_per_package.tex'.
	self assert: CodeAnalysisRunner familiesTexFileName equals: 'families.tex'.
	self assert: CodeAnalysisRunner locPerNonDataMethodTexFileName equals: 'all_loc_per_non_data_method.tex'.
	self assert: CodeAnalysisRunner methodsPerClassTexFileName equals: 'all_methods_per_class.tex'.
	self assert: CodeAnalysisRunner pharoIdentifierNamesDistributionTexFileName equals: 'pharo_identifier_names_distribution.tex'.
	self assert: CodeAnalysisRunner pharoLiteralDistributionTexFileName equals: 'pharo_literal_distribution.tex'.
	self assert: CodeAnalysisRunner pharoTokenTypeDistributionTexFileName equals: 'pharo_token_type_distribution.tex'.
	self assert: CodeAnalysisRunner testTableTexFileName equals: 'test_table.tex'.
	self assert: CodeAnalysisRunner wordCountsTexFileName equals: 'word_counts.tex'.
	self assert: CodeAnalysisRunner tokensPerMethodTexFileName equals: 'all_tokens_per_method.tex'.
	self assert: CodeAnalysisRunner top10PackagesByTheNumberOfClassesTexFileName equals: 'top_10_packages_by_class_count.tex'.
	self assert: CodeAnalysisRunner top10ClassesByTheNumberOfMethodsTexFileName equals: 'top_10_classes_by_method_count.tex'.
	self assert: CodeAnalysisRunner top10MethodsByLOCTexFileName equals: 'top_10_methods_by_loc.tex'.
	self assert: CodeAnalysisRunner top10MethodsByTokenTexFileName equals: 'top_10_methods_by_token_count.tex'.
	self assert: CodeAnalysisRunner listPackageMetricsTexFileName equals: 'list_package_metrics.tex'
]

{ #category : 'tests' }
CodeAnalysisRunnerTest >> testWriteTop10Table [
	| metrics stream latex |
	metrics := Dictionary newFrom: {
		'ProjA' -> (Dictionary newFrom: { #rInt -> 100. #rExt -> 50 }).
		'ProjB' -> (Dictionary newFrom: { #rInt -> 200. #rExt -> 20 }).
		'ProjC' -> (Dictionary newFrom: { #rInt -> 10. #rExt -> 300 })
	}.
	
	stream := WriteStream on: String new.
	CodeAnalysisRunner writeTop10Table: metrics by: [ :m | (m at: #rInt) + (m at: #rExt) ] label: 'Class-name references' on: stream.
	latex := stream contents.

	self assert: (latex includesSubstring: '\begin{table}[!htbp]').
	self assert: (latex includesSubstring: 'Rank & Project & \# of Class-name references').
	"ProjC should be rank 1 (310), ProjB rank 2 (220), ProjA rank 3 (150)"
	self assert: (latex includesSubstring: '1 & ProjC & 310').
	self assert: (latex includesSubstring: '2 & ProjB & 220').
	self assert: (latex includesSubstring: '3 & ProjA & 150').
	self assert: (latex includesSubstring: '\caption{Top 10 projects by Class-name references.}')
]

{ #category : 'tests' }
CodeAnalysisRunnerTest >> testLatexNameLocalitySummaryUsesTable16Totals [
	| metrics latex |
	metrics := {
		Dictionary newFrom: {
			#isTestPackage -> false.
			#resolvedClassReferences -> 54206.
			#localReferences -> 25042.
			#externalReferences -> 29164 }.
		Dictionary newFrom: {
			#isTestPackage -> true.
			#resolvedClassReferences -> 50776.
			#localReferences -> 35201.
			#externalReferences -> 15575 }
	}.

	latex := CodeAnalysisRunner latexNameLocalitySummaryFor: metrics.

	self assert: (latex includesSubstring: 'Production packages & 1 & 54,206 & 25,042 & 46.2\% & 29,164 & 53.8\%').
	self assert: (latex includesSubstring: 'Test packages & 1 & 50,776 & 35,201 & 69.3\% & 15,575 & 30.7\%').
	self assert: (latex includesSubstring: 'All packages & 2 & 104,982 & 60,243 & 57.4\% & 44,739 & 42.6\%')
]

{ #category : 'tests' }
CodeAnalysisRunnerTest >> testNameLocalityCsvContainsRequestedColumns [
	| metrics csv |
	metrics := {
		Dictionary newFrom: {
			#packageName -> 'Pkg-Tests'.
			#projectOrFamily -> 'Pkg'.
			#isTestPackage -> true.
			#definedClasses -> 4.
			#resolvedClassReferences -> 20.
			#localReferences -> 15.
			#externalReferences -> 5.
			#localityRatio -> 0.75.
			#externalityRatio -> 0.25.
			#usedLocalClasses -> 3.
			#locallyUsedClassRatio -> 0.75 }
	}.

	csv := CodeAnalysisRunner nameLocalityCsvFor: metrics.

	self assert: (csv includesSubstring: '"packageName","projectOrFamily","isTestPackage","definedClasses","resolvedClassReferences","localReferences","externalReferences","localityRatio","externalityRatio","usedLocalClasses","locallyUsedClassRatio"').
	self assert: (csv includesSubstring: '"Pkg-Tests","Pkg","true","4","20","15","5","0.75","0.25","3","0.75"')
]

{ #category : 'tests' }
CodeAnalysisRunnerTest >> testNameLocalityFigureUsesConsistentRatios [
	| latex |
	latex := CodeAnalysisRunner nameLocalityFigureLatex.

	self assert: (latex includesSubstring: '28 local refs, 40 external refs').
	self assert: (latex includesSubstring: '\rho_{\mathrm{local}}=41.2\%').
	self assert: (latex includesSubstring: '\rho_{\mathrm{external}}=58.8\%').
	self assert: (latex includesSubstring: '5 local refs, 20 external refs').
	self assert: (latex includesSubstring: '\rho_{\mathrm{external}}=80\%')
]

{ #category : 'tests' }
CodeAnalysisRunnerTest >> testNameLocalitySupportFilters [
	| metrics referenceMetrics coverageMetrics |
	metrics := {
		Dictionary newFrom: {
			#packageName -> 'TooFewReferences'.
			#resolvedClassReferences -> 9.
			#definedClasses -> 3 }.
		Dictionary newFrom: {
			#packageName -> 'EnoughReferences'.
			#resolvedClassReferences -> 10.
			#definedClasses -> 2 }
	}.

	referenceMetrics := CodeAnalysisRunner nameLocalityReferenceMetricsFrom: metrics.
	coverageMetrics := CodeAnalysisRunner nameLocalityCoverageMetricsFrom: metrics.

	self assert: referenceMetrics size equals: 1.
	self assert: referenceMetrics first equals: metrics second.
	self assert: coverageMetrics size equals: 1.
	self assert: coverageMetrics first equals: metrics first
]

{ #category : 'tests' }
CodeAnalysisRunnerTest >> testNameLocalityRankingUsesSupportAsTieBreaker [
	| metrics sorted |
	metrics := {
		Dictionary newFrom: {
			#packageName -> 'PkgA'.
			#localityRatio -> 0.8.
			#resolvedClassReferences -> 20 }.
		Dictionary newFrom: {
			#packageName -> 'PkgB'.
			#localityRatio -> 0.8.
			#resolvedClassReferences -> 30 }.
		Dictionary newFrom: {
			#packageName -> 'PkgC'.
			#localityRatio -> 0.7.
			#resolvedClassReferences -> 100 }
	}.

	sorted := CodeAnalysisRunner
		nameLocalityTopThreeFrom: metrics
		metric: #localityRatio
		descending: true
		support: #resolvedClassReferences.

	self assert: (sorted collect: [ :each | each at: #packageName ]) asArray
		equals: #('PkgB' 'PkgA' 'PkgC')
]
