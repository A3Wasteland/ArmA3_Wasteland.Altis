private ["_saveToDB","_array","_varName","_varValue","_saveArray","_loadFromDB","_type","_loadArray"];

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
		_cdata = call compile _data;

		if((_cdata select 0)) then {
			_cdata select 1
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
	diag_log format["iniDB_exists called with %1", _this];
	_data = "iniDB" callExtension format["exists;%1", _this];
	diag_log format["iniDB_exists returned %1", _data];
	_cdata = call compile _data;
	
	if((_cdata select 0) && (_cdata select 1)) then {
		true
	} else {
		false
	};
};

iniDB_delete = {
	_data = "iniDB" callExtension format["delete;%1", _this];
	_cdata = call compile _data;
	
	if((_cdata select 0)) then {
		true
	} else {
		false
	};
};

// =======================================================================

iniDB_readRaw = {
	private["_file", "_sec", "_key", "_data"];
	diag_log format["iniDB_readRaw called with %1", _this];
	_file = _this select 0;
	_sec = _this select 1;
	_key = _this select 2;
	_data = "iniDB" callExtension format["read;%1;%2;%3", _file, _sec, _key];
	diag_log format["iniDB_readRaw returned '%1'", _data];
	_cdata = [false];
	if (_data != "") then {
		_cdata = call compile _data;
	};
	
	if((_cdata select 0)) then {
		_cdata select 1
	} else {
		""
	};
};

iniDB_writeRaw = {
	private["_file", "_sec", "_key", "_val", "_data"];
	diag_log format["iniDB_writeRaw called with %1", _this];

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
};

// =======================================================================

iniDB_Datarizer = {
	private["_string", "_type", "_return"];
	diag_log format["iniDB_Datarizer called with %1", _this];
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
};

iniDB_read = {
	private["_file", "_sec", "_key", "_type", "_data"];
	diag_log format["iniDB_read called with %1", _this];

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
	diag_log format["iniDB_write called with %1", _this];

	_file = _this select 0;
	_sec = _this select 1;
	_key = _this select 2;
	_data = _this select 3;
	
	_data = format['"%1"', _data];
	_data = [_file, _sec, _key, _data] call iniDB_writeRaw;
	_data
};

_saveToDB =
"
	diag_log format['_saveToDB called with %1', _this];
	_array = _this;
	_uid = _array select 1;
	_varName = _array select 2;
	_varValue = _array select 3;
	_saveArray = [_uid, _uid, _varName, _varValue];
	_saveArray call iniDB_write;
";

saveToDB = compile _saveToDB;

_loadFromDB =
"
	diag_log format['_loadFromDB called with %1', _this];
	_array = _this;
	_uid = _array select 1;
	_varName = _array select 2;
	_varType = _array select 3;
	if ([_uid] call accountExists) then {
		diag_log ""account exists!"";
		_loadArray = [_uid, _uid, _varName, _varType];
		accountToClient = [_uid,_varName,_loadArray call iniDB_read];
		diag_log format['setting accountToClient to %1', accountToClient];
		publicVariable 'accountToClient';
	} else {
		diag_log format[""Account doesn't exist so we cannot load %1. Sending back nothing!"", _varName];
		accountToClient = [_uid, _varName];
		publicVariable 'accountToClient';
	};
";

loadFromDB = compile _loadFromDB;

_accountExists = 
"	
	_uid = _this Select 0;
	_exists = _uid call iniDB_exists;
	_exists
";
accountExists = compile _accountExists;

"accountToServerSave" addPublicVariableEventHandler 
{
	(_this select 1) spawn saveToDB;
};

"accountToServerLoad" addPublicVariableEventHandler 
{
	(_this select 1) spawn loadFromDB;
};

