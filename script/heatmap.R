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
    blur = 20, max = 0.05, radius = 5,
    gradient = "RdPu", #cellSize = 0.5
  )


# get html widget
library(gridExtra)

# sort days of the week
bk07heat$DayFormatText <- factor(bk07heat$DayFormatText,
                                  levels= c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday",
                                            "Friday", "Saturday"))

# save as png without conditional formatting
png(filename =
      "~/Clark/RA-ing/SummerInstitute/USF/vignettes/figures/bk07heat.png",
    width = 1280, height = 590)
bk07table <- t(table(bk07heat$DayFormatText, bk07heat$HourFormat))
grid.table(bk07table)
dev.off()

# for conditional formatting, export as csv. Read in csv file, and format.
library(DT)
options(DT.options = list(pageLength = 24))
write.table(bk07table,
            file = "~/Clark/RA-ing/SummerInstitute/USF/localdrive/rtm_test/nyc/bk07table.csv", sep = ",", quote = FALSE, row.names = F)
saveRDS(bk07table, "~/Clark/RA-ing/SummerInstitute/USF/risk/bk07table.RDS")

bk07table <- readRDS("bk07table.RDS") %>% as.data.frame()
# bk07table <- read.csv(
#   "~/Clark/RA-ing/SummerInstitute/USF/localdrive/rtm_test/nyc/bk07table.csv") %>%
#   as.data.frame() #%>% mutate(Hour = 0:23)
brks <- quantile(bk07table, probs = seq(.05, .95, .05), na.rm = TRUE)
ramp <- colorRampPalette(c("green", "yellow", "red"))
clrs <- ramp(length(brks)+1)
hmtable07col <- datatable((bk07table),
                          rownames = (seq(0, 23) %>% as.character)) %>%
  formatStyle(names(bk07table),backgroundColor = styleInterval(brks, clrs))
print(hmtable07col)
library(webshot)
html <- "bk_hmtable07col.html"
setwd("~/Clark/RA-ing/SummerInstitute/USF/risk/")
saveWidget(hmtable07col, html)
#webshot(url = "file:///C:/Users/pilii/Documents/Clark/RA-ing/SummerInstitute/USF/localdrive/vignettes/hmtable07col.html") # you can also export to pdf

