# Monitoraggio multitemporale della copertura di neve/ghiaccio alle Svalbard (2016-2020-2024)

> #### Progetto d'esame - Telerilevamento Geo-Ecologico in R - 2026
>> ##### Jacopo Moresco, matricola n.1237448

# Abstract

# 1. Introduzione 📌

Le Svalbard rappresentano una delle regioni artiche più sensibili al riscaldamento climatico in atto, con tassi di aumento della temperatura superiori alla media globale e conseguenze dirette sulla dinamica dei ghiacciai dell'arcipelago. Studi recenti basati su fonti storiche e geomorfologiche documentano, per questi e altri ghiacciai, una consistente perdita di massa e un arretramento marcato alternato solo da fasi di avanzata legate a eventi di *surge* (Zagorski et al.). Questo quadro rende le Svalbard un caso di studio rilevante per verificare, tramite telerilevamento multitemporale, se e come la copertura di neve e ghiaccio stia effettivamente variando in un intervallo temporale recente e osservabile da satellite.

## Area di studio 🛰️

L'area di studio è situata nella porzione sud-occidentale dell'isola di Spitsbergen, nell'arcipelago norvegese delle Svalbard, all'interno del Sør-Spitsbergen National Park. In particolare, il sito interessa la parte nord-occidentale del Recherchefjorden e la costa meridionale di Bellsund, nella regione di Wedel Jarlsberg Land (~77°N, 14°E). Nel ritaglio considerato sono presenti Renardbreen — un ghiacciaio vallivo che in passato terminava in mare — Scottbreen, Blomlibreen e alcune superfici glaciali minori.

Si tratta di ghiacciai di tipo *surge*, soggetti a temporanei e violenti avanzamenti pulsanti seguiti da lunghe fasi di quiescenza; tuttavia, la tendenza dominante osservata negli ultimi decenni in questa regione, fortemente influenzata dal rapido riscaldamento artico, è quella di un arretramento marcato e di una consistente perdita di massa.

<p align="center">
  <img src="Images/Svalard_AOI_print.png" width="850">
</p>

> Figura 1. Localizzazione dell'area di studio nel settore sud-occidentale di Spitsbergen, Svalbard.

## Obiettivo 🎯

L'obiettivo del progetto è stimare la variazione della copertura di neve/ghiaccio nell'area di studio tra il 2016 e il 2024, utilizzando immagini Sentinel-2 attraverso il calcolo di indici spettrali e un'analisi multitemporale, nell'ipotesi che tale estensione si riduca per effetto del riscaldamento climatico in atto alle Svalbard.

# 2. Materiali e Metodi 📌

## Raccolta delle immagini 📂

Le immagini satellitari sono state ottenute tramite [**Google Earth Engine**](https://earthengine.google.com/) (GEE), una piattaforma cloud che consente di accedere direttamente all'archivio satellitare pubblico, tra cui le collezioni Sentinel-2, e di elaborarlo senza doverlo scaricare in locale: è possibile filtrare le scene disponibili per area geografica, intervallo temporale e percentuale di copertura nuvolosa, per poi esportare l'immagine risultante già ritagliata sull'area di interesse. Per questo progetto sono state selezionate immagini con una copertura nuvolosa massima del 10% (`CLOUDY_PIXEL_PERCENTAGE < 10`), soglia scelta per ridurre il più possibile l'interferenza delle nuvole nel calcolo degli indici spettrali.

Le immagini utilizzate sono composti mediani mensili: per ciascun anno, tutte le scene Sentinel-2 di agosto (2016, 2020, 2024) con copertura nuvolosa inferiore al 10% sono state combinate calcolando il valore mediano pixel per pixel, riducendo così l'effetto di rumore residuo e le differenze radiometriche tra acquisizioni singole. Il dataset di partenza è Sentinel-2 Surface Reflectance Harmonized (Level-2A), già corretto atmosfericamente. Il periodo estivo è stato scelto perché corrisponde alla fase di massima ablazione glaciale, durante la quale la copertura nevosa stagionale è generalmente ridotta, rendendo più semplice distinguere il ghiaccio permanente dalle superfici circostanti.

> [!NOTE]
> Il codice completo in JavaScript utilizzato per ottenere le immagini si trova nel file `Code.js`.

Per ciascun anno sono state scaricate le bande Sentinel-2 riportate in tabella, esportate a una risoluzione uniforme di 20 m (nativamente B2, B3, B4 e B8 sarebbero a 10 m, ma sono state allineate alla risoluzione di B11 in fase di esportazione):

| Banda | Nome | Risoluzione nel raster | Indice/uso |
|---|---|---|---|
| B2 | Blue | 20 m | Composizione RGB |
| B3 | Green | 20 m | Composizione RGB, NDSI, NDWI |
| B4 | Red | 20 m | NDVI, Composizione RGB |
| B8 | NIR | 20 m | NDWI, NDVI, filtro NIR |
| B11 | SWIR1 | 20 m | NDSI |

## Procedimento R-Studio 🧪

Una volta scaricate, le tre immagini sono state importate in RStudio dopo aver impostato una working directory.

```r
setwd("C:/Users/Jacopo/OneDrive/Università/Magistrale/Telerilevamento_Rocchini/Exam")
```

Successivamente sono stati installati i seguenti pacchetti:

```r
library(terra)      # Gestione raster e vettori spaziali
library(imageRy)    # Visualizzazione immagini telerilevate
library(viridis)    # Palette cromatiche per mappe
library(ggplot2)    # Grafici finali
library(patchwork)  # Affiancamento grafici
library(ggridges)   # Distribuzioni degli indici
library(reshape2)   # Riorganizzazione tabelle per ggplot
```

### Importazione e visualizzazione delle immagini 💻

I tre raster Sentinel-2 sono stati importati con la funzione `rast()` di `terra`, che legge direttamente il file multibanda in formato `.tif` mantenendo la struttura originale delle cinque bande selezionate in fase di esportazione da GEE.

```r
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
```

### Importazione degli outlines glaciali di riferimento 🗺️

Oltre alle tre immagini Sentinel-2, è stato importato lo shapefile con gli outlines glaciali ufficiali del Norwegian Polar Institute (NPI), disponibile per l'anno 2020. Questo dato vettoriale costituisce l'unico riferimento indipendente disponibile nel progetto e viene utilizzato più avanti per validare la classificazione neve/ghiaccio ottenuta dagli indici spettrali.

```r
# ------------------------------------------------------------
# IMPORTAZIONE SHAPEFILE
# ------------------------------------------------------------
# Cerco tutti i file .shp nella cartella Shapefile_2020
shapefiles_2020 <- list.files(
  path = "data_raw/Shapefile_2020",
  pattern = "\\.shp$",
  recursive = TRUE,   # cerca nelle eventuali sottocartelle
  full.names = TRUE
)

# Importo gli outlines del 2020
glacier_outlines_2020 <- vect(shapefiles_2020[1]) 
glacier_outlines_2020        # Visualizzo informazioni del vettore

# Confronto il sistema di riferimento (crs) e l'estensione del raster 2020 
# e dello shapefile
crs(image_2020) == crs(glacier_outlines_2020)

# Riproietto gli outlines nel CRS dell raster del 2020
glacier_outlines_2020_proj <- project(glacier_outlines_2020, crs(image_2020))

# Ritaglio gli outlines sull'area di studio
study_glaciers_2020 <- crop(glacier_outlines_2020_proj, image_2020)

# Salvo gli outlines ritagliati come GeoPackage
writeVector(
  study_glaciers_2020,
  "data_processed/study_glaciers_2020.gpkg",
  overwrite = TRUE
)
```

### Visualizzazione RGB e bande 🎨

Una prima composizione a colori naturali (bande 4-3-2) è stata prodotta per i tre anni, utile per farsi un'idea generale della copertura del terreno e della qualità delle immagini prima di procedere al calcolo degli indici.

```r
# ============================================================
# VISUALIZZAZIONE IMMAGINI E BANDE
# ============================================================

# VISUALIZZAZIONE IMMAGINE RGB
png("output/rgb_multitemporal_glaciers.png", width = 2150, height = 1150, res = 200)
im.multiframe(1,3)
plotRGB(image_2016, r = 3, g = 2, b = 1, stretch = "lin", main = "2016", 
        cex.main = 1.8)
plotRGB(image_2020, r = 3, g = 2, b = 1, stretch = "lin", main = "2020", 
        cex.main = 1.8)
plotRGB(image_2024, r = 3, g = 2, b = 1, stretch = "lin", main = "2024", 
        cex.main = 1.8)
dev.off()
```

<p align="center">
  <img src="Images/rgb_multitemporal_glaciers.png" width="900">
</p>

> Figura 2. Composizione RGB (bande 4-3-2) a confronto tra 2016, 2020 e 2024.

Sono state poi visualizzate singolarmente le cinque bande disponibili per ciascun anno, per verificare la qualità radiometrica delle immagini e la corrispondenza tra bande e superfici osservabili (neve, roccia, acqua, ombre) prima di calcolare gli indici.

```r
# LE CINQUE BANDE DEL 2020
png("output/bands_2020.png", width = 2200, height = 1400, res = 200)
im.multiframe(2,3)
plot(image_2020[["B2"]],  main = "B2 - Blue",  col = viridis(100))
plot(image_2020[["B3"]],  main = "B3 - Green", col = viridis(100))
plot(image_2020[["B4"]],  main = "B4 - Red",   col = viridis(100))
plot(image_2020[["B8"]],  main = "B8 - NIR",   col = viridis(100))
plot(image_2020[["B11"]], main = "B11 - SWIR1", col = viridis(100))
dev.off()
```

<p align="center">
  <img src="Images/bands_2020.png" width="800">
</p>

> Figura 3. Le cinque bande Sentinel-2 disponibili per il 2020.

Prima di calcolare gli indici spettrali, le bande del visibile e le bande NIR/SWIR1 sono state confrontate sinotticamente tra i tre anni, per



## Teoria di Base - Da rielaborare
Nel dominio del visibile (VIS, lunghezze d'onda tra $0.4\ \mu\text{m}$ e $0.7\ \mu\text{m}$), e in particolare nelle bande del blu e del verde, la neve fresca e il ghiaccio pulito (clean ice) esibiscono una riflettanza eccezionalmente elevata, spesso superiore all'80-90% della radiazione solare incidente. Questa caratteristica conferisce ai ghiacciai la loro tipica luminosità abbagliante. L'alto grado di riflessione nel visibile è primariamente dominato dallo scattering multiplo all'interno della matrice dei cristalli di ghiaccio, dove l'assorbimento è minimo.
Nel vicino infrarosso (NIR, $\sim0.8 - 1.1\ \mu\text{m}$), la riflettanza inizia a decrescere progressivamente, influenzata principalmente dalla dimensione equivalente dei grani di neve. 

Nel dominio dell'infrarosso a onde corte (SWIR, $1.5 - 2.5\ \mu\text{m}$), la situazione si estremizza: le molecole d'acqua nel reticolo cristallino presentano bande di assorbimento formidabili. Di conseguenza, la riflettanza della neve e del ghiaccio nello SWIR crolla a valori prossimi allo zero. 


Questo marcato contrasto dicotomico, altissima riflettanza nel VIS e forte assorbimento nello SWIR, è il principio fisico fondamentale sfruttato dagli indici spettrali per isolare le coperture glaciali.

### NDSI
Formulato da Hall et al.(1995) per mitigare l'influenza delle nubi e standardizzare la mappatura della criosfera a livello globale. Capitalizza la massima escursione di riflettanza del ghiaccio tra la regione visibile e l'infrarosso a onde corte, operando una normalizzazione che riduce gli effetti **dell'atmosfera**, **dell'illuminazione asimmetrica** e del **rumore topografico**.


$$\text{NDSI} = \frac{\text{Green} - \text{SWIR}}{\text{Green} + \text{SWIR}}$$

Può asumere vlaori contininui da -1 a +1 e compensa intrinsecamente le differenze di illuminazione tra versanti esposti al sole e versanti in ombra, permettendo in molti casi di rintracciare la neve persino nelle profonde ombre proiettate dalle vette montane.

### Criticità NDSI
Per trasformare l'indcie da gradiente continuo a una mappa di classificazione binaria (Pixel glaciale vs. Pixel non-glaciale) è rischiesta l'applicazione di una soglia numerica ottimale (Optimal Threshold Value, OTHV). Storicamente, e nella maggior parte delle applicazioni operative si usa un valore soglia parti a $\text{NDSI} \geq 0.40$ spesso accoppiata a un vincolo accessorio nel NIR (es. riflettanza NIR $\geq 0.11$) per impedire l'inclusione di acqua estremamente scura o ombre nere. 

1. L'Ambivalenza Acqua-Ghiaccio: I laghi proglaciali e le acque superficiali presentano tassi di assorbimento massicci nella banda SWIR e una discreta riflettanza nel Verde. Di conseguenza, il rapporto normalizzato dell'NDSI per i pixel d'acqua produce spesso valori elevati, indistinguibili da quelli del ghiaccio. Senza l'ausilio di lunghe operazioni di mascheramento esterno (Water Masks), l'NDSI sovrastima sistematicamente l'area glaciale includendo i laghi terminali.
2. Sensibilità ai Pixel Misti: Ai bordi del ghiacciaio, dove il ghiaccio sottile si mescola con formazioni rocciose o vegetazione, la risoluzione spaziale dei satelliti (es. 30 m di Landsat) genera pixel misti.
3. Debris Cover: L'NDSI è fisiologicamente incapace di rilevare il ghiaccio sepolto da coperture detritiche.Poiché la litologia della copertura detritica (ghiaia, polveri, massi) copre totalmente il ghiaccio sottostante, gli indici ottici basati sul VIS-SWIR (NDSI, ANDSI, AGEI) restituiscono sistematicamente la firma spettrale della roccia. L'estrazione da remoto ignora del tutto la massa di ghiaccio sepolta, confondendo i limiti laterali e frontali inferiori del ghiacciaio con il letto periglaciale della vallata.
Il tracciamento dei ghiacciai neri necessita di flussi di lavoro eterogenei, i cui due assi portanti sono il telerilevamento termico e i sensori attivi. 



# 3. Risultati e Discussione



# 4. Conclusioni



# 5. Fonti
1. Hall, D.K., Riggs, G.A. (2011). Normalized-Difference Snow Index (NDSI). In: Singh, V.P., Singh, P., Haritashya, U.K. (eds) Encyclopedia of Snow, Ice and Glaciers. Encyclopedia of Earth Sciences Series. Springer, Dordrecht. https://doi.org/10.1007/978-90-481-2642-2_376
2. Keshri, A., Shukla, A., & Gupta, R. P. (2009). ASTER ratio indices for supraglacial terrain mapping. International Journal of Remote Sensing, 30(2), 519–524. https://doi.org/10.1080/01431160802385459
3. McFEETERS, S. K. (1996). The use of the Normalized Difference Water Index (NDWI) in the delineation of open water features. International Journal of Remote Sensing, 17(7), 1425–1432. https://doi.org/10.1080/01431169608948714
4. Lu, Y., James, T., Schillaci, C., & Lipani, A. (2022). Snow detection in alpine regions with Convolutional Neural Networks: discriminating snow from cold clouds and water body. GIScience & Remote Sensing, 59(1), 1321–1343. https://doi.org/10.1080/15481603.2022.2112391
5. Lith, A., G. Moholdt & J. Kohler. 2021. Svalbard glacier inventory based on Sentinel-2 imagery from summer 2020 [Data set]. Norwegian Polar Institute. https://data.npolar.no/dataset/1b8631bf-7710-449a-a56f-0da1a4fef608
6. König, M., Kohler, J., & Nuth, C. (2013). Glacier Area Outlines - Svalbard 1936-2010 [Dataset]. Norwegian Polar Institute. https://doi.org/10.21334/NPOLAR.2013.89F430F8
7. 
