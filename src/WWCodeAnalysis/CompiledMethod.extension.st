Extension { #name : 'CompiledMethod' }

{ #category : '*WWCodeAnalysis' }
CompiledMethod >> codeAnalysisParseTree [
	^ OCParser parseMethod: self sourceCode
]

{ #category : '*WWCodeAnalysis' }
CompiledMethod >> collectTokensUsing: aVisitorClass [
	| visitor |
	visitor := aVisitorClass new.
	visitor visitNode: self codeAnalysisParseTree.
	^ visitor tokens asArray
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
