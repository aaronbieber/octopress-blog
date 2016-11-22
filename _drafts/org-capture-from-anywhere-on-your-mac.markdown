---
layout: post
title: "Org Capture From Anywhere on Your Mac"
---

Fair warning: this is a Mac-only post. What I will talk about is surely possible
in Windows, but I have no idea how, so don't ask. If you do know (or find out)
feel free to use the comments section to share your knowledge with everyone else
here.

I'm going to show you how you can create a "bookmarklet" button in your browser
that will capture a note or link directly into Org Mode in your running
Emacs. That's right, you press a button in, say, Chrome, and Emacs pops up and
displays your Org capture interface with the current webpage's information in it.

How is this achieved? Through a little bit of magic called "Org Protocol."
~~MORE~~

The goal of this exercise is to be able to click a button in Chrome and have
your already-running GUI Emacs pop up with a capture buffer open containing the
page title and URL of the webpage that was open in Chrome when you did that.

To accomplish this, we will use Org Protocol. The way it works is
straightforward to wire up on a Mac, but there are several moving parts. This is
what is going to happen:

1. You click a "bookmarklet" button in your browser, and

2. That bookmarklet is not a URL to a page, but rather a snippet of Javascript
   that composes a URL using a protocol prefix of `org-protocol://`.

3. Javascript tells Chrome to visit that URL. Chrome sees that the protocol is
   not internally supported (e.g. `http://`, `ftp://`, etc.) and so it defers
   to the operating system to find a "handler" for that protocol.

4. Through a bit of OS X magic, an AppleScript application has been registered
   as a handler of `org-protocol://` URLs, so it is run and given this data.

5. That AppleScript application runs `emacsclient` and hands it the URL, and
   then

6. `emacsclient` communicates with your already-running Emacs (though the
   server/client connection) and Org's Protocol module interprets the URL as a
   request to capture a specific template, which it carries out.

Why is it done this way? Primarily because the Emacs GUI program doesn't
register itself as a protocol handler on your system. It would be very
convenient if it did, and maybe someone can write a patch to support that some
day, but until then we have this AppleScript layer in between.

Let's get started.

## Build a Protocol Handler ##

