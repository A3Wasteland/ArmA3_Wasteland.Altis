private ["_saveToDB","_array","_varName","_varValue","_saveArray","_loadFromDB","_type","_loadArray"];
_saveToDB =
"
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
	_array = _this;
	_uid = _array select 1;
	_varName = _array select 2;
	_type = _array select 3;
	_loadArray = [_uid, _uid, _varName, _type];
	accountToClient = [_uid,_varName,_loadArray call iniDB_read];
	publicVariable 'accountToClient';
";

loadFromDB = compile _loadFromDB;

_AccountExists = 
"	
	_Player = _this Select 0;
	_UID = GetPlayerUID _Player;
	_Exists = _UID call iniDB_exists;
	_Player SetVariable [""AccountExists"", _Exists, True];
";
AccountExists = compile _AccountExists;

"accountToServerSave" addPublicVariableEventHandler 
{
	(_this select 1) spawn saveToDB;
};

"accountToServerLoad" addPublicVariableEventHandler 
{
	(_this select 1) spawn loadFromDB;
};