//	@file Version: 1.0
//	@file Name: notifyAdminMenu.sqf
//	@file Author: AgentRev
//	@file Created: 02/01/2014 00:12

// This function was created with the purpose of letting players know when an admin is abusing his powers

if !([getPlayerUID player, 3] call isAdmin) exitWith {};

private ["_value", "_displayStr", "_message"];
_value = [_this, 0, "", ["",0]] call BIS_fnc_param;

if (typeName _value == "SCALAR" && {_value > 0}) then
{
	_message = format ["[NOTICE] %1 used the admin menu to obtain $%2", name player, _value];
}
else
{
	if (isClass (configFile >> "CfgVehicles" >> _value)) then
	{
		_displayStr = getText (configFile >> "CfgVehicles" >> _value >> "displayName");
	};

	if (isClass (configFile >> "CfgWeapons" >> _value)) then
	{
		_displayStr = getText (configFile >> "CfgWeapons" >> _value >> "displayName");
	};

	if (isClass (configFile >> "CfgMagazines" >> _value)) then
	{
		_displayStr = getText (configFile >> "CfgMagazines" >> _value >> "displayName");
	};
	
	if (!isNil "_displayStr") then
	{
		_message = format ['[NOTICE] %1 used the admin menu to obtain a "%2"', name player, _displayStr];
	};
};

if (!isNil "_message") then
{
	[[_message, getPlayerUID player, _flagChecksum, true], "chatBroadcast", true, false] call TPG_fnc_MP;
};
