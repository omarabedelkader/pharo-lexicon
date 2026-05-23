# pharo-lexicon

Load the project and its dependency in a Pharo image with:

```smalltalk

Metacello new
  githubUser: 'omarabedelkader' project: 'pharo-lexicon' commitish: 'main' path: 'src';
  baseline: 'PharoLexicon';
  load.
```

By default, the runner analyzes all packages loaded in the current image.
If you want to restrict the run to a subset, set `CodeAnalysisRunner packageNames:` first.

Run the analyses with:

```
CodeAnalysisRunner allClassesPerPackage.

CodeAnalysisRunner alllocpernondatamethod.

CodeAnalysisRunner allmethodsperclass.

CodeAnalysisRunner alltokenspermethod.

CodeAnalysisRunner counts.

CodeAnalysisRunner pharoIdentifierNamesDistribution.

CodeAnalysisRunner pharoLiteralDistribution.

CodeAnalysisRunner pharoTokenTypeDistribution.

CodeAnalysisRunner wordcounts

```
