Extension { #name : #RBProgramNode }

{ #category : #'*WWCodeAnalysis' }
RBProgramNode >> commentStrings [
	"A compatibility hook used by the token visitors."
	^ self commentsAsCleanStrings
]

{ #category : #'*WWCodeAnalysis' }
RBProgramNode >> commentsAsCleanStrings [
	"Remove tabs and newlines from comments."
	^ self comments collect: [ :each |
		' ' join: each contents substrings ]
]
