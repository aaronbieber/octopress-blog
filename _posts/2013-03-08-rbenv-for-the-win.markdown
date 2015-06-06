---
title: Rbenv For the Win
layout: post
date: 2013-03-08 10:34
comments: true
categories: 
    - ruby
    - howto
    - linux
---

I'm sure that this is not news to many of you, but rbenv is awesome. Because I 
faced some challenges along the way while setting up this Octopress blog 
environment and have now gone through the motions on both my Mac laptop and 
Linux desktop, I am going to take a few minutes to share my findings.

If you have no interest in using Ruby, you can move along.~~MORE~~

## What is rbenv?

For those who don't know, rbenv is a sort of \*NIX-oriented way of creating a 
Ruby walled garden with the precise version of Ruby itself and its associated 
gems captured in a way that doesn't affect the rest of your system. Primarily, 
this allows you to indicate a specific Ruby version that your application 
requires and ensure that it doesn't change. You can feel free to upgrade your 
system's Ruby distribution and it will not meddle with your application.

As an added bonus, gem-based tools like bundler are also captured and 
controlled by rbenv so you don't have conflicts with your system installation 
of bundler, for example. Getting all of this to work is actually not too hard, 
but it can be more of a challenge if you have, just for example, a Mac laptop 
that has had several Ruby applications run on it in the past and a muddle of 
bizarre gems scattered all around.

The general methodology of rbenv is very similar to Python's virtualenv (which 
serves essentially the same purpose on the Python side of the fence). You 
build Ruby itself into a specific location, load some path-management commands 
into one of your shell configuration scripts, and then whenever you run ruby, 
bundle, gem, etc., you actually run a "shim" command that rbenv provides, 
which redirects all of the internal Ruby path settings (classpath, basically) 
to find the precise stuff you're looking for.

Moreover, a handy little `.ruby-version` file is created in your application's 
directory when you choose a version, so that "tag," if you will, lives 
alongside your app and can inform other people what version they will need to 
satisfy with their own rbenv environments.

With rbenv and bundler combined, you can rest assured that all support 
libraries are sane and organized, which is pretty awesome.

## Installation

OK, so how do we install it?

I won't go step-by-step through the instructions that are already out there, 
but I will link to everything you need and explain some of the caveats and 
semi-weirdness that I encountered.

First, you need rbenv itself. If you are on a Mac, you should use Homebrew to 
install it, and that is covered in the [rbenv README][1].

[1]: https://github.com/sstephenson/rbenv

If you are in some flavor of Debian or Ubuntu or probably Gentoo, you can get 
rbenv from your package management system du jour, maybe something like this:

``` bash
$ sudo apt-get update
$ sudo apt-get install rbenv
```

Once that's installed, you are also going to want the `ruby-build` package 
also by Sam Stephenson, which streamlines the download and compilation of your 
selected version(s) of Ruby. This is covered on the 
[ruby-build github page][2], but I had some issue installing it as a plugin, 
which I'll cover next.

[2]: https://github.com/sstephenson/ruby-build

I attempted to clone the project straight in `~/.rbenv/plugins/ruby-build` as 
instructed, but rbenv could never find the command. I would run `rbenv 
install` and it would just tell me that the command could not be found. So I 
opted for the system-wide installation, which, at least in my case, is not a 
big deal because I'm the only user of the system. To do this, you clone the 
project wherever you want and run its installer script:

{% infobox %}
I finally figured this out; see 
[Rbenv revisited](/blog/2013/03/11/rbenv-revisited/) for the details!
{% endinfobox %}

``` bash
$ git clone git://github.com/sstephenson/ruby-build ruby-build
$ cd ruby-build
$ sudo ./install.sh
```

It will install the `ruby-build` executable into `/usr/local/bin` along with 
the `rbenv-install` and `rbenv-uninstall` plugin commands and then you can 
either run `ruby-build` itself, or run `rbenv install` to install new Ruby 
versions.

## Cautionary notes

None of the rbenv black magic works without updating your shell initialization 
scripts. For most folks (I think), this is one of `.bash_profile`, `.profile`, 
or `.bashrc`. For those using other shells, you know what your initialization 
script is. The [rbenv README][1] goes into detail about that, but suffice it 
to say, you need to update these files and explicitly source them or restart 
your terminal session before things will work correctly.

When it comes to building versions of Ruby, if you are using `ruby-build` 
directly as I am, you need to specify the installation location yourself. I 
recommend using the default location, `~/.rbenv/versions/<version name>`. So 
if you wanted to install 1.9.3-p392, you would run:

``` bash
$ ruby-build 1.9.3-p392 ~/.rbenv/versions/1.9.3-p392
```

I'm fairly sure that you can name the destination directory however you'd 
like, but it seems to make sense to name it for the exact Ruby version. Once 
the build completes, you will be able to set the version for any directory 
using `rbenv version`.

## That's it

So that's about it. If I left anything out that you have questions about, or 
if I was... You know... Wrong... About anything... Please leave a comment 
below! I'll reply, I promise.
