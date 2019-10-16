Wild-Caught Fisheries - Food Provision Subgoal data prep
================

-   [1. Background](#background)
    -   [Goal Description](#goal-description)
    -   [Model & Data](#model-data)
    -   [Reference points](#reference-points)
    -   [Other information](#other-information)
-   [2. Data](#data)
    -   [2.1 Datasets with Sources](#datasets-with-sources)
    -   [2.2 Centralization & Normalization](#centralization-normalization)
    -   [2.3 Initial Data Exploration](#initial-data-exploration)
-   [3. Prep: Wrangling & Derivations, Checks/Evaluation, Gapfilling](#prep-wrangling-derivations-checksevaluation-gapfilling)
    -   [3.1 Reorganizing/wrangling](#reorganizingwrangling)
    -   [3.2 Evaluate flagged data & sampling patterns](#evaluate-flagged-data-sampling-patterns)
    -   [3.3 Status and trend options and calculation](#status-and-trend-options-and-calculation)
    -   [3.4 Gapfilling](#gapfilling)
    -   [3.5 Methods discussion](#methods-discussion)
-   [4. Visualizing Data Layers](#visualizing-data-layers)
    -   [4.1 Proportions of Total Catch over time](#proportions-of-total-catch-over-time)
    -   [4.2 Regional Proportions of Total Catch](#regional-proportions-of-total-catch)
    -   [4.3 Timeseries plots of F/FMSY, B/BMSY, and Landings](#timeseries-plots-of-ffmsy-bbmsy-and-landings)
    -   [4.4 FIS Goal Status Map](#fis-goal-status-map)
-   [5. References](#references)

``` r
loc <- file.path(here::here(), "prep", "FIS")

source(file.path(here::here(), "R", "setup.R"))
```

    ## here() starts at /Users/eleanorecampbell/Desktop/GitHub/bhi-prep

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

``` r
source(file.path(here::here(), "R", "prep.R"))
knitr::opts_chunk$set(message = FALSE, warning = FALSE, results = "hide", fig.width=9.5)

bkgd_path <- file.path(here::here(), "supplement", "goal_summaries", "FIS.Rmd")
data_path <- file.path(here::here(), "data", "FIS", version_year, "fis_np_data.rmd")
refs_path <- file.path(loc, "fis_references.Rmd")

dir_layer <- file.path(here::here(), "layers")
```

1. Background
-------------

### Goal Description

The Fisheries sub-goal of Food Provision describes the ability to maximize the sustainable yield of wild-caught seafood for human consumption. **For the BHI cod and herring stocks in the Baltic Sea were included as wild-caught fisheries**.

### Model & Data

The data used for this goal are composed of cod and herring spawning biomass (SSB) and fishing mortality (F) data. The current status is calculated as a function of the ratio (B’) between the single species current biomass at sea (B) and the reference biomass at maximum sustainable yield (BMSY), as well as the ratio (F’) between the single species current fishing mortality (F) and the fishing mortality at maximum sustainable yield (FMSY). B/Bmsy and F/Fmsy data are converted to scores between 0 and 1 using this [general relationship](https://github.com/OHI-Science/bhi-prep/blob/master/prep/FIS/ffmsy_bbmsy_score.png), also captured in [this formula](https://cloud.githubusercontent.com/assets/5685517/11152185/5291d988-89ee-11e5-839a-0b1b162832f3.png). This equation simply converts the F/FMSY value to an F' score that will fall between 0-1 (this function applies a penalty when b/bmsy scores indicate good/underfishing, i.e., &gt;= 0.8, but f/fmsy scores indicate high fisheries related mortality, i.e., &gt; 1.2).

-   [Cod and herring data accessed from the ICES homepage](http://www.ices.dk/marine-data/tools/Pages/stock-assessment-graphs.aspx) &gt; search for 'cod' or 'herring' &gt; specify the ecoregion as Baltic Sea &gt; search for the 2013 assessment.

### Reference points

The reference point used for the computation are based on the MSY principle and are described as a functional relationship. MSY means the highest theoretical equilibrium yield that can be continuously taken on average from a stock under existing average environmental conditions without significantly affecting the reproduction process *(European Union 2013, World Ocean Review 2013).*

### Other information

*External advisors/goalkeepers are Christian Möllmann & Stefan Neuenfeldt*

<br/>

<!-- ## 2. Data --- header in the child  document -->
2. Data
-------

### 2.1 Datasets with Sources

<br/>

#### Landings (for F/FMSY) and SSB (for B/BMSY) Data

<br/>

**Cod in subdivisions 22-24, western Baltic stock**
<!-- dataset save location BHI_share/2.0/Goals/FP/Fisheries/Cod/cod_SDs22-24 -->

| Option                 | Specification |
|:-----------------------|:--------------|
| Species:               | Gadus morhua  |
| EcoRegion (Fishstock): | Baltic Sea    |
| Assessment year:       | 2019          |
| FishStock:             | cod.27.22-24  |
| Assessment Key:        | 10446         |
| <br/>                  |               |

**Cod in subdivisions 24-32, eastern Baltic stock**
<!-- dataset save location BHI_share/2.0/Goals/FP/Fisheries/Cod/cod_SDs24-32 -->

| Option                 | Specification |
|:-----------------------|:--------------|
| Species:               | Gadus morhua  |
| EcoRegion (Fishstock): | Baltic Sea    |
| Assessment year:       | 2019          |
| FishStock:             | cod.27.24-32  |
| Assessment Key:        | 12941         |
| <br/>                  |               |

**Herring in subdivisions 20-24 -Skagerrak, Kattegat and western Batic-**
<!-- dataset save location BHI_share/2.0/Goals/FP/Fisheries/Herring/herring_SDs20-24 -->

| Option                 | Specification   |
|:-----------------------|:----------------|
| Species:               | Clupea harengus |
| EcoRegion (Fishstock): | Baltic Sea      |
| Assessment year:       | 2019            |
| FishStock:             | her.27.20-24    |
| Assessment Key:        | 12592           |
| <br/>                  |                 |

**Herring in subdivisions 25-29,32 -central Baltic Sea (excluding Gulf of Riga)-**
<!-- dataset save location BHI_share/2.0/Goals/FP/Fisheries/Herring/herring_SDs25-29,32 -->

| Option                 | Specification   |
|:-----------------------|:----------------|
| Species:               | Clupea harengus |
| EcoRegion (Fishstock): | Baltic Sea      |
| Assessment year:       | 2019            |
| FishStock:             | her.27.25-2932  |
| Assessment Key:        | 10408           |
| <br/>                  |                 |

**Herring in subdivision 28.1 (Gulf of Riga)**
<!-- dataset save location BHI_share/2.0/Goals/FP/Fisheries/Herring/herring_SD_28.1 -->

| Option                 | Specification   |
|:-----------------------|:----------------|
| Species:               | Clupea harengus |
| EcoRegion (Fishstock): | Baltic Sea      |
| Assessment year:       | 2019            |
| FishStock:             | her.27.28       |
| Assessment Key:        | 10404           |
| <br/>                  |                 |

**Herring in subdivisions 30-31 (Gulf of Bothnia)**
<!-- dataset save location BHI_share/2.0/Goals/FP/Fisheries/Herring/herring_SDs30-31 -->

| Option                 | Specification   |
|:-----------------------|:----------------|
| Species:               | Clupea harengus |
| EcoRegion (Fishstock): | Baltic Sea      |
| Assessment year:       | 2019            |
| FishStock:             | her.27.3031     |
| Assessment Key:        | 12738           |
| <br/>                  |                 |

**Sprat in subdivisions 22-32 (Baltic Sea)**
<!-- dataset save location BHI_share/2.0/Goals/NP/Sprat/sprat_SDs22-32 -->

| Option                 | Specification     |
|:-----------------------|:------------------|
| Species:               | Sprattus sprattus |
| EcoRegion (Fishstock): | Baltic Sea        |
| Assessment year:       | 2019              |
| FishStock:             | spr.27.22-32      |
| Assessment Key:        | 12942             |
| <br/>                  |                   |

#### FMSY and BMSY

[Cod (Gadus morhua) in subdivisions 22–24, western Baltic stock (western Baltic Sea)](Reference%20points:%20http://ices.dk/sites/pub/Publication%20Reports/Advice/2019/2019/cod.27.22-24.pdf): BMSY: 21 876 ; FMSY (Ftotal 2020): 0.26

[Cod (Gadus morhua) in subdivisions 24–32, eastern Baltic stock (eastern Baltic Sea)](Reference%20points:%20http://ices.dk/sites/pub/Publication%20Reports/Advice/2019/2019/cod.27.24-32.pdf): BMSY (Bpa): 108 035 ; FMSY: 0.3

[Herring (Clupea harengus) in Subdivisions 20-24 (Skagerrak, Kattegat and western Baltic)](Reference%20points:%20http://ices.dk/sites/pub/Publication%20Reports/Advice/2019/2019/her.27.20-24.pdf): BMSY 150 000 ; FMSY 0.31

[Herring (Clupea harengus) in Subdivisions 25-29,32 (excluding Gulf of Riga)](Reference%20points:%20http://ices.dk/sites/pub/Publication%20Reports/Advice/2019/2019/her.27.25-2932.pdf): BMSY 600 000 ; FMSY 0.22

[Herring (Clupea harengus) in Subdivision 28.1 (Gulf of Riga)](Reference%20points:%20http://ices.dk/sites/pub/Publication%20Reports/Advice/2019/2019/her.27.28.pdf): BMSY 60 000 ; FMSY 0.32

[Herring (Clupea harengus) in Subdivisions 30 and 31 (Gulf of Bothnia)](Reference%20points:%20http://ices.dk/sites/pub/Publication%20Reports/Advice/2019/2019/her.27.3031.pdf): BMSY 140 998 ; FMSY 0.15

[Sprat (Sprattus sprattus) in Subdivisions 22-32 (Baltic Sea)](Reference%20points:%20http://ices.dk/sites/pub/Publication%20Reports/Advice/2019/2019/spr.27.22-32.pdf): BMSY 570 000 ; FMSY 0.26

### 2.2 Centralization & Normalization

#### 2.2.1 Standardize Units

#### 2.2.2 Rename Fields/Variables

#### 2.2.3 Save to BHI Database

<br/>

### 2.3 Initial Data Exploration

#### 2.3.1 Compare versus Previous Years Data

#### 2.3.2 Timeseries Plots

#### 2.3.3 Map

<br/>

3. Prep: Wrangling & Derivations, Checks/Evaluation, Gapfilling
---------------------------------------------------------------

### 3.1 Reorganizing/wrangling

This section prepares data layers for FIS and NP at the same time, separating the fish stocks for each:

-   FIS stocks: cod\_22-24, cod\_25-32, her\_28.1, her\_20-24, her\_25-29,32, her\_30-31
-   NP stocks: spr\_22-32

**Load datasets:**

``` r
## root location of the raw data
dir_rawdata <- file.path(dir_B, "Goals", "FP", "FIS") # list.files(dir_rawdata)

## Fisheries data from ICES
## note if csvs are saved w/ semicolons, to read columns...

# source(file.path(here::here(), "R", "semicolon_to_comma.R"))
# lapply(
#   list("cod_SDs22_24", "cod_SDs24_32",
#        "herring_SD_28.1", "herring_SDs20_24",
#        "herring_SDs25_29_32", "herring_SDs30_31"),
#   function(x){
#      fp <- file.path(dir_rawdata, x, paste0(x, "_reformat.csv"))
#      semicolon_to_comma(fp, remove_na_cols = TRUE, overwrite = TRUE)
#   }
# )
# semicolon_to_comma(file.path(dir_B, "Goals", "NP", "sprat_SDs22_32", "sprat_SDs22_32_reformat.csv"), TRUE, TRUE)


## cod data
cod1raw <- read_csv(file.path(dir_rawdata, "cod_SDs22_24", "cod_SDs22_24_reformat.csv"))
cod2raw <- read_csv(file.path(dir_rawdata, "cod_SDs24_32", "cod_SDs24_32_reformat.csv"))

## herring data
herring1raw <- read_csv(file.path(dir_rawdata, "herring_SD_28.1", "herring_SD_28.1_reformat.csv"))
herring2raw <- read_csv(file.path(dir_rawdata, "herring_SDs20_24", "herring_SDs20_24_reformat.csv"))
herring3raw <- read_csv(file.path(dir_rawdata, "herring_SDs25_29_32", "herring_SDs25_29_32_reformat.csv"))
herring4raw <- read_csv(file.path(dir_rawdata, "herring_SDs30_31", "herring_SDs30_31_reformat.csv"))

## sprat data
sprat1raw <- read_csv(file.path(dir_B, "Goals", "NP", "sprat_SDs22_32", "sprat_SDs22_32_reformat.csv"))

## make MSY values table
## these values are obtained from ICES reports, see data/FIS/fis_np_data.rmd for more details
msy_data <- t(data.frame(
  c("cod", "22-24", "cod_SDs22_24", 21876, 0.26),
  c("cod", "24-32", "cod_SDs24_32", 108035, 0.3),
  c("herring", "28.1", "herring_SD_28.1", 60000, 0.32),
  c("herring", "20-24", "herring_SDs20_24", 150000, 0.31),
  c("herring", " 25-29,32", "herring_SDs25_29_32", 600000, 0.22),
  c("herring", "30-31", "herring_SDs30_31", 140998, 0.15),
  c("sprat", "22-32", "sprat_SDs22_32", 570000, 0.26)
))
colnames(msy_data) <- c("species", "SDs", "stockname", "BMSY", "FMSY")
rownames(msy_data) <- NULL
msy_data <- as_tibble(msy_data)
```

**Merge datasets and calculate F/FMSY and BBMSY ratios:**

``` r
combined_rawdata <- rbind(
  ## cod
  cod1raw %>% 
    select(
      year, ssb, 
      fis_mort = fishing_mortality_age3_5, 
      landings = landings_tonnes
    ) %>%
    mutate(stockname = "cod_SDs22_24"),
  cod2raw %>% 
    select(
      year, ssb, 
      fis_mort = fishing_mortality_age4_6, 
      landings = landings_tonnes
    ) %>% 
    mutate(stockname = "cod_SDs24_32"),
  ## herring
  herring1raw %>% 
    select(
      year, ssb = ssb_tonnes, 
      fis_mort = `F`, 
      landings = catches_tonnes
    ) %>% 
    mutate(stockname = "herring_SD_28.1"),
  herring2raw %>% 
    select(
      year, ssb = ssb_tonnes, 
      fis_mort = F_age3_6, 
      landings = catches_tonnes
    ) %>% 
    mutate(stockname = "herring_SDs20_24"),
  herring3raw %>% 
    select(
      year, ssb = ssb_tonnes, 
      fis_mort = F_age3_6, 
      landings = catches_tonnes
    ) %>% 
    mutate(stockname = "herring_SDs25_29_32"),
  herring4raw %>% 
    select(
      year, ssb = ssb, 
      fis_mort = F_age3_7, 
      landings = catches_tonnes
    ) %>% 
    mutate(stockname = "herring_SDs30_31"),
  ## sprat
  sprat1raw %>% 
    select(
      year, ssb = ssb_tonnes, 
      fis_mort = F_age3_5, 
      landings = catches_tonnes
    ) %>% 
    mutate(stockname = "sprat_SDs22_32")) %>% 
  ## join with msy data
  filter(!is.na(year)) %>% 
  left_join(msy_data, by = c("stockname")) %>% 
  mutate(bbmsy = ssb/as.numeric(BMSY), ffmsy = fis_mort/as.numeric(FMSY)) %>% 
  arrange(species, stockname, year)
```

**Convert from ICES Fisheries regions to Baltic Regions:**

[Map of ICES regions.](ICES%20regions%20map%20https://www.ices.dk/marine-data/Documents/Maps/ICES-Ecoregions-hybrid-statistical-areas.png)

``` r
## based on 'prep/FIS/raw/DataOrganization.R' by Melanie Frazier March 16 2016, in bhi-1.0-archive
## ICES regions map https://www.ices.dk/marine-data/Documents/Maps/ICES-Ecoregions-hybrid-statistical-areas.png
regions <- read_csv(
  file.path(here::here(), "supplement", "lookup_tabs", "ices_to_bhi_lookup.csv"), 
  col_types = cols()) %>% 
  dplyr::select(-ices_id)

combined_w_rgns <- combined_rawdata %>% 
  
  ## expand ices subdivisions categories to one row per subdiv
  rowwise() %>% 
  mutate(
    ## check unique(combined_rawdata$SDs) to make sure this will work
    sd_from = as.numeric(str_split(SDs, "-|,")[[1]][1]),
    sd_to = as.numeric(str_split(SDs, "-|,")[[1]][2]),
    sd_extra = as.numeric(str_split(SDs, "-|,")[[1]][3])
  ) %>% 
  mutate(
    sd_to = ifelse(is.na(sd_to), sd_from, sd_to),
    sd_extra = ifelse(is.na(sd_extra), sd_from, sd_extra),
    incl28.2 = sd_from <= 28 & sd_to >= 28,
    incl28.1 = sd_from <= 28 & sd_to >= 28 &  species != "herring"
  ) %>% 
  ## ICES regions 28.1 and 28.2 but no 28
  mutate(SDs = list(
    unique(
      c(sd_from:sd_to, sd_extra)[!c(sd_from:sd_to, sd_extra)==28] %>% 
        c(ifelse(incl28.2, 28.2, sd_from)) %>% 
        c(ifelse(incl28.1, 28.1, sd_from))
    )
  )) %>% 
  tidyr::unnest(ices_subdiv = SDs) %>% 
  dplyr::select(-sd_from, -sd_to, -sd_extra, -incl28.1, -incl28.2) %>% 
  
  ## add bhi regions info using ices_to_bhi_lookup
  left_join(regions, by = c("ices_subdiv" = "ices_numeric")) %>% 
  arrange(species, stockname, region_id, year, ices_subdiv) %>% 
  filter(year < assess_year) %>% # current yr fish. mort. data won't be complete
  filter(!ices_subdiv %in% c(20, 21)) # ICES subdivs 20 and 21 are North Sea

## full merged dataset with MSY and raw data, as well as calculated ratios
## this will be used for the shiny app among other things!
write_csv(combined_w_rgns, file.path(loc, version_year, "intermediate", "fis_full_merged_dataset.csv"))
```

**Wrangle and save layers for FIS and NP goals, and quick plots:**

``` r
## full dataset in long format with calculated ratios:
long_format_msy_metrics <- combined_w_rgns %>% 
  dplyr::select(region_id, species, stock = stockname, year, bbmsy, ffmsy) %>% 
  tidyr::gather(key = metric, value = value, -year, -stock, -species, -region_id)

msy_metrics_plot <- ggplot(long_format_msy_metrics, aes(x = year, y = value, color = stock)) +
  geom_point(size = 0.5) + geom_line() +
  geom_abline(slope = 0, intercept = 1, color = "grey") +
  facet_grid(vars(species), vars(metric)) # msy_metrics_plot

msy_metrics_plot <- msy_metrics_plot +
  theme(legend.position = "none")

## all landings data:
landings_all <- combined_w_rgns %>% 
  dplyr::select(region_id, species, stock = stockname, year, landings) %>% 
  tidyr::gather(key = "metric", value= "value", -year, -stock, -species, -region_id)

landings_plot <- ggplot(landings_all, aes(x = year, y = value, color = stock)) +
  geom_point(size = 0.5) + geom_line() +
  facet_grid(vars(species), vars(metric)) # landings_plot
```

``` r
## same preparation of data for fis and np, just different stocks used:
## cod and herring are used in the FIS goal
## sprat are used for the NP goal
goal_stocks <- c("FIS", "NP")
for(g in goal_stocks){
  
  if(g == "FIS"){
    dat <- long_format_msy_metrics %>% 
      filter(!str_detect(stock, "spr"))
    landings <- landings_all %>% 
      filter(!str_detect(stock, "spr"))
    
  } else {
    dat <- long_format_msy_metrics %>% 
      filter(str_detect(stock, "spr"))
    landings <- landings_all %>% 
      filter(str_detect(stock, "spr"))
  }
  
  ## filter to save by metric: bbmsy, ffmsy, landings
  dat_bbmsy <- dat %>% 
    filter(metric == "bbmsy") %>% 
    dplyr::select(-metric)
  dat_ffmsy <- dat %>% 
    filter(metric == "ffmsy") %>% 
    dplyr::select(-metric)
  landings <- landings %>%
    rename(landings = value) %>% 
    dplyr::select(-metric, -species)
  
  ## save the data layers
  write_csv(dat_bbmsy, file.path(
    dir_layer, 
    sprintf("%s_bbmsy_bhi%s.csv", str_to_lower(g), assess_year))
  )
  write_csv(dat_ffmsy, file.path(
    dir_layer, 
    sprintf("%s_ffmsy_bhi%s.csv", str_to_lower(g), assess_year))
  )
  write_csv(landings, file.path(
    dir_layer, 
    sprintf("%s_landings_bhi%s.csv", str_to_lower(g), assess_year))
  )
}
```

### 3.2 Evaluate flagged data & sampling patterns

### 3.3 Status and trend options and calculation

Calculating status and trend consists of the following steps: - calculate F-scores and B-scores - take mean of F and B scores, with data grouped by region\_id, stock, year - derive weights from landings data (proportions of catch made up of different stocks) - apply a penalty because of bad cod condition in the eastern baltic - calculate status is a geometric mean weighted by proportion of catch in each region

The formulas for calculating F and B scores are based on [this paper](https://doi.org/10.1371/journal.pone.0098995).

``` r
## load layers
fis_bbmsy <- read_csv(
  file.path(dir_layer, sprintf("fis_bbmsy_bhi%s.csv", assess_year))) %>% 
  rename(bbmsy = value)

fis_ffmsy <- read_csv(
  file.path(dir_layer, sprintf("fis_ffmsy_bhi%s.csv", assess_year))) %>% 
  rename(ffmsy = value)

metric_scores <- left_join(
  fis_bbmsy, 
  fis_ffmsy,  
  by = c("region_id", "stock", "year")) %>% 
  filter(!str_detect(stock, "spr"))


## F-SCORES
## calculate F-scores
F_scores <- metric_scores %>%
  mutate(score = ifelse(bbmsy < 0.8 & ffmsy >= (bbmsy+1.5), 0, NA),
         score = ifelse(bbmsy < 0.8 & ffmsy < (bbmsy - 0.2), ffmsy/(bbmsy-0.2), score),
         score = ifelse(bbmsy < 0.8 & ffmsy >= (bbmsy + 0.2) & ffmsy < (bbmsy + 1.5), (bbmsy + 1.5 - ffmsy)/1.5, score),
         score = ifelse(bbmsy < 0.8 & ffmsy >= (bbmsy - 0.2) & ffmsy < (bbmsy + 0.2), 1, score)) %>%
  mutate(score = ifelse(bbmsy >= 0.8 & ffmsy < 0.8, ffmsy/0.8, score),
         score = ifelse(bbmsy >= 0.8 & ffmsy >= 0.8 & ffmsy < 1.2, 1, score),
         score = ifelse(bbmsy >= 0.8 & ffmsy >= 1.2, (2.5 - ffmsy)/1.3, score)) %>%
  mutate(score = ifelse(score <= 0, 0.1, score)) %>%
  mutate(score_type = "F_score")

## B-SCORES
## calculate B-scores
B_scores <- metric_scores %>%
  mutate(score = ifelse(bbmsy < 0.8 , bbmsy/0.8, NA),
         score = ifelse(bbmsy >= 0.8 & bbmsy < 1.5, 1, score),
         score = ifelse(bbmsy >= 1.5, (3.35 - bbmsy)/1.8, score)) %>%
  mutate(score = ifelse(score <= 0.1, 0.1, score)) %>%
  mutate(score = ifelse(score > 1, 1, score))%>%
  mutate(score_type = "B_score")
# plot(score ~ bbmsy, data = B_scores, main = "B-scores vs. B/Bmsy values")

scores <- rbind(B_scores, F_scores) %>%
  group_by(region_id, stock, year) %>%
  summarize(score = mean(score, na.rm = TRUE))

## WEIGHTS
## calculate weights with landing data
## we use the average catch for each stock/region across all years to obtain weights
fis_landings <- read_csv(
  file.path(dir_layer, sprintf("fis_landings_bhi%s.csv", assess_year))) %>% 
  filter(!str_detect(stock, "spr")) %>% 
  filter(year > max(year) - 10) # only use most recent 10 years

weights <- fis_landings %>%
  group_by(region_id, stock) %>% # each region/stock will have same avg catch across years
  mutate(avgCatch = mean(landings)) %>% # timeseries mean
  group_by(region_id, year) %>%
  mutate(totCatch = sum(avgCatch)) %>% # total catch on average (across years)
  ungroup() %>%
  mutate(propCatch = avgCatch/totCatch) # proportion of catch each stock accounts for

## total proportion of landings for each region/year will sum to one
# chk <- weights %>%
#   group_by(region_id, year) %>%
#   summarise(sumProps = sum(propCatch))
# unique(chk$sumProps)

## STATUS
## geometric mean weighted by proportion of catch in each region
status_with_penalty <- weights %>% 
  left_join(scores, by = c("region_id", "year", "stock")) %>%
  filter(!is.na(score)) %>% # remove missing data
  dplyr::select(region_id, year, stock, propCatch, score) %>% 
  
  ## apply penalty because bad cod condition in eastern baltic
  ## penalty factor of 0.872 based on historical cod body weight
  ## by Ning Jiang, 16 Feb, 2017 in bhi-1.0-archive/baltic2015/conf/functions.R
  mutate(
    score = ifelse(
      str_detect(stock, "cod") & str_detect(stock, "32"),
      score*0.872, score
    )
  )
status <- status_with_penalty %>% 
  group_by(region_id, year) %>%
  summarize(status = prod(score^propCatch)) %>%
  ungroup()
```

### 3.4 Gapfilling

**This data processing for FIS and NP goals does not include any gapfilling or interpolation.**

### 3.5 Methods discussion

#### 3.5.1 Adjustment of Cod scores Based on Body Weight

Data source: [Casini M et al. 2016](http://dx.doi.org/10.1098/rsos.160416) Data available: 1977 - 2014 Penalty factor (according to `bhi-1.0-archive/baltic2015/prep/FIS/fis_np_prep.Rmd`): cod\_condition / mean\_cod\_condition

**[Paper](http://dx.doi.org/10.1098/rsos.160416) used for cod condition penalty factor only includes data through 2014.** Will need to recalculate penalty factor including most recent data, in future assessments, based on their methods. Additionally its **needs to be recorded in more detail transformations from [raw dataset](https://datadryad.org/stash/dataset/doi:10.5061/dryad.875fb) to condition\_cod.csv to penalty factor.**

4. Visualizing Data Layers
--------------------------

Below are some maps visualizing a few of the intermediate datasets.
Spatially, data inputs are the same value per year per stock, across the BHI regions in which the stock exists.
BHI status and trend scores differ spatially across regions as they are combinations of multiple stocks status weighted by landings proportions.

### 4.1 Proportions of Total Catch over time

Of all the fisheries landings that occurred in a given area and year, what proportion is made up by each stock?

``` r
source(file.path(here::here(), "R", "spatial.R"))
regions_shape() # loads spatial features objects

yearly_rgn_props <- fis_landings %>%
  group_by(region_id, year) %>%
  mutate(yearlyICESrgn_totCatch = sum(landings)) %>%
  ungroup() %>%
  mutate(yearly_propCatch = landings/yearlyICESrgn_totCatch) %>% 
  dplyr::select(-landings)

ggplot(filter(yearly_rgn_props, region_id %in% c(3, 11, 14, 27, 37))) + 
  geom_line(aes(x = year, y = yearly_propCatch, color = stock)) + 
  facet_wrap(~region_id, nrow = 2) + 
  ylab("proportion of stock to total catch per (ICES) region")
```

![](fis_np_prep_files/figure-markdown_github/catch%20proportions%20plots-1.png)

### 4.2 Regional Proportions of Total Catch

``` r
map_raw_data <- yearly_rgn_props %>% 
  dplyr::select(-yearlyICESrgn_totCatch) %>% 
  spread(key = "stock", value = "yearly_propCatch") %>% 
  filter(year == max(yearly_rgn_props$year)) %>%
  left_join(
    yearly_rgn_props %>% 
      filter(year == max(yearly_rgn_props$year)) %>% 
      dplyr::select(region_id, yearlyICESrgn_totCatch) %>% 
      distinct(),
    by = "region_id") %>% 
  dplyr::select(-year)

# tmp <- landings_all %>% 
#   dplyr::select(-species, -metric) %>% 
#   filter(year %in% c(2018, 2013, 2008, 1998)) %>%
#   unite(map_layer, stock, year) %>% 
#   spread(key = region_id, value = value) %>% t()
# 
# map_raw_data <- as.data.frame(tmp[-1,]) %>% 
#   cbind(region_id = as.numeric(rownames(tmp[-1,])))
# rownames(map_raw_data) <- NULL
# 
# library(magrittr)
# map_raw_data[,1:ncol(tmp)] %<>% lapply(function(x) as.numeric(as.character(x)))
# colnames(map_raw_data) <- c(tmp[1,], "region_id")

## combine with spatial info for mapping
bhi_rgns_shp <- rmapshaper::ms_simplify(input = BHI_rgns_shp) %>% 
  sf::st_as_sf() %>% 
  mutate(Name = paste(Subbasin, rgn_nam, sep = ", ")) %>% 
  left_join(map_raw_data, by = c("BHI_ID" = "region_id"))

ICES_rgns_shp <- rmapshaper::ms_simplify(input = ICES_rgns_shp) %>% 
  sf::st_as_sf()

## create a palette
pal <- colorNumeric(
  palette = "YlGnBu", na.color = "#fcfcfd",
  domain = seq(0.05, 1, 0.005))
pal_catch <- colorNumeric(
  palette = "Greys", na.color = "#fcfcfd",
  domain = seq(5000, 800000, 1000))

props_catch_map <- leaflet::leaflet(data = bhi_rgns_shp) %>% 
  addProviderTiles(providers$CartoDB.Positron) %>%
  setView(18, 59, zoom = 5)

for(i in 1:6){
  vars <- sym(c(
    "cod_SDs22_24", "cod_SDs24_32", 
    "herring_SD_28.1", "herring_SDs20_24", 
    "herring_SDs25_29_32", "herring_SDs30_31"
  )[i])
  groups <- c(
    "Cod SDs 22-24", "Cod SDs 24-32", 
    "Herring SDs 28.1 (Riga)", "Herring SDs 20-24", 
    "Herring SDs 25-29, 32","Herring SDs 30-31"
  )
  props_catch_map <- props_catch_map %>% 
    addPolygons(
      stroke = TRUE, opacity = 0.3, weight = 1, fillOpacity = 0.8,
      fillColor = ~pal(bhi_rgns_shp[[vars]]), group = groups[i]
    )
}
props_catch_map %>%
  addPolygons(
    stroke = TRUE, opacity = 0.3, weight = 1, fillOpacity = 0.8,
    fillColor = ~pal_catch(bhi_rgns_shp$yearlyICESrgn_totCatch), group = "Total Catch (tonnes)"
  ) %>% 
  addPolygons(
    popup = paste(
      "<h5><strong>", "Total Catch:", "</strong>",
      format(bhi_rgns_shp$yearlyICESrgn_totCatch, big.mark = ","), "</h5>", sep = " "
    ),
    fillOpacity = 0,
    stroke = FALSE,
    group = "Total Catch (tonnes)"
  ) %>%
  addLayersControl(
    baseGroups = c(
      "Cod SDs 22-24", "Cod SDs 24-32",
      "Herring SDs 28.1 (Riga)", "Herring SDs 20-24", "Herring SDs 25-29, 32", "Herring SDs 30-31",
      "Total Catch (tonnes)"
    ),
    options = layersControlOptions(collapsed = FALSE)
  ) %>% 
  addLegend("bottomright", pal, seq(0.05, 1, 0.005))
```

![](fis_np_prep_files/figure-markdown_github/map%20values%20by%20bhi%20and%20ices%20regions-1.png)

### 4.3 Timeseries plots of F/FMSY, B/BMSY, and Landings

``` r
## msy_metrics_plot and landings_plot created in 'wrangle and save layers for FIS and NP goals' section above
gridExtra::grid.arrange(msy_metrics_plot, landings_plot, nrow = 1, widths = c(1, 1.1))
```

![](fis_np_prep_files/figure-markdown_github/timeseries%20plots-1.png)

### 4.4 FIS Goal Status Map

``` r
## combine with spatial info for mapping
bhi_rgns_shp <- bhi_rgns_shp %>% 
  dplyr::select(rgn_nam, rgn_key, Subbasin, HELCOM_ID, BHI_ID, Area_km2, Name) %>% 
  left_join(filter(status, year == max(scores$year)), by = c("BHI_ID" = "region_id"))
pal <- colorNumeric(
  palette = "RdYlBu", na.color = "#fcfcfd",
  domain = seq(0.4, 1, 0.005))

leaflet::leaflet(data = bhi_rgns_shp) %>% 
  addProviderTiles(providers$CartoDB.Positron) %>%
  setView(18, 59, zoom = 5) %>% 
  addPolygons(
    stroke = TRUE, opacity = 0.3, weight = 1, fillOpacity = 0.7,
    fillColor = ~pal(status)
  ) %>% 
  addPolygons(
    popup = paste(
      "<h5><strong>", "Region:", "</strong>",
      bhi_rgns_shp$Name, "</h5>",
      "<h5><strong>", "Status:", "</strong>",
      round(bhi_rgns_shp$status, 2), "</h5>", sep = " "
    ),
    fillOpacity = 0,
    stroke = FALSE
  ) %>% 
  addLegend("bottomright", pal, seq(0, 1, 0.005))
```

![](fis_np_prep_files/figure-markdown_github/goal%20status%20map-1.png)

<br/>

5. References
-------------

[Casini M et al. 2016](http://dx.doi.org/10.1098/rsos.160416) Hypoxic areas, density-dependence and food limitation drive the body condition of a heavily exploited marine sh predator. R. Soc. open sci. 3: 160416. <http://dx.doi.org/10.1098/rsos.160416>
