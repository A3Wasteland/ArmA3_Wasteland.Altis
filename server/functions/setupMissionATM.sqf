// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2015 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: setupMissionATM.sqf
//	@file Author: AgentRev

// For use in mission.sqm

params ["_atm"];

if (isNull _atm) exitWith {};

if (local _atm) then
{
	_atm allowDamage false;
};

_atm setVariable ["A3W_atmEditorPlaced", true];
_atm setVariable ["R3F_LOG_disabled", true];

if (isNil "A3W_atmArray") then
{
	A3W_atmArray = [];
};

A3W_atmArray pushBack _atm;
