// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2017 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_killBroadcast.sqf
//	@file Author: AgentRev

// client to server

params [["_victim", objNull, [objNull]], ["_victimDead", false, [false]]];

if (isNull _victim) exitWith {};

scopeName "fn_killBroadcast";
private _victimName = "";
private _victimUID = "";

if (isServer) then
{
	if (isRemoteExecuted && !(remoteExecutedOwner in [owner _victim, clientOwner])) exitWith { breakOut "fn_killBroadcast" };
	if (!isPlayer _victim) then // HandleDisconnect
	{
		_victimName = [_victim getVariable "A3W_handleDisconnect_name"] param [0,"",[""]];
		_victimUID = [_victim getVariable "A3W_handleDisconnect_UID"] param [0,"",[""]];
	};
}
else
{
	if (!local _victim) exitWith { breakOut "fn_killBroadcast" };
	_this remoteExecCall ["A3W_fnc_killBroadcast", 2];
};

if (_victimName isEqualTo "") then
{
	if (!alive _victim && !isPlayer _victim) exitWith { breakOut "fn_killBroadcast" }; // "Error: No unit"
	_victimName = name _victim;
};

if (_victimUID isEqualTo "") then
{
	_victimUID = getPlayerUID _victim;
};

private _victimGroup = group _victim;
private _victimSide = side _victimGroup;


// cause stuff //

private _causeLocal = [_victim getVariable "A3W_deathCause_local"] param [0,[],[[]]];
private _causeRemote = [_victim getVariable "A3W_deathCause_remote"] param [0,[],[[]]];

_causeLocal params [["_cLocalString","",[""]], ["_cLocalTime",nil,[0]]]; // _cLocalTime nil = force use local cause
_causeRemote params [["_cRemoteString","",[""]], ["_cRemoteTime",2e11,[0]]];

// death cause tagged by remote sources have an expiry time of 10 secs (serverTime)
private _causeParams = [_causeLocal, _causeRemote] select (!isNil "_cLocalTime" && {_cRemoteTime < _cLocalTime && _cRemoteTime > _cLocalTime - 10});

if ((_causeParams param [0,""]) isEqualTo "") then
{
	if !("" in [_cLocalString, _cRemoteString]) then
	{
		_causeParams = [_causeLocal, _causeRemote] select (_cLocalString isEqualTo ""); // fallback
	};
};

private _cause = _causeParams param [0,""];

/////////////////


// every object and group can eventually die and become null at some point during the server session

private _killParams =
[
	["_victim",        _victim], // OBJECT
	["_victimName",    _victimName], // STRING
	["_victimUID",     _victimUID], // STRING
	["_victimGroup",   _victimGroup], // GROUP
	["_victimSide",    _victimSide], // SIDE
	["_victimDead",    _victimDead], // BOOL
	["_victimCause",   _cause] // STRING
];

private _killer = [_victim getVariable "FAR_killerUnit"] param [0,objNull,[objNull]];

switch (true) do
{
	case (_victim == _killer || _cause in ["bleedout","suicide","drown","survival","forcekill"]):
	{
		_killParams append
		[
			["_killer",               objNull],
			["_killerName",           ""],
			["_killerUID",            ""],
			["_killerGroup",          grpNull],
			["_killerSide",           sideUnknown],
			["_killerFriendly",       false],
			["_killerAI",             false],
			["_killerVehicle",        objNull],
			["_killerVehicleClass",   ""],
			["_killerWeapon",         ""],
			["_killerAmmo",           ""],
			["_killerDistance",       0]
		];
	};

	case (_cause == "slay"):
	{
		private _killer = _causeParams param [2,objNull,[objNull]];

		_killParams append
		[
			["_killer",               _killer],
			["_killerName",           name _killer],
			["_killerUID",            getPlayerUID _killer],
			["_killerGroup",          group _killer],
			["_killerSide",           side group _killer],
			["_killerFriendly",       [_killer, _victim] call A3W_fnc_isFriendly],
			["_killerAI",             false],
			["_killerVehicle",        _killer],
			["_killerVehicleClass",   typeOf _killer],
			["_killerWeapon",         ""],
			["_killerAmmo",           ""],
			["_killerDistance",       _victim distance _killer]
		];
	};

	default
	{
		_killParams append
		[
			["_killer",               _killer],
			["_killerName",           [_victim getVariable "FAR_killerName"] param [0,"",[""]]],
			["_killerUID",            [_victim getVariable "FAR_killerUID"] param [0,"0",[""]]],
			["_killerGroup",          [_victim getVariable "FAR_killerGroup"] param [0,grpNull,[grpNull]]],
			["_killerSide",           [_victim getVariable "FAR_killerSide"] param [0,sideUnknown,[sideUnknown]]],
			["_killerFriendly",       [_victim getVariable "FAR_killerFriendly"] param [0,false,[false]]],
			["_killerAI",             [_victim getVariable "FAR_killerAI"] param [0,false,[false]]],
			["_killerVehicle",        [_victim getVariable "FAR_killerVehicle"] param [0,objNull,[objNull]]],
			["_killerVehicleClass",   [_victim getVariable "FAR_killerVehicleClass"] param [0,"",[""]]],
			["_killerWeapon",         [_victim getVariable "FAR_killerWeapon"] param [0,"",[""]]],
			["_killerAmmo",           [_victim getVariable "FAR_killerAmmo"] param [0,"",[""]]],
			["_killerDistance",       [_victim getVariable "FAR_killerDistance"] param [0,-1,[0]]]
		];
	};
};

[_killParams] call A3W_fnc_killFeedEntry;
