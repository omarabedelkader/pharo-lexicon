Class {
	#name : 'PackageReferenceMetrics',
	#superclass : 'Object',
	#instVars : [
		'internalClasses',
		'internalReferences',
		'externalReferences',
		'usedInternalClasses'
	],
	#category : 'WWCodeAnalysis-Metrics',
	#package : 'WWCodeAnalysis',
	#tag : 'Metrics'
}

{ #category : 'instance creation' }
PackageReferenceMetrics class >> forPackage: aPackage [
	^ (self withInternalClasses: aPackage definedClasses asSet)
		analyzePackage: aPackage;
		yourself
]

{ #category : 'instance creation' }
PackageReferenceMetrics class >> forPackages: aCollectionOfRPackages [
	| internalClasses |
	internalClasses := (aCollectionOfRPackages flatCollect: [ :p | p definedClasses ]) asSet.
	^ (self withInternalClasses: internalClasses)
		analyzePackages: aCollectionOfRPackages;
		yourself
]

{ #category : 'instance creation' }
PackageReferenceMetrics class >> withInternalClasses: aSetOfClasses [
	^ self new
		internalClasses: aSetOfClasses;
		yourself
]

{ #category : 'analysis' }
PackageReferenceMetrics >> analyzeMethod: aMethod [
	| ast |
	ast := [ aMethod ast ] on: Error do: [ nil ].
	ast ifNil: [ ^ self ].

	ast nodesDo: [ :node |
		(node isVariable and: [ node isGlobalVariable ])
			ifTrue: [ self processBinding: node binding ] ]
]

{ #category : 'analysis' }
PackageReferenceMetrics >> analyzePackage: aPackage [
	aPackage methods do: [ :method |
		self analyzeMethod: method ]
]

{ #category : 'analysis' }
PackageReferenceMetrics >> analyzePackages: aCollectionOfRPackages [
	aCollectionOfRPackages do: [ :package |
		self analyzePackage: package ]
]

{ #category : 'analysis' }
PackageReferenceMetrics >> classFromBinding: aBinding [
	| value |
	"In Pharo, class bindings value is the class itself."
	value := aBinding value.
	(value isBehavior) ifTrue: [ ^ value ].
	^ nil
]

{ #category : 'accessing' }
PackageReferenceMetrics >> externalReferences [
	^ externalReferences
]

{ #category : 'accessing' }
PackageReferenceMetrics >> externalityRatio [
	| total |
	total := self resolvedClassReferences.
	total = 0 ifTrue: [ ^ 0 ].
	^ externalReferences / total asFloat
]

{ #category : 'initialization' }
PackageReferenceMetrics >> initialize [
	super initialize.
	internalReferences := 0.
	externalReferences := 0.
	internalClasses := Set new.
	usedInternalClasses := Set new
]

{ #category : 'accessing' }
PackageReferenceMetrics >> internalClasses: aSetOfClasses [
	internalClasses := aSetOfClasses asSet.
	usedInternalClasses removeAll
]

{ #category : 'accessing' }
PackageReferenceMetrics >> internalReferences [
	^ internalReferences
]

{ #category : 'accessing' }
PackageReferenceMetrics >> localReferences [
	^ self internalReferences
]

{ #category : 'accessing' }
PackageReferenceMetrics >> localityRatio [
	^ self rhoInt
]

{ #category : 'accessing' }
PackageReferenceMetrics >> locallyUsedClassRatio [
	internalClasses ifEmpty: [ ^ 0 ].
	^ usedInternalClasses size / internalClasses size asFloat
]

{ #category : 'analysis' }
PackageReferenceMetrics >> processBinding: binding [
	| referencedClass |
	referencedClass := self classFromBinding: binding.
	referencedClass ifNil: [ ^ self ].

	(internalClasses includes: referencedClass)
		ifTrue: [
			internalReferences := internalReferences + 1.
			usedInternalClasses add: referencedClass ]
		ifFalse: [ externalReferences := externalReferences + 1 ]
]

{ #category : 'accessing' }
PackageReferenceMetrics >> resolvedClassReferences [
	^ internalReferences + externalReferences
]

{ #category : 'accessing' }
PackageReferenceMetrics >> rExt [
	^ self externalReferences
]

{ #category : 'accessing' }
PackageReferenceMetrics >> rInt [
	^ self internalReferences
]

{ #category : 'accessing' }
PackageReferenceMetrics >> rhoInt [
	| total |
	total := self resolvedClassReferences.
	total = 0 ifTrue: [ ^ 0 ].
	^ internalReferences / total asFloat
]

{ #category : 'accessing' }
PackageReferenceMetrics >> usedLocalClasses [
	^ usedInternalClasses size
]
