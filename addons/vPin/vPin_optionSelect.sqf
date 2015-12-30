// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: vPin_optionSelect.sqf
//	@file Author: LouD (Original author: Cael817)
//	@file Description: vPin script

#define vPin_Menu_option 17001
disableSerialization;

private ["_panelType","_displayvPin","_vPin_select","_money"];
_uid = getPlayerUID player;
if (!isNil "_uid") then
{
	_panelType = _this select 0;

	_displayvPin = uiNamespace getVariable ["vPin_Menu", displayNull];

	switch (true) do
	{
		case (!isNull _displayvPin): // vPin panel
		{
			_vPin_select = _displayvPin displayCtrl vPin_Menu_option;

			switch (lbCurSel _vPin_select) do
			{
				case 0: // unlock Vehicle
				{
					closeDialog 0;					
					execVM "addons\vPin\vPin_openvPin.sqf";
				};
				case 1: // lock Vehicle
				{
					closeDialog 0;					
					execVM "addons\vPin\vPin_closevPin.sqf";
				};
				case 2: // Change Password
				{
					closeDialog 0;					
					execVM "addons\vPin\password_change.sqf";
				};					
			};
		};
	};
};
