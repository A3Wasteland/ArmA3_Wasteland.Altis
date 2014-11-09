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

_savingMethod = ["A3W_savingMethod", 1] call getPublicVar;


PDB_ServerID = if (isNil "PDB_ServerID") then {"A3W_"} else {PDB_ServerID};
PDB_PlayerFileID = if (isNil "PDB_PlayerFileID") then {PDB_ServerID} else {PDB_PlayerFileID};
PDB_ObjectFileID = if (isNil "PDB_ObjectFileID") then {PDB_ServerID} else {PDB_ObjectFileID};
PDB_MessagesFileID = if (isNil "PDB_MessagesFileID") then {PDB_ServerID} else {PDB_MessagesFileID};
PDB_AdminLogFileID = if (isNil "PDB_AdminLogFileID") then {PDB_ServerID} else {PDB_AdminLogFileID};
PDB_HackerLogFileID = if (isNil "PDB_HackerLogFileID") then {PDB_ServerID} else {PDB_HackerLogFileID};
PDB_PlayersListFileID = if (isNil "PDB_PlayersListFileID") then {PDB_ServerID} else {PDB_PlayersListFileID};



PDB_playerFileName = compileFinal ("format ['%1%2', '" + PDB_PlayerFileID + "', _this]");
PDB_objectFileName = compileFinal ("format ['%1%2', '" + PDB_ObjectFileID + "', _this]");
PDB_messagesFileName = compileFinal ("format ['%1%2', '" + PDB_MessagesFileID + "', _this]");
PDB_adminLogFileName = compileFinal ("format ['%1%2', '" + PDB_AdminLogFileID + "', _this]");
PDB_hackerLogFileName = compileFinal ("format ['%1%2', '" + PDB_HackerLogFileID + "', _this]");
PDB_playersListFileName = compileFinal ("format ['%1%2', '" + PDB_PlayersListFileID + "', _this]");


diag_log format["[INFO] config: PDB_PlayerFileID = %1", PDB_PlayerFileID];
diag_log format["[INFO] config: PDB_ObjectFileID = %1", PDB_ObjectFileID];
diag_log format["[INFO] config: PDB_MessagesFileID = %1", PDB_MessagesFileID];
diag_log format["[INFO] config: PDB_AdminLogFileID = %1", PDB_AdminLogFileID];
diag_log format["[INFO] config: PDB_HackerLogFileID = %1", PDB_HackerLogFileID];
diag_log format["[INFO] config: PDB_PlayersListFileID = %1", PDB_PlayersListFileID];





PDB_databaseNameCompiler = PDB_objectFileName;


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

PDB_exists = if (_savingMethod == 2) then { iniDB_exists } else
{
	{
		!isNil {profileNamespace getVariable _this};
	} call mf_compile;
};

PDB_read = if (_savingMethod == 2) then { iniDB_read } else
{
	{
		private ["_var", "_sec", "_key", "_varSec", "_data", "_type"];
		_var = _this select 0;
		_sec = _this select 1;
		_key = _this select 2;

		_varSec = _var + "_" + _sec;
		_data = profileNamespace getVariable _varSec;

		if (!isNil "_data" && {typeName _data == "ARRAY"}) then
		{
			_data = [_data, _key] call fn_getFromPairs;
		};

		if (count _this > 3 && {isNil "_data" || {typeName _data != _this select 3}}) then
		{
			_data = [_this select 3, if (isNil "_data") then { "" } else { _data }] call PDB_defaultValue;
		};

		if (isNil "_data") then { nil } else { _data };
	} call mf_compile;
};

PDB_write = if (_savingMethod == 2) then { iniDB_write } else
{
	{
		private ["_var", "_sec", "_key", "_val", "_saveSec", "_varSec", "_data", "_setVar"];
		_var = _this select 0;
		_sec = _this select 1;
		_key = _this select 2;
		_val = _this select 3;
		_saveSec = if (count _this > 4) then { _this select 4 } else { true };

		// Save value in section

		_varSec = _var + "_" + _sec;
		_data = profileNamespace getVariable _varSec;
		_setVar = false;

		if (isNil "_data" || {typeName _data != "ARRAY"}) then
		{
			_data = [];
			_setVar = true;
		};

		[_data, _key, _val] call fn_setToPairs;

		// Since arrays are always passed by reference, we only have to call setVariable if the array itself changes
		if (_setVar) then
		{
			profileNamespace setVariable [_varSec, _data];
		};

		// Save section name in index

		if (_saveSec) then
		{
			_indData = profileNamespace getVariable _var;
			_setVar = false;

			if (isNil "_indData" || {typeName _indData != "ARRAY"}) then
			{
				_indData = [];
				_setVar = true;
			};

			if ({typeName _x == "STRING" && {_x == _sec}} count _indData == 0) then
			{
				_indData pushBack _sec;
			};

			if (_setVar) then
			{
				profileNamespace setVariable [_var, _indData];
			};
		};
	} call mf_compile;
};

PDB_delete = if (_savingMethod == 2) then { iniDB_delete } else
{
	{
		private ["_var", "_delSec", "_indData"];
		_var = _this select 0;
		_delSec = if (count _this > 1) then { _this select 1 } else { true };

		_indData = profileNamespace getVariable _var;

		if (!isNil "_indData") then
		{
			if (_delSec && typeName _indData == "ARRAY") then
			{
				{
					if (typeName _x == "STRING") then
					{
						profileNamespace setVariable [_x, nil];
					};
				} forEach _indData;
			};

			profileNamespace setVariable [_var, nil];
		};
	} call mf_compile;
};

PDB_deleteSection = if (_savingMethod == 2) then { iniDB_deleteSection } else
{
	{
		private ["_var", "_sec", "_delIndex", "_varSec", "_indData"];
		_var = _this select 0;
		_sec = _this select 1;
		_delIndex = if (count _this > 2) then { _this select 2 } else { false };

		_varSec = _var + "_" + _sec;
		profileNamespace setVariable [_varSec, nil];

		if (_delIndex) then
		{
			_indData = profileNamespace getVariable _var;

			if (!isNil "_indData" && {typeName _indData == "ARRAY"}) then
			{
				{
					if (typeName _x == "STRING" && {_x == _varSec}) then
					{
						_indData set [_forEachIndex, -1];
					};
				} forEach _indData;

				profileNamespace setVariable [_var, _indData - [-1]];
			};
		};
	} call mf_compile;
};
