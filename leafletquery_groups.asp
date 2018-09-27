<%@ language="jscript" %>
<!--#include virtual="/NmConsole/CoreNm/Database/Database.inc"-->
<!--#include virtual="/NmConsole/Core/Ajax/JSON.inc"-->

<%
var oDb = GetDb();
var groups = [];
//Query database for devices with lat/long information that also match the dynamic group filter
var sSql = "Select * From DeviceGroup Where sNote is not NULL and sNote not like ''";
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
			nDeviceGroupID: oDb.GetFieldAsLong("nDeviceGroupID"),
			sNote: oDb.GetFieldAsString("sNote"),
			nMonitorStateID: oDb.GetFieldAsLong("nMonitorStateID"),
			sGroupName: oDb.GetFieldAsString("sGroupName"),
			sStatus: oDb.GetFieldAsString("sStatus")
		});
		oDb.MoveNext();
	}
}

Response.Write(JSON.ToString(groups))
%>