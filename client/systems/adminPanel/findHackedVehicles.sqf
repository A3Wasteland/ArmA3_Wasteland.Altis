//	@file Version: 1.0
//	@file Name: findHackedVehicles.sqf
//	@file Author: AgentRev
//	@file Created: 09/06/2013 16:56

private ["_queryChecksum", "_hackedVehicles"];
_queryChecksum = call generateKey;

hackedVehicles = nil;

while {isNil "hackedVehicles" || {[hackedVehicles, 1, "", [""]] call BIS_fnc_param != _queryChecksum}} do
{
	hackedVehicles = nil;
	"hackedVehicles" addPublicVariableEventHandler {};	
	
	[[player, _queryChecksum], "checkHackedVehicles", false, false] call TPG_fnc_MP;
	
	waitUntil {!isNil "hackedVehicles"};
};

_hackedVehicles = + (hackedVehicles select 0);
hackedVehicles = nil;

{
	_hackedVehicles set [_forEachIndex, [objectFromNetId (_x select 0), toString (_x select 1)]];
} forEach _hackedVehicles;

_hackedVehicles