Livelihoods and Economies (LE) - Livelihoods (LIV) Subgoal Data Preparation
================

-   [1. Background](#background)
    -   [1.1 Goal Description](#goal-description)
    -   [1.2 Model & Data](#model-data)
    -   [1.3 Reference points](#reference-points)
    -   [1.4 Other information](#other-information)
-   [2. Data](#data)
    -   [2.1 Datasets with Sources](#datasets-with-sources)
    -   [2.2 Centralization & Normalization](#centralization-normalization)
    -   [2.3 Initial Data Exploration](#initial-data-exploration)
-   [3. Prep: Wrangling & Derivations, Checks/Evaluation, Gapfilling](#prep-wrangling-derivations-checksevaluation-gapfilling)
    -   [3.1 Spatial Data](#spatial-data-1)
    -   [3.2 Clean and Merge Employment Rate Data: standardize units, rename fields/variables](#clean-and-merge-employment-rate-data-standardize-units-rename-fieldsvariables)
    -   [3.3 Clean Population Data: standardize units, rename fields/variables](#clean-population-data-standardize-units-rename-fieldsvariables-1)
    -   [3.4 Wrangle and Save LIV data Layers](#wrangle-and-save-liv-data-layers)
-   [4. Visualizing Data Layers](#visualizing-data-layers)
-   [5. Considerations for `BHI3.0`](#considerations-for-bhi3.0)
-   [6. References](#references)

1. Background
-------------

### 1.1 Goal Description

The Livelihoods sub-goal describes livelihood quantity and quality for people living on the coast. Livelihoods includes the number of jobs in different marine related sectors. Ideally, this sub-goal would speak to the quality and quantity of marine jobs in an area. It would encompass all the marine sectors that supply jobs and wages to coastal communities, incorporating information on the sustainability of different sectors while also telling about the working conditions and job satisfaction.

Due to an earlier lack of sector-specific employment information, the BHI currently uses overall employment rates in the Baltic coastal regions to represent ocean-dependent livelihood. The assumption being that relative employment rates in marine sectors mirror those in the regions' economies overall. Subsequent iterations of the BHI will use Blue Growth Report employment data, to more accurately represent the societal value derived from marine livelihoods in the Baltic Sea.

### 1.2 Model & Data

We downloaded [Eurostat country-level employment rate and target employment rate](http://ec.europa.eu/eurostat/tgm/table.do?tab=table&init=1&plugin=0&language=en&pcode=t2020_10&tableSelection=1) from most recent years and select a subset of years based on years included in ECO status, which is based on the Blue Growth reports. (This data is not available for Russia. [Another dataset is downloaded with information for Russia.](http://appsso.eurostat.ec.europa.eu/nui/show.do?dataset=naida_10_pe&lang=en))

Regional employment numbers are derived using NUTS2 eployment rates and population density information: NUTS2 employment percentages are multiplied by the population in the 25km inland buffer associated with a BHI region. These employment numbers are summed across all areas (NUTS2 regions intersected with BHI regions) associated with a BHI region to get the total employed people in the BHI region. Regional employment rate = number of people employed/regional population. For country data, we have employment rate data directly.

### 1.3 Reference points

Reference point is max Region:Country employment ratio of the past five years, and highest country employment in the last fifteen years (77.4%). The region-to-country ratio puts the value into local context, then adjusting with respect to highest country employment rate in the last fifteen years from around the Baltic Sea situates the ratio in broader geographic context.

### 1.4 Other information

External advisors/goalkeepers: Wilfried Rickels.

<br/>

2. Data
-------

This prep document is used to generate and explore the following data layers:

-   `le_liv_coastal_employ_bhi2019.csv`
-   `le_liv_coastal_pop_bhi2019.csv`
-   `le_liv_national_pop_bhi2019.csv`

These are saved to the `layers` folder. Saved to `data/LIV/v2019/intermediate` are intermediate datasets: `rgn_coastalpop_bhi2019.csv` and `DATASETINTEMED2.csv`. All these are derived from or informed by the raw datasets from Eurostat employment rates and population change, and population densities from the [HYDE database](https://themasites.pbl.nl/tridion/en/themasites/hyde/).

<br>

### 2.1 Datasets with Sources

<br/>

#### 2.1.1 EuroStat Data

**Employment rates by sex, age and NUTS 2 regions % (lfst\_r\_lfe2emprt)** <!-- dataset save location BHI_share/BHI 2.0/Goals/LE/LIV/Employment_NUTS2/lfst_r_lfe2emprt_2019_w_nutscodes -->

| Option           | Specification                              |
|:-----------------|:-------------------------------------------|
| TIME:            | 1999-2019                                  |
| AGE:             | Y15-74 (code) From 15 to 64 years (label)  |
| GEO:             | NUTS2 (Filtering - Nuts level) SHOW: CODES |
| SEX:             | Total                                      |
| Unit of measure: | Percentage                                 |

<br/>

The source for the regional labour market information down to NUTS level 2 is the EU Labour Force Survey (EU-LFS). This is a quarterly household sample survey conducted in all Member States of the EU and in EFTA and Candidate countries.

The EU-LFS survey follows the definitions and recommendations of the International Labour Organisation (ILO). To achieve further harmonization, the Member States also adhere to common principles when formulating questionnaires. The LFS' target population is made up of all persons in private households aged 15 and over. For more information see the EU Labour Force Survey (lfsi\_esms, see paragraph 21.1.).

The EU-LFS is designed to give accurate quarterly information at national level as well as annual information at NUTS 2 regional level and the compilation of these figures is well specified in the regulation. Microdata including the NUTS 2 level codes are provided by all the participating countries with a good degree of geographical comparability, which allows the production and dissemination of a complete set of comparable indicators for this territorial level.

-   b break in time series
-   c confidential
-   d definition differs, see metadata
-   e estimated
-   f forecast
-   i see metadata (phased out)
-   n not significant
-   p provisional
-   r revised
-   s Eurostat estimate (phased out)
-   u low reliability
-   z not applicable

<br/>

**Population change - Demographic balance and crude rates at regional level (NUTS 2), Filter to NUTS2 Level** <!-- dataset save location BHI_share/2.0/Goals/LE/LIV/Population_Jan1/demo_r_gind3_2019_w_nutscodes -->

| Option                             | Specification                              |
|:-----------------------------------|:-------------------------------------------|
| TIME (Years):                      | 2000-2019                                  |
| GEO:                               | NUTS2 (Filtering - Nuts level) SHOW: CODES |
| INDIC\_DE (Demographic Indicator): | Population on 1 January - total (JAN)      |

<br/>

Summary explanation about indicator: Eurostat aims at collecting from the EU-28's Member States' data on population on 31st December, which is further published as 1 January of the following year. The recommended definition is the 'usual resident population' and represents the number of inhabitants of a given area on 31st December. However, the population transmitted by the countries can also be either based on data from the most recent census adjusted by the components of population change produced since the last census, either based on population registers.

<br/>

**Employment and population (subset to data for Russia)**
<!-- dataset save location BHI_share/2.0/Goals/LE/LIV/Pop_Employ_Russia_2019 -->

<table>
<caption>Source: <a href="http://appsso.eurostat.ec.europa.eu/nui/show.do?dataset=naida_10_pe&amp;lang=en">eurostat database</a> <br/> Downloaded 21 July, 2020 by Andrea De Cervo</caption>
<colgroup>
<col width="7%" />
<col width="92%" />
</colgroup>
<thead>
<tr class="header">
<th align="left">Option</th>
<th align="left">Specification</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left">Years:</td>
<td align="left">1990-2019</td>
</tr>
<tr class="even">
<td align="left">NA_ITEM:</td>
<td align="left">Total population national concept (POP_NC), Employees domestic concept (SAL_DC), Total employment domestic concept (EMP_DC)</td>
</tr>
<tr class="odd">
<td align="left">GEO:</td>
<td align="left">RU Russia</td>
</tr>
<tr class="even">
<td align="left">Unit:</td>
<td align="left">Thousand persons (THS_PER)</td>
</tr>
</tbody>
</table>

<br/>

**Population change - Demographic balance and crude rates at regional level (NUTS 3), Filter to NUTS3 Level** <!-- dataset save location BHI_share/2.0/Goals/LE/LIV/Population_NUTS3/demo_r_pjangrp3_w_nutscodes -->

| Option        | Specification                              |
|:--------------|:-------------------------------------------|
| TIME (Years): | 2014-2019                                  |
| GEO:          | NUTS3 (Filtering - Nuts level) SHOW: CODES |

<br/>

**Employment rate** <!-- dataset save location BHI_share/2.0/Goals/LE/LIV/Employment_NUTS3 -->

Data were extracted from the [EU Blue Economy report](https://ec.europa.eu/maritimeaffairs/sites/maritimeaffairs/files/2020_06_blueeconomy-2020-annexes-ld-part1_final.pdf) for each Baltic country.

#### 2.1.2 HYDE Database

**Population density data**
<!-- dataset save location BHI_share/2.0/Goals/LE/LIV/GriddedPop_2016AD --> <!-- ftp://ftp.pbl.nl/hyde/ -->

| Option                       | Specification                             |
|:-----------------------------|:------------------------------------------|
| Proceed to the FTP-server to | download the datasets                     |
| Connect as                   | Guest                                     |
| Index:                       | hyde/hyde3.2/2017\_beta\_release/001/zip/ |
| Name:                        | 2016AD\_pop.zip                           |

<br/>

Year of data = 2005. Data were a 5' resolution. Population density within a 25km buffer from the coast will be used.

<br/>

### 2.2 Centralization & Normalization

Summary of steps/analysis in this document:

**Wrangling of Spatial Assessment Units** - intersect BHI 25km buffer (coastal area) with NUTS2 (reporting areas in Eurostat employment and population data) - review spatial units used in the analysis

**Clean Employment Rates Data** - check and remove dataflags - clean and visualize NUTS2 employment data - explore reporting NUTS2 regions, check whether need spatial corrections based on time-period/diff. versions of NUTS2

**Clean/Create Coastal Population Data** - clean and visualize NUTS2 population data - corrections for Finland data-- different regions used than included in the raw data... - corrections for Lithuania... - calculate population in buffer-NUTS2 polygons as average pop per km2 times buffer-NUTS2 polygon area

**Derive and save Numbers Employed per BHI Region & Country** - calculate number employed (in polygons from BHI buffer-NUTS2 intersection) as the population in the polygon times the relevant NUTS2 employment rate - sum number employed in BHI buffer-NUTS2 polygons across each BHI region, to get coastal employed per BHI region - sum population in BHI buffer-NUTS2 polygons across each BHI region, to get coastal population per BHI region - divide coastal employed per BHI region by coastal population per BHI region, to get BHI region coastal employment rate - clean and visualize derived coastal population and employment data by BHI region

#### 2.2.1 Spatial Data

[Eurostat NUTS regions shapefiles can be found here](https://ec.europa.eu/eurostat/web/gisco/geodata/reference-data/administrative-units-statistical-units/nuts). The NUTS 2016, 2013, 2010, 2006, and 2003 were downloaded at 1:10 million resolution (NUTS\_RG\_10M\_year\_4326\_LEVL\_2or3 files within the zipped downloads are the polygons in espg 4326 projection).

``` r
##  NUTS2 shapefiles
## using level 2 but also have level 3 NUTS if those are better?
nutsshpfiles <- grep(
  "NUTS_RG_10M_[0-9]{4}_4326_LEVL_2/.*\\.shp", 
  list.files(file.path(dirname(dir_B), "Shapefiles", "all_NUTS_shapefiles"), recursive = TRUE),
  value = TRUE
)
for(f in nutsshpfiles){
  ## gives GDAL Errors / CPL_read_ogr warnings, but reads in the shapefile...
  shp <- sf::st_read(
    dsn = file.path(dirname(dir_B), "Shapefiles", "all_NUTS_shapefiles", stringr::str_extract(f, "ref.*LEVL_2(?=/)")),
    stringsAsFactors = FALSE
  )
  shp_baltic <- shp %>% filter(CNTR_CODE %in% c("SE", "FI", "EE", "LV", "LT", "PL", "DE", "DK"))
  assign(sprintf("nuts2_%s_shp", stringr::str_extract(f, "(?<=10M_)[0-9]{4}")), shp_baltic)
}
```

Reading layer `NUTS_RG_10M_2003_4326_LEVL_2' from data source`/Users/eleanorecampbell/Desktop/GitHub/bhi-data/Shapefiles/all\_NUTS\_shapefiles/ref-nuts-2003-10m-shp/NUTS\_RG\_10M\_2003\_4326\_LEVL\_2' using driver `ESRI Shapefile' Simple feature collection with 313 features and 5 fields geometry type:  MULTIPOLYGON dimension:      XY bbox:           xmin: -63.09557 ymin: -21.38731 xmax: 55.83677 ymax: 71.17472 epsg (SRID):    4326 proj4string:    +proj=longlat +datum=WGS84 +no_defs Reading layer`NUTS\_RG\_10M\_2006\_4326\_LEVL\_2' from data source `/Users/eleanorecampbell/Desktop/GitHub/bhi-data/Shapefiles/all_NUTS_shapefiles/ref-nuts-2006-10m-shp/NUTS_RG_10M_2006_4326_LEVL_2' using driver`ESRI Shapefile' Simple feature collection with 318 features and 5 fields geometry type: MULTIPOLYGON dimension: XY bbox: xmin: -63.09624 ymin: -21.38731 xmax: 55.83498 ymax: 71.17089 epsg (SRID): 4326 proj4string: +proj=longlat +datum=WGS84 +no\_defs Reading layer `NUTS_RG_10M_2010_4326_LEVL_2' from data source`/Users/eleanorecampbell/Desktop/GitHub/bhi-data/Shapefiles/all\_NUTS\_shapefiles/ref-nuts-2010-10m-shp/NUTS\_RG\_10M\_2010\_4326\_LEVL\_2' using driver `ESRI Shapefile' Simple feature collection with 316 features and 5 fields geometry type:  MULTIPOLYGON dimension:      XY bbox:           xmin: -63.08829 ymin: -21.38731 xmax: 55.83663 ymax: 71.17308 epsg (SRID):    4326 proj4string:    +proj=longlat +datum=WGS84 +no_defs Reading layer`NUTS\_RG\_10M\_2013\_4326\_LEVL\_2' from data source `/Users/eleanorecampbell/Desktop/GitHub/bhi-data/Shapefiles/all_NUTS_shapefiles/ref-nuts-2013-10m-shp/NUTS_RG_10M_2013_4326_LEVL_2' using driver`ESRI Shapefile' Simple feature collection with 320 features and 5 fields geometry type: MULTIPOLYGON dimension: XY bbox: xmin: -63.08826 ymin: -21.38731 xmax: 55.83663 ymax: 71.17354 epsg (SRID): 4326 proj4string: +proj=longlat +datum=WGS84 +no\_defs Reading layer `NUTS_RG_10M_2016_4326_LEVL_2' from data source`/Users/eleanorecampbell/Desktop/GitHub/bhi-data/Shapefiles/all\_NUTS\_shapefiles/ref-nuts-2016-10m-shp/NUTS\_RG\_10M\_2016\_4326\_LEVL\_2' using driver \`ESRI Shapefile' Simple feature collection with 332 features and 8 fields geometry type: MULTIPOLYGON dimension: XY bbox: xmin: -63.08825 ymin: -21.38917 xmax: 55.83616 ymax: 71.15304 epsg (SRID): 4326 proj4string: +proj=longlat +datum=WGS84 +no\_defs

``` r
## 25km inland buffer for BHI regions
buffer_25km_inland <- st_read(
  file.path(dirname(dir_B), "Shapefiles", "BHI_shapefile_25km_buffer"),
  "BHI_shapefile_25km_buffer"
)
```

Reading layer `BHI_shapefile_25km_buffer' from data source`/Users/eleanorecampbell/Desktop/GitHub/bhi-data/Shapefiles/BHI\_shapefile\_25km\_buffer' using driver \`ESRI Shapefile' Simple feature collection with 42 features and 8 fields geometry type: MULTIPOLYGON dimension: XY bbox: xmin: 9.19595 ymin: 53.37681 xmax: 30.5719 ymax: 66.13191 epsg (SRID): 4326 proj4string: +proj=longlat +datum=WGS84 +no\_defs

``` r
buffer_25km_inland <- cbind(
  buffer_25km_inland,
  buffer_area_km2 = as.numeric(sf::st_area(buffer_25km_inland)/(1000^2))
)


## create some spatial objects for making maps later
buffer_25k_simple <- rmapshaper::ms_simplify(input = buffer_25km_inland) %>% sf::st_as_sf()

basemap <- ggplot2::ggplot(rnaturalearth::ne_countries(scale = "medium", returnclass = "sf")) +
  geom_sf(size = 0.1, color = "burlywood", alpha = 0.4) +
  theme(panel.background = element_rect(fill = "#F8FBFC", color = "#E2EEF3")) +
  scale_x_continuous(limit = c(4, 32)) +
  scale_y_continuous(limit = c(53.5, 66)) 
```

<br>

#### 2.2.2 Clean Employment Rates Data: standardize units, rename fields/variables

``` r
rgn_employ_clean <- regional_employ %>%
  select(
    year = TIME, nuts2 = GEO,
    unit = UNIT, value = Value, 
    flag_notes = Flag.and.Footnotes
  ) %>% 
  mutate(
    flag_notes = case_when(
      flag_notes == "b" ~ "break in timeseries",
      flag_notes == "u" ~ "low reliability",
      flag_notes == "bu" ~ "break in timeseries and low reliability",
      !flag_notes %in% c("b", "u", "bu") ~ ""
    )
  )

## check dataflags
# unique(rgn_employ_clean$flag_notes)
# filter(rgn_employ_clean, flag_notes == "low reliability") # not Baltic country
# filter(rgn_employ_clean, flag_notes == "break in timeseries and low reliability") # not Baltic country
# filter(rgn_employ_clean, flag_notes == "break in timeseries") # not such a concern

## remove flags_notes
rgn_employ_clean <- rgn_employ_clean %>% 
  select(-flag_notes, -unit) %>% 
  mutate(value = ifelse(value == ":", NA, value)) %>% 
  mutate(value = as.numeric(value)) %>% 
  filter(substr(nuts2, 1, 2) %in% c("SE", "FI", "EE", "LV", "LT", "PL", "DE", "DK"))
# summary(rgn_employ_clean$value)
```

**Join employment info with NUTS2 shapefiles**

![](liv_prep_files/figure-markdown_github/join%20employ%20data%20with%20nuts2%20shapefile-1.png)

<br>

**Check NUTS2 regions alignment with reported Employment Data**

For Finland NUTS2 version 2016 works for employment data after and including 2005. Because of this we will keep and use only employment data from 2005 onwards.

Missing rates for Lithuania before 2013-- reported for LT00 which includes LT01 and LT02. Will assign to LT01 and LT02 the same employment rate reported for LT00 for years before 2013.

For Denmark, don't have pop data by nuts2016 level2 reporting regions before 2007. Changes are small though - population overall increases less than 1% from 2007 to 2005 (5447084 in 2007 and 5411405 in 2005). Will use ratios between country populations in different years to approximate regional population for 2005 and 2006.

``` r
## fix rgn_employ_clean to address these issues and then recreate rgn_employ_nuts_spatial 
rgn_employ_clean <- rbind(
  rgn_employ_clean %>% 
    filter(!(year %in% 2005:2012 & nuts2 %in% c("LT00", "LT01", "LT02"))) %>% 
     filter(!(year %in% 2005:2007 & substr(nuts2, 1, 2) == "DK")) %>%
    filter(year >= 2005), 
  ## Lithuania before 2013: give regions the overal employment rate
  as_tibble(rgn_employ_clean) %>% 
    filter(year %in% 2005:2012, nuts2 == "LT00") %>% 
    mutate(nuts2 = list(c("LT00", "LT01", "LT02"))) %>% 
    tidyr::unnest(cols = c(nuts2)) %>% 
    data.frame(),
  ## approximated regional employment rates for denmarks nuts2 regions, for 2005 and 2006
  rgn_employ_clean %>% 
    filter(year %in% 2005:2007 & substr(nuts2, 1, 2) == "DK") %>% 
    tidyr::pivot_wider(names_from = year, values_from = value) %>% 
    mutate(
      `2005` = `2007`*(75.9/77), 
      `2006` = `2007`*(77.4/77)
    ) %>%
    tidyr::pivot_longer(cols = 2:4, names_to = "year", values_to = "value")
)

nuts2_employ <- tidyr::pivot_wider(
  rgn_employ_clean, 
  names_from = year, names_prefix = "emp_", 
  values_from = value
)
```

<br>

#### 2.2.3 Clean Population Data: standardize units, rename fields/variables

``` r
## regional employment per NUTS2 assessemnt areas, raw data from eurostat
regional_pop_data <- file.path(
    dir_rawdata, "Population_Jan1", 
    "demo_r_gind3", 
    "demo_r_gind3_1_Data.csv"
  )
regional_pop <- read.csv(
  regional_pop_data, 
  stringsAsFactors = FALSE
)
```

``` r
rgn_pop_clean <- regional_pop %>%
  dplyr::select(
    year = TIME, nuts2 = GEO,
    value = Value,
    flag_notes = Flag.and.Footnotes
  ) %>%
  mutate(
    value = as.numeric(stringr::str_remove_all(value, ",")),
    flag_notes = case_when(
      flag_notes == "b" ~ "break in timeseries",
      flag_notes == "u" ~ "low reliability",
      flag_notes == "bu" ~ "break in timeseries and low reliability",
      !flag_notes %in% c("b", "u", "bu") ~ ""
    )
  )

## check dataflags
# unique(rgn_pop_clean$flag_notes)

## no rows "low reliability" or "break in timeseries and low reliability"
## breaks in timeseries a concern?
# filter(rgn_pop_clean, flag_notes == "break in timeseries")

## remove flags_notes
rgn_pop_clean <- rgn_pop_clean %>% 
  dplyr::select(-flag_notes) %>% 
  filter(substr(nuts2, 1, 2) %in% c("SE", "FI", "EE", "LV", "LT", "PL", "DE", "DK"))
# summary(rgn_pop_clean$value)
```

**Join population info with NUTS2 shapefiles**

![](liv_prep_files/figure-markdown_github/join%20pop%20data%20with%20nuts2%20shapefile-1.png)

**Check NUTS2 regions alignment with reported Population Data**

For Denmark, don't have pop data by nuts2016 level2 reporting regions before 2007. Changes are small though - population overall increases less than 1% from 2007 to 2005 (5447084 in 2007 and 5411405 in 2005). Will use ratios between country populations in different years to approximate regional population for 2005 and 2006.

Population data for Lithuania, as for employment data, is reported at the country level before 2013. Will use LT0 values to derive population estimates in each LT01 and LT02 for year 2005-2012, based on the relative proprtions in LT01 and LT02 in 2013...

``` r
rgn_pop_clean <- rbind(
  rgn_pop_clean %>% 
    filter(!(year %in% 2005:2007 & substr(nuts2, 1, 2) == "DK")) %>% 
    filter(!(year %in% 2005:2013 & substr(nuts2, 1, 2) == "LT")) %>% 
    filter(year >= 2005),
  ## approximated regional pops for denmarks nuts2 regions, for 2005 and 2006
  rgn_pop_clean %>% 
    filter(year %in% 2005:2007 & substr(nuts2, 1, 2) == "DK") %>% 
    tidyr::pivot_wider(names_from = year, values_from = value) %>% 
    mutate(
      `2005` = `2007`*(5411405/5447084), 
      `2006` = `2007`*(5427459/5447084)
    ) %>%
    tidyr::pivot_longer(cols = 2:4, names_to = "year", values_to = "value"),
  ## approximate regional pops for lithuania nuts2 regions, for 2005-2012
  rgn_pop_clean %>% 
    filter(year %in% 2005:2013 & substr(nuts2, 1, 2) == "LT") %>%
    tidyr::pivot_wider(names_from = year, values_from = value) %>% 
     mutate(
       `2005` = `2013`*(3355220/2971905),        
       `2006` = `2013`*(3289835/2971905),
       `2007` = `2013`*(3249983/2971905),
       `2008` = `2013`*(3212605/2971905),
       `2009` = `2013`*(3183856/2971905),
       `2010` = `2013`*(3141976/2971905),
       `2011` = `2013`*(3052588/2971905),
       `2012` = `2013`*(3003641/2971905)
     ) %>%
    tidyr::pivot_longer(cols = 2:10, names_to = "year", values_to = "value")
)

nuts2_pop <- tidyr::pivot_wider(
  rgn_pop_clean,
  names_from = year, names_prefix = "pop_", 
  values_from = value
)
```

<br>

#### 2.2.4 BHI Region Employment Rates and Coastal Populations

A BHI region's coastal employment rate is derived from populations and employment rates reported for the NUTS2 regions that overlap with the BHI region's coastal zone -- the area between the waters edge and 25km inland. The calculation assumes uniform population density and employment rates across NUTS2 regions. The BHI region's coastal employment rate is estimated as follows:

$$BHIempl.rate = \\frac{BHIcoast.empl.num}{BHIcoast.pop} = \\frac{\\sum\_{buffNUTS2}(buffNUTS2.coast.pop \\times NUTS2empl.rate) }{\\sum\_{buffNUTS2}{buffNUTS2.coast.pop}}$$

$$buffNUTS2.coast.pop = \\frac{NUTS2pop}{NUTS2area}\\times buffNUTS2.area$$

*b**u**f**f**N**U**T**S*2 = polygons within the given BHI region, created by intersecting the BHI region with NUTS2 polygons

The below code will calculate in order:

1.  average population density over NUTS2 regions
2.  population in each of intersected buffer-NUTS2 polygons, using polygon area and the average population density
3.  coastal employment estimate (number of employed) in each of the intersected buffer-NUTS2 polygons
4.  estimated total coastal population in BHI region, as sum of pops in intersected buffer-NUTS2 polygons per BHI rgn
5.  estimated total coastal employment (number of employed) per BHI region
6.  coastal employment rate in BHI regions

**Join NUTS2 Data (Employ and Pop) with NUTS2 Spatial Information**

``` r
nuts2_2016_shp <- cbind(
  nuts2_2016_shp,
  ## calculate area of NUTS2 regions in 2016 version
  ## convert area to sq km, also convert class from units to numeric
  nuts2_area_km2 = as.numeric(sf::st_area(nuts2_2016_shp)/(1000^2))
) 

nuts2spatial_popdensity_employ <- nuts2_2016_shp %>% 
  sf::st_transform(crs = 4326) %>% 
  rename(nuts2 = NUTS_ID) %>% 
  left_join(nuts2_employ, by = "nuts2") %>% 
  left_join(nuts2_pop, by = "nuts2") %>% 
  ## get average population density from nuts population and areas
  ## population per km2 in 2016 nuts2
  mutate_at(vars(starts_with("pop")), function(x){x/.$nuts2_area_km2})
```

**NUTS Regions with Data, Intersected with BHI 25km Inland Buffer**

![](liv_prep_files/figure-markdown_github/intersect%20relevant%20NUTS2%20polygons%20and%20BHI%2025km%20inland%20buffer-1.png)

<br>

``` r
## combine population and employment and calculate info for intersected polygons
coastal_pop_employ_combine <- nuts2_bhibuff_polys %>% 
  st_drop_geometry() %>% 
  select(nuts2, nuts2_area_km2, starts_with("pop"), starts_with("emp"), bhi_id = BHI_ID, area_km2) %>% 
  
  ## calculate population of intersected polygons
  ## note: using mutate_at, the pop vars now represent populations of the intersected polygons!
  mutate_at(vars(starts_with("pop")), function(x){x*.$area_km2}) %>% 
  tidyr::pivot_longer(cols = matches("[a-z]{3}_[0-9]{4}")) %>% 
  mutate(year = as.numeric(substr(name, 5, 8)), name = substr(name, 1, 3)) %>% 
  tidyr::pivot_wider(names_from = name, values_from = value) %>% 
  
  ## calculate coastal employment in each of the intersected buffer-NUTS2 polygons
  mutate(num_employed = emp/100*pop)
  

## calculate coastal employment and coastal population for BHI regions!
coastal_employ_bhi_rgns <- coastal_pop_employ_combine %>% 
  ## sum coastal employment and coastal population by BHI ID
  ## will use these two vars to get coastal employment rate per BHI region
  group_by(bhi_id, year) %>% 
  summarise(
    coastal_pop = sum(pop), 
    coastal_employ_num = sum(num_employed)
  ) %>% 
  ungroup() %>% 
  mutate(coastal_employ_rate = coastal_employ_num/coastal_pop) %>% 
  
  ## some regions should NOT have population, employed, employment rate
  ## due to spatial intersection of less than perfectly aligned buffer and NUTS2 polygons
  ## BHI regions 19, 22, and 33 are Russia so have no eurostat data -- set to NA
  ## BHI region 30 is ocean with no significant coastline (a few tiny islands) -- set to NA
  mutate_at(
    vars(starts_with("coastal")), 
    function(x){ifelse(.$bhi_id == 19|.$bhi_id == 22|.$bhi_id == 33|.$bhi_id == 30, NA, x)}
  )

mapsf <- buffer_25k_simple %>% 
  rename(bhi_id = BHI_ID) %>% 
  left_join(filter(coastal_employ_bhi_rgns, year == 2019), by = "bhi_id") %>% 
  mutate(bhi_id = as.character(bhi_id))

basemap +
  geom_sf(
    data = mapsf,
    aes(fill = coastal_employ_rate),
    color = "snow", size = 0.3,
    show.legend = FALSE
  ) +
  scale_fill_gradient2(mid = "thistle", midpoint = 0.65, limits = c(0.45, 0.85))
```

![](liv_prep_files/figure-markdown_github/calculate%20coastal%20employment%20and%20coastal%20population-1.png)

#### 2.2.5 Save LIV Data Layers

``` r
write_csv(
  select(
    coastal_employ_bhi_rgns, 
    region_id = bhi_id,
    year,
    bhi_employ_rate = coastal_employ_rate
  ), 
  file.path(dir_layers, "le_liv_regional_employ_bhi2019.csv")
)
```

``` r
natl_employ_rates <- left_join(
  rgn_employ_clean %>%
    filter(stringr::str_length(nuts2) == 2) %>% 
    rename(eez = nuts2, employ_pop = value),
  read_csv(file.path(dir_prep, "supplement",  "lookup_tabs", "rgns_complete.csv")) %>% 
    select(eez, region_id) %>% 
    mutate(eez = case_when(
      eez == "Sweden" ~ "SE",
      eez == "Finland" ~ "FI",
      eez == "Estonia" ~ "EE",
      eez == "Latvia" ~ "LV",
      eez == "Lithuania" ~ "LT",
      eez == "Poland" ~ "PL",
      eez == "Denmark" ~ "DK",
      eez == "Germany" ~ "DE",
      eez == "Denmark" ~ "DK",
      eez == "Russia" ~ "RU"
    )),
  by = "eez"
)

#write_csv(
#  select(natl_employ_rates, region_id, year, employ_pop),
#  file.path(dir_layers, "le_liv_national_employ_bhi2019.csv")
#)
```

``` r
write_csv(
  select(
    coastal_employ_bhi_rgns, 
    region_id = bhi_id,
    year,
    coastal_pop
  ), 
  file.path(dir_prep, "data", "LIV", version_year, "intermediate", "le_coastal_pop_bhi2019.csv")
)
```

<br/>

### 2.3 Initial Data Exploration

#### 2.3.1 Timeseries Plots: check regional employment time series

![](liv_prep_files/figure-markdown_github/plot%20and%20check%20regional%20employment%20time%20series-1.png)

<br/>

3. Prep: Wrangling & Derivations, Checks/Evaluation, Gapfilling
---------------------------------------------------------------

#### 3.1 Spatial Data

[Eurostat NUTS regions shapefiles can be found here](https://ec.europa.eu/eurostat/web/gisco/geodata/reference-data/administrative-units-statistical-units/nuts). The NUTS 2016, 2013, 2010, 2006, and 2003 were downloaded at 1:10 million resolution (NUTS\_RG\_10M\_year\_4326\_LEVL\_2or3 files within the zipped downloads are the polygons in espg 4326 projection).

``` r
##  NUTS3 shapefiles because coastal regions are distinguished from non-coastal at this level
nutsshpfiles <- grep(
  "NUTS_RG_10M_[0-9]{4}_4326_LEVL_3/.*\\.shp", 
  list.files(file.path(dirname(dir_B), "Shapefiles", "all_NUTS_shapefiles"), recursive = TRUE),
  value = TRUE
)
## will check 2013 in cases where matching with 2016 version doesn't work
## gives GDAL Errors / CPL_read_ogr warnings, but still reads in the shapefiles...
for(f in grep("2013|2016", nutsshpfiles, value = TRUE)){
  shp <- sf::st_read(
    dsn = file.path(dirname(dir_B), "Shapefiles", "all_NUTS_shapefiles", stringr::str_extract(f, "ref.*LEVL_3(?=/)")),
    stringsAsFactors = FALSE
  )
  shp_baltic <- shp %>% filter(CNTR_CODE %in% c("SE", "FI", "EE", "LV", "LT", "PL", "DE", "DK"))
  assign(sprintf("nuts3_%s_shp", stringr::str_extract(f, "(?<=10M_)[0-9]{4}")), shp_baltic)
}

## 25km inland buffer for BHI regions
buffer_25km_inland <- sf::st_read(
  file.path(dirname(dir_B), "Shapefiles", "BHI_shapefile_25km_buffer"),
  "BHI_shapefile_25km_buffer"
)
buffer_25km_inland <- cbind(
  buffer_25km_inland,
  buffer_area_km2 = as.numeric(sf::st_area(buffer_25km_inland)/(1000^2))
)


## create some spatial objects for making maps later
buffer_25k_simple <- rmapshaper::ms_simplify(input = buffer_25km_inland) %>% sf::st_as_sf()

basemap <- ggplot2::ggplot(rnaturalearth::ne_countries(scale = "medium", returnclass = "sf")) +
  geom_sf(size = 0.1, color = "burlywood", alpha = 0.4) +
  theme(panel.background = element_rect(fill = "#F8FBFC", color = "#E2EEF3")) +
  scale_x_continuous(limit = c(4, 32)) +
  scale_y_continuous(limit = c(53.5, 66)) 
```

<br>

### 3.2 Clean and Merge Employment Rate Data: standardize units, rename fields/variables

``` r
employ_data <- do.call(rbind, lapply(
  grep("emp-rate.csv", list.files(dir_rawdata, recursive = TRUE, full.names = TRUE), value = TRUE),
  function(x){
    joindf <- read.delim(x, sep = ";")
    colnames(joindf) <- c("sector_or_metric", "2009", "2011", "2013", "2015", "2016", "2017", "2018")
    joindf <- joindf %>% 
      filter(str_length(sector_or_metric) > 0) %>% 
      tidyr::pivot_longer(
        cols = starts_with("20"), 
        names_to = "year", 
        values_to = "persons_emp_thousand"
      ) %>% 
      mutate(sector_or_metric = str_to_lower(str_replace_all(sector_or_metric, " ", "_"))) %>% 
      mutate(persons_emp_thousand = str_replace(persons_emp_thousand, ",", ".")) %>% 
      mutate(persons_emp_thousand = str_replace(persons_emp_thousand, " ", "")) %>% 
      tidyr::pivot_wider(names_from = sector_or_metric, values_from = persons_emp_thousand) %>% 
      mutate(country = str_extract(x, "(?<=NUTS3/)[a-z]+(?=_emp-rate\\.csv)"))
    return(joindf)
  }
))
```

### 3.3 Clean Population Data: standardize units, rename fields/variables

``` r
## regional employment per NUTS3 assessemnt areas, raw data from eurostat
regional_pop_data <- file.path(
    dir_rawdata, "Population_NUTS3", 
    "demo_r_pjangrp3_w_nutscodes", 
    "demo_r_pjangrp3_1_Data.csv"
  )
regional_pop <- read.csv(
  regional_pop_data, 
  stringsAsFactors = FALSE
)
```

``` r
rgn_pop_clean <- regional_pop %>%
  filter(SEX == "Total") %>% 
  dplyr::select(
    year = TIME, nuts3 = GEO,
    value = Value,
    flag_notes = Flag.and.Footnotes
  ) %>%
  mutate(
    value = as.numeric(stringr::str_remove_all(value, ",")),
    flag_notes = case_when(
      flag_notes == "b" ~ "break in timeseries",
      flag_notes == "u" ~ "low reliability",
      flag_notes == "bu" ~ "break in timeseries and low reliability",
      !flag_notes %in% c("b", "u", "bu") ~ ""
    )
  )

## check dataflags
unique(rgn_pop_clean$flag_notes)
## no rows "low reliability" or "break in timeseries and low reliability"
## breaks in timeseries a concern?
filter(rgn_pop_clean, flag_notes == "break in timeseries")

## remove flags_notes
rgn_pop_clean <- rgn_pop_clean %>% 
  dplyr::select(-flag_notes) %>% 
  filter(substr(nuts3, 1, 2) %in% c("SE", "FI", "EE", "LV", "LT", "PL", "DE", "DK"))
# summary(rgn_pop_clean$value)
# summary(filter(rgn_pop_clean, str_length(nuts3)>4)$value)
```

**Join population info with NUTS3 shapefiles**

``` r
rgn_pop_nuts_spatial <- tidyr::pivot_wider(
  rgn_pop_clean,
  names_from = year, names_prefix = "pop_", 
  values_from = value
)
rgn_pop_nuts_spatial <- nuts3_2016_shp %>% 
  sf::st_transform(crs = 4326) %>% 
  rename(nuts3 = NUTS_ID) %>% 
  left_join(rgn_pop_nuts_spatial, by = "nuts3") %>% 
  filter(COAST_TYPE %in% 1:2)

## plotting initial values, raw NUTS2 regions employment rates
## loop through all years to check population data alignment with reporting regions...
basemap + 
  geom_sf(data = rgn_pop_nuts_spatial, aes(fill = pop_2019), size = 0.1) +
  geom_sf(data = buffer_25k_simple, fill = NA, color = "red", size = 0.2) +
  scale_fill_viridis_c() +
  labs(fill = "Population") +
  theme(legend.position = c(0.15, 0.85)) +
  ggtitle("Population 2019")
```

![](liv_prep_files/figure-markdown_github/join%20pop%20data%20with%20nuts3%20shapefile-1.png)

### 3.4 Wrangle and Save LIV data Layers

``` r
rgns_complete <- read_csv(file.path(dir_prep, "supplement", "lookup_tabs", "rgns_complete.csv"))

## join bhi regions with employment rates ----
emp_lyr <- left_join(
  employ_data %>% 
    select(year, eez = country, blue_economy_pct_of_natl = `blue_economy_(%_of_national_jobs)`) %>% 
    mutate(blue_economy_pct_of_natl = str_extract(blue_economy_pct_of_natl, "[0-9]\\.[0-9]")) %>% 
    mutate(blue_economy_pct_of_natl = as.numeric(blue_economy_pct_of_natl)) %>% 
    mutate(
      eez = str_to_sentence(eez),
      year = as.numeric(year)
    ),
  rgns_complete %>% 
    select(eez, region_id, region_name) %>% 
    mutate(region_id = as.numeric(region_id)),
  by = "eez"
)
emp_lyr <- emp_lyr %>% filter(!is.na(region_id))

## join bhi regions with national coastal population ----
rgn_coast_pop <- left_join(
  rgn_pop_nuts_spatial %>% 
    st_drop_geometry() %>% 
    tidyr::pivot_longer(
      cols = starts_with("pop_"), 
      names_to = "year", names_prefix = "pop_", 
      values_to = "population"
    ) %>% 
    group_by(year, CNTR_CODE) %>% 
    summarize(natl_coastal_pop = sum(population)) %>% 
    ungroup() %>% 
    mutate(eez = case_when(
      CNTR_CODE == "SE" ~ "Sweden",
      CNTR_CODE == "FI" ~ "Finland",
      CNTR_CODE == "EE" ~ "Estonia",
      CNTR_CODE == "LV" ~ "Latvia",
      CNTR_CODE == "LT" ~ "Lithuania",
      CNTR_CODE == "PL" ~ "Poland",
      CNTR_CODE == "DE" ~ "Germany",
      CNTR_CODE == "DK" ~ "Denmark"
    )),
  rgns_complete %>% 
    select(eez, region_id, region_name),
  by = "eez"
)

## join bhi regions with national total population ----
natl_pop <- left_join(
  rgn_pop_clean %>% 
    rename(natl_population = value) %>% 
    filter(nuts3 %in% c("SE", "FI", "EE", "LV", "LT", "PL", "DE", "DK")) %>% 
    mutate(eez = case_when(
      nuts3 == "SE" ~ "Sweden",
      nuts3 == "FI" ~ "Finland",
      nuts3 == "EE" ~ "Estonia",
      nuts3 == "LV" ~ "Latvia",
      nuts3 == "LT" ~ "Lithuania",
      nuts3 == "PL" ~ "Poland",
      nuts3 == "DE" ~ "Germany",
      nuts3 == "DK" ~ "Denmark"
    )),
  rgns_complete %>% 
    select(eez, region_id, region_name),
  by = "eez"
)


## save layers ----
write_csv(
  select(emp_lyr, region_id, year, blue_economy_pct_of_natl),
  file.path(dir_layers, "le_liv_coastal_employ_bhi2019.csv")
)
write_csv(
  select(rgn_coast_pop, region_id, year, natl_coastal_pop),
  file.path(dir_layers, "le_liv_coastal_pop_bhi2019.csv")
)
write_csv(
  select(natl_pop, region_id, year, natl_population),
  file.path(dir_layers, "le_liv_national_pop_bhi2019.csv")
)
```

<br/>

4. Visualizing Data Layers
--------------------------

**If LIV Status was calculated using blue economy Employment rates**

``` r
coastal_pop_percentage <- left_join(
  rgn_coast_pop %>% 
    select(region_id, region_name, eez, year, natl_coastal_pop) %>% 
    mutate(year = as.numeric(year)),
  natl_pop %>% 
    select(region_id, region_name, eez, year, natl_population),
  by = c("region_id", "region_name", "eez", "year")
)
coastal_pop_percentage <- coastal_pop_percentage %>% 
  mutate(coastal_pop_pct = natl_coastal_pop/natl_population)

liv_status <- emp_lyr %>% 
  filter(year %in% unique(coastal_pop_percentage$year)) %>% 
  left_join(coastal_pop_percentage, by = c("region_id", "region_name", "eez", "year")) %>% 
  select(region_id, region_name, eez, year, blue_economy_pct_of_natl, coastal_pop_pct) %>% 
  mutate(coastal_emp_vs_coastal_pop = blue_economy_pct_of_natl/coastal_pop_pct)

# distinct(liv_status, eez, year, blue_economy_pct_of_natl, coastal_pop_pct, coastal_emp_vs_coastal_pop)
```

``` r
gridExtra::grid.arrange(
  ggplot(liv_status) + 
    geom_col(aes(x = year, y = blue_economy_pct_of_natl, fill = blue_economy_pct_of_natl)) +
    scale_fill_gradient(low = "grey", high = "paleturquoise") +
    facet_wrap(~region_name, labeller = label_wrap_gen(width = 15), ncol = 10) +
    labs(x = NULL, y = NULL, fill = "%", title = "Blue Econ. Empl. % of National Empl.") +
    theme(legend.direction = "horizontal", legend.position = c(0.9, 0.01), axis.text.x = element_text(angle  = 90)),
  ggplot(liv_status) + 
    geom_col(aes(x = year, y = coastal_emp_vs_coastal_pop, fill = coastal_emp_vs_coastal_pop)) +
    scale_fill_gradient(low = "grey", high = "paleturquoise") +
    facet_wrap(~region_name, labeller = label_wrap_gen(width = 15), ncol = 10) +
    labs(x = NULL, y = NULL, fill = "Ratio", title = "Blue Econ. Empl. %\n Normalized by Coastal % of National Pop.") +
    theme(legend.direction = "horizontal", legend.position = c(0.9, 0.01), axis.text.x = element_text(angle  = 90)),
  nrow = 2
)
```

![](liv_prep_files/figure-markdown_github/plot%20of%20liv%20status-1.png)

<br/>

5. Considerations for `BHI3.0`
------------------------------

In the EU Blue Growth Reports, the Blue Economy metrics by country don't distinguish between coasts i.e. Baltic vs North Sea.

Consider: should employment in marine-related sectors be normalized just by coastal/total national population, or is potential for coastal jobs more related to geography (e.g. length coastline vs total area)?

Use [Eurostat API for Administrative Units](https://ec.europa.eu/eurostat/web/gisco/geodata/reference-data/administrative-units-statistical-units) and [R package 'eurostat: Tools for Eurostat Open Data'](https://cran.r-project.org/web/packages/eurostat/index.html). See tutorial about the R package here: <https://ropengov.github.io/eurostat/articles/eurostat_tutorial.html>

[Eurostat regional yearbook 2018 &gt; Background Maps &gt; GEOSTAT population grid 2011](https://ec.europa.eu/eurostat/statistical-atlas/gis/viewer/?mids=BKGCNT,BKGPGR,CNTOVL&o=1,1,0.7&ch=BKG,C02&center=56.62571,21.14265,5&) shows how population density along coast is typically higher than inland; using pop. reported by NUTS2 or even NUTS3 spatial units to cannnot result in accurate representation of the coastal population...

6. References
-------------

[Reference Metadata in Euro SDMX Metadata Structure (ESMS)](http://ec.europa.eu/eurostat/cache/metadata/en/reg_lmk_esms.htm) Regional labour market statistics (reg\_lmk). Compiling agency: Eurostat, the statistical office of the European Union.

[Reference Metadata in Euro SDMX Metadata Structure (ESMS)](https://ec.europa.eu/eurostat/cache/metadata/en/demo_gind_esms.htm) Population change - Demographic balance and crude rates at national level (demo\_gind). Compiling agency: Eurostat, the statistical office of the European Union.

Klein Goldewijk, K. , A. Beusen, M. de Vos and G. van Drecht (2011). The HYDE 3.1 spatially explicit database of human induced land use change over the past 12,000 years, Global Ecology and Biogeography20(1): 73-86. DOI: 10.1111/j.1466-8238.2010.00587.x.

Klein Goldewijk, K. , A. Beusen, and P. Janssen (2010). Long term dynamic modeling of global population and built-up area in a spatially explicit way, HYDE 3.1. The Holocene20(4):565-573. <http://dx.doi.org/10.1177/0959683609356587>
