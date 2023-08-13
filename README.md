# Fedora Quick Docs

This is the content repository for the Fedora Quick Docs.

Please report Issues and submit Pull Requests for **Content Fixes** here.
Never done a pull request (or "PR")? Here's the [Pagure documentation for
Pull Requests](https://docs.pagure.org/pagure/usage/pull_requests.html).


General appearance issues and publishing issues should be reported against
the [Fedora Docs Website](https://gitlab.com/fedora/docs/docs-website/docs-fp-o).

## Reviewers needed!

Whether it is broken link, outdated screenshots of graphical user interface, technical and grammatical error in Quick Docs, every little contribution helps Fedora Linux users.

### Technical review

Some pages in this repository are in need of a technical review. Pages which need
one are marked by a disclaimer on the top of the file, right below the top level heading.
Any reviews are greatly appreciated. If you want to help, pick one of the pages, check it
for accuracy, and then:

* If you find that all information on the page is correct, either open a pull request which states that you found no problems and which removes the disclaimer from the top (the `include::`) statement at the top, or open an issue against this repository stating which page you reviewed and found no errors in so we can remove it
* If you find errors, then either open a pull request fixing them and removing the disclaimer from the top, or open an issue and describe the errors you found, and how to fix them if you know a fix

### New content creation and curation

Please refer to the guide from the links below.

* [Style guide](https://docs.fedoraproject.org/en-US/fedora-docs/contributing-docs/style-guide/)
* [Categories and tags](https://docs.fedoraproject.org/en-US/fedora-docs/contributing-docs/contrib-quickdocs/)

## How to edit these documents

Documentation in Quick Docs is written in AsciiDoc. It's a simple mostly-plain-text
markup language. You may want to look at:


* [AsciiDoc Syntax Quick Reference](http://asciidoctor.org/docs/asciidoc-syntax-quick-reference/)
* [AsciiDoc Writer's Guide](http://asciidoctor.org/docs/asciidoc-writers-guide/)
* [Antora Documentation](https://docs.antora.org/antora/1.0/page/)


## Local preview

This repo includes a script to build, watch and preview the contents of this repository.

**NOTE**: Please note that if you reference pages from other repositories, such links will be broken in this local preview as it only builds this repository. If you want to rebuild the whole Fedora Docs site, please see [the Fedora Docs build repository](https://gitlab.com/fedora/docs/docs-website/docs-fp-o) for instructions.

The script uses podman. Please make sure you have podman installed on your system (you can also use Docker, but on Fedora podman is recommended).

### Installing dependencies on Fedora
```
$ sudo dnf install podman inotify-tools
```

To build, watch and preview the site, run:

```
$ ./docsbuilder.sh
```

The result will be available at http://localhost:8080
and automatically regenerated when the repo contents change.
