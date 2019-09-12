library(tidyverse)

dir_assess = "/Users/eleanorecampbell/Desktop/GitHub/bhi/baltic"
list.files("/Users/eleanorecampbell/Desktop/GitHub/bhi/baltic/layers")

## layers information ----
## NOTE: THIS MATCHES LAYERS USED IN WEB/GOALS.RMD OF BHI MASTER BRANCH (USED TO CREATE WEBSITE GOALS PAGE)
layers0 <- readr::read_csv(file.path(
  "https://raw.githubusercontent.com/OHI-Science/bhi-1.0-archive/draft/",
  "baltic2015",
  "layers.csv")) # need to read from github so works in eg  ghpages branch
# layers_csv <- readr::read_csv(file.path(
#   "https://raw.githubusercontent.com/OHI-Science/bhi/master",
#   basename(dir_assess),
#   "layers.csv"))
lyr_csv <- layers0 %>%
  select(targets, name, layer, description, units) %>% 
  filter(name != "proxy_layer") %>% 
  mutate(description = ifelse(is.na(description), "See goal description above or data prep documents for more information.", description)) %>% 
  
  mutate(description = description %>% 
           str_remove_all(pattern = "\\n\\n\\n")) %>% 
  mutate(
    name_abbrev = name %>% 
      str_replace_all(pattern = "\\(", replacement = "openparentheses ") %>% 
      str_replace_all(pattern = "\\.", replacement = " periodpunctuation") %>% 
      str_replace_all(pattern = "to be used", replacement = "tobeused") %>% 
      str_replace_all(pattern = "based on|based upon", replacement = "basedon") %>% 
      str_replace_all(pattern = "of the European Parliament", replacement = "oftheEuropeanParliament")
  ) %>%
  rowwise() %>% 
  mutate(
    name_abbrev = ifelse(
      str_length(name) < 35,
      name,
      str_split(
        name_abbrev,
        pattern = paste0("\\s", 
                         intersect(
                           c("oftheEuropeanParliament", "openparentheses", "periodpunctuation", ",", "basedon", "tobeused", "as", "of"),
                           str_split(name_abbrev, pattern = " ") %>% unlist())[1], "\\s"
        )
      )[[1]][1]
    )
  ) %>%
  mutate(
    name_abbrev = name_abbrev %>% 
      str_replace_all(pattern = " periodpunctuation", replacement = "\\.") %>% 
      str_replace_all(pattern = " basedon", replacement = "based on")) %>%
  mutate(
    web_name = str_to_lower(gsub(" ", "_", name_abbrev)) %>% 
      gsub(pattern = "/", replacement = "")
  ) %>% 
  
  mutate(info = sprintf("[%s](%s#%s) (%s): %s", name_abbrev, layers_web, web_name, layer, description))


## layer summaries templates text ----
filetxt <- scan(
  file.path(getwd(), "ref", "layer_summaries_template.md"),
  what = "character",
  sep = "\n",
  blank.lines.skip = FALSE
)

bhiRmd_txt <- c(
  "**LAYERFULLNAME**",
  "",
  "```{r, echo = FALSE, results = \"hide\"}",
  "tmp <- tempfile(fileext = \"Rmd\")",
  "on.exit(unlink(tmp))",
  "download.file(file.path(short_layer_web, \"LAYERNAME.Rmd\"), tmp)", 
  "```",
  "",
  "```{r, child = tmp, echo = FALSE, results = \"asis\"}", 
  "```",
  "",
  "---",
  ""
)

## create docs ----
lyrs_names <- lyr_csv$layer %>% sort()
for(lyr in lyrs_names){
  make_file <- file.path(getwd(), "ref", "layer_summaries", paste(lyr, "Rmd", sep = "."))
  if(!file.exists(make_file)){file.create(make_file)}
  
  lyr_txt <- filetxt
  
  ## layername
  lyr_txt[grep(x = lyr_txt, pattern = "LAYERNAME")] <- lyr_txt[grep(
    x = lyr_txt, 
    pattern = "LAYERNAME"
  )] %>% str_replace_all(pattern = "LAYERNAME", lyr)
  ## layer filename
  lyr_txt[grep(x = lyr_txt, pattern = "LAYERFILENAME")] <- lyr_txt[grep(
    x = lyr_txt, 
    pattern = "LAYERFILENAME"
  )] %>% str_replace_all(pattern = "LAYERFILENAME", filter(lyr_csv, layer == lyr)$filename)
  ## units
  lyr_txt[grep(x = lyr_txt, pattern = "UNITS")] <- lyr_txt[grep(
    x = lyr_txt, 
    pattern = "UNITS"
  )] %>% str_replace_all(pattern = "UNITS", filter(lyr_csv, layer == lyr)$units)
  ## index dimension
  lyr_txt[grep(x = lyr_txt, pattern = "INDEXDIMENSION")] <- lyr_txt[grep(
    x = lyr_txt, 
    pattern = "INDEXDIMENSION"
  )] %>% str_replace_all(
      pattern = "INDEXDIMENSION", 
      replacement = ifelse(
        "pressures" %in% filter(lyr_csv, layer == lyr)$targets %>% str_split(pattern = " ") %>% unlist(),
        "Pressure",
        ifelse(
          "resilience" %in% filter(lyr_csv, layer == lyr)$targets %>% str_split(pattern = " ") %>% unlist(),
          "Resilience",
          "Status and Trend"
        )
      )
    )
  ## goal targets
  lyr_txt[grep(x = lyr_txt, pattern = "GOALTARGETS")] <- lyr_txt[grep(
    x = lyr_txt, 
    pattern = "GOALTARGETS"
  )] %>% 
  str_replace_all(
    pattern = "GOALTARGETS", 
    replacement = ifelse(
      is.na(filter(lyr_csv, layer == lyr)$targets),
      "This layer is no longer used but has not yet been removed from the BHI",
      filter(lyr_csv, layer == lyr)$targets
    )
  )
  ## layer description
  lyr_txt[grep(x = lyr_txt, pattern = "DESCRIPTION")] <- lyr_txt[grep(
    x = lyr_txt, 
    pattern = "DESCRIPTION"
  )] %>% str_replace_all(pattern = "DESCRIPTION", filter(lyr_csv, layer == lyr)$description)
  ## goal prep link if relevant
  lyr_txt[grep(x = lyr_txt, pattern = "THISGOAL")] <- ifelse(
    !filter(lyr_csv, layer == lyr)$targets %in% 
      c("FP", "FIS", "MAR", "AO", "NP", "CS", "TR", "LE", "LIV", "ECO", "SP", "ICO", "LSP", "CW", "EUT", "TRA", "CON", "BD"),
    "", # could add something more for pressures or resilience docs here with more ifelses
    lyr_txt[grep(x = lyr_txt, pattern = "THISGOAL")] %>% 
      str_replace(pattern = "THISGOALPREP",
                  replacement = paste(str_to_lower(filter(lyr_csv, layer == lyr)$targets), "prep", sep =  "_")) %>% 
      str_replace_all(pattern = "THISGOAL",
                  replacement = filter(lyr_csv, layer == lyr)$targets)
  )
 
  
  ## for layers.Rmd doc in the bhi repo...
  bhiRmd_lyrtxt <- bhiRmd_txt
  
  ## layer full name
  bhiRmd_lyrtxt[grep(x = bhiRmd_lyrtxt, pattern = "LAYERFULLNAME")] <- bhiRmd_lyrtxt[grep(
    x = bhiRmd_lyrtxt, 
    pattern = "LAYERFULLNAME"
  )] %>% str_replace_all(pattern = "LAYERFULLNAME", filter(lyr_csv, layer == lyr)$name %>% str_to_title())
  ## layername
  bhiRmd_lyrtxt[grep(x = bhiRmd_lyrtxt, pattern = "LAYERNAME")] <- bhiRmd_lyrtxt[grep(
    x = bhiRmd_lyrtxt, 
    pattern = "LAYERNAME"
  )] %>% str_replace_all(pattern = "LAYERNAME", lyr)
  
    
  ## write the configured/layer-specific text to the rmd docs
  sink(file = make_file, append = FALSE)
  cat(lyr_txt, sep = "\n")
  closeAllConnections()
  
  sink(file = file.path(dir_bhi, "supplement", "web", "layers.Rmd"), append = TRUE)
  cat(bhiRmd_lyrtxt, sep = "\n")
  closeAllConnections()
}

