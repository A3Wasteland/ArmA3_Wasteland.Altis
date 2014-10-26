// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
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
forEach (call allPlayers);

_player
