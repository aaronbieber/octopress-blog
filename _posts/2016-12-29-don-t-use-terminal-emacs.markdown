---
layout: post
title: "Don't Use Terminal Emacs"
date: 2016-12-29T16:20:20-05:00
---

If you are a terminal guy as I am, or if you're a terminal gal, you may be
inclined to use Emacs in the terminal as well. A couple of my friends who took
up Vim got used to running it within tmux and exchanged one terminal program for
the other. This is wrong.

The GUI Emacs program is not just a crutch for the ignorant fools with their
fingers all gnarled by mouse overuse; no, GUI Emacs is much more powerful, and
there is almost no reason at all to run Emacs in a terminal. Ever.

Let me explain why.~~MORE~~

There are two reasons why GUI Emacs is superior to Emacs run in a terminal:

1. GUI Emacs is capable of things that the terminal fundamentally cannot do, and
2. TRAMP.

I'm going to come at this from a Vim vs. gVim perspective because I was the guy
who used to run around telling people to "just run Vim in the terminal," and
reciting facts like "other than color depth you get *nothing* from gVim," and so
on. Those statements are true.

Emacs, in so many ways, is light years ahead of Vim. I've said it before, I'll
say it again: Emacs is better software.

OK, so let's dig into the details.

## GUI Capabilities ##

There are things that the GUI Emacs program can do that a terminal program
simply cannot. These are things like:

* Use rich text formatting
* Display images
* Display PDF documents
* Interact with the system clipboard natively
* Respond to key presses that terminals can't see or understand

gVim has the ability to use the system clipboard, but apart from color depth
there was no other difference in capabilities between it and good old terminal
Vim.

Emacs brings in the ability to format text in different sizes, styles, and
weights; display actual full images; display PDF documents; and use key bindings
terminals don't support.

I'll just talk through a couple of these that I've found particularly useful,
but feel free to drop additional questions in the comments below.

### Display Images ###

Let's get this out of the way first. I don't think that displaying images in
Emacs is a "killer app." I have used it when creating presentations or taking
notes in Org Mode, but I could easily live without it. I even wrote a package
for displaying the weather forecast, called [Sunshine][ss], which can display
the icons for weather conditions. It's easy to do. It's not critical to my
lifestyle or well-being.

[ss]: https://github.com/aaronbieber/sunshine.el

### System Clipboard ###

Access to the system clipboard is *absolutely* a must-have. I recall going
through long and uncomfortable contortions to get tmux and terminal Vim to share
clipboard data with the Linux system clipboard using command line utilities like
`xsel` and `xclip`. It never worked well, it hung the editor, it was not
reliable.

Being able to copy and paste freely between your browser or other apps and your
editor is a *critical time-saver*. That's why the clipboard exists in the first
place.

Both gVim and GUI Emacs have this ability because they are GUI programs. You are
severely missing out if you are using your terminal as a layer in between these
functions. Pasting *into* the editor is usually not so bad, but copying out of
it is tedious and awful.

When using Org Mode to comprehensively organize my entire life, access to
features like clipboard sharing and [protocol triggers][org-protocol] are
totally killer.

[org-protocol]: {% post_url 2016-11-24-org-capture-from-anywhere-on-your-mac %}

### Respond to Keys the Terminal Doesn't Understand ###

There are actually *four* common modifier keys on any modern keyboard. Those
are, in no particular order:

1. Shift,
2. Control,
3. Alt (or Meta), and
4. Super

Super is also called by other names, like "Command" (on the Mac) or "the Windows
key" in That Other Operating System. Emacs loves to bind things to
*super*. Since picking up Emacs I have discovered all sorts of ways to make use
of the additional key bindings at my disposal when I am using *super*.

Emacs also loves binding things to *meta* (alt). Even *meta* doesn't always work
properly in some terminals because there are strong differences of opinion about
how those particular character codes are formed, but there are few terminals
that can properly handle a *super* key press at all.

You have all of these keys, and your operating system can use them, so why not
your editor?

## TRAMP ##

For those who are not familiar with TRAMP, it is an acronym that stands for
"Transparent Remote Access, Multiple Protocol" and has been a part of core Emacs
since version 22.1.

Why does this have anything at all to do with terminal vs. GUI Emacs? Because
the terminal versions of editors are quite often used to make changes to files
on remote servers, generally through an SSH connection.

What TRAMP allows you to do is open remote files, through SSH, directly in your
local GUI Emacs. Not only does it allow you to *open* those files, it allows you
to save them, to move them, to change their permissions, and so forth. TRAMP
abstracts away the protocol layer in between so that essentially all Emacs
operations work on remote files. It's similar to magic.

Is your remote file located in a Git repository? No problem, Magit works through
TRAMP as well. Because TRAMP basically wraps all of the elisp file access
functions, or something like that, most Emacs packages don't need to do any
extra work to act on remote files.

There are a few caveats, of course. If you work on remote *projects* quite
often, it can be slow to use tools like Projectile, where indexing tons of
remote files is required, but for dropping in and editing a few files (the sort
of thing you'd open a quick SSH session for), TRAMP is perfect.

Since you're using your own local GUI Emacs, you feel right at home with all of
your GUI key bindings and colors and so on.

## Advice You Didn't Ask For ##

If you've made it this far without cheating, you already know my opinion. I
strongly advise you to simply stop using Emacs in the terminal. Full stop.

You may ask, "but what if I need to edit my crontab file or something?" Sure. I
get that. Guess what, you can use GUI Emacs for that, too, if you have
`(server-start)` in your init file and your `$VISUAL` environment variable is
set to `emacsclient`.

Live in the blissful world of 16.7 million colors, different font sizes, and
infinite key bindings. Live in the GUI, forever.
