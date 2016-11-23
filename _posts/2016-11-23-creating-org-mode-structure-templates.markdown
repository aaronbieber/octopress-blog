---
layout: post
title: "Creating Org Mode Structure Templates"
date: 2016-11-23T14:02:11-05:00
---

Hopefully you already know that you can insert common markup blocks in Org Mode
by entering a prefix like `<s` and pressing `<M-TAB>`. Org Mode publicly calls
these "Easy Templates" but internally calls them "structure templates." I wanted
to be able to insert a couple of other common Org-specific blocks, so I figured
out how to add my own. ~~MORE~~

Org Mode supports a few "blocks," which you can read about beginning on the
[Blocks page][doc-blocks] of the Org documentation.

[doc-blocks]: http://orgmode.org/manual/Blocks.html

For example, if you want to insert a block of Emacs Lisp code into an Org
document, you would write a block that looks like this:

```
#+BEGIN_SRC emacs-lisp
(defun org-xor (a b)
    "Exclusive or."
    (if a (not b) b))
#+END_SRC
```

It can be hard to remember, and tedious to type, the `#+BEGIN_SRC` bit, so Org
includes this expansion capability that it refers to in its documentation as
[Easy Templates][easy-templates], but that is referred to in its source code as
"structure templates."

Getting straight to the point, I use the export features of Org Mode quite
often, especially export to HTML (mostly for pasting into other formatted
mediums such as email) and LaTeX/Beamer (for quick one-off slide decks). I
usually write content directly into my "notes" file and then export a single
subtree.

Exporting a subtree is very easy, simply trigger export with `C-c C-e`, toggle
"export subtree" on with `C-s`, and press the appropriate export format buttons,
like `h o` for "export as HTML and open in the default browser."

{% infobox %}
If you're a pro like me, you have set `org-export-initial-scope` to `subtree` so
that you can skip the second step.
{% endinfobox %}

Let's take HTML as an example. The default export settings when you export to
HTML are crude at best. For one thing, the title of the document will be the
subtree's title, which is not always what you want. Worse, the filename of the
HTML file will be the filename of the *entire file* the subtree is in. So
essentially I wound up with a `notes.org.html` over and over.

You can fix that by adding some export options, and for subtree exports you put
those into a property drawer. For me, that looks like this:

```
* Test Subtree Export
  :PROPERTIES:
  :EXPORT_FILE_NAME: actually-use-this-filename
  :EXPORT_TITLE: My Fascinating HTML Export
  :EXPORT_OPTIONS: toc:nil html-postamble:nil num:nil
  :END:
```

In this workflow there are two things that are annoying:

1. I hate typing out `:PROPERTIES:`, and I use property drawers a lot. There is
   an Org function for this (`org-insert-property-drawer`), but I'm running out
   of good key bindings so I didn't want to make another one for this.

2. I'm not going to be able to memorize the precise format of all of my HTML
   export settings, let alone `toc:nil html-postamble:nil num:nil`.

This is where a structure template comes in handy.

## The Goal ##

The goal is to be able to type something like `<p` and press `<TAB>` to insert
the property drawer, and then something like `<eh` (for **e**xport **h**tml) and
press `<TAB>` to insert my default HTML export options.

{% infobox %}
Structure templates are inserted as part of the `org-cycle` function, and so I
have bound `org-cycle` to `<TAB>` in my config. If `<TAB>` doesn't work for you,
but `<M-TAB>` does, this is probably why.
{% endinfobox %}

On the [Easy Templates][easy-templates] manual page, it says:

> You can install additional templates by customizing the variable
> `org-structure-template-alist`. See the docstring of the variable for
> additional details.

[easy-templates]: http://orgmode.org/manual/Easy-Templates.html

So this should be easy, we just need to add a new value to this list.

## Create a New Template ##

The format of `org-structure-template-alist` is like this (abridged):

```
(("s" "#+BEGIN_SRC ?\n\n#+END_SRC" "<src lang=\"?\">\n\n</src>")
 ("e" "#+BEGIN_EXAMPLE\n?\n#+END_EXAMPLE" "<example>\n?\n</example>")
 ("q" "#+BEGIN_QUOTE\n?\n#+END_QUOTE" "<quote>\n?\n</quote>")
 ...)
```

This is an *association list* so each element of the outer list is a list with
at least two elements. The first element is the letter to follow `<` in your
template expansion trigger. The second element is the template itself, with a
`?` where the cursor should wind up at the end.

Most of the defaults have a third value, which is an "Emacs Muse"-style
template. Muse is some kind of authoring system for Emacs that I know nothing
about and don't care about. You don't need a third element for this to work, so
just ignore it.

Cool, so we just add a new element to this list defining our template. Let's do
the `:PROPERTIES:` one:

```cl
(add-to-list 'org-structure-template-alist
             (list "p" (concat ":PROPERTIES:\n"
                               "?\n"
                               ":END:")))
```

{% infobox %}
Note that I am using the `list` function rather than a quoted list because I
need Emacs to evaluate the return value of the `concat` function within the
list. I am only using `concat` here to make the code more legible because the
template string is multiple lines long. I like pretty code.
{% endinfobox %}

You can evaluate this expression by placing your cursor outside of the last
closing parenthesis and calling `eval-last-sexp` (which I have bound to `C-RET`
for just such an occasion).

Once you have evaluated that expression, the template should work right away!
Open an Org file, enter `<p` on its own line, and hit `<M-TAB>` (or `<TAB>` if
you bound `org-cycle` to it as I have).

## But Longer Shortcuts Though? ##

If you read the source code of the function `org-try-structure-completion`, you
will notice that the regular expression will match *one or more letters*, so
even though Org only ships with one-letter expansion triggers, you can create
longer ones if you want to.

Here is my HTML export options template:

```cl
(add-to-list 'org-structure-template-alist
             (list "eh" (concat ":EXPORT_FILE_NAME: ?\n"
                                ":EXPORT_TITLE:\n"
                                ":EXPORT_OPTIONS: toc:nil html-postamble:nil num:nil")))
```

Now I can do `<p<TAB>` and then immediately `<eh<TAB>` and I'm all ready to add
a filename and a title and export this subtree to HTML!

Have any bright ideas for new Org Mode structure templates? Leave them in the
comments below!
