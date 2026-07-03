



// Le immagini sono state prese da: https://earthengine.google.com/
// Di seguito il codice in JavaScript per scaricare le immagini di Sentinel-2


// ==============================================
// Area di interesse
// ==============================================
Map.centerObject(geometry, 12);
Map.addLayer(geometry, {}, 'AOI Planinsko polje');

// ==============================================
// Caricamento Image Collection fase wet
// ==============================================
var s2 = ee.ImageCollection('COPERNICUS/S2_SR_HARMONIZED')
  .filterBounds(geometry)
  .filterDate('2022-02-01', '2022-04-30') //periodo bagnato
  .filter(ee.Filter.lt('CLOUDY_PIXEL_PERCENTAGE', 10)); 

print('Numero immagini Sentinel-2:', s2.size());
