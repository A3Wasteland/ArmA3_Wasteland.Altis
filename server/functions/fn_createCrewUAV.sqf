// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2016 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_createCrewUAV.sqf
//	@file Author: AgentRev

params [["_uav",objNull,[objNull]], ["_side",sideUnknown,[sideUnknown]], ["_skipCreate",false,[false]], ["_autonomous",nil,[false]]];

if (!unitIsUAV _uav) exitWith { grpNull };

private _uavClass = typeOf _uav;
private _vehCfg = configFile >> "CfgVehicles" >> _uavClass;
private _crewCount = {round getNumber (_x >> "dontCreateAI") < 1 && 
                      ((_x == _vehCfg && {round getNumber (_x >> "hasDriver") > 0}) ||
                       (_x != _vehCfg && {round getNumber (_x >> "hasGunner") > 0}))} count ([_uav, configNull] call BIS_fnc_getTurrets);

private _crewNotReady = {alive _uav && {alive _x && !isPlayer _x} count crew _uav < _crewCount};
private "_time";

while _crewNotReady do // bruteforce that shit up because createVehicleCrew is slow and unreliable
{
	if (_skipCreate) then { _skipCreate = false } else { createVehicleCrew _uav };
	if (canSuspend) then
	{
		_time = time;
		waitUntil {!(time - _time < 1 && _crewNotReady)};
	};
};

if (!alive _uav) exitWith { grpNull };

private _grp = group _uav;

if (_side != sideUnknown && side _uav != _side) then
{
	_grp = createGroup _side;
	(crew _uav) joinSilent _grp;
};

if (isNil "_autonomous") then
{
	// disable autonomous mode by default on designators so they stay on target after releasing controls
	if (["_Designator_", _uavClass] call fn_findString != -1) then
	{
		_uav setAutonomous false;
	};
}
else
{
	_uav setAutonomous _autonomous;
};

if !(_uav isKindOf "StaticWeapon") then { _grp setCombatMode "BLUE" }; // hold fire to prevent auto-teamkill shenanigans
(crew _uav) doWatch objNull; // stop aiming turret at player
_uav addRating 1e11;

_uav spawn
{
	{
		[_x, ["UAV","",""]] remoteExec ["A3W_fnc_setName", 0, _x];
	} forEach crew _this;
};

if (round getNumber (configFile >> "CfgVehicles" >> _uavClass >> "attendant") > 0) then
{
	_uav animateSource ["LED_lights_hide", 0, true]; // show medical beacons
};

// Disable UAV thermal vision if desired, adjust classnames as needed
/*if ({_uav isKindOf _x} count ["UGV_02_Base_F"] > 0) then
{
	_uav disableTIEquipment true;
};*/

_grp
