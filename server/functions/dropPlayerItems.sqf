// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2015 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: dropPlayerItems.sqf
//	@file Author: AgentRev

private ["_corpse", "_money", "_items", "_veh", "_targetPos"];
_corpse = param [0, objNull, [objNull]];
_money = param [1, 0, [0]];
_items = param [2, [], [[]]];

if (isNull _corpse || alive _corpse || (_money < 1 && count _items == 0)) exitWith {};

waitUntil
{
	sleep 0.1;

	// apparently, if the corpse is stuck in a vehicle wreck, "vehicle _corpse" returns the corpse itself, hence why the workaround below is needed; as usual, thanks BIS for breaking stuff all the time!!!!!!!!
	_veh = objectParent _corpse;
	if (isNull _veh) then { _veh = _corpse };

	isNull _corpse || (_veh == _corpse && {(isTouchingGround _corpse || (getPos _corpse) select 2 < 1) && vectorMagnitude velocity _corpse < 1}) || _corpse getVariable ["A3W_corpseEjected", false]
};

if (isNull _corpse) exitWith {};

_targetPos = getPosWorld _veh;
_targetPos set [2, (getPosATL _corpse) select 2];

if (_veh != _corpse && damage _veh > 0.99) then
{
	// if corpse is stuck in vehicle wreck, spawn items away from vehicle, at a distance relative to vehicle's size and center
	_targetPos = _targetPos vectorAdd ([[0, _veh call fn_vehSafeDistance, 1], -([_veh, _corpse] call BIS_fnc_dirTo)] call BIS_fnc_rotateVector2D);
};

if (_money > 0) then
{
	_m = createVehicle ["Land_Money_F", _targetPos, [], 1, "CAN_COLLIDE"];
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
		_obj = createVehicle [_type, _targetPos, [], 1, "CAN_COLLIDE"];
		_obj setDir random 360;
		_obj setVariable ["mf_item_id", _id, true];
		_obj setVariable ["processedDeath", diag_tickTime];
	};
} forEach _items;
