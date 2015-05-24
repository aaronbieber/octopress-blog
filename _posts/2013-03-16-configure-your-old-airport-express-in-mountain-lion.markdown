---
title: Configure Your Old AirPort Express in Mountain Lion
layout: post
date: 2013-03-16 11:31
comments: true
categories: 
---
Apple, in their ultimate wisdom, have made it impossible to install the 
AirPort Utility version 5.6 in Mountain Lion. The utility works, mind you, but 
you can't install it.

That is, unless you have a little bit of bash-fu on your utility belt, which I 
do. You can extract the utility from the installer package and run it directly 
to configure your older-generation AirPort Express. Want to learn 
how?<!--more-->

Step 1: Download [AirPort Utility 5.6](http://support.apple.com/kb/dl1482) 
from Apple.

Step 2: Mount the disk image and copy the installer `.pkg` file somewhere, 
like your desktop (I will use your desktop as my example here).

Step 3: Expand the contents of the installer package into a folder. Open your 
terminal and do this:

``` bash
$ cd Desktop
$ pkgutil --expand AirPortUtility56.pkg AirPortUtility
```

Then, go into the AirPortUtility folder that you just expanded, navigate into 
the `AirPortUtility56Lion.pkg` folder, and run the Payload.

``` bash
$ cd AirPortUtility
$ cd AirPortUtility56Lion.pkg/
$ open Payload
```

A progress dialog window will open and Payload will be extracted, which will 
create a new folder called `Payload 2 2`. Expand that folder and within it, 
expand `Applications` and then `Utilities` and there you will find `AirPort 
Utility 5.6`. You can copy the app into your Applications folder, or wherever 
you want, or just run it from there if you only need it once.

Congratulations! You can now configure your older AirPort Express (or older 
Extreme base station) using OS X Mountain Lion.
