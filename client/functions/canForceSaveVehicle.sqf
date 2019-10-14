// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: canForceSaveVehicle.sqf
//	@file Author: AgentRev

alive _this && {cameraOn distance _this <= (sizeOf typeOf _this / 2) max 2} &&
{_this isKindOf "AllVehicles" && !(_this isKindOf "Man" || _this isKindOf "StaticWeapon") &&
{_this getVariable ["A3W_purchasedVehicle", false] || _this getVariable ["A3W_missionVehicle", false]}}
