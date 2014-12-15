// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: saveAccount.sqf
//	@file Author: AgentRev

#define FILTERED_CHARS [39,58] // single quote, colon

private ["_UID", "_info", "_data", "_insertValues", "_updateValues", "_key", "_val"];
_UID = _this select 0;
_info = _this select 1;
_data = _this select 2;

if (count _info > 0) then
{
	_insertValues = "";
	_updateValues = "";

	{
		_key = _x select 0;
		_val = _x select 1;

		_val = if (typeName _val == "SCALAR") then {
			_val call fn_numToStr
		} else {
			format ["'%1'", toString (toArray format ["%1", _val] - FILTERED_CHARS)]
		};

		_insertValues = _insertValues + format ["%1%2=%3", if (_insertValues != "") then { "," } else { "" }, _key, _val];
		_updateValues = _updateValues + format ["%1%2=VALUES(%2)", if (_updateValues != "") then { "," } else { "" }, _key];
	} forEach _info;

	[format ["insertOrUpdatePlayerInfo:%1:", _UID] + _insertValues + ":" + _updateValues] call extDB_Database_async;
};

if (count _data > 0) then
{
	_insertValues = "";
	_updateValues = "";

	{
		_key = _x select 0;
		_val = _x select 1;

		_val = if (typeName _val == "SCALAR") then {
			_val call fn_numToStr
		} else {
			format ["'%1'", toString (toArray str _val - FILTERED_CHARS)]
		};

		_insertValues = _insertValues + format ["%1%2=%3", if (_insertValues != "") then { "," } else { "" }, _key, _val];
		_updateValues = _updateValues + format ["%1%2=VALUES(%2)", if (_updateValues != "") then { "," } else { "" }, _key];
	} forEach _data;

	[format ["insertOrUpdatePlayerSave:%1:%2:", _UID, call A3W_extDB_MapID] + _insertValues + ":" + _updateValues] call extDB_Database_async;
};
