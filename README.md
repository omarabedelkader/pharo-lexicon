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

Each command writes a `.tex` file to the same directory as the running Pharo image by default.
You can change that with `CodeAnalysisRunner outputDirectory: aFileReference`.

Run the analyses with:

```smalltalk
CodeAnalysisRunner allClassesPerPackage.
"writes all_classes_per_package.tex"

CodeAnalysisRunner alllocpernondatamethod.
"writes all_loc_per_non_data_method.tex"

CodeAnalysisRunner allmethodsperclass.
"writes all_methods_per_class.tex"

CodeAnalysisRunner alltokenspermethod.
"writes all_tokens_per_method.tex"

CodeAnalysisRunner counts.
"writes counts.tex"

CodeAnalysisRunner pharoIdentifierNamesDistribution.
"writes pharo_identifier_names_distribution.tex"

CodeAnalysisRunner pharoLiteralDistribution.
"writes pharo_literal_distribution.tex"

CodeAnalysisRunner pharoTokenTypeDistribution.
"writes pharo_token_type_distribution.tex"

CodeAnalysisRunner wordcounts.
"writes word_counts.tex"

```
