// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2016 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_setupResupplyTruck.sqf
//	@file Author: AgentRev

params [["_veh",objNull,[objNull]], ["_static",false,[false]]];

if (_veh getVariable ["A3W_resupplyTruckSetup", false]) exitWith {};

if (hasInterface) then
{
	_veh addAction ["<img image='client\icons\repair.paa'/> Resupply Vehicle", "client\functions\fn_resupplyTruck.sqf", [], 51, false, true, "", "alive _target && alive objectParent _this && attachedTo _target != vehicle _this && _target distance vehicle _this <= (10 max (sizeOf typeOf vehicle _this * 0.75)) && (isNil 'mutexScriptInProgress' || {!mutexScriptInProgress})"]; // _target = truck, _this = player
};

if (local _veh) then
{
	_veh setAmmoCargo 0;
	_veh setFuelCargo 0;
	_veh setRepairCargo 0;

	clearBackpackCargoGlobal _veh;
	clearMagazineCargoGlobal _veh;
	clearWeaponCargoGlobal _veh;
	clearItemCargoGlobal _veh;

	if (_static) then
	{
		_veh lock 2;
	};
};

if (_static) then
{
	_veh allowDamage false;
	_veh setVariable ["A3W_lockpickDisabled", true];
	_veh setVariable ["R3F_LOG_disabled", true];

	if (isServer) then
	{
		_veh setDamage 0;
		_veh enableSimulationGlobal false;
	};
};

_veh setVariable ["A3W_resupplyTruck", true];
_veh setVariable ["A3W_resupplyTruckSetup", true];
