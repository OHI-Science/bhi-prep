Artisanal Fishing Opportunities (AO)
================

<br>

## 1\. Background

### 1.2 Goal Description

The Artisanal Fishing Opportunities goal, often also called small-scale
fishing, provides a critical source of food, nutrition, poverty
alleviation and livelihood opportunities for many people around the
world, in particular in developing nations. This goal measures whether
people who need to fish on a small, local scale have the opportunity to
do so. It has three sub-components: stock, access, and need. A score of
100 means the country or region is meeting the needs of artisanal
fishermen or communities by implementing institutional supports,
providing access to near-shore water, and maintaining the health of
targeted species.

**For the BHI, the focus is on the *stock* sub-component and will use
this as a proxy for the entire goal.**

### 1.3 Model & Data

The Artisanal Fishing Opportunities goal (AO) model assesses the health
of fish stocks. Two HELCOM core indicators are included:

1)  abundance of coastal fish key functional groups (Catch-per-unit
    effort (CPUE) of cyprinids/mesopredators and CPUE of piscivores);
2)  abundance of key coastal fish species (CPUE of perch, cod or
    flounder, depending on the area).

Environmental status assessments were provided by Jens Olsson (SLU,
Sweden), see also HELCOM FISH-PRO II
(<http://www.helcom.fi/helcom-at-work/projects/fish-pro/>). CPUE data
used in the GES assessment. Data provided by Jens Olsson was also used
in trend. Slopes from each analysis available here, but CPUE data held
internally in the BHI database and not accessible here.

### 1.4 Reference values

Previously, indicator status was scored per monitoring area using the
assessment protocol for coastal fish (baseline or trend-based approach)
=\> yielding whether or not the status per monitoring area is **Good
Environmental Status (GES)** or **subGES**. If a monitoring station
received a “sub-GES” assessment, it was given a qualifier as “low” or
“high”.  
Environmental status assessments were provided by Jens Olsson (SLU,
Sweden). See [HELCOM FISH-PRO
II](http://www.helcom.fi/helcom-at-work/projects/fish-pro/) now in
progress for the [HELCOM FISH-PRO
III](https://helcom.fi/helcom-at-work/projects/fish-pro-iii/)

Now, for the newer assessment, to match the [BEAT-tool as developed
within HOLAS
II](http://stateofthebalticsea.helcom.fi/wp-content/uploads/2017/07/HELCOM_The_integrated_assessment_of_biodiversity_supplementary_report_first_version_2017.pdf),
indicator status was normalized in categorial classes: - Nearest lower
value of 0.125 = 0.125 - Nearest lower value of 0.375 = 0.375 - Nearest
lower value of 0.6 = 0.6 - Nearest lower value of 0.875 = 0.875 where
**threshold value = 0.6**. Threshold values for the status assessments
are identified based on site-specific time-series data for each
indicator, as coastal fish generally have local population structures,
limited migration, and show local responses to environmental change.
*See also powerpoint provided by Jens Olsson of BHI shared folder*

### 1.5 Other information

*External advisors/goalkeepers: Jens Olsson*

<br/>

## 2\. Data

This prep document is used to generate and explore the following data
layers:

  - `ao_stock_status_bhi2019.csv`
  - `ao_stock_slope_bhi2019.csv`

These are saved to the `layers` folder. Saved to
`data/AO/v2019/intermediate` are intermediate datasets:
`ao_merged_rawdata.csv` and `ao_cleaned_cpue.csv`. All these are derived
from or informed by the raw datasets from Jens Olsson (goalkeeper).

<br>

### 2.1 Datasets with Sources

<br/>

#### 2.1.1 Coastal fish Data

Data were received by Jens Olsson via email (18 March 2020). Dare from
monitoring locations (described in the HELCOM core indicators). Finnish
data are fisheries data from ICES assessment regions (ICES 29-32).

### 2.2 Centralization & Normalization

#### 2.2.1 Coastal fish datasets

Since coastal fish data (‘coastal\_fish\_data\_2018.csv’) are updated
until 2018, but the latest status assessment (HOLAS II) only includes
data until 2016, we have decided to use the data included in HOLAS II
(until 2016) for this first BHI 2.0 calculations
(‘key\_species\_status.csv’, ‘piscivores\_status.csv’,
‘cyprinids\_status.csv’). Then, once the most updated data will be
included into the next “intermediate” status assessment, we will also
include the newest data.

``` r
# library(readr)
# load all raw data (containing the newest data)
coastal_fish_raw <- read.csv(
  file.path(dir_rawdata, "coastal_fish_data_2018.csv"), 
  sep = ";")

# key species status data (until 2016)
key_species_status_raw <- read.csv(
  file.path(dir_rawdata, "key_species_status.csv"),
  sep = ";")

# functional groups (piscivores and cyprinids) status data (until 2016)
piscivores_status_raw <- read.csv(
  file.path(dir_rawdata, "piscivores_status.csv"), 
  sep = ";")

cyprinids_status_raw <- read.csv(
  file.path(dir_rawdata, "cyprinids_status.csv"), 
  sep = ";")

coastal_areas <- sf::st_read(file.path(
  dir_rawdata, "Coastal fish monitoring areas",
  "CoastalFishAreas.shp"
)) # CRS: 3035
```

Reading layer `CoastalFishAreas' from data
source`/Users/andreadecervo/github/bhi-data/BHI 2.0/Goals/AO/Coastal
fish monitoring areas/CoastalFishAreas.shp’ using driver \`ESRI
Shapefile’ Simple feature collection with 6 features and 14 fields
geometry type: MULTIPOLYGON dimension: XY bbox: xmin: 4825687 ymin:
4114489 xmax: 5289321 ymax: 4811097 CRS: 3035

**Explore and clean coastal fish data for trend calculation**

``` r
coastal_fish_cpue <- coastal_fish_raw %>% 
  dplyr::rename(
    monitoring_area = Area, 
    coastal_water_type = Assessment.unit,
    core_indicator = Indicator,
    cpue = Value
  ) %>% 
   dplyr::mutate(
      monitoring_area = str_replace(monitoring_area, "≈", "A"), ## need to clean the areas' names!
      monitoring_area = str_replace(monitoring_area, "Area south of Zealand (SmÂlandsfarvandet)", "Area south of Zealand (Smalandsfarvandet)"),
      monitoring_area = str_replace(monitoring_area, "Askˆ", "Asko"),
      monitoring_area = str_replace(monitoring_area, "Gaviksfj‰rden", "Gaviksfjaerden"),
      monitoring_area = str_replace(monitoring_area, "Holmˆn", "Holmoen"),
      monitoring_area = str_replace(monitoring_area, "Kinnb‰cksfj‰rden", "Kinnbaecksfjaerden"),
      monitoring_area = str_replace(monitoring_area, "RÂneÂ", "Ranea"),
      monitoring_area = str_replace(monitoring_area, "LÂngvindsfj‰rden", "Langvindsfjaerden"),
      monitoring_area = str_replace(monitoring_area, "Kv‰dˆfj‰rden", "Kvaedoefjaerden"),
      monitoring_area = str_replace(monitoring_area, "LÂngvindsfj‰rden", "Langvindsfjaerden"),
      monitoring_area = str_replace(monitoring_area, "Rectangle 23", "ICES SD 23"),
      monitoring_area = str_replace(monitoring_area, "Rectangle 28", "ICES SD 28"),
      monitoring_area = str_replace(monitoring_area, "PrÊst¯ Fiord", "Praestoe Fiord"),
      Subbasin = str_replace(Subbasin, "≈", "A"),
      Subbasin = str_replace(Subbasin, "Arkona basin", "Arkona Basin"),
      Subbasin = str_replace(Subbasin, "Bornholm basin", "Bornholm Basin"),
      cpue = str_replace(cpue, ",", "."),
      cpue = str_replace(cpue, "-", ""),
      cpue = as.numeric(cpue),
      core_indicator = ifelse(Functional.group == "Cyprinids" & core_indicator  == "Key species", "Key functional group", core_indicator),
      Taxa = if_else(
        Species == "-", Functional.group, Species)) %>% 
  dplyr::select(-Species, -Functional.group)
```

<br>

<br>

**Clean, explore and merge key species, cyprinids and piscivores status
data**

``` r
coastal_fish_status <- rbind(
  key_species_status_raw %>% 
    dplyr::rename(
      Latitude = Coordinates,
      Longitude = X,
      Taxa = Identity.of.key.species,
      Monitoring.area = Monitoring.location,
      Subbasin = Sub.basin.name,
      coastal_water_type = Coastal.area.name..assessment.unit.,
      period = Time.period.assessed
    ) %>% 
    dplyr::mutate(
      Latitude = str_replace(Latitude, ",", "."),
      Latitude = str_replace(Latitude, "Area not point", ""),
      Longitude = str_replace(Longitude, ",", "."),
      ## assign lat-lon for ICES area to allow map plotting 
      # (assign location in center of Finnish coasts for ICES areas (23,28,29-32)
      Latitude = ifelse(Monitoring.area == "Finnish ICES SD 31", 64.207281,
                 ifelse(Monitoring.area == "Finnish ICES SD 30", 61.679815,
                 ifelse(Monitoring.area == "Finnish ICES SD 29", 59.705518,
                 ifelse(Monitoring.area == "Finnish ICES SD 32", 60.108130,
                 ifelse(Monitoring.area == "Finnish ICES rect 23", 63.505817, 
                 ifelse(Monitoring.area == "Finnish ICES rect 28", 63.505817, Latitude)))))),
      Longitude = ifelse(Monitoring.area == "Finnish ICES SD 31", 23.511161,
                  ifelse(Monitoring.area == "Finnish ICES SD 30", 21.269112,
                  ifelse(Monitoring.area == "Finnish ICES SD 29", 21.264879,
                  ifelse(Monitoring.area == "Finnish ICES SD 32", 25.772410,
                  ifelse(Monitoring.area == "Finnish ICES rect 23", 21.351243, 
                  ifelse(Monitoring.area == "Finnish ICES rect 28", 21.351243, Longitude)))))),
      Latitude = as.numeric(Latitude),
      Longitude = as.numeric(Longitude),
      Status.value.monitoring.location = str_replace(Status.value.monitoring.location, ",", "."),
      Status.value.monitoring.location = as.numeric(Status.value.monitoring.location),
      Monitoring.area = str_replace(Monitoring.area, "Kvädöfjärden, autumn", "Kvädöfjärden"),
      Monitoring.area = str_replace(Monitoring.area, "Kvädöfjärden, perch", "Kvädöfjärden"),
      threshold_value = 0.6,
      core_indicator = "key species"),
  cyprinids_status_raw %>% 
    dplyr::rename(
      Latitude = Coordinates,
      Longitude = X,
      Monitoring.area = Monitoring.location,
      Subbasin = Sub.basin.name,
      coastal_water_type = Coastal.area.name..assessment.unit.,
      period = Time.period.assessed
    ) %>% 
    dplyr::select(-Identity.of.indicator) %>% 
    dplyr::mutate(
      Latitude = str_replace(Latitude, ",", "."),
      Latitude = str_replace(Latitude, "Area not point", ""),
      Longitude = str_replace(Longitude, ",", "."),
       Latitude = ifelse(Monitoring.area == "Finnish ICES SD 31", 64.207281,
                 ifelse(Monitoring.area == "Finnish ICES SD 30", 61.679815,
                 ifelse(Monitoring.area == "Finnish ICES SD 29", 59.705518,
                 ifelse(Monitoring.area == "Finnish ICES SD 32", 60.108130,
                 ifelse(Monitoring.area == "Finnish ICES rect 23", 63.505817, 
                 ifelse(Monitoring.area == "Finnish ICES rect 28", 63.505817, Latitude)))))),
      Longitude = ifelse(Monitoring.area == "Finnish ICES SD 31", 23.511161,
                  ifelse(Monitoring.area == "Finnish ICES SD 30", 21.269112,
                  ifelse(Monitoring.area == "Finnish ICES SD 29", 21.264879,
                  ifelse(Monitoring.area == "Finnish ICES SD 32", 25.772410,
                  ifelse(Monitoring.area == "Finnish ICES rect 23", 21.351243, 
                  ifelse(Monitoring.area == "Finnish ICES rect 28", 21.351243, Longitude)))))),
      Latitude = as.numeric(Latitude),
      Longitude = as.numeric(Longitude),
      Status.value.monitoring.location = str_replace(Status.value.monitoring.location, ",", "."),
      Status.value.monitoring.location = as.numeric(Status.value.monitoring.location),
      threshold_value = 0.6,
      Taxa =  "cyprinids",
      core_indicator = "functional group"),
  piscivores_status_raw %>% 
    dplyr::rename(
      Latitude = Coordinates,
      Longitude = X,
      Subbasin = Sub.basin.name,
      coastal_water_type = Coastal.area.name..assessment.unit.,
      period = Time.period.assessed
    ) %>% 
    # separate_rows(Taxa, sep =",\\s+") %>% # serapate different taxa from single rows
    dplyr::select(-Identity.of.key.piscivores) %>% 
    dplyr::mutate(
      Latitude = str_replace(Latitude, ",", "."),
      Latitude = str_replace(Latitude, "Area not point", ""),
      Longitude = str_replace(Longitude, "Åland Sea", "."),
      Longitude = str_replace(Longitude, ",", "."),
       Latitude = ifelse(Monitoring.area == "Finnish ICES SD 31", 64.207281,
                 ifelse(Monitoring.area == "Finnish ICES SD 30", 61.679815,
                 ifelse(Monitoring.area == "Finnish ICES SD 29", 59.705518,
                 ifelse(Monitoring.area == "Finnish ICES SD 32", 60.108130,
                 ifelse(Monitoring.area == "Finnish ICES rect 23", 63.505817, 
                 ifelse(Monitoring.area == "Finnish ICES rect 28", 63.505817, Latitude)))))),
      Longitude = ifelse(Monitoring.area == "Finnish ICES SD 31", 23.511161,
                  ifelse(Monitoring.area == "Finnish ICES SD 30", 21.269112,
                  ifelse(Monitoring.area == "Finnish ICES SD 29", 21.264879,
                  ifelse(Monitoring.area == "Finnish ICES SD 32", 25.772410,
                  ifelse(Monitoring.area == "Finnish ICES rect 23", 21.351243, 
                  ifelse(Monitoring.area == "Finnish ICES rect 28", 21.351243, Longitude)))))),
      Latitude = as.numeric(Latitude),
      Longitude = as.numeric(Longitude),
      Status.value.monitoring.location = str_replace(Status.value.monitoring.location, ",", "."),
      Status.value.monitoring.location = as.numeric(Status.value.monitoring.location),
      threshold_value = 0.6,
      Taxa =  "piscivores",
      core_indicator = "functional group"))
```

<br>

``` r
readr::write_csv(
  coastal_fish_status, 
  here::here("data", "AO", version_year, "intermediate", "ao_merged_rawdata.csv")
)
```

<br>

### 2.3 Initial Data Exploration

#### 2.3.1 Check unique indicators per monitoring location

1.  Is more than one key species monitored at a given locations? **Yes,
    in Kvädöfjärden both flounder (autumn) and perch (summer)**
2.  Is more than one functional group monitored? **Yes, except in Muskö
    (Sweden) where no assessment of cyprinids/mesopredators is
    available. However, in Danish areas, only key species (flounder) are
    assessed as there are no reliable data for either piscivores or
    cyprinids/mesopredators**  
3.  Are both key species and functional groups monitored at all
    locations? **No**

<!-- end list -->

  - 11 monitoring areas without Functional groups (all Danish areas)
  - 1 monitoring area with two Key\_spp status: *Kvädöfjärden*

**Number of indicators by monitoring location**

``` r
## how many core indicators, how many taxa
indicator_count <- coastal_fish_status %>%
  select(
    Monitoring.area, core_indicator, Taxa, Status.value.monitoring.location
  ) %>%
  group_by(Monitoring.area) %>%
  summarise(unique_indicator = length(unique(core_indicator)),
            unique_taxa_func = length(unique(Taxa))
  ) %>%
  ungroup()
# indicator_count %>% print(n=40)

## which stations have only 1 core indicator type (either have only functional or only key spp)
one_indicator <- indicator_count %>% 
  filter(unique_indicator == 1)
# one_indicator %>% print(n=14)

## number of taxa organized by location and core indicator type
indicator_taxa_count <- coastal_fish_status %>% 
  select(
    Monitoring.area, core_indicator, Taxa
    ) %>%
  group_by(Monitoring.area, core_indicator) %>%
  summarise(unique_taxa_func = length(unique(Taxa))) %>%
  ungroup()
# indicator_taxa_count %>% print(n=66)

## which locations are missing an indicator type?
indicator_taxa_count %>% 
  filter(Monitoring.area %in% one_indicator$Monitoring.area)
```

    ## # A tibble: 11 x 3
    ##    Monitoring.area                           core_indicator unique_taxa_func
    ##    <chr>                                     <chr>                     <int>
    ##  1 Area south of Zealand (Smålandsfarvandet) key species                   1
    ##  2 Århus Bay                                 key species                   1
    ##  3 Islefjord and Roskilde fjord              key species                   1
    ##  4 Northern Limfjord                         key species                   1
    ##  5 Odense Fiord                              key species                   1
    ##  6 Præstø Fiord                              key species                   1
    ##  7 Sejerø Bay                                key species                   1
    ##  8 Skive Fiord and Lovns Broad               key species                   1
    ##  9 Southern Little Belt and the archipelago  key species                   1
    ## 10 The Great Belt                            key species                   1
    ## 11 The sound                                 key species                   1

``` r
ggplot(indicator_taxa_count) + 
  geom_point(aes(Monitoring.area, unique_taxa_func)) +
  facet_wrap(~core_indicator) +
  labs(y = "Taxa obs", x = "Monitoring Areas") +
  ggtitle("Number of indicators by monitoring location") +
  theme(axis.text.x = element_text(colour="grey20", size=6, angle=90, 
                                   hjust=.5, vjust=.5, face = "plain"),
        plot.margin = unit(c(1,1,1,1), "cm")) 
```

![](ao_prep_files/figure-gfm/unique%20indicators%20monitoring%20region-1.png)<!-- -->

``` r
## Number of NAs by each indicator
indicator_taxa_count %>%  
  spread(core_indicator, unique_taxa_func) %>% 
  dplyr::rename(key_species = `key species`) %>%
  dplyr::rename(functional_group = `functional group`) %>%
  summarise(Func_na = sum(is.na(functional_group)),                                                                               KeySpp_na = sum(is.na(key_species)))
```

    ## # A tibble: 1 x 2
    ##   Func_na KeySpp_na
    ##     <int>     <int>
    ## 1      11         0

<br>

#### 2.3.2 Compare status values across taxa

``` r
# make coastal_fish_scores in long format then plot
temp_long <- coastal_fish_status %>% 
  select(
    Monitoring.area, core_indicator, Taxa, Status.value.monitoring.location
    ) %>%
  group_by(
    Monitoring.area, core_indicator, Taxa
    ) %>% 
  ungroup()

# Coastal Fish Status Value (by monitoring area)
ggplot(coastal_fish_status) + 
  geom_point(
    aes(Monitoring.area, Status.value.monitoring.location, 
        colour = Taxa, shape = Taxa)) +
  facet_wrap(~core_indicator) +
  theme(axis.text.x = element_text(colour= "grey20", 
                                   size=7, angle=90, hjust=.5, vjust=.5, face="plain"),
        plot.margin = unit(c(1,1,1,1), "cm")) +
  labs(x = "Monitoring Area", y = "Status Value") +
  ggtitle("Coastal Fish Status Values (by monitoring area)")
```

![](ao_prep_files/figure-gfm/show%20data-1.png)<!-- -->

``` r
# Coastal Fish Status Value (by regions)
ggplot(coastal_fish_status) + 
  geom_point(
    aes(coastal_water_type, Status.value.monitoring.location, 
        colour = Taxa, shape = Taxa)) +
  facet_wrap(~ core_indicator) +
  theme(axis.text.x = element_text(colour= "grey20", 
                                   size=7, angle=90, hjust=.5, vjust=.5, face="plain"),
        plot.margin = unit(c(1,1,1,1), "cm")) +
  labs(x = "Regions", y = "Status Value") +
  ggtitle("Coastal Fish Status Values (by regions)")
```

![](ao_prep_files/figure-gfm/show%20data-2.png)<!-- -->

<br/>

## 3\. Prep: Wrangling & Derivations, Checks/Evaluation, Gapfilling

``` r
## previously merged in 'data/AO/v2019/ao_data.R' script
combined_coastal_fish <- read_csv(file.path(dirname(data_path), "intermediate", "ao_merged_rawdata.csv"))
cpue <- read_csv(file.path(dirname(data_path), "intermediate", "ao_cleaned_cpue.csv"))
```

<br/>

### 3.1 Match BHI regions

The raw coastal fish data must be assigned to their respective Subbasins
and BHI Regions based on their latitude/longitude
coordinates.

``` r
# Rename some variable and subbasin name to make it match to the basin_lookup table
combined_coastal_fish1 <- combined_coastal_fish %>% 
  rename(lat = Latitude, lon = Longitude) %>% 
  filter(!is.na(lat) & !is.na(lon)) %>%  # however, by doing this, more than 73 locations will be cut off
  mutate(
    Subbasin = stri_trans_totitle(Subbasin),
    Subbasin = str_replace(Subbasin, "Åland Sea", "Aland Sea"),
    Subbasin = str_replace(Subbasin, "Archipelago Sea", "Aland Sea"),
    Subbasin = str_replace(Subbasin, "Belt Sea", "Great Belt"),
    Subbasin = str_replace(Subbasin, "Gulf Of Finland", "Gulf of Finland"),
    Subbasin = str_replace(Subbasin, "Gulf Of Riga", "Gulf of Riga"),
    Subbasin = str_replace(Subbasin, "Estern Gotland Basin", "Eastern Gotland Basin"),
    Subbasin = str_replace(Subbasin, "Mecklenburg Bight", "Bay Of Mecklenburg"),
    Subbasin = str_replace(Subbasin, "Bay Of Mecklenburg", "Bay of Mecklenburg"),
    Subbasin = str_replace(Subbasin, "Northern Baltic Sea", "Northern Baltic Proper")) %>% 
  rename(subbasin = Subbasin)
# need to check if "Archipelago Sea" (Finland) is actually Aland Sea subbasin
#detach("package:raster", unload=TRUE) 

# bhibuffer <- sf::st_read(file.path(dirname(dir_B), "Shapefiles", "BHI_shapefile_25km_buffer"))
coastalfish_rgns <- join_rgns_info(
  combined_coastal_fish1, helcomID_col = "helcom_id", country_col = "country", 
  latlon_vars = c("^lat", "^lon"), return_spatial = FALSE, 
  rgn_shps_loc = file.path(dirname(dir_B), "Shapefiles"), 
  buffer_shp = NULL
) 
```

<br/>

**Explore coastal fish data on a map**

``` r
library(leaflet)
source(here::here("R", "spatial.R"))
regions_shape()

# Remove data points out of the bhi regions
coastalfish_rgns1 <- coastalfish_rgns %>% 
  filter(monitoring.area != "Northern Limfjord" & 
           monitoring.area != "Skive Fiord and Lovns Broad") %>% 
  # assign bhi_id with na value
  mutate(BHI_ID = replace(BHI_ID, is.na(BHI_ID) & monitoring.area == "Finbo", 36),
         BHI_ID = replace(BHI_ID, is.na(BHI_ID) & monitoring.area == "Jurkalne", 24),
         BHI_ID = replace(BHI_ID, is.na(BHI_ID) & monitoring.area == "Præstø Fiord", 12))

## make basemap
basemap <- ggplot2::ggplot(rnaturalearth::ne_countries(scale = "medium", returnclass = "sf")) + 
  geom_sf(size = 0.1, color = "burlywood", alpha = 0.4) +
  scale_x_continuous(limit = c(4, 32)) +
  scale_y_continuous(limit = c(53.5, 66)) +
  theme(panel.background = element_rect(fill = "#F8FBFC", color = "#E2EEF3"))

bhi_rgns_simple <- rmapshaper::ms_simplify(input = BHI_rgns_shp) %>% sf::st_as_sf()

basemap +
  geom_sf(data = bhi_rgns_simple, fill = "white", size = 0.2, color = "burlywood") +
  geom_sf(
    mapping = aes(colour = monitoring.area),
    data = sf::st_as_sf(
      coastalfish_rgns1, 
      coords = c("lon", "lat"), 
      crs = 4326
    ),
    size = 1.8
  ) +
  labs(x = NULL, y = NULL, colour = "Monitoring area") +
  ggtitle("Sampling Locations")
```

![](ao_prep_files/figure-gfm/explore%20coastal%20fish%20data%20in%20map-1.png)<!-- -->

``` r
# + theme(legend.position = c(0.9, 0.1)) +
#  scale_color_manual(values = c("tomato", "aquamarine2", "gold"))
```

## 4 BHI Status score

Since there will be 12 BHI regions with no score (due to missing data or
no sampling there), the status score will be calculated at BHI region
scale (instead of at Subbasin scale).

Step 1. Take mean score for each indicator type in each monitoring
region.

Step 2. Take mean score for each indicator at the BHI region scale.

Step 3. Take mean of the two indicators for each BHI region.

Step 4. Apply basin score to each BHI region

Xao = Mean Stock Indicator Value / Reference Point

  - Stock indicators = two HELCOM core indicators assessed for good
    environmental status (each scored between 0 and 1 by BHI region)
  - Reference value = 0.6

**A status of 100 indicates target is
achieved**

``` r
## Number of time series that will contribute to the mean score in each bhi rgn
basin_n_obs <- coastalfish_rgns1 %>% 
  dplyr::select(BHI_ID) %>%
  count(BHI_ID)

## Indicator mean by monitoring area
monitoring_indicator_mean <- coastalfish_rgns %>% 
  dplyr::select(
    BHI_ID, subbasin, country, monitoring.area, lat, lon, core_indicator, status.value.monitoring.location, threshold_value
    ) %>%
  group_by(BHI_ID, subbasin, country, monitoring.area, lat, lon, core_indicator, threshold_value)%>%
  summarise(mean_core_monitoring_score = mean(status.value.monitoring.location, na.rm=TRUE))%>%
  ungroup()

# Monitoring area score (mean across the two indicators)
monitoring_mean_score <- monitoring_indicator_mean %>%
  group_by(monitoring.area, BHI_ID, subbasin, country, lat, lon, threshold_value) %>%
  summarise(mean_monitoring_score = round(mean(mean_core_monitoring_score, na.rm=TRUE), 2)) %>%
  ungroup()

# join basin lookup
bhi_monitoring_mean_score <- monitoring_mean_score %>% 
  full_join(., basin_lookup, by = c("BHI_ID" = "bhi_id", "subbasin"))  

# Indicator mean by bhi region
bhi_indicator_mean <- monitoring_indicator_mean %>%
  group_by(BHI_ID, subbasin, country, core_indicator, threshold_value)%>%
  summarise(mean_core_bhi_score = mean(mean_core_monitoring_score, na.rm=TRUE)) %>%
  ungroup()

## BHI score (mean across the two indicators)
# join basin lookup
bhi_mean_score <- bhi_indicator_mean %>%  
  group_by(BHI_ID, threshold_value) %>%
  summarise(mean_bhi_score = round(mean(mean_core_bhi_score, na.rm=TRUE), 2)) %>%
  ungroup() %>% 
  full_join(., basin_lookup, by = c("BHI_ID" = "bhi_id"))
```

<br/>

### 4.1 Plot scores at each level

Plot the monitoring stations and BHI regions

#### 4.1.1 Plot monitoring area indicator mean scores

**Note that points are “jittered” in the second plot to make visible**

**Colors in the second plot are different monitoring locations**

``` r
## Plot monitoring area indicator mean scores
ggplot(monitoring_indicator_mean) + 
  geom_point(aes(monitoring.area, mean_core_monitoring_score, color = core_indicator,
                 shape = core_indicator), size = 3, alpha = 0.6) +
  geom_hline(yintercept = 0.6, color = "red") +
  theme(axis.text.x = element_text(colour="grey20", size=6, angle=90, 
                                   hjust=.5, vjust=.5, face = "plain"),
        plot.margin = unit(c(1,1,1,1), "cm"))  +
  labs(y = "Score", x = "Monitoring Areas") +
  ggtitle("Monitoring Area Indicator Mean Score")
```

![](ao_prep_files/figure-gfm/plot%20scores%20levels%20of%20aggregation-1.png)<!-- -->

``` r
## Plot monitoring area indicator mean scores by BHI regions
ggplot(monitoring_indicator_mean) + 
  geom_jitter(aes(BHI_ID, mean_core_monitoring_score, color = monitoring.area, 
                  shape = factor(core_indicator))) +
  guides(colour=FALSE)+
  theme(axis.text.x = element_text(colour="grey20", size=8, angle=90, 
                                   hjust=.5, vjust=.5, face = "plain"),
        plot.margin = unit(c(1,1,1,1), "cm")) +
  labs(y = "Score", x = "BHI Regions") +
  ggtitle("Monitoring Area Indicator Mean Score by BHI regions")
```

![](ao_prep_files/figure-gfm/plot%20scores%20levels%20of%20aggregation-2.png)<!-- -->

#### 4.1.2 Plot BHI indicator mean score

Plot the mean bhi score for each indicator

``` r
## Plot bhi indicator mean scores
ggplot(bhi_indicator_mean) + 
  geom_point(aes(BHI_ID, mean_core_bhi_score, color = core_indicator, 
                 shape = core_indicator), size = 2, alpha = 0.7) +
  geom_hline(yintercept = 0.6, color = "red") +
  scale_shape_manual(values = c(6,19)) +
  theme(axis.text.x = element_text(colour = "grey20", size = 8, angle = 90, 
                                    hjust=.5, vjust = .5, face = "plain"),
         plot.margin = unit(c(1,1,1,1), "cm")) +
  labs(y = "Score", x = "BHI Regions") +
  ggtitle('Indicator Mean Score by BHI Regions')
```

![](ao_prep_files/figure-gfm/plot%20basin%20indicator%20scores-1.png)<!-- -->
<br/>

**Plot bhi mean score across indicators** The mean of the two indicator
scores was taken for each bhi region

``` r
## Plot bhi mean score across indicators
ggplot(bhi_mean_score) + 
  geom_point(aes(rgn_nam, mean_bhi_score), size=2) +
  geom_hline(yintercept = 0.6, color = "red") +
  theme(axis.text.x = element_text(colour = "grey20", size = 8, angle = 90, 
                                   hjust = .5, vjust = .5, face = "plain"),
        plot.margin = unit(c(1,1,1,1), "cm")) +
  labs(y = "Score", x = "BHI Regions") +
  ggtitle('Mean Score by BHI region')
```

![](ao_prep_files/figure-gfm/plot%20basin%20mean%20across%20indicators-1.png)<!-- -->
<br/>

#### 4.1.3 Plot BHI Scores

The score to regions where no sampling occurred, due to local
population. Therefore, 12 regions have the score replaced with NA (4, 7,
8, 10, 13, 16, 17, 18, 19, 21, 22, 33). *See this map of sampling
locations provided by Jens Olsson for the above justification (note that
the Finnish sites are not marked but covered the entire coastline as
they are ICES regions. Coloration of the coastal waters is indication
HELCOM coastal water
type.*

``` r
## Calculate bhi status as: basin_mean/basin_target, constraining values to 1 as maximum score
bhi_status <- bhi_mean_score %>%
  dplyr::select(BHI_ID, mean_bhi_score, threshold_value) %>%
  mutate(
    mean_basin_score = ifelse(BHI_ID %in% c(4,7,8,10,13,16,17,18,19,21,22,33), NA, mean_bhi_score),
    dimension= "status"
    ) %>%  
  dplyr::rename(rgn_id = BHI_ID) %>%
  mutate(score = pmin(1, mean_basin_score/threshold_value),
         score = round(score * 100, 2)) %>% # keep decimal places, will round when combine eut indicators
  dplyr::select(rgn_id, dimension, score) %>% 
  filter(!is.na(rgn_id))
```

<br/>

#### 4.1.4 Plot final score objects

``` r
## Number of observations
##basin_n_obs    
##Plot points
plot_status <- bhi_status %>% 
  full_join(.,basin_lookup, by = c("rgn_id"= "bhi_id")) %>%
  full_join(., basin_n_obs, by= c("rgn_id" ="BHI_ID"))

# ggplot(plot_status) +
#  geom_point(aes(rgn_id, status, color = n, size = n)) +
#  ylim(0, 100) +
#  labs(y = "Score", x = "BHI regions") +
#  ggtitle("AO Status Score")

## plot the status
## BHI region plots will look the same, as BHI status are taken from subbasin means
## unless alternative calculation is used, based on BHI region means rather than subbasin means
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
  ggtitle("AO Status by Region")
```

![](ao_prep_files/figure-gfm/ao%20final%20score%20object%20plotted-1.png)<!-- -->

## 5\. Trend Calculation

We decided to follow the same approach as for BHI 1.0, from [Bergström
et
al 2016](https://www.researchgate.net/publication/288058474_Long_term_changes_in_the_status_of_coastal_fish_in_the_Baltic_Sea),
but only focus on the final 10 year-time period for the slope
(2008-2018)

### 5.1 Trend calculation method

STEPS:

1)  Select final time period of trend assessment (2008-2018)
2)  Use time series from both indicators, Key Species and Functional
    groups. For functional groups, include both cyprinid and piscivore
    time series.
3)  For each time series: square-root transform data, z-score, fit
    linear regression, extract slope
4)  Within each time series group (key species, cyprinid, piscivore),
    take the mean slope for each group within each bhi region
5)  Within each bhi region take a mean functional group indicator slope
    (mean of cyprinid mean and piscivore mean)
6)  For each bhi region take overall mean slope - mean of key species
    and functional group
7)  Multiple by five for future year value
8)  Apply trend value for all BHI regions (except in Gulf of Finland, do
    not apply Finnish site value to Estonia and Russian regions)

**Select time period and plot data**

``` r
## Select years 2008-2018
cpue <- cpue %>%
  filter(Year >= 2008 & Year <= 2018) %>% 
  mutate(Year = as.character(Year)) %>% 
  right_join(basin_lookup, by = c("Subbasin" = "subbasin", "Country" = "country"))

## Plot raw data
ggplot(filter(cpue, core_indicator == "Key species")) +
  geom_point(aes(Year, cpue)) +
  facet_wrap(~monitoring_area, scales="free_y") +
  theme(axis.text.x = element_text(angle = 90)) +
  ggtitle("Key Species CPUE by monitoring areas (2008-2018)")
```

![](ao_prep_files/figure-gfm/select%20time%20period%20and%20plot%20data-1.png)<!-- -->

``` r
ggplot(filter(cpue, Taxa == "Cyprinids")) +
  geom_point(aes(Year, cpue)) +
  facet_wrap(~monitoring_area, scales="free_y") +
  theme(axis.text.x = element_text(angle = 90)) +
  ggtitle("Cyprinids CPUE by monitoring areas (2008-2018)")
```

![](ao_prep_files/figure-gfm/select%20time%20period%20and%20plot%20data-2.png)<!-- -->

``` r
ggplot(filter(cpue, Taxa == "Piscivores")) +
  geom_point(aes(Year, cpue)) +
  facet_wrap(~monitoring_area, scales="free_y") +
  theme(axis.text.x = element_text(angle = 90)) +
  ggtitle("Piscivores CPUE by monitoring areas (2008-2018)")
```

![](ao_prep_files/figure-gfm/select%20time%20period%20and%20plot%20data-3.png)<!-- -->
<br/>

**Transform data**

``` r
# square root transform and zscore each time series
cpue_trans <- cpue %>%
  mutate(cpue_sqrt = sqrt(cpue))%>% ## square root transform the data
  group_by(bhi_id, rgn_nam, monitoring_area, core_indicator, Taxa) %>%
  mutate(cpue_mean = mean(cpue_sqrt, na.rm = TRUE),
         cpue_sd = sd(cpue_sqrt, na.rm=TRUE),
         cpue_z = ((cpue_sqrt - cpue_mean)/cpue_sd)) %>% ## zscore the transformed data, each time series zscored to itself
  ungroup()

## check zscore mean should be = 0, sd should be = 1
cpue_trans %>% 
  dplyr::select(monitoring_area, core_indicator, Taxa, cpue_z) %>%
  group_by(monitoring_area, core_indicator, Taxa) %>%
  summarise(mean_check = mean(cpue_z, na.rm = TRUE),
            sd_check = sd(cpue_z, na.rm = TRUE)) %>%
  ungroup()
```

    ## # A tibble: 90 x 5
    ##    monitoring_area                core_indicator     Taxa    mean_check sd_check
    ##    <chr>                          <chr>              <chr>        <dbl>    <dbl>
    ##  1 Area south of Zealand (SmÂlan… Key species        Flound…   7.22e-16     1   
    ##  2 Arhus Bay                      Key species        Flound…   7.12e-17     1   
    ##  3 Asko                           Key functional gr… Cyprin…   5.05e-17     1   
    ##  4 Asko                           Key functional gr… Pisciv…   2.88e-16     1.00
    ##  5 Asko                           Key species        Perch    -2.32e-16     1.00
    ##  6 Curonian Lagoon                Key functional gr… Cyprin…   0.           1   
    ##  7 Curonian Lagoon                Key functional gr… Pisciv…   1.44e-16     1   
    ##  8 Curonian Lagoon                Key species        Perch     1.20e-16     1   
    ##  9 Daugagriva                     Key functional gr… Cyprin…  -2.76e-16     1   
    ## 10 Daugagriva                     Key functional gr… Pisciv…  -2.50e-16     1   
    ## # … with 80 more rows

``` r
## means are all very different,sd are 1
  
## Plot sqrt transformed and zscored data
ggplot(filter(cpue_trans, core_indicator == "Key species")) +
  geom_point(aes(Year, cpue_z))+
  geom_hline(yintercept = 0) +
  facet_wrap(~monitoring_area, scales="free_y") +
  theme(axis.text.x = element_text(angle = 90)) +
  ggtitle("Key Species CPUE Sqrt Zscore")
```

![](ao_prep_files/figure-gfm/transform%20data-1.png)<!-- -->

``` r
ggplot(filter(cpue_trans, Taxa == "Cyprinids")) +
  geom_point(aes(Year, cpue_z))+
  geom_hline(yintercept = 0) +
  facet_wrap(~monitoring_area, scales="free_y") +
  theme(axis.text.x = element_text(angle = 90)) +
  ggtitle("Cyprinids CPUE Sqrt Zscore")
```

![](ao_prep_files/figure-gfm/transform%20data-2.png)<!-- -->

``` r
ggplot(filter(cpue_trans, Taxa =="Piscivores")) +
  geom_point(aes(Year, cpue_z)) +
  geom_hline(yintercept = 0) +
  facet_wrap(~monitoring_area, scales="free_y") +
  theme(axis.text.x = element_text(angle = 90)) +
  ggtitle("Piscivores CPUE Sqrt Zscore")
```

![](ao_prep_files/figure-gfm/transform%20data-3.png)<!-- -->

**Fit LM, extract slope**

``` r
library(broom)
cpue_mdl <- cpue_trans %>%
  dplyr::select(bhi_id, rgn_nam, monitoring_area, core_indicator, Taxa, Year, cpue_z) %>%
  mutate(Year = as.numeric(Year)) %>% 
  group_by(bhi_id, rgn_nam, monitoring_area, core_indicator, Taxa) %>%
  drop_na(cpue_z) %>% # need to drop 'NA' to make the lm work
  do(mdl = lm(cpue_z ~ Year, data = .)) %>%             # regression model to get the trend
  summarize(bhi_id = bhi_id,
            rgn_nam = rgn_nam,
            monitoring_area = monitoring_area,
            core_indicator = core_indicator,
            Taxa = Taxa,
            slope = coef(mdl)['Year'],
            r2 = as.numeric(summary(mdl)['r.squared']),
            nobs = nrow(augment(mdl))) %>%  ## augment() is from the broom library, extracts fits including data, rows of output matches number of obs used
  ungroup()

## Is the number of observations ever less than 5 for lm?
cpue_mdl %>% 
  dplyr::select(nobs) %>% 
  min()  ## yes, there is a row with 3 obs (remove that?)
```

**Plot slope extracted with number of observations**

``` r
## Plot slope extracted with number of observations
ggplot(cpue_mdl) +
  geom_point(aes(rgn_nam, slope, colour = monitoring_area, 
                 shape = core_indicator, label = nobs), size = 2) +
  geom_hline(yintercept = 0) +
  geom_text(aes(rgn_nam, slope, label = nobs), size = 2.5, alpha = 0.5) +
  theme(axis.text.x = element_text(colour = "grey20", size = 8, angle = 90,
                                   hjust = .5, vjust = .5, face = "plain")) +
  labs(x = "BHI region", y = "Slope") +
  guides(colour = "none") +
  ggtitle("lm slopes 2008-2018")
```

![](ao_prep_files/figure-gfm/ao%20plot%20slope-1.png)<!-- -->

``` r
## Plot without number of observations
ggplot(cpue_mdl) +
  geom_point(aes(rgn_nam, slope, colour = monitoring_area,
                 shape = core_indicator), size = 2.5, alpha = 0.5) +
  geom_hline(yintercept = 0) +
  theme(axis.text.x = element_text(colour = "grey20", size = 8, angle = 90,
                                   hjust = .5, vjust = .5, face = "plain")) +
  labs(x = "BHI region", y = "Slope") +
  guides(colour = "none") +
  ggtitle("lm slopes per monitoring areas (2008-2018)")
```

![](ao_prep_files/figure-gfm/ao%20plot%20slope-2.png)<!-- -->

### 5.2 Plot the slopes from all timeseries

``` r
#### Plot the slopes from all timeseries
ggplot(cpue_mdl)+
  geom_hline(yintercept = 0) +
  geom_boxplot(aes(rgn_nam, slope)) +
  facet_wrap(~core_indicator + Taxa)+
  theme(axis.text.x = element_text(colour = "grey20", size = 8, angle = 90,
                                   hjust = .5, vjust = .5, face = "plain")) +
  labs(x = "BHI region", y = "Slope") +
  ggtitle("Time Series slope by Indicator type and Taxa")
```

![](ao_prep_files/figure-gfm/plot%20slopes-1.png)<!-- -->

``` r
## Only Functional groups
ggplot(filter(cpue_mdl, core_indicator == "Key functional group")) +
  geom_hline(yintercept = 0) +
  geom_point(aes(rgn_nam, slope, colour = monitoring_area)) +
  facet_wrap(~Taxa) +
  theme(axis.text.x = element_text(colour = "grey20", size = 8, angle = 90,
                                   hjust = .5, vjust = .5, face = "plain"),
        legend.text = element_text(colour = "grey20", size = 5),
        plot.title = element_text(colour = "grey20", size = 8)) +
  labs(x = "BHI region", y = "Slope") +
  ggtitle("Time Series slope for Functional Group by Taxa")
```

![](ao_prep_files/figure-gfm/plot%20slopes-2.png)<!-- -->

``` r
## Only Key Species
ggplot(filter(cpue_mdl, core_indicator == "Key species")) +
  geom_hline(yintercept = 0) +
  geom_point(aes(rgn_nam, slope, colour = monitoring_area, shape = Taxa)) +
  theme(axis.text.x = element_text(colour = "grey20", size = 8, angle = 90,
                                   hjust = .5, vjust = .5, face = "plain"),
        legend.text = element_text(colour = "grey20", size = 5),
        plot.title = element_text(colour = "grey20", size = 8)) +
  #guides(size=.5)+
  labs(x = "BHI region", y = "Slope") +
  ggtitle("Time Series slope for Key Species by Taxa")
```

![](ao_prep_files/figure-gfm/plot%20slopes-3.png)<!-- -->

### 5.3 Mean Slope group per bhi region

Within each time series group (key species, cyprinid, piscivore), take
the mean slope for each group within each bhi region

``` r
## slope (per bhi region)
slope_bhi <- cpue_mdl %>%
  mutate(bhi_id = as.character(bhi_id)) %>% 
  group_by(bhi_id, core_indicator, Taxa) %>%
  mutate(slope_mean_bhi_taxa = mean(slope)) %>% 
#  stringi::stri_sort("bhi_id", numeric = TRUE) %>% 
  ungroup() 

## number of time series for each bhi region
bhi_n_obs_slope <- slope_bhi %>%
  dplyr::select(bhi_id)%>%
  count(bhi_id)

## Plot
ggplot(slope_bhi) + 
  geom_hline(yintercept = 0) +
  geom_boxplot(aes(rgn_nam, slope)) +
  geom_point(aes(rgn_nam, slope_mean_bhi_taxa), colour = "red") +
  facet_wrap(~core_indicator + Taxa)+
  theme(axis.text.x = element_text(colour = "grey20", size = 8, angle = 90,
                                   hjust = .5, vjust = .5, face = "plain")) +
  labs(x = "BHI region", y = "Slope") +
  ggtitle("Mean slope by bhi region and indicator taxa")
```

![](ao_prep_files/figure-gfm/mean%20slope%20by%20group%20per%20bhi%20region-1.png)<!-- -->

### 5.4 Mean slope for each indicator (Functional group, Key Spp)

Within each bhi region take a mean functional group indicator slope
(mean of cyprinid mean and piscivore mean) and take mean of each Key
species indicator

``` r
## new object only mean value
slope <- slope_bhi %>%
  dplyr::select(bhi_id, rgn_nam, core_indicator, Taxa, slope_mean_bhi_taxa)

slope2 <- slope %>%
  group_by(bhi_id, core_indicator) %>%
  mutate(slope_mean_bhi_indicator = mean(slope_mean_bhi_taxa)) %>%
  ungroup()
# str(slope2)

# plot
ggplot(slope2) + 
  geom_hline(yintercept = 0) +
  geom_point(aes(rgn_nam, slope_mean_bhi_indicator), colour = "red") +
  facet_wrap(~core_indicator) +
  theme(axis.text.x = element_text(colour = "grey20", size = 8, angle = 90,
                                   hjust = .5, vjust = .5, face = "plain")) +
  ylim(-.3,.3) +
  labs(y = "Slope", x = "BHI region") +
  ggtitle("Mean slope by bhi region and indicator type")
```

![](ao_prep_files/figure-gfm/ao%20mean%20indicator%20slope-1.png)<!-- -->

### 5.5 BHI region mean slope

Take the mean for each bhi region across the indicator types (Functional
groups, key species)

``` r
## new object only bhi rgn and indicator mean
slope3 <- slope2 %>%
  dplyr::select(bhi_id, rgn_nam, core_indicator, slope_mean_bhi_indicator)

slope3 <- slope3 %>%
  group_by(bhi_id) %>%
  mutate(slope_mean_bhi = mean(slope_mean_bhi_indicator)) %>%
  ungroup()

ggplot(slope3) + 
  geom_hline(yintercept = 0) +
  geom_point(aes(rgn_nam, slope_mean_bhi), colour = "black", size = 3) +
  geom_point(aes(rgn_nam, slope_mean_bhi_indicator, shape = core_indicator), colour = "red") +
  theme(axis.text.x = element_text(colour = "grey20", size = 8, angle = 90,
                                   hjust = .5, vjust = .5, face = "plain")) +
  scale_shape_manual(values = c(1:2)) +
  ylim(-.3,.3) +
  labs(y = "Slope", x = "BHI region") +
  ggtitle("Mean slope (black dots) by bhi region")
```

![](ao_prep_files/figure-gfm/ao%20bhi%20mean%20slope-1.png)<!-- -->

#### 5.5.1 Investigate on functional groups slopes

This plot might help explaining the overall positive trend of functional
groups

``` r
# Investigate on functional groups
slope22 <- slope2 %>%
  group_by(bhi_id, core_indicator) %>%
  mutate(slope_mean_bhi_indicator = mean(slope_mean_bhi_taxa)) %>%
  filter(Taxa %in% c("Cyprinids", "Piscivores")) %>%
  ungroup() 
# str(slope22)

ggplot(slope22) + 
  geom_hline(yintercept = 0) +
  geom_point(aes(rgn_nam, slope_mean_bhi_indicator), colour = "black", size = 3) +
  geom_point(aes(rgn_nam, slope_mean_bhi_taxa, shape = Taxa), colour = "red") +
  theme(axis.text.x = element_text(colour = "grey20", size = 8, angle = 90,
                                   hjust = .5, vjust = .5, face = "plain")) +
  scale_shape_manual(values = c(1:2)) +
  ylim(-.3,.3) +
  labs(y = "Slope", x = "BHI region") +
  ggtitle("Functional Groups mean slope (black dots) by BHI regions")
```

![](ao_prep_files/figure-gfm/ao%20functional%20group%20mean%20slope-1.png)<!-- -->

``` r
## This plot might help explaining the overall positive trend of functional groups
```

### 5.6 Final slope object

``` r
## new object, only bhi rgn mean
slope4 <- slope3 %>%
  dplyr::select(bhi_id, slope_mean_bhi) %>% 
  distinct(.)

bhi_slope <- slope4 %>%
  dplyr::select(bhi_id, slope_mean_bhi)%>%
  dplyr::rename(rgn_id = bhi_id,
                score = slope_mean_bhi) %>%
  mutate(rgn_id = as.numeric(rgn_id),
         dimension="trend",
         score = round(score, 2)) %>% ## round to 2 decimal places
  dplyr::select(rgn_id, dimension,score)
```

#### 5.6.1. Plot final slope object

Size points by number of times series used

``` r
##object with number of observations
plot_slope <- bhi_slope %>%
  full_join(., basin_lookup, by = c("rgn_id" = "bhi_id")) %>% 
  full_join(., basin_n_obs, by= c("rgn_id" = "BHI_ID")) %>% 
  filter(!is.na(score))

ggplot(plot_slope) +
  geom_hline(yintercept = 0) +
  geom_point(aes(rgn_nam, score, color = n, size = n)) +
  ylim(-1, 1) +
  labs(y="Slope", x = "BHI regions") +
  theme(axis.text.x = element_text(colour = "grey20", size = 8, angle = 90,
                                   hjust = .5, vjust = .5, face = "plain")) +
  ggtitle("AO Slope")
```

![](ao_prep_files/figure-gfm/ao%20plot%20final%20code%20object-1.png)<!-- -->

``` r
ggplot(rbind(plot_status, plot_slope)) + 
  geom_col(aes(rgn_nam, score, fill = subbasin), alpha = 0.5, show.legend = FALSE) +
  coord_flip() +
  facet_wrap(~dimension, scales = "free_x", nrow = 1) +
  labs(x = "BHI Region\n", y = "Score") +
  ggtitle("AO Status and Trend Scores by Region") +
  scale_fill_manual(values = statuspal) +
  theme(axis.text.y = element_text(size = 7))
```

![](ao_prep_files/figure-gfm/ao%20plot%20final%20code%20object-2.png)<!-- -->

**Export Data Layers**

``` r
## Data layers for the stock component of AO

## Status Score
write_csv(bhi_status, file.path(dir_layers, 'ao_stock_status_bhi2019.csv'))

## Slope for Trend
write_csv(bhi_slope, file.path(dir_layers, 'ao_stock_slope_bhi2019.csv'))
```

## 6\. Considerations for `BHI3.0`

Stock was one component of the AO goal. Model could be updated with
parameters representing **access** and **need** of artisanal fishing
opportunities in the future. Jens Olsson and his group will compile
information on current regulations for small-scale fishing in the Baltic
Sea along the coast. There is an NGO called [‘Low Impact Fishers of
Europe (LIFE)’](https://lifeplatform.eu/) that could provide this type
of information for both recreational and commercial fishing.

<br>

## 7\. References

[HELCOM coastal fish core indicator database
(COOL)](http://bio.helcom.fi/apex/f?p=108:5::::::)

[Status of coastal fish communities in the Baltic Sea during 2011-2016 —
the third thematic
assessment](https://helcom.fi/media/publications/BSEP161.pdf)

[HELCOM Abundance of key coastal fish species core
indicator](https://helcom.fi/media/core%20indicators/Abundance-of-key-coastal-fish-species-HELCOM-core-indicator-2018.pdf)

[HELCOM Abundance of coastal fish key functional groups core
indicator](https://helcom.fi/media/core%20indicators/Abundance-of-coastal-fish-key-functional-groups-HELCOM-core-indicator-2018.pdf)

[HELCOM Guidelines for coastal fish
monitoring](https://helcom.fi/wp-content/uploads/2020/01/HELCOM-Guidelines-for-coastal-fish-monitoring-2019.pdf)
