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

if (!isNil "PDB_ServerID") then
{
	PDB_PlayerFileID = PDB_ServerID;
	PDB_ObjectFileID = PDB_ServerID;
};

PDB_playerFileName = compileFinal ("format ['%1%2', '" + PDB_PlayerFileID + "', _this]");
PDB_objectFileName = compileFinal ("format ['%1%2', '" + PDB_ObjectFileID + "', _this]");

PDB_databaseNameCompiler = PDB_objectFileName;

iniDB_version = compileFinal str ("iniDB" callExtension "version");

iniDB_HashFunction = {
	private["_mode", "_data", "_cdata"];
	_mode = _this select 0;
	_data = _this select 1;

	if((typeName _data) == "STRING") then {
		_data = "iniDB" callExtension format["%1;%2", _mode, _data];
		_cdata = call compile _data;

		if((_cdata select 0)) then {
			_cdata select 1
		} else {
			nil
		};
	} else {
		nil
	};
}
call mf_compile;

iniDB_CRC32 = {
	_this = ["crc", _this] call iniDB_HashFunction;
	_this
}
call mf_compile;

iniDB_MD5 = {
	_this = ["md5", _this] call iniDB_HashFunction;
	_this
}
call mf_compile;

iniDB_Base64Encode = {
	_this = ["b64_enc", _this] call iniDB_HashFunction;
	_this
}
call mf_compile;

iniDB_Base64Decode = {
	_this = ["b64_dec", _this] call iniDB_HashFunction;
	_this
}
call mf_compile;

iniDB_exists = {
	private ["_data", "_cdata"];
	if (__DEBUG_INIDB_CALLS__ == 1) then { diag_log format["iniDB_exists called with %1", _this]; };
	_data = "iniDB" callExtension format["exists;%1", _this];
	if (__DEBUG_INIDB_CALLS__ == 1) then { diag_log format["iniDB_exists returned %1", _data]; };
	_cdata = call compile _data;

	if((_cdata select 0) && (_cdata select 1)) then {
		true
	} else {
		false
	};
}
call mf_compile;


iniDB_delete = {
	private ["_data", "_cdata"];
	_data = "iniDB" callExtension format["delete;%1", _this select 0]; //############################
	_cdata = call compile _data;

	if((_cdata select 0)) then {
		true
	} else {
		false
	};
}
call mf_compile;

iniDB_deleteSection = {
	private ["_data", "_cdata"];
	_data = "iniDB" callExtension format["deletesection;%1;%2", _this select 0, _this select 1];
	_cdata = call compile _data;

	if((_cdata select 0)) then {
		true
	} else {
		false
	};
}
call mf_compile;

// =======================================================================

iniDB_readRaw = {
	private["_file", "_sec", "_key", "_data", "_cdata"];
	if (__DEBUG_INIDB_CALLS__ == 1) then { diag_log format["iniDB_readRaw called with %1", _this]; };
	_file = _this select 0;
	_sec = _this select 1;
	_key = _this select 2;
	_data = "iniDB" callExtension format["read;%1;%2;%3", _file, _sec, _key];
	if (__DEBUG_INIDB_CALLS__ == 1) then { diag_log format["iniDB_readRaw returned '%1'", _data]; };
	_cdata = [false];
	// Better handling of empty strings which don't compile well
	if (_data != "") then {
		_cdata = call compile _data;
	};

	if((_cdata select 0)) then {
		_cdata select 1
	} else {
		""
	};
}
call mf_compile;

iniDB_writeRaw = {
	private["_file", "_sec", "_key", "_val", "_data", "_cdata"];
	if (__DEBUG_INIDB_CALLS__ == 1) then {diag_log format["iniDB_writeRaw called with %1", _this];};

	_file = _this select 0;
	_sec = _this select 1;
	_key = _this select 2;
	_val = _this select 3;
	_data = "iniDB" callExtension format["write;%1;%2;%3;%4", _file, _sec, _key, _val];
	_cdata = call compile _data;

	if((_cdata select 0)) then {
		true
	} else {
		false
	};
}
call mf_compile;

// =======================================================================

iniDB_Datarizer = {
	private["_string", "_type", "_return"];
	if (__DEBUG_INIDB_CALLS__ == 1) then { diag_log format["iniDB_Datarizer called with %1", _this]; };
	_string = _this select 0;
	_type = _this select 1;

	if(_type == "ARRAY") then {
		_return = call compile _string;
	} else {
		if((_type == "SCALAR") || (_type == "NUMBER")) then { // "NUMBER" is less confusing for new folks
			_return = parseNumber _string;
		} else {
			_return = _string;
		};
	};

	_return
}
call mf_compile;

iniDB_read = {
	private["_file", "_sec", "_key", "_type", "_data"];
	if (__DEBUG_INIDB_CALLS__ == 1) then { diag_log format["iniDB_read called with %1", _this]; };

	_file = _this select 0;
	_sec = _this select 1;
	_key = _this select 2;
	_data = [_file, _sec, _key] call iniDB_readRaw;

	if (count _this > 3) then {
		_type = _this select 3;
		_data = [_data, _type] call iniDB_Datarizer;
	};

	_data
}
call mf_compile;

iniDB_write = {
	private["_file", "_sec", "_key", "_data"];
	if (__DEBUG_INIDB_CALLS__ == 1) then {diag_log format["iniDB_write called with %1", _this];};

	_file = _this select 0;
	_sec = _this select 1;
	_key = _this select 2;
	_data = _this select 3;

	_data = format['"%1"', _data];
	_data = [_file, _sec, _key, _data] call iniDB_writeRaw;
	_data
}
call mf_compile;

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
