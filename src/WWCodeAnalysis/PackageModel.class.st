Class {
	#name : 'PackageModel',
	#superclass : 'Object',
	#instVars : [
		'methods',
		'name',
		'rInt',
		'rExt',
		'rhoInt'
	],
	#category : 'WWCodeAnalysis-Models',
	#package : 'WWCodeAnalysis',
	#tag : 'Models'
}

{ #category : 'initialization' }
PackageModel >> initialize [
	super initialize.
	methods := #()
]

{ #category : 'accessing' }
PackageModel >> rExt [
	^ rExt
]

{ #category : 'accessing' }
PackageModel >> rExt: anObject [
	rExt := anObject
]

{ #category : 'accessing' }
PackageModel >> rInt [
	^ rInt
]

{ #category : 'accessing' }
PackageModel >> rInt: anObject [
	rInt := anObject
]

{ #category : 'accessing' }
PackageModel >> rhoInt [
	^ rhoInt
]

{ #category : 'accessing' }
PackageModel >> rhoInt: anObject [
	rhoInt := anObject
}

{ #category : 'accessing' }
PackageModel >> methods [
	^ methods
]

{ #category : 'accessing' }
PackageModel >> methods: anObject [
	methods := anObject
]

{ #category : 'accessing' }
PackageModel >> name [
	^ name
]

{ #category : 'accessing' }
PackageModel >> name: anObject [
	name := anObject
]
