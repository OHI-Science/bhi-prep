Lasting Special Places (LSP) Data Preparation
================

## 1\. Background

### Goal Description

The Lasting Special Places sub-goal focuses on those geographic
locations that hold particular value for aesthetic, spiritual, cultural,
recreational or existence reasons, and assesses how well they are
protected. **For the BHI, the designation and management of marine
protected areas (MPAs) captures the commitment of a country to
preserving areas of biological, aesthetic or ecosystem service value.**

### Other information

*External advisors/goalkeepers: Sofia Wikström*

<br/>

## 2\. Data

This prep document is used to generate and explore the following data
layers:

  - `lsp_status_bhi2019.csv`
  - `lsp_trend_bhi2019.csv`

These are saved to the `layers/v2019` folder. Saved to
`data/LSP/v2019/intermediate` are intermediate datasets:
`mpa_bhi_data.csv`, `bhi_buffer.shp` and `bhi_transf.shp`. All these are
derived from or informed by the raw datasets from HELCOM database.

<br>

### 2.1 Datasets with Sources

<br/>

#### 2.1.1 MPA Data

**HELCOM MPAs**

This dataset contains borders of the HELCOM MPAs (former Baltic Sea
Protected Areas (BSPAs). The dataset has been compiled from data
submitted by HELCOM Contracting Parties. It includes the borders of
designated HELCOM MPAs stored in the [HELCOM Marine Protected Areas
database](http://mpas.helcom.fi/apex/f?p=103:1::::::). The designation
is based on the HELCOM Recommendation 15/5 (1994).

<!-- dataset save location BHI_share/BHI 2.0/Goals/LSP/ -->

| Option           | Specification   |
| :--------------- | :-------------- |
| Biodiversity:    | Protected areas |
| Protected areas: | HELCOM MPAs     |

Source: [HELCOM Map and Data
Service](http://metadata.helcom.fi/geonetwork/srv/eng/catalog.search#/metadata/d27df8c0-de86-4d13-a06d-35a8f50b16fa)
<br/> Downloaded 23 June 2020 by Andrea De Cervo

<br/>

**MPAs**

Data were downloaded from the *MPAs* tab on the HELCOM MPA database.  
These MPA status levels depend upon the existence of implemented
management plans for the MPA areas. Also, MPA status is based on
self-reporting. If countries differ in their definitions of “managed” or
inflate their MPA status, we cannot account for those biases in the
data.

<!-- dataset save location BHI_share/BHI 2.0/Goals/LSP/ -->

| Option   | Specification |
| :------- | :------------ |
| MPAs     | Actions       |
| Download | .csv          |

Source: [HELCOM Marine Protected Areas
database](http://mpas.helcom.fi/apex/f?p=103:5::::::) <br/> Downloaded
23 June 2020 by Andrea De Cervo

<br/>

**Management Plans**

The status of the management plans associated with each MPA were
downloaded from HELCOM MPA database, under the *Management Plans* tab.
There are three levels of management plan status that can be assigned to
each MPA: *No plan*, *In development*, *Implemented*.

A challenge is that each MPA can have multiple management plans
associated with it. There is no limit to the number of plans not an
ability to assess their relative importance. Different management plans
for the same MPA can have different levels of implementation.

<!-- dataset save location BHI_share/BHI 2.0/Goals/LSP/ -->

| Option           | Specification |
| :--------------- | :------------ |
| Management plans | Actions       |
| Download         | .csv          |

Source: [HELCOM Marine Protected Areas
database](http://mpas.helcom.fi/apex/f?p=103:5::::::) <br/> Downloaded
23 June 2020 by Andrea De Cervo

<br/>

### 2.1.2 Reference values

The [Convention on Biodiversity’s
target](https://www.cbd.int/sp/targets/rationale/target-11/) is for 10%
of a country’s EEZs is designated as MPAs, and are fully managed.

For the BHI 2.0, the designation of at least 10% of the BHI region area
as MPAs with a full implemented management plan, in order to give a fair
representation of spatial coverage to the country and its respective
basin. Management status are broken down to three categories and
weighted on a 0-1 scale:

0.1 = designated 0.4 = designated and partly managed 1.0 = designated
and managed

### 2.2 Centralization & Normalization

#### 2.2.1 MPAs datasets

Get them in the same coordinate reference system for the Baltic. The MPA
file is in the [LAEA coordinate reference
system](http://spatialreference.org/ref/epsg/etrs89-etrs-laea/).

**Read in MPA and BHI regions shapefiles** OGR data source with driver:
ESRI Shapefile Source:
“/Users/andreadecervo/github/bhi-data/Shapefiles/BHI\_shapefile”,
layer: “BHI\_shapefile” with 42 features It has 6 fields rgn\_nam
rgn\_key Subbasin HELCOM\_ID BHI\_ID Area\_km2 0 Denmark DNK Arkona
Basin SEA-006 12 6272.534 1 Denmark DNK Bay of Mecklenburg SEA-005 9
1144.293 2 Denmark DNK Bornholm Basin SEA-007 15 7152.798 3 Denmark DNK
Great Belt SEA-002 3 10369.113 4 Denmark DNK Kattegat SEA-001 2
15300.700 5 Denmark DNK Kiel Bay SEA-004 7 1208.876 OGR data source with
driver: ESRI Shapefile Source: “/Users/andreadecervo/github/bhi-data/BHI
2.0/Goals/LSP/HELCOM\_MPAs”, layer: “HELCOM\_MPAs” with 177 features It
has 8 fields Integer64 fields read as strings: OBJECTID\_1 Year\_est
![](lsp_prep_files/figure-gfm/read%20in%20shapefiles-1.png)<!-- -->

#### 2.2.2 Intersect BHI and HELCOM\_MPA polygons

MPA regions were divided by with BHI region shapefile, and thus we were
able to calculate the total MPA area within each BHI region. MPA area
per region is saved in the prep folder (`mpa_area_per_rgn.csv`).

The .csv file includes information: Area per MPA, Date established, MPA
status, total MPA area per region.

<br/>

## 3\. Prep: Wrangling & Derivations, Checks/Evaluation, Gapfilling

``` r
management_plans <- read.delim(
  file.path(dir_rawdata, "management_plans.csv"), 
  sep = ",",
  stringsAsFactors = FALSE)

report_sites <- read.delim(
  file.path(dir_rawdata, "report_sites.csv"), 
  sep = ";",
  stringsAsFactors = FALSE)

## previously merged in 'data/LSP/v2019/lsp_data.R' script
mpa_bhi <- sf::st_read(file.path(
  dir_intermediate, 
  "mpa_bhi.shp"
))

## previously merged in 'data/LSP/v2019/lsp_data.R' script
mpa_bhi_data <- read_csv(file.path(dirname(data_path), "intermediate", "mpa_bhi_data.csv"))
```

<br/>

In BHI 1.0, MPA regions were divided by with BHI region shapefile, to be
able to calculate the total MPA area within each BHI region. (MPA area
per region was saved in the prep folder
*bhi-1.0-archive/baltic2015/prep/LSP/mpa\_area\_per\_rgn.csv* and
includes information on *Area per MPA, Date established, MPA status,
total MPA area per region*).

However, in April 2016, changes had been made on raw datasets, in
particular the following attributes were removed: “Location\_S”,
“AreaTot\_Ha”, “AreaMar\_Ha”, “N2K\_Site”, changed following
attributes names: “BSPA\_ID” to “MPA\_ID”, “BSAPLink” to “Site\_link”
and added attribute “Date\_est”. Therefore, the attribute
“MPA.size.km.sup2” from the raw *report\_sites* dataset will be used
as total MPA area.

### 3.1 MPA management status

Joining information from the .csv file to the shapefile data.

``` r
mgmt_status <- report_sites %>%
  mutate(status = str_replace_all(Status, " ", "_")) %>%
  dplyr::select(name_csv = HELCOM.MPA.name,
                MPA_ID = ID,
                status_csv = status,
                mpa_area_km2 = MPA.size..km.sup2..) 

# count number of unique mpa names in new mpa mgmt status csv with a total of 175 observations
mpa_name <- dplyr::select(mgmt_status, name_csv)
unique_mpa_csv_new <- base::unique(mpa_name) ## total of 177 names that are unique

# combine mpa_status with shapefile data
mpa_mgmt <- right_join(mgmt_status, mpa_bhi,  
                       by = "MPA_ID") %>%
  dplyr::rename(name_shape = Name, 
                country = rgn_nam,
                status_shape = MPA_status,
                date_est = Date_est,
                eez_area_km2 = Area_km2) %>% 
  mutate(mgmt_status = ifelse(is.na(status_csv), as.character(status_shape), status_csv)) %>%  
  # join the basin_lookup which has slighly different bhi_region_areas
  right_join(basin_lookup, by = "BHI_ID")
       
# count number of MPAs in shape file with no matches in csv file. 
# num_mismatch_new <- dplyr::count(mpa_mgmt, !status_csv== "NA") 
# 1 rows (1 MPA) have no match from the status csv file. 
```

<br/>

### 3.2 Explore map data

``` r
library(leaflet)
source(here::here("R", "spatial.R"))
regions_shape()

## Make basemap
basemap <- ggplot2::ggplot(rnaturalearth::ne_countries(scale = "medium", returnclass = "sf")) + 
  geom_sf(size = 0.1, color = "burlywood", alpha = 0.4) +
  scale_x_continuous(limit = c(4, 32)) +
  scale_y_continuous(limit = c(53.5, 66)) +
  theme(panel.background = element_rect(fill = "#F8FBFC", color = "#E2EEF3"))

# bhi_rgns_simple <- rmapshaper::ms_simplify(input = BHI_rgns_shp) %>% sf::st_as_sf()

## previously merged in 'data/LSP/v2019/lsp_data.R' script
bhi_buff <- sf::st_read(file.path(
  dir_intermediate, 
  "bhi_buffer.shp"
))
```

    ## Reading layer `bhi_buffer' from data source `/Users/andreadecervo/github/bhi-prep/data/LSP/v2019/intermediate/bhi_buffer.shp' using driver `ESRI Shapefile'
    ## Simple feature collection with 42 features and 6 fields
    ## geometry type:  MULTIPOLYGON
    ## dimension:      XY
    ## bbox:           xmin: 4283762 ymin: 3397830 xmax: 5442611 ymax: 4818369
    ## proj4string:    +proj=laea +lat_0=52 +lon_0=10 +x_0=4321000 +y_0=3210000 +ellps=GRS80 +units=m +no_defs

``` r
## previously merged in 'data/LSP/v2019/lsp_data.R' script
bhi_transf <- sf::st_read(file.path(
  dir_intermediate, 
  "bhi_transf.shp"
))
```

    ## Reading layer `bhi_transf' from data source `/Users/andreadecervo/github/bhi-prep/data/LSP/v2019/intermediate/bhi_transf.shp' using driver `ESRI Shapefile'
    ## Simple feature collection with 42 features and 6 fields
    ## geometry type:  MULTIPOLYGON
    ## dimension:      XY
    ## bbox:           xmin: 4283762 ymin: 3397830 xmax: 5442611 ymax: 4818369
    ## proj4string:    +proj=laea +lat_0=52 +lon_0=10 +x_0=4321000 +y_0=3210000 +ellps=GRS80 +units=m +no_defs

``` r
mpa_plot <- basemap +
  geom_sf(data = bhi_transf, fill = "white", size = 0.2, color = "burlywood") +
  geom_sf(
    mapping = aes(colour = MPA_status),
    data = sf::st_as_sf(
      mpa_bhi, 
      coords = c("lon", "lat"), 
      crs = 3035
    ),
    size = 1.8
  ) +
  labs(x = NULL, y = NULL, colour = "MPA Status") +
  ggtitle("MPA Status in the Baltic Sea")

print(mpa_plot)
```

![](lsp_prep_files/figure-gfm/explore%20mpa%20data%20in%20map-1.png)<!-- -->

``` r
# + theme(legend.position = c(0.9, 0.1)) +
#  scale_color_manual(values = c("tomato", "aquamarine2", "gold"))
```

<br/>

### 3.3 Plot number of MPAs per bhi regions

``` r
## plot the number of MPAs per bhi regions
num_mpa_per_bhi_rgn = mpa_mgmt %>%
  group_by(BHI_ID) %>%
  summarize(count = length(!duplicated(name_shape))) %>%
  ungroup %>% 
  full_join(basin_lookup, by = "BHI_ID")

mpa_per_bhi_rgn_plot <- ggplot(num_mpa_per_bhi_rgn, aes(x = rgn_nam, y = count)) +
 geom_bar(stat = 'identity') +
 geom_text(aes(label = sprintf('n = %s', count), y = count), 
           size = 3, 
           angle = 90, hjust = 0, color = 'grey30') +
 theme(axis.text.x = element_text(angle = 75, hjust = 1)) + 
 labs(title = 'Number of MPAs per BHI region',
      x = 'BHI regions', 
      y = 'Number of MPAs')

print(mpa_per_bhi_rgn_plot)
```

![](lsp_prep_files/figure-gfm/plot%20number%20of%20MPAs%20per%20country-1.png)<!-- -->
<br/>

### 3.4 Plot the number of MPAs per bhi region by management level

``` r
# Add the management categories and their respective value
mgmt_weight <- data.frame(mgmt_status = c(
  "Designated", "Designated_and_partly_managed", "Designated_and_managed"),
  weight = c(0.1, 0.4, 1))
                          
mpa_mgmt_with_wt <- full_join(mgmt_weight, mpa_mgmt, 
                              by = 'mgmt_status')

num_mpa_per_bhi_rgn_mgmt <- mpa_mgmt_with_wt %>%
  group_by(BHI_ID, weight) %>%
  summarize(count = length(!duplicated(name_shape))) %>%
  ungroup %>% 
  full_join(mpa_mgmt_with_wt, by = "weight") 

## plot number of MPAs per bhi rgn by mgmt levels 
num_bhi_rgn_mgmt_plot <- ggplot(num_mpa_per_bhi_rgn_mgmt, aes(x = rgn_nam, y = count, fill = mgmt_status)) +
 geom_bar(stat = 'identity') +
 geom_text(aes(label = sprintf('n = %s', count), y = count), 
           size = 3, 
           angle = 90, hjust = 0, color = 'grey30') +
 theme(axis.text.x = element_text(angle = 75, hjust = 1)) + 
 labs(title = 'Number of MPAs by BHI region and management level',
      x = 'BHI region', 
      y = 'Number of MPAs',
      fill = 'Management Level')

print(num_bhi_rgn_mgmt_plot)
```

![](lsp_prep_files/figure-gfm/plot%20number%20of%20MPAs%20per%20country%20by%20mgmt%20levels-1.png)<!-- -->
<br/>

## 4\. New Status calculation

In the BHI 1.0, the model assessed the area of MPAs in each *country* in
relation to its EEZs, and their management status.

In order to give a more fair representation of MPA coverage to both the
countries and their respective basins, the status is now calculated by
*bhi region*.

STEPS:

1)  Calculate the reference point: 10% BHI region area (instead of total
    EEZ per country)

2)  Calculate total MPA area in a given BHI region (mpa\_prop):

<!-- end list -->

  - if the total MPA area exceeds the 10% target, use ratio MPA
    area/total MPA areas in given BHI region;

  - if the total MPA area does not reach the 10% target, use ratio MPA
    area/Reference Area (10%).

<!-- end list -->

3)  Calculate total mpa\_area \* weight, per BHI region per year

4)  Calculate status by BHI region per year

5)  Calculate status by BHI region

*Xlsp\_country = sum(MPA\_area/Reference\_pt\_bhiregions) \* w\_i*

Weight (w\_i) is based upon management status, which is broken down to
three categories and weighted on a 0-1 scale:

0.1 = designated 0.4 = designated and partly managed 1.0 = designated
and managed

**Reference\_pt\_bhiregion** = 10% of the bhi region area is designated
as an MPA and is fully managed.

### 4.1 New calculation of sum area

``` r
# Calculate the proportion
mpa_status <- mpa_mgmt_with_wt %>%
  group_by(BHI_ID) %>%
  mutate(
    total_mpa_area_in_bhirgn = sum(mpa_area_km2),
    area_refpt = 0.1 * bhi_area_km2 # instead of 'eez_area_km2'
  ) %>% 
  ungroup() %>% 
  ## if the total MPA area exceeds the 10% mark,
  ## don't want sum of weights for weighted sum to exceed 1
  ## so need to use ratio of MPA area to Sum of MPA areas in given BHI region
  ## but want to penalize for not reaching 10% mark
  ## so use MPA area vs Reference Area (10%) in all other cases
  mutate(mpa_prop = ifelse(
    total_mpa_area_in_bhirgn >= area_refpt,
    mpa_area_km2/total_mpa_area_in_bhirgn,
    mpa_area_km2/area_refpt
  )) %>% 
  group_by(BHI_ID) %>% 
  mutate(
    ## check_area_ref_relationship should be less than 1 for BHI regions where 10% ref area as MPA is not achieved
    ## but should never exceed 1!
    ## (if you were to calc mpa_prop above without ifelse, i.e. mpa_prop = mpa_area/area_refpt, would get many cases above 1
    check_area_ref_relationship = sum(mpa_prop),
    status_score = sum(mpa_prop*weight))
```

<br/>

#### 4.1.1 Plot total MPA area vs. 10% of the EEZ

In the plot below, the red line represents where total MPA area equals
that of the reference point (ie. 10% EEZ). Any point above that line
means that the country has exceeded the reference point of designated
MPA area and therefore will have a status score of 100, and any point
below the line will have a score lower than
100.

``` r
mpa_vs_bhiarea_plot <- ggplot(mpa_status, aes(x = area_refpt, y = total_mpa_area_in_bhirgn)) +
  geom_point(aes(color = BHI_ID), size = 3) +
  geom_abline(slope = 1, intercept = 0, color = 'red') +
  geom_text(aes(label = BHI_ID), nudge_y = -300) +
  theme(legend.position = 'none') +
  coord_cartesian(xlim = c(0, 15000), ylim = c(0, 15000)) +
  labs(title = 'Total MPA vs. Reference area by BHI region',
       x = '10% BHI region (km2)', 
       y = 'Total MPA (km2)')

print(mpa_vs_bhiarea_plot)
```

![](lsp_prep_files/figure-gfm/compare%20total%20MPA%20area%20with%20ref%20area-1.png)<!-- -->
<br/>

#### 4.1.2 Plot the area of MPA by management level vs. 10% EEZ

The plot below compares the total MPA area of each management level with
the reference point (10% BHI region area). The black dots represent 10%
BHI region
area.

``` r
area_vs_mgmt_lvl_plot <- ggplot(mpa_status, aes(x = rgn_nam, y = total_mpa_area_in_bhirgn, 
                                                fill = mgmt_status)) +
 geom_bar(stat = 'identity') +
 geom_point(aes(x = rgn_nam, y = area_refpt, size = area_refpt), col = "black", show.legend = NA) +
 theme(axis.text.x = element_text(angle = 75, hjust = 1)) + 
 labs(title = 'MPA area of each management level vs. 10% BHI region area',
      x = 'BHI region', 
      y = 'MPA area (km2)',
      fill = 'Management Level',
      size = '10% BHI region area')

print(area_vs_mgmt_lvl_plot)
```

![](lsp_prep_files/figure-gfm/MPA%20area%20vs%20management%20level-1.png)<!-- -->
<br/>

### 4.2 LSP Status

``` r
### Calculate status per year by bhi region
status_per_year_by_bhiregion <- mpa_status %>% 
  group_by(BHI_ID, year = Year_est) %>%
  summarize(status = round(max(-1, pmin(1, status_score)) * 100, 1)) %>%
  ungroup() %>%
  arrange(BHI_ID, year)

### Calculate status per bhi region
status_by_bhiregion <- status_per_year_by_bhiregion %>%
  group_by(rgn_id = BHI_ID) %>%
  filter(year == max(year)) %>% # there are also differences in MPA status among years
  dplyr::select(-year, -BHI_ID)

lsp_last_year <- status_per_year_by_bhiregion %>%
  group_by(BHI_ID)%>%
  summarise(last_year = last(year))
# bhi_rgn have different last year data

knitr::kable(
  lsp_last_year %>% 
    group_by(last_year) %>%
    summarize(`Num. BHI Regions with Year` = n(), BHI_ID = paste(BHI_ID, collapse = ", ")) %>% 
    rename(`Last Year ` = last_year))
```

| Last Year | Num. BHI Regions with Year | BHI\_ID                                                            |
| :-------- | -------------------------: | :----------------------------------------------------------------- |
| 2005      |                          3 | 19, 30, 40                                                         |
| 2008      |                          6 | 9, 10, 11, 29, 35, 39                                              |
| 2009      |                         19 | 1, 2, 3, 4, 5, 6, 7, 8, 12, 13, 14, 15, 16, 17, 18, 20, 21, 31, 34 |
| 2011      |                          2 | 26, 41                                                             |
| 2013      |                          3 | 25, 27, 28                                                         |
| 2015      |                          6 | 24, 32, 33, 36, 37, 42                                             |
| 2016      |                          2 | 22, 23                                                             |
| 2018      |                          1 | 38                                                                 |

``` r
r.status_mpa <- mpa_status %>%
  filter(!duplicated(BHI_ID)) %>%
  dplyr::select(rgn_id = BHI_ID, 
                country, rgn_nam) %>%
  full_join(status_by_bhiregion, 
            by = 'rgn_id') %>% 
  dplyr::select(rgn_id, 
                score = status) %>% 
  mutate(dimension= "status",
         status = score/100)

# Save status layer
write_csv(r.status_mpa, file.path(dir_layers, 'lsp_status_bhi2019.csv'))
```

<br/>

#### 4.2.1 Plot status

``` r
## plot the status
plot_status <- r.status_mpa %>% 
  full_join(.,basin_lookup, by = c("rgn_id"= "BHI_ID")) 

set.seed(2)
statuspal <- colorRampPalette(fullpal)(80)[sample(1:80, size = 18)]

ggplot(plot_status) +
  geom_col(
    aes(rgn_nam, score, fill = subbasin),
    position = position_dodge(), 
    color = "black", 
    alpha = 0.6,
    size = 0.2,
    show.legend = FALSE
  ) + 
  geom_text(aes(rgn_nam, score, label = score), color = "black", size = 3) +
  coord_flip() +
  labs(x = NULL, y = "Score") +
  theme_bw() +
  theme(axis.text.y = element_text(size = 9)) +
  scale_fill_manual(values = statuspal) +
  ggtitle("LSP Status by BHI Region")
```

![](lsp_prep_files/figure-gfm/plot%20lsp%20status-1.png)<!-- --> <br/>

#### 4.2.2 Plot status map

``` r
# Make a map with score and mpa status categories
basemap <- ggplot2::ggplot(rnaturalearth::ne_countries(scale = "medium", returnclass = "sf")) +
  geom_sf(size = 0.1, color = "burlywood", alpha = 0.4) +
  theme(panel.background = element_rect(fill = "#F8FBFC", color = "#E2EEF3")) +
  scale_x_continuous(limit = c(4, 32)) +
  scale_y_continuous(limit = c(53.5, 66)) 

cols <- c("indianred", "coral", "goldenrod1", "khaki", "lightblue", "steelblue")

bhi_rgn <- st_read(file.path(dirname(dir_B), "Shapefiles", "BHI_shapefile"))
```

    ## Reading layer `BHI_shapefile' from data source `/Users/andreadecervo/github/bhi-data/Shapefiles/BHI_shapefile' using driver `ESRI Shapefile'
    ## Simple feature collection with 42 features and 6 fields
    ## geometry type:  MULTIPOLYGON
    ## dimension:      XY
    ## bbox:           xmin: 9.420778 ymin: 53.60164 xmax: 30.34708 ymax: 65.90708
    ## CRS:            4326

``` r
bhi_rgn_simple <- rmapshaper::ms_simplify(input = bhi_rgn) %>% 
  sf::st_as_sf() %>% 
  mutate(rgn_nam = stringr::str_replace(rgn_nam, ", ",  " , "))

MPA_shp <- rmapshaper::ms_simplify(input = mpa_bhi) %>% 
  sf::st_as_sf()

## try joining data before plotting to make sure join works
plotsf <- left_join(
   bhi_rgn_simple,
   r.status_mpa,
   by = c("BHI_ID" = "rgn_id")
)

statusmap <- basemap +
  geom_sf(
    data = plotsf,
    mapping = aes(fill = score)
  ) +
  scale_fill_gradientn(
    colors = (cols),
    values = c(0, 0.1, 0.3, 0.65, 0.8, 1),
    limits = c(0, 100)
  )

statusmap + geom_sf(data = MPA_shp, mapping = aes(color = MPA_status), fill = NA, alpha = 0.4)
```

![](lsp_prep_files/figure-gfm/plot%20lsp%20status%20map-1.png)<!-- -->
<br/>

## 5\. Trend calculation

### 5.1 Linear trend of status scores

A linear trend was drawn on the status scores of the past five years.

``` r
library(tidyr)
trend_data <- status_per_year_by_bhiregion %>% 
  filter(!is.na(year)) %>% # one russian MPA didn't have info on established year
  mutate(year = as.integer(year)) %>%
  tidyr::complete(year = full_seq(year, 1), nesting(BHI_ID)) %>%
  group_by(BHI_ID) %>%
  fill(status) %>%
  mutate(status = ifelse(is.na(status), 0, status)) %>%
  ungroup()

r.trend <- trend_data %>%
  filter(year > (max(year) - 5)) %>% # most recent 5 years of data (2013- 2018)
  group_by(BHI_ID) %>%
  do(dlm = lm(status ~ year, data = .)) %>%
  mutate(score = round(pmax(-1, pmin(1, coef(dlm)[['year']]* 5/100)), 1)) %>%
  dplyr::select(BHI_ID, score)%>% 
  full_join(basin_lookup, by = "BHI_ID")   

r.trend_by_bhi <- dplyr::select(mpa_mgmt_with_wt, BHI_ID, country) %>% 
  filter(!duplicated(BHI_ID)) %>% 
  full_join(r.trend,
            by = "BHI_ID") %>% 
  dplyr::select(BHI_ID, 
                score) %>% 
  mutate(dimension = "trend") 

# Save trend layer
write_csv(r.trend_by_bhi, file.path(dir_layers, 'lsp_trend_bhi2019.csv'))  
```

<br/>

### 5.2 Plot final slope object

``` r
plot_slope <- r.trend_by_bhi %>%
  full_join(., basin_lookup, by = "BHI_ID") %>% 
  rename(rgn_id = BHI_ID)

ggplot(rbind(plot_status, plot_slope)) + 
  geom_col(aes(rgn_nam, score, fill = subbasin), alpha = 0.5, show.legend = FALSE) +
  coord_flip() +
  facet_wrap(~dimension, scales = "free_x", nrow = 1) +
  labs(x = "BHI Region\n", y = "Score") +
  ggtitle("LSP Status and Trend Scores by Region") +
  scale_fill_manual(values = statuspal) +
  theme(axis.text.y = element_text(size = 7))
```

![](lsp_prep_files/figure-gfm/plot%20final%20code%20object-1.png)<!-- -->
<br/>

## 6\. Status calculation (previous alternative)

Following a similar method as for the BHI 1.0, the model assesses the
area of MPAs in each *bhi region* in relation to its EEZs, and their
management status.

Status is calculated by *bhi region* (which is also associated with that
respective country).

STEPS:

1)  Calculate the reference point: 10% total eez per BHI region (instead
    of per country)

2)  Calculate cumulative mpa\_area \* weight, per BHI region per year
    \[cumulative\_sum (weight \* mpa\_area\_km2)\]

3)  Calculate status by BHI region per year \[cumulative\_sum (weight \*
    mpa\_area\_km2) / ref\_point\]

4)  Calculate status by BHI region

\_Xlsp\_country = sum(w\_i \* MPA area)*m / Reference\_pt\_bhiregions*

  - Numerator is the sum over all MPAs within a bhi region’s EEZ of the
    MPA area weighted by the management status.  
  - w\_i = value between 0 -1

Weight (w\_i) is based upon management status, which is broken down to
three categories and weighted on a 0-1 scale:

0.1 = designated 0.4 = designated and partly managed 1.0 = designated
and managed

**Reference\_pt\_bhiregion** = 10% of the area in a bhi region’s EEZ is
designated as an MPA and is 100% managed = 10% area bhi region’s EEZ

### 6.1 Calculate reference point

``` r
### Calculate the reference point: 10% total eez per bhi region 
eez_data <- mpa_mgmt_with_wt %>%
  dplyr::select(MPA_ID, BHI_ID, country, eez_area_km2) %>%
#  filter(!duplicated(MPA_ID)) %>% #remove duplicated rows of the same MPA (but also MPA shared by two bhi_rgn)
  filter(!duplicated(BHI_ID)) %>%
  group_by(BHI_ID) %>%
  summarize(total_eez_km2 = sum(eez_area_km2)) %>% 
  ungroup() %>%
  mutate(ref_eez_km2 = 0.1 * total_eez_km2) %>%
  dplyr::select( -total_eez_km2)

### Calculate cumulative mpa_area*weight, per bhi region per year:
### cumulative_sum (weight * mpa_area_km2)
cum_mpa_area_wt <- mpa_mgmt_with_wt %>%
  dplyr::select(MPA_ID, BHI_ID, weight, country, rgn_nam, mpa_area_km2, year = Year_est) %>%
  filter(!is.na(year)) %>% 
  group_by(BHI_ID, year) %>%
  dplyr::summarize(sum_mpa_wt = sum(mpa_area_km2 * weight)) %>%
  arrange(year) %>%
  mutate(cum_mpa_wt = cumsum(sum_mpa_wt)) %>%
  ungroup()

### Calculate status per bhi region per year: 
### cumulative_sum (weight * mpa_area_km2) / ref_point
status_per_year_by_bhiregion_alt <- full_join(
  cum_mpa_area_wt, eez_data, by = 'BHI_ID') %>% 
  group_by(BHI_ID, year) %>%
  summarize(status = round(max(-1, pmin(1, cum_mpa_wt/ref_eez_km2)) * 100, 1)) %>%
  ungroup() %>%
  arrange(BHI_ID, year)

### Calculate status per bhi region
status_by_bhiregion_alt <- status_per_year_by_bhiregion %>%
  group_by(rgn_id = BHI_ID) %>%
  filter(year == max(year)) %>% # there are also differences in MPA status among years
  dplyr::select(-year, -BHI_ID)

lsp_last_year_alt <- status_per_year_by_bhiregion %>%
  group_by(BHI_ID)%>%
  summarise(last_year = last(year))
# bhi_rgn have different last year data

# knitr::kable(
#  lsp_last_year %>% 
#    group_by(last_year) %>%
#    summarize(`Num. BHI Regions with Year` = n(), rgn_nam = paste(rgn_nam, collapse = ", ")) %>% 
#    rename(`Last Year ` = last_year))

r.status_alt <- mpa_mgmt_with_wt %>%
  filter(!duplicated(BHI_ID)) %>%
  dplyr::select(rgn_id = BHI_ID, 
                country, rgn_nam) %>%
  full_join(status_by_bhiregion, 
            by = 'rgn_id') %>% 
  dplyr::select(rgn_id, 
                score = status) %>% 
  mutate(rgn_id = as.integer(rgn_id)) %>% 
  mutate(dimension= "status")

# lsp_status <- r.status_helcom %>%
#  full_join(r.status_bhi, 
#            by = 'rgn_id')

# Save status layer
# write_csv(r.status, file.path(dir_layers, 'lsp_status_bhi2019.csv'))
```

<br/>

#### 6.1.1 Plot total MPA area vs. 10% of the EEZ

In the plot below, the red line represents where total MPA area equals
that of the reference point (ie. 10% EEZ). Any point above that line
means that the country has exceeded the reference point of designated
MPA area and therefore will have a status score of 100, and any point
below the line will have a score lower than 100.

``` r
mpa_vs_eez <- mpa_mgmt_with_wt %>%
  dplyr::select(MPA_ID, BHI_ID, country, mpa_area_km2, year = Year_est) %>%
#  filter(!is.na(year), 
#         !duplicated(MPA_ID)) %>%  # the same MPA could exist in different BHI_IDs 
  group_by(BHI_ID, year)  %>%
  summarize(total_mpa_per_year = sum(mpa_area_km2)) %>%
  ungroup() %>%
  group_by(BHI_ID) %>%
  mutate(total_mpa = cumsum(total_mpa_per_year)) %>%
  filter(year == max(year)) %>%
  full_join(dplyr::select(eez_data, BHI_ID, ref_eez_km2), 
            by = 'BHI_ID') %>%
  dplyr::select( -total_mpa_per_year, -year) %>% 
  full_join(basin_lookup, by = "BHI_ID")
  
mpa_vs_eez_plot <- ggplot(mpa_vs_eez, aes(x = ref_eez_km2, y = total_mpa)) +
  geom_point(aes(color = BHI_ID), size = 3) +
  geom_abline(slope = 1, intercept = 0, color = 'red') +
  geom_text(aes(label = BHI_ID), nudge_y = -300) +
  theme(legend.position = 'none') +
  coord_cartesian(xlim = c(0, 15000), ylim = c(0, 15000)) +
  labs(title = 'Total MPA vs. Reference EEZ area by BHI region',
       x = '10% EEZ (km2)', 
       y = 'Total MPA (km2)')
```

<br/>

## 7\. Considerations for `BHI3.0`

<br>

## 8\. References

[Baltic Sea Environment Proceedings No. 148 - Ecological coherence
assessment of the Marine Protected Area network in the Baltic
Sea](https://www.helcom.fi/wp-content/uploads/2019/08/BSEP148.pdf)
