// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2016 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_markerLogEntry.sqf
//	@file Author: AgentRev, based on code by Killzone Kid: http://killzonekid.com/arma-scripting-tutorials-whos-placingdeleting-markers/

if (count _this < 8) exitWith {};
pvar_A3W_markerLog = _this;
publicVariable "pvar_A3W_markerLog";

["",_this] call A3W_fnc_markerLogPvar;
