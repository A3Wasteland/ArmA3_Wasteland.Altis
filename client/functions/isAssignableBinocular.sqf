//	@file Version: 1.0
//	@file Name: isAssignableBinocular.sqf
//	@file Author: AgentRev
//	@file Created: 22/08/2013 21:54

private ["_player", "_item", "_slotEmpty"];

_player = _this select 0;
_item = _this select 1;
_slotEmpty = true;

if (getNumber (configFile >> "CfgWeapons" >> _item >> "type") == 4096 &&
   {getNumber (configFile >> "CfgWeapons" >> _item >> "ItemInfo" >> "type") != 616}) then
{
	{
		if (getNumber (configFile >> "CfgWeapons" >> _x >> "type") == 4096 &&
		   {getNumber (configFile >> "CfgWeapons" >> _x >> "ItemInfo" >> "type") != 616}) exitWith
		{
			_slotEmpty = false;
		};
	} forEach assignedItems player;
}
else
{
	_slotEmpty = false;
};

_slotEmpty
