#### SHINY DASHBOARD ####

# Housing Justice

library(tidycensus)
library(tidycensus)
library(tidyverse)
library(sf)

#https://walker-data.com/tidycensus/articles/basic-usage.html
census_api_key("db359ed97072a2b7fc30c854994aea932e99598a", install = TRUE)

v19 <- load_variables(2009, "acs5", cache = TRUE)
View(v19)

bk_2009 <- get_acs(state = "NY", county = "Kings", geography =
                       "tract", variables = "B19326_001", year = 2009, geometry = TRUE)

bk_2009 %>%
  ggplot(aes(fill = estimate)) +
  geom_sf(color = NA) +
  scale_fill_viridis_c(option = "magma") +
  labs(title = "median income 2009")

st_crs(bk_2009)
st_crs(parcels)
bk_2009 <- st_transform(bk_2009, crs = 4326)
parcels <- st_join(bk_2009, nyc_boundaries, left = TRUE)%>%
  filter(!estimate %in% NA)
saveRDS(parcels, "~/Clark/RA-ing/SummerInstitute/USF/housing-justice/parcels.RDS")

#saveRDS(bk_2009, "~/Clark/RA-ing/SummerInstitute/USF/housing-justice/income_2009.RDS")


q <- parcels %>% filter(Name == "Williamsburg") %>%
  filter(!estimate %in% NA)
# quantile breaks
#install.packages("classInt")
library(classInt)
breaks_qt <- classIntervals(q$estimate, n = 7, style = "quantile")
br <- breaks_qt$brks
qpal <-  colorQuantile("Greens", q$estimate, n = 7)
mapq_interactive <- leaflet(q) %>% # openmaps background not showing up
  addPolygons(stroke = TRUE, fill = TRUE,
              color= NA, opacity = 5,
              # set the stroke width in pixels
              weight = 7,
              # set the fill opacity
              fillOpacity = 6, fillColor = ~qpal(q$estimate),
              popup = paste("Value: ", q$estimate, "<br>"),
              # highlightOptions = highlightOptions(color = "black",
              #                                     weight = 2,
              #                                     bringToFront = TRUE)
  ) %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  addLegend(values = ~estimate, colors = brewer.pal(7, "Greens"),
            # labFormat = function(type, cuts, p) {
            #   n = length(cuts)
            #   p = paste0(round(p * 100), '%')
            #   cuts = paste0(formatC(cuts[-n]), " - ", formatC(cuts[-1]))},
            labels = paste0("up to ", format(breaks_qt$brks[-1], digits = 2)),
            title = "Median Household Income, 2009"
  )

