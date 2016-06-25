// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_sortAlphabetically.sqf
//	@file Author: AgentRev

params [["_array",[],[[]]], ["_objCode",{},[{}]]];

private _sort = _array apply { [if (_x isEqualType "") then [{_x},_objCode], _x] };
_sort sort true;

_sort apply {_x select 1}
