---
title: Learning to Love Emacs
layout: post
date: 2015-01-17 15:31:51 -0500
comments: true
tags: vim emacs
---

It would be safe to say that I'm a Vim devotee; a follower. I own more than one
t-shirt with Vim "stuff" on it (one bearing its logo, another the image of
"HJKL" key caps). I've spoken at local Vim meetups, I subscribe to Vim-related
lists, I've casually urged people to switch from Sublime Text to Vim at the
office and a few actually did.

For me, saying that I use Emacs or, heaven forbid, advertising it through
wardrobe choices, feels like an act of high treason.

Still, it is true. I've been secretly using Emacs for the past few months,
exclusively. I have told a few people at work and all of them, without
exception, literally gasped. That's how broadly I had advertised my love of
Vim. But it's time now to explain why I switched and why you should think about
switching, too.<!--more-->

## Vim Is Awesome

What is it about Vim that is so awesome? Primarily, it is its mnemonically
fluent, composable grammar, which lends itself to the common keyboard
interface. Once you learn the keystroke for "delete," and the keystrokes for
"word," "sentence," "paragraph," and so on, you can delete those things (we call
them "text objects") by typing the keystrokes one after another. Learn the
keystroke for "yank" (which is "copy" in Vim parlance) and you can now yank all
of those text objects. That's what we mean by "composable," and that is the
source of Vim's power.

Emacs, in its default configuration, uses sequences of modifier keystrokes to
avoid pressing any bare letters or numbers to issue commands. This means that in
order to delete letters, words, sentences, paragraphs, and so on, you must learn
entirely new sequences of keystrokes, each of which putting your hands into
contortions to press a modifier at the same time.

Vim's approach is simpler to grasp and easier to execute. Paired with an array
of impressive plug-ins adding everything from linting to git integration, it's
as close to an IDE as I've ever wanted.

Unfortunately for Vim--the editor that I have grown to love with a passion that
spills from my words and actions on a daily basis and that even now I'm mildly
proselytizing--it is a shitty piece of software. I mean, sure, you can run it on
virtually any platform and it opens quickly and can handily edit huge files and
for all of those reasons it is objectively superior to, say, EditPlus or even
Sublime Text in certain circumstances. But that doesn't make it a *great* piece
of software.

There are three reasons that I believe Emacs to be superior to Vim *as a
software package*.

## Capabilities, Plain and Simple

Emacs is capable of more. Here are a few things that Emacs can do that Vim
simply cannot; it can:

1. Run tasks in the background ("asynchronously"). That includes extension code
   that you have written as well as shell programs, even while piping the output
   from those programs into visible windows. In Vim, this hangs the UI.
2. Display graphics. If you use Emacs in its GUI form (which is recommended), it
   can display custom glyphs, images, and even full document formats like
   PDF. The GUI version of Vim ("gVim") provides scrollbars, a toolbar, can
   display more colors, and... That's it.
3. Be *truly* extended. By this I mean that all of Emacs' core functionality is
   exposed through elisp functions, which can be called and even overridden
   using a sort of mixin strategy called "advice." Given this, there are few
   limitations to what you can do to customize it. Vim provides a scripting
   language that can manipulate most of Vim's behavior, but it is limited
   primarily to modifying data; you cannot change any fundamental behaviors like
   how Vim draws line numbers.

The best example I can think of for how Emacs can be extended is "Evil Mode,"
which essentially emulates Vim within Emacs, and it is a staggeringly complete
implementation. The ex command prompt and all of the built-in commands (like
"registers" and "bdelete" and so on) are implemented. Think about this. A
seamless ex command prompt was implemented in elisp and it's as good, if not
better, than Vim's own. Jumps, marks, registers, all of the text objects and
associated commands... They're all there.

But having a little Vim running inside your Emacs and being able to run some
background tasks and hacking on elisp is only one of the reasons I think that
Emacs is objectively better software.

## Code Quality

I haven't attempted to submit patches to Vim nor Emacs, but Geoff Greer has
hacked on Vim code before, and his analysis of why Vim is a pretty terrible
software project is compelling.

Here is an excerpt from his recent post, [Why NeoVim Is Better than Vim](http://geoff.greer.fm/2015/01/15/why-neovim-is-better-than-vim/):

> I started programming in C almost 20 years ago. Vim is, without question, the
> worst C codebase I have seen. Copy-pasted but subtly changed code
> abounds. Indentation is haphazard. Lines contain tabs mixed with
> spaces. Source files are huge. There are almost 25,000 lines in `eval.c`. That
> file contains over 500 `#ifdefs` and references globals defined in the 2,000
> line `globals.h`.
> 
> Some of Vim’s source code isn’t even valid text. It’s not
> ASCII or UTF-8. The venerable `file` can’t figure out the encoding.

As a programmer myself, this bothers me in principle. It is hard to hear that
lurking behind the facade of one of your favorite programs is a pile of
spaghetti code. Still, how a program is written is not necessarily a deal-breaker
for the users of that program. Take, as an example, the various and long-lived
Microsoft Office programs. We know from stories written by past and present
Microsoft engineers that codebases of that size with reverse compatibility
requirements of that magnitude are going to produce anything from mild shame to
active regret in their maintainers.

But Microsoft is a giant and powerful software company that has the enviable
luxury of hiring amazingly talented people and paying them generously to
continue down that rocky path of maintenance and feature development because
these products *are indispensable* in modern business and *make tons of money*
for Microsoft and its employees and shareholders.

Vim, on the other hand, is "charityware," is maintained and improved by a
relatively small and devoted cadre of programmers who work for pure praise and
self-satisfaction, and could, at least in theory, fall into an irrecoverable
state of disrepair as other open source software projects have in the past if
developers lose interest in the daily uphill battle of navigating disorganized
code kept that way willfully by its original author.

None of this makes me feel supremely confident that Vim will actually improve
steadily over time. In fact, the observations made by Greer in his post linked
up above seem to indicate that not only will Vim improve slowly, if at all, but
that a collapse into that irrecoverable state of disrepair I mentioned is
frighteningly likely.

I mean, if you're passionate about a project and you want to spend some of your
time and energy contributing to it, about the last thing you want to do,
especially as a newcomer, is dig through decades of cruft that core project
maintainers have *actively ignored*.

This brings me to the final nail in the coffin, which is...

## Project Leadership

Purely as a piece of software, Vim is a program that was written by Bram
Moolenaar, who is still its primary maintainer. That is not, by any means, a bad
thing. Linus Torvalds still approves all Linux kernel changes himself, because
he's passionate about it and because he's damned good at it.

Still, Bram has been notoriously intractable on topics of modernization ranging
from simple internals issues, like removing obsolete `#ifdef` branches that make
Vim compatible with operating systems that aren't even in use anymore (like
BeOS, remember that one?), to adding capabilities broadly and passionately
desired by Vim's users such as asynchronous operations.

So strong is the will of the Vim community and so obstinate is Bram in his
vision of what Vim ought to be that a guy by the name of Thiago Arruguda created
a project called NeoVim that aims to provide all of that and more. Asynchronous
processing? Sure. An extension language that stands on its own as feature-rich
and fluent? Absolutely. A plug-in API that exposes everything for customization?
Imagine!

NeoVim sounds very promising, but it is still in its infancy. It only compiles
on a few platforms and it isn't feature-complete yet. It might not be for some
time to come. From what I have heard, the group of folks working on the project
are friendly and welcoming to others willing to help. The Vim community lacks
this because it is led and managed solely by Bram.

In an e-mail interview published on Binpress,
[10 Questions with Vim's creator, Bram Moolenaar](http://www.binpress.com/blog/2014/11/19/vim-creator-bram-moolenaar-interview/),
Alexis Santos asks, "How can the community ensure that the Vim project succeeds
for the foreseeable future?" Bram answers, "Keep me alive. :-)"

That is a staggeringly, mind-blowingly irresponsible answer for the maintainer
of such a venerable and ubiquitous project to offer his community. "Keep me
alive?" Setting aside for a moment the inescapable fact that every human
eventually dies, Bram's flippant answer to this question does not inspire faith
in me that the Vim project has a reliable stewardship and a bright and long
future.

Let's take a look at the Emacs side. Emacs was originally written by none other
than Richard M. Stallman (often self-identified and sometimes addressed by his
initials, "RMS"), who is also the founder of the Free Software Foundation and
the creator of the GNU Project (GNU is Not UNIX). Stallman has a lot going on;
he is involved in the operations of his foundation, he frequently gives talks on
freedom and privacy topics, and he is involved with Emacs development as well.

I say "involved" because he stepped down as maintainer of Emacs in 2008, handing
the reins to two gentlemen, Stefan Monnier and Chong Yidong, who had a proven
track record of contributing to the project and vetting others'
contributions. In classic RMS style, here is how Richard handed over the
leadership of one of open source's largest development efforts:

```
From:	 Richard Stallman
Subject: Re: Looking for a new Emacs maintainer or team
Date:    Fri, 22 Feb 2008 17:57:22 -0500

Stefan and Yidong offered to take over, so I am willing to hand
over Emacs development to them.
```

Problem solved.

Making the transition to Emacs isn't transparent or instantaneous. Even with
Evil Mode, there are some things you need to learn about how the system works,
including, probably, a bit of elisp. But if you're up for it, it can be a
tremendously gratifying experience. All of the things you love about Vim, with
all of the capabilities of what has been described as "a great operating system,
lacking only a great text editor." I believe that Evil Mode is that editor.
