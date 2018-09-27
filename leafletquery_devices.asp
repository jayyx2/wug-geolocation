<%@ language="jscript" %>
<!--#include virtual="/NmConsole/CoreNm/Database/Database.inc"-->
<!--#include virtual="/NmConsole/Core/Ajax/JSON.inc"-->

<%
var oDb = GetDb();
var groups = [];
// name of the dynamic group you want to display
var sDynamicGroupName = Request.QueryString("dynamicGroupName").Item;

//Query dataabase for dynamic group filter
var sSql1 = "select sFilter from devicegroup where sGroupName = '" + sDynamicGroupName + "'";
var oResult = oDb.ExecSql(sSql1);	
if (oResult.Failed){
 //Failed to load the data
 }
if (oDb.IsEOF){
 //No data
 }
while (!oDb.IsEOF){
 var sGroupFilter = oDb.GetFieldAsString("sFilter");
 oDb.MoveNext();
}

//Query database for devices with lat/long information that also match the dynamic group filter
var sSql = "select D.nDeviceID, D.nDeviceTypeID, D.sDisplayName, sValue, nWorstStateID, nBestStateID, sStatus from DeviceAttribute DA " +
"join Device D on D.nDeviceID = DA.nDeviceID where (sName = 'LatLong' and sValue is not null and D.nDeviceID in (" + sGroupFilter + "))";
var oResult = oDb.ExecSql(sSql);
if (oResult.Failed) {
	// Failed to load the group data
} else if(oDb.IsEOF) {
	// No group data found
} else {
	// add all the devices from the specified group
	while(!oDb.IsEOF)
	{
		groups.push({
			nDeviceID: oDb.GetFieldAsLong("nDeviceID"),
			sValue: oDb.GetFieldAsString("sValue"),
			nDeviceTypeID: oDb.GetFieldAsLong("nDeviceTypeID"),
			nWorstStateID: oDb.GetFieldAsLong("nWorstStateID"),
			nBestStateID: oDb.GetFieldAsLong("nBestStateID"),
			sDisplayName: oDb.GetFieldAsString("sDisplayName"),
			sStatus: oDb.GetFieldAsString("sStatus")
		});
		oDb.MoveNext();
	}
}
Response.Write(JSON.ToString(groups))
%>