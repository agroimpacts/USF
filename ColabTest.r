{
  "nbformat": 4,
  "nbformat_minor": 0,
  "metadata": {
    "colab": {
      "name": "Night Time Lights Analysis of New York City 2012-2022",
      "provenance": [],
      "include_colab_link": true
    },
    "kernelspec": {
      "name": "ir",
      "display_name": "R"
    },
    "language_info": {
      "name": "R"
    }
  },
  "cells": [
    {
      "cell_type": "markdown",
      "metadata": {
        "id": "view-in-github",
        "colab_type": "text"
      },
      "source": [
        "<a href=\"https://colab.research.google.com/github/agroimpacts/USF/blob/main/ColabTest.r\" target=\"_parent\"><img src=\"https://colab.research.google.com/assets/colab-badge.svg\" alt=\"Open In Colab\"/></a>"
      ]
    },
    {
      "cell_type": "markdown",
      "source": [
        "# **Introduction**"
      ],
      "metadata": {
        "id": "M6mQ8tQaU1cW"
      }
    },
    {
      "cell_type": "markdown",
      "source": [
        "In this analysis, the feasibility of detecting police surveillance floodlights using the NASA Black Marble nighttime lights product was assessed.  Detecting floodlights using remote sensing products could provide a new way to quantify police presence in urban studies research.  The overall purpose of this project is to analyze the socioeconomic and social influences of floodlights within New York City.  To do this our project was split into three parts.  First, a proof of concept was developed for the Polo Grounds Towers public housing development in Harlem.  Between August 2015 and March 2016, [341 lights](https://www1.nyc.gov/site/nycha/about/press/pr-2016/polo-grounds-20160310.page) were installed for crime mitigation at the Polo Grounds Towers.  A programmatic method was developed to find nighttime radiance anomalies in a nighttime lights time series. We compared the mean radiance values before, during, and after the installation of these lights.  By detecting these known light installations, the Black Marble product could be used to determine the police presence at nighttime protests. \n",
        "\n",
        "The second step was to use the Black Marble nighttime lights product to determine if police surveillance floodlights used during the 2020 Black Lives Matter protests could be detected.  Our initial goal was to create a complete map of the United States showing floodlight locations in relation to BLM protests.  However, due to the scale and unavailability of BLM protest points, this idea would not allow for accurate and meaningful work.  After developing our research plan and assessing the availability of data we landed in New York City as our starting point as nighttime lights data had already been acquired for this city for the proof of concept.  New York City was a hot spot for the 2020 BLM protests within the United States and the spatial locations of protests were documented to extrapolate when studying light distribution.  The nighttime lights during the protests were compared to the same time frame in previous and subsequent years. \n",
        "\n",
        "Lastly, we analyzed the influence of floodlight installation to decrease crime in NYC public housing when compared to private housing which does not experience these policies. To do this, we developed a method to sample areas within New York City with and without public housing with a similar structure and population density.  This was done by creating gridded population and gridded building density layers.  The 10-year mean nighttime lights values were compared for areas with and without public housing.  This was done to determine if the areas with public housing are exposed to increased policing through the use of floodlights.\n",
        "\n",
        "We found that the coarse resolution and patchy coverage of the Black Marble dataset was ineffective in detecting anomalies associated with floodlights in both the proof of concept and during the BLM protests.  However, we did find that areas in NYC with public housing have greater light exposure than areas with a similar population and building structure that do not have public housing.  Upon the completion of our project goals, we had a more complete understanding of the Black Marble product, its limitations, and the influences of nighttime light levels in New York City, particularly, in concerns to our public housing populations. "
      ],
      "metadata": {
        "id": "JOxZaxdWU7GP"
      }
    },
    {
      "cell_type": "code",
      "source": [
        "knitr::opts_chunk$set(echo = FALSE)"
      ],
      "metadata": {
        "id": "aZ0c-nHEVLuC"
      },
      "execution_count": null,
      "outputs": []
    },
    {
      "cell_type": "code",
      "source": [
        "# Libraries for vector data\n",
        "install.packages(\"geojsonsf\") # Use to import geojson data\n",
        "install.packages(\"sp\")\n",
        "#install.packages(\"sf\")\n",
        "library(geojsonsf) \n",
        "library(sp)\n",
        "#library(sf)\n",
        "\n",
        "# Libraries for raster data\n",
        "install.packages(\"terra\") # Use to convert .hd format to SpatialRaster\n",
        "install.packages(\"raster\")\n",
        "#install.packages(\"exactextractr\") # Use for creating fractional images\n",
        "library(terra) \n",
        "library(raster)\n",
        "#library(exactextractr) \n",
        "\n",
        "# Libraries for data manipulation\n",
        "install.packages(\"dplyr\")\n",
        "install.packages(\"tidyr\")\n",
        "install.packages(\"zoo\") # Use to create rolling means\n",
        "install.packages(\"classInt\") # Use to create quartile breaks\n",
        "library(dplyr)\n",
        "library(tidyr)\n",
        "library(zoo)\n",
        "library(classInt)\n",
        "\n",
        "# Libraries for visualization\n",
        "install.packages(\"ggplot2\")\n",
        "install.packages(\"RColorBrewer\")\n",
        "install.packages(\"viridis\")\n",
        "install.packages(\"kableExtra\")\n",
        "library(ggplot2)\n",
        "library(RColorBrewer) # Use for color palettes\n",
        "library(viridis) # Use for color palettes\n",
        "library(kableExtra) # Use for data table formatting"
      ],
      "metadata": {
        "colab": {
          "base_uri": "https://localhost:8080/"
        },
        "id": "kbMTxmtVQrje",
        "outputId": "da015ec9-51d1-49da-e3e9-95f521cb5118"
      },
      "execution_count": null,
      "outputs": [
        {
          "output_type": "stream",
          "name": "stderr",
          "text": [
            "Installing package into ‘/usr/local/lib/R/site-library’\n",
            "(as ‘lib’ is unspecified)\n",
            "\n",
            "Installing package into ‘/usr/local/lib/R/site-library’\n",
            "(as ‘lib’ is unspecified)\n",
            "\n",
            "Installing package into ‘/usr/local/lib/R/site-library’\n",
            "(as ‘lib’ is unspecified)\n",
            "\n",
            "Installing package into ‘/usr/local/lib/R/site-library’\n",
            "(as ‘lib’ is unspecified)\n",
            "\n",
            "Installing package into ‘/usr/local/lib/R/site-library’\n",
            "(as ‘lib’ is unspecified)\n",
            "\n",
            "Installing package into ‘/usr/local/lib/R/site-library’\n",
            "(as ‘lib’ is unspecified)\n",
            "\n",
            "Installing package into ‘/usr/local/lib/R/site-library’\n",
            "(as ‘lib’ is unspecified)\n",
            "\n",
            "Installing package into ‘/usr/local/lib/R/site-library’\n",
            "(as ‘lib’ is unspecified)\n",
            "\n",
            "\n",
            "Attaching package: ‘dplyr’\n",
            "\n",
            "\n",
            "The following objects are masked from ‘package:raster’:\n",
            "\n",
            "    intersect, select, union\n",
            "\n",
            "\n",
            "The following objects are masked from ‘package:terra’:\n",
            "\n",
            "    intersect, union\n",
            "\n",
            "\n",
            "The following objects are masked from ‘package:stats’:\n",
            "\n",
            "    filter, lag\n",
            "\n",
            "\n",
            "The following objects are masked from ‘package:base’:\n",
            "\n",
            "    intersect, setdiff, setequal, union\n",
            "\n",
            "\n",
            "\n",
            "Attaching package: ‘tidyr’\n",
            "\n",
            "\n",
            "The following object is masked from ‘package:raster’:\n",
            "\n",
            "    extract\n",
            "\n",
            "\n",
            "The following object is masked from ‘package:terra’:\n",
            "\n",
            "    extract\n",
            "\n",
            "\n",
            "\n",
            "Attaching package: ‘zoo’\n",
            "\n",
            "\n",
            "The following object is masked from ‘package:terra’:\n",
            "\n",
            "    time<-\n",
            "\n",
            "\n",
            "The following objects are masked from ‘package:base’:\n",
            "\n",
            "    as.Date, as.Date.numeric\n",
            "\n",
            "\n",
            "Installing package into ‘/usr/local/lib/R/site-library’\n",
            "(as ‘lib’ is unspecified)\n",
            "\n",
            "Installing package into ‘/usr/local/lib/R/site-library’\n",
            "(as ‘lib’ is unspecified)\n",
            "\n",
            "Installing package into ‘/usr/local/lib/R/site-library’\n",
            "(as ‘lib’ is unspecified)\n",
            "\n",
            "also installing the dependency ‘gridExtra’\n",
            "\n",
            "\n",
            "Installing package into ‘/usr/local/lib/R/site-library’\n",
            "(as ‘lib’ is unspecified)\n",
            "\n",
            "also installing the dependency ‘webshot’\n",
            "\n",
            "\n",
            "Loading required package: viridisLite\n",
            "\n",
            "\n",
            "Attaching package: ‘kableExtra’\n",
            "\n",
            "\n",
            "The following object is masked from ‘package:dplyr’:\n",
            "\n",
            "    group_rows\n",
            "\n",
            "\n"
          ]
        }
      ]
    },
    {
      "cell_type": "markdown",
      "source": [
        "# **Data**"
      ],
      "metadata": {
        "id": "V2RFRJTmVAcE"
      }
    },
    {
      "cell_type": "markdown",
      "source": [
        "**1. NYC Feature Datasets**"
      ],
      "metadata": {
        "id": "710b7ZxcVDdg"
      }
    },
    {
      "cell_type": "markdown",
      "source": [
        "Public Housing Development data was acquired from [NYC Open Data](https://data.cityofnewyork.us/Housing-Development/NYCHA-GIS-file/tqnb-xmxw). This polygon dataset is a .geojson of all New York City Housing Authority developments. Additionally, census tracts and building foothills shapefiles are acquired from the same source. Census tract population data was acquired in tabular format from [NYC Planning Population FactFinder](https://popfactfinder.planning.nyc.gov/). The plot below shows the locations of public housing in blue and the Polo Grounds Towers circled in red overlaid on census tracts.\n"
      ],
      "metadata": {
        "id": "xqmDYXgGVHej"
      }
    },
    {
      "cell_type": "code",
      "source": [
        "# Shapefile of census tracts -- \n",
        "# Projection is NAD83 / New York Long Island (ft US)\n",
        "nytract <- st_read(\"/content/nyct2020.shp\")\n",
        "\n",
        "# This is the crs for NYC for future use\n",
        "ny_crs <- crs(nytract)\n",
        "\n",
        "# Geojson of NYC public housing developments \n",
        "nycha <- st_read(\"/content/nycha.geojson\") %>% \n",
        "  st_transform(ny_crs)\n",
        "\n",
        "# Select Polo Grounds Towers for proof of concept\n",
        "polo <- nycha %>% dplyr::filter(., developmen == \"POLO GROUNDS TOWERS\")\n",
        "\n",
        "# Import population data with common attribute to shapefile, \"BoroCT2020\"\n",
        "ny_pop <- read.csv(\"/content/nyct2020_pop.csv\")\n",
        "\n",
        "# Shapefile of NYC building footprints \n",
        "buildings <- st_read(\"/content/buildings_p.shp\") %>% \n",
        "  st_transform(ny_crs)\n",
        "\n",
        "# Display tracts with public housing in blue, and Polo Grounds in red with circle hightlighting the area\n",
        "ggplot() +\n",
        "  geom_sf(data = nytract, col = alpha(\"grey9\", 0.1), fill = \"grey\") +\n",
        "  geom_sf(data = nycha, aes(fill = 'A'), col = \"blue4\", \n",
        "          show.legend = \"polygon\", inherit.aes = F) +\n",
        "  geom_sf(data = polo, aes(fill = 'B'), col = NA,\n",
        "          show.legend = \"polygon\", inherit.aes = F) +\n",
        "  geom_sf(data = polo %>% st_geometry() %>% st_centroid() %>% st_buffer(2000), \n",
        "          fill = NA, col = 'red4', \n",
        "          show.legend = F, inherit.aes = F) +\n",
        "  ggtitle(\"NYC Public Housing Developments\") +\n",
        "  scale_fill_manual(values = c(\"A\" = \"blue\", \"B\" = \"red\"), \n",
        "                    labels = c(\"Public Housing Developments\", \"Polo Grounds Towers\")) +\n",
        "  xlab('') + ylab('') +\n",
        "  theme_bw() +\n",
        "  theme(panel.grid.major = element_blank(), \n",
        "        panel.grid.minor = element_blank(),\n",
        "        legend.title = element_blank(),\n",
        "        axis.text.y = element_blank(),\n",
        "        axis.text.x = element_blank(),\n",
        "        axis.ticks = element_blank(),\n",
        "        legend.position = c(0.22, 0.92)) +\n",
        "  ggsave(\"C:/CLARK/GEOSPAAR/floodlightblm/graphics/ph_overview.png\")"
      ],
      "metadata": {
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 97
        },
        "id": "rz39njJsVSVk",
        "outputId": "af3b92d6-e099-4413-d3e5-32a643a6af28"
      },
      "execution_count": null,
      "outputs": [
        {
          "output_type": "error",
          "ename": "ERROR",
          "evalue": "ignored",
          "traceback": [
            "Error in st_read(\"/content/nyct2020.shp\"): could not find function \"st_read\"\nTraceback:\n"
          ]
        }
      ]
    },
    {
      "cell_type": "code",
      "source": [
        "knitr::include_graphics(\"graphics\\\\ph_overview.png\")"
      ],
      "metadata": {
        "id": "N5eQMUk0VYDF"
      },
      "execution_count": null,
      "outputs": []
    },
    {
      "cell_type": "markdown",
      "source": [
        "**2. BLM Protest Points**"
      ],
      "metadata": {
        "id": "il38zknbVY2F"
      }
    },
    {
      "cell_type": "markdown",
      "source": [
        "Further downloading and developing our research after utilizing the NYC GIS database, we used a combination of points from a [web map](https://en.wikipedia.org/wiki/George_Floyd_protests_in_New_York_City) located in a Wikipedia timeline to find BLM protests that occurred in NYC, and a time series of NASA Black Marble data spanning from January 19, 2012, to December 31, 2021, to find the long term mean of nighttime lights in NYC. To deploy our BLM points into RStudio we manually entered the dates, longitude, latitude, and names of each BLM protest into a spreadsheet on Excel. We found the dates of each point through extensive research and assumptions on the timelines of each BLM protest. This process was then replicated to find the nighttime locations of protests, as these are the most relevant protests to our floodlights, we then read in the entire data set and nighttime CSV file to begin our true analysis within RStudio."
      ],
      "metadata": {
        "id": "kEQ-jvt6VcgI"
      }
    },
    {
      "cell_type": "code",
      "source": [
        "blm_csv <- read.csv(\"//Users//liamtobin//downloads//BLM Protest Points - Sheet1.csv\")\n",
        "\n",
        "s3 <- stack(\"//Users//liamtobin//downloads//floodlightblmdata//bm_nyc.grd\")\n",
        "\n",
        "nycha <- geojson_sf(\"//Users//liamtobin//downloads//floodlightblmdata//nycha.geojson\")\n",
        "\n",
        "# Select Polo Grounds Towers for proof of concept\n",
        "polo <- nycha %>% dplyr::filter(., developmen == \"POLO GROUNDS TOWERS\")\n",
        "\n",
        "# Shapefile of census tracts\n",
        "nytract <- st_read(\"//Users//liamtobin//downloads//floodlightblmdata//nyct2020.shp\") %>%\n",
        "  st_transform(crs(nycha))\n",
        "\n",
        "# Read protest points for BLM protests\n",
        "blm_csv_night <- read.csv(\"//Users//liamtobin//downloads//BLM Protest Points Night - Sheet1.csv\")\n",
        "\n",
        "# Convert protest points csv to sf\n",
        "blm_pts_night <- st_as_sf(blm_csv_night, coords = c(\"Long\", \"Lat\"))\n",
        "\n",
        "# Add crs to protest points\n",
        "st_crs(blm_pts_night) <- st_crs(nycha)"
      ],
      "metadata": {
        "id": "EAjRT2yZVfms"
      },
      "execution_count": null,
      "outputs": []
    },
    {
      "cell_type": "markdown",
      "source": [
        "**3. NASA Black Marble Night Time Lights**"
      ],
      "metadata": {
        "id": "4Q7si7bZVg1w"
      }
    },
    {
      "cell_type": "markdown",
      "source": [
        "A time series of the NASA Black Marble product was acquired for a time series from January 19, 2012 to December 31, 2021.  Specifically, the VNP46A2 - VIIRS/NPP Gap-Filled Lunar BRDF-Adjusted Nighttime Lights is used.  This product is a daily, 500-meter resolution raster of nocturnal visible light that is corrected for atmospheric conditions and lunar irradiance. Band 3 of this product, the Gap-Filled DNB BRDF-Corrected NTL, will be used in this study. In this band, pixels that are masked due to cloud cover or low data quality are filled with the closest value temporally.  17.5 GB of daily observations were downloaded from [LAADS DAAC](https://ladsweb.modaps.eosdis.nasa.gov/) using command line code provided by LADDS DAAC. The data is in a .h5 datatype which was converted to raster datatype.  The extent of this download is a 10 x 10 degree grid which is cropped to the NYC extent.  The following code block performs this preprocessing to create a manageable raster stack for analysis:"
      ],
      "metadata": {
        "id": "DAJY8tx2VmGM"
      }
    },
    {
      "cell_type": "code",
      "source": [
        "# List of .h5 files\n",
        "files <- list.files(\"E://blackmarble\", pattern = \".h5\", full.names = TRUE)\n",
        "\n",
        "# Get dates from file names create vector to add to raster stack\n",
        "dates <- as.Date(sapply(files, function(x) {substr(x, 26, 32)}), format = \"%Y%j\")\n",
        "\n",
        "# Create a list of processed images\n",
        "l <- lapply(files, function(i){\n",
        "  # Date character\n",
        "  d <- substr(i, 26, 32)\n",
        "  # Convert .h5 to SpatRaster\n",
        "  i_sr <- rast(i)\n",
        "  # Select gap-filled band and convert to raster\n",
        "  i_rast <- raster(i_sr[[3]])\n",
        "  # Set extent\n",
        "  extent(i_rast) <- c(-80, -70, 40, 50)\n",
        "  # Set crs\n",
        "  crs(i_rast) <- \"EPSG:4326\"\n",
        "  # Crop to NYC\n",
        "  i_rast_nyc <- crop(i_rast, c(-74.256, -73.699, 40.496, 40.916))\n",
        "  # Set NA\n",
        "  i_rast_nyc[i_rast_nyc == 65535] <- NA\n",
        "  # Rename with date\n",
        "  names(i_rast_nyc) <- d\n",
        "  return(i_rast_nyc)\n",
        "})\n",
        "\n",
        "# Stack list of raster layers and add date\n",
        "s <- setZ(stack(l), dates, \"date\")\n",
        "\n",
        "# Export raster stack\n",
        "writeRaster(s, \"C://CLARK//GEOSPAAR//floodlightblm//data//bm_nyc_cen.grd\",\n",
        "            format = \"raster\")\n",
        "```\n",
        "\n",
        "The following is a masked visualization of the mean NYC nighttime lights from 2012 to 2022.\n",
        "\n",
        "```{r, eval = FALSE}\n",
        "# Upload raster stack of nighttime lights\n",
        "s <- stack(\"C://CLARK//GEOSPAAR//floodlightblm//data//bm_nyc_cen.grd\")\n",
        "\n",
        "# Calculate the long term mean of nighttime lights, \n",
        "# project to NYC crs, then mask to NYC.\n",
        "mean_s <- mean(s, na.rm = TRUE) %>% projectRaster(., crs = ny_crs)\n",
        "mean_sc <- mask(mean_s, nytract)\n",
        "\n",
        "# Convert raster to dataframe for plotting\n",
        "mean_s_df <- as.data.frame(rasterToPoints(mean_sc))\n",
        "colnames(mean_s_df) <- c('x', 'y', 'value')\n",
        "\n",
        "# Plot long term mean of nighttime lights for NYC\n",
        "ggplot() + \n",
        "  geom_raster(aes(x = x, y = y, fill = value), data = mean_s_df) +\n",
        "  ggtitle(\"NYC Nighttime Lights mean radiance 2012 - 2022\") +\n",
        "  scale_fill_viridis(guide = guide_colorbar(title = \"nWatts·cm−2·sr−1\", \n",
        "                                             ticks = FALSE)) +\n",
        "  xlab('') + ylab('') +\n",
        "  theme_bw() +\n",
        "  theme(panel.grid.major = element_blank(), \n",
        "        panel.grid.minor = element_blank(),\n",
        "        axis.text.y = element_blank(),\n",
        "        axis.text.x = element_blank(),\n",
        "        axis.ticks = element_blank(),\n",
        "        legend.position = c(0.2, 0.8)) +\n",
        "  ggsave(\"C:/CLARK/GEOSPAAR/floodlightblm/graphics/mean_lights.png\")"
      ],
      "metadata": {
        "id": "Og22y_I3Vo3W"
      },
      "execution_count": null,
      "outputs": []
    },
    {
      "cell_type": "code",
      "source": [
        "knitr::include_graphics(\"graphics\\\\mean_lights.png\")"
      ],
      "metadata": {
        "id": "rSY_6XBhVqZf"
      },
      "execution_count": null,
      "outputs": []
    },
    {
      "cell_type": "markdown",
      "source": [
        "**3. NASA Black Marble Night Time Lights**"
      ],
      "metadata": {
        "id": "1jzjVT7uW-2l"
      }
    },
    {
      "cell_type": "markdown",
      "source": [
        "A time series of the NASA Black Marble product was acquired for a time series from January 19, 2012 to December 31, 2021.  Specifically, the VNP46A2 - VIIRS/NPP Gap-Filled Lunar BRDF-Adjusted Nighttime Lights is used.  This product is a daily, 500-meter resolution raster of nocturnal visible light that is corrected for atmospheric conditions and lunar irradiance. Band 3 of this product, the Gap-Filled DNB BRDF-Corrected NTL, will be used in this study. In this band, pixels that are masked due to cloud cover or low data quality are filled with the closest value temporally.  17.5 GB of daily observations were downloaded from [LAADS DAAC](https://ladsweb.modaps.eosdis.nasa.gov/) using command line code provided by LADDS DAAC. The data is in a .h5 datatype which was converted to raster datatype.  The extent of this download is a 10 x 10 degree grid which is cropped to the NYC extent.  The following code block performs this preprocessing to create a manageable raster stack for analysis:"
      ],
      "metadata": {
        "id": "guBNp-GHXCk_"
      }
    },
    {
      "cell_type": "code",
      "source": [
        "# List of .h5 files\n",
        "files <- list.files(\"E://blackmarble\", pattern = \".h5\", full.names = TRUE)\n",
        "\n",
        "# Get dates from file names create vector to add to raster stack\n",
        "dates <- as.Date(sapply(files, function(x) {substr(x, 26, 32)}), format = \"%Y%j\")\n",
        "\n",
        "# Create a list of processed images\n",
        "l <- lapply(files, function(i){\n",
        "  # Date character\n",
        "  d <- substr(i, 26, 32)\n",
        "  # Convert .h5 to SpatRaster\n",
        "  i_sr <- rast(i)\n",
        "  # Select gap-filled band and convert to raster\n",
        "  i_rast <- raster(i_sr[[3]])\n",
        "  # Set extent\n",
        "  extent(i_rast) <- c(-80, -70, 40, 50)\n",
        "  # Set crs\n",
        "  crs(i_rast) <- \"EPSG:4326\"\n",
        "  # Crop to NYC\n",
        "  i_rast_nyc <- crop(i_rast, c(-74.256, -73.699, 40.496, 40.916))\n",
        "  # Set NA\n",
        "  i_rast_nyc[i_rast_nyc == 65535] <- NA\n",
        "  # Rename with date\n",
        "  names(i_rast_nyc) <- d\n",
        "  return(i_rast_nyc)\n",
        "})\n",
        "\n",
        "# Stack list of raster layers and add date\n",
        "s <- setZ(stack(l), dates, \"date\")\n",
        "\n",
        "# Export raster stack\n",
        "writeRaster(s, \"C://CLARK//GEOSPAAR//floodlightblm//data//bm_nyc_cen.grd\",\n",
        "            format = \"raster\")\n",
        "\n"
      ],
      "metadata": {
        "id": "BF_o8qqOXD4f"
      },
      "execution_count": null,
      "outputs": []
    },
    {
      "cell_type": "markdown",
      "source": [
        "The following is a masked visualization of the mean NYC nighttime lights from 2012 to 2022."
      ],
      "metadata": {
        "id": "KFM4LCsxXU2W"
      }
    },
    {
      "cell_type": "code",
      "source": [
        "# Upload raster stack of nighttime lights\n",
        "s <- stack(\"C://CLARK//GEOSPAAR//floodlightblm//data//bm_nyc_cen.grd\")\n",
        "\n",
        "# Calculate the long term mean of nighttime lights, \n",
        "# project to NYC crs, then mask to NYC.\n",
        "mean_s <- mean(s, na.rm = TRUE) %>% projectRaster(., crs = ny_crs)\n",
        "mean_sc <- mask(mean_s, nytract)\n",
        "\n",
        "# Convert raster to dataframe for plotting\n",
        "mean_s_df <- as.data.frame(rasterToPoints(mean_sc))\n",
        "colnames(mean_s_df) <- c('x', 'y', 'value')\n",
        "\n",
        "# Plot long term mean of nighttime lights for NYC\n",
        "ggplot() + \n",
        "  geom_raster(aes(x = x, y = y, fill = value), data = mean_s_df) +\n",
        "  ggtitle(\"NYC Nighttime Lights mean radiance 2012 - 2022\") +\n",
        "  scale_fill_viridis(guide = guide_colorbar(title = \"nWatts·cm−2·sr−1\", \n",
        "                                             ticks = FALSE)) +\n",
        "  xlab('') + ylab('') +\n",
        "  theme_bw() +\n",
        "  theme(panel.grid.major = element_blank(), \n",
        "        panel.grid.minor = element_blank(),\n",
        "        axis.text.y = element_blank(),\n",
        "        axis.text.x = element_blank(),\n",
        "        axis.ticks = element_blank(),\n",
        "        legend.position = c(0.2, 0.8)) +\n",
        "  ggsave(\"C:/CLARK/GEOSPAAR/floodlightblm/graphics/mean_lights.png\")"
      ],
      "metadata": {
        "id": "CAgdOJ3hXVn9"
      },
      "execution_count": null,
      "outputs": []
    },
    {
      "cell_type": "code",
      "source": [
        "knitr::include_graphics(\"graphics\\\\mean_lights.png\")"
      ],
      "metadata": {
        "id": "ajY2urZzXGh1"
      },
      "execution_count": null,
      "outputs": []
    },
    {
      "cell_type": "markdown",
      "source": [
        "#**Methods**"
      ],
      "metadata": {
        "id": "9u8lzE6fVrkN"
      }
    },
    {
      "cell_type": "markdown",
      "source": [
        "In undertaking the methods portion of our analysis there were many packages and data sets that needed to be collected. To fully understand nighttime light anomalies, BLM protests/floodlight locations, and public/private housing levels in New York City we needed  visualization packages within RStudio. These visualization packages included `ggplot2` for maps and graphs, `RColorBrewer` and `viridis` for color palettes, and `kableExtra` for table visualization.  The main packages we installed to manage the NYC city, protest location, and public housing vector data were `sf` and `sp`. The `terra` and `raster` packages were used for raster creating and manipulation when working with Black Marble and creating gridded population and building volume rasters.  `terra` was primarily used to convert the Black Marble .h5 files to `SpatRaster` format. `raster` was used for analysis and extraction of the nighttime lights time series.  After extracting night time lights values and working with dataframes, `dplyr`, `tidyr`, and `zoo` were used for data manipulation.  `zoo` allows for the creation of rolling means.  Finally, `ggplot2` were used to visualize the results of our analysis and to create a spatially appropriate examination of our data. Our method for data collection included the use of NYC GIS, specifically, a geojson polygon dataset of all New York City Housing Authority developments. After finding this data we added the area to census tracts and joined them with our New York City population data. Shortly after, we defined this data as a raster with an extent and resolution as mean nighttime lights. These steps were crucial in the development of our public housing analysis and the creation of an interpolated population grid. \n",
        "\n",
        "The following packages are needed for our analysis."
      ],
      "metadata": {
        "id": "wdRiVYzMVv_Q"
      }
    },
    {
      "cell_type": "code",
      "source": [
        "# Libraries for vector data\n",
        "install.packages(\"geojsonsf\") # Use to import geojson data\n",
        "install.packages(\"sp\")\n",
        "install.packages(\"sf\")\n",
        "library(geojsonsf) \n",
        "library(sp)\n",
        "library(sf)\n",
        "\n",
        "# Libraries for raster data\n",
        "install.packages(\"terra\") # Use to convert .hd format to SpatialRaster\n",
        "install.packages(\"raster\")\n",
        "install.packages(\"exactextractr\") # Use for creating fractional images\n",
        "library(terra) \n",
        "library(raster)\n",
        "library(exactextractr) \n",
        "\n",
        "# Libraries for data manipulation\n",
        "install.packages(\"dplyr\")\n",
        "install.packages(\"tidyr\")\n",
        "install.packages(\"zoo\") # Use to create rolling means\n",
        "install.packages(\"classInt\") # Use to create quartile breaks\n",
        "library(dplyr)\n",
        "library(tidyr)\n",
        "library(zoo)\n",
        "library(classInt)\n",
        "\n",
        "# Libraries for visualization\n",
        "install.packages(\"ggplot2\")\n",
        "install.packages(\"RColorBrewer\")\n",
        "install.packages(\"viridis\")\n",
        "install.packages(\"kableExtra\")\n",
        "library(ggplot2)\n",
        "library(RColorBrewer) # Use for color palettes\n",
        "library(viridis) # Use for color palettes\n",
        "library(kableExtra) # Use for data table formatting"
      ],
      "metadata": {
        "colab": {
          "base_uri": "https://localhost:8080/"
        },
        "id": "QAXRKkmdVzOa",
        "outputId": "695a6bbb-dc95-463d-93ec-06e15f33ab16"
      },
      "execution_count": null,
      "outputs": [
        {
          "output_type": "stream",
          "name": "stderr",
          "text": [
            "Installing package into ‘/usr/local/lib/R/site-library’\n",
            "(as ‘lib’ is unspecified)\n",
            "\n",
            "Installing package into ‘/usr/local/lib/R/site-library’\n",
            "(as ‘lib’ is unspecified)\n",
            "\n",
            "Installing package into ‘/usr/local/lib/R/site-library’\n",
            "(as ‘lib’ is unspecified)\n",
            "\n",
            "Installing package into ‘/usr/local/lib/R/site-library’\n",
            "(as ‘lib’ is unspecified)\n",
            "\n",
            "Installing package into ‘/usr/local/lib/R/site-library’\n",
            "(as ‘lib’ is unspecified)\n",
            "\n",
            "Installing package into ‘/usr/local/lib/R/site-library’\n",
            "(as ‘lib’ is unspecified)\n",
            "\n",
            "Installing package into ‘/usr/local/lib/R/site-library’\n",
            "(as ‘lib’ is unspecified)\n",
            "\n",
            "Installing package into ‘/usr/local/lib/R/site-library’\n",
            "(as ‘lib’ is unspecified)\n",
            "\n",
            "\n",
            "Attaching package: ‘dplyr’\n",
            "\n",
            "\n",
            "The following objects are masked from ‘package:raster’:\n",
            "\n",
            "    intersect, select, union\n",
            "\n",
            "\n",
            "The following objects are masked from ‘package:terra’:\n",
            "\n",
            "    intersect, union\n",
            "\n",
            "\n",
            "The following objects are masked from ‘package:stats’:\n",
            "\n",
            "    filter, lag\n",
            "\n",
            "\n",
            "The following objects are masked from ‘package:base’:\n",
            "\n",
            "    intersect, setdiff, setequal, union\n",
            "\n",
            "\n",
            "\n",
            "Attaching package: ‘tidyr’\n",
            "\n",
            "\n",
            "The following object is masked from ‘package:raster’:\n",
            "\n",
            "    extract\n",
            "\n",
            "\n",
            "The following object is masked from ‘package:terra’:\n",
            "\n",
            "    extract\n",
            "\n",
            "\n",
            "\n",
            "Attaching package: ‘zoo’\n",
            "\n",
            "\n",
            "The following object is masked from ‘package:terra’:\n",
            "\n",
            "    time<-\n",
            "\n",
            "\n",
            "The following objects are masked from ‘package:base’:\n",
            "\n",
            "    as.Date, as.Date.numeric\n",
            "\n",
            "\n",
            "Installing package into ‘/usr/local/lib/R/site-library’\n",
            "(as ‘lib’ is unspecified)\n",
            "\n",
            "Installing package into ‘/usr/local/lib/R/site-library’\n",
            "(as ‘lib’ is unspecified)\n",
            "\n",
            "Installing package into ‘/usr/local/lib/R/site-library’\n",
            "(as ‘lib’ is unspecified)\n",
            "\n",
            "also installing the dependency ‘gridExtra’\n",
            "\n",
            "\n",
            "Installing package into ‘/usr/local/lib/R/site-library’\n",
            "(as ‘lib’ is unspecified)\n",
            "\n",
            "also installing the dependency ‘webshot’\n",
            "\n",
            "\n",
            "Loading required package: viridisLite\n",
            "\n",
            "\n",
            "Attaching package: ‘kableExtra’\n",
            "\n",
            "\n",
            "The following object is masked from ‘package:dplyr’:\n",
            "\n",
            "    group_rows\n",
            "\n",
            "\n"
          ]
        }
      ]
    },
    {
      "cell_type": "markdown",
      "source": [
        "**1. Polo Grounds Towers Proof of Concept**"
      ],
      "metadata": {
        "id": "Ie9RiSx0Xf3c"
      }
    },
    {
      "cell_type": "markdown",
      "source": [
        "For this first part of the analysis, the goal was to be able to see if we could detect a known light installation in the New York Housing Authority project Polo Grounds. We found an article published on the nyc.gov website which claimed an installation of 341 new light fixtures at this location occurred between early August 2015 and March 10th, 2016. We first set out to see if we could find an anomaly in the amount of radiance from before and after the light installation. Then we set out to see how the values change over time to see if there are any recurring patterns by doing a rolling 30-day mean due to a large amount of noise in the data. Lastly, in an attempt to dampen the influence of yearly trends, we expanded the mean to quarterly."
      ],
      "metadata": {
        "id": "GltPTf1kXjZI"
      }
    },
    {
      "cell_type": "code",
      "source": [
        "# Names of each layer aka dates in format Xyyyyjjj\n",
        "names_s <- names(s)\n",
        "\n",
        "# Taking out the X in the dates\n",
        "dates_yj <- as.data.frame(names_s) %>%  lapply(., function(x) {\n",
        "  gsub(\"X\", \"\", x)})\n",
        "\n",
        "# Converting from yyyyjjj to date data format\n",
        "dates <- lapply(dates_yj, function(x) {\n",
        "  as.Date(x, format = \"%Y%j\")\n",
        "})\n",
        "\n",
        "# Adding dates as z value to each layer for easy querying \n",
        "p <- as.data.frame(dates)\n",
        "s2 <- setZ(s, p[,1], \"date\")\n",
        "dates <- getZ(s2)\n",
        "class(getZ(s2)) \n",
        "print(s2)\n",
        "\n",
        "# Query Formatting\n",
        "instal_sub <- subset(s2, \n",
        "                  which(getZ(s2) >= '2015-7-01' & (getZ(s2) <= '2016-03-10')))\n",
        "\n",
        "# Getting subsets of before and after year of known installation \n",
        "before_inst_sub <- subset(s2, \n",
        "                  which(getZ(s2) <= '2015-07-01' & (getZ(s2) >= '2014-07-01')))\n",
        "after_inst_sub <- subset(s2, \n",
        "                  which(getZ(s2) >= '2016-03-10' & (getZ(s2) <= '2017-03-10')))\n",
        "\n",
        "# Creating one year means before and after the installation of lights at Polo Grounds\n",
        "before_mean <- mean(before_inst_sub, na.rm = TRUE)\n",
        "after_mean <- mean(after_inst_sub, na.rm = TRUE)\n",
        "\n",
        "# Anomalies of radiance, from before and after light installation\n",
        "diff <- (after_mean - before_mean)\n",
        "\n",
        "# Cropping the anomaly for Polo Grounds, turns out to only be 1 pixel\n",
        "rpolo_ann <- crop(x = diff, y = polo)\n",
        "rpolo_ann_df <- as.data.frame(rpolo_ann, xy = TRUE)\n",
        "rpolo_ann_df$layer\n",
        "\n",
        "# This Results in a value of -190 over polo grounds, which shows a decrease in radiance comparing before and after the light installation.\n",
        "\n",
        "# Looking at a 30 day rolling mean of the data above to visualize the decrease in radiance\n",
        "polo_roll <- polo_frame %>% mutate(month_av = rollapply(polo_frame[[1]], \n",
        "              width = 30, FUN = function(x) mean(x, na.rm = TRUE), fill = NA))\n",
        "\n",
        "# Creation of 30 day rolling mean of 3 year chunk analyzed above to display why a decrease in radiance is seen\n",
        "polo_roll %>% \n",
        "ggplot() + \n",
        "  geom_line(mapping = aes(x = date, y = month_av), size = 1.2, col = \"blue\") +\n",
        "  geom_line(polo_roll[(361:614),], mapping = aes(x = date, y = month_av), \n",
        "            size = 1.2, col = \"red\") +\n",
        "  xlab(\"Date\") + ylab(\"Radiancen (Watts·cm^−2·sr^−1)\") +\n",
        "  ggtitle(\"Polo Grounds 30 day rolling mean with light installation period highlighted in red\") +\n",
        "  ggsave(\"C:/GEOG246_R/floodlightblm/vignettes/graphics/rolling_mean_window2.png\")\n",
        "```\n",
        "\n",
        "Displaying why the resulting anomaly value for polo ground is showing a decrease in radiance.\n",
        "```{r, out.width = \"60%\", echo = FALSE, fig.align = 'center'}\n",
        "knitr::include_graphics(\"graphics\\\\rolling_mean_window2.png\")\n",
        "```\n",
        "\n",
        "Seeing Polo Grounds in the context of the whole time series by doing a 30 day rolling mean.\n",
        "\n",
        "```{r, eval = FALSE}\n",
        "# Cropping the time series to Polo Grounds\n",
        "polo_s2 <- crop(x = s2, y = polo)\n",
        "\n",
        "# Making a data frame from those radiance values form all the layers\n",
        "polo_frame_full <- extract(x = polo_s2,\n",
        "                   y = polo, exact = TRUE, na.rm = TRUE) %>% unlist(.) %>% \n",
        "                  as.data.frame(.) %>% mutate(., date = getZ(s2))\n",
        "\n",
        "# Executing a rolling mean of 30 days across the whole time series and saving it as a new column in the data frame.\n",
        "polo_roll_full <- polo_frame_full %>%\n",
        "  mutate(month_av = rollapply(polo_frame_full[[1]],\n",
        "                width = 30, FUN = function(x) mean(x, na.rm = TRUE), fill = NA))\n",
        "\n",
        "# NA values are excluded from this rolling mean and the first 15 are NA.\n",
        "\n",
        "polo_roll_full %>% \n",
        "ggplot() + geom_line(mapping = aes(x = date, y = month_av), col = \"blue\", size = 1.2) +\n",
        "  geom_line(polo_roll_full[(1244:1497), ], \n",
        "            mapping = aes(x = date, y = month_av), col = \"red\", size = 1.2) +\n",
        "  ggtitle(\"Rolling 30 day mean over Polo Grounds with light installation period highlighted in red\") +\n",
        "  ylab(\"Radaice (Watts·cm^−2·sr^−1)\") + xlab(NULL) +\n",
        "  ggsave(\"C:/GEOG246_R/floodlightblm/vignettes/graphics/rolling_mean_polo.png\")"
      ],
      "metadata": {
        "id": "dOUixICLXkly"
      },
      "execution_count": null,
      "outputs": []
    },
    {
      "cell_type": "markdown",
      "source": [
        "Displaying a rolling mean of 30 days over polo ground across the whole time series."
      ],
      "metadata": {
        "id": "z_BmDHOZXpo_"
      }
    },
    {
      "cell_type": "code",
      "source": [
        "knitr::include_graphics(\"graphics\\\\rolling_mean_polo.png\")"
      ],
      "metadata": {
        "id": "xX0EYXbjXqTw"
      },
      "execution_count": null,
      "outputs": []
    },
    {
      "cell_type": "markdown",
      "source": [
        "Looking at quarterly means to smooth over short term trends."
      ],
      "metadata": {
        "id": "33fcsPujXr5X"
      }
    },
    {
      "cell_type": "code",
      "source": [
        "# Summarizing the radiance values over Polo Grounds by 3-month means in an effort\n",
        "# to lessen the influence of the February spike in radiance seen every year. \n",
        "zoo_frame <- polo_roll_full %>% \n",
        "  mutate(quarter = as.yearqtr(polo_roll_full$date, format = \"%Y-%m-%d\")) %>%\n",
        "  mutate(radiance = as.numeric(polo_roll_full$.)) %>% \n",
        "  group_by(quarter) %>% \n",
        "  summarise(., mean = mean(radiance, na.rm = TRUE)) %>% \n",
        "  as.data.frame(.) %>% \n",
        "  mutate(year = as.yearqtr(.$quarter, format = \"%y/0%q\") %>%\n",
        "  format(., format = \"%y\")) %>%\n",
        "  mutate(row_num = seq.int(nrow(.))) %>% \n",
        "  mutate(group = ifelse(row_num < 15, \"Before\", \n",
        "                        ifelse(row_num > 17, \"After\", \"During\")))\n",
        "\n",
        "# Looking at the difference of before and after installation with full time scale\n",
        "zoo_table <- zoo_frame %>% \n",
        "  group_by(group) %>% \n",
        "  summarise(., mean = round(mean(mean))) %>% \n",
        "  as.data.frame(.) \n",
        "\n",
        "# Adding the difference row in the table\n",
        "zoo_table[nrow(zoo_table) + 1, ] <- c(\"difference\", \n",
        "                                      (zoo_table$mean[1] - zoo_table$mean[2]))\n",
        "# Creation of a more visually appealing table\n",
        "zoo_table %>% kable() %>% kable_styling() %>% \n",
        "  as_image(file = \"C:/GEOG246_R/floodlightblm/vignettes/graphics/polo_table.png\")\n",
        "\n",
        "# Line plot of quarterly \n",
        "ggplot(zoo_frame) +\n",
        "  geom_line(aes(x = quarter, y = mean), size = 0.5) + ylab(\"Radiance\") +\n",
        "  geom_point(mapping = aes(x = quarter, y = mean, color = group), size = 2) +\n",
        "  xlab(NULL) +\n",
        "  ggtitle(\"Comparison of radiance of before and after\n",
        "light instalation at Polo Grounds by looking at quarterly means\") +\n",
        "   ggsave(\"C:/GEOG246_R/floodlightblm/vignettes/graphics/polo_qline_plot.png\")"
      ],
      "metadata": {
        "id": "VwUpTLKxXtPN"
      },
      "execution_count": null,
      "outputs": []
    },
    {
      "cell_type": "markdown",
      "source": [
        "Quarterly means of Polo Ground"
      ],
      "metadata": {
        "id": "EX26sTpjXv1x"
      }
    },
    {
      "cell_type": "code",
      "source": [
        "knitr::include_graphics(\"graphics\\\\polo_qline_plot.png\")"
      ],
      "metadata": {
        "id": "YY4Hv2Y7XxFn"
      },
      "execution_count": null,
      "outputs": []
    },
    {
      "cell_type": "markdown",
      "source": [
        "**2. BLM Protest Analysis**"
      ],
      "metadata": {
        "id": "SQrVRgBLXzfA"
      }
    },
    {
      "cell_type": "markdown",
      "source": [
        "For part two of the analysis we used a combination of points from a web map located in a Wikipedia timeline to find BLM protests that occurred in NYC, and a time series of NASA Black Marble data spanning from January 19, 2012, to December 31, 2021, to find the long term mean of nighttime lights in NYC. To deploy our BLM points into RStudio we manually entered the dates, longitude, latitude, and names of each BLM protest into a spreadsheet on Excel. We found the dates of each point through extensive research and assumptions on the timelines of each BLM protest. This process was then replicated to find the nighttime locations of protests, as these are the most relevant protests to our floodlights, we then read in the entire data set and nighttime CSV file to begin our true analysis. Upon the completion of these steps we created a map showing BLM Protest Points over the NYC grid during the day and at night. Furthermore, a comparison of a mean 3 day period (During the BLM Protest Dates) - comparing nighttime floodlight radiance over multiple years. \n",
        "\n",
        "Reading in BLM Protest Points and NYC GRID."
      ],
      "metadata": {
        "id": "uwXR-aPhX2FC"
      }
    },
    {
      "cell_type": "code",
      "source": [
        "blm_csv <- read.csv(\"//Users//liamtobin//downloads//BLM Protest Points - Sheet1.csv\")\n",
        "\n",
        "s3 <- stack(\"//Users//liamtobin//downloads//floodlightblmdata//bm_nyc.grd\")"
      ],
      "metadata": {
        "id": "m4ZPIhCmX5bO"
      },
      "execution_count": null,
      "outputs": []
    },
    {
      "cell_type": "markdown",
      "source": [
        "Reading in Polo Ground Towers proof of concept. "
      ],
      "metadata": {
        "id": "Ygng4k44X6TL"
      }
    },
    {
      "cell_type": "code",
      "source": [
        "nycha <- geojson_sf(\"//Users//liamtobin//downloads//floodlightblmdata//nycha.geojson\")\n",
        "\n",
        "# Select Polo Grounds Towers for proof of concept\n",
        "polo <- nycha %>% dplyr::filter(., developmen == \"POLO GROUNDS TOWERS\")\n",
        "\n",
        "# Shapefile of census tracts\n",
        "nytract <- st_read(\"//Users//liamtobin//downloads//floodlightblmdata//nyct2020.shp\") %>%\n",
        "  st_transform(crs(nycha))\n",
        "\n",
        "# Visualize housing and tracts\n",
        "par(mar = c(0, 0, 1, 0))\n",
        "plot(nytract %>% st_geometry(), col = \"grey\", pch = NA, border = \"grey9\", \n",
        "     main = \"NYC Public Housing Development\")\n",
        "plot(nycha %>% st_geometry(), col = \"blue\", border = 'blue', add = TRUE)\n",
        "plot(polo %>% st_geometry(), col = \"red\", border = 'red', add = TRUE)\n",
        "plot(polo %>% st_geometry() %>% st_centroid() %>% st_buffer(1000), \n",
        "     col = NA, border = 'red', add = TRUE)"
      ],
      "metadata": {
        "id": "BYLRkolKX7jd"
      },
      "execution_count": null,
      "outputs": []
    },
    {
      "cell_type": "markdown",
      "source": [
        "Plotting all BLM Protest Points. "
      ],
      "metadata": {
        "id": "TAXt2IlgX-wo"
      }
    },
    {
      "cell_type": "code",
      "source": [
        "# Read protest points for BLM protests\n",
        "blm_csv <- read.csv(\"//Users//liamtobin//downloads//BLM Protest Points - Sheet1.csv\")\n",
        "\n",
        "# Convert protest points csv to sf\n",
        "blm_pts <- st_as_sf(blm_csv, coords = c(\"Long\", \"Lat\"))\n",
        "\n",
        "# Add crs to protest points\n",
        "st_crs(blm_pts) <- st_crs(nycha)\n",
        "\n",
        "# Visualize protest points\n",
        "par(mar = c(0, 0, 1, 0))\n",
        "plot(nytract %>% st_geometry(), col = \"grey\", pch = NA, border = \"grey9\", \n",
        "     main = \"BLM Protest Locations\")\n",
        "plot(blm_pts %>% st_geometry(), col = \"blue\", pch = 16, add = TRUE)"
      ],
      "metadata": {
        "id": "DQzb4xMuX_9Y"
      },
      "execution_count": null,
      "outputs": []
    },
    {
      "cell_type": "markdown",
      "source": [
        "Plotting only Night Time BLM Protest Points."
      ],
      "metadata": {
        "id": "yHN87aXYYCsp"
      }
    },
    {
      "cell_type": "code",
      "source": [
        "# Read protest points for BLM protests\n",
        "blm_csv_night <- read.csv(\"//Users//liamtobin//downloads//BLM Protest Points Night - Sheet1.csv\")\n",
        "\n",
        "# Convert protest points csv to sf\n",
        "blm_pts_night <- st_as_sf(blm_csv_night, coords = c(\"Long\", \"Lat\"))\n",
        "\n",
        "# Add crs to protest points\n",
        "st_crs(blm_pts_night) <- st_crs(nycha)\n",
        "\n",
        "# Visualize protest points\n",
        "par(mar = c(0, 0, 1, 0))\n",
        "plot(nytract %>% st_geometry(), col = \"grey\", pch = NA, border = \"grey9\", \n",
        "     main = \"BLM Protest Locations Night\")\n",
        "plot(blm_pts_night %>% st_geometry(), col = \"blue\", pch = 16, add = TRUE)"
      ],
      "metadata": {
        "id": "f3nbMKiSYD88"
      },
      "execution_count": null,
      "outputs": []
    },
    {
      "cell_type": "markdown",
      "source": [
        "Plotting long term mean of Nighttime lights for NYC."
      ],
      "metadata": {
        "id": "3GlPVEHhYHzD"
      }
    },
    {
      "cell_type": "code",
      "source": [
        "# Upload raster stack of nighttime lights\n",
        "s <- stack(\"//Users//liamtobin//downloads//floodlightblmdata//bm_nyc_cen.grd\")\n",
        "\n",
        "# Calculate the long term mean of nighttime lights.\n",
        "mean_s <- mean(s, na.rm = TRUE)\n",
        "\n",
        "# Convert raster to dataframe for plotting\n",
        "mean_s_df <- as.data.frame(rasterToPoints(mean_s))\n",
        "colnames(mean_s_df) <- c('x', 'y', 'value')\n",
        "\n",
        "par(mar = c(0, 0, 1, 0))\n",
        "plot(nytract %>% st_geometry(), col = \"grey\", pch = NA, border = \"grey9\", \n",
        "     main = \"BLM Protest Locations\")\n",
        "plot(blm_pts %>% st_geometry(), col = \"blue\", pch = 16, add = TRUE)\n",
        "\n",
        "# Plot long term mean of nighttime lights for NYC\n",
        "ggplot() + \n",
        "  geom_raster(aes(x = x, y = y, fill = value), data = mean_s_df) +\n",
        "  geom_sf(data = nytract, fill = NA, col = alpha(\"white\", 0.2)) +\n",
        "  ggtitle(\"Nighttime Lights mean radiance 2012 - 2022\") +\n",
        "  scale_fill_gradient(low = 'black', high = 'yellow') +\n",
        "  xlab('') + ylab('') +\n",
        "  coord_sf(expand = 0) +\n",
        "  theme_minimal() +\n",
        "  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())"
      ],
      "metadata": {
        "id": "LDb-dtdCYKOk"
      },
      "execution_count": null,
      "outputs": []
    },
    {
      "cell_type": "markdown",
      "source": [
        "Plotting long term mean of Nighttime lights with BLM Protest Points on top."
      ],
      "metadata": {
        "id": "aNEQkXF7YLwK"
      }
    },
    {
      "cell_type": "code",
      "source": [
        "# Upload raster stack of nighttime lights\n",
        "s <- stack(\"//Users//liamtobin//downloads//floodlightblmdata//bm_nyc_cen.grd\")\n",
        "\n",
        "# Calculate the long term mean of nighttime lights.\n",
        "mean_s <- mean(s, na.rm = TRUE)\n",
        "\n",
        "# Convert raster to dataframe for plotting\n",
        "mean_s_df <- as.data.frame(rasterToPoints(mean_s))\n",
        "colnames(mean_s_df) <- c('x', 'y', 'value')\n",
        "\n",
        "# Plot long term mean of nighttime lights for NYC with BLM Night Protest Points.\n",
        "ggplot() + \n",
        "  geom_raster(aes(x = x, y = y, fill = value), data = mean_s_df) +\n",
        "  geom_sf(data = nytract, fill = NA, col = alpha(\"white\", 0.2)) +\n",
        "  geom_sf(data = blm_pts_night, fill = NA, col = \"deeppink\") + \n",
        "  ggtitle(\"Mean Radiance 2012 - 2022 with BLM Protest Points\") +\n",
        "  ggsave(\"BLM_Points_Mean_Radiance.png\")\n",
        "  scale_fill_gradient(low = 'black', high = 'yellow',\n",
        "                      guide = guide_colorbar(title = \"\", \n",
        "                                             ticks = FALSE)) +\n",
        "  xlab('') + ylab('') +\n",
        "  coord_sf(expand = 0) +\n",
        "  theme_minimal() +\n",
        "  theme(panel.grid.major = element_blank(), \n",
        "        panel.grid.minor = element_blank(),\n",
        "        axis.text.y = element_blank(),\n",
        "        axis.text.x = element_blank(),\n",
        "        axis.ticks = element_blank()) +\n",
        "  ggsave(\"C:/GEOG246_R/floodlightblm/vignettes/graphics/blm_points_mean_radiance.png\")"
      ],
      "metadata": {
        "id": "XF26_pWOYNHw"
      },
      "execution_count": null,
      "outputs": []
    },
    {
      "cell_type": "code",
      "source": [
        "knitr::include_graphics(\"graphics\\\\BLM_Points_Mean_Radiance.png\")"
      ],
      "metadata": {
        "id": "rMJ51eMAYP1s"
      },
      "execution_count": null,
      "outputs": []
    },
    {
      "cell_type": "markdown",
      "source": [
        "Mean 3 day period - comparing it over multiple years. BLM Nighttime Protest Points Overlay \n",
        "Doing the same method for the BLM Protests that occurred at night. looking at a 3 month window, look only at the single pixel in which each protest happened, plot those values and highlight the night of the protest in red.\n",
        "\n",
        "Using NASA black marble to evaluate mean nighttime lights and dates."
      ],
      "metadata": {
        "id": "VhQdwD70YSPL"
      }
    },
    {
      "cell_type": "code",
      "source": [
        "# Names of each layer aka dates in format Xyyyyjjj\n",
        " names_s <- names(s)\n",
        "# taking out the X in the dates\n",
        "dates_yj <- as.data.frame(names_s) %>%  lapply(., function(x) {\n",
        "  gsub(\"X\", \"\", x)})\n",
        "# converting from yyyyjjj to date data format\n",
        "dates <- lapply(dates_yj, function(x) {\n",
        "  as.Date(x, format = \"%Y%j\")\n",
        "})\n",
        "# assigning data names to raster stack layers in z Value\n",
        "\n",
        "p <- as.data.frame(dates)\n",
        "s2 <- setZ(s, p[,1], \"date\")\n",
        "dates <- getZ(s2)\n",
        "class(getZ(s2)) \n",
        "print(s2)\n",
        "\n",
        "# additional code\n",
        "before_inst_sub <- subset(s2, which(getZ(s2) <= '2015-07-01' & (getZ(s2) >= '2014-07-01')))"
      ],
      "metadata": {
        "id": "5GtfWiWiYUtQ"
      },
      "execution_count": null,
      "outputs": []
    },
    {
      "cell_type": "markdown",
      "source": [
        "Plotting Nighttime BLM Protest Points on NYC GRID. "
      ],
      "metadata": {
        "id": "spE5XN7hYWWn"
      }
    },
    {
      "cell_type": "code",
      "source": [
        "# Read protest points for BLM protests\n",
        "blm_csv_night <- read.csv(\"//Users//liamtobin//downloads//BLM Protest Points Night - Sheet1.csv\")\n",
        "\n",
        "# Convert protest points csv to sf\n",
        "blm_pts_night <- st_as_sf(blm_csv_night, coords = c(\"Long\", \"Lat\"))\n",
        "\n",
        "# Add crs to protest points\n",
        "st_crs(blm_pts_night) <- st_crs(nycha)\n",
        "\n",
        "# Visualize protest points\n",
        "par(mar = c(0, 0, 1, 0))\n",
        "plot(nytract %>% st_geometry(), col = \"grey\", pch = NA, border = \"grey9\", \n",
        "     main = \"BLM Protest Locations Night\")\n",
        "plot(blm_pts_night %>% st_geometry(), col = \"blue\", pch = 16, add = TRUE)\n",
        "\n",
        "mean_blm <- mean(s, na.rm = TRUE)\n",
        "\n",
        "mean_blm_night <- as.data.frame(rasterToPoints(mean_blm))\n",
        "colnames(mean_blm_night) <- c('x', 'y', 'value')\n",
        "\n",
        "mean_blm_night"
      ],
      "metadata": {
        "id": "5iYcv95JYXSJ"
      },
      "execution_count": null,
      "outputs": []
    },
    {
      "cell_type": "markdown",
      "source": [
        "Polo Ground Code / BLM Protest Point Work Space\n",
        "\n",
        "Figuring out means for BLM Protest Areas using Polo Ground and NASA Black Marble data."
      ],
      "metadata": {
        "id": "wl418QCKYaYB"
      }
    },
    {
      "cell_type": "code",
      "source": [
        "#Names of each layer \n",
        " names_s <- names(s)\n",
        "\n",
        "# taking out the X in the dates\n",
        "dates_yj <- as.data.frame(names_s) %>%  lapply(., function(x) {\n",
        "  gsub(\"X\", \"\", x)})\n",
        "\n",
        "#converting from yyyyjjj to date data format\n",
        "dates <- lapply(dates_yj, function(x) {\n",
        "  as.Date(x, format = \"%Y%j\")\n",
        "})\n",
        "\n",
        "#adding dates as z value to each layer\n",
        "p <- as.data.frame(dates)\n",
        "s2 <- setZ(s, p[,1], \"date\")\n",
        "dates <- getZ(s2)\n",
        "class(getZ(s2)) \n",
        "print(s2)\n",
        "\n",
        "#Query Formatting\n",
        "instal_sub <- subset(s2, \n",
        "                     which(getZ(s2) >= '2014-5-28' & (getZ(s2) <= '2021-06-01')))\n",
        "\n",
        "#Getting subsets of before and after year of known installation \n",
        "blm_2020_sub <- subset(s2, \n",
        "                       which(getZ(s2) >= '2020-5-28' & (getZ(s2) <= '2020-06-01')))\n",
        "blm_2019_sub <- subset(s2, \n",
        "                       which(getZ(s2) >= '2019-5-28' & (getZ(s2) <= '2019-06-01')))\n",
        "blm_2018_sub <- subset(s2, \n",
        "                       which(getZ(s2) >= '2018-5-28' & (getZ(s2) <= '2018-06-01')))\n",
        "blm_2017_sub <- subset(s2, \n",
        "                       which(getZ(s2) >= '2017-5-28' & (getZ(s2) <= '2017-06-01')))\n",
        "\n",
        "#Creating one year means before and after the installation of lights at Polo Grounds\n",
        "blm_2020_mean <- mean(blm_2020_sub, na.rm = TRUE)\n",
        "blm_2019_mean <- mean(blm_2019_sub, na.rm = TRUE)\n",
        "blm_2018_mean <- mean(blm_2018_sub, na.rm = TRUE)\n",
        "blm_2017_mean <- mean(blm_2017_sub, na.rm = TRUE)\n",
        "\n",
        "#Plots of before and after means \n",
        "blm_mean_s <- stack(blm_2020_mean, blm_2019_mean, blm_2019_mean, blm_2017_mean)\n",
        "names(blm_mean_s) <- c(\"May_June_2020\", \"May_June_2019\", \"May_June_2018\", \"May_June_2017\")\n",
        "blm_mean_overtime <- plot(blm_mean_s)\n",
        "dev.copy(png, \"blm_mean_overtime.png\")\n",
        "dev.off()\n",
        "\n",
        "#Anomalies of radiance, from before and after light installation\n",
        "blmdiff <- (blm_2020_mean - blm_2019_mean)\n",
        "\n",
        "#cropping the anomaly for Polo Grounds, turns out only 1 pixel\n",
        "rblm_ann <- crop(x = blmdiff, y = blm_pts_night)\n",
        "plot(rblm_ann)"
      ],
      "metadata": {
        "id": "dTi54to-YbL4"
      },
      "execution_count": null,
      "outputs": []
    },
    {
      "cell_type": "code",
      "source": [
        "knitr::include_graphics(\"graphics\\\\blm_mean_overtime.png\")"
      ],
      "metadata": {
        "id": "-lPnwy01Ydxb"
      },
      "execution_count": null,
      "outputs": []
    },
    {
      "cell_type": "markdown",
      "source": [
        "**3. Public Housing Light Analysis**"
      ],
      "metadata": {
        "id": "il2F3FFJYf4E"
      }
    },
    {
      "cell_type": "markdown",
      "source": [
        "In this part of the analysis, the 10-year mean of nighttime lights is compared for pixels that have and do not have public housing.  The goal is to select pixels at the resolution of the nighttime lights image that represent presence of public housing.  Then pixels without public housing will be sampled if they have a similar structure as represented by population and building density. A fractional coverage raster is created where the proportion of 500 m pixel area covered by public housing is established.  All area calculations in this section are made using the NAD83 / New York Long Island (ft US) projected coordinate system (EPSG:2263)."
      ],
      "metadata": {
        "id": "Yw_IxUkNYiiT"
      }
    },
    {
      "cell_type": "code",
      "source": [
        "# Define raster with extent and resolution as mean nighttime lights\n",
        "r <- mean_s\n",
        "values(r) <- 1:ncell(r)\n",
        "\n",
        "# Create raster with proportion of pixel covered by public housing\n",
        "ph_fraction <- coverage_fraction(r, st_combine(nycha))[[1]]\n",
        "\n",
        "# Export raster\n",
        "writeRaster(ph_fraction, \n",
        "            \"C://CLARK//GEOSPAAR//floodlightblm//data//ph_coverage.grd\", \n",
        "            format = \"raster\")\n",
        "\n",
        "# Assign 0 to NA then convert raster to dataframe for plotting\n",
        "ph_fraction[ph_fraction == 0] <- NA\n",
        "ph_frac_df <- as.data.frame(rasterToPoints(ph_fraction))\n",
        "colnames(ph_frac_df) <- c('x', 'y', 'value')\n",
        "\n",
        "# Plot fractional coverage image of public housing tracts\n",
        "ggplot() + \n",
        "  geom_sf(data = nytract, col = \"lightgrey\", fill = NA) +\n",
        "  geom_raster(aes(x = x, y = y, fill = value), data = ph_frac_df) +\n",
        "  ggtitle(\"Proportion of pixel area with public housing\") +\n",
        "  scale_fill_viridis_b(breaks = seq(0, 0.8, 0.1), \n",
        "                     guide = guide_colorbar(title = \"\", \n",
        "                                            ticks = FALSE)) +\n",
        "  xlab('') + ylab('') +\n",
        "  coord_sf() +\n",
        "  theme_bw() +\n",
        "  theme(panel.grid.major = element_blank(), \n",
        "        panel.grid.minor = element_blank(),\n",
        "        axis.text.y = element_blank(),\n",
        "        axis.text.x = element_blank(),\n",
        "        axis.ticks = element_blank(),\n",
        "        legend.position = c(0.1, 0.85)) +\n",
        "  ggsave(\"C:/CLARK/GEOSPAAR/floodlightblm/graphics/ph_plot.png\")\n"
      ],
      "metadata": {
        "id": "fJzBgWvVYkX_"
      },
      "execution_count": null,
      "outputs": []
    },
    {
      "cell_type": "code",
      "source": [
        "knitr::include_graphics(\"graphics\\\\ph_plot.png\")"
      ],
      "metadata": {
        "id": "0Dtl3Ls4Ynub"
      },
      "execution_count": null,
      "outputs": []
    },
    {
      "cell_type": "markdown",
      "source": [
        "**4. Create gridded population from census tracts**"
      ],
      "metadata": {
        "id": "ObrkgJ56YsXH"
      }
    },
    {
      "cell_type": "markdown",
      "source": [
        "The next step is to create an areal interpolated population grid.  We want to know the approximate population within each 500 m night time lights grid cell.  This is done by intersecting census tracts with the 500 m resolution grid.  The area of census tracts segments is calculated, then divided by the original tract size to find the area proportion of the segment.  Then the population for the tract is multiplied by the area proportion of the segments to find the approximate population in each tract segment.  Lastly, the tract segment populations are summed within each 500 m grid cell."
      ],
      "metadata": {
        "id": "9I7TIWudYxPk"
      }
    },
    {
      "cell_type": "code",
      "source": [
        "## Create areal interpolated population grid\n",
        "\n",
        "# Add area to census tracts then join population data\n",
        "nytract_pop <- nytract %>% \n",
        "  mutate(area = as.numeric(st_area(.) / 10^6)) %>% \n",
        "  mutate(BoroCT2020 = as.numeric(BoroCT2020)) %>% \n",
        "  inner_join(., ny_pop, by = \"BoroCT2020\")\n",
        "\n",
        "# Convert empty raster to polygons\n",
        "grid_p <- rasterToPolygons(x = r, dissolve = FALSE) %>% st_as_sf()\n",
        "\n",
        "# Intersect tracts with polygon grid and calculate area of segments\n",
        "# then calculate population within each 'cutup' census tract piece\n",
        "tracts_cut <- st_intersection(x = nytract_pop, y = grid_p) %>% \n",
        "  mutate(area_seg = as.numeric(st_area(.) / 10^6)) %>% \n",
        "  mutate(pop_seg = area_seg / area * Pop_20)\n",
        "\n",
        "# Calculate sum of population of tract segments within each cell\n",
        "# The 'layer' column indicates which cell index the tract segment belongs to\n",
        "r_pop_vals <- tracts_cut %>% group_by(layer) %>% \n",
        "  summarise(., pop = sum(pop_seg, na.rm = TRUE))\n",
        "\n",
        "# Find cell index for NA values\n",
        "not_in_df <- data.frame(subset(1:ncell(r), !(1:ncell(r) %in% r_pop_vals$layer)), NA)\n",
        "names(not_in_df) <- c(\"layer\", \"pop\")\n",
        "\n",
        "# Combine values for cells with and without population \n",
        "r_pop_vals_full <- rbind(not_in_df, r_pop_vals %>% \n",
        "                           as.data.frame() %>% \n",
        "                           select(., c(\"layer\", \"pop\"))) %>% \n",
        "  mutate(., layer = as.numeric(layer)) %>% arrange(., layer)\n",
        "\n",
        "# Create gridded population raster by setting the population column to the empty raster\n",
        "r_pop <- setValues(r, values = r_pop_vals_full$pop)\n",
        "\n",
        "# Convert population to integer\n",
        "r_pop[] <- as.integer(r_pop[])\n",
        "\n",
        "# Export 2020 gridded population\n",
        "writeRaster(r_pop, \n",
        "            \"C://CLARK//GEOSPAAR//floodlightblm//data//pop2020_grid.grd\", \n",
        "            format = \"raster\")\n",
        "\n",
        "# Tract Population map -- This is the true population\n",
        "ggplot() +\n",
        "  geom_sf(data = nytract_pop, aes(fill = Pop_20), col = NA) +\n",
        "  ggtitle(\"Population by Census Tract\") +\n",
        "  scale_fill_gradient(low = 'lightsteelblue2', high = 'darkblue', \n",
        "                      guide = guide_colorbar(ticks = FALSE), \n",
        "                      limits = c(0, cellStats(r_pop, max)),\n",
        "                      oob = scales::squish) +\n",
        "  xlab('') + ylab('') + \n",
        "  labs(caption = paste(\"True Total Population = \",\n",
        "                       as.character(sum(nytract_pop$Pop_20)))) +\n",
        "  theme_bw() +\n",
        "  theme(panel.grid.major = element_blank(), \n",
        "        panel.grid.minor = element_blank(),\n",
        "        axis.text.y = element_blank(),\n",
        "        axis.text.x = element_blank(),\n",
        "        axis.ticks = element_blank(),\n",
        "        legend.title = element_blank(),\n",
        "        legend.position = c(0.1, 0.85)) +\n",
        "  ggsave(\"C:/CLARK/GEOSPAAR/floodlightblm/graphics/pop_plot1.png\")\n",
        "  \n",
        "# Convert raster to dataframe for plotting\n",
        "r_pop_df <- as.data.frame(rasterToPoints(r_pop))\n",
        "colnames(r_pop_df) <- c('x', 'y', 'value')\n",
        "\n",
        "# Interpolated Population map -- This is the output\n",
        "ggplot() + \n",
        "  geom_raster(aes(x = x, y = y, fill = value), data = r_pop_df) +\n",
        "  ggtitle(\"Population Grid from areal interpolation\") +\n",
        "  scale_fill_gradient(low = 'lightsteelblue2', high = 'darkblue', \n",
        "                      guide = guide_colorbar(ticks = FALSE),\n",
        "                      limits = c(0, cellStats(r_pop, max))) +\n",
        "  labs(caption = paste(\"Interpolated Population = \", \n",
        "                       as.character(cellStats(x = r_pop, stat = \"sum\")))) +\n",
        "  xlab('') + ylab('') +\n",
        "  coord_sf() +\n",
        "  theme_bw() +\n",
        "  theme(panel.grid.major = element_blank(), \n",
        "        panel.grid.minor = element_blank(),\n",
        "        axis.text.y = element_blank(),\n",
        "        axis.text.x = element_blank(),\n",
        "        axis.ticks = element_blank(),\n",
        "        legend.title = element_blank(),\n",
        "        legend.position = c(0.1, 0.85)) +\n",
        "  ggsave(\"C:/CLARK/GEOSPAAR/floodlightblm/graphics/pop_plot2.png\")"
      ],
      "metadata": {
        "id": "wcISfL4AYzE6"
      },
      "execution_count": null,
      "outputs": []
    },
    {
      "cell_type": "markdown",
      "source": [
        "The maps below compare the true 2020 census tract population to the interpolated population grid."
      ],
      "metadata": {
        "id": "JFw1OAI6Y2au"
      }
    },
    {
      "cell_type": "code",
      "source": [
        "knitr::include_graphics(c(\"graphics\\\\pop_plot1.png\", \"graphics\\\\pop_plot2.png\"))"
      ],
      "metadata": {
        "id": "zAVs0Z6MY4j7"
      },
      "execution_count": null,
      "outputs": []
    },
    {
      "cell_type": "markdown",
      "source": [
        "**4. Create gridded building volume from NYC buildings**"
      ],
      "metadata": {
        "id": "IjD3aeUeZuky"
      }
    },
    {
      "cell_type": "markdown",
      "source": [
        "The same process for creating a gridded population raster is used for creating a building volume grid.  First the volume of each building is determined by converting the building height attribute (height_roof) to meters.  Then, the area of each building (m^2) is determined and multiplied by building height to find the building volume.  An intersection is performed to find the building segments in each 500 m grid cell then the area of each building segment is calculated.  The area proportion of each building segment to the full building area is determined then multiplied by the full building volume.  The building volume of segments is summed within each grid cell to find the approximate total building volume within each night time lights pixel."
      ],
      "metadata": {
        "id": "zxLp-Hu1ZzHo"
      }
    },
    {
      "cell_type": "code",
      "source": [
        "## Create building volume grid\n",
        "\n",
        "# Filter buildings that are fully constructed (feat_code 2100), \n",
        "buildings_c <- buildings %>% filter(., feat_code == 2100)\n",
        "\n",
        "# Convert building height to meters, calculate area, then calculate volume\n",
        "buildings_vol <- buildings_c %>% mutate(heightroof = heightroof / 3.281) %>% \n",
        "  mutate(area = as.numeric(units::set_units(st_area(.), m^2))) %>% \n",
        "  mutate(volume = area * heightroof)\n",
        "\n",
        "# Intersect buildings with polygon grid and calculate area of segments\n",
        "# then find proportional volume\n",
        "build_cut <- st_intersection(x = buildings_vol, y = grid_p) %>% \n",
        "  mutate(area_seg = as.numeric(units::set_units(st_area(.), m^2))) %>% \n",
        "  mutate(volume_seg = area_seg / area * volume)\n",
        "\n",
        "# Convert to dataframe selecting cell value (layer) and volume of segment\n",
        "build_cut_df <- build_cut %>% as.data.frame(.) %>% select(., c('layer', 'volume_seg'))\n",
        "\n",
        "# Find total building volume in each cell\n",
        "r_bvol_vals <- build_cut_df %>% group_by(layer) %>% \n",
        "  summarise(., vol = sum(volume_seg, na.rm = TRUE))\n",
        "\n",
        "# Find cell index for NA values\n",
        "not_in_df <- data.frame(subset(1:ncell(r), \n",
        "                               !(1:ncell(r) %in% r_bvol_vals$layer)), NA)\n",
        "names(not_in_df) <- c(\"layer\", \"vol\")\n",
        "\n",
        "# Combine values for cells with and without buildings \n",
        "r_vol_vals_full <- rbind(not_in_df, r_bvol_vals) %>% \n",
        "  mutate(., layer = as.numeric(layer)) %>% arrange(., layer)\n",
        "\n",
        "# Create gridded building volume raster\n",
        "r_bvol <- setValues(r, values = r_vol_vals_full$vol)\n",
        "r_bvol[r_bvol == 0] <- NA\n",
        "\n",
        "# Export building volume raster\n",
        "writeRaster(r_bvol, \n",
        "            \"C://CLARK//GEOSPAAR//floodlightblm//data//buildvol_grid.grd\", \n",
        "            format = \"raster\")\n",
        "\n",
        "# Convert raster to dataframe for plotting, convert from cubic meters to cubic hectometers\n",
        "r_bvol_df <- as.data.frame(rasterToPoints(r_bvol / 1000000))\n",
        "colnames(r_bvol_df) <- c('x', 'y', 'value')\n",
        "\n",
        "# Get 7 class breaks for visualization\n",
        "breaks_qt <- classIntervals(\n",
        "  c(min(r_bvol_df$value) - min(r_bvol_df$value), r_bvol_df$value), \n",
        "                            n = 7, style = \"fisher\")\n",
        "\n",
        "# Add class breaks as column in the building volume dataframe\n",
        "r_bvol_df <- mutate(r_bvol_df, value_qt = cut(value, breaks_qt$brks)) \n",
        "\n",
        "# Interpolated building volume map\n",
        "ggplot() + \n",
        "  geom_raster(aes(x = x, y = y, fill = value_qt), data = r_bvol_df) +\n",
        "  ggtitle(\"Building Volume Grid from areal interpolation\") +\n",
        "  scale_fill_brewer(palette = \"OrRd\")  +\n",
        "  xlab('') + ylab('') + labs(fill = expression(hm^3)) +\n",
        "  coord_sf() +\n",
        "  theme_bw() +\n",
        "  labs(caption = \"0.75 hm^3 would be a pixel 100% covered with 1 story houses\") +\n",
        "  theme(panel.grid.major = element_blank(), \n",
        "        panel.grid.minor = element_blank(),\n",
        "        axis.text.y = element_blank(),\n",
        "        axis.text.x = element_blank(),\n",
        "        axis.ticks = element_blank(),\n",
        "        legend.position = c(0.15, 0.75)) +\n",
        "  ggsave(\"C:/CLARK/GEOSPAAR/floodlightblm/graphics/bvol_plot.png\")"
      ],
      "metadata": {
        "id": "CbrECalLZ0tw"
      },
      "execution_count": null,
      "outputs": []
    },
    {
      "cell_type": "markdown",
      "source": [
        "The map below shows the areal interpolated volume of buildings in each 500 m cell."
      ],
      "metadata": {
        "id": "2wcuMbGFZ3iv"
      }
    },
    {
      "cell_type": "code",
      "source": [
        "knitr::include_graphics(\"graphics\\\\bvol_plot.png\")"
      ],
      "metadata": {
        "id": "4oHNdnhkZ400"
      },
      "execution_count": null,
      "outputs": []
    },
    {
      "cell_type": "markdown",
      "source": [
        "**5. Sample pixels with and without public housing**"
      ],
      "metadata": {
        "id": "YVvloJ4hZ6f8"
      }
    },
    {
      "cell_type": "markdown",
      "source": [
        "The 10-year mean nighttime lights for pixels with public housing (PH) coverage is compared to those without public housing (NoPH). First, PH pixels are filtered so there is a minimum of 10% public housing area coverage. There are 179 pixels with at least 10% coverage. Next, the population and building volume for these pixels are extracted.  Then the quartile breaks for population and building volume in PH pixels is determined. A cross-tabulation table is created to find the frequency of PH pixels in these breaks. This frequency is used to perform a stratified sample on NoPH pixels. NoPH pixels are randomly sampled to meet the population and building volume conditions and frequencies so 179 NoPH pixels are selected. Radiance, building volume, and population are extracted for sampled NoPH pixels."
      ],
      "metadata": {
        "id": "F_VbcS4mZ9hm"
      }
    },
    {
      "cell_type": "code",
      "source": [
        "# Upload Public Housing Fractional coverage raster\n",
        "ph_r <- raster(\"C://CLARK//GEOSPAAR//floodlightblm//data//ph_coverage.grd\")\n",
        "\n",
        "# Upload gridded population\n",
        "pop_r <- raster(\"C://CLARK//GEOSPAAR//floodlightblm//data//pop2020_grid.grd\")\n",
        "\n",
        "# Upload gridded building volume, convert to cubic hectometers\n",
        "bvol_r <- \n",
        "  raster(\"C://CLARK//GEOSPAAR//floodlightblm//data//buildvol_grid.grd\") / 1000000\n",
        "\n",
        "# Find PH pixels with at least 10% coverage of tracts with public housing\n",
        "ph_full_r <- ph_r > 0.1\n",
        "ph_full_r[ph_full_r == 0] <- NA\n",
        "\n",
        "# Mask gridded population with PH pixels\n",
        "pop_ph <- pop_r * ph_full_r\n",
        "\n",
        "# Quartile class breaks for population for PH pixels\n",
        "pop_breaks_qt <- classIntervals(c(cellStats(pop_ph, min) - 1, getValues(pop_ph)), \n",
        "                            n = 4, style = \"quantile\")\n",
        "\n",
        "# Mask gridded building volume\n",
        "bvol_ph <- bvol_r * ph_full_r\n",
        "\n",
        "# Quartile breaks for building volume with PH pixels\n",
        "bv_breaks_qt <- classIntervals(\n",
        "  c(cellStats(bvol_ph, min) - cellStats(bvol_ph, min), getValues(bvol_ph)), \n",
        "                            n = 4, style = \"quantile\")\n",
        "\n",
        "# Convert PH pixels greater then 10% coverage to points\n",
        "ph_p <- rasterToPoints(ph_full_r) %>% as.data.frame() %>% \n",
        "  st_as_sf(., coords = c(\"x\", \"y\"))\n",
        "\n",
        "# Create column that specifies that pixels contain public housing\n",
        "# Extract radiance, population, and building volume\n",
        "# Create columns with population and building volume class breaks\n",
        "extract_ph_p <- ph_p %>% mutate(., sample = \"PH\") %>%\n",
        "  mutate(., radiance = raster::extract(mean_s, .)) %>% \n",
        "  mutate(., population = raster::extract(pop_r, .)) %>% \n",
        "  mutate(., building_volume = raster::extract(bvol_r, .)) %>% \n",
        "  mutate(., pop_class = cut(population, pop_breaks_qt$brks, dig.lab = 4)) %>% \n",
        "  mutate(., bvol_class = cut(building_volume, bv_breaks_qt$brks, dig.lab = 2))\n",
        "\n",
        "# Create a frequency cross tabulation of pixels within population and building \n",
        "# volume quartiles.\n",
        "t <- table(pop = extract_ph_p$pop_class, bvol = extract_ph_p$bvol_class)\n",
        "\n",
        "# Reformat frequency cross tabulation to a dataframe in order to for query\n",
        "# and stratified sampling of No PH pixels\n",
        "t2 <- as.data.frame(t) %>% \n",
        "  separate(., col = pop, into = c(\"pop_l\", \"pop_u\"), sep = \",\") %>% \n",
        "  separate(., col = bvol, into = c(\"bvol_l\", \"bvol_u\"), sep = \",\") %>% \n",
        "  mutate(., pop_l = as.numeric(gsub(\"\\\\(\", \"\", pop_l))) %>% \n",
        "  mutate(., pop_u = as.numeric(gsub(\"\\\\]\", \"\", pop_u))) %>%\n",
        "  mutate(., bvol_l = as.numeric(gsub(\"\\\\(\", \"\", bvol_l))) %>% \n",
        "  mutate(., bvol_u = as.numeric(gsub(\"\\\\]\", \"\", bvol_u))) %>% \n",
        "  filter(., Freq > 0)\n",
        "\n",
        "# Find pixels with at 0% coverage with public housing\n",
        "no_ph_r <- ph_r == 0\n",
        "\n",
        "# This lapply masks the NYC extent based on the population class and building volume\n",
        "# class criteria.  The number of pixels randomly sampled from the No PH raster is the \n",
        "# same number in the frequency cross tabulation.  This is done to ensure that the sampled\n",
        "# No PH pixels represent the same population and building volume conditions as the PH pixels.\n",
        "set.seed(19)\n",
        "no_ph <- lapply(1:nrow(t2), function(i) { \n",
        "  x <- t2[i, ]\n",
        "  pop_mask <- pop_r > x$pop_l & pop_r <= x$pop_u\n",
        "  bvol_mask <- bvol_r > x$bvol_l & bvol_r <= x$bvol_u\n",
        "  no_ph_r_masked <- no_ph_r * pop_mask * bvol_mask\n",
        "  no_ph_r_masked[no_ph_r_masked == 0] <- NA\n",
        "  no_ph_smp <- sampleRandom(x = no_ph_r_masked, size = x$Freq, cells = TRUE)\n",
        "  return(no_ph_smp[, 1])}) %>% unlist()\n",
        "\n",
        "# Bind cell index with a column 'layer' set to 1, indicating sampled\n",
        "no_ph_df <- cbind(cell = no_ph, layer = rep(1, length(no_ph)))\n",
        "\n",
        "# Find cell index for non sampled pixels and set 'layer' to NA\n",
        "not_in_df <- data.frame(subset(1:ncell(r), !(1:ncell(r) %in% no_ph)), NA)\n",
        "names(not_in_df) <- c(\"cell\", \"layer\")\n",
        "\n",
        "# Combine values for non-sample and samples\n",
        "r_smp_df <- rbind(not_in_df, no_ph_df) %>% arrange(., cell)\n",
        "\n",
        "# Create a raster where No PH sampled pixels are 1, and non sampled pixels are NA\n",
        "r_smp <- setValues(r, values = r_smp_df$layer)\n",
        "\n",
        "# Convert No PH sample raster to points\n",
        "smp_p <- rasterToPoints(r_smp) %>% as.data.frame() %>% \n",
        "  st_as_sf(., coords = c(\"x\", \"y\"), crs = crs(mean_s))\n",
        "\n",
        "# Create column that specifies that pixels do not contain public housing\n",
        "# Extract radiance, population, and building volume\n",
        "# Create columns with population and building volume class breaks\n",
        "extract_noph_p <- smp_p %>% mutate(., sample = \"No PH\") %>% \n",
        "  mutate(., radiance = raster::extract(mean_s, .)) %>% \n",
        "  mutate(., population = raster::extract(pop_r, .)) %>% \n",
        "  mutate(., building_volume = raster::extract(bvol_r, .)) %>% \n",
        "  mutate(., pop_class = cut(population, pop_breaks_qt$brks, dig.lab = 4)) %>% \n",
        "  mutate(., bvol_class = cut(building_volume, bv_breaks_qt$brks, dig.lab = 2))\n",
        "\n",
        "# Combine ph and no ph samples\n",
        "combined <- rbind(as.data.frame(extract_noph_p), \n",
        "                  as.data.frame(extract_ph_p))\n",
        "\n",
        "# Display map of PH and No PH samples \n",
        "ggplot() + \n",
        "  geom_sf(data = nytract, col = \"lightgrey\", fill = NA) +\n",
        "  geom_sf(data = combined %>% st_as_sf(), aes(fill = sample, col = sample)) +\n",
        "  ggtitle(\"Locations of Samples\") +\n",
        "  scale_color_manual(values = c(\"red\", \"blue\")) +\n",
        "  xlab('') + ylab('') +\n",
        "  theme_bw() +\n",
        "  theme(panel.grid.major = element_blank(), \n",
        "        panel.grid.minor = element_blank(),\n",
        "        axis.text.y = element_blank(),\n",
        "        axis.text.x = element_blank(),\n",
        "        axis.ticks = element_blank(),\n",
        "        legend.position = c(0.1, 0.9),\n",
        "        legend.title= element_blank()) + \n",
        "  ggsave(\"C:/CLARK/GEOSPAAR/floodlightblm/graphics/samples_map0.png\", \n",
        "         width = 6, height = 6)"
      ],
      "metadata": {
        "id": "uVe7o5kqZ_TX"
      },
      "execution_count": null,
      "outputs": []
    },
    {
      "cell_type": "markdown",
      "source": [
        "Below shows the locations of pixels with at least 10% area coverage of public housing and sampled pixels without public houses with the same building and population structure.\n"
      ],
      "metadata": {
        "id": "8RMAuAylaDvn"
      }
    },
    {
      "cell_type": "code",
      "source": [
        "knitr::include_graphics(\"graphics\\\\samples_map.png\")"
      ],
      "metadata": {
        "id": "In0hz9VnaFFe"
      },
      "execution_count": null,
      "outputs": []
    },
    {
      "cell_type": "markdown",
      "source": [
        "# **Results**"
      ],
      "metadata": {
        "id": "juHA7aGvaGvt"
      }
    },
    {
      "cell_type": "markdown",
      "source": [
        "When analyzing the results of our project it is crucial to understand our emphasis on spatial visualization. Our figures consist of BLM nighttime protest locations with a mean floodlight analysis before and after. Moreover, the distribution of long term means nighttime lights of NYC, and the same nighttime floodlight analysis but with the Polo Ground Towers. To truly understand these visuals, we had to implement an appropriate scale bar, title, legend, and filter upon each individual map. With the restrictions of our data, the Polo Ground Towers analysis only contained one pixel. Although limiting, we were able to construct an accurate visual analysis of this pixel through both a manual time series and vectorized distribution. Coupled with this, our final public housing analysis used a variety of tools in its result. Our culminating visuals were a raster with a proportion of pixels covered by census tracts with public housing. Furthermore, the creation of a building volume grid in which an interpolated population map was added. This analysis also contained a long term mean radiance for public housing, population, and building volume. "
      ],
      "metadata": {
        "id": "xtvW_RSeaJNf"
      }
    },
    {
      "cell_type": "markdown",
      "source": [
        "**1. Polo Grouds Toweres Proof of Concept**"
      ],
      "metadata": {
        "id": "fs3_baXlaKqv"
      }
    },
    {
      "cell_type": "markdown",
      "source": [
        "Looking at the original anomaly analysis of comparing the mean radiance from the year prior to the year after the light installation at Polo Grounds, we found there to be a decrease of 190 (Watts·cm^−2·sr^−1) over the housing site. Meaning we were unable to detect any increase in radiance due to the installation of new light fixtures using the method above. Furthermore, when expanding the time frame of the analysis from 2014-2016 to 2012-2022, we still saw an overall decrease of the radiance by 36 when comparing the time period before and after the light installation. This can be visually seen in the boxplot below, keep in mind not all boxes have equal amounts of observations."
      ],
      "metadata": {
        "id": "AHrJIZEAaOp-"
      }
    },
    {
      "cell_type": "code",
      "source": [
        "#Using the same data frame of the quarterly means used in the line plot in section 1 of methods.\n",
        "ggplot(zoo_frame) + \n",
        "  geom_boxplot(aes(x = group, y = mean, fill = group)) +\n",
        "  ylab(\"Radiance\") + xlab(NULL) +\n",
        "  ggtitle(\"Comparison of radiance of before and after light instalation at Polo Grounds\") +\n",
        "  ggsave(\"C:/GEOG246_R/floodlightblm/vignettes/graphics//polo_boxplot.png\")"
      ],
      "metadata": {
        "id": "Gbts3Zo_aQAc"
      },
      "execution_count": null,
      "outputs": []
    },
    {
      "cell_type": "code",
      "source": [
        "knitr::include_graphics(\"graphics\\\\polo_boxplot.png\")"
      ],
      "metadata": {
        "id": "XTnrD3XbaR1V"
      },
      "execution_count": null,
      "outputs": []
    },
    {
      "cell_type": "markdown",
      "source": [
        "**2. BLM Protest Analysis**"
      ],
      "metadata": {
        "id": "8sGYm2EKaTxa"
      }
    },
    {
      "cell_type": "markdown",
      "source": [
        "Analyzing the locations of BLM Protest Point centroids with nighttime mean radiance data from 2012 - 2022 allows for a unique perspective of social politics within New York City. Within this visual we can see the development of nighttime hot spots over time, as well, as the lighting factors that took place before the BLM Protests."
      ],
      "metadata": {
        "id": "OWETHkImaWLq"
      }
    },
    {
      "cell_type": "code",
      "source": [
        "ggplot() + \n",
        "  geom_raster(aes(x = x, y = y, fill = value), data = mean_s_df) +\n",
        "  geom_sf(data = nytract, fill = NA, col = alpha(\"white\", 0.2)) +\n",
        "  geom_sf(data = blm_pts_night, fill = NA, col = \"deeppink\") + \n",
        "  ggtitle(\"Mean Radiance 2012 - 2022 with BLM Protest Points\") +\n",
        "  ggsave(\"BLM_Points_Mean_Radiance.png\")\n",
        "  scale_fill_gradient(low = 'black', high = 'yellow',\n",
        "                      guide = guide_colorbar(title = \"\", \n",
        "                                             ticks = FALSE)) +\n",
        "  xlab('') + ylab('') +\n",
        "  coord_sf(expand = 0) +\n",
        "  theme_minimal() +\n",
        "  theme(panel.grid.major = element_blank(), \n",
        "        panel.grid.minor = element_blank(),\n",
        "        axis.text.y = element_blank(),\n",
        "        axis.text.x = element_blank(),\n",
        "        axis.ticks = element_blank())\n",
        "  ggsave(\"C:/GEOG246_R/floodlightblm/vignettes/graphics/blm_points_mean_radiance.png\")"
      ],
      "metadata": {
        "id": "CqWB-_q5aX1t"
      },
      "execution_count": null,
      "outputs": []
    },
    {
      "cell_type": "markdown",
      "source": [
        "When analyzing the mean nighttime floodlight radiance across the 3-day window of BLM locations May into June (2017 - 2020). There is an obvious increase in mean radiance within 2020. However, there are only a few BLM Protest points that reside within these locations. Upon the conclusion of these results it is important to understand the correlation between BLM Protests and floodlight use are minimal. Although the potential of floodlight usage may increase with the presence of police officers at these protests, there are many factors at play when analyzing light radiation. "
      ],
      "metadata": {
        "id": "NTQrZfG3aZxm"
      }
    },
    {
      "cell_type": "code",
      "source": [
        "blm_mean_s <- stack(blm_2020_mean, blm_2019_mean, blm_2019_mean, blm_2017_mean)\n",
        "names(blm_mean_s) <- c(\"May_June_2020\", \"May_June_2019\", \"May_June_2018\", \"May_June_2017\")\n",
        "blm_mean_overtime <- plot(blm_mean_s)\n",
        "dev.copy(png, \"blm_mean_overtime.png\")\n",
        "dev.off()"
      ],
      "metadata": {
        "id": "kGaq7EC1aa5c"
      },
      "execution_count": null,
      "outputs": []
    },
    {
      "cell_type": "code",
      "source": [
        "knitr::include_graphics(\"graphics\\\\blm_mean_overtime.png\")"
      ],
      "metadata": {
        "id": "toyozodjacV1"
      },
      "execution_count": null,
      "outputs": []
    },
    {
      "cell_type": "markdown",
      "source": [
        "**3. Public Housing Lights Analysis**"
      ],
      "metadata": {
        "id": "Awju_zQhadu2"
      }
    },
    {
      "cell_type": "markdown",
      "source": [
        "Two boxplots were created with the 10-year mean night time lights on the y-axis and either the Population class or Building Volume class on the x-axis.  Within each class, the distribution of pixels with and without public housing developments are compared.  In each boxplot, there are 44 to 45 pixels represented in the distribution. "
      ],
      "metadata": {
        "id": "Mldfz6WpagdO"
      }
    },
    {
      "cell_type": "code",
      "source": [
        "# Create boxplot comparing mean radiance for public housing vs none within population classes\n",
        "ggplot(combined, aes(x = pop_class, y = radiance, color = sample, fill = sample)) +\n",
        "  scale_color_manual(values = c('red', 'blue')) +\n",
        "  scale_fill_manual(values = alpha(c('red', 'blue'), 0.3)) +\n",
        "  xlab(\"Population Class\") + ylab(\"10 year mean radiance\") +\n",
        "  stat_summary(geom = \"point\", fun = mean, pch = 4, \n",
        "               position = position_dodge(.75)) +\n",
        "  geom_boxplot() +\n",
        "  theme_bw() +\n",
        "  theme(panel.grid.major = element_blank(),\n",
        "        panel.grid.minor = element_blank(),\n",
        "        legend.title = element_blank()) +\n",
        "  ggsave(\"C:/CLARK/GEOSPAAR/floodlightblm/graphics/boxplot1.png\", \n",
        "         width = 9, height = 6)"
      ],
      "metadata": {
        "id": "8-a_cQeCaiJX"
      },
      "execution_count": null,
      "outputs": []
    },
    {
      "cell_type": "code",
      "source": [
        "knitr::include_graphics(\"graphics\\\\boxplot1.png\")"
      ],
      "metadata": {
        "id": "EP_8Y6Y-aj-5"
      },
      "execution_count": null,
      "outputs": []
    },
    {
      "cell_type": "markdown",
      "source": [
        "The above boxplot displaying the Population class on the x-axis shows that in both pixels with and without public housing, the 10-year mean radiance increases with population.  Both the mean (indicated by an X) and median (indicated by the line), increase when moving from lower to higher population classes.  Within each Population class, we see that both the mean and median radiance value is greater for pixels with public housing.  In the three largest Population classes, the interquartile ranges for the public housing pixels are outside and greater than the interquartile ranges of those without public housing, while there is a slight overlap in the lowest class.  In all plots, values greater than the 75th percentile in the NOPH distributions overlap the interquartile range of the PH distributions."
      ],
      "metadata": {
        "id": "B-2oS0EUamT9"
      }
    },
    {
      "cell_type": "code",
      "source": [
        "# Create boxplot comparing mean radiance for public housing vs none within building volume classes\n",
        "ggplot(combined, aes(x = bvol_class, y = radiance, color = sample, fill = sample)) +\n",
        "  scale_color_manual(values = c('red', 'blue')) +\n",
        "  scale_fill_manual(values = alpha(c('red', 'blue'), 0.3)) +\n",
        "  xlab(\"Building Volume Class\") + ylab(\"10 year mean radiance\") +\n",
        "  stat_summary(geom = \"point\", fun = mean, pch = 4, \n",
        "               position = position_dodge(.75)) +\n",
        "  geom_boxplot() +\n",
        "  theme_bw() +\n",
        "  theme(panel.grid.major = element_blank(),\n",
        "        panel.grid.minor = element_blank(),\n",
        "        legend.title = element_blank()) +\n",
        "  ggsave(\"C:/CLARK/GEOSPAAR/floodlightblm/graphics/boxplot2.png\", \n",
        "         width = 9, height = 6)"
      ],
      "metadata": {
        "id": "0ZbXeUj0aoA6"
      },
      "execution_count": null,
      "outputs": []
    },
    {
      "cell_type": "code",
      "source": [
        "knitr::include_graphics(\"graphics\\\\boxplot2.png\")"
      ],
      "metadata": {
        "id": "_nCg0a3Fap5W"
      },
      "execution_count": null,
      "outputs": []
    },
    {
      "cell_type": "markdown",
      "source": [
        "In the above boxplot displaying the Building Volume class on the x-axis, similar trends are found.  Both the mean and median values, increase when moving from lower to higher Building Volume classes.  Within each Building Volume class, both the mean and median radiance value is greater for pixels with public housing.  In the three largest Population classes, the interquartile ranges for the public housing pixels are outside and greater than the interquartile ranges of those without public housing, while there is a slight overlap in the lowest class.  In all plots, values greater than the 75th percentile in the NoPH distributions overlap the interquartile range of the PH distributions."
      ],
      "metadata": {
        "id": "oVObymCJaqqI"
      }
    },
    {
      "cell_type": "markdown",
      "source": [
        "# **Discussion**"
      ],
      "metadata": {
        "id": "Wb7wlx6FaseT"
      }
    },
    {
      "cell_type": "markdown",
      "source": [
        "There could be a multitude of reasons why we didn't detect the light installation at Polo Grounds in Part 1. First of all, we made many assumptions and worked with little information. For example, the article we used does not specify when the lights were installed, leading to the installation date to be between when they said it started in August 2015 and the publication date of the article, March 10th ~ 7 months. Secondly, we don't know what kinds of lights were installed nor where. Ideally, we would have floodlights at a known location for a known duration for the best proof of concept. \n",
        "\n",
        "During the analysis for part 1, we noticed a yearly pattern of large increases in nighttime radiance values during February every year, with the signal in some years much stronger than in others. It is unclear what this may be caused by, thoughts have included snow cover which is our leading thought, while other explanations have included satellite viewing angles which can alter what kinds of light sources the satellite can see, but getting that exact information would be extremely difficult. Additionally, no large festivals are seemly occurring at that time, and the pattern persists with the surrounding 9x9 pixels, leading us to think that this phenomenon should be investigated further. \n",
        "\n",
        "As seen in Part 3, there is a clear trend that areas with public housing have higher 10-year mean night time lights values than those without. Additionally, there appears to be a trend that increased Population and Building Volume contributes to increased night time lights.  By using a stratified sample to select pixels without public housing that have a similar population and building volume structure, we can see claim that there is a correlation with more confidence.  However, because the population and building class ranges are somewhat broad, we cannot precisely sample No PH pixels with the exact same structure. If this was done, the sample size would have been much smaller and the results may have been differed. \n",
        "\n",
        "Pixels that were used to define presence of public housing were those where the area proportion of the pixel covered by public housing was at least 10%. 10% coverage is equal to at least 25,000 m^2 of public housing building area within the pixel. We did not have data on the number of residents in these buildings so rather simply substantial presence of public housing was used.  Because of the coarse spatial resolution of this product, features besides public housing development could lead to the differences seen.\n",
        "\n",
        "The cause of this difference in nighttime lights with and without public housing may not be due to installation of floodlights as the Polo Grounds proof of concept did not detect the installation of over 300 new streetlamps.  This difference may be due to public housing developments being constructed near industry or expressways. Pixels classified as having public housing could also contain these features that emit high amounts of light. Another reason may be that pixels with public housing developments may have lower tree cover than areas with similar population and building density.  Tree cover would mask light emitted from street lamps and shorter buildings."
      ],
      "metadata": {
        "id": "ALGK-xuYavDz"
      }
    },
    {
      "cell_type": "markdown",
      "source": [
        "# **Conclusion**"
      ],
      "metadata": {
        "id": "IppTmlFkaxpM"
      }
    },
    {
      "cell_type": "markdown",
      "source": [
        "The NASA Black Marble night time lights product may not be effective in detecting fine-scale spatial and temporal scale differences between images due to its coarse resolution, sensitivity to sensor angle, and patchy coverage due to cloud cover.  By temporally aggregating to a broader resolution, the sensor angle and coverage issues can be solved; however, we found that detecting floodlight installations finer than the 500 m resolution may not be possible.  Other features contained in the pixel of interest may be saturating or blocking the radiance values.  This product appears to be useful when looking at broader geographic trends, like comparing the 10-year mean radiance of different areas.  We found that nighttime lights for pixels containing public housing tend to be greater than pixels without public housing when controlling for Population and Building Volume within the pixel.  Although this trend may not be due to installation of police surveillance floodlights, it may show a difference in light pollution caused the infrastructure, industry, and lack of tree cover adjacent to public housing developments.\n",
        "\n",
        "When looking at these results as a whole there is much to be improved upon in terms of future research. As previously mentioned, our choice of New York City was based upon a limitation of floodlight data due to cloud coverage and seasonal gaps in data observation. To further build upon the study of BLM protests, public housing trends, and growth in floodlight use surrounding housing blocks we must expand across the United States. In collecting data from multiple cities across the U.S or even the world one can begin to understand the influence of increased floodlights and new age policing in a nuanced way. Through just focusing on New York City, we were getting a very small handful of policing and crime data. Coupled with this, the Polo Ground Towers, although the only site with an accurate timeline, could be built upon with locations that contain more pixels. Overall, we were not expecting this many difficulties in terms of data collection in the project. The overall VIIRS floodlight location data was only accessible through NASA’s black marble database, and the BLM data was nearly nonexistent - or was entered without credible sources.  In future projects we would also like to create higher resolution images, as well as find a concrete proof of concept."
      ],
      "metadata": {
        "id": "VQGnWp5da0HW"
      }
    }
  ]
}