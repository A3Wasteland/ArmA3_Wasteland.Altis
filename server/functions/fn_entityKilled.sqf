// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2018 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_entityKilled.sqf
//	@file Author: AgentRev

if (!isServer) exitWith {};

params ["_entity", "_presumedKiller", "_instigator"];

// AI killed
if (_entity isKindOf "CAManBase" && !isPlayer _entity && {isNil {_entity getVariable "cmoney"} && getText (configFile >> "CfgVehicles" >> typeOf _entity >> "simulation") != "UAVPilot"}) then
{
	[_entity, _presumedKiller, "", _instigator] call FAR_setKillerInfo;

	private _killer = _entity getVariable "FAR_killerUnit";

	if (isNil "_killer" || {isNull _killer}) then
	{
		_killer = [_instigator, _presumedKiller] select isNull _instigator;
	};

	[_entity, effectiveCommander _killer, effectiveCommander _presumedKiller] call A3W_fnc_serverPlayerDied;
};
