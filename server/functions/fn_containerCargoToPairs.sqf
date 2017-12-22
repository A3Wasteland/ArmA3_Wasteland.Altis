// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2017 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_containerCargoToPairs.sqf
//	@file Author: AgentRev

params [["_container",objNull,[objNull]], ["_subcontainer",false,[false]]];

if (isNull _container) exitWith { [[],[],[],[]] };

private _weapons = [];
private _magsCargo = magazinesAmmoCargo _container;
private _items = (getItemCargo _container) call cargoToPairs;
private _backpacks = (getBackpackCargo _container) call cargoToPairs;

{
	([_x select 1, true] call fn_containerCargoToPairs) params ["_contWeaps", "_contMags", "_contItems", "_contBacks"];
	[_weapons, _contWeaps] call fn_mergePairs;
	[_items, _contItems] call fn_mergePairs;
	[_backpacks, _contBacks] call fn_mergePairs;
	_magsCargo append _contMags;
} forEach everyContainer _container;

private ["_weapon", "_linkedItems", "_item"];

{
	_weapon = _x deleteAt 0;
	[_weapons, _weapon, 1] call fn_addToPairs;
	_linkedItems = (configProperties [configFile >> "CfgWeapons" >> _weapon >> "LinkedItems", "isClass _x"]) apply {getText (_x >> "item")};

	{
		if !(_x in ["",[]]) then
		{
			_item = _x;

			if (_item isEqualType "" && {{_item == _x} count _linkedItems == 0}) then
			{
				[_items, _item, 1] call fn_addToPairs;
			};
			if (_item isEqualType [] && {_item isEqualTypeArray ["",0]}) then
			{
				_magsCargo pushBack _item;
			};
		};
	} forEach _x;
} forEach weaponsItemsCargo _container;

private _magazines = [];

if (_subcontainer) then
{
	_magazines = _magsCargo;
}
else
{
	{
		_x params ["_mag", "_ammo"];

		if (_ammo == getNumber (configFile >> "CfgMagazines" >> _mag >> "count")) then
		{
			// Full mags
			[_magazines, _mag, 1] call fn_addToPairs;
		}
		else
		{
			// Partial mags
			_added = false;

			{
				if (_x select 0 == _mag) exitWith
				{
					_ammoArr = _x param [2,[]];
					_ammoArr pushBack _ammo;
					_x set [2, _ammoArr];

					_added = true;
				};
			} forEach _magazines;

			if (!_added) then
			{
				_magazines pushBack [_mag, 0, [_ammo]];
			};
		};
	} forEach _magsCargo;
};

[
	_weapons,
	_magazines, // [[class, fullCount(, [partialAmmo, ...])], ...]
	_items,
	_backpacks
]
