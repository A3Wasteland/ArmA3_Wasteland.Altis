// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2017 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_enableDriverAssist.sqf
//	@file Author: AgentRev

// This feature was inspired by Killzone Kid:  http://killzonekid.com/arma-scripting-tutorials-one-man-tank-operation/

private _veh = objectParent player;

if (!alive _veh || alive driver _veh || effectiveCommander _veh != player) exitWith {};

private _class = format ["%1_UAV_AI", ["B","O","I"] select (([BLUFOR,OPFOR,INDEPENDENT] find playerSide) max 0)];
private _ai = createAgent [_class, [0,0,0], [], 0, ""];

[_ai, ["Autodrive","",""]] remoteExec ["A3W_fnc_setName", 0, _ai];
_ai moveInDriver _veh;
_ai setVariable ["A3W_driverAssistOwner", player, true];
_ai allowDamage false;

_veh spawn
{
	_time = time;
	waitUntil {local _this || time - _time > 3};

	if (local _this) then
	{
		_this lockDriver true;
	}
	else
	{
		["lockDriver", _this] remoteExecCall ["A3W_fnc_towingHelper", _this];
	};
};
