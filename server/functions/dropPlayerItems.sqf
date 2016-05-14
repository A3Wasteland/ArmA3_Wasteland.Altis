// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2015 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: dropPlayerItems.sqf
//	@file Author: AgentRev

params [["_corpse",objNull,[objNull]], ["_money",0,[0]], ["_items",[],[[]]]];

if (isNull _corpse) exitWith {};

private "_veh";
waitUntil
{
	sleep 0.1;

	// apparently, if the corpse is stuck in a vehicle wreck, "vehicle _corpse" returns the corpse itself, hence why the workaround below is needed; as usual, thanks BIS for breaking stuff all the time!!!!!!!!
	_veh = objectParent _corpse;
	if (isNull _veh) then { _veh = _corpse };

	isNull _corpse || (_veh == _corpse && {(isTouchingGround _corpse || (getPos _corpse) select 2 < 1) && vectorMagnitude velocity _corpse < 1}) || _corpse getVariable ["A3W_corpseEjected", false]
};

if (isNull _corpse) exitWith {};

private _targetPos = getPosWorld _veh;
_targetPos set [2, (getPosATL _corpse) select 2];

if (_veh != _corpse && damage _veh > 0.99) then
{
	// if corpse is stuck in vehicle wreck, spawn items away from vehicle, at a distance relative to vehicle's size and center
	_targetPos = _targetPos vectorAdd ([[0, _veh call fn_vehSafeDistance, 1], -([_veh, _corpse] call BIS_fnc_dirTo)] call BIS_fnc_rotateVector2D);
};

if (_money <= 0) then
{
	_money = _corpse getVariable ["cmoney", 0];
};

if (_money > 0) then
{
	_m = createVehicle ["Land_Money_F", _targetPos, [], 1, "CAN_COLLIDE"];
	_m setDir random 360;
	_m setVariable ["cmoney", _money, true];
	_m setVariable ["owner", "world", true];
};

if (_items isEqualTo []) then
{
	_items = _corpse getVariable ["mf_inventory_list", []];
};

{
	_x params [["_id","",[""]], ["_qty",0,[0]], ["_type","",[""]]];

	for "_i" from 1 to _qty do
	{
		_obj = createVehicle [_type, _targetPos, [], 1, "CAN_COLLIDE"];
		_obj setDir random 360;
		_obj setVariable ["mf_item_id", _id, true];
		_obj setVariable ["processedDeath", diag_tickTime];
	};
} forEach _items;
