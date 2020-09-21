Biodiversity (BD) Goal Data Preparation
================

-   [1. Background](#background)
    -   [1.1 Goal Description](#goal-description)
    -   [1.2 Model & Data](#model-data)
    -   [1.3 Reference points](#reference-points)
    -   [1.4 Other information](#other-information)
-   [2. Data](#data)
    -   [2.1 Datasets with Sources](#datasets-with-sources)
-   [3. Prep: Wrangling & Derivations, Checks/Evaluation, Gapfilling](#prep-wrangling-derivations-checksevaluation-gapfilling)
    -   [3.1 Initial Data Wrangling/Harmonizing](#initial-data-wranglingharmonizing)
    -   [3.2 Match BHI regions by Country and/or Subbasin](#match-bhi-regions-by-country-andor-subbasin)
    -   [3.3 Waterbirds Data](#waterbirds-data)
    -   [3.4 Save Biodiversity Layers](#save-biodiversity-layers)
    -   [3.5 Biodiversity Trial Status & Trend Calculations](#biodiversity-trial-status-trend-calculations)
-   [4. Visualizing Data Layers](#visualizing-data-layers)
    -   [4.1 Bar Plots by Indicator and Overall Status](#bar-plots-by-indicator-and-overall-status)
    -   [4.2 Maps](#maps)
-   [5. Considerations for `BHI3.0`](#considerations-for-bhi3.0)
-   [6. References](#references)

<br>

``` r
source(here::here("R", "setup.R"))
source(here::here("R", "spatial.R"))
knitr::opts_chunk$set(message = FALSE, warning = FALSE, results = "hide")

loc <- here::here("prep", "BD")
dir_rawdata <- file.path(dir_B, "Goals", "BD") # change to 'ICO' folder if having permission issues 
dir_intermediate <- here::here("data", "BD", version_year, "intermediate")

bkgd_path <- here::here("supplement", "goal_summaries", "BD.Rmd")
data_path <- here::here("data", "BD", version_year, "bd_data.rmd")
refs_path <- file.path(loc, "bd_references.Rmd")
# file.exists(c(loc, bkgd_path, data_path, refs_path))
```

1. Background
-------------

### 1.1 Goal Description

This goal captures the biodiversity status of the Baltic Sea ecosystems and intactness of broad, encompassing marine habitats/zones.

### 1.2 Model & Data

This goal consists of five components: - benthic habitats - pelagic habitats - fish - mammals (seals) - seabirds

It has been evaluated using the biological quality ratios and seabird abundance, derived in the integrated biodiversity assessments from HELCOM (the HELCOM assessment tool: <https://github.com/NIVA-Denmark/BalticBOOST>). These are based on core indicators for key species and species groups, including abundance, distribution, productivity, physiological and demographic characteristics.

Statuses of these five biodiversity components are aggregated first within each component, combining coastal area values with area-weighted averages, then combining the values for coastal and offshore areas of each BHI region with equal weight. A single biodiversity status score per region is calculated as geometric mean of the five components. More detailed information on the indicators and the biodiversity assessment can be found at HELCOM (<http://stateofthebalticsea.helcom.fi/biodiversity-and-its-status/>).

### 1.3 Reference points

For the seabirds, the HELCOM core indicator threshold of 0.75 abundance, decided by HELCOM, was used as good status (corresponding to a status score of 100 in BHI). For the other four components (benthic habitats, pelagic habitats, fish, and mammals), a biological quality ratio (BQR) of 0.6 was developed by HELCOM with the aim to represent good status and was used as here as the target.

### 1.4 Other information

External advisors/goalkeepers: Andrea Belgrano and Henn Ojaveer

<br/>

2. Data
-------

This prep document is used to generate and explore the following data layers:

-   `bd_hab_benthic_bhi2019.csv`
-   `bd_hab_pelagic_bhi2019.csv`
-   `bd_spp_fish_bhi2019.csv`
-   `bd_spp_seals_bhi2019.csv`
-   `bd_spp_winter_birds_bhi2019.csv`
-   `bd_spp_breeding_birds_bhi2019.csv`

These are saved to the `layers` folder. All these are derived from or informed by the raw datasets from the HELCOM 2018 integrated biodiversity status assessments.

<br>

### 2.1 Datasets with Sources

<br/>

The data for the Biodiversity goal consists of 4 shapefiles downloaded from HELCOM Metadata catalogue, with status and metrics reported by HELCOM Assessment Units – HELCOM open sea sub-basins and coastal WFD water bodies.

#### 2.1.1 Habitats

**Integrated biodiversity status assessment - Benthic Habitats**

<!-- dataset save location BHI_share/BHI 2.0/Goals/BD/helcom_integrated_assessments -->
Source: [HELCOM Metadata catalogue:](http://metadata.helcom.fi/geonetwork/srv/eng/catalog.search#/metadata/478d52dd-08b7-4777-b879-8806b1188b27)

Downloaded 9 September 2020 by Ellie Campbell.

For more information about the dataset and indicators see the [State of the Baltic Sea webpage on Benthic Habitats](http://stateofthebalticsea.helcom.fi/biodiversity-and-its-status/benthic-habitats/).

**Integrated biodiversity status assessment - Pelagic Habitats**

<!-- dataset save location BHI_share/BHI 2.0/Goals/BD/helcom_integrated_assessments -->
Source: [HELCOM Metadata catalogue:](http://metadata.helcom.fi/geonetwork/srv/eng/catalog.search#/metadata/821b33a7-35b3-489c-93ab-9ef8f4422f2a)

Downloaded 9 September 2020 by Ellie Campbell.

For more information about the dataset and indicators see the [State of the Baltic Sea webpage on Pelagic Habitats](http://stateofthebalticsea.helcom.fi/biodiversity-and-its-status/pelagic-habitats/).

#### 2.1.2 Species Groups

**Integrated biodiversity status assessment - Fish**

<!-- dataset save location BHI_share/BHI 2.0/Goals/BD/helcom_integrated_assessments -->
Source: [HELCOM Metadata catalogue:](http://metadata.helcom.fi/geonetwork/srv/eng/catalog.search#/metadata/ee20ad8b-c826-4561-b63a-bf203bb481b9)

Downloaded 9 September 2020 by Ellie Campbell.

For more information about the dataset and indicators see the [State of the Baltic Sea webpage on Fish](http://stateofthebalticsea.helcom.fi/biodiversity-and-its-status/fish/).

**Integrated biodiversity status assessment - Seals**

<!-- dataset save location BHI_share/BHI 2.0/Goals/BD/helcom_integrated_assessments -->
Source: [HELCOM Metadata catalogue:](http://metadata.helcom.fi/geonetwork/srv/eng/catalog.search#/metadata/c1662d7b-f63a-48cc-96f6-3072d328ae56)

Downloaded 9 September 2020 by Ellie Campbell.

For more information about the dataset and indicators see the [State of the Baltic Sea webpage on Marine Mammals (Seals)](http://stateofthebalticsea.helcom.fi/biodiversity-and-its-status/marine-mammals/).

**Abundance of waterbirds in the breeding season, 2018**

<!-- dataset save location BHI_share/BHI 2.0/Goals/BD/helcom_integrated_assessments -->
Source: [HELCOM Metadata catalogue:](http://metadata.helcom.fi/geonetwork/srv/eng/catalog.search#/metadata/67d2f5e9-7f56-4ef0-87f0-a036528c56b9). The metadata catalogue and Map Viewer have pages/layers titled by bird groups (wading, surface, pelagic, benthic, grazing feeders), but the data linked on each of the metadata catalogue pages seem to be the same shapefile with all these groups included.

Downloaded 10 September 2020 by Ellie Campbell.

For more information about the dataset and indicators see the [State of the Baltic Sea webpage on Waterbirds](http://stateofthebalticsea.helcom.fi/biodiversity-and-its-status/waterbirds/).

**Abundance of waterbirds in the wintering season, 2018**

<!-- dataset save location BHI_share/BHI 2.0/Goals/BD/helcom_integrated_assessments -->
Source: [HELCOM Metadata catalogue:](http://metadata.helcom.fi/geonetwork/srv/eng/catalog.search#/metadata/cf3f0772-acd1-4674-8c78-44ea5abbe5f1). The metadata catalogue and Map Viewer have pages/layers titled by bird groups (wading, surface, pelagic, benthic, grazing feeders), but the data linked on each of the metadata catalogue pages seem to be the same shapefile with all these groups included.

For more information about the dataset and indicators see the [State of the Baltic Sea webpage on Waterbirds](http://stateofthebalticsea.helcom.fi/biodiversity-and-its-status/waterbirds/).

Downloaded 10 September 2020 by Ellie Campbell.

<br>

<br/>

3. Prep: Wrangling & Derivations, Checks/Evaluation, Gapfilling
---------------------------------------------------------------

### 3.1 Initial Data Wrangling/Harmonizing

**Load all Biodiversity Datasets**

``` r
files <- grep(
  "helcom_.*\\.shp$", 
  list.files(dir_rawdata, recursive = TRUE, full.names = TRUE), 
  value = TRUE
)
lapply(
  X = files,
  FUN = function(x){
    tmp <- sf::st_read(x)
    colnames(tmp) <- str_to_lower(names(tmp))
    nm <- sprintf("%s_shp", str_extract(x, "benthic|Fish|Seals|pelagic|wintering|briding")) %>% 
      str_replace("wintering", "wintering_birds") %>% 
      str_replace("briding", "breeding_birds") %>% 
      str_to_lower()
    assign(nm, tmp, envir = .GlobalEnv)
  }
)
```

**Subset, replace zeros with NAs where zone Not Assessed, add Year column, some subbasin alternative names**

``` r
## HABITATS ----
## benthic and pelagic habitats have the same columns and spatial units
for(shp in c("benthic_shp", "pelagic_shp")){
  
  habshp <- get(shp)
  colnames(habshp) <- str_to_lower(names(habshp))
  
  habshp <- habshp %>% 
    dplyr::select(helcom_id, country, subbasin = level_2, area_km2, BQR = bqr, status) %>% 
    mutate(BQR = ifelse(str_detect(status, "Not assessed"), NA, BQR)) %>% 
    ## these are just the 2018 integrated assessment
    mutate(year = 2018) %>% 
    dplyr::select(-status)
  
  assign(shp, habshp)
}


## FISH ----
## fish have data by coastal area (by country) and open sea sub-basins, similar to habitats spatial units
colnames(fish_shp) <- str_to_lower(names(fish_shp))
fish_shp$country <- as.character(fish_shp$country)
fish_shp <- fish_shp %>% 
  mutate(country = ifelse(country == "Open sea", "Opensea", country)) %>% 
  ## create subbasins column from name; need some corrections
  mutate(subbasin = ifelse(
    country == "Opensea",
    "Opensea",
    str_extract(name, "^.* (?=Finnish|Swedish|Estonian|Latvian|Lithuanian|Danish)"))
  ) %>% 
  mutate(subbasin = str_remove(subbasin, "(?=-).*$")) %>% 
  mutate(subbasin = str_remove(subbasin, " $")) %>%
  mutate(subbasin = case_when(
    subbasin == "Western Gotlland Basin" ~ "Western Gotland Basin",
    subbasin == "Mecklenburg Bight" ~ "Bay of Mecklenburg",
    subbasin == "Belts" ~ "Great Belt",
    TRUE ~ subbasin
  )) %>% 
  ## filter to keep assessed, select only cols needed for the bhi status calculations
  filter(!(is.na(subbasin) & is.na(ecosystemc))) %>% 
  dplyr::select(helcom_id, country, subbasin, BQR = bqr) %>% 
  ## these data are just the 2018 integrated assessment
  mutate(year = 2018)

## calculate area of the polygons - coastal and open sea regions
fish_shp <- cbind(fish_shp, area_km2 = as.numeric(sf::st_area(fish_shp)/(1000^2))) 


## SEALS ----
## seal data is by subbasin rather than country and subbasin,
## will expand to have data by bhi regions to be on same scale as other data, 
## but original data is at subbasin level!
seals_shp <- seals_shp %>%
  dplyr::select(helcom_id, subbasin = level_2, area_km2, BQR = bqr) %>% 
  ## these are just the 2018 integrated assessment
  mutate(year = 2018) %>% 
  ## will join subbasins as for the seal data as for other layers' opensea data
  mutate(country = "Opensea")


## WATERBIRDS ----
for(shp in c("wintering_birds_shp", "breeding_birds_shp")){
  
  birdshp <- get(shp)
  colnames(birdshp) <- str_to_lower(names(birdshp))
  
  birdshp <- birdshp %>% 
    mutate_if(is.factor, as.character) %>% 
    dplyr::select(
      helcom_id, country, subbasin = level_2, area_km2, 
      wading_feeders = wading_fee, wading_status = wading_f_1,
      surface_feeders = surface_fe, surface_status = surface__1,
      pelagic_feeders = pelagic_fe, pelagic_status = pelagic__1,
      benthic_feeders = benthic_fe, benthic_status = benthic_fe,
      grazing_feeders = grazing_fe, grazing_status = grazing__1,
      name
    ) %>% 
    mutate(
      wading_feeders = ifelse(str_detect(wading_status, "Not Assessed"), NA, wading_feeders),
      surface_feeders = ifelse(str_detect(surface_status, "Not Assessed"), NA, surface_feeders),
      pelagic_feeders = ifelse(str_detect(pelagic_status, "Not Assessed"), NA, pelagic_feeders),
      benthic_feeders = ifelse(str_detect(benthic_status, "Not Assessed"), NA, benthic_feeders),
      grazing_feeders = ifelse(str_detect(grazing_status, "Not Assessed"), NA, grazing_feeders)
    ) %>% 
    ## these are just the 2018 integrated assessment
    mutate(year = 2018) %>% 
    dplyr::select(-wading_status, -surface_status, -pelagic_status, -benthic_status, -grazing_status) %>% 
    mutate(across(matches("feeders"), function(x){ifelse(x == "n/a", NA, x)})) %>% 
    mutate(across(matches("feeders"), as.numeric)) %>% 
    mutate(winter_or_breeding = str_extract(shp, ".*(?=_)")) %>% 
    mutate(subbasin = case_when(
      subbasin == "Western Gotlland Basin" ~ "Western Gotland Basin",
      subbasin == "Mecklenburg Bight" ~ "Bay of Mecklenburg",
      subbasin == "Belts" ~ "Great Belt",
      subbasin == "Kiel Bight" ~ "Kiel Bay",
      TRUE ~ subbasin
    ))
  
  assign(shp, birdshp)
}
```

### 3.2 Match BHI regions by Country and/or Subbasin

``` r
regions_shape()

rgns_complete <- read_csv(file.path(dir_prep, "supplement", "lookup_tabs", "rgns_complete.csv")) %>% 
  select(region_id, subbasin, country = eez, region_name, region_area_km2) %>% 
  mutate(subbasin = ifelse(subbasin == "Aland Sea", "Åland Sea", subbasin))

for(shp in c("benthic_shp", "pelagic_shp", "fish_shp", "seals_shp", "wintering_birds_shp", "breeding_birds_shp")){
  
  coastal_w_rgns <- get(shp) %>% 
    filter(country != "Opensea") %>% 
    left_join(rgns_complete, by = c("subbasin", "country")) %>% 
    mutate(coastal = TRUE)
  
  ## to match BHI regions, need to split the 'opensea' areas between adjacent countries
  ## for fish will need to spatially intersect opensea areas with BHI regions to evaluate overlap
  if(shp == "fish_shp"){
    
    ## need to fix weird geometries and also invalid geometries of bhi regions, then intersect...
    ## https://strimas.com/smoothr/reference/drop_crumbs.html
    opensea_w_rgns <- sf::st_intersection(
      lwgeom::st_make_valid(st_transform(BHI_rgns_shp, crs = 3035)),
      smoothr::drop_crumbs(filter(get(shp), country == "Opensea"), 300*(1000^2), drop_empty = TRUE)
    )
    
    ## view map of intersection between fish open sea and BHI regions
    # rmapshaper::ms_simplify(input = opensea_w_rgns) %>%
    #   sf::st_as_sf() %>%
    #   mutate(BHI_ID = as.character(BHI_ID)) %>%
    #   ggplot() +
    #   geom_sf(aes(fill = BHI_ID)) +
    #   scale_fill_manual(values = colorRampPalette(RColorBrewer::brewer.pal(6, "Dark2"))(80)[sample(1:80, 42)])
    
    opensea_w_rgns <- cbind(
      select(opensea_w_rgns, -area_km2, -subbasin),
      ## recalculate area of opensea after intersection with BHI regions
      area_km2 = as.numeric(sf::st_area(opensea_w_rgns)/(1000^2))
    )
    opensea_w_rgns <- opensea_w_rgns %>% 
      mutate(region_name = sprintf("%s, %s", Subbasin, rgn_nam)) %>% 
      select(
        helcom_id = HELCOM_ID, subbasin = Subbasin, 
        area_km2, BQR, year, 
        region_id = BHI_ID, region_name, country = rgn_nam, 
        region_area_km2 = Area_km2
      ) %>% 
      mutate(coastal = FALSE)
    
  } else {
    ## may be slight issues with areas 
    ## (bhi regions areas dont add to subbasin areas for seals data...)
    ## is our bhi shapefile out of date, or maybe areas are incorrectly calculated??
    opensea_w_rgns <- get(shp) %>% 
      filter(country == "Opensea") %>% 
      left_join(tidyr::nest(rgns_complete, data = c(region_id, region_name, country, region_area_km2)), by = "subbasin") %>% 
      select(-country) %>% 
      tidyr::unnest(cols = c(data)) %>% 
      mutate(coastal = FALSE)
  }

  ## calculate areas for opensea fractions of BHI regions
  shp_w_rgns <- bind_rows(opensea_w_rgns, coastal_w_rgns) %>% 
    group_by(region_id) %>% 
    mutate(coastal_area = sum(area_km2*coastal)) %>% 
    ungroup() %>% 
    mutate(area_km2 = ifelse(coastal, area_km2, region_area_km2 - coastal_area)) %>% 
    select(-coastal_area, -region_area_km2)
  
  assign(str_replace(shp, "_shp", "_w_rgns"), shp_w_rgns)
}
```

### 3.3 Waterbirds Data

``` r
## need to merge and reshape as the waterbirds data is by bird groups: 
## wading, surface, pelagic, benthic, grazing feeders
## and also wintering vs breeding
birds_data <- bind_rows(wintering_birds_w_rgns, breeding_birds_w_rgns) %>% 
  st_drop_geometry() %>% 
  rename(spatial_group = name) %>% 
  tidyr::pivot_longer(
    cols = c(wading_feeders, surface_feeders, pelagic_feeders, benthic_feeders, grazing_feeders),
    names_to = "feeder_group",
    values_to = "BQR"
  ) %>% 
  mutate(feeder_group = sprintf("%s, %s", feeder_group, winter_or_breeding)) %>% 
  select(region_id, region_name, helcom_id, coastal, year, feeder_group, spatial_group, area_km2, BQR)
```

### 3.4 Save Biodiversity Layers

``` r
write_csv(
  benthic_w_rgns %>% 
    st_drop_geometry() %>% 
    select(region_id, helcom_id, year, BQR, area_km2), 
  file.path(dir_layers, "bd_hab_benthic_bhi2019.csv")
)
write_csv(
  pelagic_w_rgns %>% 
    st_drop_geometry() %>% 
    select(region_id, helcom_id, year, BQR, area_km2), 
  file.path(dir_layers, "bd_hab_pelagic_bhi2019.csv")
)
write_csv(
  fish_w_rgns %>% 
    st_drop_geometry() %>% 
    select(region_id, helcom_id, year, BQR, area_km2), 
  file.path(dir_layers, "bd_spp_fish_bhi2019.csv")
)
write_csv(
  seals_w_rgns %>% 
    st_drop_geometry() %>% 
    select(region_id, helcom_id, year, BQR, area_km2), 
  file.path(dir_layers, "bd_spp_seals_bhi2019.csv")
)
write_csv(
  birds_data %>% 
    select(region_id, helcom_id, year, BQR, area_km2, feeder_group, spatial_group), 
  file.path(dir_layers, "bd_spp_birds_bhi2019.csv")
)
```

### 3.5 Biodiversity Trial Status & Trend Calculations

``` r
## will do bird assessment with spatial groups specified in the data rather than BHI regions
## then will rematch to BHI regions afterwards
birds_spatial_units <- distinct(birds_data, region_id, region_name, spatial_group)
birds <- birds_data %>% 
  group_by(helcom_id, feeder_group) %>% 
  mutate(helcom_id_area_km2 = sum(area_km2)) %>% 
  ## each helcom_id region has 10 groups - 5 feeding groups, for each wintering and breeding
  ## what kind of average to use?? will use arithmetic mean of BQRs across groups for now...
  ## note: only benthic feeders are assessed for the open sea areas
  distinct(helcom_id, coastal, spatial_group, feeder_group, BQR, helcom_id_area_km2) %>% 
  group_by(helcom_id, coastal, spatial_group, helcom_id_area_km2) %>% 
  summarize(averageBQR = mean(BQR, na.rm = TRUE)) %>% 
  ungroup() %>% 
  ## will take area weighted means of BQRs within coastal areas of the spatial assessment area
  group_by(coastal, spatial_group) %>% 
  summarize(averageBQR = weighted.mean(averageBQR, helcom_id_area_km2)) %>% 
  ungroup() %>% 
  ## combine coastal and open sea with equal weights rather than area-weighted average
  group_by(spatial_group) %>% 
  summarize(averageBQR = mean(averageBQR, na.rm = TRUE)) %>% 
  ungroup() %>% 
  ## now rejoin the BHI regions based on which spatial unit they are within
  right_join(birds_spatial_units, by = "spatial_group") %>% 
  mutate(indicator = "spp_birds") %>% 
  select(-spatial_group)


## merge all other data layers
bd_all_data <- bind_rows(
  benthic_w_rgns %>% 
    st_drop_geometry() %>% 
    mutate(indicator = "hab_benthic"),
  pelagic_w_rgns %>% 
    st_drop_geometry() %>% 
    mutate(indicator = "hab_pelagic"),
  fish_w_rgns %>% 
    st_drop_geometry() %>% 
    mutate(indicator = "spp_fishes"),
  seals_w_rgns %>% 
    st_drop_geometry() %>% 
    mutate(indicator = "spp_seals")
)

## is it better to calculate status (which involves capping at 1) first and then aggregate indicators, 
## or aggregate indicators first? 
## aggregating first would mean status over ref point in some areas couldn't go towards compensating for areas under ref point...
## also, will use geometric mean to represent how components are not interchangeable
## geometric mean function
## https://stackoverflow.com/questions/2602583/geometric-mean-is-there-a-built-in
gm_mean = function(x, na.rm = TRUE, zero.propagate = FALSE){
  if(any(x < 0, na.rm = TRUE)){
    return(NaN)
  }
  if(zero.propagate){
    if(any(x == 0, na.rm = TRUE)){
      return(0)
    }
    exp(mean(log(x), na.rm = na.rm))
  } else {
    exp(sum(log(x[x > 0]), na.rm = na.rm) / length(x))
  }
}


## at BQR of 0.6 is the reference point except for birds, which have a ref point of 0.75
## will rescale so BQR = 0.6 or above is a status of 1, while BQR = 0 is a status of zero
bd_status <- bd_all_data %>% 
  group_by(region_id, region_name, coastal, indicator) %>% 
  summarize(averageBQR = weighted.mean(BQR, area_km2, na.rm = TRUE)) %>% 
  ungroup() %>% 
  ## combine coastal and open sea with equal weights rather than area-weighted average
  group_by(region_id, region_name, indicator) %>% 
  summarize(averageBQR = mean(averageBQR, na.rm = TRUE)) %>% 
  ungroup() %>% 
  ## bind birds data with other biodiversity layers
  bind_rows(birds) %>% 
  mutate(averageBQR = ifelse(is.nan(averageBQR), NA, averageBQR)) %>% 
  ## calculate the status for individual indicators
  mutate(indicator_status = case_when(
    indicator == "spp_birds" ~ pmin(1, (4/3)*averageBQR),
    indicator != "spp_birds" ~ pmin(1, (5/3)*averageBQR)
  )) %>% 
  select(-averageBQR)


bd_status <- bind_rows(
  bd_status %>% 
    rename(status = indicator_status),
  bd_status %>% 
    group_by(region_id, region_name) %>% 
    summarize(status = gm_mean(indicator_status)) %>% 
    ungroup() %>% 
    mutate(indicator = "combined")
)
```

<br/>

4. Visualizing Data Layers
--------------------------

### 4.1 Bar Plots by Indicator and Overall Status

``` r
ggplot(bd_status) + 
    geom_col(aes(x = region_name, y = status, fill = status)) +
    scale_fill_viridis_c(direction = -1) +
    labs(fill = "Score", x  = NULL, y = "\nStatus Score") +
    coord_flip() +
    facet_wrap(~indicator, nrow = 2)
```

![](bd_prep_files/figure-markdown_github/plot%20of%20biodiversity%20status%20results-1.png)

### 4.2 Maps

``` r
bhirgn_simple <- rmapshaper::ms_simplify(input = BHI_rgns_shp) %>% sf::st_as_sf()

## simplify the polygons before creating maps
## first transforming to match rnaturalearth basemap crs...
benthic_shp <- rmapshaper::ms_simplify(input = sf::st_transform(benthic_shp, crs = 4326)) %>%
  sf::st_as_sf()
pelagic_shp <- rmapshaper::ms_simplify(input = sf::st_transform(pelagic_shp, crs = 4326)) %>%
  sf::st_as_sf()
fish_shp <- rmapshaper::ms_simplify(input = sf::st_transform(fish_shp, crs = 4326)) %>% 
  sf::st_as_sf()
seals_shp <- rmapshaper::ms_simplify(input = sf::st_transform(seals_shp, crs = 4326)) %>% 
  sf::st_as_sf()

## basemap and color palettes
basemap <- ggplot2::ggplot(rnaturalearth::ne_countries(scale = "medium", returnclass = "sf")) +
  geom_sf(size = 0.1, color = "burlywood", alpha = 0.4) +
  theme(panel.background = element_rect(fill = "#F8FBFC", color = "#E2EEF3")) +
  scale_x_continuous(limit = c(4, 32)) +
  scale_y_continuous(limit = c(53.5, 66)) 

cols <- c("indianred", "coral", "goldenrod1", "khaki", "lightblue", "steelblue")
```

#### 4.2.1 Benthic and Pelagic Habitats

``` r
gridExtra::grid.arrange(
  basemap +
    geom_sf(
      data = benthic_shp, 
      mapping = aes(fill = BQR),
      alpha = 0.7, color = "steelblue", size = 0.3
    ) +
    geom_sf(
      data = bhirgn_simple,
      size = 0.4, color = "snow", fill = NA
    ) +
    scale_fill_viridis_c() +
    theme(legend.position = c(0.2, 0.75)),
  basemap +
    geom_sf(
      data = pelagic_shp, 
      mapping = aes(fill = BQR),
      alpha = 0.7, color = "steelblue", size = 0.3
    ) +
    geom_sf(
      data = bhirgn_simple,
      size = 0.4, color = "snow", fill = NA
    ) +
    scale_fill_viridis_c() +
    theme(legend.position = c(0.2, 0.75)),
  nrow = 1
)
```

![](bd_prep_files/figure-markdown_github/map%20of%20benthic%20and%20pelagic-1.png)

#### 4.2.2 Fish and Seals

``` r
gridExtra::grid.arrange(
  basemap +
    geom_sf(
      data = fish_shp, 
      mapping = aes(fill = BQR),
      alpha = 0.7, color = "steelblue", size = 0.3
    ) +
    geom_sf(
      data = bhirgn_simple,
      size = 0.4, color = "snow", fill = NA
    ) +
    scale_fill_viridis_c() +
    theme(legend.position = c(0.2, 0.75)),
  basemap +
    geom_sf(
      data = seals_shp, 
      mapping = aes(fill = BQR),
      alpha = 0.7, color = "steelblue", size = 0.3
    ) +
    geom_sf(
      data = bhirgn_simple,
      size = 0.4, color = "snow", fill = NA
    ) +
    scale_fill_viridis_c() +
    theme(legend.position = c(0.2, 0.75)),
  nrow = 1
)
```

![](bd_prep_files/figure-markdown_github/map%20of%20seals%20and%20fish-1.png)

<br>

5. Considerations for `BHI3.0`
------------------------------

\*\*Temporal <data:**> The data used here consists of an integrated assessment period (2011-2016), so no trend was calculated from the same data used in status calculations. The trend dimension included is from the global OHI assessment, which employs a different status calculation approach.

**Varied habitats and functions:** Including a greater range of more specific habitat types and functional types (in a transparent way), could help make the goal more actionable for managers at local scales.

<br>

6. References
-------------

[State of the Baltic Sea webpage on Benthic Habitats](http://stateofthebalticsea.helcom.fi/biodiversity-and-its-status/benthic-habitats/)

[State of the Baltic Sea webpage on Pelagic Habitats](http://stateofthebalticsea.helcom.fi/biodiversity-and-its-status/pelagic-habitats/)

[State of the Baltic Sea webpage on Fish](http://stateofthebalticsea.helcom.fi/biodiversity-and-its-status/fish/)

[State of the Baltic Sea webpage on Marine Mammals (Seals)](http://stateofthebalticsea.helcom.fi/biodiversity-and-its-status/marine-mammals/)

[State of the Baltic Sea webpage on Waterbirds](http://stateofthebalticsea.helcom.fi/biodiversity-and-its-status/waterbirds/)
