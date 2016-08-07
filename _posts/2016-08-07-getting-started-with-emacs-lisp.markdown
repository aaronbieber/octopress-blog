---
layout: post
title: "Getting Started With Emacs Lisp"
date: 2016-08-07T15:47:38-04:00
---

As you certainly know by now, I was an outspoken and enthusiastic Vim user for
about 15 years. During that time, I tried Emacs a couple of times, but it didn't
really stick until last year. One of the reasons Emacs makes me so happy is its
Lisp-based extension language (Emacs Lisp, or just Elisp for short).

I do not have a formal background in computer science, so I never had the
experience of being forced to do exercises in Scheme or Lisp; Elisp is the first
(and only) Lisp I've ever learned. For that reason, I'm sure I went about it all
wrong, but I think I know it pretty well now and I want to share with you some
of the tricks and concepts I've learned so you can hopefully have an easier time
than I did.

Introductory Lisp articles abound, so I will try to focus on the Emacs features
and functions that make Elisp development unique.~~MORE~~

## Lisp Interaction Mode ##

The best way I've found to start playing with Elisp or to experiment with
creating new functions is to use the aptly named "scratch buffer." When you
start Emacs, a scratch buffer is always created for you, and its name is,
appropriately, `*scratch*`.

The scratch buffer is set to Lisp Interaction Mode, which is derived from Emacs
Lisp Mode, which itself is derived from Prog Mode (the parent of all
"programming" modes). Lisp Interaction Mode changes only a couple of things from
Emacs Lisp Mode, but its intent is to make it easier to type in and actually
interact with Emacs Lisp code.

This mode will become your best friend as you begin to find your way around the
expansive world of the Emacs Lisp language.

## Essential Bindings ##

There are a few massively useful functions available in Lisp Interaction Mode
that you really need easy key bindings for, because you will use them all the
time. The first is `eval-last-sexp`, which evaluates the S-expression (or
"sexp") right before the cursor. I have two bindings for this one, which I'll
talk a little bit about.

First, for any Emacs user, I think that `<C-return>` is a nice key combo for
this.

```cl
(define-key lisp-interaction-mode-map (kbd "<C-return>") 'eval-last-sexp)
```

For Evil Mode users out there, it is important to note that `eval-last-sexp`
evaluates the expression immediately _behind_ point, which means it only works
predictably while in insert mode (when the cursor is a pipe style and you can
see which character is immediately behind it).

For that reason, I have an insert mode binding to run `eval-last-sexp`, but I
use the same key in normal mode to run `eval-defun`, which evaluates the entire
function definition that point is within the bounds of.

```cl
(evil-define-key 'insert global-map (kbd "s-d") 'eval-last-sexp)
(evil-define-key 'normal global-map (kbd "s-d") 'eval-defun)
```

Finally, Lisp Interaction Mode by default binds `C-j` to another useful
function, `eval-print-last-sexp`, which evaluates the S-expression behind point
and then _prints its return value into the buffer_. This is really handy for
debugging things.

## A Contrived Example ##

Often, before I even set about writing a new function, I want to prove that I
can accomplish some task or that I can find existing functions to glue together
that will do what I need. Lisp Interaction Mode is a perfect platform for this
exploration.

As an example, let's pretend that we want to write a function to count the
frequency of words used in a buffer. The result of the function should be an
*association list* ("alist" for short) where the keys are the words in the
buffer and the values are the counts of how many times each word appears.

The basic approach that I think I want to use, without writing any code yet, is:

1. Create an empty alist, then
2. From the beginning of the buffer,
3. Search forward for a word using a regular expression search, and
4. If the word is already in our alist, increment the count, otherwise
5. Add the word to the alist with a count of 1.
6. Finally, return the alist sorted in descending order by frequency.

To do this, I know I need a few functions based on my prior experience. At a
minimum, I probably need:

* `save-excursion` to let me move around in the buffer without leaving point or
  mark in different locations after I'm done. This isn't critical for the
  function to work, but it's polite to use it.

* `let` to bind some local variables to use.

* `re-search-forward` to perform the regular expression search.

* `push` to build up an association list.

* `reverse` and `sort` to do the sorting at the end.

I remember most of these function names because I've used them before, but I
usually don't remember the exact arguments they take. That's OK, though, because
Emacs Lisp is self-documenting and all of the standard library functions are
extremely well-documented.

A good example here is `re-search-forward`, which takes several arguments, and I
can't remember the order. Look up the function by typing `C-h f
re-search-forward RET`. Your eyes will rapidly glaze over with a layer of real
human tears as you behold a split window containing a practical explanation of
how this function operates.

OK, let's start with a very rough little expression that we can use to prove
that this idea works.

```cl
(save-excursion
  (goto-char 0)
  (re-search-forward "\\w+" (point-max) t)
  (match-string-no-properties 0))
```

This expression saves the location of point, moves to the very beginning of the
buffer, searches forward for a "word" (using a naive pattern matching any
sequence of one or more word characters), and then returns the matched string
with no text properties.

Just a few minor points here:

* I mess around with the contents of `*scratch*` all the time while
  testing. It's probably a good idea to go ahead and make the buffer start with
  a single word before running this code.
* I didn't describe all of the arguments to `re-search-forward`, but I showed
  you how to look up functions. Hint hint.
* The same goes for `match-string-no-properties`.

You can now run this code in two ways. First, you can position point at the end
of the expression (at the end of the last line), (if you're an Evil user,
make sure you're in **insert mode**), and press `C-<return>` (using my binding
from up above). The result will be printed in the minibuffer.

Second, you can press `C-j` and the result will be printed into the buffer
itself. This is useful if you want to grab that value and actually use it for
something else. Most of the time, I use `C-<return>`.

If you evaluate this expression with `C-<return>`, the first word in the buffer
should be printed in the *minibuffer*.

## Debugging ##

We now have a piece of code that can find the first word in the buffer, so the
next step is to see if we can find *all* of the words in the buffer. To do this,
let's evaluate the search as part of a *while loop*. I think this will work:

``` cl
(save-excursion
  (goto-char 0)
  (while (re-search-forward "\\w+" (point-max) t)
    (match-string-no-properties 0)))
```

The only problem is, if you run this piece of code, it will happily go about its
business matching words (hopefully) and give you no feedback at all. Well, if it
works perfectly, it will finally return the very last word matched, but there is
a lot of uncertainty there.

Rather than being uncertain, I always prefer to be certain. The simplest way to
reach certainty with this loop is with *a crash course in the Elisp debugger*.

We can trigger the debugger by calling `debug`, so let's do that within the
loop:

``` cl
(save-excursion
  (goto-char 0)
  (while (re-search-forward "\\w+" (point-max) t)
    (debug)
    (match-string-no-properties 0)))
```

When you evaluate this statement, the debugger window will open
immediately. There are only a couple of keystrokes in the debugger that you need
to know, and those are:

* `d`: Step through
* `c`: Continue
* `e`: Eval expression
* `q`: Top level (debugger code word for "quit")

There are several other commands, and as always you can learn about them by
pressing `C-h m` from the debugger window to open the help for the current
mode.

When you enter the debugger, the `(while)` expression is at the top of the stack
(because you broke within in). Press `d` repeatedly to step through the code and
observe the return values of each expression.

To prove that our code works, we can press `d` to step into the
`match-string-no-properties` call. Pressing `d` again steps into
`buffer-substring-no-properties`, which is used internally to get the text from
the buffer, and then pressing `d` a third and final time reveals the return
value of the expression on the top line of the debugger. Hopefully that is the
first word in your scratch buffer!

You can repeat this process a couple of times to see that the while loop is
matching subsequent words in the buffer. **Certainty restored!**

## Building the Association List ##

The final piece of the puzzle is to accumulate the counts of these words in an
association list that we can ultimately sort and return. Elisp does have support
for a proper hash table data structure, but for this toy it seemed too heavy, so
I went with the association list approach.

There are a couple of caveats that I'll try to explain, but the point of this
exercise is not to learn all of the ins and outs of Elisp, but rather to give
you the tools you need to figure things out for yourself.

Before going any further, I'd like to introduce you to a little guy called
`let`. You will see `let` used all the time in Elisp code and it's important to
understand what it does. The `let` form allows you to bind variables that only
retain their values within that form. As an example:

```cl
(let ((foo "Hello")
      (bar "World!"))
  (message "%s %s" foo bar))

(message foo)
```

Evaluating the first expression will print "Hello World!" in the minibuffer, but
if you evaluate that entire block, the second form will result in an error
because the symbol `foo` is not bound to any value outside of the `let`
form. This gives you a way to create, essentially, "local" variables. It is
polite to do this so that you don't clutter Emacs' symbol table with temporary
stuff.

We'll use `let` to create a variable to hold our return value (which we'll call
`words`), and then in each loop we'll either increment the value of the word's
existing count or we'll push the new word onto the list.

Here's what the final function looks like:

```cl
(let ((words))
  (save-excursion
    (goto-char 0)
    (while (re-search-forward "\\w+" (point-max) t)
      (let ((word (match-string-no-properties 0)))
        (cl-incf (cdr (or (assoc word words)
                          (first (push (cons word 0) words)))))))
    (reverse (sort words (lambda (a b) (< (cdr a) (cdr b)))))))
```

There are a couple of things worth explaining, but I'll leave the rest of the
code interpretation as an exercise for the reader.

`cl-incf` is a _Lisp macro_ provided by a library called `cl-lib.el`. This
library provides a ton of useful functions that are found in the more powerful
Common Lisp language and many Emacs packages depend on it. `cl-lib.el` is now
part of Emacs, so you can freely use these macros and functions.
 
{% infobox %}
Many of the functions and macros in `cl-lib.el` are also aliased to their names
without the `cl-` prefix (e.g. `incf`). _You are strongly encouraged_ to use the
`cl-` prefixed versions! Some day the aliases may be deprecated, so heed my
warning.
{% endinfobox %}

Congratulations, you just built an Elisp expression that returns a sorted word
frequency for the current buffer. This is useful, but you'll probably want to be
able to run this code on demand, either by pressing a key or through a menu. To
do that, we should put it into a function.

## Creating Functions ##

Creating a function is very easy with the `defun` macro; you simply wrap up your
S-expression and provide a list of arguments and a documentation string and
you're off to the races.

Here is what ours might look like:

```cl
(defun air--get-word-frequency ()
  "Return an alist with counts for all words in the current buffer."
  (let ((words))
    (save-excursion
      (goto-char 0)
      (while (re-search-forward "\\w+" (point-max) t)
        (let ((word (match-string-no-properties 0)))
          (cl-incf (cdr (or (assoc word words)
                            (first (push (cons word 0) words)))))))
      (reverse (sort words (lambda (a b) (< (cdr a) (cdr b))))))))
```

If you evaluate this expression, the function `air--get-word-frequency` will be
created, and you'll be able to look up its definition with `C-h f
air--get-word-frequency RET` just like any other function.

There is no "return" statement in Elisp; functions return the last value
evaluated, so in this case the result of evaluating `reverse` becomes the
function's return value.

Note that I have used my typical `air` prefix, which helps keep my functions
separate from those of Emacs itself and all of my installed packages. If you're
writing code to share, it's polite to use a unique prefix string of some kind.

You'll also notice that I have used two hyphens after my unique prefix. This is
an Elisp convention that indicates that this function is not meant to be used
outside of its package. I have done this because this function returns a raw
alist; it isn't very useful to call on its own, and Emacs will truncate that
data when displaying it to you.

To make this function more useful, let's make a separate function that we can
call from a key binding that will display the results in a human-readable
way. This will also introduce some other wonderful Elisp helpers.

## Interactive Functions ##

This is what our callable function looks like:

```cl
(defun air-show-word-frequency ()
  "Display a word frequency analysis for the current buffer."
  (interactive)
  (let* ((buf (get-buffer-create "*Word Frequency*"))
         (word-freq (air--get-word-frequency))
         (text (concat "Word\t\tCount\n----\t\t-----\n"
                       (mapconcat (lambda (word)
                                    (format "%s\t\t%s" (car word) (cdr word)))
                                  word-freq "\n"))))
    (with-current-buffer buf
      (erase-buffer)
      (insert text)
      (goto-char 0))
    (pop-to-buffer buf)))
```

There are some new and interesting things going on here, and I invite you to
explore and experiment, but I will explain the most important ones.

* The `interactive` call immediately after the docstring is **required** if
  you wish to call this function from a key binding. For more information about
  this interesting and useful function, press `C-h f interactive RET`.

* I am using a modified form of `let` called `let*`. The star version forces
  each symbol assignment to occur *in the order written*. Note that the value of
  `text` refers to the value of `word-freq`; if you do not use a `let*` form,
  you can (and likely will) get "unbound symbol" errors.
  
You will notice right away that I'm creating a new buffer for this. Buffers are
like the national currency of Emacs; they are used for much more than simply
displaying information to the user, although that is one of their primary
functions.

The `with-current-buffer` form is a convenient way to evaluate expressions with
the named buffer temporarily "current." Functions like `insert` operate on the
current buffer, so this gives you a way to say "go run all of these things
against the other buffer, then set everything back the way it was."

Now you can go ahead and bind a key to this function, if you want. You would
accomplish that using `define-key`, for example, like this:

```cl
(define-key global-map (kbd "C-c w c") 'air-show-word-frequency)
```

You can evaluate that expression and then press `C-c w c` to show the word count
for the current buffer.

## Congratulations! ##

You've made it through another **2,900 words** about Emacs! Your dedication and
attention are literally awe-inspiring.

If you have followed along closely, you now know how to:

* Interact with Elisp code live, within Emacs,

* Debug Elisp code interactively using Debugger Mode, and

* Define Elisp functions that you can call from other functions and
  interactively from key bindings

You should also have learned some new Elisp tricks for working with alists,
buffers, and more! There are so many functions in the standard library that it
will take you some time to get comfortable. Always remember to use the `C-h f`
menu to search for commands (this is easier if you're using Helm, _which you
really should be_).

If I've left any stones un-turned, please leave a comment below. Do me a favor,
though, and explore on your own before asking for Elisp help; I'm happy to
provide assistance, but try Google first!
