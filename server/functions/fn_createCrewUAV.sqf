// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2016 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_createCrewUAV.sqf
//	@file Author: AgentRev

params [["_uav",objNull,[objNull]], ["_side",sideUnknown,[sideUnknown]]];

private _crewCount = count allTurrets _uav + 1; // +1 because allTurrets doesn't include driver
private _crewNotReady = {alive _uav && {alive _x} count crew _uav < _crewCount};
private "_time";

while _crewNotReady do // bruteforce that shit up
{
	createVehicleCrew _uav;
	_time = diag_tickTime;
	waitUntil {!(diag_tickTime - _time < 1 && _crewNotReady)};
};

if (!alive _uav) exitWith { grpNull };

private _grp = group _uav;

if (_side != sideUnknown && side _uav != _side) then
{
	_grp = createGroup _side;
	(crew _uav) joinSilent _grp;
};

_grp setCombatMode "BLUE"; // hold fire to prevent auto-teamkill shenanigans

_uav spawn
{
	{
		[_x, ["UAV","",""]] remoteExec ["A3W_fnc_setName", 0, _x];
	} forEach crew _this;
};

_grp
