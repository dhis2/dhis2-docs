# dhis2-markdown-docs
All of your favourite documents - in markdown format!


# Updating the documents
This is the easy bit, and is all that most people have to do. The following sections describe the format, structure and a few considerations necessary for correctly generating the desired output.

## Format and editing
The documents are maintained in **commonmark** markdown format, with an `.md` extension.

Editing documents is as simple as editing a text file. Many IDEs have markdown support, including live previews. For Linux and Windows, [ghostwriter](https://wereturtle.github.io/ghostwriter/) is a nice option; it is free and supports side-by-side preview and custom stylesheets.

> **TIP**
>
> If you have the option to apply custom css to your markdown editor, set it to `./src/commonmark/en/resources/css/dhis2.css` to reflect the html output style for DHIS2!


## Structure

The documents are structured as follows:

```
<root>
└── src
    └── commonmark
        └── en
	        ├── dhis2_android_user_man_INDEX.md
	        ├── dhis2_developer_manual_INDEX.md
	        ├── dhis2_end_user_manual_INDEX.md
	        ├── dhis2_implementation_guide_INDEX.md
	        ├── dhis2_user_manual_en_INDEX.md
	        ├── user_stories_book_INDEX.md
		├── resources
		│   ├── css
		│   │   ├── dhis2.css
		│   │   └── dhis2_pdf.css
		│   └── images
		│       └── dhis2-logo-rgb-negative.png
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

The `*_INDEX.md` files are the starting points for the master documents. They contain only `!INCLUDE` directives.

e.g. dhis2_android_user_man_INDEX.md:
```
!INCLUDE "content/common/about-this-guide.md"
!INCLUDE "content/android/configure-dhis2-programs-to-work-on-android-apps.md"
!INCLUDE "content/android/android-event-capture-app.md"
!INCLUDE "content/android/android-aggregate-data-capture-app.md"
!INCLUDE "content/android/android-tracker-capture-app.md"
```

The `!INCLUDE` directives point to the "chapters" that are used to make up the manual. 

> **NOTE**
>
> the `!INCLUDE` directives are not part of pure commonmark format, but are used in pre-processing to build the master documents. The particular format here is the one supported by markdown-pp out of the box, but we could change it to another "include" format if desired.

It is perfectly valid to use `!INCLUDE` directives in the sub-documents too, but currently the documents are split up at chapter level only.

### Adding images

Image resources should be included inside a folder structure beginning with `resources/images/` relative to the current document. e.g. for the chapter `content/android/android-event-capture-app.md`, the images are somewhere under `content/android/resources/images/<rest-of-path>`. _The images will be collected under `resources/images/content/android/<rest-of-path>` relative to the master document, when the the files are pre-processed for generation._  


### Section references

In order to provide fixed references within the document, we can set a fixed text string to be applied to any section. For our markdown docs this is done by adding a comment after the section heading in the form:
```
<!-- DHIS2-SECTION-ID:name_of_section -->
```

where ```name_of_section``` is replace with the id you wish to use. 

For example:
```

## Validation

<!--DHIS2-SECTION-ID:webapi_validation-->

To generate a data validation summary you can interact ...
```

Will set the section id of the level 2 heading **Validation** to "webapi_validation", which may then be referenced as "#webapi_validation" within the html file.

After the full html file is generated, it is post-processed and the first ```DHIS2-SECTION-ID``` after the start of the section is used as the section id.

Please follow the convention of lowercase letters and underscores, in order to create id's that are also valid as filenames when the html files are split.

# Building documents

The documents are built in stages:

1. The documents are pre-processed with [markdown-pp](https://github.com/jreese/markdown-pp). This assembles all the included (eventually nested) files into a single master document in a temporary directory. This includes copying and adjusting the links to included images.
2. The final documentation (HTML and PDF formats) are generated with [pandoc](https://pandoc.org/); using [weasyprint](https://weasyprint.readthedocs.io/en/stable/#) as the PDF generation engine.
3. The chunked html versions are generated by post-processing the full versions; splitting sections at h2 level, and inserting them into a template.

In order to build:

- run the build.sh script:
```
./build.sh
```

> **NOTE**
>
> The first time it is run, the build script will create a python virtual env and install the dependencies from the requirements.txt file. It will copy pandoc (v2.2.1), and install a "modified" version of markdown-pp; these are provided in the tools directory. The venv will then be activated to perform the rest of the build. **This should work on Linux, but hasn't been tested on other platforms!**

The generated files are placed in a `target` directory:

```
<root>
├── build.sh
├── README.md
├── requirements.txt
├── venv_setup
├── src
│   └── commonmark
│       └── en
│           .
│           .
│           .
├── target
│   └── commonmark
│       └── en
│           ├── android
│           │   ├── dhis2_android_user_man.pdf
│           │   └── html
│           ├── developer
│           │   ├── dhis2_developer_manual.pdf
│           │   └── html
│           ├── end-user
│           │   ├── dhis2_end_user_manual.pdf
│           │   └── html
│           ├── implementer
│           │   ├── dhis2_implementation_guide.pdf
│           │   └── html
│           ├── user
│           │   ├── dhis2_user_manual_en.pdf
│           │   └── html
│           └── user-stories
│               ├── html
│               └── user_stories_book.pdf
└── tools
    ├── pandoc
    ├── pandoc-citeproc
    └── python
        └── markdown-pp-master
            ├── images
            ├── LICENSE
            ├── makefile
            ├── MANIFEST.in
            ├── MarkdownPP
            ├── readme.md
            ├── readme.mdpp
            ├── setup.py
            └── test


```

# Shortcomings

As we transition to markdown, please bear in mind the following issues and shortcomings!

- It is not clear if we can continue the Bibliography support that Docbook provided (or if we need to)

## Known Issues - to be fixed

- [X] Chunked HTML output should use the same identifiers as the docbook output
- [X] Intra- (and inter-) document links need updating to generate properly
- [ ] "Asides" (NOTE, TIP, WARNING, etc.) have classes applied in a post-processing step which doesn't apply to PDF output. (could be done as a pandoc filter instead).
- [ ] Section regarding documentation and Docbook needs rewrite (obviously)
- [ ] build environment needs improvement to allow easy generation on various platforms (but most developers will not need to build as they can see the expected output in a good markdown editor)
- [ ] in conjunction with previous point, the build script could be changed to a more robust build tool

