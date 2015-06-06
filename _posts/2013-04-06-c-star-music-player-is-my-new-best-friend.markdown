---
title: C * Music Player Is My New Best Friend
layout: post
date: 2013-04-06 08:34
comments: true
categories: 
---
Have you heard of C * Music Player, also commonly abbreviated as its command 
name, `cmus`? If you haven't, you're potentially missing out on your new 
favorite music player (at least, since WinAmp 2.x; ahhh, those were the days).

C * Music Player is for UNIX-like OSes, which essentially means Linux and OS 
X. You can usually grab it through your package manager of choice (`apt` in 
Debian-based Linuxes, Homebrew in OS X).

It looks a little like this:

{% img /images/uploads/cmus-cmus_screenshot.png %}

That's `cmus` running in a tmux session in iTerm 2, using the Zenburn color 
theme that now ships along with it (finally).

You might be thinking, "Ugh, a terminal-based music player? How limiting." Not 
so. What if I told you that you could have global keyboard shortcuts and Growl 
notifications? Well, you can (at least in OS X). I'll tell you how.
~~MORE~~

_Full disclosure_: in order to get global hotkeys working in OS X, you need 
the Alfred Powerpack, which is not free. Alfred is an amazing launcher 
utility, faster and more awesome than Quicksilver and Butler. Seriously, you 
should try it, it's free. If you like it, you can buy the Powerpack and follow 
my instructions below to learn how use it to control lots of other things.

The Alfred Powerpack includes "workflows," a super-powerful visual 
scripting capability that can probably make a lot of things easier for you in 
the long run. I recommend supporting these guys, they make good stuff.

That said, if you are in a Linuxy type of environment, there will be some 
other way to create global keyboard shortcuts (in Xmonad you can plop them 
right into your `~/.xmonad/xmonad.hs`, for which there is massive amounts of 
documentation), but I'm not going to get into any of that in this article.

Even in OS X there are probably other ways, such as Quicksilver. What you need 
is the ability to bind a global keyboard shortcut to a _terminal script 
execution_, or a command, to put it simply.

## Yay, sockets!

`cmus`, by default, starts listening for remote control commands on a *UNIX 
socket* called, appropriately, `~/.cmus/socket`. UNIX sockets are awesome, 
even better than named pipes. So how does this help you to reach `cmus` 
nirvana? Through a little included utility predictably named `cmus-remote`. 
You can already see where this is going.

What we're going to do is wire up an Alfred workflow to listen for a key press 
like Control-Command-X and tell `cmus` to begin playing, then also print out 
and grep the current artist and track name, and send that along to Growl so 
that it displays what it's doing in the corner of the screen. Perfect.

Here is what the workflow looks like for the "play" command:

{% img center /images/uploads/cmus-alfred_workflow.png %}

It's the "Run Script" step that's interesting. Here is the script we're 
running:

``` bash
/usr/local/bin/cmus-remote -p && echo "$(/usr/local/bin/cmus-remote -Q | 
/usr/bin/grep 'tag artist' | /usr/bin/cut -d' ' -f3-) - 
$(/usr/local/bin/cmus-remote -Q | /usr/bin/grep 'tag title' | /usr/bin/cut -d' 
' -f3-)"
```

Evidently the `/bin/bash` environment that Alfred executes scripts within does 
not have any path configured, so I've had to put in the full paths to each 
utility, but that's not a big deal. Let me break down for you what's happening 
here.

First, we execute `cmus-remote -p`, which tells `cmus` to begin playing.

Next, echo the output of two sub-shell commands:

``` bash
cmus-remote -Q | grep 'tag artist' | cut -d' ' -f3-
```

``` bash
cmus-remote -Q | grep 'tag title' | cut -d' ' -f3-
```

Each command first runs `cmus-remote -Q`, which outputs the current status of 
`cmus`, including the currently playing track and so on. I use `grep` to find 
the line I'm looking for, which looks like `tag artist Artist Name` and use 
the `cut` command to get just the artist name itself.

With `cut -d' '` I am specifying that the field delimiter is a space, and then 
I'm asking for fields three through to the end (the trailing hyphen means 
"all following fields").

I then separate the output of each with a hyphen by using this bash construct:

``` bash
echo "$(first command) - $(second command)"
```

It's a very helpful little trick to know. This results in an output like 
"Artist Name - Track Name".

Then, I set up the Growl notification step in the workflow to actually include 
the previous command output in the message, which in Alfred you can achieve by 
using the special string `{query}`.

{% img center /images/uploads/cmus-growl_panel.png %}

Now when I press Control-Command-X, `cmus` begins playing and Alfred helpfully 
pops up a Growl notification saying "Play (Artist - Track)". I duplicated this 
workflow for each of previous track, next track, pause, and stop. It's 
amazing.

### OK, but why?

Why go through all of this work when you can just use iTunes or something? 
There are certainly tons of ways to remote control iTunes with the keyboard, 
and in fact, Alfred ships with support for it in its workflows, also.

The answer is... `cmus` is fast. It's fast and efficient and handles 
searching, organizing, and playing many thousands of tracks so much better 
than iTunes. Plus, I can keep it tucked away in tmux where I can get to it by 
keyboard when I'm in the middle of doing whatever it is I'm doing... Like 
writing this blog post.

Questions? Comments? That's what the form at the bottom of the page is for. Go 
for it.
