// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: canForceSaveStaticWeapon.sqf
//	@file Author: AgentRev

private "_veh";
_veh = cursorTarget;

alive _veh && {player distance _veh <= (sizeOf typeOf _veh / 2) max 2} && 
(["A3W_extDB_SaveUnlockedObjects"] call isConfigOn || _veh getVariable ["objectLocked", false]) &&
{_veh isKindOf "StaticWeapon" && (!(_veh getVariable ["R3F_LOG_disabled", false]) || locked _veh == 2)}
