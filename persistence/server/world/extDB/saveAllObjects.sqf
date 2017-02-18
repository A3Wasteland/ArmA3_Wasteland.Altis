// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2017 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: saveAllObjects.sqf
//	@file Author: AgentRev

#include "..\functions.sqf"

private _objectSavingOn = (_baseSavingOn || _boxSavingOn || _staticWeaponSavingOn || _warchestSavingOn || _warchestMoneySavingOn || _beaconSavingOn);
private _vehicleSavingOn = ["A3W_vehicleSaving"] call isConfigOn;
private _mineSavingOn = ["A3W_mineSaving"] call isConfigOn;

private _savingInterval = 0;

[_objectSavingOn, _vehicleSavingOn, _mineSavingOn] call fn_oSaveOnce;
