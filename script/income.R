#### SHINY DASHBOARD ####

# Housing Justice

library(tidycensus)
library(tidycensus)
library(tidyverse)
library(sf)

#https://walker-data.com/tidycensus/articles/basic-usage.html
census_api_key("db359ed97072a2b7fc30c854994aea932e99598a", install = TRUE)


# load parcels data
#parcels <- readRDS("~/Clark/RA-ing/SummerInstitute/USF/housing-justice/parcels.RDS")


### 2009 data ###
v19 <- load_variables(2009, "acs5", cache = TRUE)
View(v19) # view name of variable

# download data from 2005-2009 5 year ACS
bk_2009 <- get_acs(state = "NY", county = "Kings", geography =
                       "tract", variables = "B19326_001", year = 2009, geometry = TRUE)

# plot
bk_2009 %>%
  ggplot(aes(fill = estimate)) +
  geom_sf(color = NA) +
  scale_fill_viridis_c(option = "magma") +
  labs(title = "median income 2009")

# join data to parcels
st_crs(bk_2009)
st_crs(parcels)
st_bbox(bk_2009)
st_bbox(parcels)

bk_2009 <- st_transform(bk_2009, crs = 4326)
brooklyn_neigh <- brooklyn_neigh %>%
  st_transform(. , crs = st_crs(parcels))

parcels <- st_join(parcels, bk_2009, left = TRUE)%>%
  filter(!estimate %in% NA)

# q <- parcels_b %>% filter(NHood == "Williamsburg")
# plot(q$geometry)
# names(parcels_b)[29] <- "estimate2009"


# rename columns, delete extra
colnames(parcels)
names(parcels)[28] <- "estimate2009"
names(parcels)[29] <- "moe2009"
parcels <- parcels[-c(25:27)]

### 2019 data ###
v19 <- load_variables(2019, "acs5", cache = TRUE)
View(v19)

# download data from 2015-2019 5-year ACS
bk_2019 <- get_acs(state = "NY", county = "Kings", geography =
                     "tract", variables = "B06011_001", year = 2019, geometry = TRUE)

# plot
bk_2019 %>%
  ggplot(aes(fill = estimate)) +
  geom_sf(color = NA) +
  scale_fill_viridis_c(option = "magma") +
  labs(title = "median income 2019")

st_crs(bk_2019)
st_crs(parcels)
st_bbox(bk_2019)
st_bbox(parcels)


bk_2019 <- st_transform(bk_2009, crs = 4326)
parcels <- st_join(parcels, bk_2019, left = TRUE)%>%
  filter(!estimate %in% NA)

# rename columns, delete extra
colnames(parcels)
names(parcels)[30] <- "estimate2019"
names(parcels)[31] <- "moe2019"
parcels <- parcels[-c(27:29)]

## Export parcels

saveRDS(parcels, "~/Clark/RA-ing/SummerInstitute/USF/housing-justice/parcels.RDS")

#saveRDS(bk_2009, "~/Clark/RA-ing/SummerInstitute/USF/housing-justice/income_2009.RDS")


q <- parcels %>% filter(NHood == "Williamsburg") %>%
  filter(!estimate2009 %in% NA)
# quantile breaks
#install.packages("classInt")
library(classInt)
breaks_qt <- classIntervals(q$estimate2009, n = 7, style = "quantile")
br <- breaks_qt$brks
qpal <-  colorQuantile("Greens", q$estimate2009, n = 7)
mapq_interactive <- leaflet(q) %>% # openmaps background not showing up
  addPolygons(stroke = TRUE, fill = TRUE,
              color= NA, opacity = 5,
              # set the stroke width in pixels
              weight = 7,
              # set the fill opacity
              fillOpacity = 6, fillColor = ~qpal(q$estimate2009),
              popup = paste("Value: ", q$estimate2009, "<br>"),
              # highlightOptions = highlightOptions(color = "black",
              #                                     weight = 2,
              #                                     bringToFront = TRUE)
  ) %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  addLegend(values = ~estimate2009, colors = brewer.pal(7, "Greens"),
            # labFormat = function(type, cuts, p) {
            #   n = length(cuts)
            #   p = paste0(round(p * 100), '%')
            #   cuts = paste0(formatC(cuts[-n]), " - ", formatC(cuts[-1]))},
            labels = paste0("up to ", format(breaks_qt$brks[-1], digits = 2)),
            title = "Median Household Income, 2009"
  )

