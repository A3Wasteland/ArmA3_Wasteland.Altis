// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: init.sqf
//	@file Author: AgentRev

diag_log "WASTELAND HEADLESS - Waiting for server startup";

waitUntil {!isNil "A3W_serverSpawningComplete"};

diag_log "WASTELAND HEADLESS - Server startup completed, begin headless operations";

_hcPrefix = ["A3W_hcPrefix", "A3W_HC"] call getPublicVar;

if (["A3W_hcObjCaching"] call isConfigOn && {vehicleVarName player == format ["%1%2", _hcPrefix, ["A3W_hcObjCachingID", 1] call getPublicVar]}) then
{
	execVM "addons\fpsFix\vehicleManagerHC.sqf";
};

if (["A3W_hcObjCleanup"] call isConfigOn && {vehicleVarName player == format ["%1%2", _hcPrefix, ["A3W_hcObjCleanupID", 1] call getPublicVar]}) then
{
	execVM "server\WastelandServClean.sqf";
};

if (["A3W_hcObjSaving"] call isConfigOn && {vehicleVarName player == format ["%1%2", _hcPrefix, ["A3W_hcObjSavingID", 2] call getPublicVar]}) then
{
	waitUntil {!isNil "A3W_hcObjSaving_serverReady"};
	execVM "server\init.sqf";
};
