---
layout: post
title: "The Right Tool for the Job"
date: 2017-08-26T11:06:23-04:00
---

I've become somewhat more of an Emacs celebrity than I could have
predicted. After giving [that talk][talk] and spending a couple years blogging
and tweeting about Emacs, people frequently ask for my opinion or advice
regarding its use, how to learn it, or whether to learn it at all.

[talk]:https://www.youtube.com/watch?v=JWD1Fpdd4Pc

Today I want to share my long-form answer to a few related questions that I get
asked pretty often. Those questions are, roughly:

* Should I start using Evil Mode right away, or learn "pure" Emacs first?
* Should I learn Vim before using Evil Mode?
* Is Emacs the right editor for me if I am a: computer science student,
  professional programmer, astronaut, whatever?

The answer is: maybe.~~MORE~~

First, chances are very high that your situation is different from mine, and so
the reasoning behind my decision to give Emacs a try and then spend two years
evangelizing about it may not apply to you.

I gave Emacs a shot because I wanted to see what all the fuss over Org Mode was
about. After spending a couple of days getting Evil Mode working to my
satisfaction, it became abundantly clear to me that Emacs was a far superior
system when compared to Vim (7.4, or so). Neovim is chipping away at that
divide, but I still believe Emacs is superior.

There are some things that Emacs is extremely good at. There are other things
that it is not very good at. The same can be said of Vim, or Neovim, or Sublime
Text, or Atom, or whatever tool you are using.

So let me answer all of the original questions in two parts.

## The Vim Paradigm is Life-Changing

The one universal piece of advice that I give to everyone (whether they ask for
it or not) is that the modal editing system that Vim made famous is the most
efficient and powerful approach yet devised and that you will fail to reach your
full potential if you choose not to learn it.

Though the editor you choose for any particular purpose is an important choice,
and one that will likely have an impact on your ability to excel at any given
task, the Vim modal editing system will have a greater magnifying effect on your
capacity for *editing raw text* than any other skill or technique or tool that
you will learn.

If you read this whole post and come away with only *one thing*, let it be this
very strong urging that you put down your cup of coffee and your tablet and
launch `vimtutor`, right now.

## Emacs Isn't Right For Everything

So, should you learn to use Emacs, or try Emacs for the first time in order to
do task XYZ? Maybe.

If you are going to do real, professional, challenging work in PHP or Java, it
is very likely that you'll be faster and more accurate in PhpStorm or IntelliJ
(respectively). If you are going to be spending weeks or months hacking on .NET
code, you should really use Visual Studio.

In short, there is no substitute for a real IDE. Vim and Emacs can both make use
of external programs like GNU Global, ctags, or syntax checkers and linters that
make the editor *feel* pretty smart. But, at least as far as I know, none of
them are as powerful or feature-rich as a purpose-built IDE.

Fortunately, there are Vim-style editing extensions for all of them! For Visual
Studio there is VsVim; for PhpStorm, IntelliJ, DataGrip, and the other JetBrains
products there is IdeaVim; for Sublime Text there is Vintage Mode; for Chrome
there is Vimium; for your shell there is `set -o vi`.

Now, if what you need a text editor for is smaller projects, or projects in
languages other than those above, and if you're interested in learning a Lisp
and becoming a wizard who wields their editing environment like some
immeasurably powerful, flaming magical poisonous scepter and renders their foes
into dust with the subtlest flick of the wrist, then learn Emacs. And use Evil
Mode.

Likewise, if you spend most of your days struggling through an organizational
nightmare of running projects, requests, random ideas, meetings, emails, and
time-bound tasks, I haven't found any solution superior to Org Mode.

So, in short, choose the right tool for the job.

But make sure it supports a Vim input system.
