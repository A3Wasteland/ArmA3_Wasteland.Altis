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

	_panelOptions = ["Player Management",
					"Vehicle Management",
					"Player Markers",
					"Unstuck player",
					"Teleport",
					"Teleport player to me",
					"Teleport me to player",
	                "Money",
	                "Debug Menu",
					"Object Search",
	                "Toggle God-mode",
					"Toggle Invisible-mode"
	];

	{
		_adminSelect lbAdd _x;
	} forEach _panelOptions;
};
