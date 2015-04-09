// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: playerSelect.sqf
//	@file Author: [404] Deadbeat
//	@file Created: 20/11/2012 05:19
//	@file Args:

#define playerMenuDialog 55500
#define playerMenuPlayerList 55505
#define playerMenuSpectateButton 55506
#define playerMenuWarnMessage 55509

disableSerialization;

private ["_dialog","_playerListBox","_spectateButton","_switch","_index","_modSelect","_playerData","_target","_check","_spectating","_camadm","_rnum","_warnText","_targetUID","_playerName"];
_uid = getPlayerUID player;
if (_uid call isAdmin) then
{
	_dialog = findDisplay playerMenuDialog;
	_playerListBox = _dialog displayCtrl playerMenuPlayerList;
	_spectateButton = _dialog displayCtrl playerMenuSpectateButton;
	_warnMessage = _dialog displayCtrl playerMenuWarnMessage;

	_switch = _this select 0;
	_index = lbCurSel _playerListBox;
	_playerData = _playerListBox lbData _index;

	{
		if (str(_x) == _playerData) then {
			_target = _x;
			_check = 1;
		};
	} forEach playableUnits;

	if (_check == 0) exitWith{};

	switch (_switch) do
	{
		case 0: //Spectate
		{
			if (!isNil "_target") then
			{
				_spectating = ctrlText _spectateButton;
				if (_spectating == "Spectate") then
				{
					if (!([player] call camera_enabled)) then
					{
						[] call camera_toggle;
					};

					[player, _target] call camera_attach_to_target;
					player commandChat format ["Viewing %1.", name _target];
					_spectateButton ctrlSetText "Spectating";
				} else {
					_spectateButton ctrlSetText "Spectate";
					player commandChat format ["No Longer Viewing.", name _target];

					if ([player] call camera_enabled) then
					{
						[] call camera_toggle;
					};
				};
			};
		};
		case 1: //Warn
		{
			_warnText = ctrlText _warnMessage;
			_playerName = name player;
			[format ["Message from Admin: %1", _warnText], "A3W_fnc_titleTextMessage", _target, false] call A3W_fnc_MP;
		};
		case 2: //Slay
		{
			_target setDamage 1;
		};
		case 3: //Unlock Team Switcher
		{
			pvar_teamSwitchUnlock = getPlayerUID _target;
			publicVariableServer "pvar_teamSwitchUnlock";
		};
		case 4: //Unlock Team Killer
		{
			pvar_teamKillUnlock = getPlayerUID _target;
			publicVariableServer "pvar_teamKillUnlock";
		};
		case 5: //Remove All Money
		{
			_targetUID = getPlayerUID _target;
			{
				if(getPlayerUID _x == _targetUID) exitWith
				{
					if (!isNil "notifyAdminMenu") then { ["RemoveMoney",format["c%1m%2UID%3",_x getVariable "cmoney",_x getVariable "bmoney",_targetUID]] call notifyAdminMenu };
					_x setVariable["cmoney",0,true];
					_x setVariable["bmoney",0,true];
					
				};
			}forEach playableUnits;
		};
		case 6: //Remove All Weapons
		{
			/*_targetUID = getPlayerUID _target;
			{
				if(getPlayerUID _x == _targetUID) exitWith
				{
					removeAllWeapons _x;
				};
			}forEach playableUnits;*/
			["This option has been disabled due to having never worked at all in the first place."] spawn BIS_fnc_guiMessage;
		};
		case 7: //Check Player Gear
		{
			/*_targetUID = getPlayerUID _target;
			{
				if(getPlayerUID _x == _targetUID) exitWith
				{
					createGearDialog [_x, "RscDisplayInventory"];
				};
			}forEach playableUnits;*/
			["This option has been disabled due to having never worked at all in the first place."] spawn BIS_fnc_guiMessage;
		};
	};
};
