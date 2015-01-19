// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: canForceSaveVehicle.sqf
//	@file Author: AgentRev

private "_veh";
_veh = cursorTarget;

alive _veh &&
{player distance _veh <= (sizeOf typeOf _veh / 2) max 2} &&
{_veh isKindOf "AllVehicles" && !(_veh isKindOf "Man" || _veh isKindOf "StaticWeapon") &&
{(_veh getVariable ["A3W_purchasedVehicle", false] && ["A3W_purchasedVehicleSaving"] call isConfigOn) ||
((_veh getVariable ["A3W_missionVehicle", false] && !(_veh getVariable ["R3F_LOG_disabled", false]) && ["A3W_missionVehicleSaving"] call isConfigOn))}}
