//	@file Version: 1.2
//	@file Name: playerActions.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, [GoT] JoSchaap, AgentRev
//	@file Created: 20/11/2012 05:19

{ [player, _x] call fn_addManagedAction } forEach
[
	[format ["<img image='client\icons\playerMenu.paa' color='%1'/> <t color='%1'>[</t>Player Menu<t color='%1'>]</t>", "#FF8000"], "client\systems\playerMenu\init.sqf", [], -10, false], //, false, "", ""],

	["<img image='client\icons\money.paa'/> Pickup Money", "client\actions\pickupMoney.sqf", [], 1, false, false, "", "{_x getVariable ['owner', ''] != 'mission'} count (player nearEntities ['Land_Money_F', 5]) > 0"],

	["<img image='\a3\Ui_f\data\GUI\Cfg\CommunicationMenu\transport_ca.paa'/> <t color='#FFFFFF'>Cancel Action</t>", "noscript.sqf", "doCancelAction = true", 1, false, false, "", "mutexScriptInProgress"],

	["<img image='client\icons\repair.paa'/> Salvage", "client\actions\salvage.sqf", [], 1.1, false, false, "", "!isNull cursorTarget && !alive cursorTarget && {cursorTarget isKindOf 'AllVehicles' && !(cursorTarget isKindOf 'Man') && player distance cursorTarget <= (sizeOf typeOf cursorTarget / 3) max 2}"],

	["<img image='client\icons\save.paa'/> Save Vehicle", "addons\scripts\vehiclesave.sqf", [cursorTarget], 1,false,false,"","!isNull cursorTarget && {{ cursorTarget isKindOf _x } count ['C_Kart_01_F', 'B_Quadbike_01_F', 'O_Quadbike_01_F', 'C_Quadbike_01_F', 'I_Quadbike_01_F', 'I_G_Quadbike_01_F', 'B_G_Quadbike_01_F', 'O_G_Quadbike_01_F', 'C_Hatchback_01_F', 'C_Hatchback_01_sport_F', 'C_SUV_01_F', 'C_Offroad_01_F', 'I_G_Offroad_01_F', 'I_G_Offroad_01_armed_F', 'B_G_Offroad_01_F', 'O_G_Offroad_01_F', 'B_G_Offroad_01_armed_F', 'O_G_Offroad_01_armed_F', 'C_Van_01_transport_F', 'B_G_Van_01_transport_F', 'C_Van_01_box_F', 'C_Van_01_fuel_F', 'B_G_Van_01_fuel_F', 'B_Truck_01_mover_F', 'B_Truck_01_box_F', 'B_Truck_01_transport_F', 'B_Truck_01_covered_F', 'B_Truck_01_fuel_F', 'B_Truck_01_medical_F', 'B_Truck_01_Repair_F', 'B_Truck_01_ammo_F', 'O_Truck_03_device_F', 'O_Truck_03_transport_F', 'O_Truck_03_covered_F', 'O_Truck_03_fuel_F', 'O_Truck_03_medical_F', 'O_Truck_03_repair_F', 'O_Truck_03_ammo_F', 'I_Truck_02_transport_F', 'I_Truck_02_covered_F', 'I_Truck_02_fuel_F', 'I_Truck_02_medical_F', 'I_Truck_02_box_F', 'I_Truck_02_ammo_F', 'B_MRAP_01_F', 'B_MRAP_01_hmg_F', 'B_MRAP_01_gmg_F', 'O_MRAP_02_F', 'O_MRAP_02_hmg_F', 'O_MRAP_02_gmg_F', 'I_MRAP_03_F', 'I_MRAP_03_hmg_F', 'I_MRAP_03_gmg_F', 'O_APC_Wheeled_02_rcws_F', 'B_APC_Wheeled_01_cannon_F', 'I_APC_Wheeled_03_cannon_F', 'B_APC_Tracked_01_CRV_F', 'B_APC_Tracked_01_rcws_F', 'I_APC_tracked_03_cannon_F', 'O_APC_Tracked_02_cannon_F', 'B_APC_Tracked_01_AA_F', 'O_APC_Tracked_02_AA_F', 'B_MBT_01_cannon_F', 'B_MBT_01_TUSK_F', 'O_MBT_02_cannon_F', 'I_MBT_03_cannon_F', 'B_Heli_Light_01_F', 'O_Heli_Light_02_unarmed_F', 'I_Heli_light_03_unarmed_F', 'I_Heli_Transport_02_F', 'B_Heli_Transport_01_F', 'B_Heli_Transport_01_camo_F', 'B_Heli_Light_01_armed_F', 'O_Heli_Light_02_F', 'I_Heli_light_03_F', 'B_Heli_Attack_01_F', 'O_Heli_Attack_02_F', 'O_Heli_Attack_02_black_F', 'I_Plane_Fighter_03_AA_F', 'I_Plane_Fighter_03_CAS_F', 'B_Plane_CAS_01_F', 'O_Plane_CAS_02_F', 'C_Rubberboat', 'B_Lifeboat', 'O_Lifeboat', 'B_Boat_Transport_01_F', 'O_Boat_Transport_01_F', 'I_Boat_Transport_01_F', 'B_G_Boat_Transport_01_F', 'C_Boat_Civil_01_F', 'C_Boat_Civil_rescue_01_F', 'C_Boat_Civil_police_01_F', 'O_Boat_Armed_01_hmg_F', 'B_Boat_Armed_01_minigun_F', 'I_Boat_Armed_01_minigun_F', 'B_SDV_01_F', 'O_SDV_01_F', 'I_SDV_01_F'] > 0 ;} && cursorTarget getVariable ['ownerUID',''] != getPlayerUID player and (player distance cursortarget) < 7"],
	["<img image='client\icons\save.paa'/> Re\Save Vehicle", "addons\scripts\resavevehicle.sqf", [cursorTarget], 1,false,false,"","!isNull cursorTarget && {{ cursorTarget isKindOf _x } count ['LandVehicle', 'Ship', 'Air'] > 0 ;} && cursorTarget getVariable ['ownerUID',''] == getPlayerUID player and (player distance cursortarget) < 7"],

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
