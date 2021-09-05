// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2017 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_killFeedEntry.sqf
//	@file Author: AgentRev

// server to client

if (isServer && isRemoteExecuted && remoteExecutedOwner isEqualTo clientOwner) exitWith {}; // prevent double-call

if (isServer) then
{
	_this remoteExecCall ["A3W_fnc_killFeedEntry", -([clientOwner,remoteExecutedOwner] select isRemoteExecuted)]; // the remote-executing client will already have called this function locally, hence why it's excluded
};

if (!hasInterface) exitWith {};

#include "killFeed_defines.hpp"

private _killTime = diag_tickTime;
private _killTimeStamp = [_killTime / 3600] call BIS_fnc_timeToString;

params [["_killParams",[],[[]]]];
[] params _killParams; // automagically assign all _killParams variables defined at the bottom of fn_killBroadcast.sqf

diag_log ("_killParams = " + str _killParams);

if (_killerName isEqualTo "Error: No vehicle" && _killerSide isEqualTo sideUnknown) then
{
	_killerName = "";
};

private _killerNameEncoded = _killerName call fn_encodeText;
private _victimNameEncoded = _victimName call fn_encodeText;

if (_killerUID isEqualTo getPlayerUID player && _killerUID != "") then
{
	_killerNameEncoded = A3W_killFeed_textColorHex(_killerNameEncoded,A3W_killFeed_selfColorHex);
}
else
{
	if (_killerGroup == group player) then
	{
		_killerNameEncoded = A3W_killFeed_textColorHex(_killerNameEncoded,A3W_killFeed_groupColorHex);
	};
};

if (_victimUID isEqualTo getPlayerUID player && _victimUID != "") then
{
	_victimNameEncoded = A3W_killFeed_textColorHex(_victimNameEncoded,A3W_killFeed_selfColorHex);
}
else
{
	if (_victimGroup == group player) then
	{
		_victimNameEncoded = A3W_killFeed_textColorHex(_victimNameEncoded,A3W_killFeed_groupColorHex);
	};
};

#define SIDE_TO_COLOR(UNITSIDE) (["Map", ["Unknown","BLUFOR","OPFOR","Independent","Civilian"] select (([BLUFOR,OPFOR,INDEPENDENT,CIVILIAN] find UNITSIDE) + 1)] call BIS_fnc_displayColorGet call BIS_fnc_colorRGBtoHTML)
#define NAME_ICON(UNITSIDE,UNITNAME) (format ["<img image='client\icons\whitebar.paa' color='%1' shadow='0'/>%2", SIDE_TO_COLOR(UNITSIDE), UNITNAME]);

private _killerNameIcon = if (_killerName == "") then { "" } else { NAME_ICON(_killerSide,_killerNameEncoded) };
private _victimNameIcon = if (_victimName == "") then { "" } else { NAME_ICON(_victimSide,_victimNameEncoded) };

private _killMessage = [_killerNameEncoded, _victimNameEncoded] call A3W_fnc_deathMessage;
private _killMessageIcons = [_killerNameIcon, _victimNameIcon] call A3W_fnc_deathMessage;
private _killMessageRaw = [_killerName, _victimName] call A3W_fnc_deathMessage;

_killParams append
[
	["_killTime", _killTime],
	["_killTimeStamp", _killTimeStamp],
	["_killMessage", _killMessage],
	["_killMessageIcons", _killMessageIcons],
	["_killMessageRaw", _killMessageRaw],
	["_killerNameIcon", _killerNameIcon],
	["_victimNameIcon", _victimNameIcon]
];

private _killsArray = [missionNamespace getVariable "A3W_killFeed_killsArray"] param [0,[],[[]]];
_killsArray pushBack _killParams;
missionNamespace setVariable ["A3W_killFeed_killsArray", _killsArray];

if ([profileNamespace getVariable "A3W_killFeed_showChat"] param [0,A3W_killFeed_showChat_defaultVal,[A3W_killFeed_showChat_defaultVal]] && (!_victimDead || round difficultyOption "deathMessages" <= 0)) then
{
	systemChat _killMessageRaw;
};

call fn_killFeedRefresh;
