# dhis2-markdown-docs
All of your favourite documents - in markdown format!

## Introduction

This is a provisional repository for testing the migration of DHIS2 documentation to commonmark format.

## Shortcomings

See the following regarding updating and building, but bear in mind the following issues and shortcomings!


- The document generation pipeline below **does not** support chunked HTML - **ONLY FULL HTML** (this could be fixed by generating the docs _via_ Docbook!)
- "Asides" (NOTE, TIP, WARNING, etc.) currently all look the same (blockquote format), but we may be able to modify them in the pre-processing step to accommodate individual styling
- It is not clear if we can continue the Bibliography support that Docbook provided (or if we need to)

### Known Issues - to be fixed

- [ ] Intra- (and inter-) document links need updating to generate properly
- [ ] Section regarding documentation and Docbook needs rewrite (obviously)
- [ ] build environment needs improvement to allow easy generation on various platforms (but most developers will not need to build as they can see the expected output in a good markdown editor)
- [ ] in conjunction with previous point, the build script could be changed to a more robust build tool

## Updating the documents
This is the easy bit, and is all that most people have to do.

### Format and editing
The documents are maintained in "Commonmark" markdown format.

Editing documents is as simple as editing a text file. Many IDEs have markdown support, including live previews. For Linux and Windows, [ghostwriter](https://wereturtle.github.io/ghostwriter/) is a nice option; it is free and supports side-by-side preview and custom stylesheets.


### Structure

The documents are structured as follows:

```
<root>
└── src
    └── commonmark
        └── en
	        ├── dhis2_android_user_man.index
	        ├── dhis2_developer_manual.index
	        ├── dhis2_end_user_manual.index
	        ├── dhis2_implementation_guide.index
	        ├── dhis2_user_manual_en.index
	        ├── user_stories_book.index
	        ├── dhis2.css
	        ├── dhis2_pdf.css
	        ├── dhis2_template.html
	        ├── dhis2-logo-rgb-negative.png
	        └── content
	            ├── android
	            │   └── resources
	            │       └── images
	            ├── common
	            │   └── bookinfo.yaml
	            ├── developer
	            │   ├── resources
	            │   │   └── images
	            ├── implementation
	            │   ├── resources
	            │   │   └── images
	            │   ├── `resources
	            │   │   └── images
	            ├── stories
	            │   ├── resources
	            │   │   └── images
	            └── user
	                └── resources
	                    └── images


```

### Index files and INCLUDES

The `.index` files are the starting points for the master documents. They contain only `!INCLUDE` directives.

e.g. dhis2_android_user_man.index:
```
!INCLUDE "content/common/about-this-guide.cm"mouse
!INCLUDE "content/android/configure-dhis2-programs-to-work-on-android-apps.cm"
!INCLUDE "content/android/android-event-capture-app.cm"
!INCLUDE "content/android/android-aggregate-data-capture-app.cm"
!INCLUDE "content/android/android-tracker-capture-app.cm"
```

The `!INCLUDE` directives point to the "chapters" that are used to make up the manual. 

> NOTE:
> the `!INCLUDE` directives are not part of pure commonmark format, but are used in post-processing to build the master documents. The particular format here is the one supported by markdown-pp out of the box, but we could change it to another "include" format if desired.

It is perfectly valid to use `!INCLUDE` directives in the sub-documents too, but currently the documents are split up at chapter level only.

### Adding Images

Image resources should be included inside a folder structure beginning with `resources/images/` relative to the document. e.g. for the chapter `content/android/android-event-capture-app.cm`, the images are somewhere under `content/android/resources/images/<rest-of-path>`. _The images will be collected under `resources/images/content/android/<rest-of-path>` relative to the master document, when the the files are pre-processed for generation._  



## Building documents

The documents are build in two stages:

1. The documents are pre-processed with [markdown-pp](https://github.com/jreese/markdown-pp). This assembles all the included (eventually nested) files into a single master document in the target directory. This includes copying and adjusting the links to included images.
2. The final documentation (HTML and PDF formats) are generated with [pandoc](https://pandoc.org/); using [weasyprint](https://weasyprint.readthedocs.io/en/stable/#) as the PDF generation engine.

In order to build:

- activate the python venv:
```
source venv/bin/activate
```

- update the link to the python binary under `venv/bin/`
- run the build.sh script:
```
./build.sh
```

> NOTE:
> The provided venv contains pandoc (v2.2.1), weasyprint, and a "modified" version of markdown-pp. Hopefully, this should work on Linux. INSTALLING SEPERATELY WILL NOT CURRENTLY WORK. However, the modified markdown-pp code is provided under `tools/python/`, so with a bit of fiddling it is possible. 

The generated files (from both steps) are placed in a `target` directory:

```
<root>
├── build.sh
├── README.md
├── src
│   └── commonmark
│       └── en
│           .
│           .
│           .
├── target
│   └── commonmark
│       └── en
│           ├── bookinfo.yaml
│           ├── dhis2_android_user_man.cm
│           ├── dhis2_android_user_man.html
│           ├── dhis2_android_user_man.pdf
│           ├── dhis2.css
│           ├── dhis2_developer_manual.cm
│           ├── dhis2_developer_manual.html
│           ├── dhis2_developer_manual.pdf
│           ├── dhis2_end_user_manual.cm
│           ├── dhis2_end_user_manual.html
│           ├── dhis2_end_user_manual.pdf
│           ├── dhis2_implementation_guide.cm
│           ├── dhis2_implementation_guide.html
│           ├── dhis2_implementation_guide.pdf
│           ├── dhis2-logo-rgb-negative.png
│           ├── dhis2_pdf.css
│           ├── dhis2_template.html
│           ├── dhis2_user_manual_en.cm
│           ├── dhis2_user_manual_en.html
│           ├── dhis2_user_manual_en.pdf
│           ├── resources
│           ├── user_stories_book.cm
│           ├── user_stories_book.html
│           └── user_stories_book.pdf
├── tools
│   └── python
│       ├── MarkdownPP
│       │   ├── __init__.py
│       │   ├── main.py
│       │   ├── MarkdownPP.py
│       │   ├── Module.py
│       │   ├── Modules
│       │   ├── Processor.py
│       │   └── Transform.py
│       └── markdown-pp-master
│           ├── images
│           ├── LICENSE
│           ├── makefile
│           ├── MANIFEST.in
│           ├── MarkdownPP
│           ├── readme.md
│           ├── readme.mdpp
│           ├── setup.py
│           └── test
└── venv
    ├── bin
    │   .
    │   .
    │   .
    │   ├── python -> /home/philld/anaconda3/bin/python  # CHANGE THIS FOR YOUR SYSTEM!
    │   ├── python3 -> python
    │   .
    │   .
    ├── include
    ├── lib
    │   └── python3.6
    │       └── site-packages
    ├── lib64 -> lib
    └── pyvenv.cfg

```

