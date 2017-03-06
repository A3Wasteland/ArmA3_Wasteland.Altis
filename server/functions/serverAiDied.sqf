// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2017 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: serverAiDied.sqf
//	@file Author: AgentRev

if (!isServer) exitWith {};

params ["_unit", "_killer", "_instigator"];

private _presumedKiller = effectiveCommander _killer;
private _killerVehicle = vehicle _killer;

if (!isNull _instigator) then
{
	_killer = _instigator;
};

if (isUavConnected _killerVehicle) then
{
	private _uavOwner = (uavControl _killerVehicle) select 0;

	if (!isNull _uavOwner) then
	{
		_killer = _uavOwner;
	};
};

[_unit, _killer, _presumedKiller] call A3W_fnc_serverPlayerDied;
