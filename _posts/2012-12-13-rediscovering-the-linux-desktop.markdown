---
title: Rediscovering the Linux Desktop
author: Aaron
layout: post
comments: true
permalink: /2012/12/13/rediscovering-the-linux-desktop/
---
Here at the day job, we are slowly moving our (production) systems away from 
Windows and toward (Ubuntu LTS) Linux. The company has always been 
Windows-oriented, mostly due to the decisions of its President when it was 
founded, subsequent inertia, and the skillsets of the infrastructure teams. 
Now, though, we have an increased Linux knowledgebase in-house, we’ve started 
this reorientation toward PHP and other open-source products, and Linux just 
makes more sense.
<!--more-->

To help “grease the wheels” in the development process, we started toying with 
Vagrant and Chef to spin up local development instances, which has been a 
really interesting and satisfying endeavor. This whole Vagrant/VirtualBox 
thing is opening up new ideas about how to develop efficiently and about the 
malleability of server configurations that we’d never have considered up till 
now.

I even started to use Vagrant myself, for freelance projects, which I found to 
be gratifying. Gone are the days of guarding your VMware image with a 
pitchfork against the specter of data loss or corruption; with only your 
Vagrantfile in hand (and at least knowing which base image you used, which is 
important only to a point), you can spin up a replica of the system in 
moments.

But this isn’t meant to be a 500-word essay on how great Vagrant is. Dipping 
back into the Linux world made me yearn for some of the things that Windows 
(no offense to Cygwin) just can’t do. For example, I really love tmux, the 
terminal multiplexer. I have finally left GNU screen behind on my Mac, but 
alas, tmux doesn’t run in Cygwin because of the way the signals are passed 
through pipes or sockets or something that Cygwin can’t do.

This is a shame, because tmux increases my productivity, and I want my 
productivity to increase. So what to do? The obvious answer (to me, anyway) 
was to dust off this copy of VMware Workstation that they got for me and just 
run Ubuntu as an actual desktop. With a GUI. Give it the old college try once 
again. So I did that.

After running a large terminal window with tmux in it and feeling the joy of 
Firefox and Google Chrome acting, essentially, identically to how they do in 
Windows, and apt-getting basically the whole world at once, a thought came to 
me.

Window managers. Remember window managers?

If you’re reading this in Linux, the chances are pretty high that you fall 
into one of two groups:

*   You’re using Gnome or KDE as your default window manager because it was 
    installed with your distribution (like Ubuntu), or
*   You’re using your own window manager because hot damn there are so many to 
    choose from.

What the hell is a window manager, you might be asking, if you are a member of 
the former group? A window manager is a piece of software that manages your 
windows; their locations, sizes, behaviors, and so forth. Every GUI OS has 
some kind of a window manager, but it so happens that in Linux (as with most 
things in Linux), the window manager is not actually inextricably tied to the 
desktop or the launcher bar (“taskbar,” if you will), or any other aspect of 
the GUI experience.

Everything is separated out. Separation of responsibility. Like a good, 
organized OS should be.

So, which window manager to choose? I decided to give xmonad a try. Xmonad is 
a window manager written in Haskell that tiles your windows automatically. 
Windows can’t float (unless you force them to), and they self-organize using 
predefined patterns, which you can change. You also get virtual desktops as 
well, so you can have several screens of tiled windows and switch between them 
quickly.

So far, this is the best computing experience I’ve probably ever had. 
Everything is at my fingertips; I barely use the mouse. Xmonad is so fast, 
even in this virtual machine running inside of my Windows 7 desktop. I 
borrowed some configuration from folks on the Googlewebs to get things pointed 
in the right direction, but it was really not too hard to set up.

Here are some references:

*   [Obtaining a beautiful, usable xmonad configuration][1]
*   [How-to: Set up XMonad & XMobar on Ubuntu][2]

[1]: http://www.vicfryzel.com/2010/06/27/obtaining-a-beautiful-usable-xmonad-configuration
[2]: http://www.huntlycameron.co.uk/2010/11/how-to-set-up-xmonad-xmobar-ubuntu/

I lifted most of the config from those guys and followed their instructions.

I also wanted to do more in terminal windows, because terminals are badass, 
and when you’re doing everything with the keyboard you really don’t want to 
fiddle with GUI widgets (except for web browsing, and for that there’s Chrome 
Vimium, of course).

*   For the tweeting: TTYtter (so cool!)
*   For Gtalk: IRSSI & the irssi-xmpp plugin (the most stable console XMPP 
    client I have tried!)
*   For music: cmus (really nice once you figure out how it works. RTFM.)
