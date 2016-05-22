// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: optionSelect.sqf
//	@file Author: [404] Deadbeat
//	@file Created: 20/11/2012 05:19

#define debugMenu_option 50003
#define adminMenu_option 50001
disableSerialization;

private ["_panelType","_displayAdmin","_displayDebug","_adminSelect","_debugSelect","_money"];
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
					if (!isNil "notifyAdminMenu") then { ["PlayerManagement", "Opened"] call notifyAdminMenu };
				};
				case 1: //Full Vehicle Management
				{
					closeDialog 0;
					execVM "client\systems\adminPanel\vehicleManagement.sqf";
					if (!isNil "notifyAdminMenu") then { ["VehicleManagement", "Opened"] call notifyAdminMenu };
				};
				case 2: //Tags
				{
					execVM "client\systems\adminPanel\playerTags.sqf";
					//Is logged from inside target script
				};
				case 3: //Unstuck player
				{
					closeDialog 0;
					execVM "client\systems\adminPanel\unstuck.sqf";
					if (!isNil "notifyAdminMenu") then { ["UnstuckPlayer", "Used"] call notifyAdminMenu };
				};
				case 4: //Teleport
				{
					closeDialog 0;
					["A3W_teleport", "onMapSingleClick",
					{
						vehicle player setPos _pos;
						if (!isNil "notifyAdminMenu") then { ["teleport", _pos] spawn notifyAdminMenu };
						["A3W_teleport", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;
						true
					}] call BIS_fnc_addStackedEventHandler;
					hint "Click on map to teleport";
				};
				case 5: //Teleport player to me
				{
					closeDialog 0;
					execVM "client\systems\adminPanel\tptome.sqf";
					if (!isNil "notifyAdminMenu") then { ["TeleportToMe", "Used"] call notifyAdminMenu };
				};
				case 6: //Teleport me to player
				{
					closeDialog 0;
					execVM "client\systems\adminPanel\tpmeto.sqf";
					if (!isNil "notifyAdminMenu") then { ["TeleportMeTo", "Used"] call notifyAdminMenu };
				};
				case 7: //Money
				{
					_money = 5000;
					player setVariable ["cmoney", (player getVariable ["cmoney",0]) + _money, true];
					if (!isNil "notifyAdminMenu") then { ["money", _money] call notifyAdminMenu };
				};
				case 8: //Debug Menu
				{
					closeDialog 0;
					execVM "client\systems\adminPanel\loadDebugMenu.sqf";
					if (!isNil "notifyAdminMenu") then { ["LoadDebugMenu", "Opened"] call notifyAdminMenu };
				};
				case 9: //Object search menu
				{
					closeDialog 0;
					execVM "client\systems\adminPanel\loadObjectSearch.sqf";
					if (!isNil "notifyAdminMenu") then { ["ObjectSearch", "Opened"] call notifyAdminMenu };
				};
				case 10: // toggle God mode
				{
					execVM "client\systems\adminPanel\toggleGodMode.sqf";
					//Is logged from inside target script
				};
				case 11: // toggle God mode
				{
					execVM "client\systems\adminPanel\toggleInvisMode.sqf";
					//Is logged from inside target script
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
					[] call loadGunStore;
					if (!isNil "notifyAdminMenu") then { ["GunStore", "Opened"] call notifyAdminMenu };
				};
				case 1: //Access General Store
				{
					closeDialog 0;
					[] call loadGeneralStore;
					if (!isNil "notifyAdminMenu") then { ["GeneralStore", "Opened"] call notifyAdminMenu };
				};
				case 2: //Access Vehicle Store
				{
					closeDialog 0;
					[] call loadVehicleStore;
					if (!isNil "notifyAdminMenu") then { ["VehicleStore", "Opened"] call notifyAdminMenu };
				};
				case 3: //Access ATM Dialog
				{
					closeDialog 0;
					call mf_items_atm_access;
					if (!isNil "notifyAdminMenu") then { ["ATM", "Opened"] call notifyAdminMenu };
				};
				case 4: //Access Respawn Dialog
				{
					closeDialog 0;
					true spawn client_respawnDialog;
					if (!isNil "notifyAdminMenu") then { ["RespawnDialog", "Opened"] call notifyAdminMenu };
				};
				case 5: //Access Proving Grounds
				{
					closeDialog 0;
					createDialog "balca_debug_main";
					if (!isNil "notifyAdminMenu") then { ["ProvingGrounds", "Opened"] call notifyAdminMenu };
				};
				case 6: //Show server FPS function
				{
					hint format["Server FPS: %1",serverFPS];
					if (!isNil "notifyAdminMenu") then { ["ServerFPS", "Used"] call notifyAdminMenu };
				};
				case 7: //Unlock Base Objects within 15m
				{
					execVM "client\systems\adminPanel\unLock.sqf";
					if (!isNil "notifyAdminMenu") then { ["UnlockObjects", "Opened"] call notifyAdminMenu };
				};
				case 8: //Delete Unlocked Base Objects within 15m
				{
					execVM "client\systems\adminPanel\deleteUnlocked.sqf";
					if (!isNil "notifyAdminMenu") then { ["DeleteUnlockedObjects", "Opened"] call notifyAdminMenu };
				};
				case 9: //Relock objects within 30m
				{
					execVM "client\systems\adminPanel\reLock.sqf";
					if (!isNil "notifyAdminMenu") then { ["RelockObjects", "Opened"] call notifyAdminMenu };
				};
			};
		};
	};
};
