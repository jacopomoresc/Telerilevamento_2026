# ISTOGRAMMI
# Gli istogrammi servono a controllare la distribuzione dei valori 
# prima di applicare soglie di classificazione.

png("output/hist_indices_2016.png", width = 2200, height = 800, res = 200)
im.multiframe(1, 3)
hist(ndwi_2016, main = "Istogramma NDWI - 2020", col = "lightblue")
hist(ndvi_2016, main = "Istogramma NDVI - 2020", col = "lightgreen")
hist(ndsi_2016, main = "Istogramma NDSI - 2020", col = "lightgrey")
dev.off()

png("output/hist_indices_2020.png", width = 2200, height = 800, res = 200)
im.multiframe(1, 3)
hist(ndwi_2020, main = "Istogramma NDWI - 2020", col = "lightblue")
hist(ndvi_2020, main = "Istogramma NDVI - 2020", col = "lightgreen")
hist(ndsi_2020, main = "Istogramma NDSI - 2020", col = "lightgrey")
dev.off()

png("output/hist_indices_2024.png", width = 2200, height = 800, res = 200)
im.multiframe(1, 3)
hist(ndwi_2024, main = "Istogramma NDWI - 2020", col = "lightblue")
hist(ndvi_2024, main = "Istogramma NDVI - 2020", col = "lightgreen")
hist(ndsi_2024, main = "Istogramma NDSI - 2020", col = "lightgrey")
dev.off()

# CLASSIFICAZIONE BINARIA
# Soglie operative
ndsi_threshold <- 0.4   # soglia da letteratura per neve/ghiaccio
ndwi_threshold <- 0.5   # filtro per escludere acqua evidente
ndvi_threshold <- 0.2   # filtro per escludere vegetazione/tundra

# Classificazione binaria:
# 1 = neve/ghiaccio
# 0 = non neve/ghiaccio

#IFEL
ice_2016 <- ifel(
  ndsi_2016 >= ndsi_threshold 
  & ndwi_2016 < ndwi_threshold & ndvi_2016 < ndvi_threshold 
  & image_2016[["B8"]] > 800
  ,
  1, 0
)

ice_2020 <- ifel(
  ndsi_2020 >= ndsi_threshold &
    ndwi_2020 < ndwi_threshold &
    ndvi_2020 < ndvi_threshold 
  & image_2020[["B8"]] > 800
  ,
  1, 0
)

ice_2024 <- ifel(
  ndsi_2024 >= ndsi_threshold &
    ndwi_2024 < ndwi_threshold &
    ndvi_2024 < ndvi_threshold & image_2024[["B8"]] > 800,
  1, 0
)

png("output/ice_mask_indices_ifel_NIR.png", width = 2150, height = 1150, res = 200)
im.multiframe(1, 3)
plot(ice_2016, main = "Ice mask - 2016", col = c("black", "white"), legend = FALSE)
plot(ice_2020, main = "Ice mask - 2020", col = c("black", "white"), legend = FALSE)
# plot(study_glaciers_2020, col="red", lwd =1.5)
plot(ice_2024, main = "Ice mask - 2024", col = c("black", "white"), legend = FALSE)
dev.off()

# CLASSIFY
# Matrice per NDSI:
# 0 = non ghiaccio/neve
# 1 = candidato ghiaccio/neve
ndsi_class_matrix <- matrix(c(
  -Inf, ndsi_threshold, 0,
  ndsi_threshold, Inf, 1
), ncol = 3, byrow = TRUE)

# Matrice per NDWI:
# 0 = non acqua
# 1 = acqua
ndwi_class_matrix <- matrix(c(
  -Inf, ndwi_threshold, 0,
  ndwi_threshold, Inf, 1
), ncol = 3, byrow = TRUE)

# Matrice per NDVI:
# 0 = non vegetazione/tundra
# 1 = vegetazione/tundra
ndvi_class_matrix <- matrix(c(
  -Inf, ndvi_threshold, 0,
  ndvi_threshold, Inf, 1
), ncol = 3, byrow = TRUE)

ice_candidate_2016 <- classify(ndsi_2016, ndsi_class_matrix)
ice_candidate_2020 <- classify(ndsi_2020, ndsi_class_matrix)
ice_candidate_2024 <- classify(ndsi_2024, ndsi_class_matrix)

water_2016 <- classify(ndwi_2016, ndwi_class_matrix)
water_2020 <- classify(ndwi_2020, ndwi_class_matrix)
water_2024 <- classify(ndwi_2024, ndwi_class_matrix)

vegetation_2016 <- classify(ndvi_2016, ndvi_class_matrix)
vegetation_2020 <- classify(ndvi_2020, ndvi_class_matrix)
vegetation_2024 <- classify(ndvi_2024, ndvi_class_matrix)

# Parto dalla classificazione NDSI
icem_2016 <- ice_candidate_2016
icem_2020 <- ice_candidate_2020
icem_2024 <- ice_candidate_2024

# Rimuovo i pixel classificati come acqua
icem_2016[water_2016 == 1] <- 0
icem_2020[water_2020 == 1] <- 0
icem_2024[water_2024 == 1] <- 0

# Rimuovo i pixel classificati come vegetazione/tundra
icem_2016[vegetation_2016 == 1] <- 0
icem_2020[vegetation_2020 == 1] <- 0
icem_2024[vegetation_2024 == 1] <- 0

png("output/ice_mask_indices_classify.png",
    width = 2150, height = 1150, res = 200)

im.multiframe(1, 3)

plot(icem_2016, main = "Ice mask - 2016",
     col = c("black", "white"), legend = FALSE)

plot(icem_2020, main = "Ice mask - 2020",
     col = c("black", "white"), legend = FALSE)

plot(icem_2024, main = "Ice mask - 2024",
     col = c("black", "white"), legend = FALSE)

dev.off()


plot(icem_2020,
     main = "Ice mask 2020 + official glacier outlines",
     col = c("black", "white"),
     legend = FALSE)

plot(study_glaciers_2020,
     add = TRUE,
     border = "red",
     lwd = 1.5)
