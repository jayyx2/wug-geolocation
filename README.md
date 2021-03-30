These 3 files allow you to place devices or groups on a map using geolocation. Drop them in %InstallDir%\Ipswitch\WhatsUp\HTML\NmConsole. You provide Latitude and Longitude values on the group description using the format lat,lng and/or add a device attribute named 'LatLong' with value of lat,lng. I use https://getlatlong.net/ to lookup mine, but you could use whatever you'd like that provides the information.

Example Device Attribute:
ATTRIBUTE NAME      ATTRIBUE VALUE
LatLong             28.719536,-81.507397

Example Device Group description:
  28.719536,-81.507397

Big changes include: No longer an ASP file, using external jQuery so we can use the latest release and ditch dependencies on old WhatsUp Gold web interface files, more map providers added, some baselayers converted to overlays, some bug fixes, and more!

Some of the map providers require API keys and/or agreeing to their terms of service. You must abide by all of the map providers terms of service, I will not be held responsible if you don't! Note there are many variables which can be changed in wug-geolocation.html. They are commented to clarify what each option does.

//All credit goes to Leaflet contributors for leaflet.js and leaflet.css
//You can download leaflet.js and leaflet.css from https://leafletjs.com/download.html

//All credit goes to Leaflet-Extras contributors for Leaflet-providers.js
//You can be download the file from here: https://github.com/leaflet-extras/leaflet-providers credit to leaflet-extras members

/*!
 * jQuery JavaScript Library v3.6.0
 * https://jquery.com/
 *
 * Includes Sizzle.js
 * https://sizzlejs.com/
 *
 * Copyright OpenJS Foundation and other contributors
 * Released under the MIT license
 * https://jquery.org/license
 *
 * Date: 2021-03-02T17:08Z
 */
