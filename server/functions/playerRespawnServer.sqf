// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: playerRespawnServer.sqf
//	@file Author: AgentRev

params ["_player", "_corpse"];
private _playerOwner = owner _player;

if (remoteExecutedOwner != _playerOwner || !alive _player || !(_player isKindOf "Man")) exitWith {};

scopeName "playerRespawnServer";

if (!local _player) then
{
	if (getPlayerUID _player isEqualTo "") then
	{
		_player spawn
		{
			for "_i" from 1 to 3 do
			{
				diag_log format ["ErrorSteamID - %1", [netId _this, _this, name _this, side _this, owner _this, isPlayer _this]];
				uiSleep 3;
			};
		};

		//diag_log format ["ErrorSteamID - %1", [_player, name _player, side _player, _playerOwner, isPlayer _player]];

		//"ErrorSteamID" remoteExecCall ["endMission", _player];
		//breakOut "playerRespawnServer";
	};

	if (_playerOwner isEqualTo owner _corpse) then
	{
		// Bank money reset fix attempt
		private _bmoney = _corpse getVariable "bmoney";
		if (!isNil "_bmoney") then
		{
			_player setVariable ["bmoney", _bmoney, true];
		};
	};
};

_this call respawnEventServer;
_player setVariable ["A3W_respawnEH", _player addEventHandler ["Respawn", respawnEventServer]];

_this remoteExec ["fn_remotePlayerSetup", -_playerOwner];
