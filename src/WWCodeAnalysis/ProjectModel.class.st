Class {
	#name : 'ProjectModel',
	#superclass : 'Object',
	#instVars : [
		'packages',
		'prefixes',
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
ProjectModel >> initialize [
	super initialize.
	packages := #().
	prefixes := #()
]

{ #category : 'accessing' }
ProjectModel >> rExt [
	^ rExt
]

{ #category : 'accessing' }
ProjectModel >> rExt: anObject [
	rExt := anObject
]

{ #category : 'accessing' }
ProjectModel >> rInt [
	^ rInt
]

{ #category : 'accessing' }
ProjectModel >> rInt: anObject [
	rInt := anObject
]

{ #category : 'accessing' }
ProjectModel >> rhoInt [
	^ rhoInt
]

{ #category : 'accessing' }
ProjectModel >> rhoInt: anObject [
	rhoInt := anObject
}

{ #category : 'accessing' }
ProjectModel >> name [
	^ name
]

{ #category : 'accessing' }
ProjectModel >> name: anObject [
	name := anObject
]

{ #category : 'accessing' }
ProjectModel >> packages [
	^ packages
]

{ #category : 'accessing' }
ProjectModel >> packages: anObject [
	packages := anObject
]

{ #category : 'accessing' }
ProjectModel >> prefixes [
	^ prefixes
]

{ #category : 'accessing' }
ProjectModel >> prefixes: anObject [
	prefixes := anObject
]
