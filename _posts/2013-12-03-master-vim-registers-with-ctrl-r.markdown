---
title: Master Vim Registers with CTRL-R
layout: post
date: 2013-12-03 08:02
comments: true
categories: 
---

Vim's registers are incredibly powerful. You use them all the time when you 
yank and put text or record macros, but are you using CTRL-R (in insert 
mode)? If you aren't, you're missing out on a huge efficiency boost! I will 
show you what CTRL-R does and how it can make you faster and give you even 
more uses for Vim's registers.<!--more-->

From the Vim documentation:

> Insert the contents of a register. Between typing CTRL-R and the second 
> character, `"` will be displayed to indicate that you are expected to enter 
> the name of a register.

In its simplest form, you can press CTRL-R followed by a register name (such 
as a letter, number, or symbol as seen in the output of `:registers`) and the 
contents of that register will be inserted at the cursor position, as though 
you had typed it. I use this all the time to insert text that I had just 
yanked by pressing `CTRL-R "`. Double quote is the name of the default 
register.

## Playing with Macros

You can also use CTRL-R to do some fun things with macros. As you may already 
know, macros are recorded into registers and you can manipulate that content 
in the same way that you manipulate any register. Let's record a macro as an 
example. Here is a macro I recorded into register "q" that starts inserting at 
the end of the line with "A" and types out " and my ax!" followed by pressing 
escape.

`qqA and my ax!^[q`

Note that `^[` is how Vim represents a literal escape. Great, so I have a 
macro recorded into register "q" and I can play it back by pressing `@q` as 
usual. But let's say I want to make a change to this macro and I am far too 
lazy to re-record it. Instead of inserting " and my ax!" at the end of the 
line, I want it to insert "My ax and " at the beginning of the line.

We can use CTRL-R to get access to that macro in a buffer so that we can edit 
it. Just press:

`i^R^Rq`

Press "i" to enter insert mode, then press CTRL-R twice, then press "q" to 
insert the contents of the "q" register. What ought to come out looks like 
this:

`A and my ax!^[`

The reason you press CTRL-R twice is to insert that escape character code 
literally. If you only press CTRL-R once, the contents of the register will be 
inserted without any literal control characters, so you'll lose the escape 
keypress, which is bad news bears.

Now that I have the contents of the macro sitting in a buffer, I can edit it 
normally as text. I will change it to look like this:

`IMy ax and ^[`

Now the macro presses "I" to start inserting at the beginning of the line and 
types out "My ax and " then presses escape. Let's capture that back into the 
"q" register. I place my cursor at the beginning of that line and press:

`"qy$`

I have just used the double quote key to tell Vim I want to use the "q" 
register for the next command and pressed `y$` to yank to the end of the line. 
Now my revised macro is in the "q" register and can be played normally with 
`@q`. This little trick comes in very handy when you are working with longer 
macros and you make a mistake partway through or want to tweak the behavior a 
little bit without re-recording the whole sequence.

As a bonus, now that you know how to use CTRL-R twice in a row to output the 
contents of a register literally, including control characters, you can 
confidently save macros for later use by creating mappings. If I want to 
create a new mapping to run the same sequence that I recorded in this macro, I 
could type this:

`nnoremap <Leader>a ^R^Rq`

The `nnoremap` command creates a mapping for the key sequence `<Leader>a` to 
the literal contents of the "q" register without allowing nested mappings. 
It's important to use `nnoremap` because in the future you may create a 
mapping for one of the key sequences used in this mapping and you don't want 
that to run; you want this key sequence to be played back literally. After 
pressing "q" in the line above, it should look like this:

`nnoremap <Leader>a IMy ax and ^[`

Ta daa!

## Expressions

In a [previous post][1] I talked about how to use CTRL-R and the expression 
register to easily edit complex Vim settings. The expression register is super 
powerful and can do a lot more than just output simple values. For example, it 
is possible to perform calculations and call any of the built-in functions 
found in `:h function-list`.

Things are about to get pretty advanced, so make sure you're strapped in. This 
is a completely contrived example, but I am going to show you how to create a 
macro that uses CTRL-R to multiply the number under the cursor by two. Later 
on, you can think of other crazy ways to apply these concepts and leave them 
in the comments below for all to enjoy.

The basic procedure is this:

1.  Begin recording a macro into register "q"
2.  Change the word (the number) under the cursor. This places the deleted 
    value in the default register, `""`, and puts you in insert mode
3.  Use CTRL-R to insert an expression and use CTRL-R again to get the value 
    from the default register, `""`, into the command.

The exact keystrokes to record the macro are these: `qqciw^R=2*^R"^M^[q`

Note in the macro string that `^R` is CTRL-R, `^M` is the return key, and `^[` 
is escape. Give it a try, record the macro, then type in some numbers in the 
buffer and replay the macro with the cursor on each number. Because we have 
used `ciw` you can place your cursor anywhere over the number and it will 
replace the whole number with the sum!

Now you have the power to *truly master CTRL-R*!

[1]: {% post_url 2013-10-24-test-complex-vim-settings-easily %}
