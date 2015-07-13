---
layout: post
title: "What I've Learned From 20,000 PHP Files"
---

{% img right /images/uploads/20-000-php-files/watch-mechanism.png %}

Aside from the well-known considerations of the computer science discipline such
as algorithmic efficiency, decoupling, cohesion, and so on, working on a huge
codebase with a large number of engineers brings its own challenges.

While a system might be quite complex as a whole, it is essential to keep its
individual parts as simple as possible and to avoid writing "clever" code. With
hundreds of engineers in the mix, code that you write is read by dozens of
people at least.

This is what that experience has taught me. ~~MORE~~

My career as a programmer began in earnest in 1999 when I was brought on
part-time at a local incubator company in Connecticut to revamp their
website. The website was straightforward; a sales site. I wrote it in PHP. It
was PHP 3.x back then.

The website grew into an application, allowing file uploads and tracking of
account statuses. My part-time job became a full-time job. The company was
acquired by a large consulting firm. Until the last six or eight months of my
time there I was the sole PHP developer. The codebase was, I would guess, fewer
than 100 files.

The stress forced me out of that job and I took a job working in ColdFusion (as
this blog's title implies). The codebase was significantly larger, on the order
of hundreds of files, and the engineering team grew over six years from two
people to ten on-shore and 100+ off-shore before I left the company.

We undertook a PHP conversion, which was still incomplete when I joined Wayfair,
where I now work.

Wayfair's codebase is over 20,000 PHP files and our engineering team is nearly
400 strong and growing. It is the largest system I've ever worked on and the
largest engineering team I've ever worked with. These are the principles I've
learned to be important, which apply to systems and teams of any size, but that
become *essential* when a system and team are as large as ours.

## Legibility ##

* Legibility is more important than raw efficiency.
* Standards are important.
* Performance is a lifestyle.
* Communication is critical, and communication takes many forms. (commit
  messages, comments, e-mail and "meatspace" interactions)
