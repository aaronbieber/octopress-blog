---
layout: post
title: "Dig Into Org Mode"
---

Org mode was one of the main reasons I tried Emacs (and left behind 15 years of
Vim), and now it is a central part of how I organize my work. Org mode can help
you take notes, track tasks, build agendas, process tabular data, and more. It's
so flexible that everyone uses it differently.

I use Org mode primarily to capture tasks and keep track of their progress. I
sometimes take notes in Org mode, but I haven't completely fleshed out my
note-taking and searching workflow, so I'll talk mostly about task management
here.~~MORE~~

## Org Setup Essentials ##

Before you can start building a refined Org workflow, you need to set up some
basics.

### Define Your Todo States ###

Org mode keeps track of the state that a task is in by applying a keyword to it,
usually something like "TODO" or "DONE." The keyword appears at the beginning of
every task and Org lets you cycle through them easily to track task
progress. When you use a list of keywords that describe a progression of states,
Org calls that a "sequence."

You can also configure multiple sequences of task states and use key bindings to
toggle between the sequences, but I haven't found a use for that feature
myself... Yet.

The easiest way to set your default task sequence is by setting
`org-todo-keywords`, like this:

~~~cl
(setq org-todo-keywords
    '((sequence "TODO" "IN-PROGRESS" "WAITING" "|" "DONE" "CANCELED")))
~~~

The observant among you will notice three things about this configuration:

* It is a list of lists. This supports the multiple sequences I mentioned above.
* My sequence starts with the symbol "sequence." That tells Org that the
  following items are a sequence of states rather than a list of task types.
* One of the items is a pipe. The pipe is optional, but if it is present, the
  task states following it will all be considered by Org to mean "complete." I
  use it to mark tasks as DONE or CANCELED.

If you wish to configure your task states differently in each Org file, you can
use a line like this at the top (the syntax, including the pipe, is the same):

~~~
#+TODO: TODO IN-PROGRESS WAITING | DONE CANCELED
~~~

Even more about Org states is covered in [Workflow states][wfs] in the Org
manual.

[wfs]: (http://orgmode.org/manual/Workflow-states.html#Workflow-states)

### Define Your Agenda Files ###

I keep all of my Org files in a single directory in my Dropbox
(`~/Dropbox/org`). I like to keep a single file for tasks and a single file for
notes, but you can absolutely break it up into as many files as you wish, or
create a new file for each meeting or set of notes.

For pure task management, Org's agenda features are so rich that it almost
doesn't make sense to edit the task file itself, so I keep all tasks in a single
file, `~/Dropbox/org/tasks.org`.

The "agenda" is a specific feature of Org that lets you view summaries of the
data in your task files, manipulate their parameters, and even use search and
tags to build your own custom views. Before you can do any of that, you need to
teach Org where to look for all of the files you wish to include in your
agenda.

You can do that by setting `org-agenda-files`:

~~~cl
(setq org-agenda-files '("~/Dropbox/org/"))
~~~

If you know a little Elisp you may notice that the variable is set to a list. If
you store your task files in more than one location, you can supply each of
those locations in the list (like `'("/dir/one" "/dir/two")` and so on).

## Basic Usage ##

Now that you've set all this stuff up, how do you actually use it?
