// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: playerRespawnServer.sqf
//	@file Author: AgentRev

params ["_player", "_corpse"];
scopeName "playerRespawnServer";

//diag_log format ["playerRespawnServer: %1", _this];

if (!local _player) then
{
	if (getPlayerUID _player isEqualTo "") then
	{
		diag_log format ["ErrorSteamID(%1) - %2, %3, %4", isPlayer _player, _player, name _player, side _player];

		if (isPlayer _player) then
		{
			"ErrorSteamID" remoteExecCall ["endMission", _player];
			breakOut "playerRespawnServer";
		}
	};

	// Bank money reset fix attempt
	private _bmoney = _corpse getVariable "bmoney";
	if (!isNil "_bmoney") then
	{
		_player setVariable ["bmoney", _bmoney, true];
	};
};

_this call respawnEventServer;
_player setVariable ["A3W_respawnEH", _player addEventHandler ["Respawn", respawnEventServer]];

_this remoteExec ["fn_remotePlayerSetup", -(owner _player)];
