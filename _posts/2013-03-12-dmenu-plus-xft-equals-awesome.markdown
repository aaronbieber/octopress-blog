---
title: dmenu + xft = awesome
layout: post
date: 2013-03-12 17:16
comments: true
categories: 
---
Though I love my Macs, I often use Ubuntu. I have an old laptop running Ubuntu 
(which I'm typing this on right now) and I occasionally run Ubuntu in VMware 
Workstation or VMware Fusion just as an efficient alternative to Windows or 
when I'm doing something that is particularly Linux-friendly.

My favorite window manager right now is Xmonad, a tiling window manager 
written in Haskell. I know very little of Haskell, which makes navigating its 
configuration files, which are Haskell scripts, somewhat daunting, but the 
window manager itself is simple and incredibly fast.

There are two tools that everyone who uses Xmonad comes to love: xmobar and 
dmenu. The former places a persistent status bar at the top of the screen, 
which of course you can customize, and the latter is triggered by a keyboard 
shortcut and opens a one-line menu of programs in your path that is filtered 
as you type. The ultimate no-frills launcher.

This is the story of how I finally got Xft (anti-aliased TrueType fonts) 
working in dmenu. It makes it look amazing. Seriously.~~MORE~~

In order to get dmenu to use Xft, you need to patch the source and compile it. 
Fortunately, the patch is provided for you. Download the dmenu source and the 
patch for the same version from the links below:

* [Suckless Tools Dmenu](http://tools.suckless.org/dmenu/)
* [Dmenu Xft support](http://tools.suckless.org/dmenu/patches/xft)

Then all you have to do, in theory, is extract the source, apply the patch, 
and compile dmenu. Something like this:

``` bash
$ tar zxvf dmenu-4.5.tar.gz
$ cd dmenu-4.5
$ mv ../dmenu-4.5-xft.diff .
$ patch -p1 < dmenu-4.5-xft.diff
$ make
$ sudo make install
```

The third line is assuming that the `dmenu-4.5.tar.gz` and 
`dmenu-4.5-xft.diff` files were downloaded or moved to the same location 
before you began. There are other ways to do it, but you get the idea, I hope.

When I attempted to run this, in Ubuntu, it complained that it couldn't find 
freetype.h (or one of the other headers in the Freetype package). Funny, I'm 
sure I installed it.

Make sure that you do install the Xft libraries themselves:

``` bash
$ sudo apt-get install libxft-dev libxft2
```

Once you've done that, you may still get an error because dmenu doesn't ship 
with a `configure` script that scours around to find the various dependencies, 
and on top of that, dmenu doesn't have an Xft dependency... Until you patch 
it. Then it does, but it doesn't know where to find the headers.

Easily fixed!

Edit the `config.mk` file in the dmenu package and find the line that looks 
like this:

```
INCS = -I${X11INC} ${XFTINC}
```

And amend it so that it looks like this:

```
INCS = -I${X11INC} ${XFTINC} -I/usr/include/freetype2
```

If you are running Ubuntu I am 99% sure this will work, but you should do a 
sanity check to make sure that `/usr/include/freetype2` exists and contains 
the freetype headers (like `freetype.h`).

If you are certain you installed it but can't find them there, an easy way to 
sniff them out is:

``` bash
$ sudo updatedb
$ locate freetype.h
```

Just replace my path with yours if it's different. Then you're on your way!

``` bash
$ make
$ sudo make install
$ dmenu_path | dmenu -fn 'Inconsolata-10'
```

That's assuming you have installed the wonderful Inconsolata typeface. If not, 
you should try it!

``` bash
$ sudo apt-get install fonts-inconsolata
```

Now you're in dmenu anti-aliased font nirvana! Just add some colors and you'll 
feel even better:

```
dmenu_run -i -nb '#282b57' -nf '#eeeeff' -sb '#555a9e' -fn 'Inconsolata-10'
```

Beautiful. Pat yourself on the back, that was great.
