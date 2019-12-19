# Mkdocs plugin: `edit_url`

## TL;DR

Mkdocs plugin to read metadata's 'edit_url' field.

This plugin will read a page's metadata to search for a field
called 'edit_url' and will force to use that value when generating the
docs as the edit_url (behind the edit button).
field

## Usage

Include this plugin in your documentation repository inside a `plugins/` directory.

Finally, load it in your `mkdocs.yml` configuration file as such:

```yaml
plugins:
  - edit_url
  - ...
```
