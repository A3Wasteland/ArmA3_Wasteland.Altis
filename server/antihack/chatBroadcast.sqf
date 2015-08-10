// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: chatBroadcast.sqf
//	@file Author: AgentRev
//	@file Created: 02/06/2013 16:23

private ["_playerUID", "_sentChecksum", "_excludeGroup"];
_playerUID = param [1, "", [""]];
_sentChecksum = param [2, "", [""]];
_excludeGroup = param [3, false, [false]];

if (_sentChecksum == _flagChecksum && {_playerUID != getPlayerUID player} && {!_excludeGroup || {{getPlayerUID _x == _playerUID} count units player == 0}}) then
{
	player commandChat format ["%1", _this select 0];
};
