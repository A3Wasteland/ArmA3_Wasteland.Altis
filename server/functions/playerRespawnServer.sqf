// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: playerRespawnServer.sqf
//	@file Author: AgentRev

private ["_player", "_corpse", "_bmoney"];
_player = _this select 0;
_corpse = _this select 1;

//diag_log format ["playerRespawnServer: %1", _this];

if (!local _player) then
{
	//_player addEventHandler ["WeaponDisassembled", weaponDisassembledServer];

	// Bank money reset fix attempt
	_bmoney = _corpse getVariable "bmoney";
	if (!isNil "_bmoney") then
	{
		_player setVariable ["bmoney", _bmoney, true];
	};
};

_this call respawnEventServer;
_player setVariable ["A3W_respawnEH", _player addEventHandler ["Respawn", respawnEventServer]];

_this remoteExec ["fn_remotePlayerSetup", -(owner _player)];
