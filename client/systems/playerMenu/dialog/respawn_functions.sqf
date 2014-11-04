// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: respawn_functions.sqf
//	@file Author: AgentRev

_getPlayersInfo =
{
	private ["_location", "_isBeacon"];
	_location = _this; // spawn beacon object or town marker name
	_isBeacon = (typeName _location == "OBJECT");

	_friendlyUnits = [];
	_friendlyPlayers = 0;
	_friendlyNPCs = 0;
	_enemyPlayers = 0;
	_enemyNPCs = 0;

	if (_isBeacon) then
	{
		_friendlyUnits = _location getVariable ["friendlyUnits", []];
		_friendlyPlayers = _location getVariable ["friendlyPlayers", 0];
		_friendlyNPCs = _location getVariable ["friendlyNPCs", 0];
		_enemyPlayers = _location getVariable ["enemyPlayers", 0];
		_enemyNPCs = _location getVariable ["enemyNPCs", 0];
	}
	else // town
	{
		_friendlyUnits = missionNamespace getVariable [format ["%1_friendlyUnits", _location], []];
		_friendlyPlayers = missionNamespace getVariable [format ["%1_friendlyPlayers", _location], 0];
		_friendlyNPCs = missionNamespace getVariable [format ["%1_friendlyNPCs", _location], 0];
		_enemyPlayers = missionNamespace getVariable [format ["%1_enemyPlayers", _location], 0];
		_enemyNPCs = missionNamespace getVariable [format ["%1_enemyNPCs", _location], 0];
	};
};
