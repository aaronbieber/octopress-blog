---
layout: post
title: "The Linguistic Relativity of Object Oriented Programming"
---

Let's talk about cognition and perception. Wikipedia says:

> The principle of *linguistic relativity* holds that the structure of a language
> affects the ways in which its respective speakers conceptualize their world,
> i.e. their world view, or otherwise influences their cognitive processes.

I would like to suggest a corollary in programming: that the structure of a
programming language affects the ways in which its users conceptualize
architectural solutions. Specifically, learning object oriented programming
*first* may limit a programmer's ability to see solutions or predict bugs that
contradict its patterns.~~MORE~~

- Paradigms, not specific syntax
- Functional programming is all the rage now
    - Some precepts of functional programming are possible in OO
    - Functional programming requires different approach to organization
- When thinking with objects, everything is an object
    - Hammer and nails
- EXAMPLE Approaching every problem looking for object relationships instead of
  system behaviors can be harmful
- Notes from Carmack's FP blog post
- Need EXAMPLE: Thinking in objects leads to a fallacy of semantics: it makes
  sense for behaviors or values to "belong" together because they are
  semantically related, leading to "god objects" or giant classes like "a
  product" or "a user" containing hundreds of functions and properties
- OO is not sufficiently abstract to accurately describe some complex systems

- You can recover from this: learn a new paradigm. Like learning a new spoken
  language, you will discover ways of expressing approaches to problems that you
  hadn't thought of before.


Linguistic relativity is a controversial subject and, scientifically speaking, a
hypothesis at best. Nevertheless, the notion that your way of thinking about the
world is directly influenced by the framework through which you express it is of
great interest to me and the idea seemed to dovetail with things I have observed
in the software engineering world.

The often-used example of linguistic relativity in the world is that of the
Pirahã people of the Amazon Rainforest. Their language lacks the ability to
express numbers, colors, person, or tense; as a hunter-gatherer group, these
limitations are of pure necessity.

Researchers have concluded that the Pirahã people are *cognitively* capable of
counting, but they aren't able to perform even the most basic arithmetic nor
relate exact quantities to others. In other words, they are intelligent enough
to *conceive* of the number "fifteen," for example, but unable to put that value
to any productive use such as comparing it to another value or telling someone
else about it.

Similarly, I believe that when a programmer has been taught to think of systems
as collections of interconnected *objects* with potentially unintended
*preconceived semantics*, they may be unable to visualize the ideal solution to
a problem if it fails to align with those semantics.

This isn't to say that object oriented programming is fundamentally flawed; to
the contrary, it is often quite useful. Still, to write very extensible and
stable object oriented code, one must sometimes break through the conceptual
barriers created by it, which is what I will attempt to demonstrate here.

Before I dig into examples you're probably wondering if this is a purely
hypothetical exercise. Who does this potentially affect? According to
[this analysis][acm], published in Communications of the ACM, Java is still the
second most popular teaching language at Ph.D.-granting colleges and
universities.

[acm]: http://goo.gl/ivF6Hi

