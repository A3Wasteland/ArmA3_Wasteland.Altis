// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: punishTeamKiller.sqf
//	@file Author: AgentRev

params [["_player",objNull,[objNull]], ["_UID","0",[""]]];

if (_UID in ["","0"]) exitWith {};

private _nbTKs = ([pvar_teamKillList, _UID, 0] call fn_getFromPairs) + 1;
[pvar_teamKillList, _UID, _nbTKs] call fn_setToPairs;
publicVariable "pvar_teamKillList";

if (getPlayerUID _player != _UID) then
{
	{
		if (getPlayerUID _x == _UID) exitWith
		{
			_player = _x;
		};
	} forEach allPlayers;
};

if (getPlayerUID _player != _UID) exitWith {};

pvar_warnTeamKiller = _nbTKs;
(owner _player) publicVariableClient "pvar_warnTeamKiller";
