---
title: "Disease risk mapping and cluster detection"
subtitle: "An overview of SpatialEpiApp by Paula Moraga"
bigimg: "/img/banners/binary.jpg"
---





In this post we present `SpatialEpiApp`, a [Shiny](https://shiny.rstudio.com/) web application for the analysis of spatial and spatio-temporal disease data. `SpatialEpiApp` integrates two of the most common approaches in public health surveillance: disease risk mapping and detection of clusters.

The application allows to fit Bayesian disease models to obtain risk estimates and their uncertainty by using [INLA](http://www.r-inla.org/), and to detect clusters by using the scan statistics implemented in [SaTScan](https://www.satscan.org/).
`SpatialEpiApp` allows user interaction and creates interactive visualizations by using the R packages [Leaflet](https://rstudio.github.io/leaflet/) for rendering maps, [dygraphs](https://rstudio.github.io/dygraphs/) for plotting time series, and [DataTables](https://rstudio.github.io/DT/) for displaying data objects. It also enables the generation of reports containing the analyses performed by using [RMarkdown](http://rmarkdown.rstudio.com/).

To carry out these analyses users simply need to upload their map and data and then click the buttons that create the input files required, execute the software and process the output to generate tables of values and plots with the results.
Here we briefly describe the main components of the application. The package [vignette](https://cran.r-project.org/web/packages/SpatialEpiApp/vignettes/manual.pdf)
can be checked for more details about the use of the application, methods and examples.


## Use of SpatialEpiApp

`SpatialEpiApp` has been implemented in the R package `SpatialEpiApp`. Users can launch the application by executing the following code in R:

```r
install.packages("SpatialEpiApp")
library(SpatialEpiApp)
run_app()
```

The application consists of three pages: 'Inputs', 'Analysis' and 'Help'.


### Inputs

The 'Inputs' page is the first page we see when we launch the application. In this page we can upload the required files and select the type of analysis to be performed. It is composed of three components:

- Upload map (shapefile);
- Upload data (csv file with area id, date, population, cases and covariates);
- Select analysis (temporal unit, date range, spatial or spatio-temporal analysis).

<img src="/img/posts/2018-01-04-SpatialEpiApp/exinput.png" width="100%">




### Analysis

In the 'Analysis' page we can visualize the data, perform the statistical analyses, and generate reports. On the top of the page there are four buttons:

- 'Edit Inputs' which is used when we wish to return to the 'Inputs' page to modify the analysis options or upload new data;
- 'Maps Pop O E SIR' that creates plots of the population, observed, expected and SIR variables;
- 'Estimate risk' which is used for estimating the disease risk and their uncertainty;
- 'Detect clusters' used for the detection of disease clusters.

<img src="/img/posts/2018-01-04-SpatialEpiApp/animation.gif" width="100%">



The 'Analysis' page also contains four tabs called 'Interactive', 'Maps', 'Clusters' and 'Report' that include tables and plots with the results.

#### Maps

The 'Maps' tab shows a summary table, maps and temporal trend plots of the population, observed cases, expected cases, SIR, risk and lower and upper limits of 95% credible intervals that were obtained by clicking the 'Map Pop O E SIR' and the 'Estimate risk' buttons.


<img src="/img/posts/2018-01-04-SpatialEpiApp/exmaps.png" width="100%">

#### Clusters

The 'Clusters tab' shows, for each of the dates of the period of study, a map with the clusters detected and a plot with all clusters over time. This tab also includes a table with the information relative to each of the clusters such as the areas included and the significance. 


<img src="/img/posts/2018-01-04-SpatialEpiApp/exclusters.png" width="100%">

#### Report

In the 'Report tab' we can download a PDF document showing the results of our analysis. The report includes maps and tables summarizing the variables population, observed, expected, SIR, risk, lower and upper limits of the 95% credible intervals and clusters for each of the periods of time. 


<img src="/img/posts/2018-01-04-SpatialEpiApp/exreport.png" width="100%">

### Help
The 'Help' button redirects to the 'Help' page which shows information about the use of the application, the statistiscal methodology and the developing tools employed.


## Conclusion
We think the `SpatialEpiApp` can be very useful for many researchers working in health surveillance.
Moreover, the application can be easily extended and in future versions we will increase its flexibility enabling more options for disease mapping and the detection of clusters, as well as custom data visualizations.

Please get in touch if you have any suggestions or doubts about input data, methods or interpretation!

Contact: Paula Moraga
[Web](https://Paula-Moraga.github.io),
[Twitter](https://twitter.com/paumose).
