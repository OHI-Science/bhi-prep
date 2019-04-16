## Libraries
source(file.path(here::here(), "R", "common.R"))
library(rgdal)
library(sp)
library(sf)
library(raster)
library(fasterize)
library(rgeos)
library(maptools)
library(ncdf4)
library(colorRamps)
library(paletteer)
library(parallel)
library(RQGIS)
library(tibble)

## Functions

subset_to_bhi_rgns <- function(){
  
}


# loc = "C:/Users/jgrif/Documents/StockholmUnivPostDoc/BalticHealthIndex/BHI_r/shapefiles/BHI_shapefile_projected"
plot_bhi_with_nuts_rgns <- function(shp_loc){
  
  ## read shapefiles from location specified by shapefile location param 'shp_loc'
  bhi_shp <- st_read(shp_loc, "BHI_shapefile_projected.shp") %>% 
    sf::st_transform("+proj=longlat +init=epsg:4326")
  plot(st_geometry(bhi_shp))
  
  bhi_shp_buffer <- st_read(shp_loc, "BHI_shapefile_25km_buffer_projected.shp") %>% 
    sf::st_transform("+proj=longlat +init=epsg:4326")
  plot(st_geometry(bhi_shp_buffer))
  
  nuts2 <- st_read(shp_loc, "NUTS2006_Level_2_reprojected.shp") %>% 
    sf::st_transform("+proj=longlat +init=epsg:4326")
  plot(st_geometry(nuts2))
  
  nuts3 <- st_read(shp_loc, "NUTS2006_Level_3_reprojected.shp") %>% 
    sf::st_transform("+proj=longlat +init=epsg:4326")
  plot(st_geometry(nuts3))
  
  
  
  
}


##---------------------------------------##
## PLOT BHI REGIONS and NUTS3 REGIONS ##
##---------------------------------------##

## get centroids of polygons for plotting labels
centroids_bhi <- getSpPPolygonsLabptSlots(BHIshp2)%>% data.frame()%>%
  dplyr::rename(lon=X1, lat=X2)%>%
  mutate(BHI_ID = BHIshp2@data$BHI_ID)

centroids_nuts3 =getSpPPolygonsLabptSlots(NUTS3_2)%>% data.frame()%>%
  dplyr::rename(lon=X1, lat=X2)%>%
  mutate(NUTS3_ID = NUTS3_2@data$NUTS_ID)

## plot NUTS3 and shapefile with buffer
png(file.path(dir_prep,"BHI_regions_NUTS3_withbuffer_plot.png"),
    width = 210, height=297, units="mm",res=300 )
plot(BHIshp_buffer2, col="red")
plot(BHIshp2, add=TRUE)
plot(NUTS3_2, add=TRUE)
text(centroids_nuts3$lon,centroids_nuts3$lat, labels=centroids_nuts3$NUTS3_ID, col="black",cex=.3)
text(centroids_bhi$lon, centroids_bhi$lat, labels=centroids_bhi$BHI_ID, col="red",cex=.5)
dev.off()

## plot NUTS3 and shapefile without buffer
png(file.path(dir_prep,"BHI_regions_NUTS3_plot.png"),
    width = 210, height=297, units="mm",res=300 )
plot(BHIshp2,col="red")
plot(NUTS3_2, add=TRUE)
text(centroids_nuts3$lon,centroids_nuts3$lat, labels=centroids_nuts3$NUTS3_ID, col="black",cex=.3)
text(centroids_bhi$lon, centroids_bhi$lat, labels=centroids_bhi$BHI_ID, col="black",cex=.5)
dev.off()


##---------------------------------------##
## PLOT BHI REGIONS and NUTS2 REGIONS ##
##---------------------------------------##

## get centroids of polygons for plotting labels
centroids_nuts2 =getSpPPolygonsLabptSlots(NUTS2_2)%>% data.frame()%>%
  dplyr::rename(lon=X1, lat=X2)%>%
  mutate(NUTS2_ID = NUTS2_2@data$NUTS_ID)

## plot NUTS2 and shapefile with buffer
png(file.path(dir_prep,"BHI_regions_NUTS2_withbuffer_plot.png"),
    width = 210, height=297, units="mm",res=300 )
plot(BHIshp_buffer2, col="red")
plot(BHIshp2, add=TRUE)
plot(NUTS2_2, add=TRUE)
text(centroids_nuts2$lon,centroids_nuts2$lat, labels=centroids_nuts2$NUTS2_ID, col="black",cex=.3)
text(centroids_bhi$lon, centroids_bhi$lat, labels=centroids_bhi$BHI_ID, col="red",cex=.5)
dev.off()

## plot NUTS2 and shapefile without buffer
png(file.path(dir_prep,"BHI_regions_NUTS2_plot.png"),
    width = 210, height=297, units="mm",res=300 )
plot(BHIshp2,col="red")
plot(NUTS2_2, add=TRUE)
text(centroids_nuts2$lon,centroids_nuts2$lat, labels=centroids_nuts2$NUTS2_ID, col="black",cex=.3)
text(centroids_bhi$lon, centroids_bhi$lat, labels=centroids_bhi$BHI_ID, col="black",cex=.5)
dev.off()
