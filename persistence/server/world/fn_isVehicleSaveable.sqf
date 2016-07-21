// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_isVehicleSaveable.sqf
//	@file Author: AgentRev

private "_veh";
_veh = _this;

["A3W_vehicleSaving"] call isConfigOn &&
alive _veh && {_veh isKindOf "AllVehicles" && !(_veh isKindOf "Man" || _veh isKindOf "StaticWeapon") &&
((isTouchingGround _veh || (getPos _veh) select 2 <= 1) || call A3W_savingMethodDir != "default") && 
{_veh getVariable ["A3W_purchasedVehicle", false] || _veh getVariable ["A3W_missionVehicle", false]}}
