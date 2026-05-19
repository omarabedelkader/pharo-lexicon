Class {
	#name : 'TokenTypesCollectingVisitor',
	#superclass : 'TokensCollectingVisitor',
	#category : 'WWCodeAnalysis-Tokenization',
	#package : 'WWCodeAnalysis',
	#tag : 'Tokenization'
}

{ #category : 'adding' }
TokenTypesCollectingVisitor >> addComments: aCollectionOfComments [
	tokens addAll: (aCollectionOfComments collect: [ :each | 'COM' ])
]

{ #category : 'encoding' }
TokenTypesCollectingVisitor >> encodeLiteral: aLiteral [
	aLiteral isNumber ifTrue: [ ^ 'NUM' ].
	aLiteral isSymbol ifTrue: [ ^ 'SYM' ].
	aLiteral isString ifTrue: [ ^ 'STR' ].
	aLiteral isCharacter ifTrue: [ ^ 'CHR' ].
	aLiteral ifNil: [ ^ 'NIL' ].
	aLiteral = true ifTrue: [ ^ 'TRU' ].
	aLiteral = false ifTrue: [ ^ 'FLS' ].
	^ aLiteral asString
]

{ #category : 'visiting' }
TokenTypesCollectingVisitor >> visitArgumentNode: anArgumentNode [
	tokens add: 'ARG'
]

{ #category : 'visiting' }
TokenTypesCollectingVisitor >> visitArrayNode: aLiteralNode [
	tokens add: 'CB1'.

	1 to: aLiteralNode children size - 1 do: [ :index |
		self visitNode: (aLiteralNode children at: index).
		tokens add: 'DOT' ].

	aLiteralNode children isEmpty
		ifFalse: [ self visitNode: aLiteralNode children last ].

	tokens add: 'CB2'
]

{ #category : 'visiting' }
TokenTypesCollectingVisitor >> visitAssignmentNode: anAssignment [
	self visitNode: anAssignment variable.
	tokens add: 'ASS'.
	self visitNode: anAssignment value
]

{ #category : 'visiting' }
TokenTypesCollectingVisitor >> visitBlockNode: aBlockNode [
	tokens add: 'SB1'.

	aBlockNode arguments do: [ :each |
		self visitNode: each ].

	aBlockNode arguments size > 0
		ifTrue: [ tokens add: 'PIP' ].

	self visitNode: aBlockNode body.
	tokens add: 'SB2'
]

{ #category : 'visiting' }
TokenTypesCollectingVisitor >> visitGlobalNode: aGlobalNode [
	(Smalltalk globals includesKey: aGlobalNode name)
		ifFalse: [
			tokens add: 'CVR' ]
		ifTrue: [
			tokens add: ((Smalltalk globals at: aGlobalNode name) isClass
				ifTrue: [ 'CLS' ]
				ifFalse: [ 'GLB' ]) ]
]

{ #category : 'visiting' }
TokenTypesCollectingVisitor >> visitLiteralArrayNode: aLiteralNode [
	tokens add: 'ARR'
]

{ #category : 'visiting' }
TokenTypesCollectingVisitor >> visitLiteralNode: aLiteralNode [
	tokens add: (self encodeLiteral: aLiteralNode value)
]

{ #category : 'visiting' }
TokenTypesCollectingVisitor >> visitMessageNode: aMessageNode [
	self visitNode: aMessageNode receiver.
	tokens add: 'MSG'.
	aMessageNode arguments do: [ :each | self visitNode: each ]
]

{ #category : 'visiting' }
TokenTypesCollectingVisitor >> visitMethodNode: aMethodNode [
	self addCommentsFrom: aMethodNode.

	aMethodNode children do: [ :each |
		each class = RBSequenceNode
			ifTrue: [ self visitNode: each ] ]
]

{ #category : 'visiting' }
TokenTypesCollectingVisitor >> visitReturnNode: aReturnNode [
	tokens add: 'RET'.
	aReturnNode children do: [ :each | self visitNode: each ]
]

{ #category : 'visiting' }
TokenTypesCollectingVisitor >> visitSelfNode: aNode [
	tokens add: 'SLF'
]

{ #category : 'visiting' }
TokenTypesCollectingVisitor >> visitSequenceNode: aSequence [
	aSequence temporaries size > 0
		ifTrue: [
			tokens add: 'PIP'.
			aSequence temporaries do: [ :each | self visitNode: each ].
			tokens add: 'PIP' ].

	aSequence statements do: [ :each |
		self visitNode: each.
		tokens add: 'DOT' ]
]

{ #category : 'visiting' }
TokenTypesCollectingVisitor >> visitSuperNode: aNode [
	tokens add: 'SUP'
]

{ #category : 'visiting' }
TokenTypesCollectingVisitor >> visitTemporaryNode: aTemporaryNode [
	tokens add: 'TMP'
]

{ #category : 'visiting' }
TokenTypesCollectingVisitor >> visitThisContextNode: aNode [
	tokens add: 'THS'
]

{ #category : 'visiting' }
TokenTypesCollectingVisitor >> visitVariableNode: aVariableNode [
	tokens add: 'VAR'
]
