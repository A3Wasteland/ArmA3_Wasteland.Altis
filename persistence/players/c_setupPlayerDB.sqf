//	@file Name: c_setupPlayerDB.sqf
//	@file Author: micovery

if (isDedicated) exitWith {};

#include "macro.h"

call compile preProcessFileLineNumbers "persistence\sock\main.sqf";
call compile preProcessFileLineNumbers "persistence\lib\hash.sqf";
call compile preProcessFileLineNumbers "persistence\players\pFunctions.sqf";
