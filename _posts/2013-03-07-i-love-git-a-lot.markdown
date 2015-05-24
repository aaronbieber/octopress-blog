---
title: I love git. A lot.
author: Aaron
layout: post
date: 2013-03-07 19:11
comments: true
categories: 
---
I love git. A lot.

Judging by the growing ubiquity of github.com in nearly every corner of 
digital life that can be captured in text form, I have concluded that I am not 
alone in this sentiment. So much do I love git and github.com that I have 
taken to using it for as much as possible.

My latest thing is dotfiles. You know all of those preference and settings 
files that start to pile up in your Mac or Linux home directory? The ones that 
start with a period? For a while I had been keeping the longer, more important 
ones on github.com, which is really helpful when using a new computer or 
reinstalling your OS from scratch.

Today, though, I took it to the next level. Want to know more?<!--more-->

Maybe this isn't an Earth-shattering, life-changing revelation, but it 
occurred to me that every time I clone this repository I wind up copying out 
the files I want and then sort of forgetting about it, neglecting it, and 
letting the various files on different computers fall out of sync.

I don't like things to get neglected and I don't like it when things are out 
of sync. I have been storing my whole Vim configuration in a git repository 
for a long time and now I could never give that up. It's too easy to pull the 
changes that I made into a different environment or to set up Vim on a new 
computer (or server).

Actually, the only dotfiles I store so far are:

```
.bashrc
.gitconfig
.screenrc
.tmux.conf
.ttytterrc
```

And even among those, `.screenrc` is sort of redundant because I now use tmux 
almost everywhere. That said, I wanted to build up a storage and installation 
system for dotfiles that I could use anywhere... So I did.

You can see the repository for yourself in its entirety [on github.com][1], 
but the really magical part is this little bash script called `linkall`.

[1]: http://github.com/aaronbieber/dotfiles

It's so short, I'll show you the whole thing right here:

``` bash
#!/bin/bash

# Get options.
LNOPTS=""
if [ $# -gt 0 ] && [ "$1" == "-f" ]; then
	LNOPTS="-f"
else
	echo "Unrecognized option '$1'!"
	exit 1
fi

# This appears to be the "best" way to get the canonicalized path to where this 
# script is located, which is, presumably, where all of my dotfiles are.
# Lifted from http://stackoverflow.com/a/4774063
pushd `dirname $0` > /dev/null
SCRIPTPATH=`pwd`
popd > /dev/null

pushd ~ > /dev/null
for dotfile in `find /Users/airborne/dotfiles -type f -iname '.*'`; do
	(echo -n "Linking ${dotfile##*/}... ")
	ln -s $LNOPTS "$dotfile" "${dotfile##*/}" > /dev/null 2>&1
	if [ $? -eq 0 ]; then
		echo "OK"
	else
		echo "Failed"
	fi
done
popd > /dev/null
```

All it does is scan the directory it lives in for files starting with a period 
(it skips directories right now because I don't store any in my dotfiles repo 
except for the `.git` repository metadata directory itself, which should not 
be linked to from elsewhere) and creates symbolic links to them from the 
running user's home directory.

In short, a file like `.bashrc` stored alongside `linkall` gets a symlink 
created called `~/.bashrc`. Additionally, to be safe, it will not overwrite 
existing files or symlinks and will instead print "Failed" for that file. If 
you are sure you want to wipe them out and replace them, just pass `-f` to the 
script.

{% infobox %}
There is only a small amount of bash-fu in this one; feel free to drop me a 
comment below if you'd like me to explain how any of this actually works.
{% endinfobox %}

How cool is that? So now, on a new system, and assuming that git is installed, 
setting up all of my preferences is as simple as:

``` bash
$ git clone git@github.com:aaronbieber/dotfiles
$ dotfiles/linkall
```

Now, when I want to make changes to my `.tmux.conf`, for example, I don't have 
to remember to copy anything. `vim ~/.tmux.conf` will edit the file in the 
repository so that I can later push it up and receive those changes on my 
other machines.

How cool is that?
