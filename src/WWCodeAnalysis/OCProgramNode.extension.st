Extension { #name : #OCProgramNode }

{ #category : #'*WWCodeAnalysis' }
OCProgramNode >> commentStrings [
	"A compatibility hook used by the token visitors."
	^ self commentsAsCleanStrings
]

{ #category : #'*WWCodeAnalysis' }
OCProgramNode >> commentsAsCleanStrings [
	"Remove tabs and newlines from comments."
	^ self comments collect: [ :each |
		' ' join: each contents substrings ]
]
