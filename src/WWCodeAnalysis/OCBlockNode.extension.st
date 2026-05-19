Extension { #name : #OCBlockNode }

{ #category : #'*WWCodeAnalysis' }
OCBlockNode >> commentStrings [
	"Blocks expose this for compatibility with the token visitors."
	^ self commentsAsCleanStrings
]

{ #category : #'*WWCodeAnalysis' }
OCBlockNode >> commentsAsCleanStrings [
	"Blocks do not contribute comments to the token stream."
	^ OrderedCollection new
]
