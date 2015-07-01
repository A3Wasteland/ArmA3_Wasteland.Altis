// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: functions.sqf
//	@file Author: AgentRev

private ["_baseSavingOn", "_boxSavingOn", "_staticWeaponSavingOn", "_warchestSavingOn", "_warchestMoneySavingOn", "_beaconSavingOn", "_timeSavingOn", "_weatherSavingOn", "_savingMethod", "_isBox", "_isStaticWeapon", "_isWarchest", "_isBeacon"];

_baseSavingOn = ["A3W_baseSaving"] call isConfigOn;
_boxSavingOn = ["A3W_boxSaving"] call isConfigOn;
_staticWeaponSavingOn = ["A3W_staticWeaponSaving"] call isConfigOn;
_warchestSavingOn = ["A3W_warchestSaving"] call isConfigOn;
_warchestMoneySavingOn = ["A3W_warchestMoneySaving"] call isConfigOn;
_beaconSavingOn = ["A3W_spawnBeaconSaving"] call isConfigOn;
_timeSavingOn = ["A3W_timeSaving"] call isConfigOn;
_weatherSavingOn = ["A3W_weatherSaving"] call isConfigOn;

_savingMethod = call A3W_savingMethod;

_isBox = { _this isKindOf "ReammoBox_F" };
_isStaticWeapon = { _this isKindOf "StaticWeapon" };
_isWarchest = { _this getVariable ["a3w_warchest", false] && {(_this getVariable ["side", sideUnknown]) in [WEST,EAST]} };
_isBeacon = { _this getVariable ["a3w_spawnBeacon", false] };

_isSaveable = { (toLower _this) in A3W_saveableObjects };

_hcProfileVarName =
{
	private "_midName";

	if (_savingMethod == "extDB") then
	{
		_midName = format ["extDB_Server%1_", call A3W_extDB_ServerID];
	};

	if (_savingMethod == "profile") then
	{
		_midName = ["PDB_ObjectFileID", "A3W_"] call getPublicVar;
	};

	if (!isNil "_midName") then { "A3W_hcSaving_" + _midName + _this } else { nil }
};

_hcSaveProfileVar =
{
	_varName = _this call _hcProfileVarName;

	if (!isNil "_varName") then
	{
		profileNamespace setVariable [_varName, missionNamespace getVariable _this];
		saveProfileNamespace;
	};
};
