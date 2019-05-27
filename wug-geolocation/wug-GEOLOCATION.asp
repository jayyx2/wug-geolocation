<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
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
<link href="https://cdn.jsdelivr.net/gh/Leaflet/Leaflet@1.5.1/dist/leaflet.css" rel="stylesheet" type="text/css" />
<script src="https://cdn.jsdelivr.net/gh/Leaflet/Leaflet@1.5.1/dist/leaflet.js">
//All credit to Leaflet contributors.
//You can download leaflet.js and leaflet.css from https://leafletjs.com/download.html</script>
<script src="https://cdn.jsdelivr.net/gh/leaflet-extras/leaflet-providers@1.7.0/leaflet-providers.js">
//All credit to Leaflet-Extras contributors.
//You can be download the file from here: https://github.com/leaflet-extras/leaflet-providers credit to leaflet-extras members</script>
<%
Js.initialize();
%>
<!-- This section allows you to change the styling of the tooltips used -->
<style>
.leaflet-tooltip {color: Goldenrod;background-color: black;font-family: "Lucida Grande", "Arial", sans-serif;font-size: 12px;font-weight: bold;text-align: center;white-space: nowrap;}
</style>
<div id='map'>
<script type="text/javascript">
///******************************
///VARIABLES THAT CAN BE CHANGED*
///******************************
var defaultLat = parseFloat(37.077979); //Default latitude
var defaultLong = parseFloat(-96.991419); //Default longitude
var defaultZoom = 5; //Default zoom, higher number is closer
var HEREappId = ""; //This is your appId, to acquire one sign-up for free here: https://developer.here.com/
var HEREappCode = ""; //This is your appCode, to acquire one sign-up for free here: https://developer.here.com/ 
var ThunderforestAPIKey = "" // In order to use Thunderforest maps, you must register. https://thunderforest.com/pricing/ (Tiles per month 150,000 free)
var ArcGIS = false //Set to true once registered. In order to use ArcGIS maps, you must register at https://developers.arcgis.com/en/sign-up/ and abide by the terms of service. No special syntax is required.
var defaultMapLayer = "Wikimedia"; //This is the default map tile used
var sDynamicGroupName = "All devices (dynamic group)";//This is the name of the dynamic group to get the device data from, default is all devices
var nRefreshInterval = 60 //Seconds to wait between refreshing markers
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
//HERE (formerly Nokia). In order to use HERE layers, you must register. Once registered, you can create an app_id and app_code
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
baselayers['HERE.redcuedDay'] = L.tileLayer.provider('HERE.redcuedDay', {app_id: HEREappId, app_code: HEREappCode});
baselayers['HERE.redcuedNight'] = L.tileLayer.provider('HERE.redcuedNight', {app_id: HEREappId, app_code: HEREappCode});
}
//OpenStreetMap
baselayers['OpenStreetMap.Mapnik'] = L.tileLayer.provider('OpenStreetMap.Mapnik');
baselayers['OpenStreetMap.BlackAndWhite'] = L.tileLayer.provider('OpenStreetMap.BlackAndWhite');
baselayers['OpenStreetMap.HOT'] = L.tileLayer.provider('OpenStreetMap.HOT');
baselayers['OpenTopoMap'] = L.tileLayer.provider('OpenTopoMap');
baselayers['OpenMapSurfer.Roads'] = L.tileLayer.provider('OpenMapSurfer.Roads');
baselayers['OpenMapSurfer.Grayscale'] = L.tileLayer.provider('OpenMapSurfer.Grayscale');
//Hydda
baselayers['Hydda.Full'] = L.tileLayer.provider('Hydda.Full');
baselayers['Hydda.Base'] = L.tileLayer.provider('Hydda.Base');
//Stamen
baselayers['Stamen.Toner'] = L.tileLayer.provider('Stamen.Toner');
baselayers['Stamen.TonerBackground'] = L.tileLayer.provider('Stamen.TonerBackground');
baselayers['Stamen.TonerLite'] = L.tileLayer.provider('Stamen.TonerLite');
baselayers['Stamen.Watercolor'] = L.tileLayer.provider('Stamen.Watercolor');
baselayers['Stamen.Terrain'] = L.tileLayer.provider('Stamen.Terrain');
baselayers['Stamen.TerrainBackground'] = L.tileLayer.provider('Stamen.TerrainBackground');
baselayers['Stamen.TopOSMRelief'] = L.tileLayer.provider('Stamen.TopOSMRelief');
//MtbMap
baselayers['MtbMap'] = L.tileLayer.provider('MtbMap');
//CartoDB
baselayers['CartoDB.Positron'] = L.tileLayer.provider('CartoDB.Positron');
baselayers['CartoDB.PositronNoLabels'] = L.tileLayer.provider('CartoDB.PositronNoLabels');
baselayers['CartoDB.DarkMatter'] = L.tileLayer.provider('CartoDB.DarkMatter');
baselayers['CartoDB.DarkMatterNoLabels'] = L.tileLayer.provider('CartoDB.DarkMatterNoLabels');
baselayers['CartoDB.Voyager'] = L.tileLayer.provider('CartoDB.Voyager');
baselayers['CartoDB.VoyagerNoLabels'] = L.tileLayer.provider('CartoDB.VoyagerNoLabels');
baselayers['CartoDB.VoyagerLabelsUnder'] = L.tileLayer.provider('CartoDB.VoyagerLabelsUnder');
baselayers['HikeBike.HikeBike'] = L.tileLayer.provider('HikeBike.HikeBike');
baselayers['NASAGIBS.ViirsEarthAtNight2012'] = L.tileLayer.provider('NASAGIBS.ViirsEarthAtNight2012');
baselayers['Wikimedia'] = L.tileLayer.provider('Wikimedia');
baselayers['GeoportailFrance.ignMaps'] = L.tileLayer.provider('GeoportailFrance.ignMaps');
baselayers['GeoportailFrance.maps'] = L.tileLayer.provider('GeoportailFrance.maps');
baselayers['GeoportailFrance.orthos'] = L.tileLayer.provider('GeoportailFrance.orthos');
//Esri/ArcGIS Esri.WorldGrayCanvas
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
}
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
var overlays = {
    "Devices": deviceLayerGroup,
    "Groups" : groupsLayerGroup
};
//Add map/layer control
var control = L.control.layers(baselayers, overlays, {collapsed: true, sortLayers: true}).addTo(map)
L.control.scale().addTo(map);

//Add the map layer
baselayers[defaultMapLayer].addTo(map);
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
 map.removeLayer(deviceLayerGroup)
 devicesRemoved = 1};
//Groups
console.log("Groups layer group active:" + IsLayerActive(groupsLayerGroup));
var groupsRemoved = 0
if(IsLayerActive(groupsLayerGroup) == true) {
 console.log("Removing groupsLayerGroup markers for refresh");
 map.removeLayer(groupsLayerGroup)
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
 var sStatusReplace = sStatus.split('|').join(',');
 sStatusReplace = sStatusReplace.replace(/([0-9].,)/g, '');
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
	.bindTooltip(sTooltip, {direction: 'auto'});
	console.log("Adding marker " + sTooltip +" to deviceLayerGroup");
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
  //Uknown
	groupIcon = "/NmConsole/resources/images/DeviceGroup/I_StaticGroup.svg";
	}
	else if (g.nMonitorStateID == 3) {
	 //Up
	 groupIcon = "/NmConsole/resources/images/DeviceGroup/I_StaticGroupUp.svg";	
	}
	else if (g.nMonitorStateID == 2) {
	 //Maintenance
	 groupIcon = "/NmConsole/resources/images/DeviceGroup/I_StaticGroupMaintenance.svg";
  } 
 else groupIcon = "/NmConsole/resources/images/DeviceGroup/I_StaticGroupDown.svg"; //Down
 var pos = g.sNote.split(",");
 if (pos.length != 2) continue;
 if (isNaN(pos[0]) || isNaN(pos[1])) continue;
 pos[0] = parseFloat(pos[0]);
 pos[1] = parseFloat(pos[1]);
 //Grab the display name as a variable
 var sGroupName = g.sGroupName
 var nDeviceGroupID = g.nDeviceGroupID
 var sLatLong = pos[0] + "," + pos[1]
 var sTooltip = sGroupName + " | " + sLatLong
 //Create the marker		
 var myIcon = L.icon({
  iconUrl: groupIcon,
  iconRetinaUrl: groupIcon,
  iconSize: [24, 24],
  iconAnchor: [16, 16],
  labelAnchor: [6, 0]});
 //Add the marker to the map
 var marker = new L.marker([pos[0], pos[1]],{icon:myIcon, nDeviceGroupID:nDeviceGroupID, title:sGroupName})
  .on('click', onClickGroup)
  .bindTooltip(sTooltip);
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
  $.get("leafletquery_devices.asp", {dynamicGroupName: sDynamicGroupName}, function (data){
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
  $.get("leafletquery_devices.asp", {dynamicGroupName: sDynamicGroupName}, function (data){
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