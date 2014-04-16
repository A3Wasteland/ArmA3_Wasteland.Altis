//Persistent Scripts by ZA-Gamers. www.za-gamers.co.za
//Filename: fn_inidb_custom.sqf
//Author: {ZAG}Ed!
//Email: edwin(at)vodamail(dot)co(dot)za
//Date: 26/03/2013
//Thanx to iniDB's author SicSemperTyrannis! May you have many wives and children!

// WARNING! This is a modified version for use with the A3W missionfile!
// This is NOT a default persistantdb script!
// changes by: JoSchaap & Bewilderbeest @ http://a3wasteland.com/

#define __DEBUG_INIDB_CALLS__ 0

if(!isServer) exitWith {};

PDB_databaseNameCompiler = {
	private ["_return", "_name", "_prefix"];
	_return = "";
	_name = _this;
	_prefix = PDB_ServerID;
	_return = format["%1%2", _prefix, _name];
	_return;
}
call mf_compile;

iniDB_version = {
	private["_data"];
	_data = "iniDB" callExtension "version";
	_data
}
call mf_compile;

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
	_data = "iniDB" callExtension format["delete;%1", _this];
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
