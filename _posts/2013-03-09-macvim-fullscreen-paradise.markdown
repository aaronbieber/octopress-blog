---
title: MacVim Fullscreen Paradise!
layout: post
date: 2013-03-09 15:06
comments: true
categories: 
---
I can't believe how utterly, totally, fully, and completely I overlooked this. 
I could add a few more adjectives to that list and it would still fail to 
capture the magnitude of sustained neglect it required on my part not to 
realize that this existed.<!--more-->

OK, hold on, rewind about one month. I got a new MacBook Pro for work, which 
is almost exactly the same as my own MacBook Pro except it's running the 
latest OS X. I haven't been putting off upgrading because I honestly didn't 
feel like the new features were worth the trouble. One of the new features is 
the ability to full-screen just about any application. This ties into the 
Expose multi-desktop functionality so that when you full-screen an app, it 
slides to the right and receives its own dedicated viewport. This is really 
slick because you can three-finger swipe on the trackpad to get back to your 
normal desktop at any time.

I was really enjoying that feature for both Chrome and MacVim, both of which I 
use often. No, often isn't the right word. Constantly. I use them 
*constantly*.

When I would come back to my own laptop, though, I would miss the ability to 
full-screen MacVim. Chrome, of course, has had full-screen built in for all 
platforms for quite some time now, so that was always there. Just hit 
Command-Shift-F and it would pop into full-screen.

Being the dense, neglectful, stolid, uncomprehending fellow that (apparently) 
I am, I never pressed those keys in MacVim. I have no idea why I never tried 
it, because it works. There's just one thing, though...

If you full-screen MacVim using default settings, it will increase its height 
to the maximum number of lines that will fit on your screen and leave the 
width alone. The Vim control is centered and the remaining space is filled 
with black. This is inefficient.

If you want the Vim control to fill the whole screen (at least to a multiple 
of the character block size, which is the maximum size you can have), you need 
to set this:

```
set fuoptions=maxvert,maxhorz
```

The `maxvert` option is the default. `maxhorz` tells MacVim to also increase 
your columns to the maximum that will fit on your screen.

It's really sweet. Especially sweet for writing blog posts without 
distraction.
