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

~~~cl
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

I use two major entry points into the Org system: "agenda," and "capture." Let's
talk about them one at a time.

### Using the Agenda ###

The agenda is a ridiculously powerful feature of Org Mode. In addition to being
a dynamic daily or weekly interactive task list, it is also a front-end for
searching and generating other types of customized reports. You can think of it
as a way to summarize Org data.

I use the agenda chiefly to display my weekly tasks. When you have
`org-agenda-files` configured, you can simply call `org-agenda-list` to generate
an agenda, which, by default, will be the weekly display. Because I use the
agenda as my primary interface to a lot of my work, I prefer to open the agenda
by itself in the current frame. To do that, I wrote a small function and
assigned it to a key binding:

~~~cl
(defun air-pop-to-org-agenda (split)
  "Visit the org agenda, in the current window or a SPLIT."
  (interactive "P")
  (org-agenda-list)
  (when (not split)
    (delete-other-windows)))
    
(define-key global-map (kbd "C-c t a") 'air-pop-to-org-agenda)
~~~

The "air" part is just a namespace prefix that I use for all of my custom
functions for historical reasons I won't go into; the important part is the
`split` argument, which allows me to optionally allow the window to split as it
does normally by specifying a prefix.

{% infobox %}
When the `interactive` call specifies "P", the function will be passed an
argument with a "truthy" or "falsy" value depending on whether the *prefix key*
was pressed. In practice what that means is if you invoke the function by
pressing `C-u` followed by the key the function is bound to, `prefix` will be
true, otherwise it will be false.

In the example above, `C-c t a` opens the agenda list and deletes all other
windows, whereas `C-u C-c t a` (which I use much less often), allows the other
windows to remain open.
{% endinfobox %}

My mnemonic for these key bindings is `t` for "todo" and `a` for "agenda." My
other Org-related bindings all start the same way.

The agenda view is only useful if you have saved tasks with either `DEADLINE` or
`SCHEDULED` dates. Without dates associated with the tasks, Org wouldn't know
where to place them in the agenda. I'll talk more about scheduling in the
following section.

#### Essential Agenda Keys ####

The agenda list is interactive. To see all of the keys available, just invoke
the mode help with `C-h m` from within the agenda list. Here are the most
critical ones that I use all the time:

Press `TAB` to reveal the Org file that the item at point comes from. I use
this when I need to get in there and edit the notes within that item or make
more involved changes. I also bound `RET` to the function
`org-agenda-switch-to`, which does the same thing but doesn't use a split.

I have re-bound my motion keys because I use Evil, but the arrow keys move among
items by default, and `n` and `p` will move between headings (like days of the
week).

Pressing `S-Left` or `S-Right` while on a task will change the task's scheduled
or deadline date by one day in either direction. I use this mostly to push out
stuff I know I'm not going to get to today.

Press `t` on a task to cycle its current state (e.g. from "TODO" to
"IN-PROGRESS," etc.)

Following the pattern used by many other Emacs packages, pressing `g` anywhere
in the agenda will redraw it (recomputing days, statuses, etc.) I use this right
after I've changed a date or cycled the state of a task so that things are
displayed where they should be.

Finally, and perhaps most importantly, press `s` anywhere in the agenda view to
save all Org buffers that provide data to the agenda. When you make changes to
task states, dates, and so on, Org edits the buffers containing those items, but
won't save them automatically. Press `s` to make sure everything's saved, once
you're happy with your changes.

As with all systems in Emacs, use the mode help to see what other keys are
available and re-bind the ones that don't feel right.

### Using Capture ###

Once you're funneling all of your tasks through Org Mode, you'll need a way to
very quickly add new tasks no matter what else you're doing. The Org mechanism
for this is called "capture," and it allows you to add items to Org files from
anywhere in Emacs.

You can actually add any type of item to any file, but I use it simply to add
task items to my task list. The simplest way to invoke capture is to simply call
`org-capture`, typically via a binding. When you call that function, a split
will open prompting you to select a "template," and you probably won't have any
so you'll only be given the option to "C," customize, or "q," abort.

So let's create a template. You can do this by setting the variable
`org-capture-templates` and the format of the data is more straightforward than
it looks at first:

~~~cl
(setq org-capture-templates
      '(("a" "My TODO task format." entry
         (file "todo.org")
         "* TODO %?
SCHEDULED: %t")))
~~~

The value of `org-capture-templates` is a list of template entries where each
entry contains a single letter key for selecting or identifying the template
("a" above), a descriptive name, a type ("entry" above), the target for the
entry (above I have used a filename, which will be relative to `org-directory`),
and finally the template text itself.

A large number of variables are available within your template text, and targets
other than a filename are also possible. All of that is documented in the manual
for `org-capture-templates` (`C-h v org-capture-templates RET`).

In my template I have used `%t` to insert a timestamp, and I've specified `%?`
to place the cursor right after the "TODO" keyword when the template is
shown. You are under no obligation to follow my, or anyone's, format here. I
always want my new tasks to be scheduled so that they appear in my agenda, so
I've added that bit of metadata to my capture template.

Now that you have a capture template, calling `org-capture` will show its name
along with its key in the menu, and pressing that key ("a" in my example above),
opens a split with the template contents so you can edit it as necessary, then
of course press `C-c C-c` to save and close the capture or `C-c C-k` to abort
(that is noted in the window itself as well).

I only have one template and I don't want to have to press two keys to capture
it, so I've wrapped my own function around it:

~~~cl
(defun air-org-task-capture ()
  "Capture a task with my default template."
  (interactive)
  (org-capture nil "a"))
~~~

All that does is call `org-capture` with its optional template key argument. Now
you can bind that to a global key and you're off to the races!

~~~cl
(define-key global-map (kbd "C-c c") 'air-org-task-capture)
~~~

When I press `C-c c`, a split opens with my scheduled task template and I can
just type in the subject line and press `C-c C-c` to save it. This has saved me
hours and allowed me to enter tasks quickly into my agenda without having to
navigate buffers or think too much.

## Useful Tweaks ##

After using this system for a while you inevitably find ways in which it could
work better for you, and since Org is such a monster, there is almost always
some configuration you can tweak to fix it. These are the tweaks I have found
that work for me and their descriptions:

~~~cl
(setq org-agenda-text-search-extra-files '(agenda-archives))
~~~

When you perform a text search (the "s" selection from the `org-agenda` pop-up),
include the archives for all of the files in Org's agenda files list. If you
archive things regularly, which I do, this helps you dig stuff out of there when
you're looking for it.

~~~cl
(setq org-blank-before-new-entry (quote ((heading) (plain-list-item))))
~~~

I tend to leave a blank line at the end of the content of each task entry. This
causes Org to automatically place a blank line before a new heading or plain
text list item, just the way I like it.

~~~cl
(setq org-enforce-todo-dependencies t)
~~~

This one is pretty awesome; it forces you to mark all child tasks as "DONE"
before you can mark the parent as "DONE." The agenda view already has the notion
of "blocked" tasks (those with incomplete child tasks), which should appear
dimmed (that, of course, is also customizable). This makes it even harder to
slack off on your work.

~~~cl
(setq org-log-done (quote time))
~~~

I like to know when tasks have changed status. Setting this option causes Org to
insert an annotation in a task when it is marked as done including a timestamp
of when exactly that happened.

~~~cl
(setq org-log-redeadline (quote time))
~~~

Adding yet further auditing, this option causes Org to insert annotations when
you change the deadline of a task, which will note the previous deadline date
and when it was changed. Very useful for figuring out how many times you "kicked
the can down the road."

~~~cl
(setq org-log-reschedule (quote time))
~~~

This does the same as above, but for the scheduled dates, which I use more often.
