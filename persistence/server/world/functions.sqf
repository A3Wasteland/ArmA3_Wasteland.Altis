// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: functions.sqf
//	@file Author: AgentRev

private ["_baseSavingOn", "_boxSavingOn", "_staticWeaponSavingOn", "_warchestSavingOn", "_warchestMoneySavingOn", "_beaconSavingOn", "_savingMethod", "_isBox", "_isStaticWeapon", "_isWarchest", "_isBeacon"];

_baseSavingOn = ["A3W_baseSaving"] call isConfigOn;
_boxSavingOn = ["A3W_boxSaving"] call isConfigOn;
_staticWeaponSavingOn = ["A3W_staticWeaponSaving"] call isConfigOn;
_warchestSavingOn = ["A3W_warchestSaving"] call isConfigOn;
_warchestMoneySavingOn = ["A3W_warchestMoneySaving"] call isConfigOn;
_beaconSavingOn = ["A3W_spawnBeaconSaving"] call isConfigOn;

_savingMethod = call A3W_savingMethod;

_isBox = { _this isKindOf "ReammoBox_F" };
_isStaticWeapon = { _this isKindOf "StaticWeapon" };
_isWarchest = { _this getVariable ["a3w_warchest", false] && {(_this getVariable ["side", sideUnknown]) in [WEST,EAST]} };
_isBeacon = { _this getVariable ["a3w_spawnBeacon", false] };

_isSaveable =
{
	_result = false;
	{ if (_this == _x) exitWith { _result = true } } forEach A3W_saveableObjects;
	_result
};
