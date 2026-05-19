Class {
	#name : #SubtokensCollectingVisitor,
	#superclass : #TokensCollectingVisitor,
	#category : #'WWCodeAnalysis-Tokenization'
}

{ #category : #adding }
SubtokensCollectingVisitor >> addComments: aCollectionOfComments [
	"Subtoken streams intentionally ignore comments."
]

{ #category : #visiting }
SubtokensCollectingVisitor >> encodeLiteral: aLiteral [
	aLiteral isNumber ifTrue: [ ^ '<num>' ].
	aLiteral isSymbol ifTrue: [ ^ '<sym>' ].
	aLiteral isString ifTrue: [ ^ '<str>' ].
	aLiteral isCharacter ifTrue: [ ^ '<chr>' ].
	^ aLiteral asString
]

{ #category : #splitting }
SubtokensCollectingVisitor >> extractSubtokens: aString [
	^ (aString splitIdentifierName collect: #asLowercase)
		collect: [ :each |
			[ each asNumber. '<num>' ]
				on: Error
				do: [ each ] ]
]

{ #category : #visiting }
SubtokensCollectingVisitor >> visitArgumentNode: anArgumentNode [
	tokens addAll: (self extractSubtokens: anArgumentNode name asString)
]

{ #category : #visiting }
SubtokensCollectingVisitor >> visitBlockNode: aBlockNode [
	tokens add: '['.

	aBlockNode arguments do: [ :each |
		tokens add: ':'.
		self visitNode: each ].

	aBlockNode arguments size > 0
		ifTrue: [ tokens add: '|' ].

	self visitNode: aBlockNode body.
	tokens add: ']'
]

{ #category : #visiting }
SubtokensCollectingVisitor >> visitGlobalNode: aGlobalNode [
	tokens addAll: (self extractSubtokens: aGlobalNode name asString)
]

{ #category : #visiting }
SubtokensCollectingVisitor >> visitLiteralArrayNode: aLiteralNode [
	tokens add: '<arr>'
]

{ #category : #visiting }
SubtokensCollectingVisitor >> visitLiteralNode: aLiteralNode [
	tokens add: (self encodeLiteral: aLiteralNode value)
]

{ #category : #visiting }
SubtokensCollectingVisitor >> visitMessageNode: aMessageNode [
	self visitNode: aMessageNode receiver.

	aMessageNode arguments
		ifEmpty: [
			tokens addAll: (self extractSubtokens: aMessageNode selector asString) ]
		ifNotEmpty: [
			1 to: aMessageNode arguments size do: [ :index |
				tokens addAll: (self extractSubtokens: (aMessageNode selectorParts at: index) asString).
				self visitNode: (aMessageNode arguments at: index) ] ]
]

{ #category : #visiting }
SubtokensCollectingVisitor >> visitTemporaryNode: aTemporaryNode [
	tokens addAll: (self extractSubtokens: aTemporaryNode name asString)
]

{ #category : #visiting }
SubtokensCollectingVisitor >> visitVariableNode: aVariableNode [
	tokens addAll: (self extractSubtokens: aVariableNode name asString)
]
