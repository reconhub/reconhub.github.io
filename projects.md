---
title: Projects
bigimg: /img/banners/devel.jpg
stable-list:
  - name: EpiEstim
    desc: Quantifying transmissibility throughout an epidemic from incidence time series.
    github: http://github.com/annecori/EpiEstim
    url: http://github.com/annecori/EpiEstim
    img: /img/projects/purple.png
  - name: OutbreakTools
    desc: Basic analysis and visualisation of complex line-list data (to be replaced by <i>incidence</i> and <i>epicontacts</i>).
    github: http://github.com/thibautjombart/OutbreakTools
    url: http://github.com/thibautjombart/OutbreakTools
    img: /img/projects/yellow.png
  - name: EpiJSON
    desc: Implementation of a generic json format for case outbreak data.
    github: http://github.com/Hackout2/EpiJSON
    url: http://github.com/Hackout2/EpiJSON
    img: /img/projects/orange.png
  - name: repijson
    desc: R package implementing EpiJSON format.
    github: http://github.com/Hackout2/repijson
    url: http://github.com/Hackout2/repijson
    img: /img/projects/blue.png
  - name: outbreaker
    desc: Inferring transmission chains using temporal and genetic information.
    github: http://github.com/thibautjombart/outbreaker
    url: http://github.com/thibautjombart/outbreaker
    img: /img/projects/red.png
upcoming-list:
  - name: cleanr
    desc: Rationalised and reproducible data cleaning.
    github: http://github.com/Hackout3/cleanr
    url: http://github.com/Hackout3/cleanr
    img: /img/projects/blue.png
  - name: dibbler
    desc: Investigation of food-borne disease outbreaks.
    github: http://github.com/thibautjombart/dibbler
    url: http://github.com/thibautjombart/dibbler
    img: /img/projects/green.png
  - name: epicontacts
    desc: Handling, visualisation and analysis of epidemiological contacts.
    github: http://github.com/Hackout3/epicontacts
    url: http://github.com/Hackout3/epicontacts
    img: /img/projects/purple.png
  - name: epimatch
    desc: Finding matching patient records across tabular data sets.
    github: http://github.com/Hackout3/epimatch
    url: http://github.com/Hackout3/epimatch
    img: /img/projects/orange.png
  - name: incidence
    desc: Computation, handling, visualisation and simple modelling of incidence.
    github: http://github.com/reconhub/incidence
    url: http://github.com/reconhub/incidence
    img: http://raw.githubusercontent.com/reconhub/incidence/master/logo/logo.png
  - name: outbreaker2
    desc: Inferring transmission chains by integrating epidemiological and genetic data.
    github: http://github.com/thibautjombart/outbreaker2
    url: http://github.com/thibautjombart/outbreaker2
    img: /img/projects/red.png
  - name: outbreaks
    desc: Collection of outbreak data.
    github: http://github.com/reconhub/outbreaks
    url: http://github.com/reconhub/outbreaks
    img: /img/projects/blue.png
  - name: vimes
    desc: Visualisation and Monitoring of Epidemics, including some outbreak detection algorithms.
    github: http://github.com/thibautjombart/vimes
    url: http://github.com/thibautjombart/vimes
    img: /img/projects/yellow.png
---



## Released packages
The packages listed below have been released at least once. This means that, although they are likely still evolving, a stable version is available.

{% include list-circles.html items=page.stable-list %}


## Up-and-coming packages
The packages listed below are still in development. They may be functional already, but a stable version has yet to be released.

{% include list-circles.html items=page.upcoming-list %}
