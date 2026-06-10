Class {
	#name : 'PackageReferenceMetricsTest',
	#superclass : 'TestCase',
	#category : 'WWCodeAnalysis-Tests',
	#package : 'WWCodeAnalysis-Tests'
}

{ #category : 'tests' }
PackageReferenceMetricsTest >> testClassFromBinding [
	| metrics binding |
	metrics := PackageReferenceMetrics new.

	binding := Smalltalk globals associationAt: #Object.
	self assert: (metrics classFromBinding: binding) equals: Object.

	"Smalltalk is a global but not a class/behavior"
	binding := Smalltalk globals associationAt: #Smalltalk.
	self assert: (metrics classFromBinding: binding) isNil
]

{ #category : 'tests' }
PackageReferenceMetricsTest >> testProcessBinding [
	| metrics binding |
	metrics := PackageReferenceMetrics new.
	metrics instVarNamed: 'internalClasses' put: { Object } asSet.

	binding := Smalltalk globals associationAt: #Object.
	metrics processBinding: binding.
	self assert: metrics rInt equals: 1.
	self assert: metrics rExt equals: 0.

	binding := Smalltalk globals associationAt: #Point.
	metrics processBinding: binding.
	self assert: metrics rInt equals: 1.
	self assert: metrics rExt equals: 1.

	self assert: metrics rhoInt equals: 0.5
]

{ #category : 'tests' }
PackageReferenceMetricsTest >> testRhoIntWithZeroReferences [
	| metrics |
	metrics := PackageReferenceMetrics new.
	self assert: metrics rhoInt equals: 0
]
