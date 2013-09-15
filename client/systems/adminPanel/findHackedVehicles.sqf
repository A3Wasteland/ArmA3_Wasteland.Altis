//	@file Version: 1.0
//	@file Name: findHackedVehicles.sqf
//	@file Author: AgentRev
//	@file Created: 09/06/2013 16:56

private ["_queryChecksum", "_hackedVehicles"];
_queryChecksum = call generateKey;
			
hackedVehicles = nil;

while {	isNil "hackedVehicles" || 
		{typeName hackedVehicles != "ARRAY"} || 
		{count hackedVehicles <= 1} || 
		{typeName (hackedVehicles select 1) != typeName _queryChecksum} ||
		{hackedVehicles select 1 != _queryChecksum} } do
{
	_queryIdent = [player,_queryChecksum];
	hackedVehicles = nil;
	
	"hackedVehicles" addPublicVariableEventHandler compile format
	["
		private '_hackedVehicles';
		_hackedVehicles = _this select 1;
		if (isNil '_hackedVehicles' || {typeName _hackedVehicles != 'ARRAY'} || {count _hackedVehicles <= 1} || {typeName (_hackedVehicles select 1) != typeName _queryChecksum} || {_hackedVehicles select 1 != '%1'}) then
		{
			_this set [1, hackedVehicles];
		};
	", _queryChecksum];
	
	[[player, _queryChecksum], "checkHackedVehicles", false, false] call TPG_fnc_MP;
	
	waitUntil {!isNil "hackedVehicles"};
};

_hackedVehicles = + (hackedVehicles select 0);
hackedVehicles = nil;

{
	_hackedVehicles set [_forEachIndex, [objectFromNetId (_x select 0), _x select 1]];
} forEach _hackedVehicles;

_hackedVehicles