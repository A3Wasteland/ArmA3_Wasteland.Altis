//	@file Version: 1.0
//	@file Name: findClientPlayer.sqf
//	@file Author: AgentRev
//	@file Created: 09/06/2013 16:39

private ["_clientID", "_player"];
_clientID = _this select 0;
_player = objNull;

{
	if (owner _x == _clientID) exitWith
	{
		_player = _x;
	};
}
forEach playableUnits;

_player
