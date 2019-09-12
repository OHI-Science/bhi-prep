## Libraries
library(here)
library(readr)
library(dplyr)
library(stringr)
library(knitr)

## Directories
dir_prep <- here::here() # CHANGE BHI PREP DIRECTORY HERE!
dir_spatial <- file.path(dir_prep, "spatial") # spatial folder of bhi repo
dir_bhi <- stringr::str_replace(dir_prep, pattern = "bhi-prep$", "bhi")
dir_B <- file.path(c("Darwin" = "/Volumes/BHI_share", # "Windows" = ?
                     "Linux" = "/home/shares/ohi")[[ Sys.info()[["sysname"]] ]], "BHI 2.0") # CHANGE MAIN AUX BHI DIRECTORY HERE!
if(Sys.info()[["sysname"]] != "Linux" & !file.exists(dir_B)){ 
  ## warning if BHI internal, shared directory doesn't exist
  paste("The BHI directory dir_share set in R/common.R does not exist.",
        sprintf("Do you need to mount the BHI server: %s?", dir_B))
}

bhi_postgres_db <- "make connection to postgres+postgis database; for saving spatial data and other raw/intermediate data..."


## General ----
assess_year <- 2019 # CHANGE BHI ASSESSMENT YEAR HERE!
version_year <- paste0("v", assess_year)
rgn_ids_vec <- 1:42
subbasin_ids_vec <- 501:517