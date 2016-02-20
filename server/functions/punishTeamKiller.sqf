// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: punishTeamKiller.sqf
//	@file Author: AgentRev

private ["_player", "_uid", "_nbTKs"];
_player = param [0, objNull, [objNull]];
_uid = param [1, "0", [""]];

if (_uid == "") exitWith {};

_nbTKs = ([pvar_teamKillList, _uid, 0] call fn_getFromPairs) + 1;
[pvar_teamKillList, _uid, _nbTKs] call fn_setToPairs;
publicVariable "pvar_teamKillList";

if (!isPlayer _player) exitWith {};

pvar_warnTeamKiller = _nbTKs;
(owner _player) publicVariableClient "pvar_warnTeamKiller";
