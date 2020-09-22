Livelihoods and Economies (LE) - Economies (ECO) Subgoal Data
Preparation
================

<br>

``` r
loc <- here::here("prep", "ECO")

source(here::here("R", "setup.R"))
knitr::opts_chunk$set(message = FALSE, warning = FALSE, results = "hide")
dir_intermediate <- here::here("data", "ECO", version_year, "intermediate")

bkgd_path <- here::here("supplement", "goal_summaries", "ECO.Rmd")
data_path <- here::here("data", "ECO", version_year, "eco_data.rmd")
refs_path <- file.path(loc, "eco_references.Rmd")
# file.exists(c(loc, bkgd_path, data_path, refs_path))
```

## 1\. Background

### 1.1 Goal Description

The Economies goal captures the economic value associated with marine
industries, using revenue from marine sectors. Currently, it is composed
of a single component: revenue (Gross Value Added). Gross value added
(GVA) is defined as the value of output less the value of intermediate
consumption. It is used to measure the output or contribution of a
particular sector.

Ideally, the economic sub-goal would also incorporate information on the
sustainability of the different marine sectors.

### 1.2 Model & Data

#### 1.2.1 Data

Data for each country were downloaded from [The EU Blue Economy
Report. 2020.](https://ec.europa.eu/maritimeaffairs/sites/maritimeaffairs/files/2020_06_blueeconomy-2020-ld_final.pdf),
which provided 2009 and 2018 marine sector-specific revenue data (GVA)
among other metrics, in the country-specific Appendices. The report also
identified the potential for Blue Growth in each of the EU Member States
(MS) of the Baltic Sea Region (BSR) as well as at sea-basin level.

(Due to a lack of data, Russian regions (19, 22, 33) have NA scores for
this subgoal.)

#### 1.2.2 Status Model

Because the Blue Economy Report 2020 contains GVA values only for 2009
and 2018, the actual annual growth rates are not known and instead a
constant annual growth rate (AGR) across the 9 years is estimated using
the
formula:

\[AGR = \Bigg(\frac{FinalValue}{BeginningValue}\Bigg)^{\Big(1/numYears\Big)} - 1\]

Thus, all years between 2009 and 2018 will have the same status and
trend values within a given country.

The goal model compares the estimated annual growth rate per sector to
the target (1.5% between 2010 and 2020, as envisioned in the Report),
calculating status first per sector. The overall status is then
calculated as the average of the sector-statuses, weighted by relative
contribution of the sectors to the country’s total marine-related
economic
revenue.

\[Status = \sum_{Sectors}{\big((SectorRevenue/TotalRevenue) \cdot SectorStatus}\big)\]

\[SectorStatus = \begin{cases} 
      0 &  \hspace{10pt} SectorAGR \leq -1.5 \\
      100/3 \hspace{2pt}\cdot \hspace{2pt} SectorAGR \hspace{3pt} + \hspace{3pt} 50 & \hspace{10pt}-1.5\leq SectorAGR \leq 1.5 \\
      100 & \hspace{10pt} 1.5\leq SectorAGR
   \end{cases}
\]

#### 1.2.3 Trend Model

Trend of this goal is the weighted average of the growth rates of each
sector by their relative contribution to the total revenue, where the
sector growth rates are the annual growth rates (AGR) estimated from
2009 and 2018 GVA
data.

\[Trend = \sum_{Sectors}{\big((SectorRevenue/TotalRevenue) \cdot SectorAGR}\big)\]

### 1.3 Reference points

As reference points we used a 1.5% annual growth between 2010 and 2020,
as envisioned in the Blue Growth Report.

### 1.4 Other information

External advisors/goalkeepers: Wilfried Rickels.

<br/>

## 2\. Data

This prep document is used to generate and explore the following data
layers:

  - `le_eco_bluegrowth_rates_bhi2019.csv`
  - `le_eco_yearly_gva_bhi2019.csv`

These are saved to the `layers` folder. Saved to
`data/ECO/v2019/intermediate` is intermediate dataset:
`le_eco_bluegrowth_bhi2019.csv`. All these are derived from or informed
by the raw datasets from the EU Blue Growth 2020 Report.

<br>

<!-- ## 2. Data --- header in the child  document -->

<br>

### 2.1 Datasets with Sources

<br/>

#### 2.1.1 EU Baltic countries GVA Data

Data for the 8 EU Baltic countries were extracted from the [2020 EU Blue
economy
report](https://ec.europa.eu/maritimeaffairs/sites/maritimeaffairs/files/2020_06_blueeconomy-2020-ld_final.pdf)
on July 14 2020 by Andrea De Cervo.

In particular, detailed info on GVA% by sub-sector and activity per
member state were extracted from the tables on the [Annex
I](https://ec.europa.eu/maritimeaffairs/sites/maritimeaffairs/files/2020_06_blueeconomy-2020-annexes-ld-part1_final.pdf)
and [Annex
II](https://ec.europa.eu/maritimeaffairs/sites/maritimeaffairs/files/2020_06_blueeconomy-2020-annexes-ld-part2_final.pdf).

#### 2.1.2 Russian country level data

No GVA data found for Russia.

#### 2.1.3 Reference values

Target is **1.5 % annual growth** between 2009 and 2018, as envisioned
in the [2020 EU Blue economy
report](https://ec.europa.eu/maritimeaffairs/sites/maritimeaffairs/files/2020_06_blueeconomy-2020-ld_final.pdf).
Status is calculated for each sector, and goal status is the average of
sector status scores.

<br>

### 2.2 Centralization & Normalization

#### 2.2.1 GVA datasets

The downloaded raw datasets provides an overview of the Blue Economy in
the individual Member States. They include the established sectors,
ensuring a comparable analysis across all the MS. In particular, these
datasets shows an overview of the Blue Economy by sub-sector and
activity for employment, GVA and turnover.

``` r
columns <- c(
  "country",
  "Sector",
  "Sub-sector",
  "Activity",
  "Persons employed (2009)",
  "Persons employed (2018)",
  "Persons employed (delta 2018-09)",
  "Turnover (M€) (2009)",
  "Turnover (M€) (2018)",
  "Turnover (M€) (delta 2018-09)",
  "Value added at factor cost (M€) (2009)",
  "Value added at factor cost (M€) (2018)",
  "Value added at factor cost (M€) (delta 2018-09)",
  "GVA to turnover (%) (2009)",
  "GVA to turnover (%) (2018)",
  "GVA to turnover (%) (delta 2018-09)",
  "Gross operating surplus (M€) (2009)",
  "Gross operating surplus (M€) (2018)",
  "Gross operating surplus (M€) (delta 2018-09)",
  "Gross profit margin (%) (2009)",
  "Gross profit margin (%) (2018)",
  "Gross profit margin (%) (delta 2018-09)",
  "Personnel costs per employee (k€) (2009)",
  "Personnel costs per employee (k€) (2018)",
  "Personnel costs per employee (k€)  (delta 2018-09)"
) 
columns <- columns %>% 
    stringr::str_to_lower() %>% 
    stringr::str_remove(" \\(.*\\) ") %>% 
    stringr::str_replace_all(" |\\(|\\)|-", "_") %>% 
    stringr::str_remove("_$") %>% 
    stringr::str_replace_all("__", "_")

for(f in grep(".*_blueconomy.*csv", list.files(dir_rawdata), value = TRUE)){
  
  tmp <- read.csv(file.path(dir_rawdata, f), sep = ";")
  tmp[,] <- sapply(tmp[,], as.character)
  colnames(tmp) <- columns
  
  assign(
    sprintf("%s_gva", substr(f, 1, 3)),
    tmp %>% 
      mutate_at(
        setdiff(columns, c("country", "sector", "sub_sector", "activity")), 
        function(x){as.numeric(stringr::str_replace(stringr::str_remove(x, "%| |-$"), ",", "."))}
      ) %>% 
      mutate_at(
        vars(matches(".*delta.*|.*gva_to_turnover.*|.*gross_profit_margin.*")), 
        function(x){x/100}
      ) %>% 
      filter(country != "", sector != "", sub_sector!= "", activity!= "")
  )
}
```

<br>

**Clean, explore and merge GVA
datasets**

``` r
eco_data_combined <- rbind(den_gva, est_gva, fin_gva, ger_gva, lat_gva, lit_gva, pol_gva, swe_gva) %>% 
  filter(!(sector == "all sectors" & sub_sector == "all sub-sectors"))

#write_csv(
#  eco_data_combined,
#  file.path(dir_intermediate, "le_eco_bluegrowth_bhi2019.csv")
#)

eco_data_combined <- eco_data_combined %>% 
  dplyr::select(
    country, sector, sub_sector, activity, 
    ## only need GVA for 2009 and 2018
    value_added_at_factor_cost_2009,
    value_added_at_factor_cost_2018
  ) %>% 
  
  ## group and aggregate by sub-sector and country
  group_by(country, sector) %>% 
  summarize(
    value_added_at_factor_cost_2009 = sum(value_added_at_factor_cost_2009, na.rm = TRUE), 
    value_added_at_factor_cost_2018 = sum(value_added_at_factor_cost_2018, na.rm = TRUE)
  ) %>% 
  ungroup() %>% 
  
  ## calculate annual growth rate with cagr formula
  ## annualgrowthrate result in decimal form, multiply by 100 to get percent %
  mutate(annualgrowthrate = (value_added_at_factor_cost_2018/value_added_at_factor_cost_2009)^(1/9) - 1) %>% 
  mutate(annualgrowthrate = ifelse(is.nan(annualgrowthrate), NA, annualgrowthrate)) %>% 
  
  ## estimate GVA at years 2009-2018, 
  ## CONVERT VALUE TO SECTOR PROPORTION OF TOTAL COUNTRY MARINE GVA
  ## (so when expand to BHI regions rather than countries, isn't misleading!!!)
  mutate(year = list(c(2009:2018))) %>% 
  tidyr::unnest(cols = c(year)) %>% 
  mutate(value_added_year = value_added_at_factor_cost_2009*((annualgrowthrate+1)^(year-2009))) %>% 
  group_by(country, year) %>% 
  mutate(annual_total_marine_value_added = sum(value_added_year, na.rm = TRUE)) %>% 
  ungroup() %>% 
  mutate(prop_annual_value_added = value_added_year/annual_total_marine_value_added)
  
  
## add bhi regions
eco_data_bhirgns <- read_csv(file.path(dir_prep, "supplement", "lookup_tabs", "rgns_complete.csv")) %>% 
  dplyr::select(region_id, country = eez) %>% 
  mutate(year = list(c(2009:2018))) %>%
  tidyr::unnest(cols = c(year)) %>%
  full_join(eco_data_combined, by = c("country", "year")) %>% 
 
  ## convert the annual growth rate into a perentage and round to just one decimal place
  ## NOTE: NOW GROWTH RATE WILL BE IN PERCENTAGE NOT DECIMAL FORM
  mutate(annualgrowthrate = round(annualgrowthrate*100, 1))
```

**Plot of Blue Economy approximate annual growth by country**
![](eco_prep_files/figure-gfm/plot%20of%20blue%20economy%20approximate%20annual%20growth%20by%20country-1.png)<!-- -->

``` r
write_csv(
  select(eco_data_bhirgns, region_id, sector, year, annual_growth_rate = annualgrowthrate),
  file.path(dir_layers, "le_eco_bluegrowth_rates_bhi2019.csv")
)
write_csv(
  select(
    eco_data_bhirgns, 
    region_id, sector, year, 
    gva_sector_prop = prop_annual_value_added, 
    country_gva_estim = value_added_year
  ),
  file.path(dir_layers, "le_eco_yearly_gva_bhi2019.csv")
)
```

<br/>

## 3\. Visualizing Data Layers

### 3.1 Map

**Marine sectors economic growth rates**

``` r
source(here::here("R", "spatial.R"))
regions_shape()
bhirgn_simple <- rmapshaper::ms_simplify(input = BHI_rgns_shp) %>% sf::st_as_sf()

eco_data_combined <- read_csv(file.path(dir_intermediate, "le_eco_bluegrowth_bhi2019.csv"))

eco_data_combined <- eco_data_combined %>% 
  dplyr::select(
    country, sector, sub_sector, activity, 
    ## only need GVA for 2009 and 2018
    value_added_at_factor_cost_2009,
    value_added_at_factor_cost_2018
  ) %>% 
  
  ## group and aggregate by sub-sector and country
  group_by(country, sector) %>% 
  summarize(
    value_added_at_factor_cost_2009 = sum(value_added_at_factor_cost_2009, na.rm = TRUE), 
    value_added_at_factor_cost_2018 = sum(value_added_at_factor_cost_2018, na.rm = TRUE)
  ) %>% 
  ungroup() %>% 
  
  ## calculate annual growth rate with cagr formula
  ## annualgrowthrate result in decimal form, multiply by 100 to get percent %
  mutate(annualgrowthrate = (value_added_at_factor_cost_2018/value_added_at_factor_cost_2009)^(1/9) - 1) %>% 
  mutate(annualgrowthrate = ifelse(is.nan(annualgrowthrate), NA, annualgrowthrate)) %>% 
  
  ## estimate GVA at years 2009-2018, 
  ## CONVERT VALUE TO SECTOR PROPORTION OF TOTAL COUNTRY MARINE GVA
  ## (so when expand to BHI regions rather than countries, isn't misleading!!!)
  mutate(year = list(c(2009:2018))) %>% 
  tidyr::unnest(cols = c(year)) %>% 
  mutate(value_added_year = value_added_at_factor_cost_2009*((annualgrowthrate+1)^(year-2009))) %>% 
  group_by(country, year) %>% 
  mutate(annual_total_marine_value_added = sum(value_added_year, na.rm = TRUE)) %>% 
  ungroup() %>% 
  mutate(prop_annual_value_added = value_added_year/annual_total_marine_value_added)
  
## add bhi regions
eco_data_bhirgns <- read_csv(file.path(dir_prep, "supplement", "lookup_tabs", "rgns_complete.csv")) %>% 
  dplyr::select(region_id, country = eez) %>% 
  mutate(year = list(c(2009:2018))) %>%
  tidyr::unnest(cols = c(year)) %>%
  full_join(eco_data_combined, by = c("country", "year")) %>% 
 
  ## convert the annual growth rate into a perentage and round to just one decimal place
  ## NOTE: NOW GROWTH RATE WILL BE IN PERCENTAGE NOT DECIMAL FORM
  mutate(annualgrowthrate = round(annualgrowthrate*100, 1))

mapsf <- left_join(
  bhirgn_simple %>% 
    dplyr::select(region_id = BHI_ID, Subbasin, country = rgn_nam),
  eco_data_bhirgns %>% 
    filter(year == 2018) %>% 
    dplyr::select(region_id, country, sector, annualgrowthrate),
    # mutate(sector = stringr::str_replace_all(stringr::str_to_lower(sector), " ", "_")) %>% 
    # tidyr::pivot_wider(names_from = sector, values_from = annualgrowthrate),
  by = c("region_id", "country")
)

ggplot2::ggplot(rnaturalearth::ne_countries(scale = "medium", returnclass = "sf")) +
  geom_sf(size = 0.1, color = "burlywood", alpha = 0.4) +
  theme(
    panel.background = element_rect(fill = "#F8FBFC", color = "#E2EEF3"), 
    legend.position = c(0.9, 0.15),
    legend.background = element_rect(color = "lavender")
  ) +
  scale_x_continuous(limit = c(4, 32)) +
  scale_y_continuous(limit = c(53.5, 66)) +
  geom_sf(data = filter(mapsf, !is.na(annualgrowthrate)), aes(fill = annualgrowthrate)) +
  labs(fill = "Annual Growth Rate (%)") +
  facet_wrap(~sector) +
  scale_fill_gradientn(
    colors = c("coral", "khaki", "cadetblue", "lightblue", "lavender", "ivory"),
    limits = c(-15, 40)
  )
```

![](eco_prep_files/figure-gfm/marine%20sectors%20economic%20growth%20rates-1.png)<!-- -->

<br>

## 4\. Considerations for `BHI3.0`

Will need to find new data sources for GVA in next BHI Assessments, if
Blue Growth Reports are discontinued. Eurostat has SBS trade indicators,
which together with other sources form the basis for the Blue Growth
Reports. These data could be explored as a replacement for GVA values
extracted from the Blue Growth Reports. This option (using eurostat
data) may be made easier by using the Eurostat R package.

Use [Eurostat API for Administrative
Units](https://ec.europa.eu/eurostat/web/gisco/geodata/reference-data/administrative-units-statistical-units)
and [R package ‘eurostat: Tools for Eurostat Open
Data’](https://cran.r-project.org/web/packages/eurostat/index.html)

<br>

## 5\. References

European Commission (2020). [The EU Blue Economy
Report. 2020.](https://ec.europa.eu/maritimeaffairs/sites/maritimeaffairs/files/2020_06_blueeconomy-2020-ld_final.pdf)
Publications Office of the European Union. Luxembourg. Prepared by the
Directorate-General Maritime Affairs and Fisheries jointly with the
Joint Research Centre.

European Commission (2020). [The EU Blue Economy Report. 2020. Annex
I](https://ec.europa.eu/maritimeaffairs/sites/maritimeaffairs/files/2020_06_blueeconomy-2020-annexes-ld-part1_final.pdf).
Publications Office of the European Union. Luxembourg.

European Commission (2020). [The EU Blue Economy Report. 2020. Annex
II](https://ec.europa.eu/maritimeaffairs/sites/maritimeaffairs/files/2020_06_blueeconomy-2020-annexes-ld-part2_final.pdf).
Publications Office of the European Union. Luxembourg.
