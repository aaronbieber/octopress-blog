---
layout: post
title: "Advanced Window Management With Slate"
date: 2016-01-31T18:12:37-05:00
---

I am mildly obsessed with window management. When I ran Linux full-time, I tried
nearly every window management system I could find and ultimately fell in love
with "tiling" window managers. I used Xmonad for more than a year and then
switched to i3.

I have used a Mac at home for a long time and previously tried Slate and
Spectacle for moving windows around quickly. When I was finally able to get a
Mac at work I refocused my efforts into finding just the right solution.

I was quite happy with Spectacle until a colleague showed me that Slate now
supports Javascript configuration, which makes it possible to do very
sophisticated things. I used that facility to re-implement my favorite feature
of Spectacle: the ability to cycle a window through three different sizes along
one screen edge.

Here I'll show you how it's done. If you don't desperately want to code up your
own Slate system after reading this, I've done something terribly wrong.~~MORE~~

## The Goal ##

The idea is to have a key binding that, when pressed, will snap the current
window to the left half of the screen. When pressed again, it should resize the
window to one third of the width of the screen, and when pressed a third time,
to two thirds of the width of the screen.

We should also have a key binding that does the same thing for the right side of
the screen.

## The Solution ##

First, you'll need to [download Slate][slate], of course. Create a `~/.slate.js`
configuration file and you're off to the races.
[slate]: https://github.com/jigish/slate/

Now, Slate already supports the resizing operations that we want to do, which
they call "bar resize" (because the window is shaped like a "bar" that covers
the screen's entire width or height depending on the requested direction). So
what we need to do is write a function that will cycle a window through each of
them.

How we'll do this is by creating an object in Javascript that maps the process
IDs of windows to a string describing their latest "resize state." When the key
is pressed to trigger a resize, we'll either add a new attribute to that object
or cycle the attribute's value to the next state in the sequence.

If the saved state isn't in the sequence associated with the key (e.g. the
window was last resized to the left half but the key pressed is for a right edge
resize), we'll just act as though the key isn't set.

You might want to skim through Slate's [Javascript documentation][slate-js] to
learn how these functions actually work.
[slate-js]: https://github.com/jigish/slate/wiki/JavaScript-Configs

### Saving the State ###

We'll save the state of each window in a Javascript object. So, first things
first, create an empty object:

~~~javascript
// Store current window states.
var windowStates = {};
~~~

### Create the Operations ###

Now we'll create an operation for each of the resize types that we want to
use. Here are the three left edge operations:

~~~javascript
// Left screen edge operations.
var leftBarThird = S.op("push",
                        {"direction": "left",
                         "style": "bar-resize:screenSizeX/3"});
var leftBarHalf = S.op("push",
                       {"direction": "left",
                        "style": "bar-resize:screenSizeX/2"});
var leftBarTwoThirds = S.op("push",
                            {"direction": "left",
                             "style": "bar-resize:screenSizeX/3*2"});
~~~

### Create a Cycle Function ###

Because the left and right cycles are identical, save for the operations and
their names, we'll create a generator function that returns a closure for any
sequence of states.

~~~js
function getCycleStates(states) {
    return function(win) {
        if (win.pid in windowStates &&
            windowStates[win.pid] !== undefined &&
            states.indexOf(windowStates[win.pid]) !== -1 
           ) {
            var nextIndex = (states.indexOf(windowStates[win.pid]) + 1) % 3;
            var nextState = states[nextIndex];
            windowStates[win.pid] = nextState;
        } else {
            windowStates[win.pid] = states[0];
        }

        eval(windowStates[win.pid] + '.run()');
    };
}
~~~

This function is passed an array of states and returns a function that will
cycle through those states when the key it is bound to is pressed. A function
bound to a key must accept one argument, the *window object* for the focused
window, so the returned closure accepts that argument.

Each string representing the current state will also correspond to one of the
Slate operations, which can be triggered by calling the `run()` method on
them. In spite of its general evilness, we'll use `eval()` to do that.

### Create the Bindable Cycle Functions ###

Now we can call `getCycleStates()` to generate a bindable function for the left
edge and the right edge sequences of states:

~~~javascript
// Window cycling functions.
var leftCycleOp = getCycleStates(['leftBarHalf',
                                  'leftBarThird',
                                  'leftBarTwoThirds']);
var rightCycleOp = getCycleStates(['rightBarHalf',
                                   'rightBarThird',
                                   'rightBarTwoThirds']);
~~~

Note, of course, that I didn't include the right edge operations at the
beginning of the post. I'm sure you can extrapolate those for yourself. After
all, that's half the fun of it.

### Bind Everything ###

Finally, bind those cycle operations to the keys we want to use. For me, I like
to try to use Vim-like keys when I can, so I've bound these to `Command-Shift-h`
for the left edge and `Command-Shift-l` for the right edge.

~~~javascript
// Bind the window cycling functions.
S.bind('h:cmd,shift', leftCycleOp);
S.bind('l:cmd,shift', rightCycleOp);
~~~

## Ta Daa! ##

That's all there is to it! You could easily expand this to cycle through any
Slate operations you like (screen quarters, different attached monitors, etc.)
or use the principles illustrated here to build other dynamic configurations do
any number of things.

If you do come up with some awesome application for these ideas, please share
it with me!
