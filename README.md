# Fedora Quick Docs

This is the content repository for the Fedora Quick Docs

Please report Issues and submit Pull Requests for **Content Fixes** here.  General appearance issues and publishing issues should be reported against the [publisher](https://pagure.io/fedora-docs/docs-fp-o).

Look for easy edits in the _topic_map.yml.  The files commented out need your help.

## How to edit this document

This document set is coded in AsciiDoc.  The content is in the en-US directory.  There is a shared entity file in the en-US directory.  Do not edit the content in the Common_Content directory.

## Testing your changes locally

To test your changes, first install `asciibinder`

$ gem install ascii_binder

To build your changes, from the root directory:

```
$ asciibinder package
$ firefox _package/main/index.html
```
