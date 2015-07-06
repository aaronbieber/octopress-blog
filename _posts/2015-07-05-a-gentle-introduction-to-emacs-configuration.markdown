---
layout: post
title: "A Gentle Introduction to Emacs Configuration"
date: 2015-07-05T13:06:22-04:00
---

Since giving my talk,
[Evil Mode, or, How I Learned to Stop Worrying and Love Emacs][evil-mode] at the
Boston Vim meetup group, I have been inundated with questions, both about how I
pulled off this transition and about Emacs itself and how it works.

One question that comes up more than the others is how to "properly" configure
Emacs. Because Emacs is essentially a Lisp engine that just happens to ship with
text editing capabilities, configuring it requires writing or modifying some
Lisp expressions, which is quite different from how Vim is configured.

Here, I will gently guide you through the very basics of Emacs configuration and
show you where to get help so that you can embark on your Emacs customization
and personalization journey with confidence.~~MORE~~

[evil-mode]: {% post_url 2015-06-03-evil-mode %}

## Overview ##

There are three ways to extend and personalize your Emacs environment:

1. By installing packages that change Emacs' behavior or add new features.
2. Using the built-in `customize` facility.
3. By editing your Emacs configuration scripts by hand.

Installing packages may also require a bit of #3 depending on what the package
does, of course. I will walk you through each of these and drop a few hints
along the way.

## Installing Packages ##

I covered this pretty thoroughly in my previous post,
[From Vim to Emacs in Fourteen Days][from-vim]. You'll want to follow the
instructions there to configure the correct package repositories. For more
information about the configuration files specifically, see the section below.

The Emacs packaging system, `package.el`, ships along with Emacs, so you can
start using it immediately. As long as you have the initialization command,
`(package-initialize)`, in your configuration file, you can manage packages
interactively. Note that the parentheses around that term are required; all
expressions in Emacs Lisp are *lists*, surrounded by parentheses. I'll talk more
about this later.

To install a package, all you have to do is call the package list
function. Press `M-x` (hold "alt" and press "x"), enter the command
`package-list-packages`, and press return (or `RET`, as it is commonly
written). The latest package lists will be downloaded from your configured
repositories and the list will appear on screen.

Even if you are using Evil Mode, the package list will likely be using Emacs key
mappings. Here are some tips for getting around:

* `C-v` scrolls down one screen.
* `M-v` scrolls up one screen.
* `C-s` starts the incremental search function. Press `C-s` repeatedly to move
  to the next match, `RET` to complete the search and stay where you are, `C-g`
  to cancel and go back to where you started. `C-g` is the universal "get me out
  of here" key in Emacs; learn it well.
* `i` marks a package for installation.
* `d` marks a package for deletion.
* `u` un-marks a package.
* `x` executes the operations as marked (so mark things you want with `i` and
  then press `x`)
* `q` quits the package interface.

You can see a full list of available key mappings by asking Emacs for help with
the current mode ("Package Menu Mode"). Press `C-h` followed by `m`. You can get
help on a lot of things in Emacs by pressing `C-h` followed by some key.

A split window will open containing help on Package Menu Mode, but the window
won't have focus. To move the focus to the other window, you must use Emacs'
window commands:

* `C-x o` (press `C-x` followed by `o`) to move focus to the "other" window.
* `C-x 0` to kill the current window.
* `C-x 1` to make the current window the "one and only" window (hide all other
  windows). This does not *kill* the other windows, it only hides them.

This should be enough to get you started. If you run into snags while installing
and configuring packages, you should turn to Google to find help on the specific
packages you're using or the scenarios you're encountering.

[from-vim]: {% post_url 2015-05-24-from-vim-to-emacs-in-fourteen-days %}

## Customize ##

The Emacs "Easy Customization Interface" is a fully interactive system for
altering Emacs settings. But that's not all: Customize can also interactively
change settings for all installed packages, too!

Package authors can call the function `defcustom` to declare variables that can
be customized, and, using a rich set of attributes that define what values are
permitted, the Customize interface draws a GUI representation of that
setting. When you save the settings, the Customize system will write the Emacs
Lisp code for configuring the settings you've changed and write that into your
configuration file for you. All of those values are stored together in a single
variable called `custom-set-variables`.

There are two main ways to start the Easy Customization Interface:

1. `M-x customize RET`, or
2. `M-x customize-group RET <group name> RET`

The first will open the initial customization interface, which has links to the
general sub-sections of configuration, help on the interface itself, and a
search function.

The second function will jump you directly into the customization settings for a
particular area, which is usually the name of a package itself, although some
larger packages expose multiple configuration "groups."

If you aren't sure what you're looking for, start with `M-x customize RET` and
use the search function. It's best to search for one or two words only; Emacs
searches the *human-readable names* of customization options, which are
typically not incredibly verbose.

There are certain keys you can press to follow links, expand and collapse
sections, and so on. You can find help on those within the customization
interface itself (by following the link to the manual page; just press `RET`
with your cursor over it, as you can with most underlined text), or by viewing
the mode help as I explained in the previous section (`C-h m`).

Once you have updated some settings, you can either *Apply* the settings, which
sets the variables in your current session only, or *Apply and Save*, which
writes them out into `custom-set-variables` in your configuration file.

You can always *Apply* a setting, leave the customization interface and try it
out, then re-open customize and press *Apply and Save*. If you have not yet
saved the settings, you can also press *Revert...* to reset things to the way
they were before.

## Edit Configuration Files ##

One of the first places to look for specific information about how Emacs works
is the Emacs manual itself. In the ["Init File"][init] section, you will find
that Emacs searches for configuration in three places (in this order):

1. `~/.emacs`
2. `~/.emacs.el`
3. `~/.emacs.d/init.el`

Of course, just like in Vim, you can write some code to load other configuration
files and organize things however you like. Most people start with one
configuration file and take it from there.

By now, you probably have a configuration file with at least the Emacs package
repositories settings that I outlined in the other post linked from the top of
this one, and maybe you have a `custom-set-variables` declaration there, which
was written for you by the Easy Customization Interface. So, how do you know
what other variables you can set?

Of course there is always Google; most settings in Emacs and its popular
packages are described in the official Emacs manual on gnu.org and in the
packages' README files, which are usually found on Github or another source code
hosting site. It's pretty easy to find the names of variables and what they do
on the Internet.

Another thing you can do is use Emacs' variable documentation. Even variables
that are not available for customization are often documented within the source
code, and that documentation can be accessed interactively. To get help on a
variable, press `C-h v <variable name> RET`.

If you have the great "Helm" package installed, `C-h v` will also open an
interactive "narrowing list" window displaying the names of variables that match
what you've typed so far. I can't recommend Helm enough, it's a great way to
explore what values are available at most prompts.

Let's say you want to change a setting in Python Mode. For example, you are a
rebellious sort and prefer to ignore PEP 8 and indent your code with two spaces
instead of four. Let's try to find the variable for this using Helm. First, you
must have Python Mode loaded or Emacs will not know about any of its declared
variables; if you have edited a Python file in your current session at any time,
Python Mode should be loaded already, but you can also set the current buffer to
Python Mode to load it. This is just an example, anyway.

To see if there is an indent offset variable, press `C-h v` and enter "python
offset". In the Helm list you should see that the top match is a variable called
`python-indent-offset`. That sounds like the right one! Press `RET` to accept
that match and a split window will open with the documentation for that
variable. Amazing.

It tells us that the variable is defined in a file that is part of the Python
Mode package (`python.el`), and that its current value is 4. It also tells us
that this variable can be customized. You can press `RET` over the "customize"
link to jump to this value in the Easy Customization Interface.

If you wish to set this value yourself, you can add a declaration to your init
file. There's just one thing: it's best to set these mode-specific variables
only when we are using that mode. Otherwise, you will have all sorts of
variables floating around in memory and not being used. We can't have that.

To set this variable only when Python Mode is invoked, we can use a *hook*. This
is a very common pattern in Emacs configuration. Here is what our hook might
look like for setting this value:

```cl
(add-hook 'python-mode-hook
          (lambda ()
            (setq python-indent-offset 2)))
```

The `add-hook` function adds the provided function to the list of functions to
be called when Python Mode starts. All Emacs modes provide a variable called
`<mode-name>-hook` that you can use to trigger your own stuff whenever that mode
is loaded up. Here, we have provided a simple lambda (anonymous function) to set
the `python-indent-offset` variable to `2` when Python Mode loads. That's it!

Of course, you don't need to use a lambda. If you want to use a named function
you can simply pass that function to `add-hook`. To pass a function without
evaluating it, you must quote it by prepending an apostrophe. This is what it
might look like if you structured it that way:

```cl
(defun configure-python-mode
  (setq python-indent-offset 2))

(add-hook 'python-mode-hook 'configure-python-mode)
```

Finally, you can evaluate Lisp expressions directly within Emacs, which can be
helpful when you want to test out new configuration options. Let's say you want
to set up this hook right now, to see if it works. Let's use the first example
with the lambda because it is a single statement. Place your cursor immediately
after the closing parenthesis of the expression. This is a little tricky; if you
are using Evil Mode you will need to be in insert mode so that the insertion
cursor is *after* the closing parenthesis.

Now, press `M-x eval-last-sexp RET` (this is short for "evaluate last
S-expression"). The result of evaluating the expression will be printed on the
bottom line of the Emacs window (what we call the "minibuffer"). Because
`add-hook` yields the value of the new hook function, it should print out the
lambda expression. Very often the result of evaluating Lisp expressions is
simply `nil`, and that's OK.

Now the value is set! You should be able to start Python Mode and see that the
offset is set to `2` instead of `4`.

For more information about Emacs Lisp, check out Caio Rordrigues' amazingly
thorough [Emacs Lisp Programming][elisp].

Questions? Comments? I'd love to hear them, just use the comments section below.

[init]: http://www.gnu.org/software/emacs/manual/html_node/emacs/Init-File.html
[elisp]: https://github.com/caiorss/Emacs-Elisp-Programming
