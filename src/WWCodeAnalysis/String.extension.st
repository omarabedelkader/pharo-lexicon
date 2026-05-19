Extension { #name : #String }

{ #category : #'*WWCodeAnalysis' }
String >> isAllLetters [
	"Return whether the receiver is composed entirely of letters and has at least one letter."

	self do: [ :character |
		character isLetter ifFalse: [ ^ false ] ].

	self ifEmpty: [ ^ false ].
	^ true
]

{ #category : #'*WWCodeAnalysis' }
String >> splitIdentifierName [
	^ IdentifierNameSplitter instance splitIdentifierName: self
]
