// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2015 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: invis.sqf
//	@file Author: macchky
//	@file Created: 2015/4/7 9:21

if (!isServer) exitWith {};

private ["_player","_state"];

_player = _this select 0;
_state = _this select 1;

_player hideObjectGlobal _state;