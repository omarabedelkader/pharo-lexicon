Class {
	#name : #ProjectModel,
	#superclass : #Object,
	#instVars : [
		'packages',
		'prefixes',
		'name'
	],
	#category : #'WWCodeAnalysis-Models'
}

{ #category : #initialization }
ProjectModel >> initialize [
	super initialize.
	packages := #().
	prefixes := #()
]

{ #category : #accessing }
ProjectModel >> name [
	^ name
]

{ #category : #accessing }
ProjectModel >> name: anObject [
	name := anObject
]

{ #category : #accessing }
ProjectModel >> packages [
	^ packages
]

{ #category : #accessing }
ProjectModel >> packages: anObject [
	packages := anObject
]

{ #category : #accessing }
ProjectModel >> prefixes [
	^ prefixes
]

{ #category : #accessing }
ProjectModel >> prefixes: anObject [
	prefixes := anObject
]
