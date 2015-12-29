// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: Safe_releaseLockDown.sqf
//	@file Author: LouD / Cael817 for original script
//	@file Description: Safe script

private ["_safe"];
_safe = cursorTarget;

_safe setVariable ["R3F_LOG_disabled", false, true];
_safe setVariable ["A3W_inventoryLockR3F", false, true];
_safe setVariable ["lockedSafe", false, true];

pvar_manualObjectSave = netId _safe;
publicVariableServer "pvar_manualObjectSave";

hint "Your safe is unlocked";