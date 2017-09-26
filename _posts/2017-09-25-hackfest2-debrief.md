---
title: "<i>Hackfest 2</i>: mapping diseases "
subtitle: What have we been up to?
bigimg: /img/banners/devel.jpg
---


### Another small hackathon

After the first [RECON hackfest](http://www.repidemicsconsortium.org/hackfest1/)
which was dedicated to graphical user interfaces earlier this year, we repeated
the experiment: bring a few hand-picked
[experts](http://www.repidemicsconsortium.org/hackfest2/#participants) together,
lock them in a room with sufficient food and coffee supply, put a lid on, let
the mix simmer, and collect outcomes after a few days. This time around, we
focused on [mapping epidemics](http://www.repidemicsconsortium.org/hackfest2/).




### What have we done?

Maps. Of various types. When it comes to mapping infectious disease data, we
realised not a single map fits all purposes. Rather, different types of maps can
be used in different contexts: to show individual cases clustering district-wise
incidence, spatio-temporal patterns, or even flows of travellers between
locations. For most of these, existing packages offer excellent solutions, so
that rather than making redundant tools, we chose to illustrate how to use the
existing ones. It resulted in the new website [**GIS first
aid**](https://gisfirstaid.netlify.com/) which contains gists of code for
various types of maps. This platform is still under development, with the aim to
facilitate further contributions from the community.

<iframe src="https://gisfirstaid.netlify.com/" width="600" height="400">
	Snapshot of https://gisfirstaid.netlify.com/.
</iframe>
[sneak peek of GISfirstaid; click [here](http://gisfirstaid.netlify.com) for the full website ]

We also created two new packages to address specific needs:

* [*epimaps*](https://github.com/reconhub/epimaps): a collection of wrappers and
  helpers to facilitate mapping infectious diseases

* [*epiflows*](https://github.com/reconhub/epiflows): new classes and methods
  for storing, handling and plotting traveller flows

Both of these are still under development, but already contain some functional
features. Check for instance [Isobel
Blake](http://www.imperial.ac.uk/people/isobel.blake)'s
[article](http://gisfirstaid.netlify.com/2017/08/30/stplot/) on combining
`incidence` objects and shapefiles to produce maps time series.




### How to contribute?

[**GIS first aid**](https://gisfirstaid.netlify.com/) has been designed as a
contributed website. If you have some experience with
[github](https://github.com/) and [Rmarkdown](http://rmarkdown.rstudio.com/),
contributing should be very easy -- merely a pull request after adding your own
article(s).

More information on this on our [github
page](https://github.com/reconhub/gisfirstaid).