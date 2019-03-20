# Fedora Quick Docs

This is the content repository for the Fedora Quick Docs.

Please report Issues and submit Pull Requests for **Content Fixes** here.
Never done a pull request (or "PR")? Here's the [Pagure documentation for
Pull Requests](https://docs.pagure.org/pagure/usage/pull_requests.html).


General appearance issues and publishing issues should be reported against
the [publishing software](https://pagure.io/fedora-docs/docs-fp-o).

## Rewievers needed!

As discussed in [issue #107](https://pagure.io/fedora-docs/quick-docs/issue/107),
a lot of pages in this repository are in need of a technical review. Pages which need
one are marked by a disclaimer on the top of the file, right below the top level heading.
Any reviews are greatly appreciated. If you want to help, pick one of the pages, check it
for accuracy, and then:

* If you find that all information on the page is correct, either open a pull request which states that you found no problems and which removes the disclaimer from the top (the `include::`) statement at the top, or open an issue against this repository stating which page you reviewed and found no errors in so we can remove it
* If you find errors, then either open a pull request fixing them and removing the disclaimer from the top, or open an issue and describe the errors you found, and how to fix them if you know a fix

## How to edit these documents

All of this is written in AsciiDoc. It's a simple mostly-plain-text
markup language. You may want to look at:


* [AsciiDoc Syntax Quick Reference](http://asciidoctor.org/docs/asciidoc-syntax-quick-reference/)
* [AsciiDoc Writer’s  Guide](http://asciidoctor.org/docs/asciidoc-writers-guide/)
* [Antora Documentation](https://docs.antora.org/antora/1.0/page/)


## Local preview

This repo includes scripts to build and preview the contents of this repository.

**NOTE**: Please note that if you reference pages from other repositories, such links will be broken in this local preview as it only builds this repository. If you want to rebuild the whole Fedora Docs site, please see [the Fedora Docs build repository](https://pagure.io/fedora-docs/docs-fp-o/) for instructions.

Both scripts use docker, so please make sure you have it installed on your system. Please see below for instructions.

To build and preview the site, run:

```
$ ./build.sh && ./preview.sh
```

The result will be available at http://localhost:8080

### Installing docker on Fedora

```
$ sudo dnf install docker
$ sudo systemctl start docker && sudo systemctl enable docker
```
