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

### Package Reference Metrics

The analyzer computes coupling metrics based on class references within methods:

- **R_int**: Count of references to classes defined within the same project.
- **R_ext**: Count of references to classes defined outside the project.
- **rho_int**: The internal reference ratio: $R_{int} / (R_{int} + R_{ext})$.

These metrics are automatically included in the CSV exports for projects, packages, and methods.

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

CodeAnalysisRunner families.
"writes families.tex as a compact three-column ranked summary of the 100 largest families;
all BaselineOf packages form one Baseline family"

CodeAnalysisRunner top10PackagesByTheNumberOfClasses.
"writes top_10_packages_by_class_count.tex"

CodeAnalysisRunner top10ClassesByTheNumberOfMethods.
"writes top_10_classes_by_method_count.tex"

CodeAnalysisRunner top10MethodsByLOC.
"writes top_10_methods_by_loc.tex"

CodeAnalysisRunner top10MethodsByToken.
"writes top_10_methods_by_token_count.tex"

CodeAnalysisRunner pharoIdentifierNamesDistribution.
"writes pharo_identifier_names_distribution.tex"

CodeAnalysisRunner pharoLiteralDistribution.
"writes pharo_literal_distribution.tex"

CodeAnalysisRunner pharoTokenTypeDistribution.
"writes pharo_token_type_distribution.tex"


CodeAnalysisRunner dataDirectory: '~/Documents/Pharo/images/pharo-image-directory/data' asFileReference.
	
CodeAnalysisRunner dataDirectory exists.

CodeAnalysisRunner englishWordSet size.

CodeAnalysisRunner corporaDirectory fullName.

CodeAnalysisRunner wordcounts.

CodeAnalysisRunner wordcounts.
"writes word_counts.tex"

CodeAnalysisRunner testtable.
"writes test_table.tex"

CodeAnalysisRunner listpackages.
"writes list_table.tex"

CodeAnalysisRunner listpackagestest.
"writes list_test_table.tex"

```

Downlaod these projects:

- Roassal
- Bloc and Toplo
- Seaside3
- Moose with Pharo 14
- Dataframe
- PolyMath 
- ChatPharo
- Copilot 
- Pharo-MCP
- Pharo-RAG
- Pharo-ACP


To downlaod the NLTK dataset :

python3 -m venv venv
source venv/bin/activate
python downloadcoprus.py

