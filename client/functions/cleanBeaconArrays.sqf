// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: cleanBeaconArrays.sqf
//	@file Author: [404] Costlyy
//	@file Created: 08/12/2012 18:30
//	@file Args: [string(ownerUID)]

private["_currBeaconOwnerUID"];

_currBeaconOwnerUID = _this select 0;

{
	if(str(_currBeaconOwnerUID) == str(_x select 3)) then {
		pvar_beaconListBlu set [_forEachIndex, "REMOVETHISCRAP"];
		pvar_beaconListBlu = pvar_beaconListBlu - ["REMOVETHISCRAP"];
		publicVariable "pvar_beaconListBlu";
	};

}forEach pvar_beaconListBlu;

{
	if(str(_currBeaconOwnerUID) == str(_x select 3)) then {
		pvar_beaconListRed set [_forEachIndex, "REMOVETHISCRAP"];
		pvar_beaconListRed = pvar_beaconListRed - ["REMOVETHISCRAP"];
		publicVariable "pvar_beaconListRed";
	};
}forEach pvar_beaconListRed;
