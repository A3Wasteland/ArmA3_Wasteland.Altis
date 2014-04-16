//	@file Version: 1.0
//	@file Name: onPlayerConnected.sqf
//	@file Author: [Kos]Bewilderbeest
//	@file Created: 13/8/2013 11:08
//	@file Description: Triggers to run when a player connected.
//	@file Args:

// This is basically here to fix anything which isn't taken care of by the built-in JIP functionality

if (!isServer) exitWith {};

private ['_id', '_name'];

_id = _this select 0;
_name = _this select 1;

if (_name == '__SERVER__') exitWith {};

// Hook for territory system
if (count (["config_territory_markers", []] call getPublicVar) > 0) then
{
	[] execVM "territory\client\updateConnectingClients.sqf";
};
