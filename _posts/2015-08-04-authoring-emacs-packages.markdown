---
layout: post
title: "Authoring Emacs Packages"
date: 2015-08-04T10:45:48-04:00
---

Have you extended Emacs in a novel way? Do you want to share your creation with
the wide world of Emacs users? Well then, you will need to learn how to create a
proper Emacs package.

Packaging for Emacs is generally pretty easy and there is a lot of help
available, both within Emacs itself and obviously on the Internet. There are a
few things, though, that are conspicuously and annoyingly hard to find help with
so I decided to document them for you.

Come with me and learn how to create an Emacs Package from scratch.~~MORE~~

An Emacs package, at its most basic level, is just an Elisp file. For a long
time, authors simply distributed ".el" files via their own websites or FTP sites
and you were on your own to download them, put them somewhere on your local
drive, and make sure that Emacs could find them.

As you probably know, this isn't how it's done today. Now we have interactive
package management built right into Emacs. Thanks to Tom Tromey, who originally
wrote `package.el`, there is a standard and it has been broadly adopted. Which
brings me to...

## Package Repositories ##

If you already know about repositories and want to get down to it, skip over
this section.

If you want to build a package for Emacs right now, you probably want to target
a popular Emacs package repository. The "official" repository is ELPA (Emacs
Lisp Package Archive), but contributing to ELPA requires that you complete a
Free Software Foundation copyright assignment document and also requires your
software to comply with FSF copyright and licensing rules. If you wind up
writing something that is amazingly popular and could end up being packaged
within Emacs, you will have to cross that bridge. Until then, there are
alternatives.

The two other most popular repositories are MELPA and Marmalade. I will very
briefly explain the difference.

MELPA, or "Milkypostman's Emacs Lisp Package Archive," was started by Donald
Curtis (milkypostman on Github and elsewhere) but is also maintained by Steve
Purcell. The great benefit of MELPA is that all submissions are reviewed by
Steve or Donald and must meet some bare minimum of packaging standards before
being merged. I've submitted two packages to MELPA and found the experience
helpful and even pleasurable.

Marmalade was started by Nic Ferrier and is a bit more like the wild west; you
can get an account on the site, which then gives you access to upload
packages. Provided that you meet some formatting requirements (which I'll
explain below), your package is in.

I suppose you could think of Marmalade as a self-service repository and MELPA as
a bit more of a curated collection. MELPA strives to offer packages that don't
overlap and that provide meaningful and useful functionality to Emacs. Marmalade
is an infrastructure for centralizing the distribution of packages for authors
who don't want to go through the ELPA legal process.

## Anatomy of a Package ##

As I said at the start, the bare minimum Emacs package is a single Elisp file,
ending in the file extension `.el`. To distribute a single Elisp file, though,
is impolite in this modern world; you should probably have at least:

1. One or more Elisp files (both of my packages are single files).
2. A README file; if you use Github, this is your Github landing page content.
3. An Info manual.

Of course, you may not need nor want a full Info manual if your package is quite
simple, but figuring out how to author and distribute my package documentation
in Info format was one of the most frustrating experiences that I encountered,
so I will explain how it can be done.

Before I get to that, though, let's talk about basic packaging requirements.

## Package Formatting ##

Elisp scripts included in a package have some annotation requirements. These
requirements, mostly concerning comments at the top of the files, are described
in the Packaging chapter of the Emacs Info documentation. You can find it by
pressing `C-h i` to open the Info reader and navigating to the "Elisp" manual,
then the "Packaging" chapter within it. For the quite lazy, you can also
[read the manual online][el-pkg]

One of the things that Emacs documentation isn't great at is providing
examples of real use. To save you a bit of time decrypting the standards, here
is the bare minimum annotation you should add to your script files, lifted from
my Octopress package:

````
;;; octopress.el --- A lightweight wrapper for Jekyll and Octopress.

;; Copyright (C) 2015 Aaron Bieber

;; Author: Aaron Bieber <aaron@aaronbieber.com>
;; Version: 1.0
;; Package-Requires ((cl-lib "0.5"))
;; Keywords: octopress, blog
;; URL: https://github.com/aaronbieber/octopress.el

;;; Commentary:

;; Octopress.el is a lightweight wrapper script to help you interact
;; with Octopress blog site and the related Jekyll programs. This
;; package is designed to be unobtrusive and to defer to Octopress and
;; Jekyll as often as possible.

;; This package was built with the assumption of Octopress 3.0 and
;; will probably not work with previous (non-gem) versions of
;; Octopress. Specifically, it expects to be able to use commands like
;; `octopress new post` rather than the old-style `rake new_post[]`.

;; Full documentation is available as an Info manual.

;;; Code:
````

Quite often, package authors include a license in this preamble. In this case, I
opted for the simple copyright statement and will add specific license text
later. If you submit your package to MELPA, the build system will lift a few
bits from this heading to create your package's landing page on melpa.org. The
URL and "Commentary" section are important in that respect.

Here is what this looks like [on melpa.org](http://melpa.org/#/octopress). (NB:
I might have changed the actual file since this post was written, but you can
always read the real source code.)

Finally, the very last line of your file should be:

````
;;; octopress.el ends here
````

Where the "octopress.el" piece matches the very first line, of course.

### Getting Help ###

There are many more style conventions that you should follow in your actual
Elisp code; too many to describe here. The easiest way to make sure your package
fits nicely within the Emacs ecosystem is to install both "flycheck," the
on-the-fly syntax checker, and "flycheck-package," a checker for Elisp package
authors. With "flycheck-mode" activated and "flycheck-package" configured, you
will get live warnings in your script files when you've done things wrong.

[el-pkg]:http://www.gnu.org/software/emacs/manual/html_node/elisp/Packaging.html

## Read Me ##

Though it's slightly irritating to keep several versions of documentation in
sync, each are important. The "Commentary" block is used by Emacs itself and the
packaging systems and repositories; the README file is used by Github, of
course; and the Info manual (described in the next section) is read by humans.

It's polite to include a README file with any source code you distribute. The
README has become such an entrenched convention that Neal Stephenson even wrote
a book whose title, "Reamde," parodies the concept. If you use Github, as it
seems safe to presume that you do, the README is parsed and displayed on the
landing page of your project.

If you don't use Github, or don't care what your Github landing page looks like,
you can skip the README file if you like. Historically, Emacs packages are
documented solely within the "Commentary" sections of their source files, and
that seems perfectly adequate to me.

Of course, if you do provide a README file for use by Github, you can hint its
format with a file extension like ".md" or ".markdown" so that Github parses the
file into rich HTML and give your visitors the pleasure of some actual formatting.

## Building Documentation ##

The standard format for Emacs packages (and Emacs itself, and basically every
other GNU package) is Info. You can read about the Info format on the
[Stand-alone GNU Info][gnu-info] manual page.

### What Is Info? ###

Info itself is a text-based format providing cross-referencing, hierarchical
organization, and some other features. To create a manual in Info format, you
compose it in Texinfo format and use the `makeinfo` program to convert it to
Info. Texinfo was designed to yield many formats, so an added benefit is that
you can use `makeinfo` to make an HTML format manual as well.

All of the GNU manual pages I've linked to online are HTML versions of their
original Texinfo documents, and can be read directly within Emacs or with the
standalone `info` reader in Info format.

### Creating Your First Manual ###

As I explained above, manuals are distributed in Info format, but the best way
to get your manual into the hands of your end user is to insert a directory
entry in the main Emacs Info contents page (the page reached with `C-h i`). To
do this requires a little fiddling, but the MELPA build system will take care of
it for you if you simply include your manual in Texinfo format.

My recommendation is to target MELPA for distribution and include your manual in
Texinfo format. There are two major advantages here:

* For you, it makes the distribution easier; MELPA's build system will convert
  your Texinfo manual to Info format and generate the directory stub file that
  Emacs looks for when installing packages.
* For ambitious end users, it allows you to include only the original Texinfo
  file in your source control repository; anyone could take that and build other
  formats for themselves if they have preferences about how to read documentation.

It's also, in my opinion, bad practice to include generated files in source
control, especially when the distribution targets platforms that necessarily
have the build mechanisms. Emacs ships with `makeinfo`, so there is really no
reason to go do that transformation yourself and bundle its output.

OK, so how do you create this ".texi" file? Easy, just learn Texinfo format!
Don't worry, in spite of its familiar prefix, Texinfo is a lot simpler than
LaTeX, and you only need a few pieces of boilerplate to make a manual that
converts nicely into Info or HTML formats.

### Texinfo Crash Course ###

Texinfo format provides special keywords that start with "@" symbols. These
keywords can be single identifiers, like `@settitle`, which sets the title of
the document, or block pairs, like `@titlepage` / `@end titlepage`, where the
content between the start and end symbols has some special meaning.

To get started writing a Texinfo manual for your package, create a new file in
the root of your package with the extension ".texi". It's customary to give it
the same base name as your package. For example, if your package is called
"superfrobnicator," your manual would be called "superfrobnicator.texi".

Great, so what do you put in this file? Texinfo format is described in detail in
[its online manual][texinfo]. Of particular importance is the section titled
"Beginning a Texinfo File."

If you are authoring your Texinfo file in Emacs itself, which is certainly
recommended, you can make use of "Texinfo Mode," which gives you some handy
shortcuts. Provided that you have `makeinfo` in your path, which you should, you
can press `C-c C-m C-b` to "make" the whole buffer. This will run the contents
of the current buffer through `makeinfo` with an Info format target, and open
the resulting Info document in a new buffer within Emacs. You can proofread,
navigate, and see what your end-user's experience will be like.

Once you're satisfied, just commit the ".texi" file into source control so that
it's included with the package destined for MELPA and let MELPA's build process
take care of the rest! Users who install your package from MELPA will have your
package's documentation linked from the main Emacs Info page.

There are a few caveats to how this all comes together, so make sure to run a
local MELPA build as described in the "Contributing to MELPA" section of MELPA's
own README so that you can see any warnings or errors that might be thrown. In
particular, there are certain expected values for tags like `@dircategory` and
`@direntry` and certain acceptable formats. Everything is described in the
documentation for Texinfo.

[gnu-info]:http://www.gnu.org/software/texinfo/manual/info-stnd/info-stnd.html#Top
[texinfo]:http://www.gnu.org/software/texinfo/manual/texinfo/texinfo.html
