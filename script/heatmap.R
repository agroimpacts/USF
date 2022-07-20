install.packages('leaflet.extras')

library(leaflet.extras)


setwd(here("risk/"))
bk07crime <- readRDS("bk07crime.RDS")


# EXTRACT LAT LONG FROM GEOMETRY
library(tidyverse)
bk07heat <- bk07crime %>%
  mutate(long = unlist(map(bk07crime$geometry,1)),
         lat = unlist(map(bk07crime$geometry,2)))
saveRDS(bk07heat, "~/Clark/RA-ing/SummerInstitute/USF/risk/bk07heat.RDS")


q <- bk07heat %>% filter(HourFormat == 15)

leaflet(bk07heat) %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  setView(-73.93, 40.68, zoom = 12)  %>% # Zoom issue
  addHeatmap(
    lng = ~long, lat = ~lat, intensity = 2,
    blur = 10, max = 0.05, radius = 5,
    gradient = "RdPu", #cellSize = 0.5
  )


dayhours <- 00:23 %>% as.character()
experiments <- lapply(dayhours, function(x) {
  Monday <- bk07heat %>% filter(HourFormat == x)
  p +
    stat_density2d(data = Monday, aes(x = long, y = lat, fill = ..density..),
                   geom = 'tile', contour = F ,alpha = 0.5) +
    scale_fill_viridis() +
    ggtitle(paste("hour:", x))
})
