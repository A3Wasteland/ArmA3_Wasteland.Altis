//	@file Version: 1.1
//	@file Name: serverVars.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, [404] Pulse, [GoT] JoSchaap, MercyfulFate, AgentRev
//	@file Created: 20/11/2012 05:19
//	@file Args:

if (!isServer) exitWith {};

diag_log "WASTELAND SERVER - Initializing Server Vars";

pvar_teamSwitchList = [];
publicVariable "pvar_teamSwitchList";
pvar_teamKillList = [];
publicVariable "pvar_teamKillList";
pvar_spawn_beacons = [];
publicVariable "pvar_spawn_beacons";
pvar_warchest_funds_east = 0;
publicVariable "pvar_warchest_funds_east";
pvar_warchest_funds_west = 0;
publicVariable "pvar_warchest_funds_west";
clientMissionMarkers = [];
publicVariable "clientMissionMarkers";
clientRadarMarkers = [];
publicVariable "clientRadarMarkers";
currentDate = [];
publicVariable "currentDate";
currentInvites = [];
publicVariable "currentInvites";

"PlayerCDeath" addPublicVariableEventHandler { [_this select 1] spawn server_playerDied };

currentStaticHelis = []; // Storage for the heli marker numbers so that we don't spawn wrecks on top of live helis

//Civilian Vehicle List - Random Spawns
civilianVehicles =
[
	"C_Quadbike_01_F",
	"C_Hatchback_01_F",
	"C_Hatchback_01_sport_F",
	"C_SUV_01_F",
	"C_Offroad_01_F",
	"I_G_Offroad_01_F",
	"C_Van_01_box_F",
	"C_Van_01_transport_F"
];

//Light Military Vehicle List - Random Spawns
lightMilitaryVehicles =
[
	"B_Quadbike_01_F",
	"O_Quadbike_01_F",
	"I_Quadbike_01_F",
	"I_G_Quadbike_01_F",
//	"O_Truck_02_covered_F",
//	"I_Truck_02_covered_F",
//	"O_Truck_02_transport_F",
//	"I_Truck_02_transport_F",
	"I_G_Offroad_01_armed_F"
];

//Medium Military Vehicle List - Random Spawns
mediumMilitaryVehicles = 
[
//	"I_Truck_02_Fuel_F",
//	"O_Truck_02_Fuel_F",
//	"I_Truck_02_medical_F",
//	"O_Truck_02_medical_F",
	"B_MRAP_01_F",
	"O_MRAP_02_F",
	"I_MRAP_03_F"
];

//Water Vehicles - Random Spawns
waterVehicles =
[
//	"B_Lifeboat",
//	"O_Lifeboat",
//	"C_Rubberboat",
//	"B_SDV_01_F",
//	"O_SDV_01_F",
//	"I_SDV_01_F",
//	"B_Boat_Transport_01_F",
//	"O_Boat_Transport_01_F",
//	"I_Boat_Transport_01_F",
//	"I_G_Boat_Transport_01_F",
	"B_Boat_Armed_01_minigun_F",
	"O_Boat_Armed_01_hmg_F",
	"I_Boat_Armed_01_minigun_F",
	"C_Boat_Civil_01_F",
	"C_Boat_Civil_01_police_F",
	"GNT_C185F",
	"C_Boat_Civil_01_rescue_F"
];

//Object List - Random Spawns.
objectList =
[
	"B_supplyCrate_F",
	"B_supplyCrate_F",
	"CamoNet_INDP_open_F",
	"CamoNet_INDP_open_F",
	"Land_BagBunker_Large_F",
	"Land_BagBunker_Large_F",
	"Land_BagBunker_Small_F",
	"Land_BagBunker_Small_F",
	"Land_BagBunker_Tower_F",
	"Land_BagBunker_Tower_F",
	"Land_BarGate_F",
	"Land_Canal_Wall_Stairs_F",
	"Land_Canal_WallSmall_10m_F",
	"Land_Canal_WallSmall_10m_F",
	"Land_CncBarrierMedium4_F",
	"Land_CncShelter_F",
	"Land_CncWall4_F",
	"Land_HBarrier_1_F",
	"Land_HBarrier_3_F",
	"Land_HBarrier_5_F",
	"Land_HBarrier_5_F",
	"Land_HBarrier_5_F",
	"Land_HBarrierBig_F",
	"Land_HBarrierBig_F",
	"Land_HBarrierBig_F",
	"Land_HBarrierBig_F",
	"Land_HBarrierTower_F",
	"Land_HBarrierWall4_F",
	"Land_HBarrierWall4_F",
	"Land_HBarrierWall6_F",
	"Land_HBarrierWall6_F",
	"Land_MetalBarrel_F",
	"Land_Mil_ConcreteWall_F",
	"Land_Mil_WallBig_4m_F",
	"Land_Mil_WallBig_4m_F",
	"Land_Mil_WallBig_4m_F",
	"Land_Pipes_large_F",
	"Land_RampConcrete_F",
	"Land_RampConcreteHigh_F",
	"Land_Sacks_goods_F",
	"Land_Shoot_House_Wall_F",
	"Land_WaterBarrel_F"
];

//Object List - Random Spawns.
staticWeaponsList = 
[
	"B_Mortar_01_F",
	"O_Mortar_01_F",
	"I_Mortar_01_F",
	"I_G_Mortar_01_F"
];

//Object List - Random Helis.
staticHeliList = 
[
	"B_Heli_Light_01_F",
	"B_Heli_Light_01_F",
	"O_Heli_Light_02_unarmed_F",
	"I_Heli_light_03_unarmed_F"
];

//Object List - Random Planes.
staticPlaneList = 
[
	"B_Plane_CAS_01_F",
	"O_Plane_CAS_02_F",
	"GNT_C185",
	"GNT_C185T",
	"I_Plane_Fighter_03_CAS_F"
];

//Random Weapon List - Change this to what you want to spawn in cars.
vehicleWeapons =
[
//	"hgun_P07_F",
//	"hgun_Rook40_F",
//	"hgun_ACPC2_F",
//	"arifle_SDAR_F",
	"SMG_01_F",					// Vermin .45 ACP
	"SMG_02_F",					// Sting 9mm
	"hgun_PDW2000_F",
	"arifle_TRG20_F",
	"arifle_TRG21_F",
	"arifle_TRG21_GL_F",
	"arifle_Mk20C_F",
	"arifle_Mk20_F",
	"arifle_Mk20_GL_F",
	"arifle_Katiba_F",
	"arifle_Katiba_C_F",
	"arifle_Katiba_GL_F",
	"arifle_MXC_F",
	"arifle_MX_F",
	"arifle_MX_GL_F",
	"arifle_MX_SW_F",
	"arifle_MXM_F",
//	"srifle_EBR_F",
	"LMG_Mk200_F",
	"LMG_Zafir_F",
	"hlc_rifle_ak74",		 	//- AK74
	"hlc_rifle_aks74",			//- AKS74
	"hlc_rifle_aks74u",			//- AKS74U
	"hlc_rifle_ak47",			//- AK47
	"hlc_rifle_akm",			//-AKM
	"hlc_rifle_rpk",			//-RPK
	"hlc_rifle_ak12",			//-AK12
	"hlc_rifle_akmgl",			//-AKM+GP25
	"hlc_rifle_aks74_GL",		//-AKS74+GP30 (Export Variant)
	"hlc_rifle_saiga12k",		//-Saiga12K Shotgun
	"hlc_rifle_aek971",
	"hlc_rifle_RU556",		 	//- AR15 Sanitied Carbine (Magpul AFG, MOE,P-Mag,BAD-lever. Novekse KX3)
	"hlc_rifle_RU5562",		 	//- AR15 Magpul Carbine (Magpul AFG, UBR,P-Mag,BAD-lever. Novekse KX3)
	"hlc_rifle_Colt727",		//- Colt Carbine (Colt Model 727 "Commando" - "M4" Barrel, M16A2 Upper, Full-Auto Lower)
	"hlc_rifle_Colt727_GL",		//- Same as above, add M203
	"hlc_rifle_bcmjack", 		//- Bravo Company MFG/Haley Strategic Jack Carbine)
	"hlc_rifle_Bushmaster300",	//- Busmaster .300 Carbine (M4A1-profile carbine chambered for .300 Blackout, instead of 5.56mm NATO)
	"hlc_rifle_vendimus",		//- AR15 .300 Dissipator Carbine (Carbine-length heavy barrel covered by full-length rifle furniture)
	"hlc_rifle_SAMR",			//- Rock River Arms LAR-15 AMR (Full-Auto-Capable full-length rifle, kitted out to be able to double as a marksman rifle, with accuracy to match)
	"hlc_rifle_honeybase",		//- AAC 'Honey-Badger',Sans Suppressor
	"hlc_rifle_honeybadger",	//- AAC 'Honey-Badger' (Suppressed Carbine-length defense weapon, created to show off the low-velocity suppressed capabilities of the .300 Blackout round)
	"hlc_rifle_l1a1slr",		//- Enfield L1A1 SLR
	"hlc_rifle_SLR",		 	//- Lithgow SLR (Australian manufactured L1A1)
	"hlc_rifle_STG58F",		 	//- Steyr STG.58 
	"hlc_rifle_FAL5061",		// - FN FAL 'Para' 
	"hlc_rifle_c1A1",		 	//- FN C1A1 (Canadian SLR variant, manufactured by FN)
	"hlc_rifle_LAR",		 	//- FN LAR (Light infantry rifle contracted to Israel, Differs from the Support variant by the omission of bipod and standard width barrel)
	"hlc_rifle_SLRchopmod",		//- Lithgow SLR Chopmod ( Litghow SLR with the selector group from an L2A1  Barrel sawn down and flash suppressor omitted, additional pistol grip drilled to foregrip.
	"hlc_rifle_falosw",			//- DSA Arms FAL OSW (Offensive Suppression Weapon. Or Offensively Short Weapon)
	"hlc_rifle_osw_GL",			//-DSA Arms FAL OSW + M203 GL
	"hlc_rifle_g3sg1",		 	//- H&K G3SG1 (Designated marksman rifle)
	"hlc_rifle_psg1",		 	//- H&K PSG1 (Sniper Weapon System. So dedcated to the role that the tripod that it mounts to is not integral to the weapon)
	"hlc_rifle_g3a3",		 	//- H&K G3A3 (Infantry Rifle)
	"hlc_rifle_g3ka4",		 	//- H&K G3KA4 (Modernised,slightly shorter Infantry rifle)
	"HLC_Rifle_g3ka4_GL",		//- H&K G3KA4 + M203
	"hlc_rifle_hk51",		 	//- FR Ordnance MC51 (G3 rifle made as compact as an MP5. A Specfic request made by the SAS, apparently 50 made, but none saw combat)
	"hlc_rifle_hk53",			//- H&K HK53 (H&K's formalised solution to the SASR's dilemma, essentially an HK33 made to fit the same size package as the MP5)
	"hlc_rifle_M14",		 	//- M14 (Infantry Rifle)
	"hlc_rifle_M21",		 	//- M21 Marksman Rifle ( Removal of select fire, Addition of Fibreglass stock and Harris Bipod)
	"hlc_rifle_M14DMR",		 	//- M14 DMR (USMC Designated Marksman Weapon. ArmA2 DMR)
	"hlc_rifle_m14sopmod",	 	//- Troy M14 SOPMOD (Precursor to the EBR. Modernised M14 Chasis)
	"hlc_lmg_M60E4",		 	//- M60E4
	"hlc_lmg_m60"				//-  M60 (original variant, no rails, longer, heavier)
];

vehicleAddition =
[
	"muzzle_snds_L", 			// 9mm
	"muzzle_snds_M", 			// 5.56mm
	"muzzle_snds_H", 			// 6.5mm
	"muzzle_snds_H_MG",			// 6.5mm LMG
	"muzzle_snds_B", 			// 7.62mm
	"muzzle_snds_acp", 			// .45 ACP
	"optic_Arco",
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
	"ToolKit",
	"HLC_Optic_PSO1",			//- PSO1 Sniper Optic
	"HLC_Optic_1p29",			//- 1P29 Rifle Combat Optic
	"hlc_muzzle_545SUP_AK",		//- PBS4 Suppressor (5.45x39)
	"hlc_muzzle_762SUP_AK",		//- PBS1 Suppressor (7.62x39)
	"hlc_optic_kobra",			//- Kobra Collimator Sight
	"hlc_optic_goshawk",		//- Goshawk Thermal Sight
	"hlc_30Rnd_545x39_B_AK",	// - 30 Round magazine of 5.45x39mm Ball Rounds (i.e, standard bullets)
	"hlc_30Rnd_545x39_T_AK",	// - 30 Round magazine of 5.45x39mm Tracer Rounds
	"hlc_30Rnd_545x39_EP_AK",	// - 30 Round magazine of 5.45x39mm Enhanced Performance Rounds 
	"hlc_45Rnd_545x39_t_rpk",	// - 45 Round magazine of 5.45x39mm Mixed
	"hlc_30Rnd_762x39_b_ak",	// - 30 Round magazine of 7.62x39mm Ball Rounds (i.e, standard bullets)
	"hlc_30Rnd_762x39_t_ak",	// - 30 Round magazine of 7.62x39mm Tracer Rounds
	"hlc_45Rnd_762x39_t_rpk",	// - 45 Round magazine of 7.62x39mm Tracer Rounds
	"hlc_45Rnd_762x39_m_rpk",	// - 45 Round magazine of 7.62x39mm Mixed
	"hlc_75rnd_762x39_m_rpk",	//- 75 Round magazine of 7.62x39mm Mixed
	"hlc_10rnd_12g_buck_S12",	//- 10 Round magazine of 12 Gauge 00-Buckshot rounds 
	"hlc_10rnd_12g_slug_S12",	//- 10 Round magazine of 12 Gauge Solid Slug rounds
	"hlc_VOG25_AK",				//- HE Round for the GP25 and GP30
	"hlc_GRD_White",			//- Smoke Rounds for the GP25 and GP30
	"hlc_GRD_red",
	"hlc_GRD_green",
	"hlc_GRD_blue",
	"hlc_GRD_orange",
	"hlc_GRD_purple",
	"hlc_muzzle_556NATO_KAC",	//-Sound Suppressor 5.56MM NATO AR15s
	"hlc_muzzle_300blk_KAC",	//- Sound Suppressor .300 Blackout AR15s
	"hlc_optic_LRT_m14",		//- Leupold LR/T (Effectively the same as the LRPS that's already ingame)
	"29rnd_300BLK_STANAG",		//- 30 Round magazine of .300 Blackout FMJ (-1 to ensure smooth feeding)
	"29rnd_300BLK_STANAG_T",	// - 30 Round magazine of .300 Blackout Tracer Rounds
	"29rnd_300BLK_STANAG_S",	// - 30 Round magazine of .300 Blackout FMJ "cold" loads for optimum sound suppression.
	"hlc_30rnd_556x45_EPR",		//- 30 Round magazine of 5.56x45mm NATO Enhanced Performance Rounds.
	"hlc_30rnd_556x45_SOST",	//- 30 Round magazine of 5.56x45mm NATO Mk318 Rounds(designed for optimal performance with even SBR-length rifles).
	"hlc_30rnd_556x45_SPR",		//- 30 Round magazine of 5.56x45mm NATO Mk262 Rounds(desgined for long range ballistic consistency).
	"hlc_optic_PVS4FAL",		//- AN/PVS4 Night Optic (Exclusive to the FALs)
	"hlc_optic_suit",			//- SUIT Optic (Single Unit, infantry, Trilux. Exclusive to the FALs)
	"hlc_muzzle_snds_fal",		//- FAL Suppressor
	"hlc_20Rnd_762x51_B_fal",	//- 20 Round magazine of 7.62x51mm Ball Rounds (i.e, standard bullets)
	"hlc_20Rnd_762x51_t_fal",	//- 20 Round magazine of 7.62x51mm Tracer Rounds
	"hlc_20Rnd_762x51_S_fal",	//- 20 Round magazine of 7.62x51mm cold-loaded ball (subsonic, for use with suppressor
	"hlc_50rnd_762x51_M_FAL",	//- 50 Round magazine of 7.62x51mm Mixed at a ratio of 1 Tracer for every 5 Standard Ball rounds
	"hlc_muzzle_snds_HK33",		//-  Sound Suppressor for the HK53 (and later, the HK33)
	"hlc_muzzle_snds_G3",		//-Sound Suppressor for the G3 Rifles (PSG excluded)
	"HLC_Optic_ZFSG1",			//- Zeiss Diavari 1.5-6x Rifle Optic in high-profile mount (Modern day as-equivelant to the ZFSG1. Altscope mode uses the Mount's peephole)
	"hlc_optic_accupoint_g3",	//- Trijicon Accupoint TR20 Rifle optic in high-profile mount (3-9x, Illuminated post reticle.Altscope mode uses the Mount's peephole)
	"hlc_20Rnd_762x51_B_G3",	// - 20 Round magazine of 7.62x51mm Ball Rounds (i.e, standard bullets
	"hlc_20rnd_762x51_T_G3",	// - 20 Round magazine of 7.62x51mm Tracer Rounds
	"hlc_50rnd_762x51_M_G3",	// - 50 Round magazine of 7.62x51mm Mixed at a ratio of 1 Tracer for every 5 Standard Ball rounds (X-systems drum mag, so you can have the SAW be interoperable with the rest of the squad.
	"hlc_muzzle_snds_M14",		//-Sound Suppressor for the M14 Rifles 
	"hlc_optic_artel_m14",		//-  Redfield AR-TEL Optic (3-9x Scope. Sadly, it's impossible in the engine to replicate the locked zoom:zero function)
	"hlc_optic_LRT_m14",		//- Leupold LR/T (Effectively the same as the LRPS that's already ingame)
	"hlc_20Rnd_762x51_B_M14",	//- 20 Round magazine of 7.62x51mm Ball Rounds (i.e, standard bullets)
	"hlc_20rnd_762x51_T_M14",	//- 20 Round magazine of 7.62x51mm Tracer Rounds
	"hlc_50rnd_762x51_M_M14",	//- 50 Round magazine of 7.62x51mm Mixed at a ratio of 1 Tracer for every 5 Standard Ball rounds (X-systems drum mag, so you can have the SAW be interoperable with the rest of the squad.)
	"hlc_100Rnd_762x51_B_M60E4",//- 100 Round magazine of 7.62x51mm Ball Rounds (i.e, standard bullets)
	"hlc_100Rnd_762x51_T_M60E4",//- 100 Round magazine of 7.62x51mm Tracer Rounds
	"hlc_100Rnd_762x51_M_M60E4"	//- 100 Round magazine of 7.62x51mm Mixed at a ratio of 1 Tracer for every 2 Standard Ball rounds
];

vehicleAddition2 =
[
	"Chemlight_blue",
	"Chemlight_green",
	"Chemlight_yellow",
	"Chemlight_red"
];

MissionSpawnMarkers = [];
{
	if (["Mission_", _x] call fn_findString == 0) then
	{
		MissionSpawnMarkers set [count MissionSpawnMarkers, [_x, false]];
	};
} forEach allMapMarkers;
