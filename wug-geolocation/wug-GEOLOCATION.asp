<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<link href="https://cdn.jsdelivr.net/gh/Leaflet/Leaflet@1.7.1/dist/leaflet.css" rel="stylesheet" type="text/css" />
<script src="https://cdn.jsdelivr.net/gh/Leaflet/Leaflet@1.7.1/dist/leaflet.js">
//All credit to Leaflet contributors.
//You can download leaflet.js and leaflet.css from https://leafletjs.com/download.html</script>
<script src="https://cdn.jsdelivr.net/gh/leaflet-extras/leaflet-providers@1.10.2/leaflet-providers.js">
//All credit to Leaflet-Extras contributors.
//You can be download the file from here: https://github.com/leaflet-extras/leaflet-providers credit to leaflet-extras members</script>
</head>
<%@ language="jscript" %>
<!--#include virtual="/NmConsole/Core/Ajax/Ajax.inc"-->
<%
// the global JSON symbol will be defined by Js.inc.
JSON = undefined;
%>
<!--#include virtual="/NmConsole/$Js/Core/Js.inc"-->
<!--#include virtual="/NmConsole/$Js/Core/Form/Form.inc"-->
<!--#include virtual="/NmConsole/$Js/Core/JSON/JSON.inc"-->
<!--#include virtual="/NmConsole/$Js/Core/Page/Page.inc"-->
<%
var $, JSON; 
if ($) {
	throw new Error("Global: $ already exists, cannot assign it to Js.Form");
}
$ = Js.Form;
if (JSON) {
	throw new Error("Global: JSON already exists");
}
JSON = Js.JSON;
%>

<%
Js.initialize();
%>
<script>
//Set the tooltip styling here
</script>
<style>
.leaflet-tooltip{padding: 0px; background-color: black; box-shadow: none; color: goldenrod; border:none;}
.leaflet-tooltip-bottom::before{display:none;}
</style>
<div id='map'>
<script type="text/javascript">
///******************************
///VARIABLES THAT CAN BE CHANGED*
///******************************
///Use built-in Latitude and Longitude values?
var bUseBuiltin = false;
///API KEYS
var HEREappId = ""; //This is your appId, to acquire one sign-up for free here: https://developer.here.com/
var HEREappCode = ""; //This is your appCode, to acquire one sign-up for free here: https://developer.here.com/ 
var ThunderforestAPIKey = "" // In order to use Thunderforest maps, you must register. https://thunderforest.com/pricing/ (Tiles per month 150,000 free)
var ArcGIS = false //Set to true once registered. In order to use ArcGIS maps, you must register at https://developers.arcgis.com/en/sign-up/ and abide by the terms of service. No special syntax is required.
var OpenWeatherMapAPIKey = "" //Sing-up here https://openweathermap.org/ to get an API key
var MapBoxAccessToken = "" //Sign-up here https://account.mapbox.com/
///MAP DEFAULTS
var defaultLat = parseFloat(27.620273282414246); //Default latitude
var defaultLong = parseFloat(-82.23541259765626); //Default longitude
var defaultZoom = 8; //Default zoom, higher number is closer
var defaultMapLayer = "Wikimedia"; //This is the default map tile used
var sDynamicGroupName = "All";//This is the name of the dynamic group to get the device data from, default is all devices
//Make a comma separate list using any of these options, example ["OpenWeatherMap.CloudsClassic", "OpenWeatherMap.PrecipitationClassic", "OpenWeatherMap.RainClassic"]
//OpenWeatherMap.Clouds, OpenWeatherMap.CloudsClassic, OpenWeatherMap.Precipitation, OpenWeatherMap.PrecipitationClassic
//OpenWeatherMap.Rain, OpenWeatherMap.RainClassic, OpenWeatherMap.Pressure, OpenWeatherMap.Wind, OpenWeatherMap.Temperature, OpenWeatherMap.Snow
var aDefaultOverlay = ["WhatsUp Gold - Groups", "WhatsUp Gold - Devices"] //Which overlays will be default?
//Tooltip settings
var bAlwaysShow = true; //Always show the icon tooltip? valid settings are true or false
var nRefreshInterval = 60 //Seconds to wait between refreshing device group/device markers
///**********************************
///END VARIABLES THAT CAN BE CHANGED*
///**********************************
var isInitialized = false; //Boolean for later use
var deviceLayerGroup = new L.layerGroup(); //Variable for later use
var groupsLayerGroup = new L.layerGroup(); //Variable for later use
function initialize() {
isInitialized = true; //Set boolean to true so we know it's been initialized
// Get saved data from sessionStorage
//Set or get zoom level
if (sessionStorage.getItem('zoomLev') == null) {
 zoomLevel = defaultZoom;
 }
 else {
 zoomLevel = sessionStorage.getItem('zoomLev');
 } 
//Set or get zoom level
if (sessionStorage.getItem('lat') == null || sessionStorage.getItem('lng') == null)  {
 lat = defaultLat;
 lng = defaultLong;
 }
 else {
 lat = parseFloat(sessionStorage.getItem('lat'));
 lng = parseFloat(sessionStorage.getItem('lng'));
}
//Create the map canvas
map = L.map('map').setView([lat, lng], zoomLevel);
var baselayers = {};
//05-29-2019 Layers found not to be working from United States disabled. You can try them yourself if you'd like by removing the // from before them.
//05-29-2019 Added additional layers found to be working. 
//HERE (formerly Nokia). In order to use HERE layers, you must register. Once registered, you need to define app_id and app_code variables near top of the code
if(HEREappCode.length > 0 && HEREappId.length > 0){
baselayers['HERE.normalDay'] = L.tileLayer.provider('HERE.normalDay', {app_id: HEREappId, app_code: HEREappCode});
baselayers['HERE.normalDayCustom'] = L.tileLayer.provider('HERE.normalDayCustom', {app_id: HEREappId, app_code: HEREappCode});
baselayers['HERE.normalDayGrey'] = L.tileLayer.provider('HERE.normalDayGrey', {app_id: HEREappId, app_code: HEREappCode});
baselayers['HERE.normalDayTransit'] = L.tileLayer.provider('HERE.normalDayTransit', {app_id: HEREappId, app_code: HEREappCode});
baselayers['HERE.normalNight'] = L.tileLayer.provider('HERE.normalNight', {app_id: HEREappId, app_code: HEREappCode});
baselayers['HERE.normalNightGrey'] = L.tileLayer.provider('HERE.normalNightGrey', {app_id: HEREappId, app_code: HEREappCode});
baselayers['HERE.normalNightTransit'] = L.tileLayer.provider('HERE.normalNightTransit', {app_id: HEREappId, app_code: HEREappCode});
baselayers['HERE.carnavDayGrey'] = L.tileLayer.provider('HERE.carnavDayGrey', {app_id: HEREappId, app_code: HEREappCode});
baselayers['HERE.pedestrianDay'] = L.tileLayer.provider('HERE.pedestrianDay', {app_id: HEREappId, app_code: HEREappCode});
baselayers['HERE.pedestrianNight'] = L.tileLayer.provider('HERE.pedestrianNight', {app_id: HEREappId, app_code: HEREappCode});
baselayers['HERE.satelliteDay'] = L.tileLayer.provider('HERE.satelliteDay', {app_id: HEREappId, app_code: HEREappCode});
baselayers['HERE.basicMap'] = L.tileLayer.provider('HERE.basicMap', {app_id: HEREappId, app_code: HEREappCode});
baselayers['HERE.hybridDay'] = L.tileLayer.provider('HERE.hybridDay', {app_id: HEREappId, app_code: HEREappCode});
baselayers['HERE.hybridDayTransit'] = L.tileLayer.provider('HERE.hybridDayTransit', {app_id: HEREappId, app_code: HEREappCode});
baselayers['HERE.hybridDayGrey'] = L.tileLayer.provider('HERE.hybridDayGrey', {app_id: HEREappId, app_code: HEREappCode});
baselayers['HERE.terrainDay'] = L.tileLayer.provider('HERE.terrainDay', {app_id: HEREappId, app_code: HEREappCode});
//baselayers['HERE.redcuedDay'] = L.tileLayer.provider('HERE.redcuedDay', {app_id: HEREappId, app_code: HEREappCode});
//baselayers['HERE.redcuedNight'] = L.tileLayer.provider('HERE.redcuedNight', {app_id: HEREappId, app_code: HEREappCode});
baselayers['HERE.mapLabels'] = L.tileLayer.provider('HERE.mapLabels', {app_id: HEREappId, app_code: HEREappCode});
baselayers['HERE.trafficFlow'] = L.tileLayer.provider('HERE.trafficFlow', {app_id: HEREappId, app_code: HEREappCode});
baselayers['HERE.carnavDayGrey'] = L.tileLayer.provider('HERE.carnavDayGrey', {app_id: HEREappId, app_code: HEREappCode});
baselayers['HERE.terrainDay'] = L.tileLayer.provider('HERE.terrainDay', {app_id: HEREappId, app_code: HEREappCode});
}
//OpenStreetMap
baselayers['OpenStreetMap.Mapnik'] = L.tileLayer.provider('OpenStreetMap.Mapnik');
baselayers['OpenStreetMap.HOT'] = L.tileLayer.provider('OpenStreetMap.HOT');
//baselayers['OpenTopoMap'] = L.tileLayer.provider('OpenTopoMap'); //This doesn't seem to work?
//baselayers['OpenSeaMap'] = L.tileLayer.provider('OpenSeaMap'); //This doesn't seem to work?
//baselayers['OpenPtMap'] = L.tileLayer.provider('OpenPtMap'); //This doesn't seem to work?
baselayers['OpenRailwayMap'] = L.tileLayer.provider('OpenRailwayMap');
//baselayers['OpenFireMap'] = L.tileLayer.provider('OpenFireMap'); //This doesn't seem to work?
//baselayers['SafeCast'] = L.tileLayer.provider('SafeCast'); //Useless map?
//OpenMapSurfer
//baselayers['OpenMapSurfer.Roads'] = L.tileLayer.provider('OpenMapSurfer.Roads');
//baselayers['OpenMapSurfer.Hybrid'] = L.tileLayer.provider('OpenMapSurfer.Hybrid');
//baselayers['OpenMapSurfer.AdminBounds'] = L.tileLayer.provider('OpenMapSurfer.AdminBounds');
//baselayers['OpenMapSurfer.ContourLines'] = L.tileLayer.provider('OpenMapSurfer.ContourLines'); //This doesn't seem to work?
//baselayers['OpenMapSurfer.Hillshade'] = L.tileLayer.provider('OpenMapSurfer.Hillshade'); //Useless map
//baselayers['OpenMapSurfer.ElementsAtRisk'] = L.tileLayer.provider('OpenMapSurfer.ElementsAtRisk'); //Useless map
//Hydda
baselayers['Hydda.Full'] = L.tileLayer.provider('Hydda.Full');
baselayers['Hydda.Base'] = L.tileLayer.provider('Hydda.Base');
baselayers['Hydda.RoadsAndLabels'] = L.tileLayer.provider('Hydda.RoadsAndLabels');
//Stamen
baselayers['Stamen.Toner'] = L.tileLayer.provider('Stamen.Toner');
baselayers['Stamen.TonerBackground'] = L.tileLayer.provider('Stamen.TonerBackground');
baselayers['Stamen.TonerLite'] = L.tileLayer.provider('Stamen.TonerLite');
baselayers['Stamen.TonerLabels'] = L.tileLayer.provider('Stamen.TonerLabels');
baselayers['Stamen.Watercolor'] = L.tileLayer.provider('Stamen.Watercolor');
baselayers['Stamen.Terrain'] = L.tileLayer.provider('Stamen.Terrain');
baselayers['Stamen.TerrainBackground'] = L.tileLayer.provider('Stamen.TerrainBackground');
baselayers['Stamen.TopOSMRelief'] = L.tileLayer.provider('Stamen.TopOSMRelief');
baselayers['Stamen.TopOSMFeatures'] = L.tileLayer.provider('Stamen.TopOSMFeatures');
//MtbMap
//baselayers['MtbMap'] = L.tileLayer.provider('MtbMap'); //This doesn't seem to work?
//CartoDB
baselayers['CartoDB.Positron'] = L.tileLayer.provider('CartoDB.Positron');
baselayers['CartoDB.PositronNoLabels'] = L.tileLayer.provider('CartoDB.PositronNoLabels');
//baselayers['CartoDB.PositronOnlyLabels'] = L.tileLayer.provider('CartoDB.PositronOnlyLabels'); //Useless map
baselayers['CartoDB.DarkMatter'] = L.tileLayer.provider('CartoDB.DarkMatter');
baselayers['CartoDB.DarkMatterNoLabels'] = L.tileLayer.provider('CartoDB.DarkMatterNoLabels');
//baselayers['CartoDB.DarkMatterOnlyLabels'] = L.tileLayer.provider('CartoDB.DarkMatterOnlyLabels'); //Useless map
baselayers['CartoDB.Voyager'] = L.tileLayer.provider('CartoDB.Voyager');
baselayers['CartoDB.VoyagerNoLabels'] = L.tileLayer.provider('CartoDB.VoyagerNoLabels');
//baselayers['CartoDB.VoyagerOnlyLabels'] = L.tileLayer.provider('CartoDB.VoyagerOnlyLabels'); //Useless Map
baselayers['CartoDB.VoyagerLabelsUnder'] = L.tileLayer.provider('CartoDB.VoyagerLabelsUnder');
//HikeBike
baselayers['HikeBike.HikeBike'] = L.tileLayer.provider('HikeBike.HikeBike');
//baselayers['HikeBike.HillShading'] = L.tileLayer.provider('HikeBike.HillShading'); //Useless map?
//BasemapAT //These don't seem to work
//baselayers['BasemapAT.basemap'] = L.tileLayer.provider('BasemapAT.basemap');
//baselayers['BasemapAT.grau'] = L.tileLayer.provider('BasemapAT.grau');
//baselayers['BasemapAT.overlay'] = L.tileLayer.provider('BasemapAT.overlay');
//baselayers['BasemapAT.highdpi'] = L.tileLayer.provider('BasemapAT.highdpi');
//baselayers['BasemapAT.orthofoto'] = L.tileLayer.provider('BasemapAT.orthofoto');
//GeoportailFrance
//baselayers['GeoportailFrance.parcels'] = L.tileLayer.provider('GeoportailFrance.parcels'); //Useless map?
baselayers['GeoportailFrance.ignMaps'] = L.tileLayer.provider('GeoportailFrance.ignMaps');
baselayers['GeoportailFrance.maps'] = L.tileLayer.provider('GeoportailFrance.maps');
baselayers['GeoportailFrance.orthos'] = L.tileLayer.provider('GeoportailFrance.orthos');
//OneMapSG -- These don't seem to work?
//baselayers['OneMapSG.Default'] = L.tileLayer.provider('OneMapSG.Default');
//baselayers['OneMapSG.Night'] = L.tileLayer.provider('OneMapSG.Night');
//baselayers['OneMapSG.Original'] = L.tileLayer.provider('OneMapSG.Original');
//baselayers['OneMapSG.Grey'] = L.tileLayer.provider('OneMapSG.Grey');
//baselayers['OneMapSG.LandLot'] = L.tileLayer.provider('OneMapSG.LandLot');
//NASAGIBS -- These don't seem to work?
//baselayers['NASAGIBS.ModisTerraTrueColorCR'] = L.tileLayer.provider('NASAGIBS.ModisTerraTrueColorCR');
//baselayers['NASAGIBS.ModisTerraBands367CR'] = L.tileLayer.provider('NASAGIBS.ModisTerraBands367CR');
//baselayers['NASAGIBS.ViirsEarthAtNight2012'] = L.tileLayer.provider('NASAGIBS.ViirsEarthAtNight2012');
//baselayers['NASAGIBS.ModisTerraLSTDay'] = L.tileLayer.provider('NASAGIBS.ModisTerraLSTDay');
//baselayers['NASAGIBS.ModisTerraSnowCover'] = L.tileLayer.provider('NASAGIBS.ModisTerraSnowCover');
//baselayers['NASAGIBS.ModisTerraAOD'] = L.tileLayer.provider('NASAGIBS.ModisTerraAOD');
//baselayers['NASAGIBS.ModisTerraChlorophyl'] = L.tileLayer.provider('NASAGIBS.ModisTerraChlorophyl');
//Others
//baselayers['NLS'] = L.tileLayer.provider('NLS'); -- This doesn't seem to work?
//baselayers['FreeMapSK'] = L.tileLayer.provider('FreeMapSK'); -- This doesn't seem to work?
//Mapbox -- In order to use Mapbox layers, you must register. Once registered, you need to define the MapBoxAccessToken variable near top of the code
//Sign-up here https://account.mapbox.com/
if(MapBoxAccessToken.length > 0){
baselayers['MapBox'] = L.tileLayer.provider('MapBox', {accessToken: MapBoxAccessToken});
};
//baselayers['nlmaps'] = L.tileLayer.provider('nlmaps'); -- This doesn't seem to work?
baselayers['Wikimedia'] = L.tileLayer.provider('Wikimedia');
//Esri/ArcGIS
if(ArcGIS){
baselayers['Esri.WorldStreetMap'] = L.tileLayer.provider('Esri.WorldStreetMap');
baselayers['Esri.DeLorme'] = L.tileLayer.provider('Esri.DeLorme');
baselayers['Esri.WorldTopoMap'] = L.tileLayer.provider('Esri.WorldTopoMap');
baselayers['Esri.WorldImagery'] = L.tileLayer.provider('Esri.WorldImagery');
baselayers['Esri.WorldTerrain'] = L.tileLayer.provider('Esri.WorldTerrain');
baselayers['Esri.WorldShadedRelief'] = L.tileLayer.provider('Esri.WorldShadedRelief');
baselayers['Esri.WorldPhysical'] = L.tileLayer.provider('Esri.WorldPhysical');
baselayers['Esri.OceanBasemap'] = L.tileLayer.provider('Esri.OceanBasemap');
baselayers['Esri.NatGeoWorldMap'] = L.tileLayer.provider('Esri.NatGeoWorldMap');
baselayers['Esri.WorldGrayCanvas'] = L.tileLayer.provider('Esri.WorldGrayCanvas');
};
//Thunderforest
if(ThunderforestAPIKey.length > 0){
baselayers['Thunderforest.OpenCycleMap'] = L.tileLayer.provider('Thunderforest.OpenCycleMap', {apikey: ThunderforestAPIKey});
baselayers['Thunderforest.Transport'] = L.tileLayer.provider('Thunderforest.Transport', {apikey: ThunderforestAPIKey});
baselayers['Thunderforest.TransportDark'] = L.tileLayer.provider('Thunderforest.TransportDark', {apikey: ThunderforestAPIKey});
baselayers['Thunderforest.SpinalMap'] = L.tileLayer.provider('Thunderforest.SpinalMap', {apikey: ThunderforestAPIKey});
baselayers['Thunderforest.Landscape'] = L.tileLayer.provider('Thunderforest.Landscape', {apikey: ThunderforestAPIKey});
baselayers['Thunderforest.Outdoors'] = L.tileLayer.provider('Thunderforest.Outdoors', {apikey: ThunderforestAPIKey});
baselayers['Thunderforest.Pioneer'] = L.tileLayer.provider('Thunderforest.Pioneer', {apikey: ThunderforestAPIKey});
};

//WUG Devices/Groups
var overlays = {
	"WhatsUp Gold - Devices": deviceLayerGroup,
	"WhatsUp Gold - Groups" : groupsLayerGroup
};

if(OpenWeatherMapAPIKey.length > 0){
//Add weather overlays 05-30-2019 changed these to overlays instead of baselayers.
overlays['OpenWeatherMap.Clouds'] = L.tileLayer.provider('OpenWeatherMap.Clouds', {apiKey: OpenWeatherMapAPIKey});
overlays['OpenWeatherMap.CloudsClassic'] = L.tileLayer.provider('OpenWeatherMap.CloudsClassic', {apiKey: OpenWeatherMapAPIKey});
overlays['OpenWeatherMap.Precipitation'] = L.tileLayer.provider('OpenWeatherMap.Precipitation', {apiKey: OpenWeatherMapAPIKey});
overlays['OpenWeatherMap.PrecipitationClassic'] = L.tileLayer.provider('OpenWeatherMap.PrecipitationClassic', {apiKey: OpenWeatherMapAPIKey});
overlays['OpenWeatherMap.Rain'] = L.tileLayer.provider('OpenWeatherMap.Rain', {apiKey: OpenWeatherMapAPIKey});
overlays['OpenWeatherMap.RainClassic'] = L.tileLayer.provider('OpenWeatherMap.RainClassic', {apiKey: OpenWeatherMapAPIKey});
overlays['OpenWeatherMap.Pressure'] = L.tileLayer.provider('OpenWeatherMap.Pressure', {apiKey: OpenWeatherMapAPIKey});
overlays['OpenWeatherMap.Wind'] = L.tileLayer.provider('OpenWeatherMap.Wind', {apiKey: OpenWeatherMapAPIKey});
overlays['OpenWeatherMap.Temperature'] = L.tileLayer.provider('OpenWeatherMap.Temperature', {apiKey: OpenWeatherMapAPIKey});
overlays['OpenWeatherMap.Snow'] = L.tileLayer.provider('OpenWeatherMap.Snow', {apiKey: OpenWeatherMapAPIKey});
};

var control = L.control.layers(baselayers, overlays, {collapsed: true, sortLayers: false}).addTo(map);
L.control.scale().addTo(map);

//Add the map layer
baselayers[defaultMapLayer].addTo(map);
aDefaultOverlay.forEach(function(defaultOverlay){
overlays[defaultOverlay].addTo(map);
})

//grab map center and zoom level each tme a zoom is ended
 map.on("zoomend", function(){
  var zoomLev = map.getZoom();
  var lat = map.getCenter().lat;
  var lng = map.getCenter().lng;
  // Save data to sessionStorage
  sessionStorage.setItem('zoomLev', zoomLev);
  sessionStorage.setItem('lat', lat);
  sessionStorage.setItem('lng', lng);
  });    	
//grab map center each time a drag is ended
 map.on("dragend", function(){
  var lat = map.getCenter().lat;
  var lng = map.getCenter().lng;
  // Save data to sessionStorage
  sessionStorage.setItem('lat', lat);
  sessionStorage.setItem('lng', lng);
  });
}; //end initialize function

//Check if layer active
function IsLayerActive(sLayerName) {
 return map.hasLayer(sLayerName);
}
//Refresh device markers
function refreshMarkers(){
 var removed = removeMarkers();
 //console.log(removed);
 if(removed.devicesRemoved == 1){ 
 deviceLayerGroup.addTo(map)};
 if(removed.groupsRemoved == 1){ 
 groupsLayerGroup.addTo(map)};
};

//function to removeMarkers
function removeMarkers(){
//Devices
var devicesRemoved = 0
console.log("Device layer group active:" + IsLayerActive(deviceLayerGroup));
if(IsLayerActive(deviceLayerGroup) == true) {
 console.log("Removing deviceLayerGroup markers for refresh");
 //map.removeLayer(deviceLayerGroup)
 deviceLayerGroup.clearLayers();
 devicesRemoved = 1};
//Groups
console.log("Groups layer group active:" + IsLayerActive(groupsLayerGroup));
var groupsRemoved = 0
if(IsLayerActive(groupsLayerGroup) == true) {
 console.log("Removing groupsLayerGroup markers for refresh");
 //map.removeLayer(groupsLayerGroup)
 groupsLayerGroup.clearLayers();
 groupsRemoved = 1};
//return if the devices/groups were removed or not
return {devicesRemoved, groupsRemoved};
}; //End function

//function to add Device Layer Group
function addDeviceMarkers(nmGroups) {
//Begin loop to add markers to map
for (var i = 0; i < nmGroups.length; i++) {
 var g = nmGroups[i];
 //This section allows you to use your own icon, you will need to comment out the other var sIcon to use this one instead
 //Manual icon
 if (g.nBestStateID == -1) {
  var sIcon = "/NmConsole/resources/Wug/images/MapLegend/I_Legend_DeviceUnknown.svg";
 }
 else if (g.nWorstStateID == 1 && g.nBestStateID == 3) {
  //Up with down monitors
  var sIcon = "/NmConsole/resources/Wug/images/MapLegend/I_Legend_DeviceUpMonitorDown_Green.svg";
 }
 else if (g.nWorstStateID == 3 && g.nWorstStateID == 3) {
  //Up device
  var sIcon = "/NmConsole/resources/Wug/images/MapLegend/I_Legend_DeviceUp.svg";
 }
 else if (g.nWorstStateID == 2 || g.nBestStateID == 2) {
  //Maintenance
  var sIcon = "/NmConsole/resources/Wug/images/MapLegend/I_Legend_DeviceMaintenance.svg";
 }
 else if (g.nWorstStateID == 1 && g.nBestStateID == 1) {
  //Down Device
  var sIcon = "/NmConsole/resources/Wug/images/MapLegend/I_Legend_DeviceDown.svg";
 }
//This is the default "Device Icon", you will need to comment out the other var sIcon to use this one instead -- for v2016 and below
//var sIcon = "/NMConsole/CoreNM/CoreAsp/RenderSmallIcon.asp?nWorstMonitorStateID=" + g.nWorstStateID +	"&nBestMonitorStateID=" + g.nBestStateID + "&nIconType=3&sBackgroundColor=010101&nsize=16";
 var pos = g.sValue.split(",");
 if (pos.length != 2) continue;
 if (isNaN(pos[0]) || isNaN(pos[1])) continue;
 pos[0] = parseFloat(pos[0]);
 pos[1] = parseFloat(pos[1]);
 //Grab the display name as a variable
 var sDisplayName = g.sDisplayName
 var nDeviceID = g.nDeviceID
 var sLatLong = pos[0] + "," + pos[1]
 var sTooltip = sDisplayName
 //This formats the status, removing |, numbers before monitor name, and changing ; to ,
 var sStatus = g.sStatus;
 var sStatusReplace = sStatus.replace(/([0-9])/g, '');
 sStatusReplace = sStatusReplace.replace(/(\|)/g, '');
 sStatusReplace = sStatusReplace.split(';').join(', ');
 var sStatusReplaceLength = sStatusReplace.length;
 sStatusReplace = sStatusReplace.substring(0, sStatusReplaceLength-2);
 var sStatusReplaceLength = (sStatusReplace.length)
 if (sStatusReplaceLength > 0) {
  sStatusReplace = 'Monitors that down: ' + sStatusReplace
 }
 else {
  sStatusReplace = 'All monitors are up!'
 }
 //Create the marker		
 var myIcon = L.icon({
  iconUrl: sIcon,
  iconRetinaUrl: sIcon,
  iconSize: [16, 16],
  iconAnchor: [16, 16]});
 //Add the marker to the map
 var marker = new L.marker([pos[0], pos[1]],{icon:myIcon, nDeviceID:nDeviceID, title:sStatusReplace})
  .on('click', onClickDevice)
	.bindTooltip(sTooltip, {permanent: bAlwaysShow, direction: 'auto'});
	console.log("Adding marker " + sTooltip +" to deviceLayerGroup " + pos[0] + "," + pos[1]);
	deviceLayerGroup.addLayer(marker);
 } //End loop
}; //End function
//When clicked, marker runs this function
function onClickDevice(e) {window.open('/NmConsole/#v=Wug_view_dashboard_DeviceStatus/p=%7B%22deviceId%22%3A' + e.target.options.nDeviceID  + '%7D', '_blank');}
function addGroupMarkers(nmGroups) {
//Begin loop to add markers to map
for (var i = 0; i < nmGroups.length; i++) {
 var g = nmGroups[i];
 //This section allows you to use your own icon, you will need to comment out the other var sIcon to use this one instead
 if (g.nMonitorStateID == -1) {
  //Unknown
	//var groupIcon = "/NmConsole/resources/images/DeviceGroup/I_StaticGroup.svg";
	groupIcon = "/NmConsole/resources/Wug/images/MapLegend/I_Legend_DeviceUnknown.svg";
	}
	else if (g.nMonitorStateID == 3) {
	 //Up
	 //var groupIcon = "/NmConsole/resources/images/DeviceGroup/I_StaticGroupUp.svg";	
	 groupIcon = "/NmConsole/resources/Wug/images/MapLegend/I_Legend_DeviceUp.svg";
	}
	else if (g.nMonitorStateID == 2) {
	 //Maintenance
	 //var groupIcon = "/NmConsole/resources/images/DeviceGroup/I_StaticGroupMaintenance.svg";
	 groupIcon = "/NmConsole/resources/Wug/images/MapLegend/I_Legend_DeviceMaintenance.svg";
  } 
// else groupIcon = "/NmConsole/resources/images/DeviceGroup/I_StaticGroupDown.svg"; //Down
else groupIcon = "/NmConsole/resources/Wug/images/MapLegend/I_Legend_DeviceDown.svg"; //Down
 var pos = g.sNote.split(",");
 if (pos.length != 2) continue;
 if (isNaN(pos[0]) || isNaN(pos[1])) continue;
 pos[0] = parseFloat(pos[0]);
 pos[1] = parseFloat(pos[1]);
 //Grab the display name as a variable
 var sGroupName = g.sGroupName
 var nDeviceGroupID = g.nDeviceGroupID
 var sLatLong = pos[0] + "," + pos[1]
 //var sTooltip = sGroupName + " | " + sLatLong
 var sTooltip = sGroupName
 //Create the marker		
 var myIcon = L.icon({
  iconUrl: groupIcon,
  iconRetinaUrl: groupIcon,
  iconSize: [16, 16],
  iconAnchor: [8, 8],
  labelAnchor: [0, 0]});
 //Add the marker to the map
 var marker = new L.marker([pos[0], pos[1]],{icon:myIcon, nDeviceGroupID:nDeviceGroupID, title:sLatLong})
  .on('click', onClickGroup)
  .bindTooltip(sTooltip, {permanent: bAlwaysShow, direction: 'bottom'});
	console.log("Adding marker " + sTooltip +" to groupsLayerGroup");
	groupsLayerGroup.addLayer(marker);
 }//End loop
}; //End function
//When clicked, marker runs this function
function onClickGroup(e) {window.open('/NmConsole/#home/p=%7B%22groupId%22%3A' + e.target.options.nDeviceGroupID  + '%2C%22autoLayout%22%3Atrue%7D', '_blank');}
//layout
(function ($) {
 Nm.loadScript = function() {}; //This stops unnecessary WhatsUp Gold scripts from loading
 var layoutList,	scrollToSelected;
 var prevDeviceListControlsheight = null;
 layoutList = function () {
  var $ = jQuery;
  var navcontainer = $("#navcontainer");
  var titlebar = $("#titlebar");
  var mapArea = $("#map");
  var navHeight = navcontainer.outerHeight(true) || 0;
  var contentHeight = $(window).height() - (titlebar.outerHeight(true) + navHeight);
  mapArea.css("height", contentHeight + "px");
  if (isInitialized == false){initialize();}
  $.get("leafletquery_devices.asp", {dynamicGroupName: sDynamicGroupName, bUseBuiltin : bUseBuiltin}, function (data){
  var aMarkers = JSON.parse(data);
  addDeviceMarkers(aMarkers);
  deviceLayerGroup.addTo(map)
  });
  $.get("leafletquery_groups.asp", {dynamicGroupName: sDynamicGroupName}, function (data){
  var aMarkers = JSON.parse(data);
  addGroupMarkers(aMarkers);
  groupsLayerGroup.addTo(map)
	});
	};	
 //apply the layout after 600ms (allow time for .js to load)
 $(window).resize(layoutList);
 setTimeout(layoutList, 600);
 // Reload markers every X seconds
 setInterval(function() {
  refreshMarkers();
  $.get("leafletquery_devices.asp", {dynamicGroupName: sDynamicGroupName, bUseBuiltin : bUseBuiltin}, function (data){
  var aDeviceMarkers = JSON.parse(data);
  addDeviceMarkers(aDeviceMarkers);
  });
  $.get("leafletquery_groups.asp", {dynamicGroupName: sDynamicGroupName}, function (data){
  var aGroupMarkers = JSON.parse(data);
  addGroupMarkers(aGroupMarkers);
  });
 }, nRefreshInterval * 1000);
})(jQuery);
//Script End
</script>
</div>