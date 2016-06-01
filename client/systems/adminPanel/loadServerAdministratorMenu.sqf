// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: loadServerAdministratorMenu.sqf
//	@file Author: [404] Deadbeat
//	@file Created: 20/11/2012 05:19
//	@file Args:

#define adminMenu_option 50001
disableSerialization;

private ["_start","_panelOptions","_displayAdmin","_adminSelect"];
_uid = getPlayerUID player;
if ([_uid, 3] call isAdmin) then {
	_start = createDialog "AdminMenu";

	_displayAdmin = uiNamespace getVariable "AdminMenu";
	_adminSelect = _displayAdmin displayCtrl adminMenu_option;

	_panelOptions = ["Player Management",	//0
					"Vehicle Management",	//1
					"Map Markers Log",		//2
					"Group Leader Markers",	//3
					"Unstuck player",		//4
					"Teleport",				//5
					"Teleport player to me",//6
					"Teleport me to player",//7
	                "Money",				//8
	                "Debug Menu",			//9
					"Object Search",		//10
	                "Toggle God-mode",		//11
					"Toggle Invisible-mode"	//12
	];

	{
		_adminSelect lbAdd _x;
	} forEach _panelOptions;
};
