---
title: Test Complex Vim Settings Easily
layout: post
date: 2013-10-24 12:52
comments: true
categories: 
---
Have you ever wanted to test a new value for a complex Vim setting, like 
`comments`, and been annoyed at having to print out the setting, memorize its 
value, and then type it back in? There are a couple of ways around this that 
are much more convenient, but I'll show you a great trick for getting the 
current value of a setting to work from.~~MORE~~

As an example, let's stick with the `comments` setting, which tells Vim what 
source code comments look like in various languages. A typical value for 
`comments` is something like `s1:/*,mb:*,ex:*/,://,:#` (this one handles all 
PHP-style comments).

The first part of this trick is to know that you can reference the values of 
settings by prepending an ampersand on their name. In other words, in VimL 
code, you can use `&comments` to reference the value of the `comments` 
setting. This is done in Vim script fairly regularly to manipulate the values 
of buffer-local settings that affect what the script is trying to do.

The second part of the trick is to understand that a variable like `&comments` 
is considered to be an *expression* by Vim, which is to say, it can be 
evaluated. The result of evaluating `&comments` is the value of the setting.

Armed with these two pieces of knowledge, we can use the *expression register* 
to easily feed the current value of a setting into the command to change that 
setting. Let's try it with `comments`. Type this exactly:

```
:set comments=<C-R>=&comments<CR>
```

Note that `<C-R>` means that you should press Ctrl-R on your keyboard, and 
`<CR>` means that you should press the return key. When you press Ctrl-R, Vim 
will enter *operator pending* mode and wait for you to enter a register name 
(which is typically a single letter or number). When you press `=`, it 
indicates that you want to insert a value from the *expression register*, 
which is a special register that has no stored value. Instead, you will see an 
equal sign prompt and you can enter any expression that Vim can evaluate.

When you enter `&comments` at the expression prompt and press enter, Vim 
evaluates that expression and inserts the resulting value at the cursor's 
(previous) position, which sets you up to start editing that setting.

You can also use this `<C-R>=` trick in insert mode at any time to insert the 
result of expression evaluation directly into the file you're editing. This 
can sometimes be helpful to do quick math or string conversions using any of 
Vim's built-in functions.

Want more? Check out these articles in the Vim help files to learn all about 
expressions, the expression register, and Vim's built-in functions:

* `:h expression`
* `:h function-list`
* `:h quote=`
