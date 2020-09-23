Sense of Place (SP) - Iconic Species (ICO) Subgoal Data Preparation
================

-   [1. Background](#background)
    -   [1.1 Goal Description](#goal-description)
    -   [1.2 Model & Data](#model-data)
    -   [1.3 Reference points](#reference-points)
    -   [1.4 Other information](#other-information)
-   [2. Data](#data)
    -   [2.1 Datasets with Sources](#datasets-with-sources)
    -   [2.2 Adding Region Information to Dataset](#adding-region-information-to-dataset)
-   [3. Prep: Wrangling & Derivations, Checks/Evaluation, Gapfilling](#prep-wrangling-derivations-checksevaluation-gapfilling)
    -   [3.1 Filtering to keep only Iconic Species](#filtering-to-keep-only-iconic-species)
    -   [3.2 Add birds: white-tailed sea eagle & common eider](#add-birds-white-tailed-sea-eagle-common-eider)
-   [4. Visualizing Data Layers](#visualizing-data-layers)
    -   [4.1 Iconic Species by Subbasin](#iconic-species-by-subbasin)
-   [5. Considerations for `BHI3.0`](#considerations-for-bhi3.0)
-   [6. References](#references)

<br>

1. Background
-------------

### 1.1 Goal Description

Marine species hold multiple meanings for humans, ranging from the food provisioning and socio-economic services perspective to aesthetic and religious values across diverse societies and communities. This subgoal captures the status of species that are important to a region because they are relevant to local cultural identity.

**For the BHI, a survey identified the following iconic species:**

-   Cod
-   Flounder
-   Herring
-   Perch
-   Pike
-   Salmon
-   Trout
-   Sprat
-   Grey seal
-   European otter
-   Harbour seal
-   Harbour porpoise
-   Ringed seal
-   White-tailed sea eagle
-   Common eider/

### 1.2 Model & Data

The status of iconic species was evaluated using species observational data from the HELCOM database. A subset of species identified as culturally significant in the region included eight fish (cod, flounder, herring, perch, pike, salmon, trout, and sprat), five mammals (grey seal, harbour seal, ringed seal, harbour porpoise, and European otter), and two birds (sea eagle and common eider). The status of each of these iconic species is a numeric weight corresponding to their Red List threat category (ranging from “extinct” to “least concern”) of the International Union for Conservation of Nature (IUCN).

HELCOM provides species checklists for the Baltic that include distribution and a complete list of all species assessed with IUCN criteria. Species were assigned a *threat category* (ranging from "extinct" to "least concern") and assigned a weight. The goal score is the average weight of all species assessed.

### 1.3 Reference points

A maximum score of 100 will be achieved in the case when all species are categorised as **’Least Concern’**.

### 1.4 Other information

<br/>

2. Data
-------

This prep document is used to generate and explore the following data layers:

-   `sp_ico_assessments_bhi2019.csv`

These are saved to the layers folder. These are based on the `bd_spp_all_assessments.csv` dataset saved to the `data/ICO/v2019/intermediate` folder during the Biodiversity species subgoal data prep (see `prep/ICO/v2019/spp_prep.Rmd` for details). All these are derived from or informed by the raw datasets from datasets from the HELCOM Biodiversity database: Observations data, Red list information data, Species data.

<br>

### 2.1 Datasets with Sources

<br/>

#### 2.1.1 Species Presence, Observations and Red List Assessments

To obtain data in shapefile format: downloaded, unzipped, opened (observations\_final.gdb, observation\_points layer) in QGIS, exported to shapefile. *These data are obtained from the HELCOM species database, compiled from original data sources: Shark SMHI, Species Observations System (Artportalen), MVM, and Entomological Collections (NHRS) from GBIF.*

<!-- dataset save location BHI_share/BHI 2.0/Goals/BD/baltic_species/baltic_species.shp -->
| Option   | Specification                            |
|:---------|:-----------------------------------------|
| Tab:     | Download                                 |
| Dataset: | Observations data ESRI Geodatabase (ZIP) |

<br>

#### 2.1.2 Red list (IUCN) information, about Species and their Assessment at HELCOM

<!-- dataset save location BHI_share/BHI 2.0/Goals/BD/species_with_redlist_category/species_with_redlist_category.csv -->
| Option   | Specification                 |
|:---------|:------------------------------|
| Tab:     | Download                      |
| Dataset: | Red list information data CSV |

#### 2.1.3 Species ID, with taxanomic information for each species in HELCOM database

<!-- dataset save location BHI_share/BHI 2.0/Goals/BD/species_taxa.csv -->
| Option   | Specification    |
|:---------|:-----------------|
| Tab:     | Download         |
| Dataset: | Species data CSV |

------------------------------------------------------------------------

<br/>

### 2.2 Adding Region Information to Dataset

``` r
## root location of the raw data
dir_rawdata <- file.path(dir_B, "Goals", "BD")
```

**Remove spatial 'depth' dimension, and assign BHI Region IDs**

Data points in the raw species observation dataset have latitude/longitude information. We join BHI region and Subbassin information based on the given latitude/longitude. The code chunk below alsoo renames some columns.

<br/>

<br/>

<br>

3. Prep: Wrangling & Derivations, Checks/Evaluation, Gapfilling
---------------------------------------------------------------

``` r
subbasins <- c(
  "Kattegat", "Great Belt", "The Sound", "Bay of Mecklenburg", "Kiel Bay",
  "Arkona Basin", "Bornholm Basin", "Western Gotland Basin", "Eastern Gotland Basin",
  "Gdansk Basin", "Northern Baltic Proper", "Gulf of Riga", "Gulf of Finland",
  "Aland Sea", "Bothnian Sea", "The Quark", "Bothnian Bay"
)

## create a dataframe with the info on fish which were missing from the biodiversity goal 'observations' data...
## we need these fish species here even more than for the BD goal, because half the iconic species list are fish...
## not finding specific ranges for pike and trout and also they are coastal/inland not in opensea, so will exclude here
missing_fis <- tibble(
  scientific_name = c(
    "Clupea harengus", "Salmo salar", "Gadus morhua",
    "Clupea harengus", "Salmo salar", "Gadus morhua",
    "Gadus morhua (Kattegat subpopulation)",
    "Gadus morhua (Western Baltic subpopulation)",
    "Gadus morhua (Eastern Baltic subpopulation)",
    # "Esox lucius", "Salmo trutta", 
    "Sprattus sprattus"
  ),
  Subbasin = c(
    list(subbasins[1:17]), list(subbasins[c(15:17, 8)]), list(subbasins[1:12]), 
    list(subbasins[1:17]), list(subbasins[c(15:17, 8)]), list(subbasins[1:12]), 
    list(subbasins[1]), 
    list(subbasins[2:6]), 
    list(subbasins[6:12]),
    # list(subbasins[13:17]), list(subbasins[1:3]), 
    list(subbasins[1:11])
  ),
  no_rec_this_dec = rep(FALSE, 10),
  ## cod has 2007 and a 2013 assessment
  assessment_year_red_list = c(rep(2007, 3), rep(2013, 7))
)

missing_fis <- tidyr::unnest(missing_fis, cols = c(Subbasin))

## still missing ringed seal and European/Eurasian otter...
# missing_mammals <- tidyr::unnest(missing_mammals, cols = c(Subbasin))
```

``` r
## species data with assessment (iucn) categories
sppdata <- rbind(
  read_csv(here::here("data", "ICO", "v2019", "intermediate", "bd_spp_all_assessments.csv")) %>% 
    mutate(scientific_name = str_replace(scientific_name, "Phoca vitulina", "Phoca vitulina vitulina")),
  read_csv(here::here("data", "ICO", "v2019", "intermediate", "fis_redlist.csv")) %>% 
    mutate(scientific_name = ifelse(
      scientific_name == "Gadus morhua" & !is.na(remarks), 
      sprintf("%s (%s)", scientific_name, remarks), 
      scientific_name)
    ) %>% 
    select(scientific_name, species_group, red_list_category, assessment_year_red_list) %>% 
    right_join(missing_fis, by = c("scientific_name", "assessment_year_red_list"))
)

## looking at redlist dataframe, as used in the prep/SPP/v2019/spp_prep...
## Pusa hispida botnica has category VU - Vulnerable, assessed in 2013
ringed_seal <- tibble(
  scientific_name = "Pusa hispida",
  species_group = "Mammals",
  Subbasin = list(subbasins[11:17]),
  no_rec_this_dec = FALSE,
  assessment_year_red_list = 2013,
  red_list_category = "VU - Vulnerable"
)
ringed_seal <- tidyr::unnest(ringed_seal, cols = c(Subbasin))

sppdata_w_ringedseal <- rbind(sppdata, ringed_seal)


## list of 'iconic species' execept birds
ico_spp_list <- read_csv(file.path(loc, "ico_species_selection_fish_mammals.csv"))
ico_spp_list <- rbind(
  filter(ico_spp_list, common_name != "harbour porpoise"),
  ico_spp_list %>% 
    filter(common_name == "harbour porpoise") %>% 
    mutate(latin_name = list(c(
      "Phocoena phocoena (Baltic Sea Sub-population)",
      "Phocoena phocoena (Western Baltic Sea subpopulation)"
    ))) %>% 
    tidyr::unnest(cols = latin_name)
)

# knitr::kable(rename(ico_spp_list, `Common Name` = common_name, `Latin Name` = latin_name), format = "html") %>% 
#   kableExtra::kable_styling(latex_option = c("hold_position"), position = "left")

tab <- ico_spp_list
colnames(tab) <- c("Common Name", "Latin Name")
rownames(tab) <- NULL
htmlTable::htmlTable(tab, align = "lr", col.rgroup = c("none", "#8D909E"))
```

<table class="gmisc_table" style="border-collapse: collapse; margin-top: 1em; margin-bottom: 1em;">
<thead>
<tr>
<th style="border-bottom: 1px solid grey; border-top: 2px solid grey;">
</th>
<th style="font-weight: 900; border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: left;">
Common Name
</th>
<th style="font-weight: 900; border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: right;">
Latin Name
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;">
1
</td>
<td style="text-align: left;">
Cod
</td>
<td style="text-align: right;">
Gadus morhua
</td>
</tr>
<tr style="background-color: #8d909e;">
<td style="background-color: #8d909e; text-align: left;">
2
</td>
<td style="background-color: #8d909e; text-align: left;">
Flounder
</td>
<td style="background-color: #8d909e; text-align: right;">
Platichthys flesus
</td>
</tr>
<tr>
<td style="text-align: left;">
3
</td>
<td style="text-align: left;">
Herring
</td>
<td style="text-align: right;">
Clupea harengus
</td>
</tr>
<tr style="background-color: #8d909e;">
<td style="background-color: #8d909e; text-align: left;">
4
</td>
<td style="background-color: #8d909e; text-align: left;">
Perch
</td>
<td style="background-color: #8d909e; text-align: right;">
Perca fluviatilis
</td>
</tr>
<tr>
<td style="text-align: left;">
5
</td>
<td style="text-align: left;">
Pike
</td>
<td style="text-align: right;">
Esox lucius
</td>
</tr>
<tr style="background-color: #8d909e;">
<td style="background-color: #8d909e; text-align: left;">
6
</td>
<td style="background-color: #8d909e; text-align: left;">
Salmon
</td>
<td style="background-color: #8d909e; text-align: right;">
Salmo salar
</td>
</tr>
<tr>
<td style="text-align: left;">
7
</td>
<td style="text-align: left;">
Trout
</td>
<td style="text-align: right;">
Salmo trutta
</td>
</tr>
<tr style="background-color: #8d909e;">
<td style="background-color: #8d909e; text-align: left;">
8
</td>
<td style="background-color: #8d909e; text-align: left;">
Sprat
</td>
<td style="background-color: #8d909e; text-align: right;">
Sprattus sprattus
</td>
</tr>
<tr>
<td style="text-align: left;">
9
</td>
<td style="text-align: left;">
grey seal / gray seal
</td>
<td style="text-align: right;">
Halichoerus grypus
</td>
</tr>
<tr style="background-color: #8d909e;">
<td style="background-color: #8d909e; text-align: left;">
10
</td>
<td style="background-color: #8d909e; text-align: left;">
European otter / Euraisan otter
</td>
<td style="background-color: #8d909e; text-align: right;">
Lutra lutra
</td>
</tr>
<tr>
<td style="text-align: left;">
11
</td>
<td style="text-align: left;">
harbour seal / common seal
</td>
<td style="text-align: right;">
Phoca vitulina vitulina
</td>
</tr>
<tr style="background-color: #8d909e;">
<td style="background-color: #8d909e; text-align: left;">
12
</td>
<td style="background-color: #8d909e; text-align: left;">
ringed seal
</td>
<td style="background-color: #8d909e; text-align: right;">
Pusa hispida
</td>
</tr>
<tr>
<td style="text-align: left;">
13
</td>
<td style="text-align: left;">
harbour porpoise
</td>
<td style="text-align: right;">
Phocoena phocoena (Baltic Sea Sub-population)
</td>
</tr>
<tr style="background-color: #8d909e;">
<td style="background-color: #8d909e; border-bottom: 2px solid grey; text-align: left;">
14
</td>
<td style="background-color: #8d909e; border-bottom: 2px solid grey; text-align: left;">
harbour porpoise
</td>
<td style="background-color: #8d909e; border-bottom: 2px solid grey; text-align: right;">
Phocoena phocoena (Western Baltic Sea subpopulation)
</td>
</tr>
</tbody>
</table>
### 3.1 Filtering to keep only Iconic Species

``` r
ico_spp_data <- left_join(ico_spp_list, sppdata_w_ringedseal,  by = c("latin_name" = "scientific_name"))
## still missing mammals: ringed seal (pusa hispida) and european otter (lutra lutra)...
```

### 3.2 Add birds: white-tailed sea eagle & common eider

Discussion with Baltic Sea Centre and SRC (Nov 2016) concluded that 2 bird species as being seen as very important iconic species: white-tailed sea eagle (Haliaeetus albicilla) and common eider (Somateria mollissima). It would be important to add them to the iconic species list and in the ICO calculation. The sea -eagle need to be added manually as it is not in the species redlist from HELCOM but here we could use the status LC from the IUCN criteria based on the Europe IUCN redlist (<http://www.iucnredlist.org/details/22695137/0>). The common eider is already in the red list as VU.

``` r
## iconic birds in Baltic Sea include sea eagle and common eider
## adding both these species for all Subbasins
sea_eagle_data <- data_frame(Subbasin = subbasins) %>% 
  mutate(
    common_name = "sea eagle", 
    latin_name = "Haliaeetus albicilla", 
    species_group = "Birds", 
    red_list_category  = "LC - Least Concern", 
    no_rec_this_dec = FALSE,
    assessment_year_red_list = 2013
  )
common_eider_data <- data_frame(Subbasin = subbasins) %>% 
  mutate(
    common_name = "common eider", 
    latin_name = "Somateria mollissima", 
    species_group = "Birds", 
    red_list_category  = "VU - Vulnerable", 
    no_rec_this_dec = FALSE,
    assessment_year_red_list = 2013
  )

ico_spp_w_birds <- rbind(ico_spp_data, sea_eagle_data, common_eider_data)
```

``` r
rgns_complete <- readr::read_csv(here::here("supplement", "lookup_tabs", "rgns_complete.csv"))
  
## Write as sp_ico to layers folder
ico_spp_w_birds %>% 
  right_join(rgns_complete, by = c("Subbasin" = "subbasin")) %>% 
  select(region_id, assessment_year_red_list, scientific_name = latin_name, species_group, red_list_category) %>% 
  write.csv(here::here("layers/sp_ico_assessments_bhi2019.csv"), row.names = FALSE)

## save 'no records this decade' info also as a ICO layer, so can use for penalty/scaling?
# ico_spp_w_birds %>% 
#   right_join(rgns_complete, by = c("Subbasin" = "subbasin")) %>% 
#   filter(no_rec_this_dec == TRUE) %>% 
#   select(region_id, assessment_year_red_list, scientific_name = latin_name) %>% 
#   write.csv(here::here("layers/sp_ico_norec_bhi2019.csv"), row.names = FALSE)
```

<br/>

4. Visualizing Data Layers
--------------------------

### 4.1 Iconic Species by Subbasin

``` r
ico_spp_w_birds %>% 
  filter(!is.na(Subbasin), assessment_year_red_list == 2013) %>% 
  tidyr::complete(latin_name, Subbasin) %>% 
  mutate(presence = ifelse(is.na(red_list_category), 0, 1)) %>% 
  ggplot() +
  geom_bar(
    aes(latin_name, presence, fill = red_list_category),
    show.legend = FALSE,
    color = NA, 
    stat = "identity"
  ) +
  scale_fill_manual(values = c("indianred", "slategray2", "lightsalmon", "grey")) +
  facet_grid(cols = vars(Subbasin)) +
  theme(
    axis.text.x = element_blank(),
    axis.ticks = element_blank(),
    strip.text.x = element_text(size = 8, angle = 90, hjust = 0)
  ) +
  coord_flip() +
  labs(title = "Presence/Absence of ICO species by basin", y = NULL, x = NULL)
```

![](ico_prep_files/figure-markdown_github/plotting%20presence%20of%20different%20iconic%20species%20by%20subbasin-1.png)

<br>

5. Considerations for `BHI3.0`
------------------------------

**Species ranges:** One limitation of the observation data used is larger uncertainties in spatial ranges of rare species. Estimation of rare species could be improved to more confidently represent distributions of species around the Baltic Sea; one way to do this would be using IUCN species range maps to establish species occurrence in relation to their spatial habitat area.

**Relation to other assessments:** Improve the link between the BHI and the future Biodiversity assessments by IPBES and use the UN Ocean Biodiversity Information System (OBIS) as national and regional assessments will be performed and linked to IPBES in the future.

**Data consideration:** Lack of quantitative information about the level of effort involved in obtaining the species observations data, or background environmental conditions corresponding to the data points, precludes useful interpretation from observation frequencies of species; rigorous assessment of the historical conditions of all species collectively would require this data which is not readily.

<br>

6. References
-------------
