//	@file Version: 1.0
//	@file Name: optionSelect.sqf
//	@file Author: [404] Deadbeat
//	@file Created: 20/11/2012 05:19
//	@file Args:

#define debugMenu_option 50003
#define adminMenu_option 50001
disableSerialization;

private ["_panelType","_displayAdmin","_displayDebug","_adminSelect","_debugSelect"];
_uid = getPlayerUID player;
if (_uid call isAdmin) then
{
	_panelType = _this select 0;
	
	_displayAdmin = uiNamespace getVariable ["AdminMenu", displayNull];
	_displayDebug = uiNamespace getVariable ["DebugMenu", displayNull];
	
	switch (true) do
	{
	    case (!isNull _displayAdmin): //Admin panel
	    {
			_adminSelect = _displayAdmin displayCtrl adminMenu_option;
			
			switch (lbCurSel _adminSelect) do
			{
			    case 0: //Player Menu
				{
	                closeDialog 0;
					execVM "client\systems\adminPanel\playerMenu.sqf";
				};
				case 1: //Full Vehicle Management
				{
	                closeDialog 0;
					execVM "client\systems\adminPanel\vehicleManagement.sqf";
				};
			    case 2: //Tags
			    {
					execVM "client\systems\adminPanel\playerTags.sqf";
			    };
			    case 3: //Teleport
			    {
	                closeDialog 0;    
	                hint "Click on map to teleport";
	                onMapSingleClick "vehicle player setPos _pos; onMapSingleClick '';true;";
			    };
	            case 4: //Money
			    {      
					player setVariable ["cmoney", (player getVariable "cmoney") + 5000, true];
					if (!isNil "notifyAdminMenu") then { 5000 call notifyAdminMenu };
			    };
	            case 5: //Debug Menu
			    {   
	            	closeDialog 0;   
	                execVM "client\systems\adminPanel\loadDebugMenu.sqf";
			    };
				case 6: //Object search menu
			    {   
	            	closeDialog 0;
	                execVM "client\systems\adminPanel\loadObjectSearch.sqf";
			    };
			    case 7: // toggle God mode
			    {
			    	execVM "client\systems\adminPanel\toggleGodMode.sqf";
			    };
			};
	    };
	    case (!isNull _displayDebug): //Debug panel
	    {
			_debugSelect = _displayDebug displayCtrl debugMenu_option;
			
			switch (lbCurSel _debugSelect) do
			{
			    case 0: //Access Gun Store
				{
	                closeDialog 0;
					execVM "client\systems\gunStore\loadGunStore.sqf";
				};
				case 1: //Access General Store
				{
	                closeDialog 0;
					execVM "client\systems\generalStore\loadGenStore.sqf";
				};
				case 2: //Access Vehicle Store
				{
	                closeDialog 0;
					execVM "client\systems\vehicleStore\loadVehicleStore.sqf";
				};
			    case 3: //Access Respawn Dialog
			    {
	                closeDialog 0;
					true spawn client_respawnDialog;
			    };
			    case 4: //Access Proving Grounds
			    {
	                closeDialog 0;      
					createDialog "balca_debug_main";
			    };
	            case 5: //Show server FPS function
			    {      
					hint format["Server FPS: %1",serverFPS];
			    };
	            case 6: //Test Function
			    {
                    _group = createGroup civilian;
					_leader = _group createunit ["C_man_polo_1_F", getPos player, [], 0.5, "Form"];
                    
					_leader addMagazine "RPG32_HE_F";
					_leader addMagazine "RPG32_HE_F";
					_leader addWeapon "launch_RPG32_F";
					_leader addMagazine "30Rnd_556x45_Stanag";
					_leader addMagazine "30Rnd_556x45_Stanag";
					_leader addMagazine "30Rnd_556x45_Stanag";
					_leader addWeapon "arifle_TRG20_F";
			    };
			};		
	    };
	};
};
