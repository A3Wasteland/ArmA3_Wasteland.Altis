//	@file Version: 1.0
//	@file Name: loadServerAdministratorMenu.sqf
//	@file Author: [404] Deadbeat
//	@file Created: 20/11/2012 05:19
//	@file Args:

#define serverAdminMenu_option 50007
disableSerialization;

private ["_start","_panelOptions","_displayServerAdmin","_serverAdminSelect"];
_uid = getPlayerUID player;
if ((_uid in moderators) OR (_uid in administrators) OR (_uid in serverAdministrators)) then {
	_start = createDialog "ServerAdminMenu";
	
	_displayServerAdmin = uiNamespace getVariable "ServerAdminMenu";
	_serverAdminSelect = _displayServerAdmin displayCtrl serverAdminMenu_option;
	
	_panelOptions = ["Player Menu",
					"Vehicle Management",
					"Tags",
					"Teleport",
	                "Money",
	                "Debug Menu"
	];
	
	{
		_serverAdminSelect lbAdd _x;
	} forEach _panelOptions;
} else {
  exit;  
};