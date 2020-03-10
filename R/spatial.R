## Libraries
source(here::here("R", "setup.R"))
library(sf)

## Functions

#' create regions shape objects
#' 
#' @param sp_dir the file location of the shapefiles folders; the directory should contain a folder for each shapefile
#' @param foldernames folders containing respective shapefiles, besides the standard BHI, ICES, HELCOM subbasins, etc
#'
#' @return defines spatial objects: bhi_rgns, helcom_subbasins, nuts2_rgns, ices_rgns, baltic_mpas in the global environment

regions_shape <- function(sp_dir = file.path(dirname(dir_B), "Shapefiles"), foldernames = NULL){
  
  foldernames <- c(
    foldernames,
    # "bhi_shapefile", 
    # "helcom_subbasins_shapefile",
    # "nuts2_shapefile",
    # "ices_rgn_shapefile",
    # "mpas_shapefile", 
    # "BHI_shapefile_25km_buffer",
    #"HELCOM_subbasins_holasbasins",
    "BHI_shapefile", 
    "ICES_areas"
  )
  
  for(i in foldernames){
    
    if(file.exists(file.path(sp_dir, i))){
      shp_path <- list.files(file.path(sp_dir, i), full.names = TRUE, 
                             pattern = "[A-Za-z0-9_]+.shp$") # assumes 1 shapefile per folder
      shp <- sf::st_read(
        dsn = file.path(sp_dir, i), 
        layer = str_extract(basename(shp_path), pattern = "[A-Za-z0-9_]+"),
        quiet = TRUE
      )
      
      name_obj <- paste0(str_extract(i, pattern = "[a-zA-Z0-9]+"), "_rgns_shp")
      message("creating object in global environment: ", name_obj, "\n")
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
                           latlon_vars = c("^lat", "^lon"), return_spatial = FALSE, 
                           rgn_shps_loc = file.path(dir_B, "Spatial"), buffer_shp = NULL){
  
  
  colnames(dataset) <- stringr::str_to_lower(names(dataset))
  
  lat <- grep(colnames(dataset), pattern = latlon_vars[1], value = TRUE)
  lon <- grep(colnames(dataset), pattern = latlon_vars[2], value = TRUE)
  message(sprintf("using latitude longitude colnames identified: '%s' and '%s' respectively", lat, lon))
  
  ## call regions_shape function also in this script, to define shapefiles needed in global env
  if(!exists("BHI_rgns_shp", .GlobalEnv)|!exists("ICES_rgns_shp", .GlobalEnv)){
    message("loading BHI regions w/ HELCOM ID, and ICES shapefiles to global environment")
    regions_shape(sp_dir = rgn_shps_loc)
  }
  if(is.na(st_crs(ICES_rgns_shp)$epsg) || st_crs(ICES_rgns_shp)$epsg != 4326){
    ICES_rgns_shp <- st_transform(ICES_rgns_shp, 4326)
  }
  
  ## latitude/longitude approach ----
  ## if there is lat lon information, use sf::st_join with shapefiles to assign regions
  if(length(lat) == 1 & length(lon) == 1 & !any(is.na(latlon_vars))){
    data_sf0 <- st_as_sf(dataset, coords = c(lon, lat), crs = 4326, agr = "constant")
    
    ## points in the BHI regions 10km buffer zone ----
    if(!is.null(buffer_shp)){
      data_buff_sf <- data_sf0 %>% 
        st_join(select(buffer_shp, BHI_ID)) %>% 
        filter(!is.na(BHI_ID)) %>%
        left_join(st_drop_geometry(BHI_rgns_shp), by = "BHI_ID") %>% 
        mutate(ICES_area = NA, Area_km2_ICES = NA, in_25km_buffer = TRUE) %>% 
        rename(Area_km2_BHI = Area_km2)
    }
    
    ## check if any points are not matched with a BHI id ----
    if(!is.null(buffer_shp)){
      test <- data_sf0 %>% 
        st_join(select(buffer_shp, bhi_id_buff = BHI_ID))
    } else {
      test <- data_sf0 %>% 
        mutate(bhi_id_buff = NA)
    }
    test <- test %>% 
      select(zn = one_of("country", "helcom_id"), yr = starts_with("year"), bhi_id_buff) %>% 
      st_join(select(BHI_rgns_shp, bhi_id_water = BHI_ID)) %>% 
      filter(is.na(bhi_id_buff) & is.na(bhi_id_water))
    
    if(nrow(test) != 0){
      test_result <- sprintf(
        "%s of %s data points (in: %s, years: %s) have not been",
        nrow(test),
        nrow(dataset),
        paste(
          c(head(unique(test$zn)) %>% as.character(), 
            ifelse(length(unique(test$zn)) > 6, "...", "")), 
          collapse = ", "
        ),
        paste(
          c(head(unique(test$yr)), 
            ifelse(length(unique(test$yr)) > 6, "...", "")), 
          collapse = ", "
        )
      )
    } else {test_result <- "all data points are"}
    message(paste(test_result, "assigned corresponding BHI IDs"))
    
    ## return spatial object sf or just dataframe
    data_rgns_joined <- data_sf0 %>% 
      st_join(rename(BHI_rgns_shp, Area_km2_BHI = Area_km2)) %>% 
      st_join(rename(ICES_rgns_shp, Area_km2_ICES = Area_km2)) %>% 
      filter(!is.na(BHI_ID)) %>% 
      mutate(in_25km_buffer = FALSE) %>% 
      rbind(data_buff_sf)
    
    if(!return_spatial){
      data_rgns_joined <- data_rgns_joined %>% 
        as_tibble() %>% 
        select(-geometry, -Area_km2_BHI, -Area_km2_ICES) 
    }
  
  ## country/subbasin approach ----
  ## if no lat lon, need to use country or subbasin or other information... 
  } else {
    bhi_rgns_df <- BHI_rgns_shp %>% 
      as_tibble() %>% 
      select(rgn_nam, rgn_key, HELCOM_ID, BHI_ID)
    colnames(bhi_rgns_df) <- stringr::str_to_lower(colnames(bhi_rgns_df))
    
    ## join by helcom_id then use combination of helcom_id and country name/key to determine bhi_id
    data_rgns_joined <- dplyr::left_join(
      dataset, bhi_rgns_df,
      by = c(helcomID_col = "helcom_id", country_col = "rgn_nam"))
  }
  
  ## return result
  return(data_rgns_joined)
}
