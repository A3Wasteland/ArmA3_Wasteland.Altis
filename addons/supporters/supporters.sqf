// Virtual Arsenal Supporter Customization - 
// by CRE4MPIE
// Inspired by fn_r3m3dy - thx xD
// PS: Arrays are a bitch

//http://forums.a3wasteland.com/index.php?topic=1226.0
// Remember to change your createvehicle.txt to log for logic only and not kick ( 2 "^Logic")
// Add exception to antihack for BIS_fnc_arsenal,bis_fnc_setidentity in filterExecAttempt.sqf
// payload.sqf	if (!isNull (uiNamespace getVariable ["RscDisplayArsenal", displayNull]) && !_isAdmin) exitWith { _cheatFlag = "Virtual Arsenal" };



// Supporter Loadout  
_donatorEnabled = ["A3W_donatorEnabled"] call isConfigOn;
_donatorLevel = player getVariable ["donatorLevel", 0];


switch (_donatorLevel) do {	
		case 1: // Supporter
		{			
			
				_crate = "Box_East_Ammo_F";		
				["Open",_crate] call BIS_fnc_arsenal;
				[_crate,[true],true] call BIS_fnc_addVirtualMagazineCargo;
[_crate,[
//BackPack
"B_AssaultPack_blk",		//Assault Pack Black 	
"B_AssaultPack_dgtl",	//Assault Pack Desert Camo 	
"B_AssaultPack_khk",		//Assault Pack Light Green 	
"B_AssaultPack_rgr",		//Assault Pack Olive Green 	
"B_AssaultPack_sgg",		//Assault Pack Sage 	
"B_AssaultPack_cbr",		//Assault Pack Tan 	
"B_AssaultPack_mcamo",	//Assault Pack Woodland Camo 	
"B_Bergen_blk",		//Bergen Black 	
"B_Bergen_rgr",		//Bergen Olive Green 	
"B_Bergen_sgg",		//Bergen Sage 	
"B_Bergen_mcamo",	//Bergen Woodland Camo 	
"B_Carryall_oucamo",		//Carryall Blue Camo 	
"B_Carryall_ocamo",		//Carryall Desert Camo 	
"B_Carryall_khk",	//Carryall Light Green 	
"B_Carryall_oli",	//Carryall Olive Green 	
"B_Carryall_cbr",	//Carryall Tan 	
"B_Carryall_mcamo",	//Carryall Woodland Camo 	
"B_FieldPack_blk",	//Field Pack Black 	
"B_FieldPack_oucamo",	//Field Pack Blue Camo 	
"B_FieldPack_ocamo",		//Field Pack Desert Camo 	
"B_FieldPack_cbr",		//Field Pack Tan 	
"B_HuntingBackpack",		//Hunting Backpack 	
"B_Kitbag_sgg",		//Kitbag Sage 	
"B_Kitbag_cbr",		//Kitbag Tan 	
"B_Kitbag_mcamo",	//Kitbag Woodland Camo 	
"B_OutdoorPack_blk",		//Outdoor Pack Black 	
"B_OutdoorPack_blu",		//Outdoor Pack Blue 	
"B_OutdoorPack_tan",	//Outdoor Pack Tan

"B_Respawn_Sleeping_bag_blue_F", //backpack respawn sleeping bags
"B_Respawn_Sleeping_bag_brown_F",
"B_Respawn_Sleeping_bag_F",

"B_Respawn_TentDome_F", //backpack respawn tents
"B_Respawn_TentA_F",

"I_GMG_01_A_weapon_F", //backpack static GMGs
"B_GMG_01_A_weapon_F",
"O_GMG_01_A_weapon_F",
"I_GMG_01_weapon_F",
"B_GMG_01_weapon_F",
"O_GMG_01_weapon_F",
"I_GMG_01_high_weapon_F",
"B_GMG_01_high_weapon_F",
"O_GMG_01_high_weapon_F",

"I_HMG_01_A_weapon_F", //backpack static HMGs
"B_HMG_01_A_weapon_F",
"O_HMG_01_A_weapon_F",
"I_HMG_01_weapon_F",
"B_HMG_01_weapon_F",
"O_HMG_01_weapon_F",
"I_HMG_01_support_F",
"B_HMG_01_support_F",
"O_HMG_01_support_F",
"I_HMG_01_high_weapon_F",
"B_HMG_01_high_weapon_F",
"O_HMG_01_high_weapon_F",
"I_HMG_01_support_high_F",
"B_HMG_01_support_high_F",
"O_HMG_01_support_high_F",

"I_UAV_01_backpack_F", //backpack UAVs
"B_UAV_01_backpack_F",
"O_UAV_01_backpack_F",

"O_Static_Designator_02_weapon_F", //backpack remote designators
"B_Static_Designator_01_weapon_F",

"B_Parachute", //backpack parachute

"I_AA_01_weapon_F",	//Static launcher AA
"B_AA_01_weapon_F",
"O_AA_01_weapon_F",
"I_AT_01_weapon_F",	//Static launcher AT
"B_AT_01_weapon_F",
"O_AT_01_weapon_F",

//Special BackPack
"I_Parachute_02_F",   //Parachute
"B_Parachute_02_F", 	//Cargo Parachute
"B_AssaultPack_rgr_LAT",	//AT Assault Pack 	
"B_AssaultPack_rgr_Medic",	//Medic Assault Pack 	
"B_AssaultPack_rgr_Repair",	//Repair Assault Pack 	
"B_AssaultPack_blk_DiverExp",		//Diver Assault Pack 	
"B_Kitbag_rgr_Exp",		//Demolitions Assault Pack 
"B_FieldPack_blk_DiverExp",	//Diver Field Pack 	
"B_FieldPack_ocamo_Medic",	//Medic Field Pack 	
"B_FieldPack_cbr_LAT",	//AT Field Pack 	
"B_FieldPack_cbr_Repair",		//Repair Field Pack 	
"B_Carryall_ocamo_Exp",	//Demolitions Carryall 

//DLC APEX
"B_ViperLightHarness_khk_F", 
"B_ViperLightHarness_blk_F", 
"B_ViperLightHarness_hex_F", 
"B_ViperLightHarness_oli_F", 
"B_ViperLightHarness_ghex_F", 
"B_ViperHarness_oli_F", 
"B_ViperHarness_khk_F", 
"B_ViperHarness_ghex_F", 
"B_ViperHarness_blk_F", 
"B_FieldPack_ghex_F",
"B_AssaultPack_tna_F",
"B_Carryall_ghex_F", 
"B_Bergen_tna_F", 
"B_Bergen_hex_F", 
"B_Bergen_dgtl_F", 
"B_Bergen_mcamo_F", 
"B_ViperHarness_hex_F"

],true] call BIS_fnc_addVirtualBackpackCargo;

[_crate,[

// Handguns
"hgun_Pistol_heavy_01_F",
"hgun_ACPC2_F",
"hgun_P07_F",
"hgun_Rook40_F",
"hgun_Pistol_Signal_F",
"hgun_Pistol_heavy_02_F",

// Rifles
"srifle_DMR_04_F",
"srifle_DMR_04_Tan_F",
"srifle_DMR_05_blk_F",
"srifle_DMR_05_hex_F",
"srifle_DMR_05_tan_f",
"srifle_GM6_F",
"srifle_GM6_camo_F",
"arifle_Katiba_F",
"arifle_Katiba_C_F",
"arifle_Katiba_GL_F",
"srifle_LRR_F",
"srifle_LRR_camo_F",
"srifle_DMR_02_F",
"srifle_DMR_02_camo_F",
"srifle_DMR_02_sniper_F",
"srifle_DMR_03_F",
"srifle_DMR_03_multicam_F",
"srifle_DMR_03_khaki_F",
"srifle_DMR_03_tan_F",
"srifle_DMR_03_woodland_F",
"srifle_DMR_06_camo_F",
"srifle_DMR_06_olive_F",
"srifle_EBR_F",
"arifle_Mk20_plain_F",
"arifle_Mk20_F",
"arifle_Mk20_GL_plain_F",
"arifle_Mk20_GL_F",
"LMG_Mk200_F",
"arifle_Mk20C_plain_F",
"arifle_Mk20C_F",
"arifle_MX_GL_F",
"arifle_MX_GL_Black_F",
"arifle_MX_F",
"arifle_MX_Black_F",
"arifle_MX_SW_F",
"arifle_MX_SW_Black_F",
"arifle_MXC_F",
"arifle_MXC_Black_F",
"arifle_MXM_F",
"arifle_MXM_Black_F",
"MMG_01_hex_F",
"MMG_01_tan_F",
"hgun_PDW2000_F",
"srifle_DMR_01_F",
"arifle_SDAR_F",
"MMG_02_black_F",
"MMG_02_camo_F",
"MMG_02_sand_F",
"SMG_02_F",
"arifle_TRG20_F",
"arifle_TRG21_F",
"arifle_TRG21_GL_F",
"SMG_01_F",
"LMG_Zafir_F",
//Apex
"arifle_MX_GL_khk_Holo_Pointer_Snds_F", //MX 3GL 6.5mm (Khaki)
"arifle_AK12_F", //AK-12 Rifle
"arifle_AK12_GL_F", //AK-12 GL Rifle
"arifle_AKM_F", //AKM Rifle
"arifle_AKM_FL_F", //AKM 7.62 mm Built-in flashlight
"arifle_AKS_F", //AKS-74U Carbine
"arifle_ARX_blk_F", //Type 115 Rifle
"arifle_ARX_hex_F", //Type 115 Rifle (Hex)
"arifle_ARX_ghex_F", //Type 115 Rifle (G Hex)
"arifle_CTAR_blk_F", //CAR-95 Rifle
"arifle_CTAR_GL_blk_F", //CAR-95 GL Rifle
"arifle_CTARS_blk_F", //CAR-95-1 LMG
"LMG_03_F", //LIM-85 LMG
"arifle_MX_GL_khk_F", //MX 3GL Rifle (Khaki)
"arifle_MX_khk_F", // MX Rifle (Khaki)
"arifle_MX_SW_khk_F", //MX SW LMG (Khaki)
"arifle_MXC_khk_F", //MX Carbine (Khaki)
"arifle_MXM_khk_F", //MXM Rifle (Khaki)
"arifle_SPAR_01_blk_F", //SPAR-16 Rifle
"arifle_SPAR_01_khk_F", //SPAR-16 Rifle (Khaki)
"arifle_SPAR_01_snd_F", //SPAR-16 Rifle (Sand)
"arifle_SPAR_01_GL_blk_F", //SPAR-16 GL Rifle
"arifle_SPAR_01_GL_khk_F", //SPAR-16 GL Rifle (Khaki)
"arifle_SPAR_01_GL_snd_F", //SPAR-16 GL Rifle (Sand)
"arifle_SPAR_02_blk_F", //SPAR-16S LMG
"arifle_SPAR_02_khk_F", //SPAR-16S LMG (Khaki)
"arifle_SPAR_02_snd_F", //SPAR-16S LMG (Sand)
"arifle_SPAR_03_blk_F", //SPAR-17 Rifle
"arifle_SPAR_03_khk_F", //SPAR-17 Rifle (Khaki)
"arifle_SPAR_03_snd_F", //SPAR-17 Rifle (Sand)
"srifle_DMR_07_blk_F", //CMR-76 Rifle
"srifle_DMR_07_hex_F", //CMR-76 Rifle (Hex)
"srifle_DMR_07_ghex_F", //CMR-76 Rifle (G Hex)
"srifle_GM6_ghex_F", //GM6 links 12.7mm (G Hex)
"srifle_LRR_tna_F", //M320 LRR .408 (Tropic)
// Launchers
"launch_RPG32_F",
"launch_NLAW_F",
"launch_Titan_short_F",
"launch_O_Titan_short_F",
"launch_I_Titan_short_F",
"launch_Titan_F",
"launch_O_Titan_F",
"launch_I_Titan_F",
"launch_RPG32_ghex_F", //RPG-42 Alamut (G Hex)
"launch_B_Titan_tna_F", //Titan MPRL AA (Tropic)
"launch_O_Titan_ghex_F", //Titan MPRL AA (G Hex)
"launch_B_Titan_short_tna_F", // Titan MPRL Compact (Tropic)
"launch_O_Titan_short_ghex_F", //Titan MPRL Compact (G Hex)
// Random
"Rangefinder",
"Laserdesignator",
"Laserdesignator_02",
"Laserdesignator_03",
"Binocular",
//Apex
"Laserdesignator_02_ghex_F", // Laser Designator (Green Hex)
"Laserdesignator_01_khk_F"  // Laser Designator (khaki)

],true] call BIS_fnc_addVirtualWeaponCargo;

[_crate,[
// Accessories
"optic_Holosight",
"optic_MRD",
"muzzle_snds_L",
"muzzle_snds_acp",
"optic_Hamr",
"optic_aco_smg",
"muzzle_snds_M",
"muzzle_snds_H",
"muzzle_snds_H_MG",
"muzzle_snds_B",
"muzzle_snds_338_black",
"muzzle_snds_338_green",
"muzzle_snds_338_sand",
"muzzle_snds_65_TI_blk_F",
"muzzle_snds_65_TI_hex_F",
"muzzle_snds_65_TI_ghex_F",
"muzzle_snds_H_MG_blk_F",
"muzzle_snds_H_MG_khk_F",
"muzzle_snds_B_khk_F",
"muzzle_snds_B_snd_F",
"muzzle_snds_58_blk_F",
"muzzle_snds_58_wdm_F",
"muzzle_snds_93mmg",
"muzzle_snds_93mmg_tan",
"bipod_01_F_blk",
"bipod_02_F_blk",
"bipod_03_F_blk",
"bipod_01_F_mtp",
"bipod_02_F_hex",
"bipod_03_F_oli",
"bipod_01_F_snd",
"bipod_02_F_tan",
"acc_flashlight",
"acc_pointer_IR",
"optic_Yorris",
"optic_Holosight_smg",
"optic_Aco",
"optic_Aco_grn",
"optic_MRCO",
"optic_Arco",
"optic_DMS",
"optic_SOS",
"optic_AMS",
"optic_AMS_khk",
"optic_AMS_snd",
"optic_KHS_blk",
"optic_KHS_hex",
"optic_KHS_old",
"optic_KHS_tan",
"optic_LRPS",
//"optic_NVS",
"optic_tws",
//"optic_tws_mg",
//APEX
"optic_ERCO_blk_F", //ERCO
"optic_ERCO_khk_F", //ERCO (Khaki)
"optic_ERCO_snd_F", //ERCO (Sand)
"optic_DMS_ghex_F", //DMS (G Hex)
"optic_LRPS_ghex_F", //LRPS (G Hex)
"optic_LRPS_tna_F", //LRPS (Tropic)
"optic_Holosight_blk_F", //MK17 Holosight (Black)
"optic_Holosight_khk_F", //MK17 Holosight (Khaki)
"optic_Holosight_smg_blk_F", //MK17 Holosight  SMG (Black)
"optic_SOS_khk_F", //MOS (Khaki)
"optic_Hamr_khk_F", //RCO (Khaki)
"optic_Arco_blk_F", //ARCO (Black)
"optic_Arco_ghex_F", //ARCO (G Hex)
// Vests
"V_RebreatherB",
"V_RebreatherIR",
"V_RebreatherIA",
"V_PlateCarrier1_rgr",
"V_PlateCarrier1_blk",
"V_PlateCarrier3_rgr",
"V_PlateCarrierGL_rgr",
"V_PlateCarrierGL_blk",
"V_PlateCarrierGL_mtp",
"V_PlateCarrierIA1_dgtl",
"V_PlateCarrierIA2_dgtl",
"V_PlateCarrierIAGL_dgtl",
"V_PlateCarrierIAGL_oli",
"V_HarnessO_brn",
"V_HarnessO_gry",
"V_HarnessOGL_brn",
"V_HarnessOGL_gry",
"V_HarnessOSpec_brn",
"V_HarnessOSpec_gry",
"V_BandollierB_blk",
"V_BandollierB_cbr",
"V_BandollierB_rgr",
"V_BandollierB_khk",
"V_BandollierB_oli",
"V_Chestrig_khk",
"V_Chestrig_rgr",
"V_Chestrig_blk",
"V_Chestrig_oli",
"V_TacVest_blk",
"V_TacVest_brn",
"V_TacVest_camo",
"V_TacVest_khk",
"V_TacVest_oli",
"V_TacVest_blk_POLICE",
"V_I_G_resistanceLeader_F",
"V_TacVestIR_blk",
"V_PlateCarrierL_CTRG",
"V_PlateCarrierH_CTRG",
"V_PlateCarrierSpec_rgr",
"V_PlateCarrierSpec_blk",
"V_PlateCarrierSpec_mtp",
"V_Press_F",
//APEX
"V_PlateCarrier1_tna_F",   // Carrier Lite (Tropic)
"V_PlateCarrier2_tna_F",   // Carrier Rig (Tropic)
"V_PlateCarrierSpec_tna_F",  // Carrier Special Rig (Tropic)
"V_PlateCarrierGL_tna_F",   // Carrier GL Rig (Tropic)
"V_HarnessO_ghex_F",  //LBV Harness (Green Hex)
"V_HarnessOGL_ghex_F",  //LBV Grenadier Harness (Green Hex)
"V_BandollierB_ghex_F",  // Slash Bandolier (Green Hex)
"V_TacVest_gen_F", // Gendarmerie Vest
"V_PlateCarrier1_rgr_noflag_F", // Carrier Lite (Green, No Flag)
"V_PlateCarrier2_rgr_noflag_F", //Carier Rig(Green, No Flag)
// Items
"Medikit",
"ToolKit",
"MineDetector",
"Rangefinder",
"FirstAidKit",
"Laserdesignator",
"NVGoggles_OPFOR",
"NVGoggles_INDEP",
"Chemlight_blue",
"Chemlight_green",
"Chemlight_yellow",
"Chemlight_red",
"ItemGPS",
"I_UavTerminal",
"O_UavTerminal",
"B_UavTerminal",
"ItemMap",
"ItemCompass",
"ItemWatch",
"NVGoggles",
"ItemRadio",

// Goggles
"G_Aviator",
"G_Diving",
"G_Balaclava_blk",
"G_Balaclava_oli",
"G_Balaclava_combat",
"G_Balaclava_lowprofile",
"G_Bandanna_aviator",
"G_Bandanna_beast",
"G_Bandanna_blk",
"G_Bandanna_khk",
"G_Bandanna_oli",
"G_Bandanna_shades",
"G_Bandanna_sport",
"G_Bandanna_tan",
"G_Combat",
"G_Goggles_VR",
"G_Lady_Blue",
"G_Lady_Dark",
"G_Lady_Mirror",
"G_Lady_Red",
"G_Lowprofile",
"G_Shades_Black",
"G_Shades_Blue",
"G_Shades_Green",
"G_Shades_Red",
"G_Spectacles",
"G_Spectacles_Tinted",
"G_Sport_Blackred",
"G_Sport_BlackWhite",
"G_Sport_Blackyellow",
"G_Sport_Checkered",
"G_Sport_Greenblack",
"G_Sport_Red",
"G_Squares",
"G_Squares_Tinted",
"G_Tactical_Black",
"G_Tactical_Clear",
//APEX
"G_Balaclava_TI_G_tna_F", // Stealth Balaclava (Green, Goggles)
"G_Balaclava_TI_blk_F", // Stealth Balaclava (Black) 
"G_Balaclava_TI_G_blk_F", // Stealth Balaclava (Black, Goggles)
"G_Balaclava_TI_tna_F", //Stealth Balaclava (Green)
"G_Combat_Goggles_tna_F", //Combat Goggles (Green)
"O_NVGoggles_ghex_F", //Compact NVG (G Hex)
"O_NVGoggles_hex_F", //Compact NVG (Hex) 
"O_NVGoggles_urb_F", //Compact NVG (Urban)
//"NVGogglesB_blk_F", //ENVG-II(Black)
//"NVGogglesB_grn_F", //ENVG-II(Green)
//"NVGogglesB_gry_F", //ENVG-II(Gray)
"NVGoggles_tna_F", // NV Goggles (Tropic)
// All Clothing
"U_OrestesBody",
"U_I_G_resistanceLeader_F",
"U_B_GhillieSuit",
"U_O_GhillieSuit",
"U_I_GhillieSuit",
"U_B_FullGhillie_ard",
"U_O_FullGhillie_ard",
"U_I_FullGhillie_ard",
"U_B_FullGhillie_lsh",
"U_O_FullGhillie_lsh",
"U_I_FullGhillie_lsh",
"U_B_FullGhillie_sard","U_O_FullGhillie_sard",
"U_I_FullGhillie_sard",
"U_B_Wetsuit",
"U_O_Wetsuit",
"U_I_Wetsuit",
"U_B_CombatUniform_mcam",
"U_O_CombatUniform_ocamo",
"U_I_CombatUniform",
"U_B_CombatUniform_mcam_tshirt",
"U_B_CombatUniform_mcam_vest",
"U_B_SpecopsUniform_sgg",
"U_B_CTRG_1",
"U_B_CTRG_2",
"U_B_CTRG_3",
"U_O_SpecopsUniform_ocamo",
"U_O_CombatUniform_oucamo",
"U_I_CombatUniform_shortsleeve",
"U_I_CombatUniform_tshirt",
"U_O_OfficerUniform_ocamo",
"U_I_OfficerUniform",
"U_B_PilotCoveralls",
"U_O_PilotCoveralls",
"U_I_pilotCoveralls",
"U_B_HeliPilotCoveralls",
"U_I_HeliPilotCoveralls",
"U_BG_Guerilla1_1",
"U_BG_Guerilla2_1",
"U_BG_Guerilla2_2",
"U_BG_Guerilla2_3",
"U_BG_Guerilla3_1",
"U_BG_Guerilla3_2",
"U_BG_leader",
"U_OG_Guerilla1_1",
"U_OG_Guerilla2_1",
"U_OG_Guerilla2_2",
"U_OG_Guerilla2_3",
"U_OG_Guerilla3_1",
"U_OG_Guerilla3_2",
"U_OG_leader",
"U_IG_Guerilla1_1",
"U_IG_Guerilla2_1",
"U_IG_Guerilla2_2",
"U_IG_Guerilla2_3",
"U_IG_Guerilla3_1",
"U_IG_Guerilla3_2",
"U_IG_leader",
"U_Competitor",
"U_Rangemaster",
"U_B_Protagonist_VR",
"U_O_Protagonist_VR",
"U_I_Protagonist_VR",
"U_C_WorkerCoveralls",
"U_C_Poor_1",
"U_C_Poloshirt_redwhite",
"U_C_Poloshirt_salmon",
"U_C_Poloshirt_tricolour",
"U_C_Poloshirt_blue",
"U_C_Poloshirt_burgundy",
"U_C_Poloshirt_stripped",
"U_C_Driver_1_black",
"U_C_Driver_1_blue",
"U_C_Driver_1_green",
"U_C_Driver_1_yellow",
"U_C_Driver_1_orange",
"U_C_Driver_1_red",
"U_C_Driver_1_white",
"U_C_Driver_1",
"U_C_Driver_2",
"U_C_Driver_3",
"U_C_Driver_4",
//Apex
"U_O_V_Soldier_Viper_F", // Special Purpose Suit (Green Hex)
"U_O_V_Soldier_Viper_hex_F", //Special Purpose Suit (Hex)
"U_B_CTRG_Soldier_F", //CTRG Stealth Uniform
"U_B_CTRG_Soldier_3_F", //CTRG Stealth Uniform (Rolled Up)
"U_B_CTRG_Soldier_2_F", //CTRG Stealth Uniform (Tee)
"U_B_CTRG_Soldier_urb_1_F",  //CTRG Urban Uniform
"U_B_CTRG_Soldier_urb_2_F", //CTRG Urban Uniform (Tee)
"U_B_CTRG_Soldier_urb_3_F", //CTRG Urban Uniform (Rolled Up)
"U_B_T_Soldier_F", //Combat Fatigues (Tropic)
"U_B_T_Soldier_AR_F", //Combat Fatigues (Tropic, Tee)
"U_O_T_Soldier_F", //Fatigues (Green Hex) [CSAT]
"U_O_T_Officer_F", //Officer Fatigues (Green Hex) [CSAT]
"U_B_T_Soldier_SL_F", //Recon Fatigues (Tropic)
"U_O_T_FullGhillie_tna_F", //Full Ghillie (Jungle) [CSAT]
"U_B_T_FullGhillie_tna_F", //Full Ghillie (Jungle) [NATO]
"U_O_T_Sniper_F", //Ghillie Suit (Green Hex) [CSAT]
"U_B_T_Sniper_F", //Ghiilie Suit (Tropic) [NATO]
"U_B_GEN_Commander_F", //Gendarmerie Commander Uniform
"U_B_GEN_Soldier_F", //Gendarmerie Uniform
"U_I_C_Soldier_Camo_F", //Syndikat Uniform
// All Headgear
"H_HelmetB",
"H_HelmetB_camo",
"H_HelmetB_light",
"H_HelmetB_paint",
"H_HelmetSpecB",
"H_HelmetSpecB_blk",
"H_HelmetSpecB_paint1",
"H_HelmetSpecB_paint2",
"H_HelmetB_plain_blk",
"H_HelmetO_ocamo",
"H_HelmetO_oucamo",
"H_HelmetLeaderO_ocamo",
"H_HelmetLeaderO_oucamo",
"H_HelmetSpecO_blk",
"H_CrewHelmetHeli_B",
"H_CrewHelmetHeli_O",
"H_CrewHelmetHeli_I",
"H_PilotHelmetHeli_B",
"H_PilotHelmetHeli_O",
"H_PilotHelmetHeli_I",
"H_HelmetCrew_B",
"H_HelmetCrew_O",
"H_HelmetCrew_I",
"H_PilotHelmetFighter_B",
"H_PilotHelmetFighter_O",
"H_PilotHelmetFighter_I",
"H_MilCap_blue",
"H_MilCap_gry",
"H_MilCap_oucamo",
"H_MilCap_rucamo",
"H_MilCap_mcamo",
"H_MilCap_ocamo",
"H_MilCap_dgtl",
"H_Cap_headphones",
"H_Bandanna_cbr",
"H_Bandanna_camo",
"H_Bandanna_gry",
"H_Bandanna_khk",
"H_Bandanna_mcamo",
"H_Bandanna_sgg",
"H_Bandanna_surfer",
"H_Watchcap_blk",
"H_Watchcap_sgg",
"H_Watchcap_cbr",
"H_Watchcap_khk",
"H_Watchcap_camo",
"H_Beret_blk",
"H_Beret_Colonel",
"H_Beret_02",
"H_Booniehat_khk",
"H_Booniehat_tan",
"H_Booniehat_mcamo",
"H_Booniehat_dgtl",
"H_Hat_blue",
"H_Hat_brown",
"H_Hat_camo",
"H_Hat_checker",
"H_Hat_grey",
"H_Hat_tan",
"H_Cap_blk",
"H_Cap_blu",
"H_Cap_grn",
"H_Cap_oli",
"H_Cap_red",
"H_Cap_tan",
"H_Cap_grn_BI",
"H_Cap_blk_CMMG",
"H_Cap_blk_ION",
"H_Cap_blk_Raven",
"H_Cap_khaki_specops_UK",
"H_Cap_tan_specops_US",
"H_Cap_brn_SPECOPS",
"H_ShemagOpen_khk",
"H_ShemagOpen_tan",
"H_Shemag_khk",
"H_Shemag_olive",
"H_Shemag_tan",
"H_RacingHelmet_1_black_F",
"H_RacingHelmet_1_blue_F",
"H_RacingHelmet_1_green_F",
"H_RacingHelmet_1_yellow_F",
"H_RacingHelmet_1_orange_F",
"H_RacingHelmet_1_red_F",
"H_RacingHelmet_1_white_F",
"H_RacingHelmet_1_F",
"H_RacingHelmet_2_F",
"H_RacingHelmet_3_F",
"H_RacingHelmet_4_F",
"H_HelmetSpecO_ocamo",
"H_HelmetIA_net",
"H_HelmetIA_camo",
"H_BandMask_blk",
"H_BandMask_demon",
"H_BandMask_khk",
"H_BandMask_reaper",	
//apex
"H_Helmet_Skate", // Skate Helmet
"H_HelmetB_TI_tna_F", // Stealth Combat Helmet
"H_HelmetB_tna_F", // Combat Helmet (Tropic)
"H_HelmetB_Enh_tna_F", //Enhanced Combat Helmet (Tropic)
"H_HelmetB_Light_tna_F", //Light Combat Helmet (Tropic)
"H_HelmetSpecO_ghex_F",  // Assassin Helmet (Green Hex)
"H_HelmetLeaderO_ghex_F", //Defender Helmet (G Hex)
"H_HelmetO_ghex_F",  // Protector Helmet (Green Hex)
"H_HelmetCrew_O_ghex_F" // Crew Helmet (Green Hex)
//"H_MilCap_tna_F", 
//"H_MilCap_ghex_F", 
//"H_Booniehat_tna_F", 
//"H_Beret_gen_F", 
//"H_MilCap_gen_F",
//"H_HelmetO_ViperSP_hex_F", //  Special Purpose Helmet (Hex)
//"H_HelmetO_ViperSP_ghex_F" // Special Purpose Helmet (Green Hex)
],true] call BIS_fnc_addVirtualItemCargo;

				//systemChat format["Welcome %1, Enjoy your Supporter Loadout!", name player];
				//systemChat format["Bemvindo %1, Aproveite! Este Loadout será disponibilizado por tempo limitado!", name player];
				systemChat format["Bemvindo %1, Aproveite! Este Loadout é disponibilizado somente para os VIPS! Obrigado por ajudar a manter o Server", name player];
		};	
	};

waitUntil {isNull (uiNamespace getVariable ["RscDisplayArsenal", displayNull])};