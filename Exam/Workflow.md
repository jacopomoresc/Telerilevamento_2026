# Titolo Provvisorio 

TUTTO QUESTO E' DA RISCRIVERE 
# Abstract

# 1. Introduzione 📌
Le Svalbard rappresentano una delle regioni artiche più sensibili al riscaldamento climatico in atto, con tassi di aumento della temperatura superiori alla media globale e conseguenze dirette sulla dinamica dei ghiacciai dell'arcipelago. Studi recenti basati su fonti storiche e geomorfologiche documentano, per questi e altri ghiacciai, una consistente perdita di massa e un arretramento marcato alternato solo da fasi di avanzata legate a eventi di *surge*.(Zagorski et al.). Questo quadro rende le Svalbard un caso di studio rilevante per verificare, tramite telerilevamento multitemporale, se e come la copertura di neve e ghiaccio stia effettivamente variando in un intervallo temporale recente e osservabile da satellite.

## Area di studio 🛰️
L’area di studio è situata nella porzione sud-occidentale dell’isola di Spitsbergen, nell’arcipelago norvegese delle Svalbard, all’interno del Sør-Spitsbergen National Park. In particolare, il sito interessa la parte nord-occidentale del Recherchefjorden e la costa meridionale di Bellsund, nella regione di Wedel Jarlsberg Land (~77°N e 14°E). Nel ritaglio considerato sono presenti Renardbreen - un ghiacciaio vallivo che in passato terminava in mare - Scottbreen, Blomlibreen e alcune superfici glaciali minori. 

<p align="center">
  <img src="Images/Svalard_AOI_print.png" width="850">
</p>

> Figura 1. Localizzazione dell’area di studio nel settore sud-occidentale di Spitsbergen, Svalbard.</em>

## Obiettivo 🎯
L'obiettivo del progetto è stimare la variazione della copertura di neve/ghiaccio nell'area di studio tra il 2016 e il 2024, utilizzando immagini Sentinel-2 attraverso il calcolo di indici spettrali e un'analisi multitemporale. L'ipotesi di partenza è che tale estensione si riduca per effetto del riscaldamento climatico..

# 2. Materiali e Metodi 📌

## Raccolta delle immagini📂 
Le immagini satellitari sono state scaricate da [**Google Earth Engine**](https://earthengine.google.com/) (GEE) selezionando l'area di studio nelle date indicate.

> [!NOTE]
> Il codice completo JavaScript utilizzato è quello fornito durante il corso ed è disponibile nel file Code.js


# 4. Materiali e Metodi 

## 4.1 Dati utilizzati 🧪

Le immagini satellitari sono state ottenute tramite [**Google Earth Engine**](https://earthengine.google.com/) (GEE), una piattaforma cloud che permette di accedere e processare direttamente l'archivio satellitare pubblico (tra cui Sentinel-2), senza doverlo scaricare localmente: è possibile filtrare le scene per area, intervallo di date e copertura nuvolosa, e ottenere ed esportare l'immagine risultante già ritagliata sull'area di interesse.

Sono state selezionate immagini **Sentinel-2**, filtrate impostando una copertura nuvolosa massima del 10% (`CLOUDY_PIXEL_PERCENTAGE < 10`), per minimizzare l'interferenza delle nuvole sulla classificazione degli indici spettrali.

Sono state selezionate immagini acquisite durante la stagione estiva (luglio–agosto) degli anni 2016, 2020 e 2024, corrispondenti a un intervallo temporale di circa otto anni. La scelta del periodo estivo è motivata dal fatto che rappresenta la fase di massima ablazione glaciale, durante la quale la copertura nevosa stagionale è generalmente ridotta e risulta quindi più semplice distinguere il ghiaccio permanente dalle superfici circostanti.

Per ciascun anno sono state scaricate le bande Sentinel-2 riportate in tabella, utilizzate poi per il calcolo degli indici spettrali:

| Banda | Nome | Risoluzione | Indice/uso |
|---|---|---|---|
| B2 | Blue | 10 m | Composizione RGB |
| B3 | Green | 10 m | NDSI, NDWI |
| B4 | Red | 10 m | NDVI, composizione RGB |
| B8 | NIR | 10 m | NDWI, NDVI, filtro NIR |
| B11 | SWIR1 | 20 m | NDSI |

> [!NOTE]
> Il codice completo in JavaScript utilizzato per ottenere le immagini si trova nel file `Code.js`.



## Importazione e visualizzazione delle immagini 💻 
Una volta ottenute le immagini satellitari le carichiamo su R impostando una working directory:

````r
setwd("~/Desktop/TELERILEVAMENTO_R")
````

## 2.1 Dati utilizzati - Spiegazione codice Js
Per l'analisi sono state utilizzate tre immagini Sentinel-2 dell'area, 
acquisite a fine estate (late summer) negli anni 2016, 2020 e 2024: la 
finestra temporale di fine stagione riduce l'interferenza della neve 
fresca stagionale, concentrando l'analisi sulla componente di ghiaccio 
più stabile. Per il 2020 sono inoltre disponibili gli outlines glaciali 
ufficiali del Norwegian Polar Institute (NPI), utilizzati come 
riferimento indipendente per la validazione della classificazione.

perchè sentinel 2 e dove sono stati presi i dati e con quali impostazioni: 
- copertura nuvolosa 10%,
- GEE cosa permette di fare,
- quali anni (2016-2024) perchè fine estate (problema di neve sciolta): _Sono state selezionate immagini acquisite durante la stagione estiva (luglio–agosto) degli anni 2016, 2020 e 2024, corrispondenti a un intervallo temporale di circa otto anni. La scelta del periodo estivo è motivata dal fatto che rappresenta la fase di massima ablazione glaciale, durante la quale la copertura nevosa stagionale è generalmente ridotta e risulta quindi più semplice distinguere il ghiaccio permanente dalle superfici circostanti._,
- bande scaricate e in che indici le uso (fare una tabella per semplificare la visione)

> [!Note]
> 
> Il codice completo in JavaScript utilizzato per ottenere le immagini si trova nel file Code.js

> **Commento**
> 
> Il codice completo in JavaScript utilizzato per ottenere le immagini si trova nel file Code.js


### 2.2 Procedimento - Rstudio



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

