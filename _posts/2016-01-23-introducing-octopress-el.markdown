---
layout: post
title: "Introducing Octopress.el"
date: 2016-01-23T17:41:34-05:00
---

If you've ever scrolled all the way to the bottom of this blog, you'll know that
I use Octopress (a Jekyll-powered blogging system written in Ruby) to build
it. What I like about Octopress is a subject for a different post, but I like it
a lot.

Of course, as an Emacs user, it pains me to drop to a command line to do
something that should be part of a fluid text editing workflow, and blogging is
a great example of such a scenario.

To solve that problem, I wrote Octopress.el, an Emacs package for blogging with
Octopress. Using Octopress.el, you can view your drafts and posts, publish,
unpublish, build, preview, and even deploy your Octopress blog right from within
Emacs!

Octopress.el can be installed **right now** from MELPA (package name:
[octopress][melpa]), or downloaded from my Github (repository:
[octopress.el][gh]). Go get it, give it a try, send me issues or pull requests,
and get blogging!

[melpa]: http://melpa.org/#/octopress
[gh]: https://github.com/aaronbieber/octopress.el

If you want to go on more of a detailed tour, continue reading!~~MORE~~

## How To Octopress ##

Naturally you need to have Octopress. I won't cover how to get started with it;
if you want to begin using Octopress,
[follow the instructions here][getocto]. Note that Octopress.el will *only* work
with Octopress 3.0, the gem distribution of Octopress.

[getocto]: https://github.com/octopress/octopress

It's recommended that you use Bundler to install Octopress. If you have done so,
and a Gemfile is present, all Octopress commands will be prefixed with `bundler
exec` automatically so that your project local gems are used.

The only configuration that Octopress.el requires is the location of your
blog. At this time, it only supports working on a single blog. If you begin to
use Octopress.el without configuring your blog location, you will be prompted to
enter it.

You can preconfigure your blog location by setting the custom value
`octopress-blog-root` through the `customize` facility, or by setting the
variable in your init files somewhere. If you have only one blog, this is
convenient because you can run Octopress.el from anywhere within Emacs and begin
working on that blog.

### Starting Octopress.el ###

The main entry point into Octopress.el is the interactive function
`octopress-status`. Similar to Magit and others, that function will pop to a
status buffer displaying statistics about your blog and file lists that you can
use to interact with your posts and drafts.

Several key bindings are available and you can view a menu of them by pressing
`?`. The "Drafts" and "Posts" headings can be expanded or collapsed by pressing
`TAB`, and pressing `RET` on a file item will open it for editing.

### Creating and Previewing ###

Most of the commands should be self-explanatory, but I will go into a little bit
of detail on the "build" and "server" functions because they are slightly more
complicated.

Some commands have sub-selections or flags. For example, when you press `c` to
create a new item, you will be prompted to choose whether you want to create a
"draft," "post," or "page." Press the letter in brackets to indicate your
selection.

The "build" and "server" commands have flags, which configure which objects are
included in your build or served by the local preview server. By pressing the
letters in brackets, the color of the item will change to indicate whether the
flag is on or off. To accommodate sight disabilities, the faces used for enabled
and disabled flags is customizable through the `customize` facility. In
addition, the default flag settings can also be customized.

### Publishing and Unpublishing ###

Once you are happy with a draft and you're ready to publish, select the draft in
the list and press `P`. Octopress will convert your draft into a published post
and, if that draft is open in some window, Octopress.el will swap the window
contents to display the post. If you elect to unpublish a post, the opposite
will happen.

Note that if you remove the "date" metadata from a post *before* unpublishing
it, Octopress will throw a confusing nil error and fail. This is just an
Octopress thing, so don't mess with the posted date until it's converted back to
a draft.

### Happy Blogging ###

So that's it, a crash course on Octopress.el. I hope you enjoy using it as much
as I do, and if you find issues please open them on the Github repository so I
can dig in, or better yet, send a pull request with your fix!
