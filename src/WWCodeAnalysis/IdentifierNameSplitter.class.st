Class {
	#name : 'IdentifierNameSplitter',
	#superclass : 'Object',
	#instVars : [
		'abbreviationsRegex1',
		'abbreviationsRegex2',
		'abbreviationsRegex3',
		'camelCaseRegex',
		'nonAlphanumericRegex',
		'numbersRegex'
	],
	#classInstVars : [
		'instance'
	],
	#category : 'WWCodeAnalysis-Splitting',
	#package : 'WWCodeAnalysis',
	#tag : 'Splitting'
}

{ #category : 'accessing' }
IdentifierNameSplitter class >> instance [
	^ instance ifNil: [ instance := self new ]
]

{ #category : 'accessing' }
IdentifierNameSplitter class >> resetInstance [
	instance := nil
]

{ #category : 'initialization' }
IdentifierNameSplitter >> initialize [
	"Regular expression creation is expensive. Keep compiled regexes on the splitter instance."
	super initialize.

	abbreviationsRegex1 := '[A-Z][A-Z]+\>' asRegex.
	abbreviationsRegex2 := '[A-Z][A-Z]+' asRegex.
	abbreviationsRegex3 := ' |[^ ]+' asRegex.
	camelCaseRegex := '[A-Z][a-z]+|\<[a-z]+' asRegex.
	nonAlphanumericRegex := '[A-Za-z0-9]+|[\W_]+' asRegex.
	numbersRegex := '\d+|\D+' asRegex
]

{ #category : 'splitting' }
IdentifierNameSplitter >> separateAbbreviationsIn: aString [
	| str suffix words |
	aString isEmpty ifTrue: [ ^ OrderedCollection new ].

	str := aString.

	suffix := abbreviationsRegex1 matchesIn: str collect: #value.
	suffix := suffix isEmpty
		ifTrue: [ '' ]
		ifFalse: [ suffix anyOne ].

	str := suffix isEmpty
		ifTrue: [ str ]
		ifFalse: [
			suffix size = str size
				ifTrue: [ '' ]
				ifFalse: [ str copyFrom: 1 to: str size - suffix size ] ].

	str := abbreviationsRegex2
		copy: str
		translatingMatchesUsing: [ :match |
			' ', (match copyWithoutIndex: match size), ' ', match last asString ].

	words := abbreviationsRegex3 matchesIn: str collect: #value.
	words := words copyWithout: ' '.

	suffix isEmpty ifFalse: [ words := words, { suffix } ].
	^ words
]

{ #category : 'splitting' }
IdentifierNameSplitter >> separateCamelCaseIn: aString [
	^ camelCaseRegex matchesIn: aString collect: #value
]

{ #category : 'splitting' }
IdentifierNameSplitter >> separateNonAlphanumericIn: aString [
	^ nonAlphanumericRegex matchesIn: aString collect: #value
]

{ #category : 'splitting' }
IdentifierNameSplitter >> separateNumbersIn: aString [
	^ numbersRegex matchesIn: aString collect: #value
]

{ #category : 'splitting' }
IdentifierNameSplitter >> splitIdentifierName: aString [
	| words |
	aString isEmpty ifTrue: [ ^ OrderedCollection new ].

	words := OrderedCollection with: aString.

	words := words flatCollect: [ :eachWord |
		self separateNonAlphanumericIn: eachWord ].

	words := words flatCollect: [ :eachWord |
		self separateNumbersIn: eachWord ].

	words := words flatCollect: [ :eachWord |
		self separateAbbreviationsIn: eachWord ].

	words := words flatCollect: [ :eachWord |
		eachWord
			detect: [ :eachCharacter | eachCharacter isLowercase ]
			ifFound: [ self separateCamelCaseIn: eachWord ]
			ifNone: [ { eachWord } ] ].

	^ words
]
