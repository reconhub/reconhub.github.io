---
title: RECON guidelines
subtitle: Best practices for package development
bigimg: /img/banners/devel.jpg
comments: true
---

*Note: this document is work in progress! Please send comments / suggestions using disqus, by posting issues or via pull requests. The file generating this page is [there](https://github.com/reconhub/reconhub.github.io/blob/master/guidelines.md)*.


This document provides guidelines for package development which are meant to promote clearer, robust, maintainable, and well-documented code. It borrows largely from the [*rOpenSci* onboarding guidelines](https://github.com/ropensci/onboarding/) and from [this post](http://discourse.repidemicsconsortium.org/t/scoring-system-for-r-packages/31/2) on the RECON forum. See [list of contributors](#credits) for more information on people who shaped this.



## Package development guidelines

We recommend following the [*rOpenSci* package development guidelines](https://github.com/ropensci/onboarding/blob/master/packaging_guide.md), with the following additions / changes:

- RECON does not use any package submission system.

- Packages should be hosted on [github](http://github.com), or a similar platform with a (ideally, distributed) version control system; we recommend keeping the *master* branch as functional, and using other branches for more adventurous changes.

- Packages should be submitted to a [*goodpractice*](https://github.com/MangoTheCat/goodpractice/) run to detect possible issues.

- The `README.Rmd` should provide an overview of the main functionalities of the package; vignettes can be used for finer details, but ideally the users should be able to become familiar with a package from its github project page.

- We **strongly** recommend the use of [*roxygen2*](https://cran.r-project.org/web/packages/roxygen2/index.html) for documentation, as it makes documentation easier to maintain.

- We encourage the use of "`::`" when importing functions from non-core packages, as it makes dependencies on foreign code more visible (and avoids using `@importFrom` tags).




## Credits

Besides the [*rOpenSci*](http://ropensci.org/) whose guidelines we largely adopted, the following people contributed to these guidelines; in alphabetic order:

- Gabor Csardi
- Rich Fitzjohn
- Thibaut Jombart
- Noam Ross