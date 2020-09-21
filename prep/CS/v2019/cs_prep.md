Carbon Storage (CS) Goal Data Preparation
================

<br>

## 1\. Background

### Goal Description

The Carbon Storage goal captures the ability of the coastal habitats to
remove carbon given their carbon uptake rate and health conditions. A
score of 100 means all habitats that contribute to carbon removal are
still intact or have been restored and they can function to their full
carbon burial potential. Highly productive coastal wetland ecosystems or
seagrass store substantially large amount of carbon have the highest
sequestration rates of any habitats on earth. They are also threatened
by under-regulated coastal development but are amenable to restoration
and conservation efforts.

For the BHI, as data was limited we only used seagrass (\_Zostera sp.)
coverage data to assess vegetation-based carbon storage. There is high
uncertainty associated with using only seagrass data. However, we aim to
highlight the need to better monitor marine vegetation in order to
understand the carbon storage capacity in coastal areas.

### Model & Data

Seagrass data (Zostera sp.) data were downloaded from the [HELCOM Map &
Data service](http://maps.helcom.fi/website/Biodiversity/index.html).
Select: Biodiversity \>\> Red List \>\> Macrophytes \>\> Least concern
(LC) \>\> Zostera marina (LC).

The data were classified as follows:

  - 0 = no observations  
  - 1 = present before year 1995 or in 1995  
  - 2 = present after year 1995  
  - 3 = present before and after year 1995

### Reference points

A Zostera sp classification of 2 (present after year 1995) or 3 (present
before and after year 1995) have used as reference points.

### Considerations for BHI 3.0

As availability of seagrass extent data is limited, higher-resolution
and more recent coverage data should be used for analysis. Also, include
spatial data from remote sensing for saltmarshes, sheltered shallow
bays, lagoons and reed belts, as well as other indicators, such as
freshwater macrophyte distribution and monitoring data for the northern
Baltic areas.

### Other information

*External advisors/goalkeepers: Christoffer Boström and Markku
Viitasalo*

<br/>

## 2\. Data

This prep document is used to generate and explore the following data
layers:

  - `cs_status_bhi2019.csv`

These are saved to the `layers` folder. Saved to
`data/CS/v2019/intermediate` are intermediate datasets: `bhi_transf.shp`
and `cs_bhi_intersect.shp`. All these are derived from HELCOM Map and
Data Service.

<br>

### 2.1 Datasets with Sources

<br/>

#### 2.1.1 Zostera marina Data

**Zostera marina observations (LC)**

Observations of Zostera marina were collected from the Baltic Sea area
for HELCOM Red List species list. Zostera marina has been placed to the
Red List category of Least Concern (LC) species.

Dataset for download contains spatial grid of the Baltic Sea.
Distribution of the species can be found in corresponding name column.
Values are coded: 0 = no observations 1 = present before year 1995 or in
1995 2 = present after year 1995 3 = present before and after year 1995

<!-- dataset save location BHI_share/BHI 2.0/Goals/CS/ -->

| Option             | Specification       |
| :----------------- | :------------------ |
| Biodiversity:      | Red List            |
| Macrophytes:       | Least Concern (LC)  |
| Least Concern (LC) | Zostera marina (LC) |

Source: [HELCOM Map and Data
Service](http://metadata.helcom.fi/geonetwork/srv/eng/catalog.search#/metadata/dd90a6aa-1d65-4158-a2e7-7ca3ee87d615)
<br/> Downloaded 13 July 2020 by Andrea De Cervo

<br/>

**Zostera marina distribution**

Distribution of eelgrass based on data submission by HELCOM contracting
parties. Mainly pointwise occurrences of eelgrass were submitted,
originally gathered in national mapping and monitoring campaigns, or for
scientific research. Polygon data from Puck Bay (Poland) was digitized
based on Polish Marine Atlas and Orlowo cliff area was added based on
expert knowledge. From Estonian waters, a predictive model was used
(200m resolution), that was converted to presence/absence using
minimized difference threshold (MDT) criteria. Spatial resolution: 1 km
x 1 km grid (originally 5 x 5 km).

Raster value representing presence (1) or absence (0) of Zostera marina.

<!-- dataset save location BHI_share/BHI 2.0/Goals/CS/ -->

| Option           | Specification               |
| :--------------- | :-------------------------- |
| Biodiversity:    | Ecosystem components (BSII) |
| Benthic species: | Zostera marina distribution |

Source: [HELCOM Map and Data
Service](http://metadata.helcom.fi/geonetwork/srv/eng/catalog.search#/metadata/ca327bb1-d3cb-46c2-8316-f5f62f889090)
<br/> Downloaded 13 July 2020 by Andrea De Cervo

<br/>

**Seagrass Meadows**

The data set is showing seagrass meadows in the Baltic Sea area as
points used for the BRISK project (Sub-regional risk of spill of oil and
hazardous substances in the Baltic Sea; learn more
[here](http://www.brisk.helcom.fi/)). This dataset has been produced by
[COWI](http://www.cowi.dk) based on data from HELCOM.

<!-- dataset save location BHI_share/BHI 2.0/Goals/CS/ -->

| Option                    | Specification                   |
| :------------------------ | :------------------------------ |
| Shipping:                 | Risk assessment (BRISK project) |
| Environmental parameters: | Seagrass meadows point (BRISK)  |

Source: [HELCOM Map and Data
Service](http://metadata.helcom.fi/geonetwork/srv/eng/catalog.search#/metadata/6a0c8a15-3ff0-48e3-a878-0aa388122867)
<br/> Downloaded 13 July 2020 by Andrea De Cervo

<br/>

### 2.2 Centralization & Normalization

#### 2.2.1 Zostera marina shapefile

We will only explore the dataset chosen by BHI 1.0 (Alternative 4),
unless new available better data.

``` r
# library(readr)
library(raster)
# load all raw data (containing the newest data)
macrophytes <- sf::st_read(file.path(
  dir_rawdata, "Join_macrophytes_20200713",
  "Join_macrophytes.shp"
))
```

Reading layer `Join_macrophytes' from data
source`/Users/andreadecervo/github/bhi-data/BHI
2.0/Goals/CS/Join\_macrophytes\_20200713/Join\_macrophytes.shp’ using
driver \`ESRI Shapefile’ Simple feature collection with 51300 features
and 24 fields geometry type: POLYGON dimension: XY bbox: xmin: 4e+06
ymin: 2800000 xmax: 5900000 ymax: 5500000 CRS: 3035

``` r
## extent:
extent(macrophytes)
```

class : Extent xmin : 4e+06 xmax : 5900000 ymin : 2800000 ymax : 5500000

``` r
# xmin        : 4e+06 
# xmax        : 5900000 
# ymin        : 2800000 
# ymax        : 5500000 

bhi <- sf::st_read(file.path(
  dir_A, "Shapefiles", "BHI_shapefile",
  "BHI_shapefile.shp"
))
```

Reading layer `BHI_shapefile' from data
source`/Users/andreadecervo/github/bhi-data/Shapefiles/BHI\_shapefile/BHI\_shapefile.shp’
using driver \`ESRI Shapefile’ Simple feature collection with 42
features and 6 fields geometry type: MULTIPOLYGON dimension: XY bbox:
xmin: 9.420778 ymin: 53.60164 xmax: 30.34708 ymax: 65.90708 CRS: 4326

``` r
## extent:
extent(bhi)
```

class : Extent xmin : 9.420778 xmax : 30.34708 ymin : 53.60164 ymax :
65.90708

``` r
# xmin       : 9.420778 
# xmax       : 30.34708 
# ymin       : 53.60164 
# ymax       : 65.90708 

seagrass_meadows <- sf::st_read(file.path(
  dir_rawdata, "Seagrass_meadows_point_(BRISK)_20200713",
  "Seagrass meadows point BRISK.shp"
))
```

Reading layer `Seagrass meadows point BRISK' from data
source`/Users/andreadecervo/github/bhi-data/BHI
2.0/Goals/CS/Seagrass\_meadows\_point\_(BRISK)\_20200713/Seagrass
meadows point BRISK.shp’ using driver \`ESRI Shapefile’ Simple feature
collection with 1917 features and 2 fields geometry type: POINT
dimension: XY bbox: xmin: 4213701 ymin: 3424054 xmax: 5331130 ymax:
4317448 CRS: 3035

``` r
## extent:
extent(seagrass_meadows)
```

class : Extent xmin : 4213701 xmax : 5331130 ymin : 3424054 ymax :
4317448

``` r
# xmin       : 4213701 
# xmax       : 5331130 
# ymin       : 3424054 
# ymax       : 4317448 
```

<br/>

``` r
## inspect BHI regions ----
# bhi <- sf::st_read(file.path(dir_A, "Shapefiles", "BHI_shapefile", "BHI_shapefile.shp"))
bhi <- rgdal::readOGR(dsn = path.expand(file.path(dir_A, "Shapefiles", "BHI_shapefile")),
                      layer = 'BHI_shapefile') 
```

OGR data source with driver: ESRI Shapefile Source:
“/Users/andreadecervo/github/bhi-data/Shapefiles/BHI\_shapefile”,
layer: “BHI\_shapefile” with 42 features It has 6 fields

``` r
# bhi # coord. ref. : +proj=longlat
## explore/plot
# plot(bhi) #takes ~15 seconds
# bhi@data
head(bhi@data)
```

rgn\_nam rgn\_key Subbasin HELCOM\_ID BHI\_ID Area\_km2 0 Denmark DNK
Arkona Basin SEA-006 12 6272.534 1 Denmark DNK Bay of Mecklenburg
SEA-005 9 1144.293 2 Denmark DNK Bornholm Basin SEA-007 15 7152.798 3
Denmark DNK Great Belt SEA-002 3 10369.113 4 Denmark DNK Kattegat
SEA-001 2 15300.700 5 Denmark DNK Kiel Bay SEA-004 7
1208.876

``` r
# macrophytes <- sf::st_read(file.path(dir_rawdata, "Join_macrophytes_20200713", "Join_macrophytes.shp"))
macrophytes <- rgdal::readOGR(dsn = path.expand(file.path(dir_rawdata, "Join_macrophytes_20200713")),
                      layer = 'Join_macrophytes')
```

OGR data source with driver: ESRI Shapefile Source:
“/Users/andreadecervo/github/bhi-data/BHI
2.0/Goals/CS/Join\_macrophytes\_20200713”, layer: “Join\_macrophytes”
with 51300 features It has 24 fields

``` r
# mpa # coord. ref. : +proj=laea

## plot
# plot(macrophytes) # quick
# head(macrophytes@data)

## transform bhi to macrophytes coordinate reference system (CRS) ----
## LAEA: http://spatialreference.org/ref/epsg/etrs89-etrs-laea/
## https://www.nceas.ucsb.edu/~frazier/RSpatialGuides/OverviewCoordinateReferenceSystems.pdf
bhi_transf <- spTransform(bhi, macrophytes@proj4string)
# bhi # coord. ref. : +proj=laea

raster::extent(bhi_transf)
```

class : Extent xmin : 4283762 xmax : 5442611 ymin : 3397830 ymax :
4818369

``` r
# xmin        : 4283762 
# xmax        : 5442611 
# ymin        : 3397830 
# ymax        : 4818369 

## save transformed shapefile
#writeOGR(bhi_transf, dsn = path.expand(dir_intermediate), layer = 'bhi_transf', driver = 'ESRI Shapefile', overwrite = TRUE) 
```

<br/>

#### 2.2.2 Intersect the BHI shapefiles and zostera data

**Problem**: The area listed in the Zostera file only contained the
location of each sampling point, but not the area of vegetation
coverage. The area data seems to be the total area of the BHI region.
Therefore, we can’t calculate the total area of Zostera as planned.

<br/>

## 3\. Prep: Wrangling & Derivations, Checks/Evaluation, Gapfilling

``` r
## previously created in 'data/CS/v2019/ao_data.R' script
cs_rawdata <- sf::st_read(file.path(
  dir_intermediate, "cs_bhi_intersect.shp"
))
st_geometry(cs_rawdata) <- NULL
```

<br/>

## 4\. Status

Zostera new shape file explore:

  - 10km grid cell
  - field description:

0 = no observations 1 = present before year 1995 or in 1995 2 = present
after year 1995 3 = present before and after year 1995

Expert opinion (Christoffer Boström) suggested that no growth of Zostera
sp naturally occurs in these BHI ID regions: 12, 15, 17, 19, 21, 22, 23,
24, 37, 38, 39, 40, 41, 42, and were left as NA in this analysis.

**Status**

``` r
cs_status <- cs_rawdata %>% 
  dplyr::select(rgn_id = BHI_ID, country = rgn_nam, zostera = Z_marina) %>% 
  mutate(helcom_score = ifelse(zostera == 2, 100, zostera/3*100)) %>% # if zostera = 2, set score to 100
  group_by(rgn_id) %>% 
  summarize(score = mean(helcom_score)) %>%
  mutate(score = round(score, 2)) %>% 
  ungroup

### identify regions with no eelgrass growth potential and set as NA
no_eelgrass <-c(12, 15, 17, 19, 21, 22, 23, 24, 37, 38, 39, 40, 41, 42)

cs_status_2 <- cs_status %>% 
  mutate(score = ifelse(rgn_id %in% no_eelgrass, NA, score)) %>% 
  dplyr::select(rgn_id, 
                score) %>% 
  mutate(dimension = "status")

# Write status as csv file
write_csv(cs_status_2, file.path(dir_layers, 'cs_status_bhi2019.csv'))

## Plot Status
cs_plot <- ggplot(cs_status_2) +
  geom_bar(aes(rgn_id, score), stat = 'identity') +
  labs(title = "CS score based on HELCOM Zostera data",
       x = "BHI region",
       y = "Score") 
  
plot_status <- cs_status_2 %>% 
  full_join(.,basin_lookup, by = c("rgn_id"= "bhi_id"))

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
  ggtitle("CS Status by Region")
```

![](cs_prep_files/figure-gfm/cs%20status%20calculation-1.png)<!-- -->

<br/>

## 5\. Trend

**Trend** Trend will be NA for all regions.

## 6\. References
