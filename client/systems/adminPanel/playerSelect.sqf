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
				if (_spectating == "Spectate") then {
					_spectateButton ctrlSetText "Spectating";
					//player commandChat format ["Viewing %1.", name _target];

					if (!isNil "_camadm") then { camDestroy _camadm; };
					_camadm = "camera" camCreate ([(position vehicle _target select 0) - 5,(position vehicle _target select 1), (position vehicle _target select 2) + 10]);
					_camadm cameraEffect ["external", "TOP"];
					_camadm camSetTarget (vehicle _target);
					_camadm camCommit 1;

					_rnum = 0;
					while {ctrlText _spectateButton == "Spectating"} do {
						switch (_rnum) do
						{
							if (daytime > 19 || daytime < 5) then {camUseNVG true;} else {camUseNVG false;};
							case 0: {detach _camadm; _camadm attachTo [(vehicle _target), [0,-10,4]]; _camadm setVectorUp [0, 1, 5];};
							case 1: {detach _camadm; _camadm attachTo [(vehicle _target), [0,10,4]]; _camadm setDir 180; _camadm setVectorUp [0, 1, -5];};
							case 2: {detach _camadm; _camadm attachTo [(vehicle _target), [0,1,50]]; _camadm setVectorUp [0, 50, 1];};
							case 3: {detach _camadm; _camadm attachTo [(vehicle _target), [-10,0,2]]; _camadm setDir 90; _camadm setVectorUp [0, 1, 5];};
							case 4: {detach _camadm; _camadm attachTo [(vehicle _target), [10,0,2]]; _camadm setDir -90; _camadm setVectorUp [0, 1, -5];};
						};
						player commandchat "Viewing cam " + str(_rnum) + " on " + str(name vehicle _target);
						_rnum = _rnum + 1;
						if (_rnum > 4) then {_rnum = 0;};
						sleep 5;
					};
				} else {
					_spectateButton ctrlSetText "Spectate";
					player commandchat format ["No Longer Viewing.", name _target];
					player cameraEffect ["terminate","back"];
					if (!isNil "_camadm") then { camDestroy _camadm; };
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
			//[{player setDamage 1; endMission "LOSER"; deleteVehicle player}, "BIS_fnc_spawn", _target, false] call A3W_fnc_MP;
			["This option has been disabled due to exploiting by hackers."] spawn BIS_fnc_guiMessage;
		};
		case 3: //Unlock Team Switcher
		{
			pvar_teamSwitchUnlock = getPlayerUID _target;
			publicVariableServer "pvar_teamSwitchUnlock";
		};
		case 4: //Unlock Team Killer
		{
			_targetUID = getPlayerUID _target;
			{
				if(_x select 0 == _targetUID) then
				{
					pvar_teamKillList = [pvar_teamKillList, _forEachIndex] call BIS_fnc_removeIndex;
					publicVariable "pvar_teamKillList";
				};
			}forEach pvar_teamKillList;
		};
		case 5: //Remove All Money
		{
			_targetUID = getPlayerUID _target;
			{
				if(getPlayerUID _x == _targetUID) exitWith
				{
					_x setVariable["cmoney",0,true];
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
