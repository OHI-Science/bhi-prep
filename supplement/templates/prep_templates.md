
<!-- GOAL_DATA.RMD -->

```{r GOAL data preamble, echo = FALSE, include = FALSE, error = FALSE}
knitr::opts_chunk$set(message = FALSE, warning = FALSE, echo = TRUE, results = "asis", fig.width = 9.5, fig.height = 6)
source(here::here("R", "setup.R"))
source(here::here("R", "spatial.R"))
```

### 2.1 Datasets with Sources
<br/>

#### 2.1.1 DATA NAME/VARIABLE {-}

**DATASET SUBSET/SUBGROUP NAME/VARIABLE**  
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

```{r SUBGOAL load raw data, echo = TRUE, message = FALSE, warning = FALSE, results = "hide"}
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

```{r GOAL basemap to be used in spatial plotting, echo = TRUE}
basemap <- ggplot2::ggplot(rnaturalearth::ne_countries(scale = "medium", returnclass = "sf")) +
  geom_sf(size = 0.1, color = "burlywood", alpha = 0.4) +
  theme(panel.background = element_rect(fill = "#F8FBFC", color = "#E2EEF3")) +
  scale_x_continuous(limit = c(4, 32)) +
  scale_y_continuous(limit = c(53.5, 66)) 

## make larger discrete color palette
pal <- colorRampPalette(RColorBrewer::brewer.pal(8, "Set2"))(18)
```


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

```{r SUBGOAL preamble prep, message = FALSE}
knitr::opts_chunk$set(message = FALSE, warning = FALSE, echo = TRUE, results = "hide", fig.width = 9.5, fig.height = 6)
source(here::here("R", "setup.R"))

loc <- here::here("prep", "GOAL", "SUBGOAL")
bkgd_path <- here::here("supplement", "goal_summaries", "GOALCODE.Rmd")
data_path <- here::here("data", "GOAL", ["SUBGOAL"], version_year, "GOALCODE_data.rmd")
refs_path <- file.path(loc, "GOALCODE_references.Rmd")
# file.exists(c(bkgd_path, data_path, refs_path))
```

## 1. Background

```{r SUBGOAL background, child = bkgd_path, results = "asis", echo = FALSE}
```

<br/>

## 2. Data

This prep document is used to generate and explore the following data layers:

- `LAYER1_bhi2019.csv` 
- `LAYER2_bhi2019.csv` 
- `LAYER3_bhi2019.csv` 

These are saved to the `layers` folder. Saved to `data/GOAL/v2019/intermediate` are intermediate datasets: `DATASETINTEMED1.csv` and `DATASETINTEMED2.csv`. All these are derived from or informed by the raw datasets from RAW DATA SOURCES.

<br>

```{r SUBGOAL prep load data, child = data_path, results = "asis", echo = FALSE}
```

<br/>

## 3. Prep: Wrangling & Derivations, Checks/Evaluation, Gapfilling

<br/>

## 4. Visualizing Data Layers

### 4.1 Map

```{r SOME MAP, results = "show", message = FALSE, echo = TRUE, fig.width = 9.5}

```

<br>

## 5. Considerations for `BHI3.0`

<br>

## 6. References

```{r SUBGOAL references, child = refs_path, results = "asis", echo = FALSE}
```
