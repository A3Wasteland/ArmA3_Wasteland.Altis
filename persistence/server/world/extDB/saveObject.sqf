// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: saveObject.sqf
//	@file Author: AgentRev

#define FILTERED_CHARS [39,58] // single quote, colon

private ["_obj", "_manual", "_objectID", "_props", "_updateValues", "_key", "_val"];
_obj = _this select 0;
_manual = if (count _this > 2) then { _this select 2 } else { false };

_objectID = _obj getVariable "A3W_objectID";

if (isNil "_objectID") then
{
	_objectID = ([format ["newServerObject:%1:%2", call A3W_extDB_ServerID, call A3W_extDB_MapID], 2] call extDB_Database_async) select 0;
	_obj setVariable ["A3W_objectID", _objectID, true];
};

_props = [_obj] call fn_getObjectProperties;

_updateValues = "";

{
	_key = _x select 0;
	_val = _x select 1;

	_val = if (typeName _val == "SCALAR") then {
		_val call fn_numToStr
	} else {
		format ["'%1'", toString (toArray str _val - FILTERED_CHARS)]
	};

	_updateValues = _updateValues + format ["%1%2=%3", if (_updateValues != "") then { "," } else { "" }, _key, _val];
} forEach _props;

_updateValues = _updateValues + format [",Locked=%1", if (_obj getVariable ["objectLocked", false]) then { 1 } else { 0 }];

if (_manual) then
{
	_updateValues = _updateValues + ",LastInteraction=NOW()";
};

[format ["updateServerObject:%1:", _objectID] + _updateValues] call extDB_Database_async;

_objectID
