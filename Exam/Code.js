Map.centerObject(geometry, 12);
Map.addLayer(geometry, {}, 'AOI Planinsko polje');
var s2 = ee.ImageCollection('COPERNICUS/S2_SR_HARMONIZED')
  .filterBounds(geometry)
  .filterDate('2022-02-01', '2022-04-30')
  .filter(ee.Filter.lt('CLOUDY_PIXEL_PERCENTAGE', 10)); 

print('Numero immagini Sentinel-2:', s2.size());
