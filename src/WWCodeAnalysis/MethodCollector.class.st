Class {
	#name : 'MethodCollector',
	#superclass : 'Object',
	#instVars : [
		'methodId'
	],
	#category : 'WWCodeAnalysis-Collectors',
	#package : 'WWCodeAnalysis',
	#tag : 'Collectors'
}

{ #category : 'collecting' }
MethodCollector >> collectDataFromMethod: aMethod [
	| method |
	method := MethodModel new
		id: self methodId;
		name: aMethod selector;
		methodClass: aMethod methodClass;
		protocol: aMethod protocol;
		sourceCode: aMethod sourceCode;
		linesOfCode: aMethod linesOfCode;
		tokens: aMethod tokens;
		tokenTypes: aMethod tokenTypes;
		subtokens: aMethod subtokens;
		words: aMethod wordsFromIdentifierNames;
		allWords: aMethod wordsFromSourceCode;
		isTestClass: aMethod methodClass isTestCase;
		yourself.

	self updateMethodId.
	^ method
]

{ #category : 'collecting' }
MethodCollector >> collectMethodsFromPackage: aPackage [
	| methods |
	methods := OrderedCollection new.

	aPackage methods do: [ :aMethod |
		methods add: (self collectDataFromMethod: aMethod) ].

	^ PackageModel new
		name: aPackage name;
		methods: methods asArray;
		yourself
]

{ #category : 'collecting' }
MethodCollector >> collectMethodsFromProject: aProjectModel [
	| packages packageModels count |
	packageModels := OrderedCollection new.
	count := 1.

	packages := self packagesOfProject: aProjectModel.

	packages
		do: [ :package |
			packageModels add: (self collectMethodsFromPackage: package).
			count := count + 1 ]
		displayingProgress: [ :package |
			'(', count asString, '/', packages size asString, ' packages) ', package name ].

	aProjectModel packages: packageModels asArray.
	^ aProjectModel
]

{ #category : 'collecting' }
MethodCollector >> collectMethodsFromProjects: aCollectionOfProjectModels [
	| count |
	count := 1.

	aCollectionOfProjectModels
		do: [ :projectModel |
			self collectMethodsFromProject: projectModel.
			count := count + 1 ]
		displayingProgress: [ :projectModel |
			'(', count asString, '/', aCollectionOfProjectModels size asString, ' projects) ', projectModel name ].

	^ aCollectionOfProjectModels
]

{ #category : 'accessing' }
MethodCollector >> initialMethodId [
	^ 1
]

{ #category : 'initialization' }
MethodCollector >> initialize [
	super initialize.
	self methodId: self initialMethodId
]

{ #category : 'accessing' }
MethodCollector >> methodId [
	^ methodId
]

{ #category : 'accessing' }
MethodCollector >> methodId: anObject [
	methodId := anObject
]

{ #category : 'collecting' }
MethodCollector >> packagesOfProject: aProjectModel [
	^ aProjectModel prefixes flatCollect: [ :prefix |
		Smalltalk image packages select: [ :package |
			package name beginsWith: prefix ] ]
]

{ #category : 'accessing' }
MethodCollector >> updateMethodId [
	self methodId: self methodId + 1
]
