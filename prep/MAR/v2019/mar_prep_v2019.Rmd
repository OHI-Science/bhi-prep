
<!-- GOAL_DATA.RMD -->

## 2. Data

```{r Preamble, echo = FALSE, include = FALSE, error = FALSE}
source(file.path(here::here(), "R", "data.R"))
```

### 2.1 Datasets with Sources
<br/>

**DATASET NAME/VARIABLE**  
<!-- dataset save location BHI_share/2.0/Goals/ -->

```{r echo = FALSE, results = "asis"}
tab <- t(data.frame(
  c(":", ""), 
  c(":", "")))

colnames(tab) <- c("Option", "Specification")
rownames(tab) <- NULL

knitr::kable(tab, caption = "Source: [ABC database](URL/LINK) <br/> Downloaded DATE by NAME")
```
<br/>


### 2.2 Centralization & Normalization

#### 2.2.1 Rename Fields/Variables

#### 2.2.2 Standardize Units

#### 2.2.3 Save to BHI Database

<br/>

### 2.3 Initial Data Exploration

#### 2.3.1 Compare versus Previous Years Data

#### 2.3.2 Timeseries Plots

#### 2.3.3 Map


<!-- GOAL_PREP.RMD -->


---
title: "SUBGOAL - GOAL Subgoal data prep"
output:
  github_document:
    toc: true
    toc_depth: 3
params: 
    datasource: csv
---

```{r Preamble}
loc <- file.path(here::here(), "prep", "GOAL", "SUBGOAL")

source(file.path(here::here(), "R", "setup.R"))
knitr::opts_chunk$set(message = FALSE, warning = FALSE, results = "hide")

bkgd_path <- file.path(here::here(), "supplement", "goal_summaries", "GOALCODE.Rmd")
data_path <- file.path(here::here(), "data", "GOAL", ["SUBGOAL"], version_year, "GOALCODE_data.rmd")
refs_path <- file.path(loc, "GOALCODE_references.Rmd")
```

## 1. Background

```{r Background, child = bkgd_path, results = "asis", echo = FALSE}
```

<br/>

## 2. Data

```{r Data, child = data_path, results = "asis", echo = FALSE}
```

<br/>

## 3. Prep: Wrangling & Derivations, Checks/Evaluation, Gapfilling

<br/>

## 4. Visualizing Data Layers

<br/>

## 5. References

```{r References, child = refs_path, results = "asis", echo = FALSE}
```
