---
layout: post
title: "What I've Learned From 20,000 PHP Files"
date: 2015-07-14T08:05:19-04:00
---

{% img right /images/uploads/20-000-php-files/watch-mechanism.png %}

Aside from the well-known considerations of the computer science discipline like
algorithmic efficiency, decoupling, cohesion, and so on, working on a huge
codebase with a large number of engineers brings its own challenges.

Since joining Wayfair, I have had the opportunity to work on a larger system and
with a larger team than I ever have before.

This is what that experience has taught me. ~~MORE~~

First, a brief history.

My career as a programmer began in earnest in 1999 when I was brought on
part-time at a tiny startup in Connecticut to revamp their website. The website
was straightforward; a sales site. I wrote it in PHP. It was PHP 3.x back then.

The website grew into an application, allowing file uploads, tracking of account
statuses, and granular user security. My part-time job became a full-time
job. The company was acquired by a large consulting firm. Until the last six to
eight months of my time there I was the sole PHP developer. The codebase was, I
would guess, fewer than 100 files.

The stress forced me out of that job and I took a position working in ColdFusion
(as this blog's title implies). The codebase was significantly larger, on the
order of hundreds of files, and the engineering team grew over six years from
two people to twelve on-shore and 100+ off-shore before I left the company.

We undertook a PHP conversion, which was still incomplete when I joined Wayfair.

Wayfair's codebase is over 20,000 PHP files and our engineering team is nearly
400 strong and growing. It is the largest system I've ever worked on and the
largest engineering team I've ever worked with. These are the principles I've
learned to be important, which apply to systems and teams of any size, but that
become *essential* when a system and team are as large as ours.

## Legibility ##

Legibility trumps terseness and even efficiency in the majority of cases. Though
it is true that PHP might be intrinsically slower than a compiled language like
C# or Java, the difference between a FOR loop and a FOREACH loop, for
example, is trivial with normal workloads. There are few cases where minor
syntax choices affect performance dramatically.

Minor syntax choices, however, can affect legibility dramatically. As an
example, a long-form IF/ELSE statement is much more readable than a
nested ternary.

Compare this mess...

```php
<?php
$show_heading_count = !empty($global_heading_count) ?
                      (int) $global_heading_count :
                      ((   Heading_Model::can_show_local_headings()
                        && Heading_Model::local_headings() > 1) ?
                      Heading_Model::local_heading_total() : 6);
```

To this:

```php
<?php
$show_heading_count = 6; // Default heading count.
if (!empty($global_heading_count)) {
  // Use the global heading count, if available.
  $show_heading_count = (int) $global_heading_count
} elseif (   Heading_Model::can_show_local_headings()
          && Heading_Model::local_headings() > 1
) {
  // Use the local heading count, if more than one.
  $show_heading_count = Heading_Model::local_heading_total();
}
```

That's not even to mention that ternaries in PHP are inexplicably
left-associative, which causes them to do the opposite of what you expect
without carefully placed parentheses.

When you work with a very large team, you have to remember that the code you
spent an hour composing will be read for tens of hours by many other
people. Think of them as you write it.

## Standards Are Important ##

> The nice thing about standards is that you have so many to choose from.
>
> --- Andrew S. Tanenbaum, *Computer Networks, 2nd ed., p. 254*

If you contribute to more than one project written in the same language by
different teams, you may have had the experience of feeling a little bit "lost"
when switching between them if they use very different syntax conventions. Not
everyone is as sensitive to dramatic changes in format and style, but we humans
are excellent at pattern recognition and when patterns change unexpectedly, it
can be disorienting.

For large teams, it is critical to agree on style guidelines and to stick to
them. When a single style standard is followed, the code is more legible and
predictable overall. This becomes especially important when someone needs to
work on code that they have never seen before, which may have been developed by
an entirely different group.

We like to talk about this style issue as a matter of "cognitive load," which
is the perceived mental effort to carry out a task. Certainly the act of
programming itself carries a significant cognitive load, but so does parsing the
format of the code. If that format is constantly changing, the cognitive load
remains at a higher level than it has to be, which slows everything down.

Understanding what one block of code does is much easier if it is visually and
syntactically similar to other blocks of code that do similar things. This is
why a single standard is essential.

At Wayfair, we use the popular "PHP Codesniffer" package to emit warnings and
errors when code deviates from the standard. The standard itself is relatively
organic and has evolved with our teams, but the benefit of using a system like
this is that we are always transforming the code to move *closer* to a *single
standard*, which can be well-understood because it is described by the PHP
Codesniffer rules themselves.

Adhering to this style standard has, in no small way, made our large team more
productive.

## Performance Is Not a Destination... ##

... It is a journey.

Years ago, we tried giving one person the sole task of making performance
improvements on our website. That approach works in terms of delivering results,
but it creates a *moral hazard* whereby engineers in general are sheltered from
the performance-related decisions they make in their regular work. "The
performance guy will clean it up" is what you might think.

Eventually, one person isn't enough to clean up the performance issues that
creep into your code as hundreds of people make changes on a daily basis. At
that point, you can either commit to hiring more performance engineers or you
can distribute the work.

We chose to distribute the work. It is still helpful to have subject matter
experts around who can coach and keep an eye on metrics, but when it is
everyone's job to think about performance as they write and review code it
slows the natural erosion of site speed.

Even then, your job is never through. With hundreds of changes made daily,
performance is a constant battle that will never be fully won. It is necessary
to understand this and to structure teams and priorities around it.

## Communication Is Critical ##

> [O]rganizations which design systems ... are constrained to produce designs which
> are copies of the communication structures of these organizations.
>
> --- M. Conway

As Melvin Conway implies by this quote, if your teams are fractured and don't
talk to one another and keep messy commit logs and don't write documentation and
can't understand when to comment their code, the system they've written is going
to be fractured and generally a pain in the ass to maintain.

There are five major ways that programmers communicate, and each one is essential:

1. Synchronously: face-to-face, chat, etc.
2. Asynchronously: e-mail, mostly.
3. In commit messages.
4. By commenting the code itself.
5. Through documentation separate from the code.

Some organizations may prioritize one type of communication over another due to
preference or necessity, but the thing to keep in mind is that when engineers
talk to one another, especially between cross-functional groups, they make the
product better. Never forget that **commit messages** and **comments** are
at least as important as chats and e-mails for sharing knowledge about a system.

It strikes wrenching pain into my very core when I see *thoughtless commit
messages*. Remember, these words are for posterity, so try to show a little bit
of pride.

Personally, I think that e-mail is a scourge. The best way to explain how code
works is through comments. The best way to annotate changes to code through time
is through commit messages. The best way to document systems at a high level is
through a shared knowledge base.

If you use some platform to make documentation available across your engineering
teams, make sure it has the ability to easily cross-reference, categorize, and
search content. An example of a platform that does this is MediaWiki, the
software that powers Wikipedia.
