// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: processMagazineCargo.sqf
//	@file Author: AgentRev

private ["_container", "_mags", "_mag", "_fullQty", "_ammoCounts"];
_container = _this select 0;
_mags = _this select 1;

if (isNull _container) exitWith {};

{
	_mag = _x select 0;
	_fullQty = _x select 1;
	_ammoCounts = _x select 2;

	_container addMagazineCargoGlobal [_mag, _fullQty];

	if (!isNil "_ammoCounts") then
	{
		{ _container addMagazineAmmoCargo [_mag, 1, _x] } forEach _ammoCounts;
	};
} forEach _mags;
