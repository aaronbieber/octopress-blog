---
layout: post
title: "Dig Into Org Mode"
---
Org mode was one of the main reasons I tried Emacs (and wound up leaving behind
15 years of Vim), and now it is a central part of how I organize my work. Org
mode can help you take notes, track tasks, build agendas, process tabular data,
and more. It's so flexible that everyone uses it differently.

I thought I'd share my workflow and some of the settings and functions I've
changed or added that might help you get started with Org mode, or get more out
of it.~~MORE~~

I use Org mode primarily to capture tasks and keep track of their progress. I
sometimes take notes in Org mode, but I haven't completely fleshed out my
note-taking and searching workflow so I'll talk mostly about task management
here.

## Define Your Todo States ##

Org mode keeps track of the state that a task is in by applying a keyword to it,
usually something like "TODO," "IN-PROGRESS," or "DONE." The keyword appears at
the beginning of every task and Org lets you cycle through them easily to track
task progress.

You can customize `org-todo-keywords`, or you can put a line like this at the
top of your Org file:

~~~
#+TODO: TODO IN-PROGRESS WAITING DONE
~~~

Org will then use those keywords when working on that file. It's up to you how
you want to set them. You can also have multiple sets of task keywords in the
same file, but I haven't found a need for that yet so I won't talk about it
here.

I use the keywords above, but your workflow is probably different so you may
want more or fewer states. There is also a way to have multiple "done" states
(such as "CANCELED") so that Org knows that a task no longer requires your
attention, but it isn't marked strictly as "done." There is an annotation format
for that, which is covered in [Workflow states][wfs] in the Org manual.

[wfs]: (http://orgmode.org/manual/Workflow-states.html#Workflow-states)

## Define Your Files ##

Org can manage multiple separate files. Right now, I keep my personal stuff in a
file named `home.org`, my work stuff in a file appropriately named `work.org`,
and I capture new items into a notes file named `notes.org`.
