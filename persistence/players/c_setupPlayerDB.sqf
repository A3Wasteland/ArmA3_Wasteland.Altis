//	@file Name: c_setupPlayerDB.sqf
//	@file Author: micovery

if (isDedicated) exitWith {};

#include "macro.h"

call compile preprocessFileLineNumbers "persistence\sock\main.sqf";
call compile preprocessFileLineNumbers "persistence\lib\hash.sqf";
call compile preprocessFileLineNumbers "persistence\lib\shFunctions.sqf";
call compile preprocessFileLineNumbers "persistence\players\pFunctions.sqf";
