---
title: Sharpening Your Blades
layout: post
date: 2014-02-12 17:27:47 -0500
comments: true
categories:
---
The "toolbox" metaphor often used to describe a programmer's knowledge,
favorite software, shell scripting tricks, and so on, is a convenient one. The
skills and utilities that a seasoned programmer brings to bear on any given
problem is much the same as the craftsman's physical collection of implements;
selected carefully, representative of the craftsman's preferences, and wielded
with precision borne from experience.

We can learn much from these parallel concepts. In the same way that a builder
must keep the blade of the saw sharp, so must a programmer focus some effort
on sharpening the "blades" of his or her tools and techniques. This is not a
post about education or learning new algorithms or solving ridiculous _code
katas_ every day. This is a story about chainsaws.~~MORE~~

I watched this talk by the inimitable Gary Bernhardt (some day I hope someone
describes me as "inimitable") called "[The Unix Chainsaw][1]." Though the
technical guts of the talk consists of (awesome) Unix shell wizardry, the
philosophical thread that runs throughout is the avoidance of what Bernhardt
terms "the tar pit of immediacy," an expression that has since been used far
fewer times than I feel it deserves, which is why I'm mentioning it now.

[1]: http://www.confreaks.com/videos/615-cascadiaruby2011-the-unix-chainsaw

The "tar pit of immediacy" describes the experience of encountering a problem,
reaching for some familiar tool, solving the problem quickly and messily, and
then whenever the problem is encountered again, _doing the exact same thing_.
Often, getting the job done is absolutely the most important thing, but
looking at it from the perspective of our metaphorical craftsman this is much
like cutting things with the same blade until it's as dull as a spoon.

If there is one single piece of advice that I would like to give to every
software engineer ever, it's this: *you need to take the time to sharpen your
blades.*

The best programmers are fundamentally lazy people. They *abhor* repetition,
they *embrace* automation. If I see a programmer pressing the same keys over
and over, or submitting code for review with the same trivial syntactic
mistakes (like trailing whitespace or mis-alignments), I am going to walk over
to them and ask them how their chainsaw is doing because it sure looks to me
like they're cutting down a tree with a camping hatchet.

I have been, and continue to be, a massive advocate (some might say
proselytizer) of Vim and the Unix shell. I write about them, I teach Vim and
the shell at work, I give Vim talks, I own a t-shirt with the Vim logo printed
on it... You get the idea. This set of tools works for me; if I were a
carpenter they would be the hammer or chisel that fit so perfectly in my hand
that it would seem as though they were molded to my very palm. And indeed I
have spent enough time customizing my tools that in some ways they *are*
molded to my way of doing things, as a good tool ought to be.

But this is where I need to be absolutely clear: *your tools are yours*. Vim
isn't for everyone. I will continue to try to convince you that you should
learn it, but you can probably hit the ground running at a faster pace in
Sublime Text or some other editor. That you have chosen tool X, Y, or Z and I
have chosen A, B, or C is of little consequence. What is more important is
that you are always thinking about *making your tools work for you*.

I often see people using Sublime Text rather poorly. Sublime Text is a
tremendously powerful editor with most, if not all, of the capabilities of Vim
or Emacs. If you are using it on a daily basis you should be *fast* and
*confident* with it.  If you are doing a lot of repetitive text translations,
you need to find a better way, and that's what leads me to my ultimate point:

*Test the sharpness of your blades often.*

Vim has a learning curve whose difficulty falls roughly in between playing a
song on the harmonica and building the Space Shuttle. People who have reached
even a modest efficiency in Vim feel like they've learned a new language (and
in some ways they have), but it becomes obvious through that process that
there is much, much more on the horizon. The programmer within them swells
with the anticipation of shaving further keystrokes off of each operation, of
creating macros for every common task, of learning more and more. This is how
you should feel, all the time, with all of your tools.

Contrary to Vim, a tool like Sublime Text is easy to pick up and use. This is
a great advantage and the reason I recommend it to many new programmers. Be
careful, however, to recognize the distance between you and the horizon,
between your ability to type in some code and maybe use some multiple cursors
and the vast array of keyboard shortcuts, plug-ins, and built-in functions
that will make you a wizard of your craft. Don't fall into the tar pit of
immediacy.

Always seek out the shortest path to your destination. Reduce patterns to
scripts or macros. Look up keyboard shortcuts for frequently used operations.
If you are annoyed or slowed by anything, *anything*, do a quick search to see
if there is another tool that does it better. You don't have to solve these
problems of efficiency right away; by all means, get the job done, but come
back to your pet problems and find a way to solve them. Only then will your
toolbox truly be yours.
