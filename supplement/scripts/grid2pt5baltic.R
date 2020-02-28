library(sf)

bhishp <- st_read(file.path(dirname(dir_B), "Shapefiles", "BHI_shapefile"))
bhishp_simple <- rmapshaper::ms_simplify(input = st_combine(bhishp))

grid <- st_make_grid(
  bhishp_simple,
  2.6,
  crs = st_crs(bhishp_simple),
  what = "polygons",
  square = TRUE
)

for(i in 1:5){
  sprintf(
    "sf::st_polygon(list(rbind(c(%s,%s),c(%s,%s),c(%s,%s),c(%s,%s),c(%s,%s)))),", 
    grid[[i]][[1]][1,1], grid[[i]][[1]][1,2],
    grid[[i]][[1]][2,1], grid[[i]][[1]][2,2],
    grid[[i]][[1]][3,1], grid[[i]][[1]][3,2],
    grid[[i]][[1]][4,1], grid[[i]][[1]][4,2],
    grid[[i]][[1]][5,1], grid[[i]][[1]][5,2]
  ) %>% cat(sep = "\n")
}

for(i in 10:15){
  sprintf(
    "sf::st_polygon(list(rbind(c(%s,%s),c(%s,%s),c(%s,%s),c(%s,%s),c(%s,%s)))),", 
    grid[[i]][[1]][1,1]+0.73, grid[[i]][[1]][1,2],
    grid[[i]][[1]][2,1]+0.73, grid[[i]][[1]][2,2],
    grid[[i]][[1]][3,1]+0.73, grid[[i]][[1]][3,2],
    grid[[i]][[1]][4,1]+0.73, grid[[i]][[1]][4,2],
    grid[[i]][[1]][5,1]+0.73, grid[[i]][[1]][5,2]
  ) %>% cat(sep = "\n")
}

j = 0.05
k = 0
for(i in 22:26){
  sprintf(
    "sf::st_polygon(list(rbind(c(%s,%s),c(%s,%s),c(%s,%s),c(%s,%s),c(%s,%s)))),", 
    grid[[i]][[1]][1,1]-0.1+k, grid[[i]][[1]][1,2],
    grid[[i]][[1]][2,1]-0.1+j, grid[[i]][[1]][2,2],
    grid[[i]][[1]][3,1]-0.1+j, grid[[i]][[1]][3,2],
    grid[[i]][[1]][4,1]-0.1+k, grid[[i]][[1]][4,2],
    grid[[i]][[1]][5,1]-0.1+k, grid[[i]][[1]][5,2]
  ) %>% cat(sep = "\n")
  j = j+0.05
  k = k+0.05
}

for(i in 31:33){
  sprintf(
    "sf::st_polygon(list(rbind(c(%s,%s),c(%s,%s),c(%s,%s),c(%s,%s),c(%s,%s)))),", 
    grid[[i]][[1]][1,1]-0.2, grid[[i]][[1]][1,2],
    grid[[i]][[1]][2,1]-0.2, grid[[i]][[1]][2,2],
    grid[[i]][[1]][3,1]-0.2, grid[[i]][[1]][3,2]+0.05,
    grid[[i]][[1]][4,1]-0.2, grid[[i]][[1]][4,2]+0.05,
    grid[[i]][[1]][5,1]-0.2, grid[[i]][[1]][5,2]
  ) %>% cat(sep = "\n")
}

for(i in 41:42){
  sprintf(
    "sf::st_polygon(list(rbind(c(%s,%s),c(%s,%s),c(%s,%s),c(%s,%s),c(%s,%s)))),", 
    grid[[i]][[1]][1,1]+0.85, grid[[i]][[1]][1,2]+0.05,
    grid[[i]][[1]][2,1]+0.85, grid[[i]][[1]][2,2]+0.05,
    grid[[i]][[1]][3,1]+0.85, grid[[i]][[1]][3,2],
    grid[[i]][[1]][4,1]+0.85, grid[[i]][[1]][4,2],
    grid[[i]][[1]][5,1]+0.85, grid[[i]][[1]][5,2]+0.05
  ) %>% cat(sep = "\n")
}

grid_subset <- st_sfc(
  
  sf::st_polygon(list(rbind(c(9.4208242,53.602111),c(12.0208242,53.602111),c(12.0208242,56.202111),c(9.4208242,56.202111),c(9.4208242,53.602111)))),
  sf::st_polygon(list(rbind(c(12.0208242,53.602111),c(14.6208242,53.602111),c(14.6208242,56.202111),c(12.0208242,56.202111),c(12.0208242,53.602111)))),
  sf::st_polygon(list(rbind(c(14.6208242,53.602111),c(17.2208242,53.602111),c(17.2208242,56.202111),c(14.6208242,56.202111),c(14.6208242,53.602111)))),
  sf::st_polygon(list(rbind(c(17.2208242,54.202111),c(19.8208242,54.202111),c(19.8208242,56.202111),c(17.2208242,56.202111),c(17.2208242,54.202111)))),
  sf::st_polygon(list(rbind(c(19.8208242,54.202111),c(21.7208242,54.202111),c(21.7208242,56.202111),c(19.8208242,56.202111),c(19.8208242,54.202111)))),
  
  sf::st_polygon(list(rbind(c(10.1508242,56.202111),c(12.9370242,56.202111),c(12.9370242,58.002111),c(10.1508242,58.002111),c(10.1508242,56.202111)))),
  
  sf::st_polygon(list(rbind(c(15.8508242,56.202111),c(17.9508242,56.202111),c(17.9508242,58.802111),c(15.8508242,58.802111),c(15.8508242,56.202111)))),
  sf::st_polygon(list(rbind(c(17.9508242,56.202111),c(20.5508242,56.202111),c(20.5508242,58.802111),c(17.9508242,58.802111),c(17.9508242,56.202111)))),
  sf::st_polygon(list(rbind(c(20.5508242,56.202111),c(23.1508242,56.202111),c(23.1508242,58.802111),c(20.5508242,58.802111),c(20.5508242,56.202111)))),
  sf::st_polygon(list(rbind(c(23.1508242,56.902111),c(24.9508242,56.902111),c(24.9508242,58.802111),c(23.1508242,58.802111),c(23.1508242,56.902111)))),
  
  sf::st_polygon(list(rbind(c(17.1208242,58.802111),c(19.7708242,58.802111),c(19.7708242,61.402111),c(17.1208242,61.402111),c(17.1208242,58.802111)))),
  sf::st_polygon(list(rbind(c(19.7708242,58.802111),c(22.4208242,58.802111),c(22.4208242,61.402111),c(19.7708242,61.402111),c(19.7708242,58.802111)))),
  sf::st_polygon(list(rbind(c(22.4208242,58.802111),c(25.0708242,58.802111),c(25.0708242,60.802111),c(22.4208242,60.802111),c(22.4208242,58.802111)))),
  sf::st_polygon(list(rbind(c(25.0708242,59.202111),c(27.7208242,59.202111),c(27.7208242,60.802111),c(25.0708242,60.802111),c(25.0708242,59.202111)))),
  sf::st_polygon(list(rbind(c(27.7208242,59.202111),c(30.3708242,59.202111),c(30.3708242,60.802111),c(27.7208242,60.802111),c(27.7208242,59.202111)))),
  
  sf::st_polygon(list(rbind(c(17.0208242,61.402111),c(19.6208242,61.402111),c(19.6208242,64.052111),c(17.0208242,64.052111),c(17.0208242,61.402111)))),
  sf::st_polygon(list(rbind(c(19.6208242,61.402111),c(22.2208242,61.402111),c(22.2208242,64.052111),c(19.6208242,64.052111),c(19.6208242,61.402111)))),
  sf::st_polygon(list(rbind(c(22.2208242,63.002111),c(24.8208242,63.002111),c(24.8208242,64.052111),c(22.2208242,64.052111),c(22.2208242,63.002111)))),
  
  sf::st_polygon(list(rbind(c(20.6708242,64.052111),c(23.2708242,64.052111),c(23.2708242,66.002111),c(20.6708242,66.002111),c(20.6708242,64.052111)))),
  sf::st_polygon(list(rbind(c(23.2708242,64.052111),c(25.8708242,64.052111),c(25.8708242,66.002111),c(23.2708242,66.002111),c(23.2708242,64.052111)))),
  
  crs = st_crs(bhishp_simple)
)
plot(bhishp_simple)
plot(grid_subset, border = "red", add = TRUE)

df <- st_sf(box = 1:length(grid_subset), geometry = grid_subset)
st_write(df, file.path(dirname(dir_B), "Shapefiles", "baltic_boxes", "baltic_boxes.shp"))


grid <- st_make_grid(
  bhishp_simple,
  2.4,
  crs = st_crs(bhishp_simple),
  what = "polygons",
  square = TRUE
)

for(i in c(1:5, 51:52)){
  sprintf(
    "sf::st_polygon(list(rbind(c(%s,%s),c(%s,%s),c(%s,%s),c(%s,%s),c(%s,%s)))),", 
    grid[[i]][[1]][1,1], grid[[i]][[1]][1,2],
    grid[[i]][[1]][2,1], grid[[i]][[1]][2,2],
    grid[[i]][[1]][3,1], grid[[i]][[1]][3,2],
    grid[[i]][[1]][4,1], grid[[i]][[1]][4,2],
    grid[[i]][[1]][5,1], grid[[i]][[1]][5,2]
  ) %>% cat(sep = "\n")
}

for(i in c(10:15)){
  sprintf(
    "sf::st_polygon(list(rbind(c(%s,%s),c(%s,%s),c(%s,%s),c(%s,%s),c(%s,%s)))),", 
    grid[[i]][[1]][1,1]+0.68, grid[[i]][[1]][1,2],
    grid[[i]][[1]][2,1]+0.68, grid[[i]][[1]][2,2],
    grid[[i]][[1]][3,1]+0.68, grid[[i]][[1]][3,2],
    grid[[i]][[1]][4,1]+0.68, grid[[i]][[1]][4,2],
    grid[[i]][[1]][5,1]+0.68, grid[[i]][[1]][5,2]
  ) %>% cat(sep = "\n")
}
for(i in c(22:27)){
  sprintf(
    "sf::st_polygon(list(rbind(c(%s,%s),c(%s,%s),c(%s,%s),c(%s,%s),c(%s,%s)))),", 
    grid[[i]][[1]][1,1]-0.5, grid[[i]][[1]][1,2],
    grid[[i]][[1]][2,1]-0.5, grid[[i]][[1]][2,2],
    grid[[i]][[1]][3,1]-0.5, grid[[i]][[1]][3,2],
    grid[[i]][[1]][4,1]-0.5, grid[[i]][[1]][4,2],
    grid[[i]][[1]][5,1]-0.5, grid[[i]][[1]][5,2]
  ) %>% cat(sep = "\n")
}
for(i in c(31:32)){
  sprintf(
    "sf::st_polygon(list(rbind(c(%s,%s),c(%s,%s),c(%s,%s),c(%s,%s),c(%s,%s)))),", 
    grid[[i]][[1]][1,1]+0.35, grid[[i]][[1]][1,2],
    grid[[i]][[1]][2,1]+0.35, grid[[i]][[1]][2,2],
    grid[[i]][[1]][3,1]+0.35, grid[[i]][[1]][3,2],
    grid[[i]][[1]][4,1]+0.35, grid[[i]][[1]][4,2],
    grid[[i]][[1]][5,1]+0.35, grid[[i]][[1]][5,2]
  ) %>% cat(sep = "\n")
}
for(i in c(41:43)){
  sprintf(
    "sf::st_polygon(list(rbind(c(%s,%s),c(%s,%s),c(%s,%s),c(%s,%s),c(%s,%s)))),", 
    grid[[i]][[1]][1,1]-0.55, grid[[i]][[1]][1,2],
    grid[[i]][[1]][2,1]-0.55, grid[[i]][[1]][2,2],
    grid[[i]][[1]][3,1]-0.55, grid[[i]][[1]][3,2],
    grid[[i]][[1]][4,1]-0.55, grid[[i]][[1]][4,2],
    grid[[i]][[1]][5,1]-0.55, grid[[i]][[1]][5,2]
  ) %>% cat(sep = "\n")
}

grid_subset_small <- st_sfc(
  "lots of polygons generated by for loops above...",
  crs = st_crs(bhishp_simple)
)
plot(bhishp_simple)
plot(grid_subset_small, border = "red", add = TRUE)

polys <- "content of st_sfc function above..."
str_replace_all(polys, "\\)\\),\n  sf::st_polygon\\(list\\(rbind\\(",  "\",\n \"") %>% cat()

makedf <- vector()
for(st in 1:length(polys)){
  latlon <- str_extract_all(polys[st], "[0-9]*\\.[0-9]+")[[1]][c(2,6,1,3)] %>% 
    as.numeric() %>% 
    round(4) %>% 
    paste(collapse = ", ")
  makedf <- c(makedf, sprintf("box%s = c(%s)", st, latlon))
}
cat(makedf, sep = ", \n")

