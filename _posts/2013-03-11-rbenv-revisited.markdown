---
title: Rbenv Revisited
layout: post
date: 2013-03-11 21:28
comments: true
categories: 
---
A few days ago I wrote about my 
[experience with Rbenv](/blog/2013/03/08/rbenv-for-the-win/), the Ruby 
environment manager (is that what they call it?). My overall experience was 
good, but I did encounter a couple of hiccups getting the "ruby-build" plugin 
to work. While installing the whole kit once again on this cute new Ubuntu 
laptop, I figured it out.<!--more-->

I shouldn't have been so audacious as to try to install Rbenv using `apt` 
because, naturally, it isn't the latest version. When you run the `rbenv` 
command, it actually executes a bash script that hands off to the program that 
handles whichever command you are running. In other words, when you run `rbenv 
versions`, it hands off to `rbenv-versions`, if it exists in your path.

It's that "bootstrapping" bash script that is responsible for making sure that 
all of the necessary paths are searched for the program in question. The 
latest version (from github) actually looks through the `~/.rbenv/plugins` 
directory. The version from `apt` does not.

Serves me right. Fortunately, fixing it is easy:

``` bash
$ sudo apt-get remove rbenv
$ rm -rf ~/.rbenv
$ git clone git://github.com/sstephenson/rbenv.git ~/.rbenv
$ git clone git://github.com/sstephenson/ruby-build.git 
~/.rbenv/plugins/ruby-build
```

That's pretty much it. Remember to add the path stuff to your `~/.profile` or 
`~/.bashrc` or whatever. I share my shell configurations across several 
machines, not all of which use Rbenv, so I came up with this, which works 
nicely:

``` bash
if [ -d $HOME/.rbenv/bin ]; then export PATH=$HOME/.rbenv/bin:$PATH; fi
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
```

That will only change your path and import the Rbenv initialization settings 
if Rbenv actually exists. Harmony.

The next problem that I had was that Ruby had no OpenSSL support and refused 
to let bundler run. Ruby needs to be compiled with OpenSSL support, but I had 
built it using "ruby-build," which takes no options (and generally doesn't 
need to). Oddly it worked fine on the Ubuntu VM where I did this last time.

For whatever reason, this laptop didn't have `openssl` nor `libssl-dev` 
installed. The thing is, if you don't have `libssl-dev`, ruby won't be able to 
compile its built-in OpenSSL stuff, but it won't tell you this. Or, at least, 
it won't fail to build, and since `ruby-build` gobbles up all of the output of 
the build process, you probably won't know.

So the moral of the story is, on a virgin box, install `openssl` and 
`libssl-dev` before running your `rbenv install` stuff.
