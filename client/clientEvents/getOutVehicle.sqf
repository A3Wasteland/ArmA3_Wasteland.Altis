// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: getOutVehicle.sqf
//	@file Author: AgentRev

private "_veh";
_veh = _this select 0;

player setAnimSpeedCoef 1;

_veh removeEventHandler ["Engine", _veh getVariable ["A3W_engineEH", -1]];
_veh setVariable ["A3W_engineEH", nil];

//_veh removeEventHandler ["Dammaged", _veh getVariable ["A3W_dammagedEH", -1]];
//_veh setVariable ["A3W_dammagedEH", nil];

{ _veh removeAction _x } forEach (_veh getVariable ["A3W_serviceBeaconActions", []]);
_veh setVariable ["A3W_serviceBeaconActions", nil];
