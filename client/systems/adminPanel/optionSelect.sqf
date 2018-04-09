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
				};
				case 1: //Full Vehicle Management
				{
					closeDialog 0;
					execVM "client\systems\adminPanel\vehicleManagement.sqf";
				};
				case 2: //Markers log
				{
					closeDialog 0;
					createDialog "MarkerLog";
				};
				case 3: //Tags
				{
					execVM "client\systems\adminPanel\playerTags.sqf";
				};
				case 4: //Teleport
				{
					closeDialog 0;
					["A3W_teleport", "onMapSingleClick",
					{
						private "_waterPos";
						if (surfaceIsWater _pos) then
						{
							_top = +_pos;
							_top set [2, (_top select 2) + 1000];
							_buildings = (lineIntersectsSurfaces [_top, _pos, objNull, objNull, true, -1, "GEOM", "NONE"]) select {(_x select 2) isKindOf "Building"};

							if !(_buildings isEqualTo []) then
							{
								_waterPos = _buildings select 0 select 0;
							};
						};
						if (isNil "_waterPos") then { vehicle player setPos _pos } else { vehicle player setPosASL _waterPos };
						if (!isNil "notifyAdminMenu") then { ["teleport", _pos] spawn notifyAdminMenu };
						["A3W_teleport", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;
						true
					}] call BIS_fnc_addStackedEventHandler;
					hint "Click on map to teleport";
				};
				case 5: //Money
				{
					_money = 5000;
					//player setVariable ["cmoney", (player getVariable ["cmoney",0]) + _money, true];
					[player, _money] call A3W_fnc_setCMoney;
					if (!isNil "notifyAdminMenu") then { ["money", _money] call notifyAdminMenu };
				};
				case 6: //Debug Menu
				{
					closeDialog 0;
					execVM "client\systems\adminPanel\loadDebugMenu.sqf";
				};
				case 7: //Object search menu
				{
					closeDialog 0;
					execVM "client\systems\adminPanel\loadObjectSearch.sqf";
				};
				case 8: // toggle God mode
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
					[] call loadGunStore;
				};
				case 1: //Access General Store
				{
					closeDialog 0;
					[] call loadGeneralStore;
				};
				case 2: //Access Vehicle Store
				{
					closeDialog 0;
					[] call loadVehicleStore;
				};
				case 3: //Access ATM Dialog
				{
					closeDialog 0;
					call mf_items_atm_access;
				};
				case 4: //Access Respawn Dialog
				{
					closeDialog 0;
					true spawn client_respawnDialog;
				};
				case 5: //Access Proving Grounds
				{
					closeDialog 0;
					createDialog "balca_debug_main";
				};
				case 6: //Show server FPS function
				{
					hint format["Server FPS: %1",serverFPS];
				};
				case 7: //Test Function
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
