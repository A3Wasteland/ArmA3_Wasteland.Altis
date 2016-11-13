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
	_dialog = findDisplay playerMenuDialog;
	_playerListBox = _dialog displayCtrl playerMenuPlayerList;

	{
		_uid = getPlayerUID _x;
		_punishCount = 0;
		_lockedSide = "None";
		{ if (_x select 0 == _uid) exitWith { _punishCount = _x select 1 } } forEach pvar_teamKillList;
		{ if (_x select 0 == _uid) exitWith { _lockedSide = _x select 1 } } forEach pvar_teamSwitchList;
		_namestr = format ["%1 [Side:%3] [TLock:%4] [Punishes:%5]", name _x , getplayerUID _x, side _x, _lockedSide, _punishCount];
		_index = _playerListBox lbAdd _namestr;
		_playerListBox lbSetData [_index, _uid];
		_punishCount = 0;
	} forEach allPlayers;

	lbSort _playerListBox;
};
