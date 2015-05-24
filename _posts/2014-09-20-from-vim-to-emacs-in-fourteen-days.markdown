---
title: From Vim to Emacs in Fourteen Days
layout: post
date: 2015-05-15 09:01:25 -0400
comments: true
categories: 
published: false
---

Yes, my friends, it is true. After more than fifteen years using Vim, teaching
Vim, proselytizing about Vim, all the while scoffing in the general direction of
Emacs, I've seen the light. The light of Lisp... Or something.

In this post, I am going to illustrate the high points of what is necessary to
make Emacs behave so much like Vim you'll almost forget it's Emacs, except when
it does something so awesome you'll wonder why you didn't try it sooner (or
something so frustrating it gives you reminiscent pangs of Vim).

It's taken me at least the fourteen days described in the title, but with my
help it should only take you two or three. There are some things to get used to,
some new paradigms, and you have to learn a bit of Lisp (Elisp, actually), but
don't be afraid, it's not that hard.

Is this just a phase that I'm going through? Will I get smothered in parentheses
and return to Vim? Maybe. But for now, come with me, learn a little bit of Lisp,
and have some fun.<!--more-->

## Step 1: Get Emacs ##

Emacs is available on all major platforms. For Linux OSes, you can get Emacs
from your package manager du jour, i.e. `apt-get install emacs`. There are also
Linux and Windows builds available through a
[local GNU mirror](http://ftpmirror.gnu.org/emacs/) (this link will redirect to
a mirror close to you, in theory).

For OS X (presumptuously the only reason you'd read this section...), you have
at least four choices:

* ["GNU Emacs for Mac OS X"](http://emacsformacosx.com/), which is a
  pre-built binary in common OS X dng format, ready to go. I believe it is
  version 24.5 at the time of this writing.
* The default Homebrew build, `brew install emacs`, which of course is available
  in both its trunk form and with `--use-git-head` or `--HEAD` to get a more
  bleeding-edge version.
* Yamamoto Mitsuharu's experimental "Mac port" version, which adds (better)
  native GUI support, from a custom tap. Run `brew tap railwaycat/emacsmacport`
  and then `brew install emacs-mac` to get it; this one also has the typical
  `--HEAD` option available.
* Finally, there is [Aquamacs](http://aquamacs.org/), which claims to bring more
  of the Aqua-style chrome to Emacs. In spite of being a moderate OS X fanboy I
  find this offensive and haven't tried it myself.

Each build will be a slightly different version of Emacs, with the pre-built
binaries tending toward stable trunk releases and the brew versions somewhat
newer. There are a few small differences in the way they handle key codes (the
Mac port version remaps "super" to "alt", which means the Mac command key acts
as alt; you may or may not like that). You can install all of them and try them
out; they will all load your config seamlessly.

## Learn the Basics ##

There are just a few essential keys you need to know to get started using Emacs
in its bare form. Most of the default key mappings in Emacs are a sequence of
control key presses, so, for example, `C-x C-c` means to press "control" and
"x", then press "control" and "c".

In Emacs notation, which I will use here, `RET` means return (or "enter"), and
`M` means "meta" or "alt". Depending on the build of Emacs you are using and
what your keyboard layout is, the physical key may vary; try each potential key
until you get the expected result.

* `C-x C-c`: quit Emacs. As all new Vim users must first learn `:q<CR>`, so must
  new Emacs users learn this bizarre key chord.
* `C-g`: cancel. This is the one piece of muscle memory you really need to
  acquire; even once you have re-mapped `escape` to quit from 90% of
  circumstances, there will remain some where only `C-g` will get you out. Just
  learn it, use it, love it.
* `M-x`: execute extended command. This is the gateway to a lot of the
  sophisticated stuff you can accomplish interactively in Emacs; it allows you
  to run any Elisp function by name. More on this later.
* `C-h ?`: help about help. This chord opens a list of potential help topics,
  each of which has its own direct mapping accessible through e.g. `C-h t`,
  which opens the Emacs tutorial.

Those are the only native mappings you really need to know to get started. If
you press some chord and something crazy happens, you can try backing out of it
with `C-g`, and to learn what the chord does you can ask Emacs for help about
the key by pressing `C-h k` and then pressing the key or chord in question.

One of the nicest things about Emacs is that it's self-documenting. If you want
to know what `C-x C-c` does, you can simply press `C-h k` to ask for help about
a key and then press `C-x C-c`. Emacs will open the documentation for the
function that the key is mapped to, and 99% of Emacs functions are documented.
There are other ways to learn about mappings that we'll talk about later.

All mappings, and by this I mean *all* mappings, can be re-mapped. You may take
the time to re-map the ones you use a lot (for example, I created a `<leader>x`
mapping for `M-x`), or you may live with the Emacs defaults; that is a choice
each must make on their own.

## Configure Your Environment ##

Configuring Emacs is easily as involved as configuring Vim, if not more
so. Unlike Vim, however, Emacs ships with an interactive configuration tool that
you can use as a beginner to configure basic settings without having to plumb
the depths of Emacs' numerous variables and functions. We'll get to that
later. First, get a barebones config started.

Step one is to make yourself a home for your config, if your package of choice
didn't create one for you:

* Create the directory `~/.emacs.d`
* Create the file `~/.emacs`

Open `~/.emacs` in your favorite editor and paste in this nonsense, which,
sooner or later, will seem quite simple and obvious to you:

``` cl
(require 'package)
 
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))
 
(setq package-enable-at-startup nil)
(package-initialize)
```

The above code loads the built-in package manager ("package") and adds a couple
of popular Emacs package repositories to the list of available repositories so
that we can install the latest and greatest versions of modern Emacs packages,
which are analogous to Vim plug-ins.

Start Emacs. You should now be able to press `M-x` to get a prompt at the bottom
of the frame. Type the command `package-list-packages RET`. Tab completion
works in that prompt, so feel free to use it to confirm that Emacs can find the
function. Emacs will connect to the Internet to download package lists and open
a window listing the packages available.

This part gets sticky because you need to use default Emacs key mappings to
navigate the package list, so let's just quit the buffer now that we have the
package lists updated. Press `q`.

## Install Evil Mode ##

Finally, install `evil-mode`, the Vim emulation package for Emacs, by typing
`M-x package-install RET evil-mode RET`. A second window will open and a lot of
stuff will happen in it as the package is downloaded and compiled into Emacs
bytecode. Emacs packages tend to emit a lot of compiler warnings, which you can
safely ignore. When it's through, `evil-mode` should be installed. Let's turn it
on.

Type `M-x evil-mode RET`. You can now type `:qa` to quit all windows and close
Emacs.

If all of that works, you're ready to start building your Emacs configuration
empire, and the very first thing you'll probably want to do is use `evil-mode`
by default.

{% infobox %}
A "mode" in Emacs is similar to Vim's notion of a "filetype." A mode usually
provides syntax highlighting and indentation rules, keyboard mappings, and other
functionality useful for a particular type of task.

Your "major mode" is the mode that typically defines the type of work you're
doing, which is often associated with the filetype you're editing; you can only
use one major mode at a time.

Emacs packages may also provide "minor modes," of which you may load as many as
you like. Examples of useful minor modes are "flycheck," which gives you syntax
checking, or "projectile," which provides functions for working with
source-controlle projects, or "magit," which gives you interactive git commands.
{% endinfobox %}

To tell Emacs to use `evil-mode` immediately upon opening in all buffers, you
simply load the package into memory and call the main mode function, which is
conveniently named `evil-mode`. Add this to your `~/.emacs` file:

```cl
(require 'evil)
(evil-mode t)
```

If you are editing your `.emacs` file in Emacs, you can find out what those
functions do by placing your cursor over the word "require," for example, and
pressing `C-h f` to open the "help for functions" prompt; the word under the
cursor will be placed into the prompt for you. Press enter and a split window
will open containing the definition of the function.

Try it for `evil-mode` as well. To close the split window you should be able to
use the typical Vim key `C-w o` ("only this" window). The Emacs key to do the
same thing is `C-x 1`, because that makes sense...

## Taking the Helm ##

One of the most popular packages available for Emacs is called Helm. It is
described simply as "Emacs incremental and narrowing framework," which doesn't
at first seem tremendously useful, but what it actually provides is the ability
to display a list of values that is narrowed down as you type, similar to
something like Vim's CtrlP implementation or Sublime Text's fuzzy search.

Now, Helm doesn't actually search your project files or anything. No, it simply
provides a framework for displaying an interactively narrowed list of
things. But the staggeringly cool thing about it is that when it is installed,
suddenly all of the Emacs default selection functions become interactive
lists. Everything from `M-x` to `package-install` will become narrowing lists
just like CtrlP.

Let's install it!

## Automatically Installing Packages ##

This is a perfect time to talk about how to maintain a list of packages that you
always want installed. There are a lot of different ways to do this, but here is
a quite simple one that you can immediately start using.

Since the Emacs `package.el` package manager is built into Emacs, you don't need
anything like Vundle or Neobundle or Pathogen, all you need to do is call
`package-install` on every package that isn't yet installed. This is easy to
write in Elisp.

```cl
(defvar required-packages '(evil-mode
                            helm
                            projectile)
  "Packages that are required by my configuration.")

(require 'cl-lib)
(defun required-packages-installed-p ()
  "Check if all required packages are installed."
  (cl-every 'package-installed-p required-packages
  )

(cl-loop for package in required-packages
         (unless (package-installed-p package)
           (progn (message "Installing '%s'..." package)
                  (package-install package))))
```
