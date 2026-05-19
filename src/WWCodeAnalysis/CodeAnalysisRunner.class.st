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
	self write: table to: self texFileName.
	^ table
]

{ #category : 'running' }
CodeAnalysisRunner class >> allclassesperpackage [
	^ self allClassesPerPackage
]

{ #category : 'running' }
CodeAnalysisRunner class >> allClassesPerPackageForPackagesNamed: aCollection [
	self defaultPackages: aCollection.
	^ self allClassesPerPackage
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
CodeAnalysisRunner class >> isTestPackage: aPackage [
	^ (aPackage name asLowercase includesSubstring: 'test')
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
CodeAnalysisRunner class >> saveDefaultPackagesAnalysisToTex [
	^ self allClassesPerPackage
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

{ #category : 'accessing' }
CodeAnalysisRunner class >> texFileName [
	^ 'defaultpackages-analysis.tex'
]

{ #category : 'saving' }
CodeAnalysisRunner class >> write: aString to: aFileName [
	| file |
	file := self outputDirectory / aFileName.
	file exists ifTrue: [ file delete ].
	file writeStreamDo: [ :stream | stream nextPutAll: aString ]
]
