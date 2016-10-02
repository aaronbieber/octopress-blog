---
layout: post
title: "Agenda Interactions Primer"
date: 2016-09-25T11:28:59-04:00
---

Now that you have read [An Agenda for Life with Org Mode][agenda-4l], you know
how to build the perfect agenda for managing the tasks in your life. But, I ask
you, what good is a task that you cannot complete?

[agenda-4l]: {% post_url 2016-09-24-an-agenda-for-life-with-org-mode %})

Fortunately, Org Mode provides a rich set of interactive commands for
manipulating your task entries directly from the agenda view and, in fine Emacs
style, the commands relevant to each type of view will apply only to the
appropriate section of a composite view.

I've tweaked and customized my interface to the agenda and so I want to share
with you the most useful commands and a couple of the things I have
added.~~MORE~~

## Moving Around ##

As usual, the most important commands you can learn are the navigation
commands. It would be impossible to apply the others without an ability to move
the cursor around within the agenda.

As you all know, I am an Evil Mode user, so I have bound the `k` and `j` keys to
move up and down, respectively.

~~~cl
(define-key org-agenda-mode-map "j" 'org-agenda-next-item)
(define-key org-agenda-mode-map "k" 'org-agenda-previous-item)
~~~

### Moving in a Composite View ###

Within a composite agenda view, you will have a heading of some kind at the
beginning of each section. I was surprised that Org Mode lacked navigation
commands for jumping directly to the headings, so I wrote one.

This is probably not an ideal approach, but it works. I use the fact that the
headings possess specific text properties to locate them in the buffer and it's
not the most elegant code to read, but it has been working great for me.

~~~cl
(defun air-org-agenda-next-header ()
  "Jump to the next header in an agenda series."
  (interactive)
  (air--org-agenda-goto-header))

(defun air-org-agenda-previous-header ()
  "Jump to the previous header in an agenda series."
  (interactive)
  (air--org-agenda-goto-header t))

(defun air--org-agenda-goto-header (&optional backwards)
  "Find the next agenda series header forwards or BACKWARDS."
  (let ((pos (save-excursion
               (goto-char (if backwards
                              (line-beginning-position)
                            (line-end-position)))
               (let* ((find-func (if backwards
                                     'previous-single-property-change
                                   'next-single-property-change))
                      (end-func (if backwards
                                    'max
                                  'min))
                      (all-pos-raw (list (funcall find-func (point) 'org-agenda-structural-header)
                                         (funcall find-func (point) 'org-agenda-date-header)))
                      (all-pos (cl-remove-if-not 'numberp all-pos-raw))
                      (prop-pos (if all-pos (apply end-func all-pos) nil)))
                 prop-pos))))
    (if pos (goto-char pos))
    (if backwards (goto-char (line-beginning-position)))))
~~~

Please note:

1. The `air-` prefixes are simply namespace separators to avoid possible
   function collisions.
2. The main function uses the `cl` library, which I believe is now part of
   Emacs, but you may want to err on the side of safety and include a
   `(eval-when-compile (require 'cl))` in the file this function lives in.
3. It might be a cleaner design to have the main function return `nil` or a
   buffer position and let the interactive functions call `goto-char`, but I'm
   too lazy to change it now and couldn't think of a use case for knowing the
   position without jumping to it.

I have bound these to the capitalized versions of my usual `k` and `j` motions:

~~~cl
(define-key org-agenda-mode-map "J" 'air-org-agenda-next-header)
(define-key org-agenda-mode-map "K" 'air-org-agenda-previous-header)
~~~

So now you're jumping around all over the place... But what can you do to change
the entries themselves?

## Task Management ##

The main keys you will need to know to manage the tasks in your agenda are the
following:

* `t`: Cycle the TODO state of the current item.
* `,`: Apply a specific priority (you'll be prompted in the minibuffer).
* `+` and `-`: Increase or decrease priority, respectively.
* `S-Left` and `S-Right`: Shift date or time of item at point forward or backward.
* `s`: Save all agenda buffers.
* `g`: Rebuild all agenda views in the current buffer.

These should be self-explanatory. The date/time shifting keys will affect
`SCHEDULED` or `DEADLINE` items, but you have to press `g` to rebuild the buffer
after making the change to see any effect it has on color-coding, etc.

{% infobox %}
**Important!** Making changes to items in the agenda buffer edits the
underlying buffers where the agenda items live, but it **does not** save those
buffers! Get in the habit of pressing `s` to save all modified agenda buffers
after making changes directly in the agenda view. I press `sg` after most edits
to save and recompute the agenda.
{% endinfobox %}

In addition, I wanted an easy way to add things to my task list from this view,
so I also bound `c` to my default capture command:

~~~cl
(defun air-org-agenda-capture (&optional vanilla)
  "Capture a task in agenda mode, using the date at point.

If VANILLA is non-nil, run the standard `org-capture'."
  (interactive "P")
  (if vanilla
      (org-capture)
    (let ((org-overriding-default-time (org-get-cursor-date)))
      (org-capture nil "a"))))

(define-key org-agenda-mode-map "c" 'air-org-agenda-capture)
~~~

What this does, essentially, is let me press `c` by itself to open my default
capture command, which is a TODO entry (the shortcut key is "a" and that is
passed to `org-capture`). If I use a prefix (by pressing `C-u c`), it will open
the default ("vanilla") Org Mode capture dialog, prompting me to pick a capture
type, where I can choose my "note" type or others I have developed.

After changing TODO state, priority, or adding a new item, you will need to
press `g` to rebuild the buffer and display the changes.

## Drilling Down ##

The agenda view is, ultimately, a time- and status-sensitive summary of the
content in your agenda files, which might be files dedicated to storing tasks
(as some of mine are) or note-taking files that happen to have tasks sprinkled
into them (the original reason for Org Mode's creation).

So as you are navigating your agenda, you will often need to get to the
underlying entry to edit it. Quite often, I will have a task that requires some
further note-taking or data collection, and I will use that entry itself to
gather the information.

There are four major ways in which to access the underlying task entries, and
those are:

* `RET`: Switch to the current entry in this window.
* `TAB`: Switch to the current entry in a new split window.
* `SPC`: Show the current entry in a new split window with highlighting.
* `F`: Follow mode (persist the effect of `SPC` as point moves).

`RET` and `TAB` are equivalent save for the behavior of the window splitting. If
you want to jump to an item to edit it exclusively, use `RET`; if you want to
continue to see the agenda while you do it, use `TAB`.

I don't use `SPC` as often as maybe I should. It and the "follow mode" are very
useful for understanding the location and context of an entry in a read-only
manner. I haven't found a great use for "follow mode" other than showing it off.

## Launching the Agenda ##

Finally, as you may have picked up, I live and die by my agenda, so I either
have it open all the time or I jump back to it between any other tasks I might
use Emacs for. I quickly tired of pressing `C-c t A d` to launch my agenda
custom command, so I created a quick function and global key definition.

After experimenting with a few global keys, I landed on `S-SPC` (shift +
spacebar), which is not used by anything else I'm aware of and is the easiest
thing to press that I could find. I probably press it 900 times a day.

~~~cl
(defun air-pop-to-org-agenda (&optional split)
  "Visit the org agenda, in the current window or a SPLIT."
  (interactive "P")
  (org-agenda nil "d")
  (when (not split)
    (delete-other-windows)))
    
(define-key evil-normal-state-map (kbd "S-SPC") 'air-pop-to-org-agenda)
~~~

Note that I am defining this mapping in Evil's normal state, but you could just
as easily define it in Emacs' global map instead.

The trick is calling `org-agenda` with a `nil` prefix argument and the "agenda
key" corresponding to the dispatch menu key you would press to open the agenda
view you want. Mine is "d" for my custom daily agenda.

Launching the agenda view will split the window. 99% of the time, I want to blow
away all other windows and see the agenda by itself, so that's the default
behavior, but I provided a prefix argument to leave the splits in the very few
cases where I want that.
