Class {
	#name : 'TokensCollectingVisitor',
	#superclass : 'OCProgramNodeVisitor',
	#instVars : [
		'tokens'
	],
	#category : 'WWCodeAnalysis-Tokenization',
	#package : 'WWCodeAnalysis',
	#tag : 'Tokenization'
}

{ #category : 'adding' }
TokensCollectingVisitor >> addComments: aCollectionOfComments [
	tokens addAll: aCollectionOfComments
]

{ #category : 'adding' }
TokensCollectingVisitor >> addCommentsFrom: aNode [
	aNode ifNil: [ ^ self ].

	(aNode respondsTo: #commentsAsCleanStrings)
		ifTrue: [ self addComments: aNode commentsAsCleanStrings ]
]

{ #category : 'initialization' }
TokensCollectingVisitor >> initialize [
	super initialize.
	tokens := OrderedCollection new
]

{ #category : 'accessing' }
TokensCollectingVisitor >> tokens [
	^ tokens
]

{ #category : 'visiting' }
TokensCollectingVisitor >> visitArgumentNode: anArgumentNode [
	tokens add: anArgumentNode name asString
]

{ #category : 'visiting' }
TokensCollectingVisitor >> visitArrayNode: aLiteralNode [
	tokens add: '{'.

	1 to: aLiteralNode children size - 1 do: [ :index |
		self visitNode: (aLiteralNode children at: index).
		tokens add: '.' ].

	aLiteralNode children isEmpty
		ifFalse: [ self visitNode: aLiteralNode children last ].

	tokens add: '}'
]

{ #category : 'visiting' }
TokensCollectingVisitor >> visitAssignmentNode: anAssignment [
	self visitNode: anAssignment variable.
	tokens add: ':='.
	self visitNode: anAssignment value
]

{ #category : 'visiting' }
TokensCollectingVisitor >> visitBlockNode: aBlockNode [
	tokens add: '['.

	aBlockNode arguments do: [ :each |
		tokens add: ':', each name asString ].

	aBlockNode arguments size > 0
		ifTrue: [ tokens add: '|' ].

	self visitNode: aBlockNode body.
	tokens add: ']'
]

{ #category : 'visiting' }
TokensCollectingVisitor >> visitGlobalNode: aGlobalNode [
	tokens add: aGlobalNode name asString
]

{ #category : 'visiting' }
TokensCollectingVisitor >> visitLiteralArrayNode: aLiteralNode [
	tokens add: (' ' join: aLiteralNode value fullPrintString substrings)
]

{ #category : 'visiting' }
TokensCollectingVisitor >> visitLiteralNode: aLiteralNode [
	tokens add: (' ' join: aLiteralNode value asString substrings)
]

{ #category : 'visiting' }
TokensCollectingVisitor >> visitMessageNode: aMessageNode [
	self visitNode: aMessageNode receiver.
	tokens add: aMessageNode selector asString.
	aMessageNode arguments do: [ :each | self visitNode: each ]
]

{ #category : 'visiting' }
TokensCollectingVisitor >> visitMethodNode: aMethodNode [
	self addCommentsFrom: aMethodNode.

	aMethodNode children do: [ :each |
		each class = RBSequenceNode
			ifTrue: [ self visitNode: each ] ]
]

{ #category : 'visiting' }
TokensCollectingVisitor >> visitNode: aNode [
	super visitNode: aNode.
	self addCommentsFrom: aNode
]

{ #category : 'visiting' }
TokensCollectingVisitor >> visitReturnNode: aReturnNode [
	tokens add: '^'.
	aReturnNode children do: [ :each | self visitNode: each ]
]

{ #category : 'visiting' }
TokensCollectingVisitor >> visitSequenceNode: aNode [
	aNode temporaries size > 0
		ifTrue: [
			tokens add: '|'.
			aNode temporaries do: [ :each | self visitNode: each ].
			tokens add: '|' ].

	aNode statements do: [ :each |
		self visitNode: each.
		tokens add: '.' ]
]

{ #category : 'visiting' }
TokensCollectingVisitor >> visitTemporaryNode: aTemporaryNode [
	tokens add: aTemporaryNode name asString
]

{ #category : 'visiting' }
TokensCollectingVisitor >> visitVariableNode: aVariableNode [
	tokens add: aVariableNode name asString
]
