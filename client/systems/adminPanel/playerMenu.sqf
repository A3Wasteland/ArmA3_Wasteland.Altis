// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: playerMenu.sqf
//	@file Author: [404] Deadbeat
//	@file Created: 20/11/2012 05:19
//	@file Args:

#define playerMenuDialog 55500
#define playerMenuPlayerList 55505

disableSerialization;

private ["_start","_dialog","_playerListBox","_decimalPlaces","_health","_namestr","_index","_punishCount","_side"];
_uid = getPlayerUID player;
if (_uid call isAdmin) then
{
	_start = createDialog "PlayersMenu";
	_punishCount = 0;
	_lockedSide = "None";
	_dialog = findDisplay playerMenuDialog;
	_playerListBox = _dialog displayCtrl playerMenuPlayerList;

	{
		_uid = getPlayerUID _x;
		{if((_x select 0) == _uid) then {_punishCount = (_x select 1);};}forEach pvar_teamKillList;
		{if((_x select 0) == _uid) then {if(_x select 1 == WEST) then {_lockedSide = "BLUFOR";};if(_x select 1 == EAST) then {_lockedSide = "OPFOR";};};}forEach pvar_teamSwitchList;
		if(side _x == west) then {_side = "BLUFOR";};
		if(side _x == east) then {_side = "OPFOR";};
		if(side _x == INDEPENDENT) then {_side = "Independent";};
		_namestr = name(_x) + " [UID:" + getplayerUID(_x) + "] [Side:" + format["%1",_side] + "] [Team Lock:"+format["%1",_lockedSide]+"] [Punish Count:" + format["%1",_punishCount]+ "]";
		_index = _playerListBox lbAdd _namestr;
		_playerListBox lbSetData [_index, str(_x)];
		_punishCount = 0;
	} forEach playableUnits;
};
