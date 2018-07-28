---
layout: post
title: "Living in Evil"
date: 2016-01-23T14:34:11-05:00
---

Evil Mode is a phenomenal tool; it's a better Vim than Vim. The only problem is,
there are a lot of other great tools available in Emacs that don't get along
well with Evil Mode, and if you don't set things up just right you can wind up
with jumbled key bindings and unexpected behaviors.

In this post I'll explain how I set up my configuration to use Evil Mode in all
of the places where I want it, but none of the places where it gets in the
way.~~MORE~~

## Basic Configuration ##

{% infobox %}
If you already have Evil working and you don't care how I load it into my Emacs,
you can jump down to "Brass Tacks."
{% endinfobox %}

First, I use John Wiegley's great
[use-package](https://github.com/jwiegley/use-package) system for importing
packages into my Emacs. This simplifies my configuration by defining the
packages I want, downloading them from MELPA or other repositories when they
don't exist, and defining the configurations that should be applied both before
and after the package has been loaded, all in one place.

My Evil Mode configuration is pretty big, and you can read the whole thing [in my
Github repository here][evil], but for the sake of illustration I will use an
abbreviated version in this post. Something like this:

[evil]: https://github.com/aaronbieber/dotfiles/blob/master/configs/emacs.d/lisp/init-evil.el

```cl
(use-package evil
  :ensure t
  :config
  (evil-mode 1)
  ;; More configuration goes here
  )
```

Here is a crash course in `use-package`: first you name the package you want to
load (obviously); `:ensure t` means "make sure this package is installed," which
will try to install it from MELPA if it isn't found; and then everything in the
`:config` section is evaluated right after `evil` is loaded.

Here I'm just calling `evil-mode` to activate it, because I want it to be
turned on globally, all the time.

So the first thing I do in my own configuration is load four more packages that
rely on Evil: `evil-leader`, `evil-surround`, and
`evil-indent-textobject`. Because there is no sense in loading these if Evil
isn't loaded, I nest their `use-package` calls within Evil's `:config`
section. So now we have something like this:

(NB: `evil-jumper` was merged into `evil-mode` itself in 2016, so you don't need
to install that package any longer.)

```cl
(use-package evil
  :ensure t
  :config
  (evil-mode 1)

  (use-package evil-leader
    :ensure t
    :config
    (global-evil-leader-mode))

  (use-package evil-surround
    :ensure t
    :config
    (global-evil-surround-mode))

  (use-package evil-indent-textobject
    :ensure t))
```

It might occur to you, especially if you've already skimmed my real
configuration, that this is too short. Where are all the key bindings and the
special sauces and magical fairy dust that makes Evil behave itself?

For whatever reason, I like terse `use-package` calls, so when a configuration
gets to be the size of my Evil setup, I put all of it into a custom function and
just call that function from the `:config` section of the `use-package`
declaration. I have one for Evil and another one for Evil Leader, because both
are pretty long.

It's completely up to you whether you want to do that or not. My recommendation
is to keep piling stuff into `:config` until you feel like it's too long to
remain quite organized, or too hard to read, then start breaking it up into
separate functions.

## Brass Tacks ##

Great, you've got Evil set up and now you're ready to make it play nice with
other modes. The Evil package actually ships with some sensible default
configuration for commonly used packages, like Magit (the Git porcelain inside
Emacs; one of my favorite tools in the world).

Because Magit itself provides a full complement of non-modified key bindings
(that is, you don't hold "control," "meta," or "shift" for any of them), it
doesn't make sense to let Evil assert its bindings in any of the Magit
modes. To do this, Evil uses a special state. First, a recap of Vim
states: Vim can be in one of five states:

* Normal
* Insert
* Visual
* Operator
* Replace

We also call those "modes" in Vim parlance, but because "mode" has a very
special meaning in the Emacs world, here we call them "states." Evil adds two
more states:

* Motion
* Emacs

Motion state is only the movement keys and functions without any other normal
mode capabilities (like entering the other states, deleting, etc.) The motion
state is used for pure read-only scenarios, like the Info reader (`C-h i`).

Emacs state is the important one. In Emacs state, all Evil key bindings are
suspended and Emacs behaves as though Evil is not there at all. You can
temporarily toggle Emacs state yourself by pressing `C-z`, and this can come in
handy when a mode you don't use often has some key binding you want to access
that Evil is overriding (you can figure that out by viewing the mode information
in `C-h m`).

### Forcing Emacs State ###

What we want is to automatically place certain modes into Emacs state by default
so that we can use their native key bindings without turning Evil off and on,
which would be super annoying. Fortunately, Evil has a built-in facility to do
this in the form of a variable called `evil-emacs-state-modes`. The value of
that variable is a list of mode names. If you enter a mode whose name is in that
list, Evil will toggle to Emacs state automatically.

It bears mentioning that there are also variables like
`evil-insert-state-modes`, `evil-visual-state-modes`, and so on, if you wish to
have some mode start in any of the available Evil states.

As an example, there are three modes where I want to use Emacs state by default:
`ag-mode`, `flycheck-error-list-mode`, and `git-rebase-mode`. To achieve this,
all you have to do is call the built-in function `add-to-list` and add these
values to the appropriate list variable. That looks like this:

```cl
(add-to-list 'evil-emacs-state-modes 'ag-mode)
(add-to-list 'evil-emacs-state-modes 'flycheck-error-list-mode)
(add-to-list 'evil-emacs-state-modes 'git-rebase-mode)
```

The apostrophes are Elisp shorthand for the "quote" function, which returns the
given argument without evaluating it. In this case, we want to pass the
variables and mode names themselves to `add-to-list`, not their values (the
value of `evil-emacs-state-modes` is the list of those modes, and the value of
the various mode functions are the functions themselves).

Cool, so now these modes start in Emacs state right away, but it's kind of
repetitive to type or paste `add-to-list` over and over, especially if you have
many such modes. Elisp is a full programming language, so we can simplify it a
bit:

```cl
  (dolist (mode '(ag-mode
                  flycheck-error-list-mode
                  git-rebase-mode))
    (add-to-list 'evil-emacs-state-modes mode))
```

Figuring out how this works is left as an exercise for the reader, but the one
thing I will mention here is the clever use of `'(foo bar baz)` to quote the
whole list at once. You'll see that convention used all over the place in Elisp
code.

### Adding h/j/k/l Bindings ###

Emacs state is fabulous for modes like Magit, which have their own mature and
sensible key bindings that you'll just love using and that almost feel a lot
like Vim on their own. There are other modes, though, where you want to keep
most of their bindings for special functions, but moving around with arrow keys
makes you feel like a Visual Studio developer (and we can't have that).

One such mode is `occur-mode`, which lets you see a summary of search results,
similar to editors like Sublime Text. Occur has a bunch of default key bindings
that overlap Evil's, such as `e`, which puts Occur into editing mode so that you
can actually edit the results right there and the source file is changed
simultaneously. It's a very powerful feature.

What I want, though, is to be able to move around with h, j, k, and l as I do in
Vim, but leave the rest of Occur's bindings alone. That is possible with a
really nice Evil function called, sensibly, `evil-add-hjkl-bindings`.

This function is quite versatile. It expects to receive a keymap (which is a
special Emacs data structure), a state name to apply bindings to, and optionally
a series of additional keys and functions they should call. More on that later.

Here is my configuration for Occur:

```cl
(evil-add-hjkl-bindings occur-mode-map 'emacs
  (kbd "/")       'evil-search-forward
  (kbd "n")       'evil-search-next
  (kbd "N")       'evil-search-previous
  (kbd "C-d")     'evil-scroll-down
  (kbd "C-u")     'evil-scroll-up
  (kbd "C-w C-w") 'other-window)
```

This automatically applies the Evil h, j, k, and l bindings to `occur-mode-map`
when I'm in Emacs state. Additionally, it defines some keys for a couple of
other common Vim shortcuts that I often use in Occur and maps them to existing
Evil functions.

{% infobox %}
**A crash course on keymaps**

Every major and minor mode has a keymap, even if it isn't used. When built-in
functions are called to define new modes, default map variables are created
using the name of the mode with `-map` added to the end.

If you want to confirm that a certain keymap exists, first make sure the mode
it's associated with is loaded, and then use `C-m v` to call the "Describe
variable" function and enter the name of the map. If you have Helm installed,
you will also see a narrowing list of variable names, which I use all the time
to hunt down variables.
{% endinfobox %}

Sometimes you can get into a situation where one configuration relies on another
piece of code to be loaded first. In the above example, I am assuming that Occur
has been loaded and its keymap exists. Because Occur is part of the Emacs core,
it's pretty much always loaded first, but this is sloppy coding on my part. A
much more reliable way to make sure things run in order is to use hooks.

### Bonus: How to Use Hooks ###

This isn't strictly related to Evil, but it's good to know as you build up your
Emacs configuration. Hooks are just functions called at certain points in
time. Much like keymaps, each major and minor mode will have hook variables
defined automatically for it. The hook for a mode is called immediately after
that mode is activated, so it's a great place to put any customization that
relies on that mode being loaded.

It's very common to make adjustments to a mode's keymap within the hook for that
mode (because the keymap variable won't be defined until the mode is
loaded). This also makes your configuration more efficient because you only run
code in the situations where it's actually used.

Emacs provides convenience functions for working with hooks, and the main one to
know is `add-hook`. A hook is actually a list of functions that, when a mode is
activated, are called in turn. Just like keymaps, hooks are automatically
defined as the name of the mode with `-hook` appended.

To set up the hjkl bindings in Occur mode only when Occur starts, you could
write it like this:

```cl
(add-hook 'occur-mode-hook
          (lambda ()
            (evil-add-hjkl-bindings occur-mode-map 'emacs
              (kbd "/")       'evil-search-forward
              (kbd "n")       'evil-search-next
              (kbd "N")       'evil-search-previous
              (kbd "C-d")     'evil-scroll-down
              (kbd "C-u")     'evil-scroll-up
              (kbd "C-w C-w") 'other-window)))
```

The `add-hook` function prepends the given function to the `occur-mode-hook`
variable. In this case, I'm passing an anonymous function (or lambda) to
`add-hook` because if I just put the `(evil-add-hjkl-bindings ...)` call there
by itself, the result of calling that function would be passed to `add-hook` and
it would complain about receiving the wrong variable type.

## Conclusions ##

So that's how I make Evil play nice with the various other modes that I use
often. Of course there is a lot more in my configuration, which you're welcome
to browse on Github, or if you have specific questions feel free to drop a
comment below.
