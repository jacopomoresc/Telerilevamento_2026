# R code for visualizing multispectral data

library(devtools)
library(viridis)
library(terra) # package for using spatial data
library(imageRy) # package devoted to satellite images

im.list()

# Sentinel-2 bands
# https://gisgeography.com/sentinel-2-bands-combinations/

b2 = im.import("sentinel.dolomites.b2.tif")

b3 = im.import("sentinel.dolomites.b3.tif")
plot(b3, col=plasma(100))

