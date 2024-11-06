library(here)
library(udunits2)
library(tmap)
library(dplyr)
library(sf)

Coastline = read_sf(dsn=here("Map_data/"),
                    layer="Hav_norge")
Norway = read_sf(dsn=here("Map_data/"),
                 layer="Norge_N5000")
Zones = read_sf(dsn=here("Map_data/"),
                 layer=paste("Produksjon_omraader"))


map = tm_shape(Coastline) +
  #tm_dot()
  tm_fill() +
  tm_shape(Norway) +
  tm_borders(lwd=1) +
  tm_shape(Zones) +
  tm_borders(lty = 2) +
  tm_shape(Zones %>% dplyr::filter(id == 1)) +
  tm_text("id",
          ymod = -1.75,
          xmod = -1,
          size = .75,
          fontface = "bold") +
  tm_shape(Zones %>% filter(id == 2)) +
  tm_text("id",
          ymod = -0.2,
          xmod = -1.5,
          size = .75,
          fontface = "bold") +
  tm_shape(Zones %>% filter(id == 3)) +
  tm_text("id",
          ymod = -0.2,
          xmod = -1.2,
          size = .75,
          fontface = "bold") +
  tm_shape(Zones %>% filter(id == 4)) +
  tm_text("id",
          ymod = .75,
          xmod = -1.5,
          size = .75,
          fontface = "bold") +
  tm_shape(Zones %>% filter(id == 5)) +
  tm_text("id",
          ymod = .8,
          xmod = -.8,
          size = .75,
          fontface = "bold") +
  tm_shape(Zones %>% filter(id == 6)) +
  tm_text("id",
          ymod = 1,
          xmod = -.8,
          size = .75,
          fontface = "bold") +
  tm_shape(Zones %>% filter(id == 7)) +
  tm_text("id",
          ymod = .8,
          xmod = -1.2,
          size = .75,
          fontface = "bold") +
  tm_shape(Zones %>% filter(id == 8)) +
  tm_text("id",
          ymod = 0,
          xmod = -1.,
          size = .75,
          fontface = "bold") +
  tm_shape(Zones %>% filter(id == 9)) +
  tm_text("id",
          ymod = 1.,
          xmod = -.7,
          size = .75,
          fontface = "bold") +
  tm_shape(Zones %>% filter(id == 10)) +
  tm_text("id",
          ymod = 1.2,
          xmod = -.5,
          size = .75,
          fontface = "bold") +
  tm_shape(Zones %>% filter(id == 11)) +
  tm_text("id",
          ymod = 1.,
          xmod = -.7,
          size = .75,
          fontface = "bold") +
  tm_shape(Zones %>% filter(id == 12)) +
  tm_text("id",
          ymod = 1.,
          xmod = -.7,
          size = .75,
          fontface = "bold") +
  tm_shape(Zones %>% filter(id == 13)) +
  tm_text("id",
          ymod = 1.5,
          xmod = 0,
          size = .75,
          fontface = "bold") +
  tm_legend(position = c("right", "center"), text.size=1) +
  tm_compass(size=2,
             position=c("left", "top")) +
  tm_scale_bar(breaks = c(0, 100, 200, 300), text.size=.8)

map
