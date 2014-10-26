// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: bannedNames.sqf
//	@file Author: AgentRev
//	@file Created: 14/07/2013 12:03

if (isServer) exitWith {};

private ["_bannedNames", "_name", "_trueName"];

waitUntil {sleep 1; !isNil "bannedPlayerNames"};

_bannedNames = call bannedPlayerNames;
_name = profileName;
_trueName = [];

{
	if (_name == _x) exitWith
	{
		[format ['The name "%1" is not allowed, please change it or you may get kicked.', name player], "Notice"] spawn BIS_fnc_guiMessage;
	}
} forEach _bannedNames;

{
	if ((_x > 32 && _x < 127) || (_x > 160 && _x < 383)) then
	{
		_trueName pushBack _x;
	}
} forEach toArray _name;

_trueName = toString _trueName;

if (_trueName == "") then
{
	[format ['The name "%1" is not allowed, please change it or you may get kicked.', name player], "Notice"] spawn BIS_fnc_guiMessage;
};
