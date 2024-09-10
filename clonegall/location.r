library(sf)
library(mapsf)

# set a theme
mf_theme("dark")

# import to an sf object
ire <- read_sf("counties.shp")

# load points
stations  <- read.csv("places.csv", header = TRUE, stringsAsFactors = FALSE)
stations1 <- st_as_sf(stations, coords = c('Long', 'Lat'), crs=4326)

# Selection of a target to display in the inset
ire_target <- ire[c(30), ]

# settings for export
mf_export(
  x = ire,
  filename = "clonegal.png",
  width = 1600,
  res = 300,
  expandBB = c(0.05, 0, 0, 0.3)
)

# Display the base map
mf_map(ire, expandBB = c(0, 0, 0, .35))

# display the target on the main map
mf_map(ire_target, add = TRUE, col = "tomato")
mf_label(x = ire[c(30),], var="ALT_NAME", cex=0.5, halo=TRUE, bg="white", col="grey10")

# open the inset
mf_inset_on(x = ire_target, pos = "bottomright", cex = .3)

# center on on the target
mf_map(ire_target, col = NA, border = NA)

# display all
mf_map(ire, add = TRUE)

# display the target shadow
mf_shadow(ire_target, add = TRUE)

# display the target
mf_map(ire_target, add = TRUE, col = "tomato")

# display points
mf_map(stations1, type="base", add=TRUE, col="blue", cex=0.9)
mf_label(stations1, var="Place", col="grey10", halo=TRUE, bg="white", pos=1)

# dispaly a frame around the inset
box()

# close the inset
mf_inset_off()

# display the map layout of the main map
#mf_title("Area of Interest")

# display credits
mf_credits(txt = "Created by Alexander von Lünen.")

# North arrow
mf_arrow("topright")

dev.off()