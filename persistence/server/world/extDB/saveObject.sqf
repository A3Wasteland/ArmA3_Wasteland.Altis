// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: saveObject.sqf
//	@file Author: AgentRev

#define FILTERED_CHARS [39,58] // single quote, colon

private ["_obj", "_manual", "_objectID", "_updateValues", "_locked", "_deployable"];
_obj = _this select 0;
_manual = if (count _this > 2) then { _this select 2 } else { false };

_objectID = _obj getVariable "A3W_objectID";

if (!alive _obj) exitWith {nil};

if (isNil "_objectID") then
{
	_objectID = ([format ["newServerObject:%1:%2", call A3W_extDB_ServerID, call A3W_extDB_MapID], 2] call extDB_Database_async) select 0;
	[_obj, ["A3W_objectID", _objectID, true]] call fn_secureSetVar;
	[_obj, ["A3W_objectSaved", true, true]] call fn_secureSetVar;

	A3W_objectIDs pushBack _objectID;
};

_updateValues = [[_obj] call fn_getObjectProperties, 0] call extDB_pairsToSQL;

_locked = _obj getVariable ["objectLocked", false];
_deployable = (_obj getVariable ["a3w_spawnBeacon", false] || _obj getVariable ["a3w_warchest", false]);

_updateValues = _updateValues + (",Locked=" + (if (_locked) then { "1" } else { "0" }));
_updateValues = _updateValues + (",Deployable=" + (if (_deployable) then { "1" } else { "0" }));

if (_manual) then
{
	_updateValues = _updateValues + ",LastInteraction=NOW()";
};

[format ["updateServerObject:%1:", _objectID] + _updateValues] call extDB_Database_async;

_objectID
