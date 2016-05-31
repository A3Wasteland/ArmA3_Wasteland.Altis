// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2016 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_markerLogPvar.sqf
//	@file Author: AgentRev, based on code by Killzone Kid: http://killzonekid.com/arma-scripting-tutorials-whos-placingdeleting-markers/

if (isNil "A3W_markerLog_logArray" || {!(A3W_markerLog_logArray isEqualType [])}) then
{
	A3W_markerLog_logArray = [];
};

params ["", ["_value",[],[[]]]];

_logEntry = [serverTime];
_logEntry append _value;

A3W_markerLog_logArray pushBack _logEntry;
A3W_markerLog_logArray deleteRange [0, count A3W_markerLog_logArray - 100]; // 100 entries max.
