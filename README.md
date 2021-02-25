# DHIS 2 Documentation

All of your favourite documentation - in markdown format!

# Updating the documents
This is the easy bit, and is all that most people have to do. The following sections describe the format, structure and a few considerations necessary for correctly generating the desired output.

## Format and editing
The documents are maintained in [commonmark](https://commonmark.org/help/) markdown format, with an `.md` extension.

Editing documents is as simple as editing a text file. Many IDEs have markdown support, including live previews. For Linux and Windows, [ghostwriter](https://wereturtle.github.io/ghostwriter/) is a nice option; it is free and supports side-by-side preview and custom stylesheets.


### Structure

The structure of the documentation site is defined in the build repository [dhis2-docs-builder](https://github.com/dhis2/dhis2-docs-builder).

> **Tip**
>
> The best way to find the source of the document you wish to edit is to find the document on the docs.dhis2.org website and click the "Edit" icon at the top of the page.


### Adding images

Image resources should be included as relative paths inside a sub-folder relative to the current document. e.g. for the chapter `content/android/android-event-capture-app.md`, the images are somewhere under `content/android/resources/images/<rest-of-path>` and are referenced like `[](resources/images/<rest-of-path>)`

#### Styling images

If you want to control the alignment and size of images, you can take advantage of a markdown extensionthat we use. It allows you to set attributes such as width, height and class in curly brackets at the end of the image definition. For example:
```
![](resources/images/maintainence/predictor_sequential.png){ width=50% }
```
will make your image 50% of the page width (it is best to use percentages to support a variety of output forms), while
```
![](resources/images/maintainence/predictor_sequential.png){ .center width=50% }
```
will also centre the image on the page (due to the definition of the `.center` class in css).

When images are written like
```
![Approving and accepting](resources/images/data_approval/approval_level_steps.png)
```
i.e. with caption text in the square brackets, they are rendered as figures with captions. These are centred by default, with a centred, italicised caption.

#### Taking screenshots

For screenshots of the DHIS 2 web interface, we recommend using Chrome browser, with the following two extensions:
1. [Window Resizer](https://chrome.google.com/webstore/detail/window-resizer/kkelicaakdanhinjdeammmilcgefonfh?hl=en). Use this to set the resolution to **1440x900**
2. [Fireshot](https://chrome.google.com/webstore/detail/take-webpage-screenshots/mcbpblocgmgfnpjjppndjkmgjaogfceg?hl=en). Use this to quickly create a snapshot of the **visible part**

> *Fireshot can even capture the full page, i.e. scrolled, if desired. It can also capture just a selected area (but the maximum width should always be 1440px)*

When taking screenshots of the Android app, size should be set to **360x640**.

### Section references

In order to provide fixed references within the document, we can set a fixed text string to be applied to any section. For our markdown processor this is done by adding a hash id in curly brackets at the end of the line with the section title, e.g.
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

> **Important**
>
> **Please try to use GFM tables** as they give much better support for translations.  
> You can also continue to use HTML tables when you really need more complexity (but you can also consider whether there is a better way of presenting the data).


### INCLUDES

`!INCLUDE` directives can be used to include the contents of another markdown file into the current one.

```
!INCLUDE "../other_directory/other_file.md"
```

Use relative links for `!INCLUDE` directives.

> **NOTE**
>
> the `!INCLUDE` directives are not part of pure commonmark format, but are used in pre-processing to build the master documents.


### "DHIS2" or "DHIS 2", that is the question

Historically, the correct form is "DHIS 2" when referring to the software system in normal written text. For convenience, some variables, paths, etc. use the compact form, and they should, of course, be respected in the documentation. **Note that we are now moving towards applying the compact form "DHIS2" consistently across documentation**.


# Building the documents

See the build repository [dhis2-docs-builder](https://github.com/dhis2/dhis2-docs-builder) for information about biulding the documents
