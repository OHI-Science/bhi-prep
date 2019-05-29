## Libraries
source(file.path(here::here(), "R", "common.R"))
library(httr)
library(jsonlite)
library(xml2)
library(XML)
library(lubridate)
library(data.table)
# library(doParallel)
# library(foreach)
# library(RCurl)
# library(dbplyr)
# library(DBI)
# library(odbc)
# library(config)
# library(RMySQL)
# library(rvest)
# library(splashr)
# library(RSelenium)

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
#' @return result of the data query; parsed and filtered/subsetted response. Object will be a dataframe or raster depending on the data source.

get_input_data <- function(data_source, date_range, months = 1:12,
                           latlon_ranges = c(53.6016, 65.9071, 9.42077, 30.3471), 
                           param_codes = NA, search_terms = NA, 
                           api_key = NULL, delay = 0.5, cores = 1, ...){
  
  # data_source = "ICES"; date_range = c("1990-01-01", "2017-1-1");
  # latlon_ranges = c(53.6016, 65.9071, 9.42077, 30.3471);
  # param_codes = NA; search_terms = "biota, PCBS";
  # api_key = NULL; delay = 0.05; cores = NULL;
  # months = 1:12
  
  
  # ua <- user_agent("http://github.com/OHI-Science/bhi-prep")
  # api_file <- file.path(dir_B, "api_key.csv")
  result <- data.frame()
  i <- 1
  
  data_source <- str_to_lower(data_source)
  search_terms <- search_terms %>% 
    str_to_lower() %>% 
    str_remove_all(",") %>% 
    str_split(pattern = " ") %>% 
    unlist()

  date_begin <- lubridate::ymd(date_range[1])
  date_end <- lubridate::ymd(date_range[2])
  if(is.na(date_begin)|is.na(date_end)){
    stop("issue with dates, check date_range was given in YYYYMMDD format")
  }
  yrs <- seq(year(date_begin), year(date_end))
  months <-  str_pad(months, width = 2, side = "left", pad = "0")
  
  
  ## BY DATA SOURCE ----
  
  if(data_source %in% c("nest", "baltic nest")){
    ## baltic nest data portal ----
    
    dates_seq <- seq(date_begin, date_end, by = "months") %>% 
      grep(pattern = paste0("-", months, "-", collapse = "|"), value = TRUE)
    dates_lst <- list()
    j <- 1
    for(i in 2:length(dates_seq)){
      if(!(lubridate::month(dates_seq[i-1])==lubridate::month(dates_seq[i])-1|
         (lubridate::month(dates_seq[i-1])==12&lubridate::month(dates_seq[i])==1))){
        dates_lst <- c(dates_lst, list(dates_seq[c(j, (i-1))])); j <- i
      }; i <- i + 1
    }

    for(j in 1:length(dates_lst)){
      full_url <- sprintf(
        "%s?latBegin=%s&latEnd=%s&lonBegin=%s&lonEnd=%s&dateBegin=%s&dateEnd=%s",
        "http://nest.su.se/dataPortal/getStations",
        latlon_ranges[1], latlon_ranges[2], latlon_ranges[3], latlon_ranges[4],
        dates_lst[[j]][1], dates_lst[[j]][2]
      )
      tmp <- readr::read_csv(full_url)
      if(nrow(tmp) == 0){
        message(sprintf("no rows of data found for %s to %s...", 
                        dates_lst[[j]][1], dates_lst[[j]][2]))
      }
      result <- rbind(result, tmp)
    }
    closeAllConnections()
    
  } else if(data_source == "smhi"){
    ## smhi open data oceanographical observations ----

    
  } else if(data_source == "ices"){
    ## ices data center ----
    
    ## two different web services offered
    ## http://ecosystemdata.ices.dk/webservices/index.aspx
    ## http://dome.ices.dk/Webservices/index.aspx
    ices_ecosystem_ws <- "http://ecosystemdata.ices.dk/WebServices/EcoSystemWebServices.asmx"
    ices_dome_ws <- "http://dome.ices.dk/Webservices/DOMEWebServices.asmx"
    
    ## some lookup tables for variable options
    ## other options: /getListParameters and /getListSpecies
    datasets_df <- xmlParse(paste0(ices_ecosystem_ws, "/getListDatasets")) %>% 
      xmlToList() %>% lapply(FUN = as.data.frame) %>% rbindlist()
    grps_df <- xmlParse(paste0(ices_ecosystem_ws, "/getListParamGroup")) %>% 
      xmlToList() %>% lapply(FUN = as.data.frame) %>% rbindlist()
    
    if(length(intersect(c("chlorobiphenyls","pcbs","dioxins","organofluorines","pfos"), search_terms)) != 0){
      
      ## use ices 'dome' webservice
      ## for contaminants chlorobiphenyls, dioxins, organofluorines
      ## https://vocab.ices.dk codes: OC-CB Chlorobiphenyls, OC-DX Dioxins, O-FL Organofluorines
      
      if("biota" %in% search_terms){
        method <- "/selectContaminantsInBiota?"
      }
      if("sediment" %in% search_terms|"sediments" %in% search_terms){
        method <- "/selectContaminantsInSediment?"
      } else { stop("searching for contaminants in Biota or Sediments?") }
      url_base <- paste0(
        ices_dome_ws, method,
        "%s&ParamGroup=&CNTRY=%s&Area=&PARAM=&RLABO=&ALABO=&MATRX=&TAXA=&PURPM=&MPROG=")
      
      ## Parameter Group
      tmp <- tibble(
        code = c("OC-CB", "OC-DX", "O-FL"),
        key = c("OC%%2DCB", "OC%%2DDX", "O%%2DFL"), # double % because used with sprintf
        grp = c("chlorobiphenyls", "dioxins", "organofluorines"),
        abbrev = c("pcbs", "dioxins", "pfos"))
      url_base <- str_replace(
        url_base, pattern = "ParamGroup=", 
        replacement = paste0("ParamGroup=", tmp[tmp$grp %in% search_terms|tmp$abbrev %in% search_terms,"key"]))
      
      ## Years-- need start and end years as inputs
      yrs <- mapply(yrs[-length(yrs)], yrs[2:length(yrs)], FUN = function(x, y){sprintf("yearBegining=%s&yearEnd=%s", x, y)})
    
      ## Output vars
      ## table of all dome web service outputs, from dome.ices.dk/Webservices/index.aspx
      vars <- select(read_csv(file.path(dir_prep, "ref", "lookup_tabs", "dome_ices_vars.csv"), col_types = cols()), var)
      
      ## Function to transform list from xml
      to_df <- function(x){
        entry <- unlist(x) %>% 
          data.frame(row.names = str_remove(names(.), "DOMErecord.")) %>% 
          tibble::rownames_to_column() %>% 
          merge(vars, by.x = "rowname", by.y = "var", all = TRUE) %>% # will throw error if merging fails...
          t() %>% 
          data.frame(row.names = NULL)
        entry <- entry[2,]
        return(entry)
      }
      to_df_comp <- compiler::cmpfun(to_df)
      
    } else {
      
      ## for other data, use ices 'ecosystem' webservice
      
      url_base <- paste0(
        ices_ecosystem_ws,
        "/getICESDataPortalData?",
        sprintf("minLatitude=%s&maxLatitude=%s&minLongitude=%s&maxLongitude=%s",
                latlon_ranges[1], latlon_ranges[2], latlon_ranges[3], latlon_ranges[4]),
        "&area=helcom&dataset=&datatype=&parametergroup=&parameter=&taxa=&matrix=")
      
      ws_datasets <- c(
        "oceanographic",
        "contaminants and biological effects", 
        "eggs and larvae", 
        "historical datasets",
        "vulnerable marine ecosystems", 
        "fish trawl survey", 
        "biological community", 
        "fish predation (stomach contents)")
      if(any(search_terms %in% ws_datasets)){
        key <- datasets_df[str_to_lower(datasets_df$DatasetName) == intersect(search_terms, ws_datasets), "key"] %>% 
          as.character()
        url_base <- str_replace(url_base, pattern = "dataset=", replacement = paste0("dataset=", key))
      }
      if(any(str_detect(grps_df$paramGroupName, search_terms))){
        key <- grps_df[str_detect(grps_df$paramGroupName, search_terms), "key"] %>% 
          as.character()
        if(length(key) == 1){
          url_base <- str_replace(url_base, pattern = "parametergroup=", replacement = paste0("parametergroup=", key))
        } else {stop("be more specific with search terms, to locate specific ICES parameter group...")}
      }
      
      vars <- data.frame(var = c(
        "Year","Month","day","Datetime","DayNight",
        "Cruise","Station","Longitude","Latitude","Depth", 
        "DataSet","Datatype","Parameter", 
        "Value","Precision","Unit","Original Value","Original Unit", 
        "Species","Matrix","Depth Class","Age Class","Length Class","sex",
        "DEPHL","DEPHU","QFLAG","BASIS","NOINP",
        "SampleID","MeasurementID","ICES Position Note","ICES DateTime Note")
      )
      
      # to_df <- function(x){
      #   entry <- unlist(x) %>% 
      #     data.frame(row.names = str_remove(names(.), "DOMErecord.")) %>% 
      #     tibble::rownames_to_column() %>% 
      #     merge(vars, by.x = "rowname", by.y = "var", all = TRUE) %>% # will throw error if merging fails...
      #     t() %>% 
      #     data.frame(row.names = NULL)
      #   entry <- entry[2,]
      #   return(entry)
      # }
      # to_df_comp <- compiler::cmpfun(to_df)
    }
    
    data_lst <- list()
    if(str_detect(url_base, pattern = "CNTRY")){
      countrycodes <- c("06","07","RU","67","LT","LA","ES","34","77","26")
      urls <- mapply(expand.grid(yrs, countrycodes)[1], 
                     expand.grid(yrs, countrycodes)[2],
                     FUN = function(x, y){sprintf(url_base, x, y)})
    } else {urls <- lapply(yrs, FUN = function(x){sprintf(url_base, x)}) %>% unlist()}
    
    # result = data.frame()
    # data_lst = list()
    # i = 1
    # t0 = Sys.time()
    
    for(u in urls){
      closeAllConnections()
      Sys.sleep(delay*i)
      i <- i + 1
      
      xmldoc <- xmlParse(u)
      rootNode <- xmlRoot(xmldoc)
      data0 <- xmlSApply(rootNode, function(x){xmlSApply(x, xmlValue)})

      if(class(data0) == "list"){
        data_lst <- lapply(data0, FUN = to_df_comp) %>% c(data_lst)
      } else { data_lst <- apply(data0, MARGIN = 2, FUN = to_df_comp) %>% c(data_lst) }
    }

    # cl <- makeCluster(min(cores, 2))
    # registerDoParallel(cl)
    # data_lst <- foreach(i = urls, .packages= c("XML", "magrittr", "stringr"), .combine = c) %dopar% {
    #   Sys.sleep(delay)
    #   
    #   xmldoc <- xmlParse(i)
    #   rootNode <- xmlRoot(xmldoc)
    #   data0 <- xmlSApply(rootNode, function(x){xmlSApply(x, xmlValue)})
    #   
    #   if(class(data0) == "list"){
    #     data_lst <- lapply(data0, FUN = to_df_comp) %>% c(data_lst)
    #   } else { data_lst <- apply(data0, MARGIN = 2, FUN = to_df_comp) %>% c(data_lst) }
    # }
    # stopCluster(cl)
    
    closeAllConnections()
    result <- rbindlist(data_lst)
    result <- setNames(result, sort(vars$var))
    
    # Sys.time() - t0
    
  }
  if(str_to_lower(data_source) %in% c("copernicus", "sentinel")){
    
    # OData Service Root URI for the Open Access Hub
    root_uri <- "https://scihub.copernicus.eu/dhus/odata/v1"  
    
    
    
    
  }
  if(str_to_lower(data_source) == "das"){}
  if(str_to_lower(data_source) == "holas"){}
  if(str_to_lower(data_source) == "hallbar rent"){}  

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

#' compare raw data inputs
#' 
#' checks raw data inputs -from same source/table but obtained different years- against each other
#' the aim is to ensure consistency between sequential assessments, where expected
#'
#' @param dataset1 
#' @param dataset2 
#'
#' @return

compare_yrs_data <- function(dataset1, dataset2, ){
  # if paths read_csv, otherwise expect dataframes
  # create some kind of merged table by key variables
  # missing vs extra entries?
  
  # can base this on bhi/R/common.R 'compare_tabs' function...
}
