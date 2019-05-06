## Libraries
source(file.path(here::here(), "R", "common.R"))
library(httr)
library(jsonlite)
library(xml2)
library(dbplyr)
library(DBI)
library(odbc)
library(config)
library(RMySQL)
library(rvest)
library(splashr)
library(RSelenium)

## Functions

#' get data from one of our primary sources
#' 
#' for more information the SMHI API see [here](http://opendata.smhi.se/apidocs/ocobs/index.html)
#' for more about ICES data portal web services see [here](http://ecosystemdata.ices.dk/WebServices/index.aspx)
#' for more information on the Copernicus open access hub see [here](https://scihub.copernicus.eu/twiki/do/view/SciHubUserGuide/)
#' 
#' @param data_source name of the source
#' @param date_range list or vector with two values given in YYYYMMDD format
#' @param latlon_ranges four-element vector or list: min lat, max lat, min lon, max lon.
#' @param param_code 
#' @param search_terms
#' @param 
#'
#' @return result of the data query; parsed and filtered/subsetted response

get_input_data <- function(data_source, date_range, latlon_ranges, param_code = NA, search_terms = NA, ...){
  
  date_begin <- lubridate::ymd(date_range[1])
  date_end <- lubridate::ymd(date_range[2])
  result <- data.frame()
  
  if(str_to_lower(data_source) %in% c("nest", "baltic nest")){
    
    ## baltic nest data portal
    dateseq <- seq(date_begin, date_end, by = "6 months")
    dates_tab <- data.frame(start = dateseq, end = c(dateseq[-1], date_end)) %>% 
      filter(start != end)
    
    for(i in 1:nrow(dates_tab)){
      full_url <- sprintf(
        "%s?latBegin=%s&latEnd=%s&lonBegin=%s&lonEnd=%s&dateBegin=%s&dateEnd=%s",
        "http://nest.su.se/dataPortal/getStations",
        latlon_ranges[1], latlon_ranges[2], latlon_ranges[3], latlon_ranges[4],
        dates_tab[i,1], dates_tab[i,2]
      )
      tmp <- readr::read_csv(full_url)
      if(nrow(tmp) == 0){
        message(sprintf("no rows of data found for %s to %s...", 
                        dates_tab[i,1], dates_tab[i,2]))
      }
      result <- rbind(result, tmp)
    }
    
  } else if(str_to_lower(data_source) == "smhi"){
    
    ## smhi open data oceanographical observations
    
    
    
  }
  
  
  if(str_to_lower(data_source) == "ices"){}
  if(str_to_lower(data_source) %in% c("copernicus", "sentinel")){}
  if(str_to_lower(data_source) == "das"){}
  if(str_to_lower(data_source) == "holas"){}
  if(str_to_lower(data_source) == "hallbar rent"){}  
  
  ## save results to bhi database
  
  return(result)
}


# write_to_db <- function(datatable, name_in_db, harmonize_vars, connection){}



#' call goal data from database
#' 
#' this calls the data from the database and saves as a cvs in a specified location
#' this function should be used before preparing a data layer, if the raw data were updated
#'
#' @param goal_code
#' @param assess_year
#' @param datasets 
#' @param save_loc
#' 
#' @return

extract_data <- function(goal_code, assess_year, datasets, save_loc = NA){
  
  if(is.na(save_loc)){
    dir_goal <- file.path(dir_prep, "prep", "", assess_year) 
  } else { dir_goal <- save_loc }
  
  ## access database
  ## make sure data are in database, and put them there if not
  ## import datasets
  
  for(d in datasets){
    readr::read_csv(file.path(dir_goal, "raw", "name dataset..."))
  }
  
}
