//	@file Name: splitWeaponItems.sqf
//	@file Author: AgentRev

private ["_array", "_weapon", "_items", "_mags", "_i", "_item", "_mag"];

_array = _this;
_weapon = _array select 0;

_items = [];
_mags = [];

for "_i" from 1 to 3 do
{
	_item = _array select _i;

	if (_item != "") then
	{
		_items set [count _items, _item];
	};
};

for "_i" from 4 to (count _array - 1) do
{
	_mag = _array select _i;

	if (count _mag > 1 && {_mag select 1 > 0}) then
	{
		_mags set [count _mags, _mag];
	};
};

[_weapon, _items, _mags]
