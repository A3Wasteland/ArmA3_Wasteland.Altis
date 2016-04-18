// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: FAR_setKillerInfo.sqf
//	@file Author: AgentRev

private ["_target", "_source", "_ammo", "_suspects", "_vehicle", "_killerVehicle", "_uavOwner", "_suspect", "_role"];

_target = _this select 0;
_source = _this select 1;
_ammo = _this select 2;

_suspects = [];
_vehicle = vehicle _target;

if (_vehicle != _target && (isNull _source || _source in [_target, _vehicle])) then // dying unit inside exploding vehicle
{
	_killerVehicle = _vehicle getVariable ["FAR_killerVehicle", objNull];

	if (!isNull _killerVehicle) then
	{
		_source = _killerVehicle;
		_ammo = _vehicle getVariable ["FAR_killerAmmo", ""];
	};

	//diag_log format ["_vehicle = %1 / source = %2", typeOf _vehicle, typeOf _source];
};

if (!isNull _source && !isPlayer _source && {getText (configFile >> "CfgVehicles" >> typeOf _source >> "simulation") == "UAVPilot"}) then
{
	_uavOwner = (uavControl vehicle _source) select 0;

	if (alive _uavOwner) then
	{
		_source = _uavOwner;
	};
};

_target setVariable ["FAR_killerVehicle", _source];

if !(_source isKindOf "CAManBase") then
{
	{
		_suspect = _x select 0;
		_path = _x select 3;

		_suspects pushBack [_suspect, _source magazinesTurret _path, _path];
	} forEach fullCrew [_source, "", false];
};

_target setVariable ["FAR_killerAmmo", _ammo];
_target setVariable ["FAR_killerSuspects", _suspects];

//systemChat format ["FAR_setKillerInfo: %1", [typeOf _target, name _target, typeOf _source, _ammo, _suspects]];
//diag_log format ["FAR_setKillerInfo: %1", [typeOf _target, name _target, typeOf _source, _ammo, _suspects]];
