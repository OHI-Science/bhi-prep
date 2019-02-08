## For common libraries, directories, functions


## Libraries
library(tidyverse)
library(here)
library(tools)
library(purrr)
library(broom)

library(ggmap) # install.packages("ggmap")
library(here) 

library(odbc) # devtools::install_github("rstats-db/odbc")
library(DBI) # install.packages("DBI")
library(RMySQL)


## Directories
dir_baltic <- here::here()
dir_layers <- file.path(dir_baltic, "layers")
dir_R <- file.path(dir_baltic, "R")
dir_spatial <- file.path(dir_baltic, "prep/spatial")

## Functions


#' provide a link to the data prep github_document in readme
#'
#' @param dir 
#' @param file 
#'
#' @return
create_readme = function(dir, file) {
  
  # don't overwrite existing README.md
  if(!file.exists(file.path(dir, "README.md"))) {
    
    ## create git url
    repo <- "bhi-prep"
    w <- stringr::str_split(file.path(dir, file), repo)[[1]][2]
    rawurl <- sprintf("https://github.com/OHI-Science/%s/blob/draft%s.md", 
                  repo, tools::file_path_sans_ext(w))
    
    ## rewrite from readme_template.md
    readLines(file.path(here::here(), "readme_template.md")) %>%
      stringr::str_replace("here", sprintf("[here](%s)", rawurl)) %>%
      writeLines(file.path(dir, "README.md"))
  }
}

#' update readmes for all prep folders
#'
#' @param prep_dir 
#' @param version_year 
update_readmes = function(prep_dir, version_year){
  
  ## directories where readmes need to be updated
  ## make sure to exclude dirs where readmes shouldn't be overwritten
  update_where <- list.dirs(prep_dir) %>% 
    # grep(pattern = ".*/[A-Z]{2,3}$", value = TRUE) %>% 
    grep(pattern = "prep/pressures$", invert = TRUE, value = TRUE) %>% 
    grep(pattern = "prep/spatial$", invert = TRUE, value = TRUE) %>%
    grep(pattern = "CW$", invert = TRUE, value = TRUE)
  
  for(dir in update_where){
    if(file.exists(file.path(dir, "README.md"))){
      
      ## create git url
      file <- list.files(file.path(dir, version_year), pattern = "_prep.rmd")
      w <- file.path(basename(dir), version_year, file)
      rawurl <- sprintf("https://github.com/OHI-Science/bhi-prep/blob/draft/prep/%s", w)
      
      ## rewrite from readme_template.md
      readLines(file.path(here::here(), "readme_template.md")) %>%
        stringr::str_replace("here", sprintf("[here](%s)", rawurl)) %>%
        writeLines(file.path(dir, "README.md"))
    }
  }
}

rgns_lookup <- function(){
  eez_lookup <- c("SWE"=1, "DNK"=2, "DEU"=3, "POL"=4, "RUS"=5,"LTU"=6, "LVA"=7, "EST"=8, "FIN"=9)
  
  rgns <- left_join()
  
}

## create_rgns_complete.r
## by @jules32 Sept 14 2016
## called from `functions.r - FinalizeScores()`; will save 'spatial/regions_lookup_complete.csv'


## Identify regions to aggregate as eezs and basins ----

## lookup table for EEZ ids (named vector)
eez_lookup <- c("SWE"=1, "DNK"=2, "DEU"=3, "POL"=4, "RUS"=5,"LTU"=6, "LVA"=7, "EST"=8, "FIN"=9)

## join region labels with labels for EEZs and HELCOM Subbasins
rgns <- left_join(
  
  ## begin with region labels, as per usual...
  SelectLayersData(layers, layers=conf$config$layer_region_labels, narrow=T) %>%
    dplyr::select(region_id   = id_num,
                  region_name = val_chr),
  
  ## ...joined to the lookup table with basin and eez information
  read.csv('prep/bhi_basin_country_lookup.csv', sep = ';') %>% ## don't use readr::read_csv2 because decimals will be dropped
    dplyr::rename(region_id     = BHI_ID,
                  eez_name      = rgn_nam,
                  subbasin_name = Subbasin,
                  area_km2_rgn  = Area_km2) %>%
    
    ## for HELCOM sub-basin areas:: create numeric id and calculate area
    mutate(subbasin_id = as.integer(stringr::str_replace_all(HELCOM_ID, "SEA-0", "5"))) %>%
    
    ## for EEZ areas:: create numeric id and calculate area
    mutate(eez_id = as.integer(stringr::str_c("30", eez_lookup[match(rgn_key, names(eez_lookup))]))),
  
  ## ...joined by region_id and select
  by = 'region_id') %>%
  select(region_id, region_name, area_km2_rgn, eez_id, eez_name, subbasin_id, subbasin_name)

## save csv lookup
write.csv(rgns, 'spatial/regions_lookup_complete_wide.csv', row.names=FALSE)



## Create csv lookup of all regions, with headers to match layers/rgn_labels.csv ----
rgns_complete <- bind_rows(
  data_frame(region_id = 0, label = 'Baltic', type = 'GLOBAL'),          ## combine 0...
  rgns %>%                                           ## ...with BHI ids...
    mutate(label = as.character(region_name),
           type = 'bhi') %>%
    select(region_id = region_id, label, type),
  rgns %>%                                           ## ...with EEZ ids...
    distinct(eez_id, eez_name) %>%
    mutate(type = 'eez') %>%
    select(region_id = eez_id, label = eez_name, type),
  rgns %>%                                           ## ...with SUBBASIN ids
    distinct(subbasin_id, subbasin_name) %>%
    mutate(type = 'subbasin') %>%
    select(region_id = subbasin_id, label = subbasin_name, type))

## save csv lookup
write.csv(rgns_complete, 'spatial/regions_lookup_complete.csv', row.names=FALSE)
