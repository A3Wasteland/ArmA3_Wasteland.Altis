// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2015 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: getTime.sqf
//	@file Author: AgentRev

private ["_fileName", "_dayTime", "_fog", "_overcast", "_rain", "_wind"];
_fileName = "Objects" call PDB_objectFileName;

if ([_fileName, "Info", "TimeSaved", "NUMBER"] call PDB_read < 1) exitWith { [] };

_dayTime = [_fileName, "Info", "DayTime", "NUMBER"] call PDB_read;
_fog = [_fileName, "Info", "Fog", "NUMBER"] call PDB_read;
_overcast = [_fileName, "Info", "Overcast", "NUMBER"] call PDB_read;
_rain = [_fileName, "Info", "Rain", "NUMBER"] call PDB_read;
_wind = [_fileName, "Info", "Wind", "ARRAY"] call PDB_read;

[_dayTime, _fog, _overcast, _rain, _wind]
