//	@file Version: 1.0
//	@file Name: checkHackedVehicles.sqf
//	@file Author: AgentRev
//	@file Created: 09/06/2012 16:29

private ["_array", "_client", "_checksum", "_hackedVehicles", "_owner", "_name"];

_client = owner (_this select 0);
_checksum = _this select 1;
_hackedVehicles = [];

{
	_check = _x getVariable [call vChecksum, false];
	
	if ((_x isKindOf "ReammoBox_F" && {owner _x > 1}) || {!(_x isKindOf "ReammoBox_F") && {typeName _check == typeName true} && {!_check}}) then
	{
		_owner = [owner _x] call findClientPlayer;
		
		if (isPlayer _owner) then {
			_name = name _owner;
		}
		else {
			_name = ""
		};
		
		_hackedVehicles set [count _hackedVehicles, [netId _x, _name]];
	};
} forEach vehicles;

[compile format ["hackedVehicles = [%1, '%2']", _hackedVehicles, _checksum], "BIS_fnc_spawn", _client, false] call TPG_fnc_MP;