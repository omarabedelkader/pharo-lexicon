Class {
	#name : #ExternalProjectModel,
	#superclass : #ProjectModel,
	#instVars : [
		'repositoryOwner',
		'repositoryName',
		'commit',
		'codeDirectory',
		'group'
	],
	#category : #'WWCodeAnalysis-Models'
}

{ #category : #accessing }
ExternalProjectModel >> codeDirectory [
	^ codeDirectory
]

{ #category : #accessing }
ExternalProjectModel >> codeDirectory: anObject [
	codeDirectory := anObject
]

{ #category : #accessing }
ExternalProjectModel >> commit [
	^ commit
]

{ #category : #accessing }
ExternalProjectModel >> commit: anObject [
	commit := anObject
]

{ #category : #accessing }
ExternalProjectModel >> group [
	^ group
]

{ #category : #accessing }
ExternalProjectModel >> group: anObject [
	group := anObject
]

{ #category : #actions }
ExternalProjectModel >> load [
	self metacello load: self group
]

{ #category : #metacello }
ExternalProjectModel >> metacello [
	^ Metacello new
		baseline: self name;
		repository: ('github://',
			self repositoryOwner,
			'/',
			self repositoryName,
			':',
			self commit,
			'/',
			(self codeDirectory ifNil: [ '' ]));
		onConflict: [ :exception | exception useIncoming ];
		onUpgrade: [ :exception | exception useIncoming ];
		onDowngrade: [ :exception | exception useIncoming ];
		onWarning: [ :exception | exception resume ]
]

{ #category : #accessing }
ExternalProjectModel >> repositoryName [
	^ repositoryName
]

{ #category : #accessing }
ExternalProjectModel >> repositoryName: anObject [
	repositoryName := anObject
]

{ #category : #accessing }
ExternalProjectModel >> repositoryOwner [
	^ repositoryOwner
]

{ #category : #accessing }
ExternalProjectModel >> repositoryOwner: anObject [
	repositoryOwner := anObject
]
