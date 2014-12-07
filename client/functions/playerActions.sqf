// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.2
//	@file Name: playerActions.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, [GoT] JoSchaap, AgentRev
//	@file Created: 20/11/2012 05:19

{ [player, _x] call fn_addManagedAction } forEach
[
	["Holster Weapon", { player action ["SwitchWeapon", player, player, 100] }, [], -11, false, false, "", "vehicle player == player && currentWeapon player != ''"],
	["Unholster Primary Weapon", { player action ["SwitchWeapon", player, player, 0] }, [], -11, false, false, "", "vehicle player == player && currentWeapon player == '' && primaryWeapon player != ''"],

	["Heal Self", "addons\scripts\healSelf.sqf",0,0,false,false,"","((damage player)>0.01 && (damage player)<0.25499) && ('FirstAidKit' in (items player)) && (vehicle player == player)"],
	["Resupply", "addons\scripts\fn_resupplytruck.sqf", [], 51, false, false, "", "!isNull cursorTarget && alive cursorTarget && {{ cursorTarget isKindOf _x } count ['O_Heli_Transport_04_ammo_F', 'I_Truck_02_ammo_F', 'O_Truck_03_ammo_F', 'B_Truck_01_ammo_F'] > 0 ;} && !(vehicle player == player) && (player distance cursortarget) < 10"],
	
	[format ["<img image='client\icons\playerMenu.paa' color='%1'/> <t color='%1'>[</t>Player Menu<t color='%1'>]</t>", "#FF8000"], "client\systems\playerMenu\init.sqf", [], -10, false],

	["Track Beacons", "addons\beacondetector\beacondetector.sqf",0,-10,false,false,"","('ToolKit' in (items player)) && !BeaconScanInProgress"],
	["<img image='\a3\Ui_f\data\GUI\Cfg\CommunicationMenu\transport_ca.paa'/> <t color='#FFFFFF'>Cancel tracking.</t>", "Beaconscanstop = true",0,-10,false,false,"","BeaconScanInProgress"],

	["<img image='client\icons\money.paa'/> Pickup Money", "client\actions\pickupMoney.sqf", [], 1, false, false, "", "{_x getVariable ['owner', ''] != 'mission'} count (player nearEntities ['Land_Money_F', 5]) > 0"],

	["<img image='\a3\Ui_f\data\GUI\Cfg\CommunicationMenu\transport_ca.paa'/> <t color='#FFFFFF'>Cancel Action</t>", { doCancelAction = true }, [], 1, false, false, "", "mutexScriptInProgress"],

	["<img image='client\icons\repair.paa'/> Salvage", "client\actions\salvage.sqf", [], 1.1, false, false, "", "!isNull cursorTarget && !alive cursorTarget && {cursorTarget isKindOf 'AllVehicles' && !(cursorTarget isKindOf 'Man') && player distance cursorTarget <= (sizeOf typeOf cursorTarget / 3) max 2}"],

	["<img image='client\icons\r3f_lock.paa'/> Lock", "addons\scripts\lockIn.sqf", [], 1, false, false, "", "count nearestObjects [player, ['MRAP_01_base_F', 'MRAP_02_base_F', 'MRAP_03_base_F', 'Wheeled_APC_F', 'Tank_F', 'O_Heli_Light_02_unarmed_F', 'I_Heli_light_03_unarmed_F', 'B_Heli_Transport_01_F', 'B_Heli_Transport_01_camo_F', 'O_Heli_Light_02_F', 'B_Heli_Attack_01_F', 'O_Heli_Attack_02_F', 'O_Heli_Attack_02_black_F'], 5] > 0 && !(vehicle player == player)"],
	["<img image='client\icons\r3f_unlock.paa'/> Unlock", "addons\scripts\unlock.sqf", [], 1, false, false, "", "count nearestObjects [player, ['MRAP_01_base_F', 'MRAP_02_base_F', 'MRAP_03_base_F', 'Wheeled_APC_F', 'Tank_F', 'O_Heli_Light_02_unarmed_F', 'I_Heli_light_03_unarmed_F', 'B_Heli_Transport_01_F', 'B_Heli_Transport_01_camo_F', 'O_Heli_Light_02_F', 'B_Heli_Attack_01_F', 'O_Heli_Attack_02_F', 'O_Heli_Attack_02_black_F'], 5] > 0 && !(vehicle player == player)"],
	["<img image='client\icons\r3f_lock.paa'/> Lock", "addons\scripts\lock.sqf", [cursorTarget], 1,false,false,"","!isNull cursorTarget && alive cursorTarget && {{ cursorTarget isKindOf _x } count ['StaticWeapon', 'MRAP_01_base_F', 'MRAP_02_base_F', 'MRAP_03_base_F', 'Wheeled_APC_F', 'Tank_F', 'O_Heli_Light_02_unarmed_F', 'I_Heli_light_03_unarmed_F', 'I_Heli_Transport_02_F', 'B_Heli_Transport_01_F', 'B_Heli_Transport_01_camo_F', 'B_Heli_Light_01_armed_F', 'O_Heli_Light_02_F', 'I_Heli_light_03_F', 'B_Heli_Attack_01_F', 'O_Heli_Attack_02_F', 'O_Heli_Attack_02_black_F', 'I_Plane_Fighter_03_AA_F', 'I_Plane_Fighter_03_CAS_F', 'B_Plane_CAS_01_F', 'O_Plane_CAS_02_F', 'Heli_Transport_04_base_F', 'B_Heli_Transport_03_base_F'] > 0 ;} && cursorTarget getVariable ['ownerUID',''] == getPlayerUID player && locked cursorTarget < 2 && cursorTarget distance player < 5"],
	["<img image='client\icons\r3f_unlock.paa'/> Unlock", "addons\scripts\unlock.sqf", [cursorTarget], 1,false,false,"","!isNull cursorTarget && alive cursorTarget && {{ cursorTarget isKindOf _x } count ['LandVehicle', 'Ship', 'Air'] > 0 ;} && cursorTarget getVariable ['ownerUID',''] == getPlayerUID player && locked cursorTarget >= 2 && cursorTarget distance player < 5"],
	["<img image='client\icons\r3f_unlock.paa'/> Pick Lock", "addons\scripts\lockPick.sqf", [cursorTarget], 1,false,false,"","!isNull cursorTarget && alive cursorTarget && {{ cursorTarget isKindOf _x } count ['LandVehicle', 'Ship', 'Air'] > 0 ;} && cursorTarget getVariable ['ownerUID',''] != getPlayerUID player && locked cursorTarget >= 2 && cursorTarget distance player < 5"],

	["<img image='client\icons\save.paa'/> Save Vehicle", "addons\scripts\vehicleSave.sqf", [cursorTarget], 1,false,false,"","!isNull cursorTarget && alive cursorTarget && {{ cursorTarget isKindOf _x } count ['C_Kart_01_F', 'Quadbike_01_base_F', 'Hatchback_01_base_F', 'SUV_01_base_F', 'Offroad_01_base_F', 'Van_01_base_F', 'MRAP_01_base_F', 'MRAP_02_base_F', 'MRAP_03_base_F', 'Truck_01_base_F', 'Truck_02_base_F', 'Truck_03_base_F', 'Wheeled_APC_F', 'Tank_F', 'Rubber_duck_base_F', 'SDV_01_base_F', 'Boat_Civil_01_base_F', 'Boat_Armed_01_base_F', 'B_Heli_Light_01_F', 'B_Heli_Light_01_armed_F', 'C_Heli_Light_01_civil_F', 'O_Heli_Light_02_unarmed_F', 'I_Heli_light_03_unarmed_F', 'B_Heli_Transport_01_F', 'B_Heli_Transport_01_camo_F', 'O_Heli_Light_02_F', 'I_Heli_light_03_F', 'B_Heli_Attack_01_F', 'O_Heli_Attack_02_F', 'O_Heli_Attack_02_black_F', 'I_Heli_Transport_02_F', 'Heli_Transport_04_base_F', 'B_Heli_Transport_03_base_F', 'I_Plane_Fighter_03_AA_F', 'I_Plane_Fighter_03_CAS_F', 'B_Plane_CAS_01_F', 'O_Plane_CAS_02_F'] > 0 ;} && cursorTarget getVariable ['ownerUID',''] != getPlayerUID player && locked cursorTarget != 2 && cursorTarget distance player < 5"],
	["<img image='client\icons\save.paa'/> Re\Save Vehicle", "addons\scripts\vehicleResave.sqf", [cursorTarget], 1,false,false,"","!isNull cursorTarget && alive cursorTarget && {{ cursorTarget isKindOf _x } count ['C_Kart_01_F', 'Quadbike_01_base_F', 'Hatchback_01_base_F', 'SUV_01_base_F', 'Offroad_01_base_F', 'Van_01_base_F', 'MRAP_01_base_F', 'MRAP_02_base_F', 'MRAP_03_base_F', 'Truck_01_base_F', 'Truck_02_base_F', 'Truck_03_base_F', 'Wheeled_APC_F', 'Tank_F', 'Rubber_duck_base_F', 'SDV_01_base_F', 'Boat_Civil_01_base_F', 'Boat_Armed_01_base_F', 'B_Heli_Light_01_F', 'B_Heli_Light_01_armed_F', 'C_Heli_Light_01_civil_F', 'O_Heli_Light_02_unarmed_F', 'I_Heli_light_03_unarmed_F', 'B_Heli_Transport_01_F', 'B_Heli_Transport_01_camo_F', 'O_Heli_Light_02_F', 'I_Heli_light_03_F', 'B_Heli_Attack_01_F', 'O_Heli_Attack_02_F', 'O_Heli_Attack_02_black_F', 'I_Heli_Transport_02_F', 'Heli_Transport_04_base_F', 'B_Heli_Transport_03_base_F', 'I_Plane_Fighter_03_AA_F', 'I_Plane_Fighter_03_CAS_F', 'B_Plane_CAS_01_F', 'O_Plane_CAS_02_F'] > 0 ;} && cursorTarget getVariable ['ownerUID',''] == getPlayerUID player && cursorTarget distance player < 5"],
	["<img image='client\icons\save.paa'/> Save Weapon", "addons\scripts\weaponSave.sqf", [cursorTarget], 1,false,false,"","!isNull cursorTarget && alive cursorTarget && {{ cursorTarget isKindOf _x } count ['StaticWeapon'] > 0 ;} && cursorTarget getVariable ['ownerUID',''] != getPlayerUID player && (player distance cursortarget) < 5"],
	["<img image='client\icons\save.paa'/> Re\Save Weapon", "addons\scripts\weaponResave.sqf", [cursorTarget], 1,false,false,"","!isNull cursorTarget && alive cursorTarget && {{ cursorTarget isKindOf _x } count ['StaticWeapon'] > 0 ;} && cursorTarget getVariable ['ownerUID',''] == getPlayerUID player && (player distance cursortarget) < 5"],
	["<img image='client\icons\money.paa'/> Sell Vehicle", "addons\scripts\sellVehicle.sqf", [], 51, false, false, "", "(vehicle player == player) && count nearestObjects [player, ['Land_Scrap_MRAP_01_F'], 15] > 0 && !isNull cursorTarget && alive cursorTarget && {{ cursorTarget isKindOf _x } count ['StaticWeapon', 'C_Kart_01_F', 'C_Kart_01_F', 'Quadbike_01_base_F', 'Hatchback_01_base_F', 'SUV_01_base_F', 'Offroad_01_base_F', 'Van_01_base_F', 'MRAP_01_base_F', 'MRAP_02_base_F', 'MRAP_03_base_F', 'Truck_01_base_F', 'Truck_02_base_F', 'Truck_03_base_F', 'Wheeled_APC_F', 'Tank_F', 'Rubber_duck_base_F', 'SDV_01_base_F', 'Boat_Civil_01_base_F', 'Boat_Armed_01_base_F', 'B_Heli_Light_01_F', 'B_Heli_Light_01_armed_F', 'C_Heli_Light_01_civil_F', 'O_Heli_Light_02_unarmed_F', 'I_Heli_light_03_unarmed_F', 'B_Heli_Transport_01_F', 'B_Heli_Transport_01_camo_F', 'O_Heli_Light_02_F', 'I_Heli_light_03_F', 'B_Heli_Attack_01_F', 'O_Heli_Attack_02_F', 'O_Heli_Attack_02_black_F', 'I_Heli_Transport_02_F', 'Heli_Transport_04_base_F', 'B_Heli_Transport_03_base_F', 'I_Plane_Fighter_03_AA_F', 'I_Plane_Fighter_03_CAS_F', 'B_Plane_CAS_01_F', 'O_Plane_CAS_02_F', 'UGV_01_base_F', 'UAV_02_base_F'] > 0 ;} && (player distance cursortarget) < 5"],

	["[0]"] call getPushPlaneAction,
	["Push vehicle", "server\functions\pushVehicle.sqf", [2.5, true], 1, false, false, "", "[2.5] call canPushVehicleOnFoot"],
	["Push vehicle forward", "server\functions\pushVehicle.sqf", [2.5], 1, false, false, "", "[2.5] call canPushWatercraft"],
	["Push vehicle backward", "server\functions\pushVehicle.sqf", [-2.5], 1, false, false, "", "[-2.5] call canPushWatercraft"],

	["<t color='#FF0000'>Emergency eject</t>", "client\actions\forceEject.sqf", [], -9, false, true, "", "(vehicle player) isKindOf 'Air'"],
	["<t color='#FF00FF'>Open magic parachute</t>", "client\actions\openParachute.sqf", [], 20, true, true, "", "vehicle player == player && (getPos player) select 2 > 2.5"]
];


// Hehehe...
if !(288520 in getDLCs 1) then
{
	[player, ["<t color='#00FFFF'>Get in as Driver</t>", "client\actions\moveInDriver.sqf", [], 6, true, true, "", "cursorTarget isKindOf 'Kart_01_Base_F' && player distance cursorTarget < 3.4 && isNull driver cursorTarget"]] call fn_addManagedAction;
};
