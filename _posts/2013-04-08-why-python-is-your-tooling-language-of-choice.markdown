---
title: Why Python Is Your Tooling Language of Choice
layout: post
date: 2013-04-08 06:55
comments: true
categories: 
---
{% img left /images/uploads/why-python/python_logo.gif %}

Python is, by far, the language of your choosing when you need to build a 
toolchain of utilities that interact with local systems, servers, other 
software, running processes, and generally all things outside of your 
application development.

I leave out application development because I still believe that when it comes 
to server-side application code that lives for exactly one user request, the 
best language is the one you are comfortable with. It may be Python, but it 
may also be Ruby, PHP, Scala, Erlang, Haskell, or one of those new-age sparkly 
languages such as Go or Rust.

Yet, as you dig deeper into forking processes, maintaining a running state, 
cleaning up after yourself (I'm talking about memory, I will assume that you 
bathe), and generally _acting predictably_, Python is, without a doubt, your 
chosen language.

Why? I'll tell you why.<!--more-->

First off, Python, you've heard of it? I hope so. Python is interpreted but 
bytecode compiled, and runs in its own "virtual machine" or "virtual 
environment." This gives it certain other advantages within the programming 
ecosystem but none of those are relevant to this conversation. It's easy to 
learn (relatively speaking) and enforces its scoping and nesting through 
indentation rather than curly braces or parentheses. This generally leads to 
cleaner (looking) code.

So what makes Python a better tooling language? You can certainly write Python 
web applications, but they are probably not fundamentally any more efficient 
or maintainable than the spaghetti code you wrote in any of the other 
languages I mentioned above. Any application of sufficient size and age, 
regardless of the language, becomes a bit like the New York City Subway 
system... Layers of old and new tunnels, with homeless people living in 
some of them.

Setting aside for a moment PHP's long-suffered garbage collection woes, many 
of which were resolved in at least the 5.3 release, and considering only 
language features themselves, the one thing that sets Python above the rest is 
the (somewhat new) *subprocess module*. Why is this awesome? Because shells 
suck.

Don't get me wrong, I love shells. I'm in a shell right now and I prefer 
shells to almost everything else as a human being who needs to interact with 
computers. But when programs need to interact with one another, shells 
seriously suck.

You should first read this nice explanation by Stefan Karpinski, which is 
focused more on the "julia" language but uses Ruby examples: [Shelling out 
sucks](http://julialang.org/blog/2012/03/shelling-out-sucks/).

What it boils down to is that UNIX programs like to talk to each other through 
pipes, and the easiest way for anyone to create a pipe in any arbitrary 
language of their choosing is to wire them together using the shell 
environment, because the shell gives you these tools out-of-the-box. 
Unfortunately, there are plenty of ways that things can go Wrong(tm).

In contrast, Python's subprocess module (which is now the only accepted method 
of interacting with external processes) can create the processes and wire up 
their pipes for you, without a shell in between. You can tell Python to use a 
shell, but it is strongly discouraged and in the majority of cases 
unnecessary.

If you have not had occasion to run afoul of spawning external programs and 
reading their output or passing them input... You probably need to do more 
hobby programming. That said, keep Python in mind, it will make your life a 
lot easier.
