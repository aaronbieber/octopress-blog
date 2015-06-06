---
title: Why You Should Give ZSH Another Try
layout: post
date: 2013-11-19 18:32
comments: true
categories:
---

If you're already a fan of "the Z shell" (zsh), you may not need to read any 
further. If, however, you're like me and have spent years in the Bourne Again 
shell (bash), it might be time to re-evaluate your choice.

I have used bash for a long time and reached a fair proficiency level in it. 
I was doing things like looping over program output, filtering it, using 
utilities like `seq` and `wc` all the time. I could re-run commands from my 
history in more than one way and reverse-search them with Ctrl-R. None of this 
was news to me.

But then someone told me about this Z shell configuration package called "oh 
my zsh," and I decided to dangle my toes into the waters of the Z shell and 
see what it's all about. After all, the OS X terminal drops you into zsh by 
default; there must be something to it.

I'm never going back.~~MORE~~

To begin, here are some specific reasons you should drop bash or tcsh or csh 
and use the Z shell:

1.  The number one reason to consider zsh as a replacement for the shell you
    already use is ubiquity. You're going to be much more likely to actually
    find zsh on any given machine than newfangled shells like "fish." If you
    only ever use your own single personal computer this doesn't matter as
    much.
2.  The features, oh the features! The bulk of this post will be about these
    features so I will leave it at this for now. Suffice it to say, there are
    a couple of options that are so killer that I can never go back to bash.
3.  The "oh my zsh" system provides a further ecosystem of themes and
    extensions that other people maintain, giving you some awesome
    off-the-shelf capabilities as well as a very reasonable framework in which
    to create your own, if you wish.

Curious? Let's dig in.

## Get Started Right Now

If you're like me, you're more of a *doer* than a *reader*. If you want to see
what all the fuss is about, here is how you can do that right now:

1.  Make sure you have zsh installed. It is the default shell in OS X and
    sometimes CentOS; other flavors of Linux may need a quick install. For 
    Ubuntu, `sudo apt-get install zsh`, for Gentoo `sudo emerge zsh 
    zsh-completion`.
2.  If you want to try "oh my zsh", get it [on the oh-my-zsh Github page][1].
    I highly recommend it, but be prepared to read another README and follow
    more installation instructions.

[1]: https://github.com/robbyrussell/oh-my-zsh

## Oh, the Features!

As a long-time bash user, perhaps the single most game-changing feature that 
zsh offers is insanely good command completion. What do I mean by "good?" 
Well, zsh sometimes unexpectedly completes things that I've accidentally typed 
using the wrong case, its menu completion is (to my mind) easier to use 
because it highlights the selected item. On top of those, it's all 
configurable (the Linux user's dream).

There are straightforward options for whether to ring the terminal bell when 
starting an ambiguous completion and whether to use menu completion 
immediately or attempt a regular inline completion first. Let's talk about 
these options now.

First, you can see a list of **all** of the options on this handy webpage 
maintained by a Hungarian University. This is the page I used as a reference; 
I'm not sure why it's in English or why it's so highly ranked by Google, but 
here it is: [ZSH options](http://www.cs.elte.hu/zsh-manual/zsh_16.html).

In zsh, you set and unset options using the commands `setopt` and `unsetopt`. 
Zsh has a semi-unique way of dealing with options: the names themselves are 
not case-sensitive and the underscores don't even matter. In other words, 
`APPEND_HISTORY` is the same as `Ap_pEND_hIs_t_ory` or just `appendhistory`.

Similar to Vim, you can negate an option by prepending "no" to it. Thus, 
`setopt noautomenu` is the same as `unsetopt automenu`.

With me so far? Excellent. Here are the options that I have set and why:

`autolist`
: When you press tab to try to autocomplete your entry, if the completion 
  is ambiguous (what you have typed is not unique), immediately display the 
  list of possible completions.

  Note that if you like the behavior of `menucomplete` described below, you 
  probably won't need to set this option, as `menucomplete` supersedes it.

`autonamedirs`
: Zsh has a really neat feature where you can "name" directories and then use 
  the name instead of the full directory path anywhere where a normal path 
  would be accepted. This option tells zsh that if you set an environment 
  variable to a literal path, that environment variable should also be 
  accepted as a name for that path when preceded by the `~` (tilde), which is 
  how zsh normally identifies the names of named directories. I'll dig into 
  this a bit more later on.

`cdablevars`
: This basically says that if an argument is expected to be a directory and 
  all other shell expansion has failed to produce a directory, also try to 
  expand it as though it were the name of a named directory, even though it 
  doesn't begin with the `~` character.

`histignoredups`
: Don't record duplicate commands in the history. Because honestly, did you 
  need to know how many times you had to repeat the same command? It's just 
  embarrassing.

`listtypes`
: This causes the menu completion display to include characters indicating the 
  types of the items (symbolic links, executables, etc.)

`menucomplete`
: When attempting a completion on an ambiguous match, instead of simply 
  appending all remaining characters shared by all possible matches and 
  waiting (which is the usual behavior in most shells), immediately insert the 
  entire first possible match and display the completion menu. This is better 
  experienced than described, so try it out and see if you like it. I do.

`nolistbeep`
: Zsh will emit a terminal bell when you attempt to do an ambiguous 
  completion... Unless you set this option. Which I strongly recommend.

These are the options that I'm pretty happy with so far, although I'm still 
tweaking things here and there. Now let's get into the serious stuff!

{% infobox %}
Since I wrote this, I have decided that `menucomplete` is kind of annoying. 
When `menucomplete` is turned on, you can't drill down into partial 
completions by adding disambiguating characters because the menu appears 
immediately. So, give it a try, but I turned it back off.
{% endinfobox %}

## What's in a Name?

Zsh has this pretty fantastic feature called named directories. If you are 
familiar with Linux shells at all, you are probably by now quite used to using 
`~` to stand in for the path to your home directory. This is supremely 
convenient when you want to, for example, copy a file from your current 
directory to your home directory, like this:

``` sh
$ cp some_file.txt ~
```

Much easier than having to type out `/home/myusername/` or whatever it may be. 
So that's swell, but what if you could create your own symbols for long 
directory names that you use often? In zsh you can!

The whole concept of "named directories" is based on zsh's "expansion" system, 
which you can read about in detail on [this page][2]. Essentially, if any word 
entered at the zsh prompt begins with a tilde (`~`), zsh attempts to expand it 
in a few ways. Note that you can force this expansion "live" on the prompt by 
pressing tab (which is sometimes really helpful and cool).

To name your own directory, all you need to do is define a shell variable (in 
zsh they call these "parameters;" I'm not sure why) that begins with a forward 
slash. Obviously named directories must be absolute, so that might be slightly 
limiting, but let's look at an example.

Let's say you run an Apache webserver and the root of your main website is 
located at `/var/www/awesomesite`. Even with tab completion it can be annoying 
to type that over and over, so let's create a very short name for it:

``` sh
$ export wroot=/var/www/awesomesite
```

In the above example, I have used the `export` command at the prompt to 
immediately add this variable to my environment. You can add that exact line 
to your `.zshrc` so that it is permanent (without the dollar sign prompt 
obviously). Now, if you want to change directories to your web root, you type:

``` sh
$ cd ~wr<tab>
```

When you press tab, if there are no other named directories starting with 
"wr," it will expand your command line to `cd ~wroot/`. You saved at least six 
or seven keystrokes even accounting for tab completion with the original full 
path. You can also use the `~wroot` shorthand anywhere where zsh expects a 
path and it will work. For example, `touch ~wroot/foo.txt` will work. Think of 
the possibilities.

So what if you wind up with a whole bunch of named directories? No problem, 
zsh will continue to use your various completion options to disambiguate what 
you have typed, including the same menu it uses for normal commands and paths 
as described above.

Named directories is one of my favorite zsh tricks.

## What Else?

There are obviously a lot of options available and I have only scratched the 
surface here. I am still learning which combination of options I really like, 
but maybe you have some experience or ideas as well; feel free to share them! 
Remember, sharing is caring.

[2]: http://www.cs.elte.hu/zsh-manual/zsh_6.html
