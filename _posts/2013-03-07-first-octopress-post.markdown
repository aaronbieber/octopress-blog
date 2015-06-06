---
title: First Octopress Post
author: Aaron
layout: post
date: 2013-03-07 11:34
comments: true
---

I have migrated the clunky, dusty old Wordpress blog into Octopress, the 
spiffy, mostly-Ruby-powered, static blog site generator. While the primary 
impetus for this migration was the promise of editing all of my blog posts 
directly in Vim, it's also pretty cool to have the whole site built on SASS 
and sitting in a Git repository on my laptop.

If you want to know more about why this is awesome and you should do it, too, 
read on.~~MORE~~

There are a few reasons that Octopress is the correct choice for the hacker 
writer:

1. Use your choice of editors (my primary reason for trying it out).
2. Complete control over the layout and styles without wrangling complicated 
   themes or PHP code or whatever else.
3. Total version control; place your entire blog site, including the Octopress 
   application code that generates it, into a VCS repository.
4. This is a big one. **Static sites have almost no security concerns**. This 
   blog is generated on my local machine and sync'd to my live server with 
   `rsync`. You can't hack it because it's not an application.
5. What could be faster than serving static files? All the dynamic aspects are 
   Javascript plug-ins (Disqus for comments, Smarterer on the right side, 
   sharing on social networks, etc.)

It feels wonderful to be able to write a blog post with sane line wrapping and 
text formatting (in Markdown, of course) and then have that content translated 
to HTML and cross-referenced with the other pages of the site automatically. 
This approach puts content creation where it belongs (on the desktop), and 
presents the data in hypertext where *it* belongs (on the web).

Can't remember when you wrote that article about XYZ? Just grep it.

In any case, this is a new experiment for me, so bear with the layout and 
styles of the site as I continue to hone them, which I'm sure I will do.
