//	@file Version: 1.1
//	@file Name: checkAdmin.sqf
//	@file Author: [404] Deadbeat, AgentRev
//	@file Created: 20/11/2012 05:19
//	@file Args:

private ["_uid","_handle"];
_uid = getPlayerUID player;

switch (true) do
{
	case ([_uid, serverOwners] call isAdmin || isServer):
	{
		execVM "client\systems\adminPanel\loadServerAdministratorMenu.sqf";
		hint "Welcome Boss";
	};
	case ([_uid, highAdmins] call isAdmin):
	{
		execVM "client\systems\adminPanel\loadAdministratorMenu.sqf";
		hint "Welcome High Admin";
	};
	case ([_uid, lowAdmins] call isAdmin):
	{
		execVM "client\systems\adminPanel\loadModeratorMenu.sqf";
		hint "Welcome Admin";
	};
	case (serverCommandAvailable "#exec ban"):
	{
		execVM "client\systems\adminPanel\loadServerAdministratorMenu.sqf";
		hint "Welcome Boss";
	};
	case (serverCommandAvailable "#kick"):
	{
		execVM "client\systems\adminPanel\loadModeratorMenu.sqf";
		hint "Welcome Admin";
	};
};
