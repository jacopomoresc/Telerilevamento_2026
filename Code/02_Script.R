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

# importing band 4
b4 = im.import("sentinel.dolomites.b4.tif")

# importing band 8
b8 = im.import("sentinel.dolomites.b8.tif")

im.multiframe(2,2)

# Esercizio multiframe, legende allineate con la lunghezza d'onda'
clb <- colorRampPalette(c("darkblue", "blue", "lightblue"))(100)
plot(b2, col=clb)

clg <- colorRampPalette(c("darkgreen", "green", "lightgreen"))(100)
plot(b3, col=clg)

clr <- colorRampPalette(c("darkred", "red", "pink"))(100)
plot(b4, col=clr)

cln <- colorRampPalette(c("goldenrod3", "goldenrod2", "goldenrod"))(100)
plot(b8, col=cln)

sentinel = c(b2, b3, b4, b8)
plot(sentinel, col = inferno(100))

# layer1=b2, layer2=b3, layer3=b4, layer4=b8
plot(sent$sentinel.dolomites.b8)
plot(sentinel[[4]])

