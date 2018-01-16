---
layout: post
title: "Organizing Notes With Refile"
date: 2017-03-19T10:40:12-04:00
---

{% img noborder /images/uploads/organizing-notes-with-refile/refile-screenshot.png %}

As the first quarter of the year reaches its end, my department is deep into
planning the work we will do in the second quarter. As you all know, I use Org
Mode to sort out all of the details of my work life, including imminent tasks,
meetings I need to schedule, and projects I want to work on.

For the last three months I've kept notes for all of the projects that my team
could possibly put effort toward, as I thought of them. This resulted in a
pretty haphazard list of rough ideas and specific tasks intermingled. I needed
to get this into a clean, prioritized list... So I learned how to use Refile.

Let me teach you how to use it, too.~~MORE~~

## What Is Refile?

The first thing you should do is RTFM, so check out manual section [9.5, Refile
and Copy][refile]. It's not long, I'll wait right here.

[refile]: http://orgmode.org/manual/Refile-and-copy.html

The executive summary is that the Refile command allows you to move an element
of an Org file (and its children) to another location by doing a narrowing
search for the target location. You can do this arbitrarily, in any Org file,
with `C-c C-w`, but you can also use the same command to immediately refile a
new node from the capture buffer (also extremely handy).

In other words, once you have Refile itself set up to your liking, you never
again have to worry about whether a note or task is in the right place. It
becomes trivial to copy or move it somewhere else.

## The Configuration

As with all things in Emacs, the Refile command is quite configurable, so your
mileage may vary based on how you personally use Org Mode, but here I will
present your options and what I've chosen to do.

The main thing you can configure about Refile is where the target list comes
from and how it is presented. By default, Refile will assume that you'd like to
move a node to one of the headings within the same Org buffer (a top-level
heading).

That's fairly limiting if, like me, you have divided your Org notes and tasks
across several files, perhaps using `org-agenda-files` to allow the agenda view
to see them all. For this example, let's assume that we have a file called
`backlog.org`, which contains all possible projects, and another file called
`projects.org`, which represents "live" projects.

What we want to be able to do is move project nodes from `backlog.org` to some
location in `projects.org`, either under a parent node for some existing
project, or at the top level, as an entirely new project.

We need a few configurations to make that possible.

### Refile Targets

First, we must set the value of `org-refile-targets`, which tells Org how to
find the possible targets. Be sure to read the documentation for this variable,
because there are a few ways to define targets, but for this scenario, I want to
be able to move a node to any of my agenda files, and I also want to consider
nodes up to three levels deep.

That's exactly what this setting will do.

```cl
(setq org-refile-targets '((org-agenda-files :maxlevel . 3)))
```

With this set, you can trigger Refile with `C-c C-w` in any Org file and get a
completing read of all headings up to three levels deep in all files in
`org-agenda-files`.

If you use Helm, _which you really should_, you will see a very pretty
hierarchical display of possible targets. You can type a filename to narrow down
to headings within that file, and so on.

### Refile to the Top Level

You may have noticed that all of the targets listed are existing headings. So
how can you refile a node to the top level within a file? To do that, we'll need
to reconfigure the way Org generates the targets to be aware of their outline
paths.

This is sort of a trick; you will have a generally cleaner and prettier
experience with Refile if you don't need to do this, but this is the only way to
do top-level refiles. We configure `org-refile-use-outline-path` to tell Org to
include the destination file as an element in the path to a heading, and to use
the full paths as completion targets rather than just the heading text itself.

What this results in is a targets listing containing forward-slash-delimited
filenames and headings, as though they were paths on disk. Because the filename
also appears by itself, you can select that to refile to the top level of the
file.

```cl
(setq org-refile-use-outline-path 'file)
```

But, if you use Helm, _which you really should_, you will notice that as soon as
you set this option, your target list contains only one filename. Typing to
complete may allow you to find another filename within your agenda files, but
you will only ever see a filename; no other headings ever appear! Why is that?!

It took a bit of searching to find this solution. This is because the default
behavior for Refile is to allow you to do a step-by-step completion of this
path, but if you're using Helm, Helm is overriding the completing read to make
it into a narrowing list (that we have all come to love).

So what you need to do is tell Org that you don't want to complete in steps; you
want Org to generate all of the possible completions and present them at
once. Helm then lets you narrow to the one you want.

```cl
(setq org-outline-path-complete-in-steps nil)
```

### Creating New Parents

Occasionally you may want to refile something into another file or heading and
place it beneath a new parent that you create on-the-fly. If you do not set up
this configuration, you will not be able to create new parents during refile, so
I recommend setting it up.

```cl
(setq org-refile-allow-creating-parent-nodes 'confirm)
```

This means "allow me to tack new heading names onto the end of my outline path,
and if I am asking to create new ones, make me confirm it." For the simplest
case, you allow Helm to narrow to what you want and hit `RET` and you're
done. If you want to create a new heading, you must add `/New Heading` to the
end, and upon accepting that entry, Org will prompt you to confirm that you want
to create a new heading called "New Heading."

This can be useful if you are refiling a bunch of stuff and you have an idea of
the new structure you want and you don't want to have to bounce between files
creating new parent headings that will become targets. You can just use Refile
itself to build the structure that you want.

## Conclusion

Refile is a powerful way to reorganize your notes once you've taken them. Once
you have mastered the Refile feature, you will no longer pause when making a new
note, wondering if you're putting it in the right place or expressing the
ideal relationship between items. Refile gives you the power to dynamically
restructure your existing and new notes in the blink of an eye.

If you liked this, let me know in the comments below, and share it with your
friends and followers!
