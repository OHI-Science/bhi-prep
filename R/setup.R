## Libraries
library(here)
library(readr)
library(dplyr)
library(tidyr)
library(stringr)
library(knitr)
library(ggplot2)
library(zoo)

## Directories
## CHANGE BHI PREP DIRECTORY HERE!
dir_prep <- here::here()
dir_layers <- file.path(dir_prep, "layers")
dir_spatial <- file.path(dir_prep, "spatial") # spatial folder of bhi repo
dir_assess <- stringr::str_replace(dir_prep, pattern = "bhi-prep$", "bhi")

# CHANGE MAIN AUX BHI DIRECTORY HERE!
dir_B <- "/mnt/data/ellie/bhi_share/BHI 2.0"
if(!file.exists(dir_B)){ 
  ## warning if BHI internal, shared directory doesn't exist
  sprintf(
    "The BHI directory dir_share set in R/common.R does not exist.\n
    Do you need to mount the BHI server: %s?", 
    dir_B
  )
}

bhi_postgres_db <- "make connection to postgres+postgis database; for saving spatial data and other raw/intermediate data..."


## General ----
assess_year <- 2019 # CHANGE BHI ASSESSMENT YEAR HERE!
version_year <- paste0("v", assess_year)
bhi_version <- "v2019"
rgn_ids_vec <- 1:42
subbasin_ids_vec <- 501:517
