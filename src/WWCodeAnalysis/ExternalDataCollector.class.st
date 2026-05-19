Class {
	#name : 'ExternalDataCollector',
	#superclass : 'DataCollector',
	#category : 'WWCodeAnalysis-Collectors',
	#package : 'WWCodeAnalysis',
	#tag : 'Collectors'
}

{ #category : 'collecting' }
ExternalDataCollector >> collectMethods [
	self projectModels do: [ :projectModel |
		projectModel load.

		self methodCollector collectMethodsFromProject: projectModel.

		self
			createAndSaveTablesFrom: { projectModel }
			into: self dataDirectory / projectModel name ]
]

{ #category : 'saving' }
ExternalDataCollector >> createAndSaveTables [
	"External projects are saved one project at a time while being collected."
]

{ #category : 'configuration' }
ExternalDataCollector >> dataDirectory [
	^ self workingDirectory / 'data' / 'external'
]

{ #category : 'configuration' }
ExternalDataCollector >> projectsFile [
	^ self workingDirectory / 'projects' / 'external-projects.csv'
]

{ #category : 'reading' }
ExternalDataCollector >> readProjectsMetadata [
	self projectModels: (ProjectsReader readExternalProjectsFrom: self projectsFile)
]
