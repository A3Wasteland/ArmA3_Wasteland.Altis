// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
/*********************************************************#
# @@ScriptName: updateConnectingClients.sqf
# @@Author: Nick 'Bewilderbeest' Ludlam <bewilder@recoil.org>, AgentRev
# @@Create Date: 2013-09-15 16:26:38
# @@Modify Date: 2013-09-15 17:22:37
# @@Function: Updates JIP players with the correct territory colours
#*********************************************************/

if (!isServer) exitWith {};

// Exit if territories are not set
if (isNil "currentTerritoryDetails" || {count currentTerritoryDetails == 0}) exitWith {};

params ["_player", "_JIP"];
private _markers = [];

{
	_x params ["_markerName", "", "_markerTeam"];

	if !(_markerTeam in [sideUnknown,grpNull]) then
	{
		_markers pushBack [_markerName, _markerTeam];
	};
} forEach currentTerritoryDetails;

diag_log format ["updateConnectingClients [Player: %1] [JIP: %2]", _player, _JIP];

[_markers, true] remoteExec ["A3W_fnc_updateTerritoryMarkers", _player];
