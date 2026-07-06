# Titolo Provvisorio 

TUTTO QUESTO E' DA RISCRIVERE 
# Abstract

# 1. Introduzione

## Area di studio
_L'area di studio è situata nella porzione occidentale dell'isola di Spitsbergen, nell'arcipelago delle Svalbard (Norvegia), all'interno del settore del Recherchefjorden, un ramo del fiordo Bellsund, approssimativamente compreso tra 77.43–77.58° N e 14.08–14.57° E.
L'analisi è focalizzata su tre ghiacciai costieri: Renardbreen, Scottbreen e Blomlibreen, scelti perché appartenenti allo stesso contesto climatico e geomorfologico, ma caratterizzati da dimensioni differenti e da una diversa risposta alle recenti variazioni climatiche._

**Perchè ho scelto quest'area?**

## Obiettivo
| Analizzare la variazione recente dell’area glaciale di Renardbreen, Scottbreen e Blomlibreen tra 2016, 2020 e 2024, usando immagini Sentinel-2 estive e indici spettrali per distinguere ghiaccio/neve, roccia, acqua e superfici non glaciali. 

| I tre ghiacciai mostrano una riduzione dell’area glaciale tra 2016 e 2024, e questa riduzione è simile o diversa tra ghiacciai di dimensione diversa?

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


### ANDSI
Sviluppato dal team di Mohammadi et al. (2023) con esplicito focus sui dati multispettrali Sentinel-2, costituisce attualmente uno degli strumenti più raffinati per mappare la topologia dei ghiacciai in zone ad alta densità idrologica. 

## Workflow
1. NDWI e maschera = (B3 - B8) / (B3 + B8)
2. NDVI per vegetazione = (B8 - B4) / (B8 + B4)
3. NDSI - Classificazione principale = (B3 - B11) / (B3 + B11)
4. ANDSI = (CSI x NDSI) / (CSI + NDSI) = [B8 × (B3 + B11) − B12 × (B3 − B11)] / [B8 × (B3 + B11) + B12 × (B3 − B11)]
            CSI = (B8 + B3 - B11) (B8 - B3 - B11)
? 5. NDSII ghiaccio-roccia e superfici miste = (B4 - B11) / (B4 + B11) ? 

# 2. Materiali e Metodi

## 2.1 Dati utilizzati - Spiegazione codice Js
perchè sentinel 2 e dove sono stati presi i dati e con quali impostazioni: 
- copertura nuvolosa 10%,
- GEE cosa permette di fare,
- quali anni (2016-2024) perchè fine estate (problema di neve sciolta): _Sono state selezionate immagini acquisite durante la stagione estiva (luglio–agosto) degli anni 2016, 2020 e 2024, corrispondenti a un intervallo temporale di circa otto anni. La scelta del periodo estivo è motivata dal fatto che rappresenta la fase di massima ablazione glaciale, durante la quale la copertura nevosa stagionale è generalmente ridotta e risulta quindi più semplice distinguere il ghiaccio permanente dalle superfici circostanti._,
- bande scaricate e in che indici le uso (fare una tabella per semplificare la visione)

> [!Note]
> 
> Il codice completo in JavaScript utilizzato per ottenere le immagini si trova nel file Code.js

# 3. Risultati e Discussione

# 4. Conclusioni



# 5. Fonti
1. Hall, D.K., Riggs, G.A. (2011). Normalized-Difference Snow Index (NDSI). In: Singh, V.P., Singh, P., Haritashya, U.K. (eds) Encyclopedia of Snow, Ice and Glaciers. Encyclopedia of Earth Sciences Series. Springer, Dordrecht. https://doi.org/10.1007/978-90-481-2642-2_376
2. Mohammadi, B., Pilesjö, P., & Duan, Z. (2023). The superiority of the Adjusted Normalized Difference Snow Index (ANDSI) for mapping glaciers using Sentinel-2 multispectral satellite imagery. GIScience & Remote Sensing, 60(1). https://doi.org/10.1080/15481603.2023.2257978
3. Keshri, A., Shukla, A., & Gupta, R. P. (2009). ASTER ratio indices for supraglacial terrain mapping. International Journal of Remote Sensing, 30(2), 519–524. https://doi.org/10.1080/01431160802385459
4. McFEETERS, S. K. (1996). The use of the Normalized Difference Water Index (NDWI) in the delineation of open water features. International Journal of Remote Sensing, 17(7), 1425–1432. https://doi.org/10.1080/01431169608948714
5. 
