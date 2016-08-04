---
layout: post
title: "Org Navigation Revisited"
date: 2016-07-31T11:56:16-04:00
---

In my previous post, [Playing Tag in Org Mode][tag], I talked about leveraging
Org Mode's powerful tag system to help you find the notes or references you're
looking for.

Since then, I've refined my use of tags and begun making better use of Org
Mode's custom ID abilities. In this post, I'll share the new navigation code
I've written and show you how you can use custom IDs to link or jump directly to
a specific item in your notes.

Also, as a special treat, I will debut my latest Emacs package,
[Tiny Menu][tiny-menu] (available right now on MELPA).~~MORE~~

## Custom IDs ##

Org Mode understands the notion of IDs, though by default I believe it only uses
the primary `ID` property for synchronizing items with Mobile Org, a facility
that to my mind is sorely lacking in functionality and that I abandoned long
ago.

Fortunately, there is also a property called `CUSTOM_ID`. Now, for the purposes
of this exercise it actually doesn't matter what the property field is called;
since I had to write a function to enumerate the property values myself, you
could just as easily use a property with a different name.

The goal is to give certain Org headings **unique** IDs and then create functions
for easily:

1. Jumping to the item with that ID, and
2. Dropping an Org link at point to a selected ID.

Let's start at the very beginning.

### Applying Custom IDs ###

To apply a custom ID to an item, simply call `org-set-property` with point on
the item's heading or within its content area. I have that function bound to
`<leader>p` using Evil Leader, but to each their own.

If you are using Helm (*which you really should be*), you will be presented with
a list of possible properties, and among them is `CUSTOM_ID`. Select that
property and you will then be prompted for its value. It's up to you to keep the
ID properties unique. If you are using Helm (*which you really should be*), you
will see a narrowing list of values for this property and you'll know that your
new value is unique because it will narrow to **nothing**.

Once applied, your new property should look like this:

```text
* First item
  :PROPERTIES:
  :CUSTOM_ID: note-first-item
  :END:
  
  The first item's content appears here.
```

Congratulations, you can now apply `CUSTOM_ID` properties to your notes! That's
swell, but how does this help you?

## Jumping to Custom IDs ##

The most useful thing about unique custom IDs, for me, is jumping directly to a
specific ID. I am an engineering manager and I have many people reporting to me,
about whom I keep notes of our one-on-ones, reminders about their vacations, and
so forth. Each person has a heading in my Org notes file and their `CUSTOM_ID`
value is their Active Directory username (e.g. email name) preceded with `@`. By
means of example, my custom ID would be `@abieber`.

This is a perfect use of custom IDs because our Active Directory usernames must
be unique across the organization and through time (AD names are not, at this
point, ever recycled), so I don't need to worry about the uniqueness myself.

To jump to a custom ID, you need two things:

1. A catalog of all of the custom IDs that exist in all of your agenda files,
   and
2. A function for selecting the ID and then jumping to it.

Don't worry, I've already written them for you.

### Enumerate All Custom ID Properties ###

Based heavily upon an existing Org Mode function for enumerating `ID`
properties, I've created a "global custom IDs" function, shown below:

```cl
(defun air--org-global-custom-ids ()
  "Find custom ID fields in all org agenda files."
  (let ((files (org-agenda-files))
        file
        air-all-org-custom-ids)
    (while (setq file (pop files))
      (with-current-buffer (org-get-agenda-file-buffer file)
        (save-excursion
          (save-restriction
            (widen)
            (goto-char (point-min))
            (while (re-search-forward "^[ \t]*:CUSTOM_ID:[ \t]+\\(\\S-+\\)[ \t]*$"
                                      nil t)
              (add-to-list 'air-all-org-custom-ids
                           `(,(match-string-no-properties 1)
                             ,(concat file ":" (number-to-string (line-number-at-pos))))))))))
    air-all-org-custom-ids))
```

{% infobox %}
As always, note that `air` is simply a "namespace prefix" to ensure uniqueness
and that the double hyphen is a convention for indicating that the function is
"private" to its package and isn't intended to be a part of the public API.
{% endinfobox %}

Calling this function will scan all of the Org files in `org-agenda-files` and
return an alist that looks like this:

```cl
(("note-first-item" "~/Dropbox/org/notes.org:1234")
 ("note-second-item" "~/Dropbox/org/notes.org:1245"))
```

The keys in the resulting alist are the IDs themselves and the values are
strings containing the Org filename and the line on which the ID appears
separated by a colon.

I thought about abstracting this function to parameterize the "CUSTOM_ID"
property name, but it is written specifically to handle only unique values and I
couldn't think of any other use cases, so I left it as-is for now. Org Mode
already has facilities for searching for non-unique values and they work quite
well.

### Making the Jump ###

Now that we can build up an enumeration of all of the available custom ID
values, we can very easily present a narrowing list to aid selection and jump
directly to the selected item. Again, fear not, I have written this for you
already.

```cl
(defun air-org-goto-custom-id ()
  "Go to the location of a custom ID, selected interactively."
  (interactive)
  (let* ((all-custom-ids (air--org-global-custom-ids))
         (custom-id (completing-read
                     "Custom ID: "
                     all-custom-ids)))
    (when custom-id
      (let* ((val (cadr (assoc custom-id all-custom-ids)))
             (id-parts (split-string val ":"))
             (file (car id-parts))
             (line (string-to-int (cadr id-parts))))
        (pop-to-buffer (org-get-agenda-file-buffer file))
        (goto-char (point-min))
        (forward-line line)
        (org-reveal)
        (org-up-element)))))
```

The function is simple enough that it should be self-explanatory. We use the
previous function to get an alist of all IDs, prompt for the desired ID using a
`completing-read`, and then jump to the location indicated in the original
alist, finally calling `org-up-element` so that point rests on the heading of
the ID rather than on the property itself.

I use this **all the time** to jump to the notes for big topics that I'm always
revisiting or to the notes for each of my employees. Thanks to
`completing-read` and Helm (*which you really should be using*), I don't even
have to remember what they are or type them in their entirety.

## Linking to Custom IDs ##

Finally, I also sometimes like to reference one of those big topics or a
specific employee in another TODO item, and it is very helpful to have an Org
native link within that item so that I can jump to the reference quickly to
refer to it or edit it.

If you are unfamiliar with Org links, they are extremely powerful and the
breadth of their capabilities is far beyond the scope of this post. Suffice it
to say, [RTFM](http://orgmode.org/guide/Hyperlinks.html).

A link to a custom ID could be an "internal link" (a link to a location in the
same Org file), or an "external link" (a link to a location in a different Org
file). For our purposes, we will assume that all links are external so that it
doesn't matter which agenda file the ID is in nor where the link appears.

The format of such a link is:

```text
[[file:/path/to/file.org::#id-value][Description]]
```

A link destination can take a number of forms, but Org Mode provides a format
specifically for `ID` or `CUSTOM_ID` values, as shown above. If you elect to use
a different property for this, you can use the format
`file:/path/to/file.org::1234`, where "1234" is the line number to link to.

Building and inserting the link is very similar to jumping to it, except that we
will use the ID's actual value in the link destination and description. Here is
the function itself:

```cl
(defun air-org-insert-custom-id-link ()
  "Insert an Org link to a custom ID selected interactively."
  (interactive)
  (let* ((all-custom-ids (air--org-global-custom-ids))
         (custom-id (completing-read
                     "Custom ID: "
                     all-custom-ids)))
    (when custom-id
      (let* ((val (cadr (assoc custom-id all-custom-ids)))
             (id-parts (split-string val ":"))
             (file (car id-parts))
             (line (string-to-int (cadr id-parts))))
        (org-insert-link nil (concat file "::#" custom-id) custom-id)))))
```

Now you can bind this function to a key and press it whenever you want to drop a
link to an item that has a custom ID associated with it. Very handy! I don't use
this as often as jumping to IDs, but when I do use it, it saves me boatloads of
time.

## Binding It All Together ##

In my previous post, [Playing Tag in Org Mode][tag], I mentioned in passing that
I'm running out of useful mnemonics to remember all of my related key
bindings. I have what I consider to be an above-average ability to memorize new
keystrokes for things, but functions that I use less often just don't get the
benefit of muscle memory and without some kind of mnemonic device I just won't
be able to recall.

I have started to run into this with some of these Org Mode helpers, especially
considering I'm now carrying the weight of all of Evil Mode (which after all
these years feels as natural as typing straight QWERTY) as well as a lot of
Emacs (I now press `C-c C-c` compulsively in other programs).

Tools already exist to solve this in very innovative ways, and one such solution
is the amazing [Hydra](https://github.com/abo-abo/hydra) package. Hydra allows
you to create chains of key commands with shared prefixes, branching off in
different directions (hence the reference to the hydra, the multi-headed sea
monster of Greek lore), and now you can even define visual menus similar to what
you may be familiar with from Magit.

Other packages rely on Hydra to provide that interface, and it is of interest to
me, but I have not yet used Hydra for anything else and I wanted a very
lightweight solution... So I wrote one.

### Introducing Tiny Menu ###

{% img noborder https://camo.githubusercontent.com/247cb7707c2dd5fb7b09cfabed6bf5200c71be58/687474703a2f2f6161726f6e6269656265722e636f6d2f6173736574732f696d616765732f74696e792d6d656e752d73637265656e73686f742e706e67 %}

As its name implies, [Tiny Menu][tiny-menu]
is... Tiny. Hydra weighs in at about 1,100 lines of code excluding preamble,
which considering everything it does is impressive in its own right. Tiny Menu
is 110 lines of code, and at least 15-20 of that is verbose function
descriptions.

The reason Tiny Menu is so small is because it can only display a series of
single-letter options in the minibuffer. It doesn't pretend to be able to do
even a quarter of the things that Hydra can do, but if you just want to chain a
couple of key presses together and have a visual reminder of what's what, it
could be a good option.

Thanks to help from [Tslil Clingman on Github](https://github.com/tslilc), Tiny
Menu natively supports chaining menus together (menu items that point to other
menus), as well as menus that repeat (selecting a menu item executes that
command and re-displays the same menu).

Menus are defined declaratively with a relatively straightforward data
structure, and there is a helper function for use in key bindings to keep them
concise and readable. Read the documentation on
[Tiny Menu's Github page][tiny-menu].

### Using Tiny Menu in Org Mode ###

I have used Tiny Menu to set up a couple of useful menus to call some of my Org
Mode jump and link functions. Here is a portion of my Tiny Menu setup focusing
on the things I've talked about in this post:

```cl
(setq tiny-menu-items
      '(("org-things"   ("Things"
                         ((?t "Tag"     org-tags-view)
                          (?i "ID"      air-org-goto-custom-id)
                          (?k "Keyword" org-search-view))))
        ("org-links"    ("Links"
                         ((?c "Capture"   org-store-link)
                          (?l "Insert"    org-insert-link)
                          (?i "Custom ID" air-org-insert-custom-id-link))))))
```

I have used global Evil normal mode maps as prefixes for these menus. The nice
thing about Evil bindings is that they can automatically use non-prefix keys as
prefixes; Evil negotiates that bit of Emacs errata for you. Here are the
bindings for these menus:

```cl
(evil-define-key 'normal global-map (kbd "\\ t") (tiny-menu-run-item "org-things"))
(evil-define-key 'normal global-map (kbd "\\ l") (tiny-menu-run-item "org-links"))
```

Now by pressing `\t`, I am presented with the `org-things` menu. To jump to a
tag, I press `\t t`; to an ID, `\t i`; and to a keyword, `\t k`.

I've also overridden Org Mode's default `C-c C-l` binding, which normally runs
`org-insert-link`, to instead display the `org-links` menu. Thus, to insert a
link, I press `C-c C-l l`, or, or insert a link to a custom ID by lookup I can
instead press `C-c C-l i`.

Tiny Menu is so small and fast that if you have finally memorized the next key
in the sequence, you need not slow down to wait for a menu to appear, just press
the keys at your normal speed. Nevertheless, the menu is there should you like
to use one of its other less memorable options.

## Conclusions ##

In this post, I've talked about creating and using Custom IDs as global
bookmarks and as links, and how to chain together related commands using
[Tiny Menu][tiny-menu] to make navigating your Org files a breeze.

As always, if you have any questions or feedback on anything here, leave a
comment below! I have received many requests to dive deeper into my use of Org
Mode and I expect this to be one in a series of posts where I dissect certain
bits of it.

[tag]: {% post_url 2016-03-05-playing-tag-in-org-mode %}
[tiny-menu]: https://github.com/aaronbieber/tiny-menu.el
