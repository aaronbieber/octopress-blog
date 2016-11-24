---
layout: post
title: "Org Capture From Anywhere on Your Mac"
---


I'm going to show you how you can create a "bookmarklet" button in your browser
that will capture a note or link directly into Org Mode in your running
Emacs. That's right, you press a button in, say, Chrome, and Emacs pops up and
displays your Org capture interface with the current webpage's information in it.

{% infobox %}
Fair warning: this is a Mac-only post. What I will talk about is surely possible
in Windows, but I have no idea how, so don't ask. If you do know (or find out)
feel free to use the comments section to share your knowledge with everyone else
here.
{% endinfobox %}

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
register itself as a protocol handler on your system. It would be convenient if
it did, and maybe someone can write a patch to support that some day, but until
then we have this AppleScript layer in between.

Let's get started.

## Build a Protocol Handler ##

The code necessary to implement a system-level protocol handler in OS X is
surprisingly simple, especially if you write it in AppleScript. Any application
package whose `Info.plist` defines a "URL scheme" you want to respond to and
that lives in `/Applications` is automatically registered as a handler for that
scheme.

In the AppleScript code, you write an `on open location` routine that accepts
the whole URL as an argument, and do what you want with it. In this case, we
take that URL and pass it on as an argument to `emacsclient`.

Because I am a polite and generous
hacker, [I have already written this for you (Github)][oph]. Other solutions do
already exist, but I wrote my own for three reasons:

1. To learn how (chiefly),
2. To display a desktop notification letting you know that it worked, and
3. To focus GUI Emacs (if it's running) when capture is triggered.

[oph]: https://github.com/aaronbieber/org-protocol-handler

The README within this project explains how to install and configure the
protocol handler application. Essentially, edit the path to `emacsclient` if
necessary and drop the application itself into `/Applications`. That's it.

## Configure Emacs ##

The canonical guide for configuring Org Protocol
is [available on the Org Mode website][org-protocol]. You should skim that guide
and pay special attention to the following details:

[org-protocol]: http://orgmode.org/worg/org-contrib/org-protocol.html

1. The `org-protocol` package should be included with your distribution of Org
   Mode, so you don't need to install anything.
2. You do need to `(require 'org-protocol)`, because that package isn't loaded
   by default, and finally
3. You need to have the Emacs server running.

I have added `(server-start)` to my init file so that the Emacs server is always
started when Emacs starts. The overhead involved in running this server
interface is quite low.

If you just want to store a link to the current page for later insertion into an
Org file, you don't need anything else. If you want to capture the current
page's URL, title, and any selected text into a new Org element (using
"capture"), you will need to set up a capture template.

Before getting into capture templates, let's get a simple bookmarklet working.

## Storing a Link ##

To store a link for later insertion into an Org file, I use this bookmarklet:

```
javascript:location.href='org-protocol://store-link://'
    +encodeURIComponent(location.href)+'/'
    +encodeURIComponent(document.title)+'/'
    +encodeURIComponent(window.getSelection())
```

{% infobox %}
Note that I've added newlines and indentation here strictly for legibility; you
should format this as a single continuous line for use in your browser.
{% endinfobox %}

Create a new bookmark and supply this string as the URL. I think it really works
best if you use a bookmark on your bookmarks toolbar so that it is a button you
can click on. When you click that button, your browser will attempt to visit
this URL, which runs the Javascript that does all the magic.

If you've followed along closely up till now and you have Emacs and its server
running and the Org Protocol Handler app in your `/Applications` directory and
you click this bookmarklet, a desktop notification should appear informing you
that the link has been saved.

Within Org you should be able to press `C-c C-l` to insert a link, and the first
item should be the URL of the page you were viewing when you pressed the
bookmark button! If not, you screwed something up!

## Capturing Notes ##
