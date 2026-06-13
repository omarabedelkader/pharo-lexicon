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

The dedicated name-locality report computes package-scoped metrics over resolved
class-name references in methods:

- **localReferences**: references to classes defined by the same package.
- **externalReferences**: references to classes defined outside the package.
- **localityRatio**: `localReferences / resolvedClassReferences`.
- **externalityRatio**: `externalReferences / resolvedClassReferences`.
- **usedLocalClasses**: distinct package-defined classes referenced at least once.
- **locallyUsedClassRatio**: `usedLocalClasses / definedClasses`.

Repeated references count separately in the reference ratios but only once in
the distinct-class coverage metric. The older `rInt`, `rExt`, and `rhoInt`
fields in collector exports remain project-scoped for compatibility.

#### Generate the name-locality tables

1. Open the Pharo image containing all projects from the analyzed corpus. The
   target packages and their classes must be loaded in the image before running
   the analysis.

2. Load this local checkout from a Pharo Playground:

```smalltalk
Metacello new
  baseline: 'PharoLexicon';
  repository: 'tonel:///Users/omar/Desktop/Github/pharo-lexicon/src';
  load.
```

When the changes are available on GitHub, the repository can instead be loaded
with:

```smalltalk
Metacello new
  githubUser: 'omarabedelkader'
  project: 'pharo-lexicon'
  commitish: 'main'
  path: 'src';
  baseline: 'PharoLexicon';
  load.
```

3. Select the packages belonging to the corpus. Use explicit package names so
   Pharo's own unrelated packages are not included:

```smalltalk
CodeAnalysisRunner packageNames: #(
  'MyProject-Core'
  'MyProject-Tests'
  'AnotherProject-Model'
  'AnotherProject-Tests'
).
```

To intentionally analyze every package loaded in the image:

```smalltalk
CodeAnalysisRunner packageNames: #().
```

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

CodeAnalysisRunner listpackagemetrics.
"writes list_package_metrics.tex"

CodeAnalysisRunner nameLocalityReports.

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
