Class {
	#name : #DataCollector,
	#superclass : #Object,
	#instVars : [
		'methodCollector',
		'projectModels',
		'workingDirectory'
	],
	#category : #'WWCodeAnalysis-Collectors'
}

{ #category : #'instance creation' }
DataCollector class >> on: aFileReference [
	^ self new
		workingDirectory: aFileReference;
		yourself
]

{ #category : #running }
DataCollector >> collect [
	self readProjectsMetadata.
	self collectMethods.
	self createAndSaveTables.
	^ self projectModels
]

{ #category : #collecting }
DataCollector >> collectMethods [
	self subclassResponsibility
]

{ #category : #converting }
DataCollector >> collectionAsString: aCollection [
	aCollection ifNil: [ ^ '' ].
	^ ' ' join: ((aCollection collect: [ :each | each asString ]) asArray)
]

{ #category : #private }
DataCollector >> csvEscape: anObject [
	| string escaped |
	string := anObject
		ifNil: [ '' ]
		ifNotNil: [
			anObject isString
				ifTrue: [ anObject ]
				ifFalse: [ anObject asString ] ].

	escaped := string copyReplaceAll: '"' with: '""'.
	^ '"', escaped, '"'
]

{ #category : #private }
DataCollector >> csvLineFrom: aCollection [
	^ String streamContents: [ :stream |
		aCollection doWithIndex: [ :each :index |
			index > 1 ifTrue: [ stream nextPut: $, ].
			stream nextPutAll: (self csvEscape: each) ] ]
]

{ #category : #saving }
DataCollector >> createAndSaveTables [
	self
		createAndSaveTablesFrom: self projectModels
		into: self dataDirectory
]

{ #category : #saving }
DataCollector >> createAndSaveTablesFrom: aCollectionOfProjectModels into: aDirectory [
	aDirectory ensureCreateDirectory.

	self
		writeCsvRows: (self projectRowsFrom: aCollectionOfProjectModels)
		headers: self projectCsvHeaders
		to: aDirectory / 'projects.csv'.

	self
		writeCsvRows: (self packageRowsFrom: aCollectionOfProjectModels)
		headers: self packageCsvHeaders
		to: aDirectory / 'packages.csv'.

	self
		writeCsvRows: (self methodRowsFrom: aCollectionOfProjectModels)
		headers: self methodCsvHeaders
		to: aDirectory / 'methods.csv'
]

{ #category : #configuration }
DataCollector >> dataDirectory [
	self subclassResponsibility
]

{ #category : #initialization }
DataCollector >> initialize [
	super initialize.
	projectModels := #().
	methodCollector := MethodCollector new.
	workingDirectory := FileSystem disk workingDirectory.
]

{ #category : #accessing }
DataCollector >> methodCollector [
	^ methodCollector
]

{ #category : #accessing }
DataCollector >> methodCollector: anObject [
	methodCollector := anObject
]

{ #category : #private }
DataCollector >> methodCsvHeaders [
	^ #(
		'projectName'
		'packageName'
		'methodId'
		'methodName'
		'className'
		'protocol'
		'sourceCode'
		'linesOfCode'
		'tokens'
		'tokenTypes'
		'subtokens'
		'words'
		'allWords'
		'isTestClass'
	)
]

{ #category : #private }
DataCollector >> methodRowsFrom: aCollectionOfProjectModels [
	| rows |
	rows := OrderedCollection new.

	aCollectionOfProjectModels do: [ :projectModel |
		(self packagesIn: projectModel) do: [ :packageModel |
			(self methodsIn: packageModel) do: [ :methodModel |
				rows add: (Dictionary newFrom: {
					'projectName' -> projectModel name.
					'packageName' -> packageModel name.
					'methodId' -> methodModel id.
					'methodName' -> methodModel name.
					'className' -> methodModel methodClass name.
					'protocol' -> methodModel protocol.
					'sourceCode' -> methodModel sourceCode.
					'linesOfCode' -> methodModel linesOfCode.
					'tokens' -> (self collectionAsString: methodModel tokens).
					'tokenTypes' -> (self collectionAsString: methodModel tokenTypes).
					'subtokens' -> (self collectionAsString: methodModel subtokens).
					'words' -> (self collectionAsString: methodModel words).
					'allWords' -> (self collectionAsString: methodModel allWords).
					'isTestClass' -> methodModel isTestClass }) ] ] ].

	^ rows asArray
]

{ #category : #private }
DataCollector >> methodsIn: aPackageModel [
	^ aPackageModel methods ifNil: [ #() ]
]

{ #category : #private }
DataCollector >> packageCsvHeaders [
	^ #(
		'projectName'
		'packageName'
		'methodCount'
	)
]

{ #category : #private }
DataCollector >> packageRowsFrom: aCollectionOfProjectModels [
	| rows |
	rows := OrderedCollection new.

	aCollectionOfProjectModels do: [ :projectModel |
		(self packagesIn: projectModel) do: [ :packageModel |
			rows add: (Dictionary newFrom: {
				'projectName' -> projectModel name.
				'packageName' -> packageModel name.
				'methodCount' -> (self methodsIn: packageModel) size }) ] ].

	^ rows asArray
]

{ #category : #private }
DataCollector >> packagesIn: aProjectModel [
	^ aProjectModel packages ifNil: [ #() ]
]

{ #category : #private }
DataCollector >> projectCsvHeaders [
	^ #(
		'projectName'
		'prefixes'
		'packageCount'
	)
]

{ #category : #accessing }
DataCollector >> projectModels [
	^ projectModels
]

{ #category : #accessing }
DataCollector >> projectModels: anObject [
	projectModels := anObject
]

{ #category : #private }
DataCollector >> projectRowsFrom: aCollectionOfProjectModels [
	^ aCollectionOfProjectModels collect: [ :projectModel |
		Dictionary newFrom: {
			'projectName' -> projectModel name.
			'prefixes' -> (self collectionAsString: projectModel prefixes).
			'packageCount' -> (self packagesIn: projectModel) size } ]
]

{ #category : #configuration }
DataCollector >> projectsFile [
	self subclassResponsibility
]

{ #category : #reading }
DataCollector >> readProjectsMetadata [
	self subclassResponsibility
]

{ #category : #saving }
DataCollector >> writeCsvRows: rows headers: headers to: aFileReference [
	aFileReference exists ifTrue: [ aFileReference delete ].

	aFileReference writeStreamDo: [ :stream |
		stream
			nextPutAll: (self csvLineFrom: headers);
			cr.

		rows do: [ :row |
			stream
				nextPutAll: (self csvLineFrom: (headers collect: [ :header | row at: header ifAbsent: [ '' ] ]));
				cr ] ]
]

{ #category : #accessing }
DataCollector >> workingDirectory [
	^ workingDirectory
]

{ #category : #accessing }
DataCollector >> workingDirectory: anObject [
	workingDirectory := anObject
]
