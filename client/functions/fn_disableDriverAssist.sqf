// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2017 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_disableDriverAssist.sqf
//	@file Author: AgentRev

private _veh = objectParent player;
private _driver = driver _veh;

if (!isAgent teamMember _driver || !((_driver getVariable ["A3W_driverAssistOwner", objNull]) in [player,objNull])) exitWith {};

deleteVehicle _driver;
["unlockDriver", netId _veh] call A3W_fnc_towingHelper;
