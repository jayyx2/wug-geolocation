These 3 .ASP files allow you to place devices or groups on a map using geolocation. You provide Latitude and Longitude values on the group description using the format lat,lng and/or add a device attribute named 'LatLong' with value of lat,lng

Some of the map providers require API keys and/or agreeing to their terms of service. You must abide by all of the map providers terms of service, I will not be held responsible if you don't!

Note the variables to be changed in wug-geolocation.asp. They are commented to clarify what each option does. 

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
