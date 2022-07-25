## code to prepare `bkbuildingsparcels` dataset goes here

# for steps, see: nyc_brooklyn_historicLU.R

bkbuildingsparcels <- st_read("localdrive/shapes/bkbuildingsparcels1.shp") # load data from Spatial Join in ArcPro
bkbuildingsparcels %>% colnames()

bkbuildingsparcels <- bkbuildingsparcels[-c(1:31, 33:59, 64:89, 92:93, 105:106)] # remove unwanted columns

usethis::use_data(bkbuildingsparcels, overwrite = TRUE)
