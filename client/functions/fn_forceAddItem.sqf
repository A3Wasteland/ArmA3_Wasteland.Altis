// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_forceAddItem.sqf
//	@file Author: AgentRev

// This command was made because addMagazine, addItem, and canAddItemToXXX are not detecting free inventory space correctly in Arma 3 v1.34, another bug courtesy of BIS...
// Only use for magazines and items; addWeaponInventory should be used for weapons

private ["_unit", "_class", "_qty", "_container"];
_unit = _this select 0;
_class = _this select 1;
_qty = if (count _this > 2) then { _this select 2 } else { 1 };

_container = switch (true) do
{
	case ([_unit, _class, "uniform"] call fn_fitsInventory):  { uniformContainer _unit };
	case ([_unit, _class, "vest"] call fn_fitsInventory):     { vestContainer _unit };
	default                                                   { backpackContainer _unit };
};

if (!isNull _container) then
{
	if (isClass (configFile >> "CfgMagazines" >> _class)) then
	{
		_container addMagazineCargoGlobal [_class, _qty];
	}
	else
	{
		_container addItemCargoGlobal [_class, _qty];
	};
};
