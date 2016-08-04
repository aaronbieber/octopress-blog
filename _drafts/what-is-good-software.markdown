---
layout: post
title: "What Is Good Software?"
tags: emacs vim software
---

I'm an opinionated software engineer. I have strongly held beliefs about what
makes a program good or bad (as I imagine most programmers do) but as a Vim user
for 15 years and now as an outspoken advocate for Emacs, I'm on the front lines
of a turf war that shows no signs of calming.

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr"><a href="https://twitter.com/aaronbieber">@aaronbieber</a> That doesn&#39;t mean he was wrong :-) Both code bases are pretty horrendous if you look, I&#39;m not sure either is good software.</p>&mdash; Michael Ellerman (@michaelellerman) <a href="https://twitter.com/michaelellerman/status/720587685597872129">April 14, 2016</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

Because 140 characters is barely enough to state the entirety of my opinion, let
alone its justification, here is a post on the subject.~~MORE~~

The crux of my opinion is that there is a difference between the objective
*code quality* of a piece of software and its *fitness for a particular
purpose*, to borrow the oft-used phrase from disclaimers.

When I say that Emacs is "better software" than Vim, I am not only remarking on
the well-known instances of [total insanity][insanity] in Vim's codebase, but
more importantly on the Vim project's reluctance to implement modern features
even in the face of broad and vehement user support and its uncertain future as
a project owing to its sole maintainer's neglect of organizational foresight.

[insanity]: http://geoff.greer.fm/vim/

## The Quest for Background Processing ##

As a proxy for the concept of "fitness for a particular purpose," I want to talk
about the ability of text editors to run background or asynchronous processes.

Perhaps the most coveted feature that the Vim project refused to add is support
for some manner of asynchronous process handling, or an event loop, or job
management, or something like that. For many years I suffered as Vim's single
process froze up completely while the Syntastic plug-in was running a syntax
checker on the large file I was editing.

Vim users begged for the ability to run a process in the background and receive
its output in a VimL callback function. A Yahoo engineer named Jonathan Palardy
wrote [slime.vim][vim-slime] to send commands or text from Vim to another
console or pane within GNU Screen (and someone else adapted it for
Tmux). Ironically, Jonathan's slime.vim is named for the
[Emacs package called SLIME][emacs-slime], which provides an in-editor REPL for
Common Lisp languages.

[vim-slime]: https://github.com/jpalardy/vim-slime
[emacs-slime]: https://en.wikipedia.org/wiki/SLIME

Intrepid Vim contributors even submitted patches to solve the problem. All
attempts to make this dream a reality were turned away by Vim's creator and sole
maintainer, Bram Moolenaar.

Such was the state of affairs in the Vim world until January 31, 2014 when a
young man by the name of Thiago de Arruda ([tarruda][thiago] on Github) boldly
forked Vim and set out on a project he named NeoVim. In the world of open source
software, a fork is either a compliment or an insult. I love it when people fork
my projects because they are small and mostly unimportant, and usually it means
that someone wants to contribute or cares enough that they want to play with
customizing it themselves.

[thiago]: https://github.com/tarruda

For Vim to be forked, though, in such an earnest manner, and with the intent not
to submit patches but to diverge into a separate project, was one of the first
real markers of bad project health.

The NeoVim project has had several releases beginning in late 2014 and is now
considered to be quite stable, though it is still far from version 1.0. In the
short time that the project has existed, it not only removed legacy preprocessor
definitions and modernized the make system, but it added support for
asynchronous job control, Lua scripting, and all sorts of other features that
Vim users worldwide had only dreamed of.

It was just as NeoVim was reaching usable stability and gaining traction as a
very real competitor to Vim that I began experimenting with Emacs and eventually
[gave the talk that made me (briefly) Internet famous][the-talk]. As a result, I
never actually tried NeoVim myself (and quite honestly I have no interest in
using it, though I'm still interested in its success as a project).

[the-talk]: https://www.youtube.com/watch?v=JWD1Fpdd4Pc

When I picked up Emacs, I discovered that it had all of the features that Vim
lacked. Though my first couple of attempts in years past had been fraught with
challenges that deterred me, I finally got Evil Mode working properly and
swiftly discovered an equilibrium between Vim's modal editing and Emacs'
peculiar modifier key karate.

Finally, in July of this year, one and a half years after NeoVim's inception,
Bram Moolenaar [announced Vim 8.0][vim-8]. It now includes jobs, timers,
partials (what I interpret to be a type of closure, sort of), lambdas, and
*actual package support*. I can no longer say that Bram did not listen, but I
can still criticize his early unwillingness and his "father knows best" attitude
about code contributions.

[vim-8]: https://github.com/vim/vim/blob/master/runtime/doc/version8.txt

## Project Health ##

Emacs is great because it is at least as stable and mature as Vim, which it owes
to its age and equally massive worldwide deployment, but it is also responsive
to users' requests and welcoming of their patches (sort of), and is even
entering a bit of a renaissance as younger technologists discover that it is not
simply Richard Stallman's altar to the principled but often stifling philosophy
of the GNU project, but a very capable and modern program indeed.

As a software project, Vim sucks because its creator and sole maintainer, Bram
Moolenaar, keeps a deadly strangle-hold on the project and reserves the right of
first refusal to incorporate enhancements or changes from the community. As I've
cited many times in the past, Bram went as far as to say, in not as many words,
that the best way to keep the Vim project alive is *to keep him alive*, which
implies that he has no interest in sharing that responsibility with the vibrant
community that grew around his project.

In contrast, the Emacs project has changed maintainers no fewer than two times
since Richard Stallman's reign. Not only is this a testament to the breadth of
the Emacs community, that we could find not one, and not even two, but three
qualified and motivated individuals to steer the project toward its community's
common goals, but indeed a sign of the project's health. We have nothing to fear
from the passing of time knowing that the Emacs project possesses the ability to
pass the baton quite effectively should it become necessary.

When Bram Moolenaar is no longer maintaining Vim, for whatever reason, who will
step up to the plate? Who will vet them? How will the community organize itself?
Bram has not taken any steps to build a community ecosystem around his project
and when the day comes that he is no longer in control, we can only guess at
what may happen.

## Extensibility Wins the Day ##

The final point I will make in my now extremely long-winded treatise on the
shape of great software, which has since devolved into yet another diatribe
pitting Vim against Emacs on a playing field of personal opinion, is that
extensibility is the single most important mechanism for solving most, if not
all, of the disparities between these projects.

Vim is extensible through modification of its C code and through scripting in
its built-in programming language called, officially or unofficially,
VimL. Emacs is extensible through modification of its C code and through
scripting in its built-in programming called Emacs Lisp, a variant of Common
Lisp.

Comparing VimL to Emacs Lisp is hardly fair; one is essentially an eccentric and
fairly limited DSL with demonstrable performance concerns, and the other is a
complete programming language in which approximately 3/4 of the stock program's
functionality is implemented. You can do a lot in both of them, but VimL is
limited in its usefulness because the majority of the way the program itself
functions is below the VimL level, in the C code. Emacs, on the other hand,
implements most of its editor behavior in Emacs Lisp and has a rich array of
event hooks and a sort of "mix-in" system for hooking user-defined functions
onto or around existing ones. The net effect is that nearly anything in Emacs
can be changed, easily.

Of course this rings true to anyone familiar with the pejorative expression
claiming that "Emacs is a great operating system, lacking only a decent editor."
It's fair to say that it is possible to change Emacs in such dramatic ways that
its flexibility can be almost comical when wielded without reason, but you only
need to struggle with the desire to change some simple key mapping behavior or
margin drawing functionality in Vim for a few hours before you start to
appreciate the judicious application of hooks into lower-level functions.

In conclusion, great software is defined by more than its objective code
quality; I would even go so far as to say that code quality is one of the least
important characteristics of software. Especially in open source, the greatness
of software lies in its ability to meet the needs of its users, and in its
leadership and community to adapt to the changing landscape around it.
