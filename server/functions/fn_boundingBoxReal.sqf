// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_boundingBoxReal.sqf
//	@file Author: AgentRev

// Since BIS are unable to make a command that returns the actual, genuine bounding box of an object (boundingBoxReal is shit and boundingBox is ever shittier),
// I decided to extract the bounding boxes using an intersect scanner I made, which is at the bottom of this file

private ["_vehicle", "_vehClass", "_realBoundingBoxes", "_boundingBoxReal"];
_vehicle = _this;
_vehClass = typeOf _vehicle;

_realBoundingBoxes =
[
	// Vehicle variants are ordered according to their class inheritance, disrupting those orders can cause unexpected results
	[
		"ReammoBox_F",
		[
			["Box_NATO_Wps_F", [[-0.5,-0.4,-0.2],[0.6,0.4,0.2]]],
			["Box_NATO_WpsSpecial_F", [[-0.8,-0.4,-0.2],[0.8,0.3,0.2]]],
			["Box_NATO_Ammo_F", [[-0.2,-0.3,-0.3],[0.3,0.4,0.3]]],
			["Box_NATO_AmmoOrd_F", [[-0.2,-0.3,-0.3],[0.3,0.4,0.3]]],
			["Box_NATO_Grenades_F", [[-0.2,-0.3,-0.3],[0.3,0.4,0.3]]],
			["Box_NATO_Support_F", [[-0.2,-0.3,-0.3],[0.3,0.4,0.3]]],
			["Box_NATO_WpsLaunch_F", [[-0.8,-0.2,-0.2],[0.8,0.2,0.2]]],
			["Box_NATO_AmmoVeh_F", [[-0.8,-0.8,-0.8],[0.8,0.8,0.7]]],
			["Box_East_Wps_F", [[-0.5,-0.4,-0.2],[0.6,0.4,0.2]]],
			["Box_East_WpsSpecial_F", [[-0.8,-0.4,-0.2],[0.8,0.3,0.2]]],
			["Box_East_Ammo_F", [[-0.2,-0.3,-0.3],[0.3,0.4,0.3]]],
			["Box_East_AmmoOrd_F", [[-0.2,-0.3,-0.3],[0.3,0.4,0.3]]],
			["Box_East_Grenades_F", [[-0.2,-0.3,-0.3],[0.3,0.4,0.3]]],
			["Box_East_Support_F", [[-0.2,-0.3,-0.3],[0.3,0.4,0.3]]],
			["Box_East_WpsLaunch_F", [[-0.8,-0.2,-0.2],[0.8,0.2,0.2]]],
			["Box_East_AmmoVeh_F", [[-0.8,-0.8,-0.8],[0.8,0.8,0.7]]],
			["Box_IND_Wps_F", [[-0.5,-0.4,-0.2],[0.6,0.4,0.2]]],
			["Box_IND_WpsSpecial_F", [[-0.8,-0.4,-0.2],[0.8,0.3,0.2]]],
			["Box_IND_Ammo_F", [[-0.2,-0.3,-0.3],[0.3,0.4,0.3]]],
			["Box_IND_AmmoOrd_F", [[-0.2,-0.3,-0.3],[0.3,0.4,0.3]]],
			["Box_IND_Grenades_F", [[-0.2,-0.3,-0.3],[0.3,0.4,0.3]]],
			["Box_IND_Support_F", [[-0.2,-0.3,-0.3],[0.3,0.4,0.3]]],
			["Box_IND_WpsLaunch_F", [[-0.8,-0.2,-0.2],[0.8,0.2,0.2]]],
			["Box_IND_AmmoVeh_F", [[-0.8,-0.8,-0.8],[0.8,0.8,0.7]]],
			["Box_FIA_Support_F", [[-0.6,-0.3,-1.2],[0.5,0.8,-0.1]]],
			["B_supplyCrate_F", [[-0.8,-0.6,-0.9],[0.8,0.6,0.5]]],
			["C_supplyCrate_F", [[-0.8,-0.6,-0.9],[0.8,0.6,0.5]]]
		]
	],
	[
		"Truck_F",
		[
			["Van_01_box_base_F", [[-1.2,-3.6,-2],[1.2,2,1.5]]],
			["Van_01_fuel_base_F", [[-1.2,-3.6,-1.9],[1.2,2,1]]],
			["Van_01_base_F", [[-1.2,-3.5,-1.9],[1.2,2.2,0.8]]],
			["Van_02_base_F", [[-1.2,-3.5,-1.7],[1.2,4.2,1.1]]],
			["B_Truck_01_ammo_F", [[-1.2,-4.9,-1.9],[1.3,5,1.6]]],
			["B_Truck_01_box_F", [[-1.3,-5.8,-2.3],[1.3,5.2,2.2]]],
			["B_Truck_01_fuel_F", [[-1.2,-5.2,-2],[1.3,4.9,1.6]]],
			["B_Truck_01_medical_F", [[-1.4,-5,-2.2],[1.2,5.1,1.3]]],
			["B_Truck_01_Repair_F", [[-1.3,-5.8,-2.3],[1.3,5.2,2.2]]],
			["B_Truck_01_mover_F", [[-1.2,-4.7,-1.9],[1.3,4.3,1.1]]],
			["Truck_01_base_F", [[-1.3,-5,-2.3],[1.4,5.1,1.3]]],
			["O_Truck_02_ammo_F", [[-1.4,-4,-2.4],[1.3,4.1,1]]],
			["O_Truck_02_medical_F", [[-1.4,-4,-2.4],[1.3,4,1]]],
			["O_Truck_02_box_F", [[-1.4,-4,-2.4],[1.3,4.1,1]]],
			["O_Truck_02_fuel_F", [[-1.3,-4,-2.4],[1.3,4,0.9]]],
			["I_Truck_02_ammo_F", [[-1.4,-4,-2.4],[1.3,4.1,1]]],
			["I_Truck_02_medical_F", [[-1.4,-4,-2.4],[1.3,4,1]]],
			["I_Truck_02_box_F", [[-1.4,-4,-2.4],[1.3,4.1,1]]],
			["I_Truck_02_fuel_F", [[-1.3,-4,-2.4],[1.3,4,0.9]]],
			["Truck_02_MRL_base_F", [[-1.5,-4,-2.6],[1.4,4,1]]],
			["Truck_02_base_F", [[-1.3,-4,-2.4],[1.3,4,1]]],
			["O_Truck_03_ammo_F", [[-1.7,-5.3,-2.1],[1.7,3.5,1.4]]],
			["O_Truck_03_device_F", [[-1.7,-5.3,-2.1],[1.7,3.5,1.2]]],
			["O_Truck_03_fuel_F", [[-1.7,-5.2,-2.2],[1.7,3.5,1.2]]],
			["O_Truck_03_medical_F", [[-1.6,-5.1,-2.4],[1.7,3.7,1.3]]],
			["O_Truck_03_repair_F", [[-1.7,-5.3,-2.1],[1.7,3.5,1.3]]],
			["Truck_03_base_F", [[-1.6,-5.1,-2.4],[1.7,3.7,1.3]]]
		]
	],
	[
		"Tank_F",
		[
			["UGV_02_Base_F", [[-0.3,-0.5,-0.3],[0.3,0.4,0.3]]],
			["LT_01_AT_base_F", [[-1.6,-2.7,-2],[1.2,2.9,0.9]]],
			["LT_01_AA_base_F", [[-1.6,-2.7,-2],[1.2,2.9,0.9]]],
			["LT_01_cannon_base_F", [[-1.6,-2.6,-1.9],[1.2,2.7,0.6]]],
			["LT_01_base_F", [[-1.6,-2.6,-1.9],[1.2,2.7,0.8]]],
			["B_APC_Tracked_01_AA_F", [[-2,-4.8,-2.8],[2,2.7,0.7]]],
			["B_APC_Tracked_01_CRV_F", [[-2.1,-4.8,-2.4],[2,3.9,0.8]]],
			["APC_Tracked_01_base_F", [[-2,-4.8,-2.4],[2,2.6,0.6]]],
			["O_APC_Tracked_02_AA_F", [[-2.2,-5.4,-2.7],[2.2,2.9,0.5]]],
			["APC_Tracked_02_base_F", [[-2.2,-5.4,-2.3],[2.2,2.9,1.1]]],
			["APC_Tracked_03_base_F", [[-1.9,-4.2,-2.4],[2,3.1,0.7]]],
			["MBT_01_arty_base_F", [[-2,-5.6,-2.8],[2.1,5.6,1.1]]],
			["MBT_01_mlrs_base_F", [[-1.3,-4.6,-1.9],[2.6,2.9,2.2]]],
			["B_MBT_01_TUSK_F", [[-1.9,-4.6,-2.7],[2,4.2,0.4]]],
			["MBT_01_base_F", [[-1.9,-4.6,-2.6],[2,4.2,0.4]]],
			["MBT_02_arty_base_F", [[-2,-5.5,-2.7],[2.1,5.7,0.9]]],
			["MBT_02_base_F", [[-1.8,-5,-2.2],[1.8,5.1,0.8]]],
			["MBT_03_base_F", [[-2.2,-5.7,-2.6],[2.2,5.3,0.8]]],
			["MBT_04_command_base_F", [[-2.1,-5.7,-2.6],[1.9,5.2,0.9]]],
			["MBT_04_base_F", [[-2.2,-5.7,-2.3],[2.1,5.2,1.4]]]
		]
	],
	[
		"Car_F",
		[
			["Kart_01_Base_F", [[-0.6,-0.9,-1.1],[0.7,1.2,-0.4]]],
			["Quadbike_01_base_F", [[-0.6,-1.2,-1.7],[0.6,1.1,-0.4]]],
			["Hatchback_01_base_F", [[-1,-2.6,-1.5],[0.9,2.3,0.3]]],
			["Tractor_01_base_F", [[-1,-2,-1.8],[1,1.7,0.9]]],
			["Offroad_01_military_covered_base_F", [[-1.3,-2.8,-1.8],[1.2,3,0.8]]],
			["Offroad_01_armed_base_F", [[-1.3,-2.9,-2.3],[1.2,2.9,0.3]]],
			["Offroad_01_repair_base_F", [[-1.1,-3,-1.7],[1.1,2.8,0.6]]],
			["Offroad_01_base_F", [[-1.3,-3,-1.7],[1.2,2.8,0.6]]],
			["Offroad_02_AT_base_F", [[-1.1,-1.8,-1.6],[1,2.4,1]]],
			["Offroad_02_LMG_base_F", [[-1.1,-1.8,-2.2],[1,2.4,0.3]]],
			["Offroad_02_base_F", [[-1.1,-1.8,-1.6],[1,2.4,0.5]]],
			["SUV_01_base_F", [[-1.1,-3,-1.7],[1.1,2.4,0.4]]],
			["UGV_01_rcws_base_F", [[-0.8,-2.1,-2.2],[1.7,2.1,0.1]]],
			["UGV_01_base_F", [[-0.8,-2.1,-2.2],[1.7,2.1,-0.3]]],
			["LSV_01_AT_base_F", [[-1.1,-2.5,-1.9],[1.1,2.3,0.7]]],
			["LSV_01_armed_base_F", [[-1.1,-2.5,-2.2],[1.1,2.3,-0.2]]],
			["LSV_01_base_F", [[-1.1,-2.1,-2.2],[1.1,2.3,-0.2]]],
			["LSV_02_AT_base_F", [[-1.2,-2.5,-1.7],[0.9,2.4,0.8]]],
			["LSV_02_armed_base_F", [[-1.2,-2.5,-1.7],[0.9,2.4,0.8]]],
			["LSV_02_base_F", [[-1.2,-2.5,-1.7],[0.9,2.4,0.4]]],
			["MRAP_01_gmg_base_F", [[-1.3,-4.7,-2.9],[1.3,1.7,0.9]]],
			["MRAP_01_base_F", [[-1.3,-4.8,-2.2],[1.3,1.7,0.7]]],
			["MRAP_02_hmg_base_F", [[-1.6,-4.9,-2.9],[1.6,1.7,0.8]]],
			["MRAP_02_base_F", [[-1.6,-4.9,-2.4],[1.6,1.7,0.8]]],
			["MRAP_03_hmg_base_F", [[-1.4,-3.3,-2.4],[1.4,2.6,0.5]]],
			["MRAP_03_base_F", [[-1.4,-3.3,-1.8],[1.4,2.6,1]]],
			["APC_Wheeled_01_base_F", [[-1.9,-5,-2.5],[1.9,3.4,0.9]]],
			["APC_Wheeled_02_base_F", [[-1.7,-4.8,-2.6],[2.1,2.1,0.7]]],
			["APC_Wheeled_03_base_F", [[-1.4,-5.1,-2.7],[2.3,3.4,1.2]]],
			["AFV_Wheeled_01_up_base_F", [[-1.9,-4.7,-2.4],[1.9,3.9,1.1]]],
			["AFV_Wheeled_01_base_F", [[-1.9,-4.7,-2.1],[1.9,3.9,0.5]]]
		]
	],
	[
		"Ship_F",
		[
			["SDV_01_base_F", [[-1,-4.1,-1.9],[1,2,1]]],
			["Scooter_Transport_01_base_F", [[-0.6,-1.4,-1.5],[0.6,1.9,-0.2]]],
			["Rubber_duck_base_F", [[-1.1,-2.5,-1.5],[1.1,2.4,-0.1]]],
			["Boat_Civil_01_base_F", [[-1,-3.4,-1.6],[1,3.6,0.3]]],
			["Boat_Transport_02_base_F", [[-1.5,-3.3,-1.9],[1.5,3.8,0.7]]],
			["Boat_Armed_01_base_F", [[-1.8,-5.5,-3.5],[2,6.4,1.2]]]
		]
	],
	[
		"Air",
		[
			["Heli_Light_01_civil_base_F", [[-3.7,-4.1,-0.7],[3.8,4.9,2.3]]],
			["Heli_Light_01_base_F", [[-3.7,-5,-1.8],[3.8,4.1,1.1]]],
			["Heli_Light_02_base_F", [[-6.8,-7.9,-2.4],[6.7,8,2.4]]],
			["Heli_light_03_base_F", [[-4.5,-7.6,-1.5],[4.6,5.8,2.5]]],
			["Heli_Transport_01_base_F", [[-7.2,-8.5,-2.3],[7.1,8.1,1.8]]],
			["Heli_Transport_02_base_F", [[-9.3,-11.3,-3.6],[9.3,11.2,3.6]]],
			["Heli_Transport_03_base_F", [[-8.3,-13.8,-3.6],[8.4,13.7,3]]],
			["Heli_Transport_04_base_F", [[-7.2,-8.9,-3],[7.3,9,3.7]]],
			["Heli_Attack_01_base_F", [[-5.7,-7.1,-2],[5.8,7.3,2]]],
			["Heli_Attack_02_base_F", [[-6.7,-8.5,-3.2],[6.6,8.5,3.2]]],
			["Plane_Civil_01_base_F", [[-5.5,-4,-1.6],[5.5,4.1,1.4]]],
			["Plane_Fighter_01_Base_F", [[-6.6,-8.9,-2.6],[6.6,9.5,2.6]]],
			["Plane_Fighter_02_Base_F", [[-7.6,-10.7,-2.4],[7.7,11.1,2.4]]],
			["Plane_Fighter_03_base_F", [[-5,-6.4,-2.5],[5.1,6.5,2.4]]],
			["Plane_Fighter_04_Base_F", [[-4.2,-6.9,-2.4],[4.2,7.8,2.3]]],
			["Plane_CAS_01_base_F", [[-8.8,-7.8,-2.3],[8.8,7.7,2.8]]],
			["Plane_CAS_02_base_F", [[-6.5,-8.1,-3.1],[6.5,7,3]]],
			["VTOL_01_base_F", [[-18.1,-13.5,-6.8],[18.1,13.4,4.1]]],
			["VTOL_02_base_F", [[-8.2,-8.3,-3.4],[8.2,8.4,3.5]]],
			["UAV_01_base_F", [[-0.5,-0.3,-0.1],[0.5,0.5,0.2]]],
			["UAV_02_base_F", [[-5.1,-3.4,-1.6],[5.1,3.3,0.8]]],
			["UAV_03_base_F", [[-5.6,-6,-1.7],[4.8,5.7,1.7]]],
			["UAV_04_base_F", [[-4.5,-2.8,-1.7],[4.5,2.6,0.7]]],
			["UAV_05_Base_F", [[-10.2,-6.3,-1.9],[10.2,6.4,1.9]]],
			["UAV_06_antimine_base_F", [[-0.3,-0.3,-0.3],[0.3,0.4,0.2]]],
			["UAV_06_base_F", [[-0.2,-0.4,-0.2],[0.2,0.4,0.2]]]
		]
	]
];

{
	if (_vehClass isKindOf (_x select 0)) exitWith
	{
		{
			if (_vehClass isKindOf (_x select 0)) exitWith
			{
				_boundingBoxReal = _x select 1;
			};
		} forEach (_x select 1);
	};
} forEach _realBoundingBoxes;

if (isNil "_boundingBoxReal") then { boundingBoxReal _vehicle } else { _boundingBoxReal }


// Here is the intersect scanner, which is used in the editor. The resulting array is copied into the clipboard.

/*
0 spawn
{
	_precision = 0.1; comment "change this for higher/lower precision";
	_lineColor1 = [0,1,0,1];
	_lineColor2 = [1,0,0,1];

	_parentClasses =
	[
		"ReammoBox_F",
		"Truck_F",
		"Tank_F",
		"Car_F",
		"Ship_F",
		"Air",
		"All"
	];

	_vehClasses =
	[
		["Box_NATO_Wps_F", "Box_NATO_Wps_F"],
		["Box_NATO_WpsSpecial_F", "Box_NATO_WpsSpecial_F"],
		["Box_NATO_Ammo_F", "Box_NATO_Ammo_F"],
		["Box_NATO_AmmoOrd_F", "Box_NATO_AmmoOrd_F"],
		["Box_NATO_Grenades_F", "Box_NATO_Grenades_F"],
		["Box_NATO_Support_F", "Box_NATO_Support_F"],
		["Box_NATO_WpsLaunch_F", "Box_NATO_WpsLaunch_F"],
		["Box_NATO_AmmoVeh_F", "Box_NATO_AmmoVeh_F"],
		["Box_East_Wps_F", "Box_East_Wps_F"],
		["Box_East_WpsSpecial_F", "Box_East_WpsSpecial_F"],
		["Box_East_Ammo_F", "Box_East_Ammo_F"],
		["Box_East_AmmoOrd_F", "Box_East_AmmoOrd_F"],
		["Box_East_Grenades_F", "Box_East_Grenades_F"],
		["Box_East_Support_F", "Box_East_Support_F"],
		["Box_East_WpsLaunch_F", "Box_East_WpsLaunch_F"],
		["Box_East_AmmoVeh_F", "Box_East_AmmoVeh_F"],
		["Box_IND_Wps_F", "Box_IND_Wps_F"],
		["Box_IND_WpsSpecial_F", "Box_IND_WpsSpecial_F"],
		["Box_IND_Ammo_F", "Box_IND_Ammo_F"],
		["Box_IND_AmmoOrd_F", "Box_IND_AmmoOrd_F"],
		["Box_IND_Grenades_F", "Box_IND_Grenades_F"],
		["Box_IND_Support_F", "Box_IND_Support_F"],
		["Box_IND_WpsLaunch_F", "Box_IND_WpsLaunch_F"],
		["Box_IND_AmmoVeh_F", "Box_IND_AmmoVeh_F"],
		["Box_FIA_Support_F", "Box_FIA_Support_F"],
		["B_supplyCrate_F", "B_supplyCrate_F"],
		["C_supplyCrate_F", "C_supplyCrate_F"],

		["C_Van_01_box_F", "Van_01_box_base_F"],
		["C_Van_01_fuel_F", "Van_01_fuel_base_F"],
		["C_Van_01_transport_F", "Van_01_base_F"],
		["C_Van_02_vehicle_F", "Van_02_base_F"],
		["B_Truck_01_ammo_F", "B_Truck_01_ammo_F"],
		["B_Truck_01_box_F", "B_Truck_01_box_F"],
		["B_Truck_01_fuel_F", "B_Truck_01_fuel_F"],
		["B_Truck_01_medical_F", "B_Truck_01_medical_F"],
		["B_Truck_01_Repair_F", "B_Truck_01_Repair_F"],
		["B_Truck_01_mover_F", "B_Truck_01_mover_F"],
		["B_Truck_01_covered_F", "Truck_01_base_F"],
		["O_Truck_02_ammo_F", "O_Truck_02_ammo_F"],
		["O_Truck_02_medical_F", "O_Truck_02_medical_F"],
		["O_Truck_02_box_F", "O_Truck_02_box_F"],
		["O_Truck_02_fuel_F", "O_Truck_02_fuel_F"],
		["I_Truck_02_ammo_F", "I_Truck_02_ammo_F"],
		["I_Truck_02_medical_F", "I_Truck_02_medical_F"],
		["I_Truck_02_box_F", "I_Truck_02_box_F"],
		["I_Truck_02_fuel_F", "I_Truck_02_fuel_F"],
		["I_Truck_02_MRL_F", "Truck_02_MRL_base_F"],
		["I_Truck_02_covered_F", "Truck_02_base_F"],
		["O_Truck_03_ammo_F", "O_Truck_03_ammo_F"],
		["O_Truck_03_device_F", "O_Truck_03_device_F"],
		["O_Truck_03_fuel_F", "O_Truck_03_fuel_F"],
		["O_Truck_03_medical_F", "O_Truck_03_medical_F"],
		["O_Truck_03_repair_F", "O_Truck_03_repair_F"],
		["O_Truck_03_covered_F", "Truck_03_base_F"],

		["I_LT_01_AT_F", "LT_01_AT_base_F"],
		["I_LT_01_AA_F", "LT_01_AA_base_F"],
		["I_LT_01_cannon_F", "LT_01_cannon_base_F"],
		["I_LT_01_scout_F", "LT_01_base_F"],
		["B_APC_Tracked_01_AA_F", "B_APC_Tracked_01_AA_F"],
		["B_APC_Tracked_01_CRV_F", "B_APC_Tracked_01_CRV_F"],
		["B_APC_Tracked_01_rcws_F", "APC_Tracked_01_base_F"],
		["O_APC_Tracked_02_AA_F", "O_APC_Tracked_02_AA_F"],
		["O_APC_Tracked_02_cannon_F", "APC_Tracked_02_base_F"],
		["I_APC_tracked_03_cannon_F", "APC_Tracked_03_base_F"],
		["B_MBT_01_arty_F", "MBT_01_arty_base_F"],
		["B_MBT_01_mlrs_F", "MBT_01_mlrs_base_F"],
		["B_MBT_01_TUSK_F", "B_MBT_01_TUSK_F"],
		["B_MBT_01_cannon_F", "MBT_01_base_F"],
		["O_MBT_02_arty_F", "MBT_02_arty_base_F"],
		["O_MBT_02_cannon_F", "MBT_02_base_F"],
		["I_MBT_03_cannon_F", "MBT_03_base_F"],
		["O_MBT_04_command_F", "MBT_04_command_base_F"],
		["O_MBT_04_cannon_F", "MBT_04_base_F"],

		["C_Kart_01_F", "Kart_01_Base_F"],
		["C_Quadbike_01_F", "Quadbike_01_base_F"],
		["C_Hatchback_01_F", "Hatchback_01_base_F"],
		["B_G_Offroad_01_armed_F", "Offroad_01_armed_base_F"],
		["C_Offroad_01_repair_F", "Offroad_01_repair_base_F"],
		["C_Offroad_01_F", "Offroad_01_base_F"],
		["I_C_Offroad_02_AT_F", "Offroad_02_AT_base_F"],
		["I_C_Offroad_02_LMG_F", "Offroad_02_LMG_base_F"],
		["C_Offroad_02_unarmed_F", "Offroad_02_base_F"],
		["C_SUV_01_F", "SUV_01_base_F"],
		["B_UGV_01_rcws_F", "UGV_01_rcws_base_F"],
		["B_UGV_01_F", "UGV_01_base_F"],
		["B_T_LSV_01_AT_F", "LSV_01_AT_base_F"],
		["B_T_LSV_01_armed_F", "LSV_01_armed_base_F"],
		["B_T_LSV_01_unarmed_F", "LSV_01_base_F"],
		["O_T_LSV_02_AT_F", "LSV_02_AT_base_F"],
		["O_T_LSV_02_armed_F", "LSV_02_armed_base_F"],
		["O_T_LSV_02_unarmed_F", "LSV_02_base_F"],
		["B_MRAP_01_gmg_F", "MRAP_01_gmg_base_F"],
		["B_MRAP_01_F", "MRAP_01_base_F"],
		["O_MRAP_02_hmg_F", "MRAP_02_hmg_base_F"],
		["O_MRAP_02_F", "MRAP_02_base_F"],
		["I_MRAP_03_hmg_F", "MRAP_03_hmg_base_F"],
		["I_MRAP_03_F", "MRAP_03_base_F"],
		["B_APC_Wheeled_01_cannon_F", "APC_Wheeled_01_base_F"],
		["O_APC_Wheeled_02_rcws_v2_F", "APC_Wheeled_02_base_F"],
		["I_APC_Wheeled_03_cannon_F", "APC_Wheeled_03_base_F"],
		["B_AFV_Wheeled_01_up_cannon_F", "AFV_Wheeled_01_up_base_F"],
		["B_AFV_Wheeled_01_cannon_F", "AFV_Wheeled_01_base_F"],

		["B_SDV_01_F", "SDV_01_base_F"],
		["C_Scooter_Transport_01_F", "Scooter_Transport_01_base_F"],
		["C_Rubberboat", "Rubber_duck_base_F"],
		["C_Boat_Civil_01_F", "Boat_Civil_01_base_F"],
		["C_Boat_Transport_02_F", "Boat_Transport_02_base_F"],
		["B_Boat_Armed_01_minigun_F", "Boat_Armed_01_base_F"],

		["C_Heli_Light_01_civil_F", "Heli_Light_01_civil_base_F"],
		["B_Heli_Light_01_armed_F", "Heli_Light_01_base_F"],
		["O_Heli_Light_02_F", "Heli_Light_02_base_F"],
		["I_Heli_light_03_F", "Heli_light_03_base_F"],
		["B_Heli_Transport_01_F", "Heli_Transport_01_base_F"],
		["I_Heli_Transport_02_F", "Heli_Transport_02_base_F"],
		["B_Heli_Transport_03_F", "Heli_Transport_03_base_F"],
		["O_Heli_Transport_04_box_F", "Heli_Transport_04_base_F"],
		["B_Heli_Attack_01_F", "Heli_Attack_01_base_F"],
		["O_Heli_Attack_02_F", "Heli_Attack_02_base_F"],
		["C_Plane_Civil_01_F", "Plane_Civil_01_base_F"],
		["B_Plane_Fighter_01_F", "Plane_Fighter_01_Base_F"],
		["O_Plane_Fighter_02_F", "Plane_Fighter_02_Base_F"],
		["I_Plane_Fighter_03_CAS_F", "Plane_Fighter_03_base_F"],
		["I_Plane_Fighter_04_F","Plane_Fighter_04_Base_F"],
		["B_Plane_CAS_01_F", "Plane_CAS_01_base_F"],
		["O_Plane_CAS_02_F", "Plane_CAS_02_base_F"],
		["B_T_VTOL_01_armed_F", "VTOL_01_base_F"],
		["O_T_VTOL_02_infantry_F", "VTOL_02_base_F"],
		["B_UAV_01_F", "UAV_01_base_F"],
		["B_UAV_02_CAS_F", "UAV_02_base_F"],
		["B_T_UAV_03_F", "UAV_03_base_F"],
		["O_T_UAV_04_CAS_F", "UAV_04_base_F"],
		["B_UAV_05_F", "UAV_05_Base_F"],
		["C_IDAP_UAV_06_antimine_F", "UAV_06_antimine_base_F"],
		["B_UAV_06_F", "UAV_06_base_F"]
	];

	comment "this is to take into account heli rotors";
	_extraOffsets =
	[
		["Heli_Light_01_base_F", [[0,0,0],[0,0.4,0]]],
		["Heli_Transport_03_base_F", [[0,0,0],[0,2.2,0]]]
	];

	_classesBBox = [];
	{ _classesBBox pushBack [_x, []] } forEach _parentClasses;

	_pos = getPosATL player;
	_pos set [1, (_pos select 1) + 15];
	_pos set [2, (_pos select 2) + 5];

	_dir = getDir player;
	_dir = _dir + 270;

	{
		_class = _x select 0;
		_kind = _x select 1;

		_vehicle = createVehicle [_class, _pos, [], 0, "None"];

		{
			_vehicle animate [configName _x, 0, true];
		} forEach configProperties [configFile >> "CfgVehicles" >> _class >> "AnimationSources", "(configName _x) select [0,4] == 'hide'"];

		{
			_vehicle animate [configName _x, 1, true];
		} forEach configProperties [configFile >> "CfgVehicles" >> _class >> "AnimationSources", "(configName _x) select [0,4] == 'show'"];

		_vehicle setDir _dir;
		_vehicle enableSimulation false;

		_minBBox = (boundingBox _vehicle) select 0;
		_maxBBox = (boundingBox _vehicle) select 1;

		_minX = floor (_minBBox select 0);
		_minY = floor (_minBBox select 1);
		_minZ = floor (_minBBox select 2);

		_maxX = ceil (_maxBBox select 0);
		_maxY = ceil (_maxBBox select 1);
		_maxZ = ceil (_maxBBox select 2);

		_minXreal = _maxX;
		_minYreal = _maxY;
		_minZreal = _maxZ;

		_maxXreal = _minX;
		_maxYreal = _minY;
		_maxZreal = _minZ;

		comment "intersect is used as a backup because lineIntersects doesn't detect some heli blades, 'GEOM' option is the most accurate for those";
		_found = { lineIntersects [ATLtoASL _pos1, ATLtoASL _pos2] || {count ([_vehicle, "GEOM"] intersect [_pos1, _pos2]) > 0} };

		for "_X" from _minX to _maxX step _precision do
		{
			for "_Y" from _minY to _maxY step _precision do
			{
				_pos1 = _vehicle modelToWorld [_X, _Y, _minZ];
				_pos2 = _vehicle modelToWorld [_X, _Y, _maxZ];

				if (call _found) then
				{
					if (_X < _minXreal) then { _minXreal = _X - _precision };
					if (_X >= _maxXreal) then { _maxXreal = _X + _precision };

					if (_Y < _minYreal) then { _minYreal = _Y - _precision };
					if (_Y >= _maxYreal) then { _maxYreal = _Y + _precision };

					drawLine3D [_pos1, _pos2, _lineColor2];
				}
				else
				{
					drawLine3D [_pos1, _pos2, _lineColor1];
				};
			};
		};

		for "_Y" from _minY to _maxY step _precision do
		{
			for "_Z" from _minZ to _maxZ step _precision do
			{
				_pos1 = _vehicle modelToWorld [_minX, _Y, _Z];
				_pos2 = _vehicle modelToWorld [_maxX, _Y, _Z];

				if (call _found) then
				{
					if (_Y < _minYreal) then { _minYreal = _Y - _precision };
					if (_Y >= _maxYreal) then { _maxYreal = _Y + _precision };

					if (_Z < _minZreal) then { _minZreal = _Z - _precision };
					if (_Z >= _maxZreal) then { _maxZreal = _Z + _precision };

					drawLine3D [_pos1, _pos2, _lineColor2];
				}
				else
				{
					drawLine3D [_pos1, _pos2, _lineColor1];
				};
			};
		};

		for "_Z" from _minZ to _maxZ step _precision do
		{
			for "_X" from _minX to _maxX step _precision do
			{
				_pos1 = _vehicle modelToWorld [_X, _minY, _Z];
				_pos2 = _vehicle modelToWorld [_X, _maxY, _Z];

				if (call _found) then
				{
					if (_X < _minXreal) then { _minXreal = _X - _precision };
					if (_X >= _maxXreal) then { _maxXreal = _X + _precision };

					if (_Z < _minZreal) then { _minZreal = _Z - _precision };
					if (_Z >= _maxZreal) then { _maxZreal = _Z + _precision };

					drawLine3D [_pos1, _pos2, _lineColor2];
				}
				else
				{
					drawLine3D [_pos1, _pos2, _lineColor1];
				};
			};
		};

		_minXreal = (round (_minXreal / _precision)) * _precision;
		_minYreal = (round (_minYreal / _precision)) * _precision;
		_minZreal = (round (_minZreal / _precision)) * _precision;

		_maxXreal = (round (_maxXreal / _precision)) * _precision;
		_maxYreal = (round (_maxYreal / _precision)) * _precision;
		_maxZreal = (round (_maxZreal / _precision)) * _precision;

		_minReal = [_minXreal, _minYreal, _minZreal];
		_maxReal = [_maxXreal, _maxYreal, _maxZreal];

		{
			if (_vehicle isKindOf (_x select 0)) exitWith
			{
				_minReal = _minReal vectorAdd (_x select 1 select 0);
				_maxReal = _maxReal vectorAdd (_x select 1 select 1);
			};
		} forEach _extraOffsets;

		{
			if (_vehicle isKindOf (_x select 0)) exitWith
			{
				(_x select 1) pushBack [_kind, [_minReal,_maxReal]];
			};
		} forEach _classesBBox;

		deleteVehicle _vehicle;

		sleep 0.1;

	} forEach _vehClasses;

	_validBBoxes = [];

	{
		if (count (_x select 1) > 0) then
		{
			_validBBoxes pushBack _x;
		};
	} forEach _classesBBox;

	copyToClipboard str _validBBoxes;
};
*/
