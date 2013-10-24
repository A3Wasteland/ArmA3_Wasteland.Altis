//	@file Version: 1.0
//	@file Name: globalCompile.sqf
//	@file Author: AgentRev, MercyfulFate
//	@file Created: 07/09/2013 15:06

// The purpose of this script is to compile certain functions both on client and server.

private ["_DEBUG", "_path"];
_DEBUG = _this select 0;

// Compile a function from a file.
// if in debug mode, the function will be dyncamically compiled every call.
// if not in debug mode, the function will be compileFinal'd
// example1: my_fnc_name = ["path/to/folder", "my_fnc.sqf"] call mf_compile;
// example1: my_fnc_name = ["path/to/folder/my_fnc.sqf"] call mf_compile;
// later in the code you can simply use call my_fnc_name;
mf_compile = compileFinal
('
	private "_path";
	_path = "";
	if (typeName _this == "STRING") then {
		_path = _this;
	} else {
		_path = format["%1\%2", _this select 0, _this select 1];
	};
	
	if (' + str _DEBUG + ') then {
		compile format ["call compile preProcessFileLineNumbers ""%1""", _path];
	} else {
		compileFinal preProcessFileLineNumbers _path;
	};
');

// Simple command I use to make initialization scripts clean and simple.
// uses mf_ namespace to avoid any issues.
mf_init = compileFinal
'
	private "_path";
	_path = "";
	if (typeName _this == "STRING") then {
		_path = _this;
	} else {
		_path = format["%1\%2", _this select 0, _this select 1];
	};
	_path call compile preProcessFileLineNumbers format["%1\init.sqf", _path];
';

_path = "server\functions";
detachTowedObject = [_path, "detachTowedObject.sqf"] call mf_compile;
findSafePos = [_path, "findSafePos.sqf"] call mf_compile;
fn_vehicleInit = [_path, "fn_vehicleInit.sqf"] call mf_compile;
generateKey = [_path, "network\generateKey.sqf"] call mf_compile;
getBallMagazine = [_path, "getBallMagazine.sqf"] call mf_compile;
getHitPoints = [_path, "getHitPoints.sqf"] call mf_compile;
getPublicVar = [_path, "getPublicVar.sqf"] call mf_compile;
removeNegativeScore = [_path, "removeNegativeScore.sqf"] call mf_compile;

if (isNil "fn_findString") then { fn_findString = [_path, "fn_findString.sqf"] call mf_compile };
if (isNil "fn_filterString") then { fn_filterString = [_path, "fn_filterString.sqf"] call mf_compile };

"requestDetachTowedObject" addPublicVariableEventHandler { (_this select 1) call detachTowedObject };
