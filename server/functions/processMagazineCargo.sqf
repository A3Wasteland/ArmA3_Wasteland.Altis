// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: processMagazineCargo.sqf
//	@file Author: AgentRev

private ["_container", "_mags", "_addMag", "_mag", "_fullQty", "_ammoCounts", "_i"];
_container = _this select 0;
_mags = _this select 1;

if (isNull _container) exitWith {};

// the following kludge allows grenades restored to the player inventory to be thrown directly without requiring to drop and retake them
_addMag = switch (_container) do
{
	case (uniformContainer player):  { { for "_i" from 1 to _fullQty do { player addItemToUniform _mag } } };
	case (vestContainer player):     { { for "_i" from 1 to _fullQty do { player addItemToVest _mag } } };
	case (backpackContainer player): { { for "_i" from 1 to _fullQty do { player addItemToBackpack _mag } } };
	default                          { { _container addMagazineCargoGlobal [_mag, _fullQty] } };
};

{
	_mag = _x select 0;
	_fullQty = _x select 1;
	_ammoCounts = _x select 2;

	call _addMag;

	if (!isNil "_ammoCounts") then
	{
		{ _container addMagazineAmmoCargo [_mag, 1, _x] } forEach _ammoCounts;
	};
} forEach _mags;
