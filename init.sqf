																																																												asaerw3rw3r4 = 1; 
//	@file Version: 1.2
//	@file Name: init.sqf
//	@file Author: [404] Deadbeat, [GoT] JoSchaap
//	@file Description: The main init.

#include "setup.sqf"
#define DEBUG false

StartProgress = false;
enableSaving[false,false];

X_Server = false;
X_Client = false;
X_JIP = false;
hitStateVar = false;
versionName = "Wasteland v0.1";

// Compile a function from a file.
// if in debug mode, the function will be dyncamically compiled every call.
// if not in debug mode, the function will be compileFinal'd
// example1: my_fnc_name = ["path/to/folder", "my_fnc.sqf"] call mf_compile;
// example1: my_fnc_name = ["path/to/folder/my_fnc.sqf"] call mf_compile;
// later in the code you can simply use call my_fnc_name;
mf_compile = compileFinal '
	private "_path";
	_path = "";
	if (typeName _this == "STRING") then {
		_path = _this;
	} else {
		_path = format["%1\%2", _this select 0, _this select 1];
	};
	
	if (DEBUG) then {
		compile format["call compile preProcessFileLineNumbers ""%1""", _path];
	} else {
		compileFinal preProcessFileLineNumbers _path;
	};
';

// Simple command I use to make initialization scripts clean and simple.
// uses mf_ namespace to avoid any issues.
// TODO compilefinal this shit.
mf_init = compileFinal '
	private "_path";
	_path = "";
	if (typeName _this == "STRING") then {
		_path = _this;
	} else {
		_path = format["%1\%2", _this select 0, _this select 1];
	};
	_path call compile preProcessFileLineNumbers format["%1\init.sqf", _path];
';

if(isServer) then { X_Server = true;};
if(!isDedicated) then { X_Client = true;};
if(isNull player) then {X_JIP = true;};


true spawn {
	if(!isDedicated) then {
		titleText ["Welcome to Wasteland, Have patience dear Padawan!", "BLACK", 0];
		waitUntil {!isNull player};
		client_initEH = player addEventHandler ["Respawn", {removeAllWeapons (_this select 0);}];
	};
};

//init Wasteland Core
[] execVM "config.sqf";
[] execVM "briefing.sqf";

generateKey = compileFinal preprocessFileLineNumbers "server\antihack\generateKey.sqf"; 
fn_vehicleInit = compile preprocessFileLineNumbers "server\functions\fn_vehicleInit.sqf";
removeNegativeScore = compile preprocessFileLineNumbers "server\functions\removeNegativeScore.sqf";

if(!isDedicated) then {
	waitUntil {!isNull player};

	//Wipe Group.
	if(count units group player > 1) then
	{  
		diag_log "Player Group Wiped";
		[player] join grpNull;    
	};

	[] execVM "client\init.sqf";
};

if(X_Server) then {
	diag_log format ["############################# %1 #############################", missionName];
	diag_log format["WASTELAND SERVER - Initilizing Server"];
	[] execVM "server\init.sqf";
};

//init 3rd Party Scripts
[] execVM "addons\R3F_ARTY_AND_LOG\init.sqf";
[] execVM "addons\proving_Ground\init.sqf";
