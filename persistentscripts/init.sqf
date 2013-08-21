//Persistent Scripts by ZA-Gamers. www.za-gamers.co.za
//Author: {ZAG}Ed!
//Email: edwin(at)vodamail(dot)co(dot)za
//Date: 26/03/2013
//Thanx to iniDB's author SicSemperTyrannis! May you have many wives and children!
//changes to persistentdb for arma3 and GoT Wasteland mission by JoSchaap (got2dayz.nl)

// WARNING! This is a modified version for use with the GoT Wasteland v2 missionfile!
// This is NOT a default persistantdb script!
// changes by: JoSchaap (GoT2DayZ.nl)

if(!isServer) exitWith {};

PDB_databaseNameCompiler = {
_return = "";
_name = _this;
_prefix = PDB_ServerID;
_return = format["%1%2", _prefix, _name];
_return;
};

iniDB_version = {
	private["_data"];
	_data = "iniDB" callExtension "version";
	_data
};

iniDB_HashFunction = {
	private["_mode", "_data"];
	_mode = _this select 0;
	_data = _this select 1;
	
	if((typeName _data) == "STRING") then {	
		_data = "iniDB" callExtension format["%1;%2", _mode, _data];
		_data = call compile _data;

		if((_data select 0)) then {
			_data select 1
		} else {
			nil
		};
	} else {
		nil
	};
};

iniDB_CRC32 = {
	_this = ["crc", _this] call iniDB_HashFunction;
	_this
};

iniDB_MD5 = {
	_this = ["md5", _this] call iniDB_HashFunction;
	_this
};

iniDB_Base64Encode = {
	_this = ["b64_enc", _this] call iniDB_HashFunction;
	_this
};

iniDB_Base64Decode = {
	_this = ["b64_dec", _this] call iniDB_HashFunction;
	_this
};

iniDB_exists = {
	private["_data"];
	_data = "iniDB" callExtension format["exists;%1", _this];
	_data = call compile _data;
	
	if((_data select 0) && (_data select 1)) then {
		true
	} else {
		false
	};
};

iniDB_delete = {
	_data = "iniDB" callExtension format["delete;%1", _this];
	_data = call compile _data;
	
	if((_data select 0)) then {
		true
	} else {
		false
	};
};

iniDB_readRaw = {
	private["_file", "_sec", "_key", "_data"];
	_file = _this select 0;
	_sec = _this select 1;
	_key = _this select 2;
	_data = "iniDB" callExtension format["read;%1;%2;%3", _file, _sec, _key];
	_data = call compile _data;
	
	if((_data select 0)) then {
		_data select 1
	} else {
		false
	};
};

iniDB_writeRaw = {
	private["_file", "_sec", "_key", "_val", "_data"];
	_file = _this select 0;
	_sec = _this select 1;
	_key = _this select 2;
	_val = _this select 3;
	_data = "iniDB" callExtension format["write;%1;%2;%3;%4", _file, _sec, _key, _val];
	_data = call compile _data;

	if((_data select 0)) then {
		true
	} else {
		false
	};
};

iniDB_Datarizer = {
	private["_string", "_type"];
	_string = _this select 0;
	_type = _this select 1;
	
	if(_type == "ARRAY") then {
		_string = call compile _string;
	} else {
		if((_type == "SCALAR") || (_type == "NUMBER")) then { // "NUMBER" is less confusing for new folks
			_string = parseNumber _string;
		};
	};
	
	_string
};

iniDB_read = {
	private["_file", "_sec", "_key", "_type", "_data"];
	_file = _this select 0;
	_sec = _this select 1;
	_key = _this select 2;
	_data = [_file, _sec, _key] call iniDB_readRaw;
	
	if((count _this) > 2) then {
		_type = _this select 3;
		_data = [_data, _type] call iniDB_Datarizer;
	};
	
	_data
};

iniDB_write = {
	private["_file", "_sec", "_key", "_data"];
	_file = _this select 0;
	_sec = _this select 1;
	_key = _this select 2;
	_data = _this select 3;
	
	_data = format['"%1"', _data];
	_data = [_file, _sec, _key, _data] call iniDB_writeRaw;
	_data
};


execVM "persistentscripts\oSave.sqf";
execVM "persistentscripts\oLoad.sqf";