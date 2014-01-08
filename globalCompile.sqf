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
	private ["_path", "_code"];
	_path = "";
	
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
		if (' + _DEBUG + ') then {
			compile format ["call compile preProcessFileLineNumbers ""%1""", _path]
		} else {
			compileFinal preProcessFileLineNumbers _path
		};
	} else {
		compileFinal toString _code
	};
');

// Simple command I use to make initialization scripts clean and simple.
// uses mf_ namespace to avoid any issues.
mf_init =
{
	private "_path";
	_path = "";
	if (typeName _this == "STRING") then {
		_path = _this;
	} else {
		_path = format["%1\%2", _this select 0, _this select 1];
	};
	_path call compile preProcessFileLineNumbers format["%1\init.sqf", _path];
} call mf_compile;

_clientFunc = "client\functions";
_serverFunc = "server\functions";

detachTowedObject = [_serverFunc, "detachTowedObject.sqf"] call mf_compile;
findSafePos = [_serverFunc, "findSafePos.sqf"] call mf_compile;
fn_filterString = [_serverFunc, "fn_filterString.sqf"] call mf_compile;
fn_findString = [_serverFunc, "fn_findString.sqf"] call mf_compile;
fn_vehicleInit = [_serverFunc, "fn_vehicleInit.sqf"] call mf_compile;
generateKey = [_serverFunc, "network\generateKey.sqf"] call mf_compile;
getBallMagazine = [_serverFunc, "getBallMagazine.sqf"] call mf_compile;
getHitPoints = [_serverFunc, "getHitPoints.sqf"] call mf_compile;
getPublicVar = [_serverFunc, "getPublicVar.sqf"] call mf_compile;
removeNegativeScore = [_serverFunc, "removeNegativeScore.sqf"] call mf_compile;

"requestDetachTowedObject" addPublicVariableEventHandler { (_this select 1) call detachTowedObject };
