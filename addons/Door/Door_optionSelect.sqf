// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: Door_optionSelect.sqf
//	@file Author: LouD / Cael817 for original script
//	@file Description: Door script

#define Door_Menu_option 17001
disableSerialization;

private ["_panelType","_displayDoor","_Door_select","_money"];
_uid = getPlayerUID player;
if (!isNil "_uid") then
{
	_panelType = _this select 0;

	_displayDoor = uiNamespace getVariable ["Door_Menu", displayNull];

	switch (true) do
	{
		case (!isNull _displayDoor): //Door panel
		{
			_Door_select = _displayDoor displayCtrl Door_Menu_option;

			switch (lbCurSel _Door_select) do
			{
				case 0: //Lock Door
				{
					closeDialog 0;					
					execVM "addons\Door\Door_openDoor.sqf";
				};
				case 1: //Unlock Door
				{
					closeDialog 0;					
					execVM "addons\Door\Door_closeDoor.sqf";
				};
				case 2: //Change Password
				{
					closeDialog 0;					
					execVM "addons\Door\password_change.sqf";
				};					
			};
		};
	};
};
