// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2015 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: dropPlayerItems.sqf
//	@file Author: AgentRev

private ["_corpse", "_money", "_items"];
_corpse = param [0, objNull, [objNull]];
_money = param [1, 0, [0]];
_items = param [2, [], [[]]];

if (isNull _corpse || alive _corpse || (_money < 1 && count _items == 0)) exitWith {};

waitUntil
{
	sleep 0.1;
	isNull _corpse || (vehicle _corpse == _corpse && {(isTouchingGround _corpse || (getPos _corpse) select 2 < 1) && vectorMagnitude velocity _corpse < 1})
};

if (isNull _corpse) exitWith {};

if (_money > 0) then
{
	_m = createVehicle ["Land_Money_F", getPosATL _corpse, [], 0.5, "CAN_COLLIDE"];
	_m setDir random 360;
	_m setVariable ["cmoney", _money, true];
	_m setVariable ["owner", "world", true];
};

{
	_id = _x select 0;
	_qty = _x select 1;
	_type = _x select 2;

	for "_i" from 1 to _qty do
	{
		_obj = createVehicle [_type, getPosATL _corpse, [], 0.5, "CAN_COLLIDE"];
		_obj setDir random 360;
		_obj setVariable ["mf_item_id", _id, true];
		_obj setVariable ["processedDeath", diag_tickTime];
	};
} forEach _items;
