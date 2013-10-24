//	@file Version: 1.0
//	@file Name: checkHackedVehicles.sqf
//	@file Author: AgentRev
//	@file Created: 09/06/2013 16:29

if (!isServer) exitWith {};

private ["_array", "_client", "_key", "_hackedVehicles", "_owner", "_name"];

_client = _this select 0;
_key = _this select 1;
_hackedVehicles = [];

{
	_check = _x getVariable [call vChecksum, false];
	
	if ((_x isKindOf "ReammoBox_F" && {owner _x > 1}) || {!(_x isKindOf "ReammoBox_F") && {typeName _check == "BOOL"} && {!_check}}) then
	{
		_owner = [owner _x] call findClientPlayer;
		
		if (isPlayer _owner) then
		{
			_name = name _owner;
		}
		else
		{
			_name = "";
		};
		
		_hackedVehicles set [count _hackedVehicles, [netId _x, toArray _name]];
	};
} forEach vehicles;

[[[_hackedVehicles], compile format ["%1 = _this select 0", _key]], "BIS_fnc_spawn", _client, false] call TPG_fnc_MP;
