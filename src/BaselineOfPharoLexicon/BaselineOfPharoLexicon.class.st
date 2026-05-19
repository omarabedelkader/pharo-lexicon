Class {
	#name : #BaselineOfPharoLexicon,
	#superclass : #BaselineOf,
	#category : #BaselineOfPharoLexicon
}

{ #category : #baselines }
BaselineOfPharoLexicon >> baseline: spec [
	<baseline>

	spec for: #common do: [
		spec package: 'WWCodeAnalysis'.
		spec
			package: 'WWCodeAnalysis-Tests'
			with: [ spec requires: #('WWCodeAnalysis') ] ]
]
