source(sprintf("%s/R/common.R", here::here()))

#' call ao data from database
#' 
#' This file calls the data from the database and saves as a cvs in secchi_data_database
#' This file should be run prior to secchi_prep.Rmd if data are updated in the database
#'
#' @param assess_year 
extract_ao_data <- function(assess_year, ){
  
  dir_ao <- file.path(dir_baltic, "prep/AO", assess_year)
  
  ## access database with MySQL
  
  ## make sure data are in database, and put them there if not...
  
  ## get ao_coastalfish_ges_status, coastalfish_loc, and ao_cpue_slope
  
  
  
  ## write the data to the AO prep 'raw' folder
  readr::write_csv(file.path(dir_ao, "raw", "ao_coastalfish_ges_status.csv"))
  readr::write_csv(file.path(dir_ao, "raw", "coastalfish_loc.csv"))
  readr::write_csv(file.path(dir_ao, "raw", "and ao_cpue_slope.csv"))
  
}