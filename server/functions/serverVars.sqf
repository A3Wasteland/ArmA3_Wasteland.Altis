//	@file Version: 1.1
//	@file Name: serverVars.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, [404] Pulse, [GoT] JoSchaap, MercyfulFate
//	@file Created: 20/11/2012 05:19
//	@file Args:
// --------------------------------------------------------------------------------------------------- \\
// ----------  !DO NOT CHANGE ANYTHING BELOW THIS POINT UNLESS YOU KNOW WHAT YOU ARE DOING!	---------- \\
// ----------																				---------- \\
// ----------			404Games are not responsible for anything that may happen 			---------- \\
// ----------			 as a result of unauthorised modifications to this file.			---------- \\
// --------------------------------------------------------------------------------------------------- \\
#include "setup.sqf"
if(!X_Server) exitWith {};

diag_log format["WASTELAND SERVER - Initilizing Server Vars"];

sideMissionPos = "";
mainMissionPos = "";

currentVehicles = [];
publicVariable "currentVehicles";
pvar_teamSwitchList = [];
publicVariable "pvar_teamSwitchList";
pvar_teamKillList = [];
publicVariable "pvar_teamKillList";
pvar_spawn_beacons = [];
publicVariable "pvar_spawn_beacons";
clientMissionMarkers = [];
publicVariable "clientMissionMarkers";
clientRadarMarkers = [];
publicVariable "clientRadarMarkers";
currentDate = [];
publicVariable "currentDate";
currentInvites = [];
publicVariable "currentInvites";
                  
"PlayerCDeath" addPublicVariableEventHandler {_id = (_this select 1) spawn server_playerDied};

currentStaticHelis = []; // Storage for the heli marker numbers so that we don't spawn wrecks on top of live helis

//Civilian Vehicle List - Random Spawns
civilianVehicles = ["C_Offroad_01_F"];

//Light Military Vehicle List - Random Spawns
lightMilitaryVehicles = ["B_Quadbike_01_F","O_Quadbike_01_F","I_Quadbike_01_F","C_Quadbike_01_F"];

//Medium Military Vehicle List - Random Spawns
mediumMilitaryVehicles = ["B_MRAP_01_F","O_MRAP_02_F","I_MRAP_03_F","O_Truck_02_covered_F","I_Truck_02_covered_F","O_Truck_02_transport_F","I_Truck_02_transport_F"];


//boat - Random Boats.
BoatList = ["O_Boat_Transport_01_F","B_Boat_Transport_01_F","O_Lifeboat","B_Lifeboat","C_Rubberboat","B_SDV_01_F","O_SDV_01_F","I_SDV_01_F"];
                            
//Object List - Random Spawns.
objectList = ["Land_Sacks_goods_F",
			"Land_HBarrierBig_F",
			"Land_HBarrier_5_F",
			"Land_LampShabby_F",
//			"Land_Scaffolding_F", disabled due to physics issues
			"Land_HBarrierBig_F",
			"Land_BagBunker_Small_F",
			"Land_HBarrier_1_F",
			"Land_WaterBarrel_F",
			"Land_MetalBarrel_F",
			"Land_HBarrierBig_F",
			"Land_Canal_WallSmall_10m_F",
			"Land_HBarrier_5_F",
			"Land_Mil_WallBig_4m_F",
			"Land_HBarrier_3_F",
			"Land_Canal_Wall_Stairs_F",
			"Land_Mil_WallBig_4m_F",
			"Land_HBarrier_5_F",
			"Land_cargo_addon02_V2_F",
			"Land_HBarrierBig_F",
			"Land_Pipes_large_F",
			"Land_BagFence_Long_F",
			"Land_Canal_WallSmall_10m_F",
			"Land_BagBunker_Small_F",
			"Land_CncBarrierMedium4_F",
			"Land_CncWall4_F",
			"Land_Mil_ConcreteWall_F",
			"Land_Mil_WallBig_4m_F",
			"Land_Shoot_House_Wall_F",
			"Land_BarGate_F"];
                                         
//Object List - Random Spawns.
staticWeaponsList = ["B_Mortar_01_F","O_Mortar_01_F","I_Mortar_01_F"];

//Object List - Random Helis.
staticHeliList = ["O_Heli_Light_02_unarmed_F","B_Heli_Light_01_F","I_Heli_Transport_02_F"];

//Random Weapon List - Change this to what you want to spawn in cars.
vehicleWeapons = ["arifle_SDAR_F",
				"SMG_01_F",
				"SMG_02_F",
				"arifle_MXM_F",
				"arifle_TRG21_F",
				"arifle_TRG20_F",
				"arifle_MXC_F",
                "arifle_MX_SW_F",
                "arifle_MX_GL_F",
                "arifle_TRG21_GL_F",
                "arifle_MX_F",
                "arifle_Katiba_F",
                "arifle_Katiba_C_F",
                "arifle_Katiba_GL_F",
                "arifle_SDAR_F",
                "srifle_EBR_F",
                "LMG_Mk200_F",
				"LMG_Zafir_F",
                "hgun_ACPC2_F",
                "hgun_P07_F",
                "hgun_Rook40_F"];

vehicleAddition = [
			"Zasleh2",
			"muzzle_snds_H",
			"muzzle_snds_L",
			"muzzle_snds_M",
			"muzzle_snds_B",
			"muzzle_snds_H_MG",
			"muzzle_snds_acp",
			"optic_Arco",
			"optic_MRCO",
			"optic_SOS",
			"optic_Hamr", 
			"optic_Aco", 
			"optic_ACO_grn",
			"optic_aco_smg", 
			"optic_Holosight",
			"optic_Holosight_smg", 
			"acc_flashlight", 
			"acc_pointer_IR",
			"Medikit",
			"Medikit",
			"FirstAidKit",
            	"ToolKit"
];

vehicleAddition2 = [
	"Chemlight_blue",
	"Chemlight_red",
	"Chemlight_yellow",
	"Chemlight_green"
];
 
                
MissionSpawnMarkers = [
            ["Mission_1",false],
            ["Mission_2",false],
            ["Mission_3",false],
            ["Mission_4",false],
            ["Mission_5",false],
            ["Mission_6",false],
            ["Mission_7",false],
            ["Mission_8",false],
            ["Mission_9",false],
            ["Mission_10",false],
            ["Mission_11",false],
            ["Mission_12",false],
            ["Mission_13",false],
            ["Mission_14",false],
            ["Mission_15",false],
            ["Mission_16",false],
            ["Mission_17",false],
            ["Mission_18",false],
            ["Mission_19",false],
            ["Mission_20",false]
];
