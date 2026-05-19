Class {
	#name : 'InternalDataCollector',
	#superclass : 'DataCollector',
	#category : 'WWCodeAnalysis-Collectors',
	#package : 'WWCodeAnalysis',
	#tag : 'Collectors'
}

{ #category : 'collecting' }
InternalDataCollector >> collectMethods [
	self methodCollector collectMethodsFromProjects: self projectModels
]

{ #category : 'configuration' }
InternalDataCollector >> dataDirectory [
	^ self workingDirectory / 'data' / 'internal'
]

{ #category : 'configuration' }
InternalDataCollector >> projectsFile [
	^ self workingDirectory / 'projects' / 'internal-projects.csv'
]

{ #category : 'reading' }
InternalDataCollector >> readProjectsMetadata [
	self projectModels: (ProjectsReader readInternalProjectsFrom: self projectsFile)
]
