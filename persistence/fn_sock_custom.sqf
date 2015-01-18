// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//Persistent Scripts by ZA-Gamers. www.za-gamers.co.za
//Filename: fn_inidb_custom.sqf
//Author: {ZAG}Ed!
//Email: edwin(at)vodamail(dot)co(dot)za
//Date: 26/03/2013
//Thanx to iniDB's author SicSemperTyrannis! May you have many wives and children!

// WARNING! This is a modified version for use with A3Wasteland!
// This is NOT a default persistantdb script!
// changes by: JoSchaap, Bewilderbeest, and AgentRev @ http://a3wasteland.com/

#define __DEBUG_INIDB_CALLS__ 0

if (!isServer) exitWith {};


PDB_ServerID = if (isNil "PDB_ServerID") then {"A3W_"} else {PDB_ServerID};
PDB_PlayerFileID = if (isNil "PDB_PlayerFileID") then {PDB_ServerID} else {PDB_PlayerFileID};
PDB_ObjectFileID = if (isNil "PDB_ObjectFileID") then {PDB_ServerID} else {PDB_ObjectFileID};
PDB_VehicleFileID = if (isNil "PDB_VehicleFileID") then {PDB_ServerID} else {PDB_VehicleFileID};
PDB_MessagesFileID = if (isNil "PDB_MessagesFileID") then {PDB_ServerID} else {PDB_MessagesFileID};
PDB_AdminLogFileID = if (isNil "PDB_AdminLogFileID") then {PDB_ServerID} else {PDB_AdminLogFileID};
PDB_HackerLogFileID = if (isNil "PDB_HackerLogFileID") then {PDB_ServerID} else {PDB_HackerLogFileID};
PDB_PlayersListFileID = if (isNil "PDB_PlayersListFileID") then {PDB_ServerID} else {PDB_PlayersListFileID};



PDB_playerFileName = compileFinal ("format ['%1%2', '" + PDB_PlayerFileID + "', _this]");
PDB_objectFileName = compileFinal ("format ['%1%2', '" + PDB_ObjectFileID + "', _this]");
PDB_vehicleFileName = compileFinal ("format ['%1%2', '" + PDB_VehicleFileID + "', _this]");
PDB_messagesFileName = compileFinal ("format ['%1%2', '" + PDB_MessagesFileID + "', _this]");
PDB_adminLogFileName = compileFinal ("format ['%1%2', '" + PDB_AdminLogFileID + "', _this]");
PDB_hackerLogFileName = compileFinal ("format ['%1%2', '" + PDB_HackerLogFileID + "', _this]");
PDB_playersListFileName = compileFinal ("format ['%1%2', '" + PDB_PlayersListFileID + "', _this]");


diag_log format["[INFO] config: PDB_PlayerFileID = %1", PDB_PlayerFileID];
diag_log format["[INFO] config: PDB_ObjectFileID = %1", PDB_ObjectFileID];
diag_log format["[INFO] config: PDB_VehicleFileID = %1", PDB_VehicleFileID];
diag_log format["[INFO] config: PDB_MessagesFileID = %1", PDB_MessagesFileID];
diag_log format["[INFO] config: PDB_AdminLogFileID = %1", PDB_AdminLogFileID];
diag_log format["[INFO] config: PDB_HackerLogFileID = %1", PDB_HackerLogFileID];
diag_log format["[INFO] config: PDB_PlayersListFileID = %1", PDB_PlayersListFileID];


call compile preProcessFileLineNumbers "persistence\sock\inidb_adapter.sqf";
publicVariable "PDB_PlayerFileID";


PDB_defaultValue = {
	private ["_type", "_data"];
	_type = _this select 0;
	_data = _this select 1;

	switch (toUpper _type) do
	{
		case "ARRAY":  { [] };
		case "STRING": { if (isNil "_data") then { "" } else { str _data } };
		case "NUMBER": { parseNumber str _data };
		case "SCALAR": { parseNumber str _data };
		default        { nil };
	};
}
call mf_compile;

// Server-side profileNamespace saving if iniDB is disabled or unavailable
PDB_exists = iniDB_exists;
PDB_read = iniDB_read;
PDB_write = iniDB_write;
PDB_delete = iniDB_delete;
PDB_deleteSection = iniDB_deleteSection;
