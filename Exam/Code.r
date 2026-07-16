# Monitoraggio multitemporale della copertura nevosa alle Svalbard (2016-2020-2024)
# PROGETTO D'ESAME - Telerilevamento Geo-Ecologico in R
# Jacopo Moresco

# Immagini Sentinel-2 di fine estate (late summer), quando la componente nevosa
# stagionale è ridotta e il segnale è più rappresentativo. 
# Indici usati: NDSI (copertura nevosa), NDWI (acqua), NDVI (vegetazione/tundra).
# La copertura nevosa viene classificata con NDSI da solo e in combinazione con NDWI, NIR
# e NDVI, per ridurre le confusioni tipiche (acqua, ombre, vegetazione), validando
# il risultato sul 2020 contro gli outlines ufficiali del Norwegian Polar Institute.

# ============================================================================================

# Imposto la working directory
setwd("C:/Users/Jacopo/OneDrive/Università/Magistrale/Telerilevamento_Rocchini/Exam")

# Caricamento pacchetti
library(terra)      # Gestione raster e vettori spaziali
library(imageRy)    # Visualizzazione immagini telerilevate
library(viridis)    # Palette cromatiche per mappe
library(ggplot2)    # Grafici finali
library(patchwork)  # Affiancamento grafici
library(ggridges)   # Distribuzioni degli indici
library(reshape2)   # Riorganizzazione tabelle per ggplot

# ------------------------------------------------------------
# IMPORTAZIONE IMMAGINI
# ------------------------------------------------------------

image_2016 <- rast("data_raw/svalbard_glaciers_2016_late_summer.tif")
image_2016          # visualizzo le specifiche del raster
plot(image_2016)    # visualizzo l'immagine
dev.off()           # chiudo il pannello grafico

image_2020 <- rast("data_raw/svalbard_glaciers_2020_late_summer.tif")
image_2020
plot(image_2020)
dev.off()      

image_2024 <- rast("data_raw/svalbard_glaciers_2024_late_summer.tif")
image_2024
plot(image_2024)
dev.off()      

# Bande Sentinel-2 usate: B2 = Blue, B3 = Green, B4 = Red, B8 = NIR, B11 = SWIR1

# ------------------------------------------------------------
# IMPORTAZIONE SHAPEFILE
# ------------------------------------------------------------
# Cerco tutti i file .shp nella cartella Shapefile_2020
shapefiles_2020 <- list.files(path = "data_raw/Shapefile_2020",
                              pattern = "\\.shp$", full.names = TRUE)

# Importo gli outlines del 2020
glacier_outlines_2020 <- vect(shapefiles_2020[1]) 
glacier_outlines_2020        # Visualizzo le informazioni del vettore

# Confronto il sistema di riferimento (crs) e l'estensione del raster 2020 e dello shapefile
crs(image_2020) == crs(glacier_outlines_2020)

# C'è una discrepanza, quindi riproietto gli outlines nel CRS del raster del 2020
glacier_outlines_2020_proj <- project(glacier_outlines_2020, crs(image_2020))

# Ritaglio gli outlines sull'area di studio
study_glaciers_2020 <- crop(glacier_outlines_2020_proj, image_2020)

# Salvo gli outlines ritagliati come GeoPackage
writeVector(study_glaciers_2020, "data_processed/study_glaciers_2020.gpkg", overwrite = TRUE)

# ============================================================
# VISUALIZZAZIONE IMMAGINI E BANDE
# ============================================================

# VISUALIZZAZIONE IMMAGINE RGB
png("output/rgb_multitemporal_glaciers.png", width = 2150, height = 1150, res = 200)
im.multiframe(1,3)
plotRGB(image_2016, r = 3, g = 2, b = 1, stretch = "lin", main = "2016", cex.main = 1.8)
plotRGB(image_2020, r = 3, g = 2, b = 1, stretch = "lin", main = "2020", cex.main = 1.8)
plotRGB(image_2024, r = 3, g = 2, b = 1, stretch = "lin", main = "2024", cex.main = 1.8)
dev.off()

# LE CINQUE BANDE DEL 2016
png("output/bands_2016.png", width = 2200, height = 1400, res = 200)
im.multiframe(2,3)
plot(image_2016[["B2"]],  main = "B2 - Blue",  cex.main = 1.8, col = viridis(100))
plot(image_2016[["B3"]],  main = "B3 - Green", cex.main = 1.8, col = viridis(100))
plot(image_2016[["B4"]],  main = "B4 - Red",   cex.main = 1.8, col = viridis(100))
plot(image_2016[["B8"]],  main = "B8 - NIR",   cex.main = 1.8, col = viridis(100))
plot(image_2016[["B11"]], main = "B11 - SWIR1", cex.main = 1.8, col = viridis(100))
dev.off()

# LE CINQUE BANDE DEL 2020
png("output/bands_2020.png", width = 2200, height = 1400, res = 200)
im.multiframe(2,3)
plot(image_2020[["B2"]],  main = "B2 - Blue", cex.main = 1.8, col = viridis(100))
plot(image_2020[["B3"]],  main = "B3 - Green", cex.main = 1.8, col = viridis(100))
plot(image_2020[["B4"]],  main = "B4 - Red", cex.main = 1.8, col = viridis(100))
plot(image_2020[["B8"]],  main = "B8 - NIR", cex.main = 1.8, col = viridis(100))
plot(image_2020[["B11"]], main = "B11 - SWIR1", cex.main = 1.8, col = viridis(100))
dev.off()

# LE CINQUE BANDE DEL 2024
png("output/bands_2024.png", width = 2200, height = 1400, res = 200)
im.multiframe(2,3)
plot(image_2024[["B2"]],  main = "B2 - Blue", cex.main = 1.8, col = viridis(100))
plot(image_2024[["B3"]],  main = "B3 - Green", cex.main = 1.8, col = viridis(100))
plot(image_2024[["B4"]],  main = "B4 - Red", cex.main = 1.8, col = viridis(100))
plot(image_2024[["B8"]],  main = "B8 - NIR", cex.main = 1.8, col = viridis(100))
plot(image_2024[["B11"]], main = "B11 - SWIR1", cex.main = 1.8, col = viridis(100))
dev.off()

# BANDE DEL VISIBILE: CONFRONTO DEI TRE ANNI
png("output/visible_bands.png", width = 2600, height = 2200, res = 200)
im.multiframe(3, 3)
plot(image_2016[["B2"]], main = "B2 - Blue (2016)", cex.main = 1.8, col = viridis(100))
plot(image_2016[["B3"]], main = "B3 - Green (2016)", cex.main = 1.8, col = viridis(100))
plot(image_2016[["B4"]], main = "B4 - Red (2016)", cex.main = 1.8, col = viridis(100))
plot(image_2020[["B2"]], main = "B2 - Blue (2020)", cex.main = 1.8, col = viridis(100))
plot(image_2020[["B3"]], main = "B3 - Green (2020)", cex.main = 1.8, col = viridis(100))
plot(image_2020[["B4"]], main = "B4 - Red (2020)", cex.main = 1.8, col = viridis(100))
plot(image_2024[["B2"]], main = "B2 - Blue (2024)", cex.main = 1.8, col = viridis(100))
plot(image_2024[["B3"]], main = "B3 - Green (2024)", cex.main = 1.8, col = viridis(100))
plot(image_2024[["B4"]], main = "B4 - Red (2024)", cex.main = 1.8, col = viridis(100))
dev.off()

# BANDE NIR E SWIR: CONFRONTO DEI TRE ANNI
png("output/nir_swir_bands.png", width = 1600, height = 2200, res = 200)
im.multiframe(3, 2)
plot(image_2016[["B8"]],  main = "B8 - NIR (2016)", cex.main = 1.8, col = viridis(100))
plot(image_2016[["B11"]], main = "B11 - SWIR1 (2016)", cex.main = 1.8, col = viridis(100))
plot(image_2020[["B8"]],  main = "B8 - NIR (2020)",   cex.main = 1.8, col = viridis(100))
plot(image_2020[["B11"]], main = "B11 - SWIR1 (2020)", cex.main = 1.8, col = viridis(100))
plot(image_2024[["B8"]],  main = "B8 - NIR (2024)",   cex.main = 1.8, col = viridis(100))
plot(image_2024[["B11"]], main = "B11 - SWIR1 (2024)", cex.main = 1.8, col = viridis(100))
dev.off()

# ============================================================
# INDICI
# ============================================================

# NDSI (Normalized Difference Snow Index) = (Green - SWIR1) / (Green + SWIR1)
# È l'indice standard per evidenziare le superfici innevate
ndsi_2016 <- (image_2016[["B3"]] - image_2016[["B11"]]) / 
  (image_2016[["B3"]] + image_2016[["B11"]])
ndsi_2020 <- (image_2020[["B3"]] - image_2020[["B11"]]) / 
  (image_2020[["B3"]] + image_2020[["B11"]])
ndsi_2024 <- (image_2024[["B3"]] - image_2024[["B11"]]) / 
  (image_2024[["B3"]] + image_2024[["B11"]])
dndsi <- ndsi_2024 - ndsi_2016

png("output/ndsi_multitemporal.png", width = 2150, height = 2150, res = 200)
im.multiframe(2, 2)
plot(ndsi_2016, main = "NDSI - 2016", col = viridis(100))
plot(ndsi_2020, main = "NDSI - 2020", col = viridis(100))
plot(ndsi_2024, main = "NDSI - 2024", col = viridis(100))
plot(dndsi, main = "ΔNDSI", col = viridis(100))
dev.off()

# NDWI (Normalized Difference Water Index) = (Green - NIR) / (Green + NIR)
# Evidenzia acqua marina, laghi proglaciali e superfici umide
ndwi_2016 <- (image_2016[["B3"]] - image_2016[["B8"]]) / 
  (image_2016[["B3"]] + image_2016[["B8"]])
ndwi_2020 <- (image_2020[["B3"]] - image_2020[["B8"]]) / 
  (image_2020[["B3"]] + image_2020[["B8"]])
ndwi_2024 <- (image_2024[["B3"]] - image_2024[["B8"]]) / 
  (image_2024[["B3"]] + image_2024[["B8"]])
dndwi<- ndwi_2024 - ndwi_2016

png("output/ndwi_multitemporal.png", width = 2150, height = 2150, res = 200)
im.multiframe(2, 2)
plot(ndwi_2016, main = "NDWI - 2016", col = viridis(100))
plot(ndwi_2020, main = "NDWI - 2020", col = viridis(100))
plot(ndwi_2024, main = "NDWI - 2024", col = viridis(100))
plot(dndwi, main = "ΔNDWI", col = viridis(100))
dev.off()

# NDVI (Normalized Difference Vegetation Index) = (NIR - Red) / (NIR + Red)
# Serve a individuare eventuale vegetazione/tundra
ndvi_2016 <- im.ndvi(image_2016, nir = 4, red = 3)
ndvi_2020 <- im.ndvi(image_2020, nir = 4, red = 3)
ndvi_2024 <- im.ndvi(image_2024, nir = 4, red = 3)
dndvi <- ndvi_2024 - ndvi_2016

png("output/ndvi_multitemporal.png", width = 2150, height = 2150, res = 200)
im.multiframe(2, 2)
plot(ndvi_2016, main = "NDVI - 2016", col = viridis(100))
plot(ndvi_2020, main = "NDVI - 2020", col = viridis(100))
plot(ndvi_2024, main = "NDVI - 2024", col = viridis(100))
plot(dndvi, main = "ΔNDVI 2024 - 2016", col = viridis(100))
dev.off()

# Confronto delle tre differenze (delta = anno finale - anno iniziale)
png("output/index_differences_2024_2016.png", width = 2100, height = 800, res = 200)
im.multiframe(1, 3)
plot(dndsi, col = viridis(100), main = "ΔNDSI 2024 - 2016")
plot(dndwi, col = viridis(100), main = "ΔNDWI 2024 - 2016")
plot(dndvi, col = viridis(100), main = "ΔNDVI 2024 - 2016")
dev.off()

# ============================================================
# CLASSIFICAZIONE BINARIA DELLA COPERTURA NEVOSA - ANNO 2020
# ============================================================
# La classificazione viene valutata sul 2020 perché per questo anno
# sono disponibili gli outlines glaciali ufficiali del Norwegian Polar Institute.

# Codifica delle matrici di confusione spaziali:
# 0 = TN: pixel classificato correttamente come NON NEVE
# 1 = FP: pixel classificato come NEVE, ma esterno agli outlines (falso positivo)
# 2 = FN: pixel classificato come NON NEVE, ma interno agli outlines (falso negativo)
# 3 = TP: pixel classificato correttamente come NEVE e interno agli outlines

# ------------------------------------------
# 1. CLASSIFICAZIONE NDSI 
# ------------------------------------------
png("output/hist_ndsi_2020.png", width = 1500, height = 1300, res = 200)
hist(ndsi_2020, breaks = 100, main = "Distribuzione NDSI - 2020")
dev.off() 

# Soglia consigliata in letteratura e verificata sperimentalmente tramite confronto 
# con gli outlines ufficiali e con il calcolo delle metriche
soglia_ndsi <- 0.4 
                   

# Matrice di riclassificazione: NDSI < 0.4 = 0, NON NEVE; NDSI >= 0.4 = 1, NEVE
ndsi_matrix <- matrix(c(-Inf, soglia_ndsi, 0, soglia_ndsi, Inf, 1), 
                      ncol = 3, byrow = TRUE)

# Applicazione della classificazione ai tre anni
snow_2016_ndsi <- classify(ndsi_2016, ndsi_matrix)
snow_2020_ndsi <- classify(ndsi_2020, ndsi_matrix)
snow_2024_ndsi <- classify(ndsi_2024, ndsi_matrix)

# Rasterizzazione degli outlines ufficiali sulla griglia del raster classificato
# 1 = area interna agli outlines glaciali; 0 = area esterna agli outlines
reference_snow <- rasterize(study_glaciers_2020, snow_2020_ndsi, field = 1, background = 0)

# -----------------------------------------------------
# FUNZIONI DI VISUALIZZAZIONE E MATRICE DI CONFUSIONE
# -----------------------------------------------------

# 1. Funzione unica per plottare e salvare le classificazioni dei tre anni
# ============================================================
# FUNZIONE PER VISUALIZZARE LE CLASSIFICAZIONI DEI TRE ANNI
# ============================================================

plot_snow_classified <- function(raster_2016, raster_2020, raster_2024, method, output_file) {
  
  # raster_2016   raster classificato relativo al 2016
  # raster_2020   raster classificato relativo al 2020
  # raster_2024   raster classificato relativo al 2024
  # method        nome del metodo di classificazione usato nei titoli
  # output_file   percorso e nome del file PNG finale
  
  rasters <- c(raster_2016, raster_2020, raster_2024)                   # Unisce i tre raster in un oggetto multilayer
  years <- c(2016, 2020, 2024)                                         # Associa gli anni ai tre raster
  
  png(output_file, width = 2100, height = 800, res = 200)               # Apre il dispositivo grafico PNG
  im.multiframe(1, 3)                                                   # Imposta una griglia con una riga e tre colonne
  
  for (i in 1:3) {                                                      # Ripete il grafico per ciascun anno
    
    plot(rasters[[i]],                                                  # Seleziona il raster corrispondente all'anno
         col = c("black", "lightcyan"),                                 # Assegna i colori alle due classi
         type = "classes",                                              # Tratta i valori come classi discrete
         legend = FALSE,                                                # Disattiva la legenda automatica
         main = paste("Classificazione", method, "-", years[i]))        # Crea il titolo con metodo e anno
    
    legend("bottomleft",                                                # Posiziona la legenda in basso a sinistra
           inset = c(0.12, 0.02),                                       # Sposta leggermente la legenda
           xpd = NA,                                                    # Permette di disegnare fuori dall'area del grafico
           legend = c("Neve", "Non neve"),                              # Etichette delle classi
           fill = c("lightcyan", "black"),                              # Colori associati alle classi
           border = "black",                                            # Bordo dei simboli della legenda
           cex = 0.8,                                                   # Dimensione del testo
           bg = "white",                                                # Sfondo bianco
           bty = "o")                                                   # Disegna il bordo della legenda
  }
  
  dev.off()                                                             # Chiude il dispositivo grafico e salva il file PNG
}


# 2. Funzione per confrontare la classificazione 2020 con gli outlines ufficiali
plot_snow_outlines <- function(raster, method, output_file) {
  
  # raster        raster classificato relativo al 2020
  # method        nome del metodo di classificazione usato nel titolo
  # output_file   percorso e nome del file PNG finale
  
  png(output_file, width = 1200, height = 1300, res = 200)               # Apre il dispositivo grafico PNG
  
  plot(raster,                                                           # Visualizza il raster classificato
       col = c("black", "lightcyan"),                                    # Colori delle classi non neve e neve
       type = "classes",                                                 # Interpreta il raster come classificazione
       legend = FALSE,                                                   # Disattiva la legenda automatica
       main = paste("Classificazione", method, "e outlines - 2020"))     # Crea il titolo
  
  plot(study_glaciers_2020,                                              # Aggiunge gli outlines ufficiali
       add = TRUE,                                                       # Sovrappone il vettore al raster
       border = "red",                                                   # Colore del bordo
       lwd = 2)                                                          # Spessore della linea
  
  legend("bottomleft",                                                   # Posiziona la legenda
         inset = c(0.13, 0.02),                                          # Regola la posizione
         xpd = NA,                                                       # Permette di uscire dall'area del grafico
         legend = c("Neve", "Non neve", "Outlines glaciali NPI"),       # Etichette
         fill = c("lightcyan", "black", NA),                             # Riempimenti delle classi
         border = c("black", "black", "red"),                            # Bordi associati
         cex = 0.8,                                                      # Dimensione del testo
         bg = "white",                                                   # Sfondo della legenda
         bty = "o")                                                      # Bordo della legenda
  
  dev.off()                                                              # Chiude il dispositivo grafico e salva il file PNG
}

# 3. Funzione per calcolare, visualizzare e salvare la matrice di confusione
# ==================================================================
# FUNZIONE PER CALCOLARE E VISUALIZZARE LA MATRICE DI CONFUSIONE
# ==================================================================

calculate_confusion_matrix <- function(classified_raster, method, output_file) {
  
  # classified_raster   raster binario da confrontare con gli outlines ufficiali
  # method              nome del metodo riportato nel titolo e nelle tabelle
  # output_file         percorso e nome del file PNG finale
  
  comparison <- classified_raster + 2 * reference_snow                          # Combina classificazione e riferimento in quattro classi
  cm <- freq(comparison)                                                        # Conta i pixel appartenenti a TN, FP, FN e TP
  
  counts <- setNames(rep(0, 4), 0:3)                                            # Crea un vettore completo delle quattro classi
  counts[as.character(cm$value)] <- cm$count                                    # Inserisce i conteggi osservati
  
  TN <- counts["0"]                                                             # Pixel classificati come non neve ed esterni agli outlines
  FP <- counts["1"]                                                             # Pixel classificati come neve ma esterni agli outlines
  FN <- counts["2"]                                                             # Pixel interni agli outlines non riconosciuti come neve
  TP <- counts["3"]                                                             # Pixel classificati come neve e interni agli outlines
  
  accuracy <- (TP + TN) / (TP + TN + FP + FN) * 100                             # Percentuale totale di pixel classificati correttamente
  recall <- TP / (TP + FN) * 100                                                # Percentuale dei pixel interni agli outlines riconosciuti come neve
  precision <- TP / (TP + FP) * 100                                             # Percentuale dei pixel classificati come neve che ricadono negli outlines
  
  confusion_table <- data.frame(                                                # Crea la tabella della matrice di confusionee
    Classificazione = c("NEVE", "NON NEVE"),
    Reference_SNOW = c(TP, FN),
    Reference_NOT_SNOW = c(FP, TN)
  )
  
  metrics_table <- data.frame(                                                  # Crea la tabella delle metriche finali
    Metodo = method,
    TN = as.numeric(TN),
    FP = as.numeric(FP),
    FN = as.numeric(FN),
    TP = as.numeric(TP),
    Accuracy = round(as.numeric(accuracy), 2),
    Recall = round(as.numeric(recall), 2),
    Precision = round(as.numeric(precision), 2)
  )
  
  png(output_file, width = 1200, height = 1300, res = 200)                      # Apre il dispositivo grafico PNG
  
  plot(comparison,                                                              # Visualizza la distribuzione spaziale degli errori
       col = c("grey80", "orange", "red", "darkgreen"),                         # Colori di TN, FP, FN e TP
       main = paste("Distribuzione spaziale della classificazione -", method),
       type = "classes",                                                        # Tratta i valori come classi discrete
       legend = FALSE)                                                          # Disattiva la legenda automatica
  
  legend("bottomleft",                                                          # Aggiunge la legenda
         inset = c(0.13, 0.02),
         xpd = NA,
         legend = c("TN - True Negative", "FP - False Positive",
                    "FN - False Negative", "TP - True Positive"),
         fill = c("grey80", "orange", "red", "darkgreen"),
         cex = 0.8,
         bg = "white",
         bty = "o")
  
  dev.off()                                                                     # Chiude il dispositivo grafico e salva il file PNG
      
  print(confusion_table)                                                        # Stampa la matrice di confusionee
  print(metrics_table)                                                          # Stampa accuracy, recall e precision
  
  return(list(                                                                  # Restituisce gli oggetti prodotti
    comparison = comparison,
    frequencies = cm,
    confusion_table = confusion_table,
    metrics = metrics_table
  ))
}

# Visualizzazione della classificazione NDSI nei tre anni 
plot_snow_classified(snow_2016_ndsi, snow_2020_ndsi, snow_2024_ndsi,
                     "NDSI", "output/snow_classification_ndsi.png")

# Visualizzazione del confronto classificazione NDSI con gli outlines
plot_snow_outlines(snow_2020_ndsi,"NDSI", "output/ndsi_snow_mask_2020.png")

# Risultati della matrice di confusionee 
results_ndsi <- calculate_confusion_matrix(classified_raster = snow_2020_ndsi, 
                                           method = "NDSI", output_file = "output/confusion_matrix_ndsi.png")

# ------------------------------------------
# 2. CLASSIFICAZIONE NDSI + NDWI
# ------------------------------------------
png("output/hist_ndwi_2020.png", width = 1500, height = 1300, res = 200)
hist(ndwi_2020, breaks = 100, main = "Distribuzione NDWI - 2020")
dev.off() 

# Soglia NDWI i pixel con NDWI >= 0.7 vengono considerati acqua
soglia_ndwi <- 0.7 # soglia sperimentale verificata con outlines e metriche

# Crea una maschera binaria: NDWI < 0.7 = 1, NON ACQUA; NDWI >= 0.7 = 0, ACQUA
ndwi_matrix <- matrix(c(-Inf, soglia_ndwi, 1, soglia_ndwi, Inf, 0), ncol = 3, byrow = TRUE)

# Creazione delle maschere non-acqua per i tre anni
not_water_2016 <- classify(ndwi_2016, ndwi_matrix)
not_water_2020 <- classify(ndwi_2020, ndwi_matrix)
not_water_2024 <- classify(ndwi_2024, ndwi_matrix)

# Mantiene solo i pixel classificati come neve e, contemporaneamente, come non acqua
# NDSI >= 0.4 AND NDWI < 0.7
snow_2016_ndsi_ndwi <- snow_2016_ndsi * not_water_2016
snow_2020_ndsi_ndwi <- snow_2020_ndsi * not_water_2020
snow_2024_ndsi_ndwi <- snow_2024_ndsi * not_water_2024

# Visualizzazione della classificazione NDSI + NDWI nei tre anni
plot_snow_classified(snow_2016_ndsi_ndwi, snow_2020_ndsi_ndwi, snow_2024_ndsi_ndwi,
                     "NDSI + NDWI", "output/snow_classification_ndsi_ndwi.png")

# Confronto della classificazione NDSI + NDWI con gli outlines
plot_snow_outlines(snow_2020_ndsi_ndwi, "NDSI + NDWI", "output/ndsi_ndwi_snow_mask_2020.png")

# Risultati della matrice di confusionee 
results_ndsi_ndwi <- calculate_confusion_matrix(classified_raster = snow_2020_ndsi_ndwi,
                                                method = "NDSI + NDWI", output_file = "output/confusion_matrix_ndsi_ndwi.png")

# ------------------------------------------
# 3. CLASSIFICAZIONE NDSI + NIR
# ------------------------------------------
png("output/hist_B8_2020.png", width = 1500, height = 1300, res = 200)
hist(image_2020[["B8"]], breaks = 100, main = "Distribuzione B8 - 2020")
dev.off()

# Soglia NIR per escludere i pixel con riflettanza troppo bassa
soglia_nir <- 400 # soglia sperimentale verificata con outlines e metriche

# Matrice di riclassificazione: # NIR < 400 = 0; # NIR >= 400 = 1
nir_matrix <- matrix(c(-Inf, soglia_nir, 0, soglia_nir, Inf, 1), ncol = 3, byrow = TRUE)

# Creazione delle maschere NIR per i tre anni
nir_mask_2016 <- classify(image_2016[["B8"]], nir_matrix)
nir_mask_2020 <- classify(image_2020[["B8"]], nir_matrix)
nir_mask_2024 <- classify(image_2024[["B8"]], nir_matrix)

# Combinazione delle due condizioni:
# neve = NDSI >= 0.4 AND NIR >= 400
snow_2016_ndsi_nir <- snow_2016_ndsi * nir_mask_2016
snow_2020_ndsi_nir <- snow_2020_ndsi * nir_mask_2020
snow_2024_ndsi_nir <- snow_2024_ndsi * nir_mask_2024

# Visualizzazione della classificazione NDSI + filtro NIR nei tre anni
plot_snow_classified(snow_2016_ndsi_nir, snow_2020_ndsi_nir, snow_2024_ndsi_nir,
                     "NDSI + NIR", "output/snow_classification_ndsi_nir.png")

# Confronto della classificazione NDSI + filtro NIR con gli outlines
plot_snow_outlines(snow_2020_ndsi_nir, "NDSI + NIR", "output/ndsi_nir_snow_mask_2020.png")

# Risultati della matrice di confusionee 
results_ndsi_nir <- calculate_confusion_matrix(classified_raster = snow_2020_ndsi_nir,
                                               method = "NDSI + NIR", output_file = "output/confusion_matrix_ndsi_nir.png")

# ------------------------------------------
# 4. CLASSIFICAZIONE NDSI + NDVI
# ------------------------------------------
png("output/hist_ndvi_2020.png", width = 1500, height = 1300, res = 200)
hist(ndvi_2020, breaks = 100, main = "Distribuzione NDVI - 2020")
dev.off() 

# Soglia NDVI per distinguere vegetazione e non vegetazione
soglia_ndvi <- 0.3

# Matrice di riclassificazione:
# NDVI < 0.3 = 1, NON VEGETAZIONE
# NDVI >= 0.3 = 0, VEGETAZIONE
ndvi_matrix <- matrix(c(-Inf, soglia_ndvi, 1, soglia_ndvi, Inf, 0), ncol = 3, byrow = TRUE)

# Creazione delle maschere di non vegetazione per i tre anni
not_vegetation_2016 <- classify(ndvi_2016, ndvi_matrix)
not_vegetation_2020 <- classify(ndvi_2020, ndvi_matrix)
not_vegetation_2024 <- classify(ndvi_2024, ndvi_matrix)

# Combinazione delle due condizioni:
# neve = NDSI >= 0.4 AND NDVI < 0.3
snow_2016_ndsi_ndvi <- snow_2016_ndsi * not_vegetation_2016
snow_2020_ndsi_ndvi <- snow_2020_ndsi * not_vegetation_2020
snow_2024_ndsi_ndvi <- snow_2024_ndsi * not_vegetation_2024

# Visualizzazione della classificazione NDSI + NDVI nei tre anni
plot_snow_classified(snow_2016_ndsi_ndvi, snow_2020_ndsi_ndvi, snow_2024_ndsi_ndvi,
                     "NDSI + NDVI", "output/snow_classification_ndsi_ndvi.png")

# Confronto della classificazione NDSI + NDVI con gli outlines
plot_snow_outlines(snow_2020_ndsi_ndvi, "NDSI + NDVI", "output/ndsi_ndvi_snow_mask_2020.png")

# Risultati della matrice di confusionee 
results_ndsi_ndvi <- calculate_confusion_matrix(classified_raster = snow_2020_ndsi_ndvi,
                                                method = "NDSI + NDVI", output_file = "output/confusion_matrix_ndsi_ndvi.png")

# ------------------------------------------------------------
# CONFRONTO VISIVO DEI TRE METODI DI CLASSIFICAZIONE - 2020
# ------------------------------------------------------------
classification_summary <- rbind(results_ndsi$metrics, results_ndsi_ndwi$metrics, results_ndsi_nir$metrics)
print(classification_summary) 

# Confronto visivo dei metodi di classificazione
png("output/comparison_classification_methods_2020.png", width = 2100, height = 800, res = 200)
im.multiframe(1, 3)

# Classificazione NDSI
plot(snow_2020_ndsi, col = c("black", "lightcyan"), type = "classes", legend = FALSE, main = "NDSI")
plot(study_glaciers_2020, add = TRUE, border = "red", lwd = 1.5)

legend("bottomleft", inset = c(0.10, 0.02), xpd = NA,
       legend = c("Neve", "Non neve", "Outlines glaciali NPI"),
       fill = c("lightcyan", "black", NA),
       border = c("black", "black", "red"),
       cex = 0.8, bg = "white", bty = "o")

# Classificazione NDSI + NDWI
plot(snow_2020_ndsi_ndwi, col = c("black", "lightcyan"), type = "classes", legend = FALSE, main = "NDSI + NDWI")
plot(study_glaciers_2020, add = TRUE, border = "red", lwd = 1.5)

legend("bottomleft", inset = c(0.10, 0.02), xpd = NA,
       legend = c("Neve", "Non neve", "Outlines glaciali NPI"),
       fill = c("lightcyan", "black", NA),
       border = c("black", "black", "red"),
       cex = 0.8, bg = "white", bty = "o")

# Classificazione NDSI + NIR
plot(snow_2020_ndsi_nir, col = c("black", "lightcyan"), type = "classes", legend = FALSE, main = "NDSI + NIR")
plot(study_glaciers_2020, add = TRUE, border = "red", lwd = 1.5)

legend("bottomleft", inset = c(0.10, 0.02), xpd = NA,
       legend = c("Neve", "Non neve", "Outlines glaciali NPI"),
       fill = c("lightcyan", "black", NA),
       border = c("black", "black", "red"),
       cex = 0.8, bg = "white", bty = "o")

dev.off()

# Confronto della distribuzione spaziale delle matrici di confusione del 2020
png("output/confusion_matrix_methods_2020.png", width = 2100, height = 800, res = 200)
im.multiframe(1, 3)

# Classificazione NDSI 
plot(results_ndsi$comparison, col = c("grey80", "orange", "red", "darkgreen"),
     type = "classes", legend = FALSE, main = "NDSI")

legend("bottomleft", inset = c(0.13, 0.02), xpd = NA,
       legend = c("TN - True Negative", "FP - False Positive", "FN - False Negative", "TP - True Positive"),
       fill = c("grey80", "orange", "red", "darkgreen"), border = "black", cex = 0.8, bg = "white", bty = "o")

# Classificazione NDSI + NDWI
plot(results_ndsi_ndwi$comparison, col = c("grey80", "orange", "red", "darkgreen"),
     type = "classes", legend = FALSE, main = "NDSI + NDWI")

legend("bottomleft", inset = c(0.13, 0.02), xpd = NA,
       legend = c("TN - True Negative", "FP - False Positive", "FN - False Negative", "TP - True Positive"),
       fill = c("grey80", "orange", "red", "darkgreen"), border = "black", cex = 0.8, bg = "white", bty = "o")

# Classificazione NDSI + NIR
plot(results_ndsi_nir$comparison, col = c("grey80", "orange", "red", "darkgreen"),
     type = "classes", legend = FALSE, main = "NDSI + NIR")

legend("bottomleft", inset = c(0.13, 0.02), xpd = NA,
       legend = c("TN - True Negative", "FP - False Positive", "FN - False Negative", "TP - True Positive"),
       fill = c("grey80", "orange", "red", "darkgreen"), border = "black", cex = 0.8, bg = "white", bty = "o")

dev.off()

# ============================================================
# ANALISI MULTITEMPORALE DELLA COPERTURA NEVOSA
# ============================================================
# Per l'analisi multitemporale viene utilizzato NDSI + NDWI, scelto come miglior compromesso tra recall e precision.

# ------------------------------------------
# CALCOLO PERCENTUALI NELL'AREA DI STUDIO
# ------------------------------------------

# Frequenze delle classi: 0 = assenza di neve; 1 = presenza di neve
freq_2016 <- freq(snow_2016_ndsi_ndwi)
freq_2020 <- freq(snow_2020_ndsi_ndwi)
freq_2024 <- freq(snow_2024_ndsi_ndwi)

# Percentuale di ogni classe rispetto al numero totale di celle
perc_2016 <- freq_2016$count * 100 / ncell(snow_2016_ndsi_ndwi)
perc_2020 <- freq_2020$count * 100 / ncell(snow_2020_ndsi_ndwi)
perc_2024 <- freq_2024$count * 100 / ncell(snow_2024_ndsi_ndwi)

# Tabella riassuntiva
snow_table <- data.frame(
  Classi = c("Non neve", "Neve"),
  a2016 = round(perc_2016, 2), a2020 = round(perc_2020, 2), a2024 = round(perc_2024, 2)
)
print(snow_table)

# ------------------------------------------
# CALCOLO PERCENTUALI DENTRO GLI OUTLINES
# ------------------------------------------
# Mantiene solamente i pixel compresi all'interno degli outlines ufficiali del 2020
snow_2016_inside <- mask(snow_2016_ndsi_ndwi, reference_snow, maskvalues = 0)
snow_2020_inside <- mask(snow_2020_ndsi_ndwi, reference_snow, maskvalues = 0)
snow_2024_inside <- mask(snow_2024_ndsi_ndwi, reference_snow, maskvalues = 0)

# Frequenze delle classi all'interno degli outlines
freq_inside_2016 <- freq(snow_2016_inside)
freq_inside_2020 <- freq(snow_2020_inside)
freq_inside_2024 <- freq(snow_2024_inside)

# Percentuali calcolate rispetto ai soli pixel validi interni agli outlines
perc_inside_2016 <- freq_inside_2016$count * 100 / sum(freq_inside_2016$count)
perc_inside_2020 <- freq_inside_2020$count * 100 / sum(freq_inside_2020$count)
perc_inside_2024 <- freq_inside_2024$count * 100 / sum(freq_inside_2024$count)

# Tabella riassuntiva
snow_inside_table <- data.frame(
  Classi = c("Non neve", "Neve"),
  a2016 = round(perc_inside_2016, 2), a2020 = round(perc_inside_2020, 2), a2024 = round(perc_inside_2024, 2)
)
print(snow_inside_table)

# ------------------------------------------
# GRAFICI 
# ------------------------------------------

plot_snow_percentages <- function(table, title, output_file) {
  # table         tabella con Classi, a2016, a2020 e a2024
  # title         parte comune del titolo dei tre grafici
  # output_file   percorso e nome del PNG finale
  
  # Grafico delle percentuali per il 2016
  p1 <- ggplot(table, aes(x = Classi, y = a2016, fill = Classi)) +      # Crea il grafico assegnando X, Y e colore
    geom_col() +                                                        # Crea le barre usando direttamente i valori percentuali
    geom_text(aes(label = paste0(a2016, "%")), vjust = -0.3) +          # Aggiunge i valori percentuali sopra le barre
    scale_fill_viridis_d() +                                            # Applica la palette di colori 'viridis'
    ylim(0, 100) +                                                      # Limita l'asse Y tra 0 e 100%
    labs(title = paste(title, "- 2016"),                                # Imposta titolo ed etichette degli assi
         y = "Percentuale (%)", x = NULL) +
    theme_minimal() +                                                   # Applica un tema grafico pulito
    theme(legend.position = "none")                                     # Rimuove la legenda perché le classi sono già indicate sull'asse X
  
  # Grafico delle percentuali per il 2020
  p2 <- ggplot(table, aes(x = Classi, y = a2020, fill = Classi)) +      
    geom_col() +                                                       
    geom_text(aes(label = paste0(a2020, "%")), vjust = -0.3) +                        
    scale_fill_viridis_d() +                                                           
    ylim(0, 100) +                                                                     
    labs(title = paste(title, "- 2020"),                                                
         y = "Percentuale (%)", x = NULL) +
    theme_minimal() +                                                                  
    theme(legend.position = "none")                                                     
  
  # Grafico delle percentuali per il 2024
  p3 <- ggplot(table, aes(x = Classi, y = a2024, fill = Classi)) +                    
    geom_col() +                                                                       
    geom_text(aes(label = paste0(a2024, "%")), vjust = -0.3) +                      
    scale_fill_viridis_d() +                                                          
    ylim(0, 100) +                                                                     
    labs(title = paste(title, "- 2024"),                                                
         y = "Percentuale (%)", x = NULL) +
    theme_minimal() +                                                                  
    theme(legend.position = "none")                                                    
  
  png(output_file, width = 2400, height = 900, res = 200)               # Apre il dispositivo grafico PNG e definisce dimensioni e risoluzione
  print(p1 + p2 + p3)                                                   # Affianca i tre grafici usando patchwork
  dev.off()                                                             # Chiude il dispositivo grafico e salva il file
}

# Grafici delle percentuali nell'intera area di studio
plot_snow_percentages(snow_table, "Copertura nevosa", "output/snow_percentage_comparison.png")

# Grafici delle percentuali all'interno degli outlines ufficiali
plot_snow_percentages(snow_inside_table, "Copertura nevosa negli outlines", "output/snow_inside_outlines_comparison.png")

# Mantiene solamente i pixel validi in entrambi gli anni
common_mask <- !is.na(snow_2016_ndsi_ndwi) & !is.na(snow_2024_ndsi_ndwi)
snow_2016_common <- mask(snow_2016_ndsi_ndwi, common_mask, maskvalues = 0)
snow_2024_common <- mask(snow_2024_ndsi_ndwi, common_mask, maskvalues = 0)

# Codifica delle variazioni:
# 0 = non neve stabile; 1 = neve solo nel 2024; 2 = neve solo nel 2016; 3 = neve stabile
change_2016_2024 <- snow_2024_common + 2 * snow_2016_common
freq(change_2016_2024)

# CONFRONTO VISIVO DELLA VARIAZIONE DELLA COPERTURA NEVOSA
# Confronto tra la mappa dell'intera area e quella limitata agli outlines del 2020
png("output/snow_change_comparison.png", width = 2200, height = 1300, res = 200)
im.multiframe(1, 2)

# 1. Variazione della copertura nevosa classificata tra il 2016 e il 2024 nell'intera area
plot(change_2016_2024,
     col = c("grey80", "blue", "red", "darkgreen"),
     type = "classes", legend = FALSE,
     main = "Variazione della copertura nevosa classificata 2016-2024")

plot(study_glaciers_2020, add = TRUE, border = "black", lwd = 1.2)

legend("bottomleft",
       legend = c("Non neve stabile", "Neve solo nel 2024",
                  "Neve solo nel 2016", "Neve stabile",
                  "Outlines glaciali 2020"),
       fill = c("grey80", "blue", "red", "darkgreen", NA),
       border = c("black", "black", "black", "black", NA),
       lty = c(NA, NA, NA, NA, 1),
       col = c(NA, NA, NA, NA, "black"),
       lwd = c(NA, NA, NA, NA, 1.2),
       cex = 0.8, bg = "white", inset = c(0.085, 0.009), xpd = NA, bty = "o")

# 2. Variazione della copertura nevosa all'interno degli outlines del 2020
# Limita la mappa delle variazioni agli outlines ufficiali
change_inside <- mask(change_2016_2024, reference_snow, maskvalues = 0)
plot(change_inside,
     col = c("grey80", "blue", "red", "darkgreen"),
     type = "classes", legend = FALSE,
     main = "Variazione della copertura nevosa negli outlines 2020")

plot(study_glaciers_2020, add = TRUE, border = "black", lwd = 1.2)

legend("bottomleft",
       legend = c("Non neve stabile", "Neve solo nel 2024",
                  "Neve solo nel 2016", "Neve stabile", "Outlines glaciali 2020"),
             fill = c("grey80", "blue", "red", "darkgreen", NA),
       border = c("black", "black", "black", "black", NA),
       lty = c(NA, NA, NA, NA, 1),
       col = c(NA, NA, NA, NA, "black"),
       lwd = c(NA, NA, NA, NA, 1.2),
       cex = 0.8, bg = "white",  inset = c(0.085, 0.009), xpd = NA, bty = "o")

dev.off()



