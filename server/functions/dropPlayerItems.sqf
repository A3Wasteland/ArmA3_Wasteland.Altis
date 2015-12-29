// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2015 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: dropPlayerItems.sqf
//	@file Author: AgentRev

private ["_corpse", "_money", "_items", "_firstVeh", "_veh", "_targetPos", "_burningVeh", "_vehSize"];
_corpse = param [0, objNull, [objNull]];
_money = param [1, 0, [0]];
_items = param [2, [], [[]]];

_firstVeh = vehicle _corpse;

if (isNull _corpse || alive _corpse || (_money < 1 && count _items == 0)) exitWith {};

waitUntil
{
	sleep 0.1;
	_veh = vehicle _corpse;

	// apparently, if the corpse is in a destroyed vehicle, "vehicle _corpse" returns the corpse itself, hence why the workaround below is needed; as usual, thanks BIS for breaking stuff all the time!!!!!!!!
	if (_veh != _firstVeh && _corpse in crew _firstVeh) then
	{
		_veh = _firstVeh;
	};

	isNull _corpse || (_veh == _corpse && {(isTouchingGround _corpse || (getPos _corpse) select 2 < 1) && vectorMagnitude velocity _corpse < 1}) || _corpse getVariable ["A3W_corpseEjected", false]
};

if (isNull _corpse) exitWith {};

_targetPos = getPosATL _corpse;
_burningVeh = (_veh != _corpse && damage _veh > 0.99);

if (_burningVeh) then
{
	_vehSize = sizeOf typeOf _veh;
	_targetPos = _targetPos vectorAdd ([[0, ((_vehSize / 2) + random (_vehSize / 6)) - (_corpse distance _veh), 1], -([_veh, _corpse] call BIS_fnc_dirTo)] call BIS_fnc_rotateVector2D);
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
