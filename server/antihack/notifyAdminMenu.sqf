// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: notifyAdminMenu.sqf
//	@file Author: AgentRev
//	@file Created: 02/01/2014 00:12

// This function was created with the purpose of letting players know when an admin is abusing his powers

if !([getPlayerUID player, 3] call isAdmin) exitWith {};

private ["_action", "_value", "_cfg", "_displayStr", "_message"];

_action = param [0, "", [""]];
_value = param [1, "", [0,"",[]]];

switch (toLower _action) do
{
	case "money":
	{
		if (_value > 0) then
		{
			_message = format ["[NOTICE] %1 used the admin menu to obtain $%2", name player, _value];
		};
	};
	case "teleport":
	{
		_value resize 2;
		{ _value set [_forEachIndex, round _x] } forEach _value;
	};
	case "vehicle":
	{
		_cfg = configFile >> "CfgVehicles" >> _value;
	};
	case "weapon":
	{
		_cfg = configFile >> "CfgWeapons" >> _value;
	};
	case "ammo":
	{
		_cfg = configFile >> "CfgMagazines" >> _value;
	};
};

if (!isNil "_cfg" && {isClass _cfg}) then
{
	_displayStr = getText (_cfg >> "displayName");
	if (_displayStr == "") then { _displayStr = _value } else { _value = _displayStr };

	_message = format ['[NOTICE] %1 used the admin menu to obtain a "%2"', profileName, _displayStr];
};

if (!isNil "_message" && {_message != ""}) then
{
	[[_message, getPlayerUID player, _flagChecksum, true], "A3W_fnc_chatBroadcast", true] call A3W_fnc_MP;
};

[[profileName, getPlayerUID player, _action, _value, _flagChecksum], "A3W_fnc_adminMenuLog", false] call A3W_fnc_MP;
