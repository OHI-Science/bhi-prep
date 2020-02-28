## Libraries
source(here::here("R", "setup.R"))
library(httr)
library(jsonlite)
library(xml2)
library(XML)
library(lubridate)
library(data.table)
library(doParallel)
library(foreach)
# library(eurostat)
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

#' get data from Baltic Nest data portal
#' 
#' @param date_range list or vector with two values given in YYYYMMDD format
#' @param months values 1 through 12 corresponding to months to obtain data for
#' @param param_codes baltic nest code options: TEMP,QTEMP,SALIN,QSALIN,TOTOXY,QTOTOXY,PO4P,QPO4P,TOTP,
#' QTOTP,SIO4,QSIO4,NO3N,QNO3N,NO2N,QNO2N,NO23N,QNO23N,NH4N,QNH4N,TOTN,QTOTN,CHL,QCHL
#' 
#' @return
#' 
get_nest_data <- function(date_range = c(20050101, 20191231), months = 1:12, 
                          param_codes = c("PO4P", "TOTP", "SIO4", "NO3N", "NO2N", "NO23N", "NH4N", "TOTN", "CHL")){
  
  
  ## check dates input
  date_begin <- lubridate::ymd(date_range[1])
  date_end <- lubridate::ymd(date_range[2])
  if(is.na(date_begin)|is.na(date_end)){
    stop("issue with dates, check date_range was given in YYYYMMDD format")
  }
  
  ## construct dates sequence, to download data only associated w selected months ----
  ## note: only works if more than one yr, otherwise will have only one entry in dates_lst
  months <- stringr::str_pad(months, width = 2, side = "left", pad = "0")
  dates_seq <- seq(date_begin, date_end, by = "months") %>% 
    grep(pattern = paste0("-", months, "-", collapse = "|"), value = TRUE)
  
  dates_lst <- list()
  j <- 1
  for(i in 2:length(dates_seq)){
    ## trying to keep only months of interest, not data in between...
    midyrmonthapart <- lubridate::month(dates_seq[i-1])==lubridate::month(dates_seq[i])-1
    dectojan <- lubridate::month(dates_seq[i-1])==12 & lubridate::month(dates_seq[i])==1
    if(!(midyrmonthapart|dectojan)){
      dates_lst <- c(dates_lst, list(dates_seq[c(j, (i-1))]))
      j <- i
    }
  }
  if(length(dates_lst) == 0){
    dates_lst <- list(c(dates_seq[1], dates_seq[length(dates_seq)]))
  }
  
  ## spatial polygons/boxes to batch download ----
  latlon <- tibble::tibble(
    box1 = c(53.6021, 56.0021, 10.0000, 11.8208), 
    box2 = c(53.6021, 56.0021, 11.8208, 14.2208), 
    box3 = c(53.6021, 56.0021, 14.2208, 16.6208), 
    box4 = c(53.6021, 56.0021, 16.6208, 19.0208), 
    box5 = c(53.6021, 56.0021, 19.0208, 21.4208), 
    box6 = c(65.6021, 68.0021, 21.4208, 23.8208), 
    box7 = c(65.6021, 68.0021, 23.8208, 26.2208), 
    box8 = c(56.0021, 58.4021, 10.1008, 12.5008), 
    box9 = c(56.0021, 58.4021, 12.5008, 14.9008), 
    box10 = c(56.0021, 58.4021, 14.9008, 17.3008), 
    box11 = c(56.0021, 58.4021, 17.3008, 19.7008), 
    box12 = c(56.0021, 58.4021, 19.7008, 22.1008), 
    box13 = c(56.0021, 58.4021, 22.1008, 24.5008), 
    box14 = c(58.4021, 60.8021, 16.1208, 18.5208), 
    box15 = c(58.4021, 60.8021, 18.5208, 20.9208), 
    box16 = c(58.4021, 60.8021, 20.9208, 23.3208), 
    box17 = c(58.4021, 60.8021, 23.3208, 25.7208), 
    box18 = c(58.4021, 60.8021, 25.7208, 28.1208), 
    box19 = c(58.4021, 60.8021, 28.1208, 30.5208), 
    box20 = c(60.8021, 63.2021, 16.9708, 19.3708), 
    box21 = c(60.8021, 63.2021, 19.3708, 21.7708), 
    box22 = c(63.2021, 65.6021, 18.4708, 20.8708), 
    box23 = c(63.2021, 65.6021, 20.8708, 23.2708), 
    box24 = c(63.2021, 65.6021, 23.2708, 25.6708)
  )
 
  ## function to query nest.su.se/dataPortal for data ----
  try_query <- function(queryurl){
    
    ## with error handling...
    tab <- try(
      readr::read_csv(
        queryurl,
        progress = show_progress(), 
        
        col_types = cols(
          SERVER_ID = col_integer(), ID = col_integer(),
          LATITUDE = col_number(), LONGITUDE = col_number(),
          OBSDATE = col_date(format = ""),
          OBSTIME = col_time(format = ""),
          SHIP = col_character(),
          
          OBSDEP = col_number(),
          TEMP = col_number(), QTEMP = col_number(),
          SALIN = col_number(), QSALIN = col_number(),
          TOTOXY = col_number(), QTOTOXY = col_number(),
          
          PO4P = col_number(), QPO4P = col_number(),
          TOTP = col_number(), QTOTP = col_number(),
          SIO4 = col_number(), QSIO4 = col_number(),
          NO3N = col_number(), QNO3N = col_number(),
          NO2N = col_number(), QNO2N = col_number(),
          NO23N = col_number(), QNO23N = col_number(),
          NH4N = col_number(), QNH4N = col_number(),
          TOTN = col_number(), QTOTN = col_number(),
          CHL = col_number(), QCHL = readr::col_number()
        )
      ) %>% select("ID", "LATITUDE", "LONGITUDE", "OBSDATE", "OBSTIME", "SHIP", "OBSDEP", param_codes) %>% 
        rowwise() %>% 
        ## filter to include only measurements with nutrient info
        mutate(chk = sum(!!!syms(grep("Q[A-Z0-9]+", param_codes, value = TRUE, invert = TRUE)))) %>% 
        filter(chk != 0) %>% 
        ungroup() %>% 
        select(-chk),
      
      silent = TRUE
    )
    return(tab)
    closeAllConnections()
  }
  
  ## loop through spatial grid boxes and dates ----
  cl <- parallel::makeCluster(3)
  doParallel::registerDoParallel(cl)
  result <- foreach::foreach(box = 1:ncol(latlon), .packages= c("stringr", "readr", "dplyr"), .combine = rbind) %dopar% {
    
    ## initialize results dataframe
    resultpar <- data.frame()
    
    for(dat in 1:length(dates_lst)){
      
      ## construct and open urls
      full_url <- sprintf(
        "%s?latBegin=%s&latEnd=%s&lonBegin=%s&lonEnd=%s&dateBegin=%s&dateEnd=%s",
        "http://nest.su.se/dataPortal/getStations",
        latlon[[1, box]], latlon[[2, box]], latlon[[3, box]], latlon[[4, box]], 
        dates_lst[[dat]][1], dates_lst[[dat]][2]
      )
      
      ## GET THE DATA ----
      ## if error in search, split and try again, show warning with query
      tmp <- try_query(full_url)
      
      if("try-error" %in% class(tmp)){
        
        url1 <- str_replace(
          full_url, 
          "latEnd=[0-9]+.[0-9]+", 
          sprintf("latEnd=%s", latlon[[1, box]]+(latlon[[2, box]]-latlon[[1, box]])/2)
        )
        tmp1 <- try_query(url1)
        if("try-error" %in% class(tmp1)){
          warning(sprintf(
            "ERROR in retrieving data with query: ?%s", 
            url1 %>% stringr::str_extract("latBegin.*$")
          ))
        } else {
          
          if(nrow(tmp1) == 0){
            message(sprintf(
              "no rows of data found for: ?%s", 
              url1 %>% stringr::str_extract("latBegin.*$")
            ))
            
          } else {resultpar <- rbind(resultpar, tmp1)}
        }
        
        url2 <- str_replace(
          full_url, 
          "latBegin=[0-9]+.[0-9]+", 
          sprintf("latBegin=%s", latlon[[1, box]]+(latlon[[2, box]]-latlon[[1, box]])/2)
        )
        tmp2 <- try_query(url2)
        if("try-error" %in% class(tmp2)){
          warning(sprintf(
            "ERROR in retrieving data with query: ?%s", 
            url2 %>% stringr::str_extract("latBegin.*$")
          ))
        } else {
          
          if(nrow(tmp2) == 0){
            message(sprintf(
              "no rows of data found for: ?%s", 
              url2 %>% stringr::str_extract("latBegin.*$")
            ))
            
          } else {resultpar <- rbind(resultpar, tmp2)}
        }
        
      } else {
        ## message if no rows data returned for query
        ## otherwise bind results
        if(nrow(tmp) == 0){
          message(sprintf(
            "no rows of data found for: ?%s", 
            full_url %>% stringr::str_extract("latBegin.*$")
          ))
          
        } else {resultpar <- rbind(resultpar, tmp)}
      }
    }
    result <- resultpar
  }
  stopCluster(cl)
  closeAllConnections()
  return(result)
}

#' get data from one of our primary sources
#' 
#' for more information the SMHI API see [here](http://opendata.smhi.se/apidocs/ocobs/index.html)
#' for more about ICES data portal web services see [here](http://ecosystemdata.ices.dk/WebServices/index.aspx)
#' for more information on the Copernicus open access hub see [here](https://scihub.copernicus.eu/twiki/do/view/SciHubUserGuide/)
#' 
#' @param data_source name of the source
#' @param date_range list or vector with two values given in YYYYMMDD format
#' @param months
#' @param latlon_ranges four-element vector or list: min lat, max lat, min lon, max lon.
#' @param param_code 
#' @param search_terms
#' @param api_key
#' @param delay
#' @param cores
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
  if(!is.na(search_terms)){
    search_terms <- search_terms %>% 
      str_to_lower() %>% 
      str_remove_all(",") %>% 
      str_split(pattern = " ") %>% 
      unlist()
  }

  date_begin <- lubridate::ymd(date_range[1])
  date_end <- lubridate::ymd(date_range[2])
  if(is.na(date_begin)|is.na(date_end)){
    stop("issue with dates, check date_range was given in YYYYMMDD format")
  }
  yrs <- seq(year(date_begin), year(date_end))
  months <- str_pad(months, width = 2, side = "left", pad = "0")
  
  
  ## BY DATA SOURCE
  
  if(data_source == "ices"){
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
      yrs <- mapply(yrs[-length(yrs)], yrs[2:length(yrs)], function(x, y){sprintf("yearBegining=%s&yearEnd=%s", x, y)})
    
      ## Output vars
      ## table of all dome web service outputs, from dome.ices.dk/Webservices/index.aspx
      vars <- select(read_csv(file.path(dir_prep, "ref", "lookup_tabs", "dome_ices_vars.csv"), col_types = cols()), var)
      
      ## Function to transform list from xml
      xml_to_df <- function(x){
        entry <- unlist(x) %>% 
          data.frame(row.names = str_remove(names(.), "DOMErecord.")) %>% 
          tibble::rownames_to_column() %>% 
          merge(vars, by.x = "rowname", by.y = "var", all = TRUE) %>% # will throw error if merging fails...
          t() %>% 
          data.frame(row.names = NULL)
        entry <- entry[2,]
        return(entry)
      }
      to_df_comp <- compiler::cmpfun(xml_to_df)
      
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
                     function(x, y){sprintf(url_base, x, y)})
    } else {urls <- lapply(yrs, function(x){sprintf(url_base, x)}) %>% unlist()}
    
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

#' compare raw data inputs
#' 
#' checks raw data inputs -from same source/table but obtained different years- against each other
#' the aim is to ensure consistency between sequential assessments, where expected
#'
#' @param data1
#' @param data2
#' @param compare
#' @param keys
#' @param keep_cols
#' @param color_var
#'
#' @return

compare_yrs_data <- function(data1, data2, compare, keys, keep_cols = NA, color_var = NA){

  if("string" %in% class(data1)){data1 <- readr::read_csv(data1)}
  if("string" %in% class(data2)){data2 <- readr::read_csv(data2)}
  
  if(is.na(keep_cols)){keep_cols = compare}
  keep_cols <- union(union(keep_cols, compare), keys)
  
  if(any(!c(keep_cols, keys) %in% names(data1))){
    stop("some key variables and/or selected columns not found in dataset 1")
  } else { df1 <- select(data1, keep_cols) }

  if(any(!c(keep_cols, keys) %in% names(data2))){
    stop("some key variables and/or selected columns not found in dataset 2")
  } else { df2 <- select(data2, keep_cols) }
  
  compare_df <- dplyr::full_join(df1, df2, by = keys)
  colnames(compare_df) <- c(paste0(names(df1), "1"), paste0(setdiff(names(df2), keys), "2")) %>% 
    stringr::str_to_lower() %>% 
    stringr::str_replace_all(pattern = str_to_lower(compare), replacement = "VALUE")

  ## other ideas of things to include in a script for comparing data...
  ## group by relevant categorical vars and check summary stats
  ## check for NAs after filtering to shared date range
  
  if(!is.na(color_var)){
    p <- ggplot2::ggplot(compare_df, aes(x = VALUE1, y = VALUE2, color = color_var))
  } else { p <- ggplot2::ggplot(compare_df, aes(x = VALUE1, y = VALUE2))}
  
  plot_obj <- p + geom_abline(slope = 1, intercept = 0, color = "grey") + 
    geom_point(cex = 2, alpha = 0.1) + 
    theme(legend.position = "none")

  return(plot_obj)
}

