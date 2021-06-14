# DHIS 2 Documentation Guide { #doc_guide_chapter } 

## DHIS 2 Documentation System Overview { #docs_1 } 

DHIS 2 is a web-based information management system under very active
development with typically three releases per year. Each release
typically includes a number of new features and additional
functionality. Given the fast pace of development, the system's wide
user base and distributed, global nature of development, a comprehensive
documentation system is required.

In this chapter, we will describe the documentation system of DHIS 2 and how you
can contribute.

## Introduction { #docs_2 } 

The DHIS 2 documentation is written in [Commonmark](https://commonmark.org) markdown format.
One of the main advantages of markdown is
that there is complete separation between the content and presentation.
Commonmark is a strongly defined, highly compatible specification of
markdown.
Since markdown can be transformed into a wide variety of formats (HTML,
PDF, etc) and is a text-based format, it serves as an ideal format for
documentation of the system.

There exist a wide range of text editors which can be used for the
creation of markdown files. For Linux and Windows,
[ghostwriter](https://wereturtle.github.io/ghostwriter/) is a nice option;
it is free and supports side-by-side preview and custom style sheets.

> **TIP**
>
> If you have the option to apply custom css to your markdown editor, set it to `./src/commonmark/en/resources/css/dhis2.css` to reflect the html output style for DHIS2!

One of the key concepts to keep in mind when authoring documentation in
markdown, or other presentation neutral formats, is that the **content**
of the document should be considered first. The **presentation** of the
document will take place in a separate transformation step, whereby the
source text will be rendered into different formats, such as HTML and
PDF. It is therefore important that the document is well organised and
structured, with appropriate tags and structural elements being
considered.

It is good practice to break your document in to various sections using
the section headings. In this way, very complex chapters can be split into smaller, more manageable pieces.
This concept is essentially the same as Microsoft Word or other word
processing programs. The rendering process will automatically take care of numbering
the sections for you when the document is produced.


## Getting started with GitHub { #docs_3 } 

The DHIS 2 documentation system is managed at
[GitHub](https://github.com/dhis2/dhis2-docs) in its own source
code repository. GitHub is a collaborative platform that enables
multiple people to work on software projects collaboratively. In order
for this to be possible, a version control system is necessary in order
to manage all the changes that multiple users may make. GitHub uses the
*git* source control system. While it is beyond the scope of this
document to describe the functionality of *git*, users who wish to
create documentation will need to gain at least a basic understanding of
how the system works. A basic guide is provided in the next section. The
reader is referred to the [git manual](https://git-scm.com/book/en/v2)
for further information.

In order to start adding or editing the documentation, you should first
perform a checkout of the source code. If you do not already have a
GitHub account, you will need to get one. This can be done
[here](https://github.com/). Once you register with GitHub, you will
need to request access to the *dhis2-documenters* group if you wish to
modify the source code of the documentation directly.

Login to GitHub, and then file an issue
[here](https://github.com/dhis2/dhis2-docs/issues/new). Your request will
need to be approved by the group administrators. Once you have been
granted access to the group, you can commit changes to the documentation
branch and send and receive notifications if you wish. Alternatively,
you can clone the documentation into your own repository, commit your
changes to your own fork, and request that your changes be merged with
the source of the documentation with a pull request
[here](https://github.com/dhis2/dhis2-docs/pulls).

## Getting the document source { #docs_4 } 

In order to edit the documentation, you will need to download the source
of the documentation to your computer. GitHub uses a version control
system known as git . There are different methods for getting Git
working on your system, depending on which operating system you are
using. A good step-by-step guide for Microsoft operating systems can be
viewed
[here](https://help.github.com/articles/getting-started-with-github-for-windows).
Alternatively, if you are comfortable using the command line, you can
download git from [this page](http://git-scm.com/download/win) If you
are using Linux, you will need to install git on your system through
your package manager, or from source code. A very thorough reference for
how git is used is available in a number of different formats
[here](http://git-scm.com/book).

Once you have installed git on your system, you will need to download
the document source. Just follow this procedure:

1.  Make sure you have git installed.

2.  On Windows systems, visit <https://github.com/dhis2/dhis2-docs> and
    press "Clone in Desktop". If you are using the command line, just
    type `git clone git@github.com:dhis2/dhis2-docs.git`

3.  The download process should start and all the documentation source
    files will be downloaded to the folder that you specified.

4.  Once you have the source, be sure to create your own branch for
    editing. Simply execute` git checkout -b mybranch` where *mybranch*
    is the name of the branch you wish to create.

## Editing the documentation { #docs_5 } 

Once you have downloaded the source, you should have a series of folders
inside of the repository directory. The documents are structured as follows:

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


  - For the sake of convention, place all chapters in a folder in the following format:

    `./src/commonmark/en/content/XXXX/<chapter>.md`

    where `XXXX` represents one of the thematic folders which are used to organize the documentation, and
    `<chapter>` is the filename referenced from the `*_INDEX.md` file.


### Using images

Image resources should be included inside a folder structure beginning with `resources`<!-- prevent processing -->`/images/` relative to the current document. e.g. for the chapter `content/android/android-event-capture-app.md`, the images are somewhere under `content/android/resources`<!-- prevent processing -->`/images/<rest-of-path>`.

This is important because the `resources`<!-- prevent processing -->`/images` string is used to identify images in the files. Images will be collected under `resources`<!-- prevent processing -->`/images/content/android/<rest-of-path>` relative to the master document, when the the files are pre-processed for generation. *The paths are partially reversed to ensure they remain unique when collecting images from multiple thematic folders.*


### Section references { #name_of_section } 

In order to provide fixed references within the document, we can set a fixed text string to be applied to any section. For our markdown docs this is done by adding a comment after the section heading in the form:
```
<!-- DHIS2-SECTION-ID:name_of_section -->
```

where ```name_of_section``` is replace with the id you wish to use.

For example:
```

## Validation { #webapi_validation } 

To generate a data validation summary you can interact ...
```

Will set the section id of the level 2 heading **Validation** to "webapi_validation", which may then be referenced as "#webapi_validation" within the html file.

After the full html file is generated, it is post-processed and the first ```DHIS2-SECTION-ID``` after the start of the section is used as the section id.

Please follow the convention of lowercase letters and underscores, in order to create id's that are also valid as filenames when the html files are split.

### Tables

As an extension to pure commonmark, we also support *GFM tables* (defined with pipes `|`), such as:

```
| Table Type | Description |
|:--|:----|
|Commonmark (HTML)| Tables described in pure HTML |
|Github Flavour Markdown (GFM)| Tables described with pipes: easier to read/edit, but limited in complexity|
```

which produces output like:

| Table Type | Description |
|:--|:----|
|Commonmark (HTML)| Tables described in pure HTML |
|Github Flavour Markdown (GFM)| Tables described with pipes: easier to read/edit, but limited in complexity|

For simple tables these are much more convenient for working with.
They are limited to single lines of text (i.e. each row must be on a single line), but you can, for example use `<br>` tags to create line breaks and effectively split up paragraphs within cells, if necessary.
You can also continue to use HTML tables when you really need more complexity (but you can also consider whether there is a better way of presenting the data).

## DHIS 2 Bibliography

Bilbliographic references are currently not supported in the markdown version of DHIS 2 documentation.


## Handling multilingual documentation { #docs_8 } 

The DHIS 2 documentation has been translated into a number of different
languages including French, Spanish and Portuguese. If you would like to
create a translation of the documentation or contribute to one of the
existing translations, please contact the DHIS 2 documentation team at
the email provided at the end of this chapter.


## Committing your changes back to GitHub { #docs_10 } 

Once you have finished editing your document, you will need to commit
your changes back to GitHub. Open up a command prompt on Windows or a
shell on Linux, and navigate to the folder where you have placed your
documentation. If you have added any new files or folders to your local
repository, you will need to add them to the source tree with the `git
add
` command, followed by the folder or file name(s) that you have added.
Be sure to include a descriptive comment with your commit.

`
git commit
-m
"Improved documentation on organisation unit imports with CSV."
`

Finally, you should push the changes back to the repository with `git
push origin mybranch`, where "mybranch" is the name of the branch which
you created when you checked out the document source or which you
happent o be working on. In order to do this, you will need the
necessary permissions to commit to the repository.When you have
committed your changes, [you can issue a pull
request](https://github.com/dhis2/dhis2-docs/pulls) to have them merged
with the master branch. You changes will be reviewed by the core
documentation team and tested to ensure they do not break the build, as
well as reviwed for quality. As mentioned previously, you can also push
your changes to your own GitHub repo, if you do not have access to the
main repo, and submit a pull request for your changes to be merged.

If you have any questions, or cannot find that you can get started, just
raise a question on our [development community of practice](https://community.dhis2.org/c/development).
