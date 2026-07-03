



// Le immagini sono state prese da: https://earthengine.google.com/
// Di seguito il codice in JavaScript per scaricare le immagini di Sentinel-2

// =====================
// Vecchio codice 
// =====================
Map.centerObject(aoi, 12);
var s2 = ee.ImageCollection('COPERNICUS/S2_SR_HARMONIZED')
  .filterBounds(aoi)
  .filterDate(wet2023_start, wet2023_end)
  .filter(ee.Filter.lt('CLOUDY_PIXEL_PERCENTAGE', 10))
  .sort('CLOUDY_PIXEL_PERCENTAGE');
print('Numero immagini Sentinel-2:', s2.size());

// Median composite and band selection for RGB, NDVI and MNDWI in R
var img = s2.median()
  .select(['B2', 'B3', 'B4', 'B8', 'B11', 'B12'])
  .clip(aoi);

//Visualizzazione a colori naturali
Map.addLayer(img,{bands: ['B4', 'B3', 'B2'], min: 0, max: 2000},
  'RGB_2023_wet');

//Visualizzazione NIR, falsi colori
Map.addLayer(img,{bands: ['B8', 'B4', 'B3'], min: 0, max: 2000},
  'False_color_2023_wet');  

// Export img to Google Drive
Export.image.toDrive({
  image: img,
  description: 'planinsko_2023_wet',
  folder: 'telerilevamento_carsismo',
  fileNamePrefix: 'planinsko_2023_wet',
  region: aoi,
  scale: 20,
  maxPixels: 1e13
});





