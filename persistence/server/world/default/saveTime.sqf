// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2015 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: saveTime.sqf
//	@file Author: AgentRev

private "_fileName";
_fileName = "Objects" call PDB_objectFileName;

[_fileName, "Info", "TimeSaved", 0] call PDB_write;

[_fileName, "Info", "DayTime", dayTime] call PDB_write;
[_fileName, "Info", "Fog", fog] call PDB_write;
[_fileName, "Info", "Overcast", overcast] call PDB_write;
[_fileName, "Info", "Rain", rain] call PDB_write;
[_fileName, "Info", "Wind", wind] call PDB_write;

[_fileName, "Info", "TimeSaved", 1] call PDB_write;
