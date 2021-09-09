## code to prepare `heat_map` dataset goes here
setwd("~/Clark/RA-ing/SummerInstitute/GIS/kansas_city"
      )
kcmo_heatmap <- st_read("heat_map_geoc.shp")

usethis::use_data(kcmo_heatmap, overwrite = TRUE)
