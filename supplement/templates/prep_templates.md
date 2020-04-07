
<!-- GOAL_DATA.RMD -->

```{r preamble data, echo = FALSE, include = FALSE, error = FALSE}
source(here::here("R", "setup.R"))
```

### 2.1 Datasets with Sources
<br/>

**DATASET NAME/VARIABLE**  
<!-- dataset save location BHI_share/BHI 2.0/Goals/ -->

```{r echo = FALSE, results = "asis"}
tab <- t(data.frame(
  c("[option]:", "[specification]"), 
  c("[option]:", "[specification]")))

colnames(tab) <- c("Option", "Specification")
rownames(tab) <- NULL

knitr::kable(tab, caption = "Source: [ABC database](URL/LINK) <br/> Downloaded DATE by NAME")
```

---

<br/>


### 2.2 Centralization & Normalization

```{r load raw data, message = FALSE, echo = TRUE, warning = FALSE, results = "hide"}
## root location of the raw data
dir_rawdata <- file.path(dir_B, "Goals", "GOAL/OR/SUBGOAL")
```

#### 2.2.1 Rename Fields/Variables

#### 2.2.2 Standardize Units

#### 2.2.3 Save to BHI Database

<br/>

### 2.3 Initial Data Exploration

#### 2.3.1 Compare versus Previous Years Data

#### 2.3.2 Timeseries Plots

```{r CODE CHUNK WITH FIGURE OR GRAPH, results = "show", message = FALSE, echo = TRUE, fig.width = 9.5, fig.height = 4.5}
```

#### 2.3.3 Map


<!-- GOAL_PREP.RMD -->


---
title: "SUBGOAL - GOAL Subgoal data prep"
output:
  html_document:
    toc: true
    toc_depth: 4
    code_folding: hide
---

<br>
<br>

```{r preamble prep, message = FALSE}
loc <- here::here("prep", "GOAL", "SUBGOAL")

source(here::here("R", "setup.R"))
knitr::opts_chunk$set(message = FALSE, warning = FALSE, results = "hide", fig.width = 9.5)

bkgd_path <- here::here("supplement", "goal_summaries", "GOALCODE.Rmd")
data_path <- here::here("data", "GOAL", ["SUBGOAL"], version_year, "GOALCODE_data.rmd")
refs_path <- file.path(loc, "GOALCODE_references.Rmd")
```

## 1. Background

```{r Background, child = bkgd_path, results = "asis", echo = FALSE}
```

<br/>

## 2. Data

This prep document is used to generate and explore the following data layers:

- `LAYER1_bhi2019.csv` 
- `LAYER2_bhi2019.csv` 
- `LAYER3_bhi2019.csv` 

These are saved to the `layers/v2019` folder. Saved to `data/GOAL/v2019/intermediate` are intermediate datasets: `DATASETINTEMED1.csv` and `DATASETINTEMED2.csv`. All these are derived from or informed by the raw datasets from RAW DATA SOURCES.

<br>

<!-- ## 2. Data --- header in the child  document -->
```{r Data, child = data_path, results = "asis", echo = FALSE}
```

<br/>

## 3. Prep: Wrangling & Derivations, Checks/Evaluation, Gapfilling

<br/>

## 4. Visualizing Data Layers

### 4.1 Map

```{r SOME MAAP, results = "show", message = FALSE, echo = TRUE, fig.width = 9.5}
library(leaflet)
source(here::here("R", "spatial.R"))
regions_shape()

## join datalayers with simplified spatial data for mapping
plotshp <- rmapshaper::ms_simplify(input = BHI_rgns_shp) %>% 
  sf::st_as_sf() %>% 
  dplyr::select(rgn_nam, rgn_key, Subbasin, HELCOM_ID, region_id = BHI_ID, Area_km2) %>% 
  left_join(
    DATALAYERS,
    by = "region_id"
  )
  
pal <- leaflet::colorNumeric("RdYlBu", log10(seq(1, 5, 0.01)), "#fcfcfd", reverse = TRUE)

## create map
leaflet(data = plotshp) %>% 
  addProviderTiles(providers$CartoDB.Positron) %>%
  setView(18, 59, zoom = 5) %>% 
  addMapPane("popup", zIndex = 450) %>% 
  
  addPolygons(
    stroke = TRUE, opacity = 0.3, weight = 1, fillOpacity = 0.95,
    fillColor = ~palProd(DATALAYER),
    group = "GROUPNAME"s
  ) %>% 
  
  ## layers controls, popup layer, and formatting
  addLayersControl(
    baseGroups = c(
      BASEGROUPS
    ),
    options = layersControlOptions(collapsed = FALSE)
  ) %>% 
  addPolygons(
    popup = paste(
      "<h5><strong>", "Region:", "</strong>",
      plotshp$Name, "</h5>",
      "<h5><strong>", "BHI Region ID:", "</strong>",
      plotshp$region_id, "</h5>"
    ),
    fillOpacity = 0,
    stroke = FALSE,
    options = pathOptions(pane = "popup")
  )
```

<br>

## 5. Considerations for `BHI3.0`

<br>

## 6. References

```{r References, child = refs_path, results = "asis", echo = FALSE}
```
