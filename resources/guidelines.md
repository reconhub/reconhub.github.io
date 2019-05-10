---
title: RECON guidelines
subtitle: Best practices for package development
bigimg: /img/banners/devel.jpg
comments: true
---

*Note: this document is work in progress! Please send comments / suggestions
using disqus, by posting issues or via pull requests. 
[You can follow this link to access and edit the file that created this 
page](https://github.com/reconhub/reconhub.github.io/blob/master/guidelines.md)*.


This document provides guidelines for package development which are meant to
promote clearer, robust, maintainable, and well-documented code. It borrows
largely from the [*rOpenSci* onboarding
guidelines](https://github.com/ropensci/onboarding/) and from [this
post](http://discourse.repidemicsconsortium.org/t/scoring-system-for-r-packages/31/2)
on the RECON forum. See [list of contributors](#credits) for more information
on people who shaped this.



## Package development guidelines

### General Guidelines for R code

You can set up an R package skeleton with the
[recontools](https://github.com/reconhub/recontools#readme) package, which will
set up your package with the templates for using github, continous integration,
and testing. 

When writing your package, we recommend following the [*rOpenSci* package
development guidelines](https://ropensci.github.io/dev_guide/), with the
following additions / changes:

- RECON does not use any package submission system. If you would like your
  package to integrate RECON, be in touch with us directly (click on email link
  at the bottom of this page). 

- Packages should be hosted on [github](http://github.com), or a similar
  platform with a (ideally, distributed) version control system; we recommend
  keeping the *master* branch as functional, and using other branches for more
  adventurous changes.

- When adding new functionality, **write your tests before you write your 
  functions**. This will provide better protection against bugs because you are
  writing the function based on what you expect it to do as opposed to writing
  the test based on what lines of code you want to cover. 

- Never comment out tests. If a test is failing for a good reason (e.g. you are
  performing a large refactor), then skip it using the `skip()` function from
  testthat. This allows you or others to easily track down and audit the test
  failures. 

- Packages should be submitted to a
  [*goodpractice*](https://github.com/MangoTheCat/goodpractice/) run to detect
  possible issues.

- The `README.Rmd` should provide an overview of the main functionalities of
  the package, and point to more detailed resources (vignettes, tutorials,
  open-access publications) where relevant. 

- Vignettes are strongly recommended for more detailed documentation, including
  worked examples, details of analyses and methods, customisation of graphics,
  and object classes. The *Rmarkdown* (`.Rmd`) format is preferred to Sweave
  (`.Rnw`) as it is easier to convert to `.html` pages.
 
- We **strongly** recommend the use of
  [*roxygen2*](https://cran.r-project.org/web/packages/roxygen2/index.html) for
  documentation, as it makes documentation easier to maintain.

- We encourage the use of "`::`" when importing functions from non-core
  packages, as it makes dependencies on foreign code more visible. 

- We encourage the use of [*pkgdown*](http://github.com/hadley/pkgdown) to
  generate a website for the package. For an example, see the
  [*incidence*](http://github.com/reconhub/incidence) package and [its
  website](http://www.repidemicsconsortium.org/incidence/). 

### Recommended GitHub etiquitte

When collaborating with other people on a package, it's easy to feel overwhelmed
with keeping track of a moving target. Here, we'll outline a few practices that
will help make the experience easier:

 - **Define a clear code of conduct**. You can use `usethis::use_code_of_conduct()` to
   template it if you haven't done so already.

 - **Add a CONTRIBUTING.md file**. This file will describe the kind of
   contributions you expect from the community in terms of code, test, and 
   documentation style. You can fine an example CONTRIBUTING file in the 
   [poppr R package](https://github.com/grunwaldlab/poppr/blob/master/CONTRIBUTING.md)

 - **Lock the master branch**. If code works on your computer, it's no guarantee
   that it will work on an external machine like *travis* or *appveyor*. By
   locking the master branch, you can ensure that all code must pass through a
   pull request before it can be incorporated and, thus must have some level of
   vetting.

 - **Set up 2 factor authentication**. This will help prevent your account from
   being hacked. If you use this option, you will also want to use the ssh
   protocol instead of the https protocol. 

## Credits

Besides the [*rOpenSci*](http://ropensci.org/) whose guidelines we largely
adopted, the following people contributed to these guidelines; in alphabetic
order:

- Gabor Csardi
- Rich Fitzjohn
- Thibaut Jombart
- Zhian N. Kamvar
- Noam Ross

