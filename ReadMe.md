This package collects and prepares data for the USF Summer Institute on 
"Methodologies for Just Urban Futures: Using Geospatial Tools to 
Address Police Violence" at Clark University, Graduate School of Geography.

Team:

- Dr. Asha Best
- Dr. Lyndon Estes
- RA. Amy Dundon
- RA. Pilar Delpino Marimon
- RA. Lester Carver


The data within the package is based 
on selected cities:


- [Baltimore, MD](https://github.com/agroimpacts/USF/blob/main/docs/MORE.md)
- Chicago, IL
- [NYC, NY](https://github.com/agroimpacts/USF/blob/main/docs/NYC.md)
- [San Francisco, CA](https://github.com/agroimpacts/USF/blob/main/docs/SFO.md)
- [Detroit, MI](https://github.com/agroimpacts/USF/blob/main/docs/DT.md)
- Kansas City, MO

The data compiled comes from open source databases. City/State Open data portals, civil society and community based open source data. For specifics, follow links to each case study.

## <ins> Installation </ins>

In Rstudio:

Install the devtools package

```
install.packages("devtools")
library(devtools)
```

Install the USF package*

_*this package holds a lot of data. It might take between 5 to 10 minutes to load depending on your internet connection._

```
library(devtools)
install_github("agroimpacts/USF")
```
To load preloaded data
```
library(USF)
data(name-of-dataset)
```


## <ins> Cloning the Repo </ins>

To run dashboards or explore the data, you must clone the `USF` repository into your computer with this link:

`https://github.com/agroimpacts/USF.git`

For step by step demo on how to clone a repository, follow this [link](https://nceas.github.io/oss-lessons/version-control/4-getting-started-with-git-in-RStudio.html).



## <ins> How to use the data </ins>

### <ins> 2022 Summer Institute </ins>

Two Shiny Dashboards have been created. Click on the links to deploy the Shiny app.


- [Risk, Value and Geographies of Policing - 2007](https://p462x7-pilar-delpino0marimon.shinyapps.io/housing-justice/)

- [Risk, Value and Geographies of Policing - 2020](https://p462x7-pilar-delpino0marimon.shinyapps.io/housing-justice-2020/)

- [Deconstructing Risk](https://p462x7-pilar-delpino0marimon.shinyapps.io/risk/#)


The scripts and data used to develop the dashboards are in the `housing-justice` and `risk` folders.




### <ins>  On police violence </ins>

For an overview on the data, click [here](https://github.com/agroimpacts/USF/blob/main/docs/Overview.md)


### <ins> GEOG246346 class projects: </ins>


- Mapping the sources/destinations/flows of budget revenues for police departments, from federal/state/municipal sources.

  Use data from [San Francisco, CA](https://github.com/agroimpacts/USF/blob/main/docs/SFO.md)
  
  and/or [Detroit, MI](https://github.com/agroimpacts/USF/blob/main/docs/DT.md)
  
  
- Changes in property valuation versus police activity and/or budgets (linked to #1).

  Use data from [San Francisco, CA](https://github.com/agroimpacts/USF/blob/main/docs/SFO.md)
  
  
- Spatio-temporal patterns and associations of police misconduct.

  Use data from [NYC, NY](https://github.com/agroimpacts/USF/blob/main/docs/NYC.md)
  
  
- Spatio-temporal patterns of surveillance (e.g. CCTV).

  Use data from [Detroit, MI](https://github.com/agroimpacts/USF/blob/main/docs/DT.md) and/or 
  [Baltimore, MD](https://github.com/agroimpacts/USF/blob/main/docs/MORE.md)


- Mapping #blacklivesmatter social media
  Could potentially be focused on the selected cities or broader US analysis.
  
  
_Access slides on GEOG246346 for Fall 2021 [here](https://github.com/agroimpacts/USF/blob/main/external/USF%20class%20projects.pdf)_


## <ins> More information </ins>

Database information in Excel spreadsheet format [link](https://github.com/agroimpacts/USF/blob/main/docs/Datasets_info.xls)

Access and download `.Rda` data from [Dropbox](https://www.dropbox.com/sh/birb6qtoc3duexc/AACzt3VVIgXrIxw6LWKDV-FLa?dl=0)

Access [slides](https://www.dropbox.com/s/a8vpnjvutps6vx1/Test_casestudies_7.23.21.pptx?dl=0) on case studies from 07/23/2021


