// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: chatBroadcast.sqf
//	@file Author: AgentRev
//	@file Created: 02/06/2013 16:23

private ["_playerUID", "_sentChecksum", "_excludeGroup"];
_playerUID = [_this, 1, "", [""]] call BIS_fnc_param;
_sentChecksum = [_this, 2, "", [""]] call BIS_fnc_param;
_excludeGroup = [_this, 3, false, [false]] call BIS_fnc_param;

if (_sentChecksum == _flagChecksum && {_playerUID != getPlayerUID player} && {!_excludeGroup || {{getPlayerUID _x == _playerUID} count units player == 0}}) then
{
	player commandChat format ["%1", _this select 0];
};
