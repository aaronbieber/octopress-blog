---
layout: post
title: "Playing Tag in Org Mode"
date: 2016-03-05T16:35:07-05:00
---

Once you have achieved *Org Mode Nirvana* (hopefully with the help of my
previous post, [Dig into Org Mode]({% post_url 2016-01-30-dig-into-org-mode %}))
and you have over 2,500 lines of Org notes and TODO lists as I do (I'm serious;
see the screenshot below), you'll want to seriously up your agenda game so that
you can find stuff quickly.

{% img noborder /images/uploads/playing-tag-in-org-mode/2500-org-files.png %}

One way to collate related information across Org files is by using tags. I'm
not a tagging expert, but I'll tell you what I know.~~MORE~~

Tags are not a new concept so I won't bother to explain the fundamental concept
of the tag. I use tags to classify certain important items in my notes and TODO
lists so that I can later pull up a list of all of those items together when I
need to find one (or when I want to see a cross-section of data).

A tag in Org Mode is just a word surrounded by colons, appearing on the same
line as the item's headline. Multiple tags are separated by colons, and tags
can only contain letters, numbers, underscores, and "at" symbols (no spaces!)
Tags look like this:

```
* Ideas for office parties              :party:brainstorm:
```

## Applying Tags ##

To apply tags to an Org item interactively, call `org-set-tags-command`.

If you use Helm (which you *really should*), you'll get a lovely completing read
window containing tags you've already used so that you can be consistent in your
tagging (that's really the most important thing).

What you'll notice when you start using `org-set-tags-command` is that you don't
get a great completion menu after the first tag, because the tags string is
treated as a single value and Helm wants to complete based on the full value. In
other words, with the tag `:party:` already assigned, triggering
`org-set-tags-command` gives you a tag prompt pre-populated with `:party:`
rather than letting you choose another separate tag to add.

That just won't do, so let's fix it. I created these small functions that will
allow you to choose a tag from all available tags and if that tag is not applied
to the current headline, it will add it, otherwise (if the tag you select is
already there), it will remove it.

This first function is meant for internal use only (note the double hyphen after
my "air" namespace prefix). Calling this function while point is resting on an
Org headline will replace the headline's tags with the tags string given. If
`nil` is passed, any tags will be removed.

Right at the end I call `(org-set-tags t)` to re-align the tags based on your
configuration. The `t` argument means "align only."

~~~cl
(defun air--org-swap-tags (tags)
  "Replace any tags on the current headline with TAGS.

The assumption is that TAGS will be a string conforming to Org Mode's
tag format specifications, or nil to remove all tags."
  (let ((old-tags (org-get-tags-string))
        (tags (if tags
                  (concat " " tags)
                "")))
    (save-excursion
      (beginning-of-line)
      (re-search-forward
       (concat "[ \t]*" (regexp-quote old-tags) "[ \t]*$")
       (line-end-position) t)
      (replace-match tags)
      (org-set-tags t))))
~~~

This function is the real meat and potatoes; it gives you a completing read of
all tags in the global tags table (which it also updates) and adds or removes
the tag as necessary.

~~~cl
(defun air-org-set-tags (tag)
  "Add TAG if it is not in the list of tags, remove it otherwise.

TAG is chosen interactively from the global tags completion table."
  (interactive
   (list (let ((org-last-tags-completion-table
                (if (derived-mode-p 'org-mode)
                    (org-uniquify
                     (delq nil (append (org-get-buffer-tags)
                                       (org-global-tags-completion-table))))
                  (org-global-tags-completion-table))))
           (org-icompleting-read
            "Tag: " 'org-tags-completion-function nil nil nil
            'org-tags-history))))
  (let* ((cur-list (org-get-tags))
         (new-tags (mapconcat 'identity
                              (if (member tag cur-list)
                                  (delete tag cur-list)
                                (append cur-list (list tag)))
                              ":"))
         (new (if (> (length new-tags) 1) (concat " :" new-tags ":")
                nil)))
    (air--org-swap-tags new)))
~~~

I use Evil Leader (naturally) and have mapped this to my `<leader>t`, which, for
me, is `,t`.

Once you have applied some tags to headlines in your Org files, you can take
advantage of the agenda's tag search capabilities.

## Searching for Tags ##

Typically you would simply call `org-agenda` and then press `m` to select "Match
a TAGS/PROP/TODO query," which is essentially a tag search. I search for tags
pretty often, so I created a binding directly to the underlying function, which
is `org-tags-view`.

As I mentioned in my previous Org posts, I have a common prefix key of `C-c t`
for all of my TODO-related activities. For searching I decided to create a new
base key, `C-c f` ("f" for "find"). Admittedly I'm running out of great
mnemonics that aren't already used by other functions, but such is life in the
fast lane of Emacs customization.

I also search by keyword frequently so I've assigned `C-c f t` to search for
tags and `C-c f k` to search for keywords. I'm not in love with `C-c f t`
because on the QWERTY keyboard they're all in a row, but until I come up with
something different that I can remember I'm rolling with it.

## Conclusion ##

Tags are a convenient and powerful way to link pieces of information together in
Org Mode; by applying tags carefully you can "slice and dice" your notes in
useful ways to get an overview of individual topics or keep track of how often
you think about certain things. The sky's the limit.

Full disclosure: it wasn't until I sat down to write this that I realized how
much adding and removing tags sucks and wrote the functions shown above. They're
probably buggy as hell, so let me know if you use them and run into trouble. I'd
also accept pull requests if you feel saucy.

You can [view my full Org Mode configuration file here][org].

[org]:https://github.com/aaronbieber/dotfiles/blob/master/configs/emacs.d/lisp/init-org.el

As always, drop a comment below if you have questions or wish to praise me
endlessly.
