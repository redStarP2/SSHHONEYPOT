<?php

 
 
$servername = "veritabani";
$username = "logs";
$password = "OOU1tmUdCEt3kobx";
$dbname = "logs";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
  die("Connection failed: " . $conn->connect_error);
}
$sql = 'SELECT * FROM `userPass` ';
$result = $conn->query($sql);
$dat = "";
if ($result->num_rows > 0) {
  while($row = $result->fetch_assoc()) {
  	$dat = $dat.'{lat: '.$row["latitude"].', lng:'.$row["longitude"].', count: 4},';
  }
}
$conn->close();
?>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title>HONEYPOT</title>
    <style>
      body, html { margin:0; padding:0; height:100%;}
      body { font-family:sans-serif; }
      body * { font-weight:200;}
      h1 { position:absolute; background:white; padding:10px;}
      #map { height:100%; }
      .leaflet-container {
        background: rgba(0,0,0,.8) !important;
      }
      h1 { position:absolute; background:black; color:white; padding:10px; font-weight:200; z-index:10000;}
      #all-examples-info { position:absolute; background:white; font-size:16px; padding:20px; top:100px; width:350px; line-height:150%; border:1px solid rgba(0,0,0,.2);}
    </style>
    <link rel="stylesheet" href="http://cdn.leafletjs.com/leaflet-0.7.3/leaflet.css" />
    <script src="http://cdn.leafletjs.com/leaflet-0.7.3/leaflet.js"></script>
    <script src="heatmap.min.js"></script>
    <script src="leaflet-heatmap.js"></script>
  </head>
  <body>
   <h1>GELEN SALDIRILAR YOĞUNLUK HARITASI</h1>
   
   <div id="map"></div>
 
    <script>
      window.onload = function() {

        var testData = {
          max: 8,
          data: [<?php echo $dat; ?>]
        };

        var baseLayer = L.tileLayer(
          'http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',{
            attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="http://cloudmade.com">CloudMade</a>',
            maxZoom: 18
          }
        );

        var cfg = {
          // radius should be small ONLY if scaleRadius is true (or small radius is intended)
          "radius": 1,
          "maxOpacity": .8, 
          // scales the radius based on map zoom
          "scaleRadius": true, 
          // if set to false the heatmap uses the global maximum for colorization
          // if activated: uses the data maximum within the current map boundaries 
          //   (there will always be a red spot with useLocalExtremas true)
          "useLocalExtrema": true,
          // which field name in your data represents the latitude - default "lat"
          latField: 'lat',
          // which field name in your data represents the longitude - default "lng"
          lngField: 'lng',
          // which field name in your data represents the data value - default "value"
          valueField: 'count'
        };


        var heatmapLayer = new HeatmapOverlay(cfg);
        var map = new L.Map('map', {
          center: new L.LatLng(39.925533, 32.866287),
          zoom: 4,
          layers: [baseLayer, heatmapLayer]
        });
        heatmapLayer.setData(testData);
        layer = heatmapLayer;
      };
    </script>
  </body>
</html>