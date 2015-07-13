// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: globalCompile.sqf
//	@file Author: AgentRev, MercyfulFate
//	@file Created: 07/09/2013 15:06

// The purpose of this script is to compile certain functions both on client and server.

private ["_DEBUG", "_clientFunc", "_serverFunc"];
_DEBUG = format ["%1", _this select 0];

// Compile a function from a file.
// if in debug mode, the function will be dyncamically compiled every call.
// if not in debug mode, the function will be compileFinal'd
// example: my_fnc_name = ["path/to/folder", "my_fnc.sqf"] call mf_compile;
// example: my_fnc_name = ["path/to/folder/my_fnc.sqf"] call mf_compile;
// later in the code you can simply use call my_fnc_name;
// you can also pass raw code to get it compileFinal'd
// example: my_fnc_name = {diag_log "hey"} call mf_compile;
mf_compile = compileFinal
('
	private ["_path", "_isDebug", "_code"];
	_path = "";
	_isDebug = ' + _DEBUG + ';

	switch (toUpper typeName _this) do {
		case "STRING": {
			_path = _this;
		};
		case "ARRAY": {
			_path = format["%1\%2", _this select 0, _this select 1];
		};
		case "CODE": {
			_code = toArray str _this;
			_code set [0, (toArray " ") select 0];
			_code set [count _code - 1, (toArray " ") select 0];
		};
	};

	if (isNil "_code") then {
		if (_isDebug) then {
			compile format ["call compile preProcessFileLineNumbers ""%1""", _path]
		} else {
			compileFinal preProcessFileLineNumbers _path
		};
	} else {
		if (_isDebug) then {
			compile toString _code
		} else {
			compileFinal toString _code
		};
	};
');

// Simple command I use to make initialization scripts clean and simple.
// uses mf_ namespace to avoid any issues.
mf_init =
{
	private "_path";
	_path = if (typeName _this == "STRING") then {
		_this
	} else {
		format ["%1\%2", _this select 0, _this select 1]
	};
	_path call compile preProcessFileLineNumbers format ["%1\init.sqf", _path];
} call mf_compile;

_clientFunc = "client\functions";
_serverFunc = "server\functions";

A3W_fnc_isBleeding = [_serverFunc, "fn_isBleeding.sqf"] call mf_compile;
A3W_fnc_isUnconscious = [_serverFunc, "fn_isUnconscious.sqf"] call mf_compile;
A3W_fnc_pushVehicle = [_serverFunc, "pushVehicle.sqf"] call mf_compile;
A3W_fnc_setName = [_clientFunc, "fn_setName.sqf"] call mf_compile;
A3W_fnc_setupAntiExplode = [_clientFunc, "fn_setupAntiExplode.sqf"] call mf_compile;
A3W_fnc_towingHelper = [_serverFunc, "towingHelper.sqf"] call mf_compile;
applyVehicleTexture = "client\systems\vehicleStore\applyVehicleTexture.sqf" call mf_compile;
cargoToPairs = [_serverFunc, "cargoToPairs.sqf"] call mf_compile;
detachTowedObject = [_serverFunc, "detachTowedObject.sqf"] call mf_compile;
FAR_setKillerInfo = "addons\far_revive\FAR_setKillerInfo.sqf" call mf_compile;
findSafePos = [_serverFunc, "findSafePos.sqf"] call mf_compile;
fn_addScore = [_serverFunc, "fn_addScore.sqf"] call mf_compile;
fn_addToPairs = [_serverFunc, "fn_addToPairs.sqf"] call mf_compile;
fn_allPlayers = [_serverFunc, "allPlayers.sqf"] call mf_compile;
fn_boundingBoxReal = [_serverFunc, "fn_boundingBoxReal.sqf"] call mf_compile;
fn_enableSimulationGlobal = [_serverFunc, "fn_enableSimulationGlobal.sqf"] call mf_compile;
fn_enableSimulationServer = [_serverFunc, "fn_enableSimulationServer.sqf"] call mf_compile;
fn_filterString = [_serverFunc, "fn_filterString.sqf"] call mf_compile;
fn_findString = [_serverFunc, "fn_findString.sqf"] call mf_compile;
fn_forceAddItem = [_clientFunc, "fn_forceAddItem.sqf"] call mf_compile;
fn_getFromPairs = [_serverFunc, "fn_getFromPairs.sqf"] call mf_compile;
fn_getPos3D = [_serverFunc, "fn_getPos3D.sqf"] call mf_compile;
fn_getScore = [_serverFunc, "fn_getScore.sqf"] call mf_compile;
fn_getTeamScore = [_serverFunc, "fn_getTeamScore.sqf"] call mf_compile;
fn_hideObjectGlobal = [_serverFunc, "fn_hideObjectGlobal.sqf"] call mf_compile;
fn_loopSpread = [_serverFunc, "fn_loopSpread.sqf"] call mf_compile;
fn_magazineAmmoCargo = [_serverFunc, "fn_magazineAmmoCargo.sqf"] call mf_compile;
fn_numbersText = [_serverFunc, "fn_numbersText.sqf"] call mf_compile;
fn_numToStr = [_serverFunc, "fn_numToStr.sqf"] call mf_compile;
fn_removeFromPairs = [_serverFunc, "fn_removeFromPairs.sqf"] call mf_compile;
fn_setToPairs = [_serverFunc, "fn_setToPairs.sqf"] call mf_compile;
fn_sortAlphabetically = [_serverFunc, "fn_sortAlphabetically.sqf"] call mf_compile;
fn_splitString = [_serverFunc, "fn_splitString.sqf"] call mf_compile;
fn_startsWith = [_serverFunc, "fn_startsWith.sqf"] call mf_compile;
fn_ejectCorpse = [_serverFunc, "fn_ejectCorpse.sqf"] call mf_compile;
//fn_vehicleInit = [_serverFunc, "fn_vehicleInit.sqf"] call mf_compile;
getBallMagazine = [_serverFunc, "getBallMagazine.sqf"] call mf_compile;
getFwdVelocity = [_serverFunc, "getFwdVelocity.sqf"] call mf_compile;
getHitPoints = [_serverFunc, "getHitPoints.sqf"] call mf_compile;
getMagAmmoCount = [_serverFunc, "getMagAmmoCount.sqf"] call mf_compile;
getMagazineDetailAmmo = [_serverFunc, "getMagazineDetailAmmo.sqf"] call mf_compile;
getMoveWeapon = [_clientFunc, "getMoveWeapon.sqf"] call mf_compile;
fn_getPlayerData = "persistence\client\players\getPlayerData.sqf" call mf_compile;
getPublicVar = [_serverFunc, "getPublicVar.sqf"] call mf_compile;
getTeamMarkerColor = "territory\client\getTeamMarkerColor.sqf" call mf_compile;
isConfigOn = [_serverFunc, "isConfigOn.sqf"] call mf_compile;
processMagazineCargo = [_serverFunc, "processMagazineCargo.sqf"] call mf_compile;
relativePos = [_serverFunc, "relativePos.sqf"] call mf_compile;
removeNegativeScore = [_serverFunc, "removeNegativeScore.sqf"] call mf_compile;
splitWeaponItems = [_serverFunc, "splitWeaponItems.sqf"] call mf_compile;
switchMoveGlobal = [_clientFunc, "switchMoveGlobal.sqf"] call mf_compile;
vehicleDammagedEvent = [_serverFunc, "vehicleDammagedEvent.sqf"] call mf_compile;
vehicleEngineEvent = [_serverFunc, "vehicleEngineEvent.sqf"] call mf_compile;
vehicleHandleDamage = [_serverFunc, "vehicleHandleDamage.sqf"] call mf_compile;
vehicleHitTracking = [_serverFunc, "vehicleHitTracking.sqf"] call mf_compile;

call compile preprocessFileLineNumbers "server\functions\mf_remote.sqf";

"pvar_switchMoveGlobal" addPublicVariableEventHandler { ((_this select 1) select 0) switchMove ((_this select 1) select 1) };
"pvar_detachTowedObject" addPublicVariableEventHandler { (_this select 1) spawn detachTowedObject };
