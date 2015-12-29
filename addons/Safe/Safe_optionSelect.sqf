// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: Safe_optionSelect.sqf
//	@file Author: LouD / Cael817 for original script
//	@file Description: Safe script

#define Safe_Menu_option 17001
disableSerialization;

private ["_panelType","_displaySafe","_Safe_select","_money"];
_uid = getPlayerUID player;
if (!isNil "_uid") then
{
	_panelType = _this select 0;

	_displaySafe = uiNamespace getVariable ["Safe_Menu", displayNull];

	switch (true) do
	{
		case (!isNull _displaySafe): //Safe panel
		{
			_Safe_select = _displaySafe displayCtrl Safe_Menu_option;

			switch (lbCurSel _Safe_select) do
			{
				case 0: //Lock Safe
				{
					closeDialog 0;					
					execVM "addons\Safe\Safe_lockDown.sqf";
				};
				case 1: //Release Safe Lock
				{
					closeDialog 0;					
					execVM "addons\Safe\Safe_releaseLockDown.sqf";
				};
				case 2: //Change Password
				{
					closeDialog 0;					
					execVM "addons\Safe\password_change.sqf";
				};					
			};
		};
	};
};
