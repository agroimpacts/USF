# USF Data overview


The data within the package is based 
on the selected test case study cities:


- Baltimore, MD
- Chicago, IL
- NYC, NY
- Bay area, CA 
- Detroit, MI
- Kansas City, MO
#####add link to each city for data


## <ins> Open Source Databases </ins>



### <ins> Washington Post Data - police shootings </ins> 
[Source](https://github.com/washingtonpost/data-police-shootings)

Raw data: `wpdata`

Filtered by states of test cities: `t_wpdata`

Filtered by cities: `ct_wpdata`



### <ins> Fatal Encounters </ins> 
[Source](https://fatalencounters.org/spreadsheets/)

Raw data: `encounters`

Filtered by states of test cities: `t_encounters`

Filtered by cities: `ct_encounters`



### <ins> Mapping Police Violence </ins> 
[Source](https://mappingpoliceviolence.org/aboutthedata)

Whole data set: `mpv`


- Worksheet 1 "2013-2020 Police Killings": `mpv_polkill`

  Filter by states: `t_mpv_polkill`
  Geocoded data including intersections (created with ArcGIS Pro 10)

  Filtered by cities: `ct_mpv_polkill`



- Worksheet 2 "2013-2020 Killings by PD" : `mpv_polkillbypd`

  Filter by states and city: `t_mpv_polkillbypd`

  Chart by city (only for San Francisco, Baltimore, New York, and Detroit)

 

- Worksheet 3 "2013-2020 Killings by State": `mpv_killbystate`

  Filter by states: `t_mpv_killbystate`



- Worksheet 4 "Police Killings of Black Men": `mpv_polkilbm`

  Filter by states: `t_mpv_polkilbm`

  Chart by City - only for Chicago and Kansas City



### <ins> Interactive Map </ins> 

All Point Features with Open Street Map as background.

`t_wpdata`, `t_encounters`, and `t_mpv_polkill`

```{r echo=FALSE}
tmap_mode("view")
tm_shape(ct_wpdata) +
  tm_dots(col = '#1CFBA5')  +
tm_shape(ct_encounters) +
  tm_dots(col = '#2F28FA')  +
tm_shape(ct_mpv_polkill) +
  tm_dots(col = '#FF0023')  +
tm_add_legend(col = c("#1CFBA5", "#2F28FA", "#FF0023"), 
         labels = c("Wash. Post Data", "Fatal Encounters", 
                    "Mapping Police Violence"), title = "Police Shootings Data") +
tm_basemap(server = "OpenStreetMap", alpha = 0.7)

```
