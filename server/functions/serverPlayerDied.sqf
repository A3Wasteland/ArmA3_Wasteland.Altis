//	@file Version: 1.0
//	@file Name: serverPlayerDied.sqf
//	@file Author: [404] Pulse
//	@file Created: 20/11/2012 05:19

if (!isServer) exitWith {};

private["_newPlayerObject"];
_newPlayerObject = _this select 0;
_newPlayerObject setVariable["processedDeath",time];

// Remove any persistent info about the player on death
if ((call config_player_saving_enabled) == 1) then {
	getPlayerUID _newPlayerObject call iniDB_delete;
};
