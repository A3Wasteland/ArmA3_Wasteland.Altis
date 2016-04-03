// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_remotePlayerSetup.sqf
//	@file Author: AgentRev

if (!hasInterface)  exitWith {};

params ["_player", ["_corpse",objNull]];

if (_player == player) exitWith {};

if (["A3W_headshotNoRevive"] call isConfigOn) then
{
	if (isNil "FAR_fnc_headshotHitPartEH") exitWith {};

	_playerEH = _player getVariable "FAR_headshotHitPartEH";
	_corpseEH = _corpse getVariable "FAR_headshotHitPartEH";

	if (!isNil "_playerEH") then { _player removeEventHandler ["HitPart", _playerEH] };
	if (!isNil "_corpseEH") then { _corpse removeEventHandler ["HitPart", _corpseEH] };

	if (alive _player) then
	{
		_player setVariable ["FAR_headshotHitPartEH", _player addEventHandler ["HitPart", FAR_fnc_headshotHitPartEH]];
	};
};
