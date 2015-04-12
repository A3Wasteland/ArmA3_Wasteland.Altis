// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: splitWeaponItems.sqf
//	@file Author: AgentRev

private ["_array", "_weapon", "_items", "_mags", "_i", "_item", "_mag"];

_array = _this;
_weapon = _array select 0;

_items = [];
_mags = [];

// attachments
for "_i" from 1 to 3 do
{
	_item = _array select _i;

	if (_item != "") then
	{
		_items pushBack _item;
	};
};

// mags
for "_i" from 4 to (count _array - 2) do
{
	_mag = _array select _i;

	if (count _mag > 1 && {_mag select 1 > 0}) then
	{
		_mags pushBack _mag;
	};
};

// bipod
_item = _array select (count _array - 1);
if (_item != "") then
{
	_items pushBack _item;
};

[_weapon, _items, _mags]
