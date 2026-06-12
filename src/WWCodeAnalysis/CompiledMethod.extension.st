Extension { #name : 'CompiledMethod' }

{ #category : '*WWCodeAnalysis' }
CompiledMethod >> codeAnalysisParseTree [
	^ [ OCParser parseMethod: self sourceCode ]
		on: Error
		do: [ nil ]
]

{ #category : '*WWCodeAnalysis' }
CompiledMethod >> collectTokensUsing: aVisitorClass [
	| visitor parseTree |
	parseTree := self codeAnalysisParseTree.
	parseTree ifNil: [ ^ #() ].

	visitor := aVisitorClass new.
	^ [
		visitor visitNode: parseTree.
		visitor tokens asArray
	] on: Error do: [ #() ]
]

{ #category : '*WWCodeAnalysis' }
CompiledMethod >> linesOfCode [
	^ self sourceCode lines size
]

{ #category : '*WWCodeAnalysis' }
CompiledMethod >> subtokens [
	^ self collectTokensUsing: SubtokensCollectingVisitor
]

{ #category : '*WWCodeAnalysis' }
CompiledMethod >> tokenTypes [
	^ self collectTokensUsing: TokenTypesCollectingVisitor
]

{ #category : '*WWCodeAnalysis' }
CompiledMethod >> tokens [
	^ self collectTokensUsing: TokensCollectingVisitor
]

{ #category : '*WWCodeAnalysis' }
CompiledMethod >> wordsFromIdentifierNames [
	^ ((self subtokens
		select: [ :each | each isAllLetters ])
		collect: [ :each | each asLowercase ]) asArray
]

{ #category : '*WWCodeAnalysis' }
CompiledMethod >> wordsFromSourceCode [
	^ (((self sourceCode substrings
		flatCollect: [ :each | each splitIdentifierName ])
		select: [ :each | each isAllLetters ])
		collect: [ :each | each asLowercase ]) asArray
]
