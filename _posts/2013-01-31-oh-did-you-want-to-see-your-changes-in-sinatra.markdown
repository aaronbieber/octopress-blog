---
title: Oh, did you want to see your changes in Sinatra?
author: Aaron
layout: post
comments: true
permalink: /2013/01/31/oh-did-you-want-to-see-your-changes-in-sinatra/
---

I started fiddling with the neat, lightweight Ruby web application framework 
“Sinatra” the other day. It seemed like a nice alternative to Rails and since 
I had also been playing with Slim for PHP, I wanted to see what it was like on 
the Ruby side of the fence.

I got the whole thing set up in Vagrant after no small amount of fiddling with 
Chef. I wanted to run it under Unicorn with Nginx in front, as is recommended 
by many for production deploys. After getting it all lined up, the app finally 
ran! Awesome, time to do some development!

So I started editing my index controller, saved, reloaded the browser. No 
change. Ugh. Caching, maybe?

To make a long story short, there isn’t enough information about this, and 
it’s even harder when you don’t know who’s causing the problem. I tried 
cutting out Unicorn and connected Nginx up to WEBrick directly… No love.

Some searches turned up this thing about the “sendfile” setting in Nginx 
having real problems with VirtualBox, so I tried turning that off. Nope. Still 
no refresh.

Finally, I found [this article][1] on Stack Overflow. Sinatra doesn’t reload 
files for each request because… Wait for it… It was “too complicated” to do. 
So developers just have to, what, restart their app after each change? I 
personally think that this decision is kind of dumb.

 [1]: http://stackoverflow.com/questions/1247125/how-to-get-sinatra-to-auto-reload-the-file-after-each-change

Anyway, install the “sinatra-reload” gem in your app and everything is gold. 
As one commenter suggested, you should probably check the environment and load 
it only in development, but do what you want.

I hope that all of the words in this post help it to find its way to other 
suffering souls on Google because I was just about to “vagrant destroy” for 
the last time.
