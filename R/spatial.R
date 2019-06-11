## Libraries
source(file.path(here::here(), "R", "common.R"))
library(rgdal)
library(sp)
library(sf)
library(raster)
# library(fasterize)
# library(rgeos)
# library(maptools)
# library(ncdf4)
# library(colorRamps)
# library(parallel)
# library(RQGIS)
# library(tibble)

## Functions

#' create regions shape objects
#' 
#' @param sp_dir the file location of the shapefiles folders; the directory should contain afolder for each shapefile
#' @param foldernames the folders containing respective shapefiles
#'
#' @return defines spatial objects: bhi_rgns, helcom_subbasins, nuts2_rgns, ices_rgns, baltic_mpas in the global environment

regions_shape <- function(sp_dir = file.path(dir_B, "Spatial"),
                          foldernames = c("bhi_shapefile", # "helcom_subbasins_shapefile",
                                          "nuts2_shapefile", "ices_rgn_shapefile", 
                                          "mpas_shapefile")){
  
  for(i in foldernames){
    
    if(file.exists(file.path(sp_dir, i))){
      shp_path <- list.files(file.path(sp_dir, i), full.names = TRUE, 
                             pattern = "[A-Za-z0-9_]+.shp$") # assumes 1 shapefile per folder
      shp <- sf::st_read(dsn = file.path(sp_dir, i), 
                         layer = str_extract(basename(shp_path), pattern = "[A-Za-z0-9_]+"))
      
      name_obj <- paste0(str_extract(i, pattern = "[a-zA-Z0-9]+"), "_rgns_shp")
      cat("creating object in global environment:", name_obj)
      assign(name_obj, shp, envir = .GlobalEnv) # creates object in global environment!
      
    } else {
      warning(paste(i, "not found, check it exists in spatial directory", sp_dir))
    }
  }
}


#' add information about regions to dataset
#'
#' @param dataset the dataset to add spatial information to (i.e bhi, helcom, and ices regions); ideally with latitute/longitude
#' @param helcomID_col string naming the column in the dataset with HELCOM IDs
#' @param country_col string indicating name of column in the dataset containing country names
#' @param latlon_vars a two element character-vector with names of latitude and longitude columns, values of which can be numeric or character
#' @param rgn_shps_loc the location of the shapefiles with information BHI, HELCOM, and ICES regions
#'
#' @return

join_rgns_info <- function(dataset, helcomID_col = "helcom_id", country_col = "country",
                           latlon_vars = c("^lat", "^lon"), 
                           rgn_shps_loc = file.path(dir_B, "Spatial")){
  
  colnames(dataset) <- stringr::str_to_lower(names(dataset))
  
  lat <- grep(colnames(dataset), pattern = latlon_vars[1], value = TRUE)
  lon <- grep(colnames(dataset), pattern = latlon_vars[2], value = TRUE)
  message(sprintf("using latitude longitude colnames identified: '%s' and '%s' respectively", lat, lon))
  
  ## call regions_shape function also in this script, to define shapefiles needed in global env
  regions_shape(sp_dir = rgn_shps_loc, foldernames = c("bhi_shapefile", "ices_rgn_shapefile"))
  
  
  if(length(lat) == 1 & length(lon) == 1 & !any(is.na(latlon_vars))){
    ## if there is lat lon information, use sf::st_join with shapefiles to assign regions
    data_sf <- st_as_sf(dataset, coords = c(lon, lat), crs = 4326, agr = "constant")
       
    if(exists("bhi_rgns_shp", envir = .GlobalEnv)){
      data_sf <- st_join(data_sf, bhi_rgns_shp) 
    } else { message("BHI regions w/ HELCOM ID shapefile not in global environment")}
    
    if(exists("ices_rgns_shp", envir = .GlobalEnv)){
      data_sf <- st_join(data_sf, ices_rgns_shp)
    } else { message("ICES regions shapefile not in global environment")}
    
    data_rgns_joined <- data_sf %>% 
      as_tibble() %>% 
      select(-geometry, -Area_km2)
    
  } else {
    ## if no lat lon, need to use country or subbasin or other information... 
    bhi_rgns_df <- bhi_rgns_shp %>% 
      as_tibble() %>% 
      select(rgn_nam, rgn_key, HELCOM_ID, BHI_ID)
    colnames(bhi_rgns_df) <- stringr::str_to_lower(colnames(bhi_rgns_df))

    ## join by helcom_id then use combination of helcom_id and country name/key to determine bhi_id
    data_rgns_joined <- dplyr::left_join(
      dataset, bhi_rgns_df,
      by = c(helcomID_col = "helcom_id", country_col = "rgn_nam"))
  }

  return(data_rgns_joined)
}


# calc_means_monthly <- function(){}
# subset_to_bhi_rgns <- function(){}
# make_layer_map <- function(){}
