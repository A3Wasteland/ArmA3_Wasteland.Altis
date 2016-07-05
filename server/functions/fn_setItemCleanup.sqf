// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2016 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_setItemCleanup.sqf
//	@file Author: AgentRev

params [["_obj",objNull,[objNull]], ["_time",diag_tickTime,[0]]];

_obj setVariable ["processedDeath", _time, true];
