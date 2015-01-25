if (hasInterface) exitWith {};
diag_log "hLoad.sqf loading ...";

externalConfigFolder = "\A3Wasteland_settings";
call compile preprocessFileLineNumbers "server\default_config.sqf";
call compile preprocessFileLineNumbers (externalConfigFolder + "\main_config.sqf");
call compile preprocessFileLineNumbers "persistence\fn_sock_custom.sqf";
call compile preprocessFileLineNumbers "persistence\lib\hash.sqf";
call compile preprocessFileLineNumbers "persistence\lib\shFunctions.sqf";
call compile preprocessFileLineNumbers "persistence\players\sFunctions.sqf";
call compile preprocessFileLineNumbers "persistence\players\pFunctions.sqf";
call compile preprocessFileLineNumbers "persistence\world\vFunctions.sqf";
call compile preprocessFileLineNumbers "persistence\world\oFunctions.sqf";
HeadlessClient setVariable ["hc_ready", true, true];
diag_log "hLoad.sqf loading complete";
