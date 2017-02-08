---
title: <i>outbreaker2</i> is now out for testing!
subtitle: A year in the making, but it's finally there...
bigimg: /img/banners/big_epi_image.jpg
---


## A sequel, only better

*outbreaker2* is a total re-implementation of a model implemented in
 [*outbreaker*](https://github.com/thibautjombart/outbreaker), for the
 reconstruction of transmission trees in densely sampled outbreaks (i.e., most
 cases observed). While the original version was fairly efficient, it basically
 consisted of a C engine which was optimized for speed, but poorly tested (no
 unit testing) and very hard to develop upon. 


This is unfortunate, as the [original
model](http://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1003457)
was fairly simple and did not allow addition of new types of data or likelihood
components. The original idea behind *outbreaker2* was to address these
limitations - a mission which the package, now in its testing version, has
accomplished.


## Why better?

...




