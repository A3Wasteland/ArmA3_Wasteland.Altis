// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: list.sqf
//	@file Author: MercyfulFate, AgentRev
//	@file Function: mf_inventory_list

// Lists all item ids and the quantity the player has ([_id, _qty, _objType], ...])

#include "define.sqf"

params [["_broadcast",false,[false]]];

private "_type";
_list = [];

{
	_x params ["_id", "_qty"];
	_type = (_id call mf_inventory_get) select 4;
	_list pushBack [_id, _qty, _type];
} forEach call mf_inventory_all;

if (_broadcast) then
{
	player setVariable ["mf_inventory_list", _list, true];
};

_list
