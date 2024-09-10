library(sf)
library(tmap)
library(tmaptools)
library(OpenStreetMap)

# read data
walk_shp <- st_read("walk.shp")
stops_shp <- st_read("stops.shp")
ame_shp <- st_read("amenities.shp")

bus_stop_icon <- tmap_icons("bus-stop.png")
parking_icon <- tmap_icons("parking.png")
eating_icon <- tmap_icons("restaurant.png")
start_icon <- tmap_icons("start2.png")
end_icon <- tmap_icons("end.png")

# create subsets of points
bus_stops = subset(ame_shp, type == 1)
eating = subset(ame_shp, type==2)
parking = subset(ame_shp, type==3)

start_pt = subset(stops_shp, type==1)
end_pt = subset(stops_shp, type==4)
stops_pt = subset(stops_shp, type==3)
site_pt = subset(stops_shp, type==2)
opt_pt = subset(stops_shp, type==5)

# create bounding box manually (seems to be wrong in the shape file)
heritage_bb <- st_bbox(c(xmin = -8.4916, xmax = -8.4819, ymax = 51.901, ymin = 51.8959), crs = st_crs(4326))

# read OSM base data
osm_map <- read_osm(heritage_bb)

# render map
tm<-tm_shape(osm_map)+
    tm_rgb()+
    # display walk (line)
    tm_shape(walk_shp)+
    tm_lines(col="red", lwd=2, lty="dashed", legend.lwd.show = FALSE)+

    # display start/end
    tm_shape(start_pt) +
    tm_symbols(shape = start_icon, scale=0.7, border.lwd = 0, just=c("center","bottom"))+
    tm_shape(end_pt) +
    tm_symbols(shape = end_icon, scale=0.7, border.lwd = 0, just=c("center","bottom"))+

    # display stops
    tm_shape(stops_pt) +
    tm_dots("id", shape=21, col="red", size=1, alpha=0.6, border.col="black", border.lwd=0.2)+
    tm_text("id", size=0.6)+

    tm_shape(site_pt) +
    tm_dots("id", shape=21, col="blue", size=1, alpha=0.6, border.col="black", border.lwd=0.2)+
    tm_text("id", size=0.6)+

    tm_shape(opt_pt) +
    tm_dots("id", shape=21, col="yellow", size=1, alpha=0.6, border.col="black", border.lwd=0.2)+
    tm_text("id", size=0.6)+

    # display ameneties: bus stops
    tm_shape(bus_stops) +
    tm_symbols(shape = bus_stop_icon, scale=0.7, border.lwd = 0, just=c("center","bottom"))+
    # display ameneties: parking
    tm_shape(parking) +
    tm_symbols(shape = parking_icon, scale=0.7, border.lwd = 0, just=c("center","bottom"))+
    # display ameneties: eating
    tm_shape(eating) +
    tm_symbols(shape = eating_icon, scale=0.7, border.lwd = 0, just=c("center","bottom"))+
   
    tm_layout(legend.show=F) +
    tm_basemap(server = c(StreetMap = "OpenStreetMap",
             TopoMap = "OpenTopoMap"))
    #tm_credits("Created by Alexander von Lunen.", position=c("left","bottom"),col="black",size=0.8)+
    #tm_compass(type="4star", position=c("left","top"))+
    #tm_scale_bar(position=c("right", "top"))

## save the image ("plot" mode)
tmap_save(tm, filename = "heritage_walk.png")