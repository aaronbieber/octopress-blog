---
title: Run Your Own Private Shared Git Repository
author: Aaron
layout: post
comments: true
permalink: /2013/01/14/run-your-own-private-shared-git-repository/
---
So everyone uses Github now, and that’s cool, because Github is awesome. But 
what if Github goes down, even just for a short time, and you’re sitting there 
trying to get your stuff deployed or whatever? You’re basically screwed. 
Though Github is a fantastically stable service, it does have the occasional 
availability hiccup and the only real solution to that problem is 
*redundancy*.

So what’s a guy (or gal) to do? Run your own private git repository somewhere 
else!~~MORE~~
    
Push your changes to Github and to your own repository and you’ll never be 
without a version-controlled source. You may know that git itself is able to 
operate over several protocols:

*   HTTP(S)
*   SSH
*   Git

The HTTP and SSH protocols are obvious and they give you exactly the 
capabilities that you would expect. But who wants to have to type in:

``` bash
$ git push ssh://username@domain.com:/var/git/repos/myrepo.git
```

That’s silly. On top of that, you want to have centralized access to 
repositories across a few users rather than spread all around on the remote 
system. In short, you want what Github provides. You want this:

```
$ git push git@github.com:username/repository.git
```

Well, you can have it, and I’m going to tell you how.

The trick is to use `git-shell` and the so-called “git protocol.” In reality, 
the git protocol wraps around SSH and SCP; it transfers the actual data to the 
remote system through an SSH tunnel and doesn’t require running any additional 
daemons or servers on the remote host. It does require that git is installed 
on the remote host, of course, so do that first.

When you use a URL like `git@github.com:this/is/a/path.git`, it actually logs 
into the remote host via SSH using the username “git” and makes changes to the 
repository found at “this/is/a/path.git”, which will most likely reside in the 
“git” user’s home directory. I did a very simple setup, so that directory is 
actually “/home/git”.

To make all of this work, you need the following:

1.  A “git” user and group on the remote host.
2.  The git user’s home directory contains a directory called 
    “git-shell-commands,” which is empty.
3.  The git user’s shell is set to `/usr/bin/git-shell` (or wherever it is on 
    your system; try `which git-shell`).
4.  Your own public key on your local system is appended to 
    `/home/git/.ssh/authorized_keys2`.

To see it work, you will first need to create a bare repository on the remote 
system into which you will push some changesets. To create it, simply do this:

``` bash
$ cd /home/git
$ mkdir -p username/new-repository.git
$ cd username/new-repository.git
$ git init --bare
$ sudo chown -R git:git /home/git/username
```

All of this is assuming that your username is `username`, which I’m using here 
just as a way to separate one user’s repositories from another in the way that 
Github does. You don’t need to do this; you could place each repository 
directly into git’s home directory if you wanted to.

The important part is `git init --bare`, which creates an empty git repository 
without placing it into a `.git` folder; it simply dumps all of the repository 
metadata files right into the named path (or your current directory if no path 
is specified, as above). Now it is ready to receive data!

To push to it, just use the same familiar syntax you would use with Github. I 
like to add actual remotes by name because it makes it easier later on:

``` bash
$ git remote add my-server git@mydomain.com:username/new-repository.git
$ git push --all my-server
```

You probably wouldn’t use the `--all` switch every time, but that tells git to 
push all refs and heads, not just the one(s) named. You could also just do:

``` bash
$ git push my-server master
```

To push only the master head out to your new server. If you have an SSH agent 
available already, it should start pushing those files out with no trouble. If 
not, you may be prompted to enter your private key passphrase.

Was this helpful? Let me know.
