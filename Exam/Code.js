// P - 
// Telerilevamento Geo-ecologico in R
// Jacopo Moresco

// Le immagini sono state prese da: https://earthengine.google.com/
// Di seguito il codice in JavaScript per scaricare le immagini di Sentinel-2

// Area of Interest: 
var aoi = ee.Geometry.Polygon(
        [[[14.075348963955573, 77.57823316518508],
          [14.075348963955573, 77.42532931273963],
          [14.573166957119636, 77.42532931273963],
          [14.573166957119636, 77.57823316518508]]], null, false);
          
Map.centerObject(aoi, 10);

// ------------------------------------------------------
// Estate 2016 
// ------------------------------------------------------
var s2_2016 = ee.ImageCollection('COPERNICUS/S2_SR_HARMONIZED') //Sentinel-2 Level-2A
  .filterBounds(aoi)
  .filterDate('2016-08-01', '2016-08-31')
  .filter(ee.Filter.lt('CLOUDY_PIXEL_PERCENTAGE', 10)); // poca tolleranza 

print('Conteggio immagini estate 2016:', s2_2016.size());

// Crea il composito mediano e seleziona le bande necessarie
var img_2016 = s2_2016.median()
  .select(['B2', 'B3', 'B4', 'B8', 'B11', 'B12'])
  .clip(aoi);
  
Map.addLayer(
  img_2016,
  {bands: ['B4', 'B3', 'B2'], min: 0, max: 6000},
  'RGB_2016_summer'
);

// Esportazione su Google Drive
Export.image.toDrive({
  image: img_2016,
  description: 'svalbard_glaciers_2016_late_summer',
  folder: 'telerilevamento_svalbard_glaciers',
  fileNamePrefix: 'svalbard_glaciers_2016_late_summer',
  region: aoi,
  scale: 20,
  maxPixels: 1e13
});

// ------------------------------------------------------
// Estate 2020 
// ------------------------------------------------------

var s2_2020 = ee.ImageCollection('COPERNICUS/S2_SR_HARMONIZED')
  .filterBounds(aoi)
  .filterDate('2020-08-01', '2020-08-31')
  .filter(ee.Filter.lt('CLOUDY_PIXEL_PERCENTAGE', 10));

print('Conteggio immagini estate 2020:', s2_2020.size());

// Crea il composito mediano e seleziona le bande necessarie
var img_2020 = s2_2020.median()
  .select(['B2', 'B3', 'B4', 'B8', 'B11', 'B12'])
  .clip(aoi);
  
Map.addLayer(
  img_2020,
  {bands: ['B4', 'B3', 'B2'], min: 0, max: 6000},
  'RGB_2020_summer'
);

// Esportazione su Google Drive
Export.image.toDrive({
  image: img_2020,
  description: 'svalbard_glaciers_2020_late_summer',
  folder: 'telerilevamento_svalbard_glaciers',
  fileNamePrefix: 'svalbard_glaciers_2020_late_summer',
  region: aoi,
  scale: 20,
  maxPixels: 1e13
});

// ------------------------------------------------------
// Estate 2024 
// ------------------------------------------------------
var s2_2024 = ee.ImageCollection('COPERNICUS/S2_SR_HARMONIZED')
  .filterBounds(aoi)
  .filterDate('2024-08-01', '2024-08-31')
  .filter(ee.Filter.lt('CLOUDY_PIXEL_PERCENTAGE', 10));

print('Conteggio immagini estate 2024:', s2_2024.size());

// Crea il composito mediano e seleziona le bande necessarie
var img_2024 = s2_2024.median()
  .select(['B2', 'B3', 'B4', 'B8', 'B11', 'B12'])
  .clip(aoi);
  
Map.addLayer(
  img_2024,
  {bands: ['B4', 'B3', 'B2'], min: 0, max: 6000},
  'RGB_2024_summer'
);

// Esportazione su Google Drive
Export.image.toDrive({
  image: img_2024,
  description: 'svalbard_glaciers_2024_late_summer',
  folder: 'telerilevamento_svalbard_glaciers',
  fileNamePrefix: 'svalbard_glaciers_2024_late_summer',
  region: aoi,
  scale: 20,
  maxPixels: 1e13
});
