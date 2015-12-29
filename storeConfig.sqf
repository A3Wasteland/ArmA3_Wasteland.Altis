// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
/*********************************************************#
# @@ScriptName: storeConfig.sqf
# @@Author: His_Shadow, AgentRev
# @@Create Date: 2013-09-16 20:40:58
#*********************************************************/

// This tracks which store owner the client is interacting with
currentOwnerName = "";

// Gunstore Weapon List - Gun Store Base List
// Text name, classname, buy cost

// empty name = name is extracted from class config

pistolArray = compileFinal str
[
	// Handguns
	["P07 Pistol", "hgun_P07_F", 50],
	["Rook-40 Pistol", "hgun_Rook40_F", 50],
	["ACP-C2 Pistol", "hgun_ACPC2_F", 75],
	["Zubr Revolver", "hgun_Pistol_heavy_02_F", 75],
	["4-Five Pistol", "hgun_Pistol_heavy_01_F", 100],
	["Starter Pistol", "hgun_Pistol_Signal_F", 25]
];

smgArray = compileFinal str
[
	["PDW2000 SMG", "hgun_PDW2000_F", 100],
	["Sting SMG", "SMG_02_F", 125],
	["Vermin SMG", "SMG_01_F", 125]
];

rifleArray = compileFinal str
[
	// Underwater Gun
	["SDAR Underwater Rifle", "arifle_SDAR_F", 100],

	// Assault Rifles
	["Mk20 Carbine", "arifle_Mk20C_plain_F", 150],
	["Mk20 Carbine (Camo)", "arifle_Mk20C_F", 150],
	["Mk20 Rifle", "arifle_Mk20_plain_F", 200],
	["Mk20 Rifle (Camo)", "arifle_Mk20_F", 200],
	["Mk20 EGLM Rifle", "arifle_Mk20_GL_plain_F", 250],
	["Mk20 EGLM Rifle (Camo)", "arifle_Mk20_GL_F", 250],

	["TRG-20 Carbine", "arifle_TRG20_F", 150],
	["TRG-21 Rifle ", "arifle_TRG21_F", 200],
	["TRG-21 EGLM Rifle", "arifle_TRG21_GL_F", 250],

	["Katiba Carbine", "arifle_Katiba_C_F", 150],
	["Katiba Rifle", "arifle_Katiba_F", 200],
	["Katiba GL Rifle", "arifle_Katiba_GL_F", 250],

	["MX Carbine", "arifle_MXC_F", 150],
	["MX Carbine (Black)", "arifle_MXC_Black_F", 175],
	["MX Rifle", "arifle_MX_F", 200],
	["MX Rifle (Black)", "arifle_MX_Black_F", 225],
	["MX 3GL Rifle", "arifle_MX_GL_F", 250],
	["MX 3GL Rifle (Black)", "arifle_MX_GL_Black_F", 275],

	// Markman Rifles
	["MXM Rifle", "arifle_MXM_F", 300],
	["MXM Rifle (Black)", "arifle_MXM_Black_F", 325],
	["DMR Rifle", "srifle_DMR_01_F", 375],
	["Mk18 ABR Rifle", "srifle_EBR_F", 550],

	// DLC
	["Mk14 Rifle (Camo) [DLC]", "srifle_DMR_06_camo_F", 450],
	["Mk14 Rifle (Olive) [DLC]", "srifle_DMR_06_olive_F", 450],
	["Mk-I EMR Rifle (Black) [DLC]", "srifle_DMR_03_F", 600],
	["Mk-I EMR Rifle (Camo) [DLC]", "srifle_DMR_03_multicam_F", 600],
	["Mk-I EMR Rifle (Khaki) [DLC]", "srifle_DMR_03_khaki_F", 600],
	["Mk-I EMR Rifle (Sand) [DLC]", "srifle_DMR_03_tan_F", 600],
	["Mk-I EMR Rifle (Woodland) [DLC]", "srifle_DMR_03_woodland_F", 600],
	//["NATO DMR (provisional) spotter [DLC]", "srifle_DMR_03_spotter_F", 1500], // BUGGED
	["MAR-10 Rifle (Black) [DLC]", "srifle_DMR_02_F", 750],
	["MAR-10 Rifle (Camo) [DLC]", "srifle_DMR_02_camo_F", 750],
	["MAR-10 Rifle (Sand) [DLC]", "srifle_DMR_02_sniper_F", 750],
	["Cyrus Rifle (Black) [DLC]", "srifle_DMR_05_blk_F", 1000],
	["Cyrus Rifle (Hex) [DLC]", "srifle_DMR_05_hex_F", 1000],
	["Cyrus Rifle (Tan) [DLC]", "srifle_DMR_05_tan_f", 1000],

	// Sniper Rifles
	["M320 LRR Sniper", "srifle_LRR_LRPS_F", 2000],
	["M320 LRR Sniper (Camo)", "srifle_LRR_camo_LRPS_F", 2100],
	["GM6 Lynx Sniper", "srifle_GM6_LRPS_F", 2250],
	["GM6 Lynx Sniper (Camo)", "srifle_GM6_camo_LRPS_F", 2350],

	["ASP-1 Kir Rifle (Black) [DLC]", "srifle_DMR_04_F", 5000],
	["ASP-1 Kir Rifle (Tan) [DLC]", "srifle_DMR_04_Tan_F", 5000]
];

lmgArray = compileFinal str
[
	["MX SW LMG", "arifle_MX_SW_F", 500],
	["MX SW LMG (Black)", "arifle_MX_SW_Black_F", 525],
	["Mk200 LMG", "LMG_Mk200_F", 600],
	["Zafir LMG", "LMG_Zafir_F", 700],


	["Navid MMG (Tan) [DLC]", "MMG_01_tan_F", 850],
	["Navid MMG (Hex) [DLC]", "MMG_01_hex_F", 850],
	["SPMG MMG (Sand) [DLC]", "MMG_02_sand_F", 950],
	["SPMG MMG (MTP) [DLC]", "MMG_02_camo_F", 950],
	["SPMG MMG (Black) [DLC]", "MMG_02_black_F", 950]
];

launcherArray = compileFinal str
[
	["RPG-42 Alamut", "launch_RPG32_F", 400],
	["PCML", "launch_NLAW_F", 800],
	["Titan MPRL Compact (Tan)", "launch_Titan_short_F", 2500],
	["Titan MPRL Compact (Brown)", "launch_O_Titan_short_F", 2500],
	["Titan MPRL Compact (Olive)", "launch_I_Titan_short_F", 2500],
	["Titan MPRL AA (Desert)", "launch_Titan_F", 1500],
	["Titan MPRL AA (Hex)", "launch_O_Titan_F", 1500],
	["Titan MPRL AA (Digi)", "launch_I_Titan_F", 1500]
];

allGunStoreFirearms = compileFinal str (call pistolArray + call smgArray + call rifleArray + call lmgArray + call launcherArray);

staticGunsArray = compileFinal str
[
	// ["Vehicle Ammo Crate", "Box_NATO_AmmoVeh_F", 2500],
	["Static Titan AT 4Rnd (NATO)", "B_static_AT_F", 3500], // Static launchers only have 4 ammo, hence the low price
	["Static Titan AT 4Rnd (CSAT)", "O_static_AT_F", 3500],
	["Static Titan AT 4Rnd (AAF)", "I_static_AT_F", 3500],
	["Static Titan AA 4Rnd (NATO)", "B_static_AA_F", 4000],
	["Static Titan AA 4Rnd (CSAT)", "O_static_AA_F", 4000],
	["Static Titan AA 4Rnd (AAF)", "I_static_AA_F", 4000],
	["Mk30 HMG .50 Low tripod (NATO)", "B_HMG_01_F", 3000],
	["Mk30 HMG .50 Low tripod (CSAT)", "O_HMG_01_F", 3000],
	["Mk30 HMG .50 Low tripod (AAF)", "I_HMG_01_F", 3000],
	// ["Mk30A HMG .50 Sentry (NATO)", "B_HMG_01_A_F", 5000], // "A" = Autonomous = Overpowered
	// ["Mk30A HMG .50 Sentry (CSAT)", "O_HMG_01_A_F", 5000],
	// ["Mk30A HMG .50 Sentry (AAF)", "I_HMG_01_A_F", 5000],
	["Mk30 HMG .50 High tripod (NATO)", "B_HMG_01_high_F", 4000],
	["Mk30 HMG .50 High tripod (CSAT)", "O_HMG_01_high_F", 4000],
	["Mk30 HMG .50 High tripod (AAF)", "I_HMG_01_high_F", 4000],
	["Mk32 GMG 20mm Low tripod (NATO)", "B_GMG_01_F", 6000],
	["Mk32 GMG 20mm Low tripod (CSAT)", "O_GMG_01_F", 6000],
	["Mk32 GMG 20mm Low tripod (AAF)", "I_GMG_01_F", 6000],
	// ["Mk32A GMG 20mm Sentry (NATO)", "B_GMG_01_A_F", 10000],
	// ["Mk32A GMG 20mm Sentry (CSAT)", "O_GMG_01_A_F", 10000],
	// ["Mk32A GMG 20mm Sentry (AAF)", "I_GMG_01_A_F", 10000],
	["Mk32 GMG 20mm High tripod (NATO)", "B_GMG_01_high_F", 7000],
	["Mk32 GMG 20mm High tripod (CSAT)", "O_GMG_01_high_F", 7000],
	["Mk32 GMG 20mm High tripod (AAF)", "I_GMG_01_high_F", 7000],
	["Mk6 Mortar (NATO)", "B_Mortar_01_F", 50000],
	["Mk6 Mortar (CSAT)", "O_Mortar_01_F", 50000],
	["Mk6 Mortar (AAF)", "I_Mortar_01_F", 50000]
];

throwputArray = compileFinal str
[
	//["Stone", "HandGrenade_Stone", 5], // Doesn't work
	["Smoke Grenade (White)", "SmokeShell", 50],
	["Smoke Grenade (Purple)", "SmokeShellPurple", 50],
	["Smoke Grenade (Blue)", "SmokeShellBlue", 50],
	["Smoke Grenade (Green)", "SmokeShellGreen", 50],
	["Smoke Grenade (Orange)", "SmokeShellOrange", 50],
	["Smoke Grenade (Red)", "SmokeShellRed", 50],
	["Toxic Gas Grenade", "SmokeShellYellow", 750],
	["Mini Grenade", "MiniGrenade", 50],
	["Frag Grenade", "HandGrenade", 100],
	["APERS Tripwire Mine", "APERSTripMine_Wire_Mag", 200],
	["APERS Bounding Mine", "APERSBoundingMine_Range_Mag", 250],
	["APERS Mine", "APERSMine_Range_Mag", 300],
	["Claymore Charge", "ClaymoreDirectionalMine_Remote_Mag", 350],
	["M6 SLAM Mine", "SLAMDirectionalMine_Wire_Mag", 350],
	["AT Mine", "ATMine_Range_Mag", 400],
	["Explosive Charge", "DemoCharge_Remote_Mag", 450],
	["Explosive Satchel", "SatchelCharge_Remote_Mag", 500],
	["Small IED (Urban)", "IEDUrbanSmall_Remote_Mag", 1000],
	["Small IED (Dug-in)", "IEDLandSmall_Remote_Mag", 1000],
	["Large IED (Urban)", "IEDUrbanBig_Remote_Mag", 1500],
	["Large IED (Dug-in)", "IEDLandBig_Remote_Mag", 1500]
];

//Gun Store Ammo List
//Text name, classname, buy cost
ammoArray = compileFinal str
[
	["6Rnd Signal Cylinder (Green)", "6Rnd_GreenSignal_F", 10],
	["6Rnd Signal Cylinder (Red)", "6Rnd_RedSignal_F", 10],
	["9mm 16Rnd Mag", "16Rnd_9x21_Mag", 10],
	["9mm 30Rnd Mag", "30Rnd_9x21_Mag", 15],
	[".45 ACP 6Rnd Cylinder", "6Rnd_45ACP_Cylinder", 5],
	[".45 ACP 9Rnd Mag", "9Rnd_45ACP_Mag", 10],
	[".45 ACP 11Rnd Mag", "11Rnd_45ACP_Mag", 15],
	[".45 ACP 30Rnd Vermin Mag", "30Rnd_45ACP_MAG_SMG_01", 20],
	[".45 ACP 30Rnd Tracer (Green) Mag", "30Rnd_45ACP_Mag_SMG_01_tracer_green", 15],
	["5.56mm 20Rnd Underwater Mag", "20Rnd_556x45_UW_mag", 10],
	["5.56mm 30Rnd STANAG Mag", "30Rnd_556x45_Stanag", 20],
	["5.56mm 30Rnd Tracer (Green) Mag", "30Rnd_556x45_Stanag_Tracer_Green", 15],
	["5.56mm 30Rnd Tracer (Yellow) Mag", "30Rnd_556x45_Stanag_Tracer_Yellow", 15],
	["5.56mm 30Rnd Tracer (Red) Mag", "30Rnd_556x45_Stanag_Tracer_Red", 15],
	["6.5mm 30Rnd STANAG Mag", "30Rnd_65x39_caseless_mag", 20],
	["6.5mm 30Rnd Tracer (Red) Mag", "30Rnd_65x39_caseless_mag_Tracer", 15],
	["6.5mm 30Rnd Caseless Mag", "30Rnd_65x39_caseless_green", 20],
	["6.5mm 30Rnd Tracer (Green) Mag", "30Rnd_65x39_caseless_green_mag_Tracer", 15],
	["6.5mm 100Rnd Belt Case", "100Rnd_65x39_caseless_mag", 75],
	["6.5mm 100Rnd Tracer (Red) Belt Case", "100Rnd_65x39_caseless_mag_Tracer", 50],
	["6.5mm 200Rnd Belt Case", "200Rnd_65x39_cased_Box", 150],
	["6.5mm 200Rnd Tracer (Yellow) Belt Case", "200Rnd_65x39_cased_Box_Tracer", 125],
	["7.62mm 10Rnd Mag", "10Rnd_762x54_Mag", 15],
	["7.62mm 20Rnd Mag", "20Rnd_762x51_Mag", 55],
	["7.62mm 150Rnd Box", "150Rnd_762x54_Box", 150],
	["7.62mm 150Rnd Tracer (Green) Box", "150Rnd_762x54_Box_Tracer", 125],
	[".338 LM 10Rnd Mag", "10Rnd_338_Mag", 65], //DLC Ammo
	[".338 NM 130Rnd Belt", "130Rnd_338_Mag", 150], //DLC Ammo
	[".408 7Rnd Cheetah Mag", "7Rnd_408_Mag", 100],
	["9.3mm 10Rnd Mag", "10Rnd_93x64_DMR_05_Mag", 65], //DLC Ammo
	["9.3mm 150Rnd Belt", "150Rnd_93x64_Mag", 150], //DLC Ammo
	["12.7mm 5Rnd Mag", "5Rnd_127x108_Mag", 100],
	["12.7mm 5Rnd Armor-Piercing Mag", "5Rnd_127x108_APDS_Mag", 150],
	["12.7mm 10Rnd Subsonic Mag", "10Rnd_127x54_Mag", 75], //DLC Ammo
	["RPG-42 Anti-Tank Rocket", "RPG32_F", 750],              // Direct damage: high      | Splash damage: low    | Guidance: none
	["RPG-42 High-Explosive Rocket", "RPG32_HE_F", 175],      // Direct damage: medium    | Splash damage: medium | Guidance: none
	["PCML Anti-Tank Missile", "NLAW_F", 500],                // Direct damage: very high | Splash damage: low    | Guidance: laser, ground vehicles
	["Titan Anti-Tank Missile", "Titan_AT", 1000],            // Direct damage: high      | Splash damage: low    | Guidance: mouse, laser, ground vehicles
	["Titan Anti-Personnel Missile", "Titan_AP", 750],        // Direct damage: low       | Splash damage: high   | Guidance: mouse, laser
	["Titan Anti-Air Missile", "Titan_AA", 1000],              // Direct damage: low       | Splash damage: medium | Guidance: aircraft
	["40mm HE Grenade Round", "1Rnd_HE_Grenade_shell", 125],
	["40mm 3Rnd HE Grenades", "3Rnd_HE_Grenade_shell", 250],
	["40mm Smoke Round (White)", "1Rnd_Smoke_Grenade_shell", 50],
	["40mm Smoke Round (Purple)", "1Rnd_SmokePurple_Grenade_shell", 50],
	["40mm Smoke Round (Blue)", "1Rnd_SmokeBlue_Grenade_shell", 50],
	["40mm Smoke Round (Green)", "1Rnd_SmokeGreen_Grenade_shell", 50],
	["40mm Smoke Round (Yellow)", "1Rnd_SmokeYellow_Grenade_shell", 50],
	["40mm Smoke Round (Orange)", "1Rnd_SmokeOrange_Grenade_shell", 50],
	["40mm Smoke Round (Red)", "1Rnd_SmokeRed_Grenade_shell", 50],
	["40mm 3Rnd Smokes (White)", "3Rnd_Smoke_Grenade_shell", 100],
	["40mm 3Rnd Smokes (Purple)", "3Rnd_SmokePurple_Grenade_shell", 100],
	["40mm 3Rnd Smokes (Blue)", "3Rnd_SmokeBlue_Grenade_shell", 100],
	["40mm 3Rnd Smokes (Green)", "3Rnd_SmokeGreen_Grenade_shell", 100],
	["40mm 3Rnd Smokes (Yellow)", "3Rnd_SmokeYellow_Grenade_shell", 100],
	["40mm 3Rnd Smokes (Orange)", "3Rnd_SmokeOrange_Grenade_shell", 100],
	["40mm 3Rnd Smokes (Red)", "3Rnd_SmokeRed_Grenade_shell", 100],
	["40mm Flare Round (White)", "UGL_FlareWhite_F", 25],
	["40mm Flare Round (Green)", "UGL_FlareGreen_F", 25],
	["40mm Flare Round (Yellow)", "UGL_FlareYellow_F", 25],
	["40mm Flare Round (Red)", "UGL_FlareRed_F", 25],
	["40mm Flare Round (IR)", "UGL_FlareCIR_F", 25],
	["40mm 3Rnd Flares (White)", "3Rnd_UGL_FlareWhite_F", 50],
	["40mm 3Rnd Flares (Green)", "3Rnd_UGL_FlareGreen_F", 50],
	["40mm 3Rnd Flares (Yellow)", "3Rnd_UGL_FlareYellow_F", 50],
	["40mm 3Rnd Flares (Red)", "3Rnd_UGL_FlareRed_F", 50],
	["40mm 3Rnd Flares (IR)", "3Rnd_UGL_FlareCIR_F", 50]
];

//Gun Store item List
//Text name, classname, buy cost, item class
accessoriesArray = compileFinal str
[
	["Suppressor 9mm", "muzzle_snds_L", 100, "item"],
	["Suppressor .45 ACP", "muzzle_snds_acp", 175, "item"],
	["Suppressor 5.56mm", "muzzle_snds_M", 200, "item"],
	["Suppressor 6.5mm", "muzzle_snds_H", 250, "item"],
	["Suppressor 6.5mm LMG", "muzzle_snds_H_MG", 300, "item"],
	["Suppressor 7.62mm", "muzzle_snds_B", 350, "item"],
	["Suppressor .338 [DLC]", "muzzle_snds_338_black", 450, "item"],
	["Suppressor .338 (Green) [DLC]", "muzzle_snds_338_green", 450, "item"],
	["Suppressor .338 (Sand) [DLC]", "muzzle_snds_338_sand", 450, "item"],
	["Suppressor 9.3mm [DLC]", "muzzle_snds_93mmg", 550, "item"],
	["Suppressor 9.3mm (Tan) [DLC]", "muzzle_snds_93mmg_tan", 550, "item"],
	["Bipod (NATO)", "bipod_01_F_blk", 450, "item"],
	["Bipod (CSAT)", "bipod_02_F_blk", 450, "item"],
	["Bipod (AAF)", "bipod_03_F_blk", 450, "item"],
	["Bipod (MTP)", "bipod_01_F_mtp", 450, "item"],
	["Bipod (Hex)", "bipod_02_F_hex", 450, "item"],
	["Bipod (Olive)", "bipod_03_F_oli", 450, "item"],
	["Bipod (Sand)", "bipod_01_F_snd", 450, "item"],
	["Bipod (Tan)", "bipod_02_F_tan", 450, "item"],
	["Flashlight", "acc_flashlight", 100, "item"],
	["IR Laser Pointer", "acc_pointer_IR", 100, "item"],
	["Yorris Sight (Zubr Revolver)", "optic_Yorris", 50, "item"],
	["MRD Sight (4-Five Pistol)", "optic_MRD", 50, "item"],
	["ACO (CQB)", "optic_aco_smg", 50, "item"],
	["Holosight (CQB)", "optic_Holosight_smg", 75, "item"],
	["ACO (Red)", "optic_Aco", 100, "item"],
	["ACO (Green)", "optic_Aco_grn", 100, "item"],
	["Holosight", "optic_Holosight", 125, "item"],
	["MRCO", "optic_MRCO", 150, "item"],
	["ARCO", "optic_Arco", 175, "item"],
	["RCO", "optic_Hamr", 200, "item"],
	["MOS", "optic_SOS", 300, "item"],
	["DMS", "optic_DMS", 350, "item"],
	["AMS [DLC]", "optic_AMS", 400, "item"],
	["AMS (Khaki) [DLC]", "optic_AMS_khk", 400, "item"],
	["AMS (Sand) [DLC]", "optic_AMS_snd", 400, "item"],
	["Kahlia [DLC]", "optic_KHS_blk", 500, "item"],
	["Kahlia (Hex) [DLC]", "optic_KHS_hex", 500, "item"],
	["Kahlia (Tan) [DLC]", "optic_KHS_tan", 500, "item"],
	["Kahlia (Old) [DLC]", "optic_KHS_old", 500, "item"],
	["LRPS", "optic_LRPS", 750, "item"],
	["NVS", "optic_NVS", 1500, "item"],
	["TWS", "optic_tws", 10000, "item"],
	["TWS MG", "optic_tws_mg", 12000, "item"],
	["Nightstalker", "optic_Nightstalker", 15000, "item"]
];

// If commented, means the color/camo isn't implemented or is a duplicate of another hat
headArray = compileFinal str
[
	["Gas Mask (NATO)", "H_CrewHelmetHeli_B", 1000, "hat"],
	["Gas Mask (CSAT)", "H_CrewHelmetHeli_O", 1000, "hat"],
	["Gas Mask (AAF)", "H_CrewHelmetHeli_I", 1000, "hat"],
	["ECH", "H_HelmetB", 50, "hat"],
	["ECH (Ghillie)", "H_HelmetB_camo", 50, "hat"],
	["ECH (Light)", "H_HelmetB_light", 50, "hat"],
	["ECH (Spraypaint)", "H_HelmetB_paint", 50, "hat"],
	["SF Helmet", "H_HelmetSpecB", 50, "hat"],
	["SF Helmet (Black)", "H_HelmetSpecB_blk", 50, "hat"],
	["SF Helmet (Light Paint)", "H_HelmetSpecB_paint1", 50, "hat"],
	["SF Helmet (Dark Paint)", "H_HelmetSpecB_paint2", 50, "hat"],
	["Combat Helmet (Black)", "H_HelmetB_plain_blk", 50, "hat"],
	["Protector Helmet (Hex)", "H_HelmetO_ocamo", 50, "hat"],
	["Protector Helmet (Urban)", "H_HelmetO_oucamo", 50, "hat"],
	["Defender Helmet (Hex)", "H_HelmetLeaderO_ocamo", 50, "hat"],
	["Defender Helmet (Urban)", "H_HelmetLeaderO_oucamo", 50, "hat"],
	["Assassin Helmet (Hex)", "H_HelmetSpecO_ocamo", 50, "hat"],
	["Assassin Helmet (Black)", "H_HelmetSpecO_blk", 50, "hat"],
	["MICH", "H_HelmetIA", 50, "hat"],
	// ["MICH (Camo)", "H_HelmetIA_net", 50, "hat"],
	// ["MICH 2 (Camo)", "H_HelmetIA_camo", 50, "hat"],
	/*["Heli Crew Helmet (NATO)", "H_CrewHelmetHeli_B", 50, "hat"],
	["Heli Crew Helmet (CSAT)", "H_CrewHelmetHeli_O", 50, "hat"],
	["Heli Crew Helmet (AAF)", "H_CrewHelmetHeli_I", 50, "hat"],*/ // Removed and renamed as gasmask
	["Heli Pilot Helmet (NATO)", "H_PilotHelmetHeli_B", 50, "hat"],
	["Heli Pilot Helmet (CSAT)", "H_PilotHelmetHeli_O", 50, "hat"],
	["Heli Pilot Helmet (AAF)", "H_PilotHelmetHeli_I", 50, "hat"],
	["Crew Helmet (NATO)", "H_HelmetCrew_B", 50, "hat"],
	["Crew Helmet (CSAT)", "H_HelmetCrew_O", 50, "hat"],
	["Crew Helmet (AAF)", "H_HelmetCrew_I", 50, "hat"],
	["Pilot Helmet (NATO)", "H_PilotHelmetFighter_B", 50, "hat"],
	["Pilot Helmet (CSAT)", "H_PilotHelmetFighter_O", 50, "hat"],
	["Pilot Helmet (AAF)", "H_PilotHelmetFighter_I", 50, "hat"],
	["Bandanna (Coyote)", "H_Bandanna_cbr", 10, "hat"],
	["Bandanna (Camo)", "H_Bandanna_camo", 10, "hat"],
	["Bandanna (Gray)", "H_Bandanna_gry", 10, "hat"],
	["Bandanna (Khaki)", "H_Bandanna_khk", 10, "hat"],
	["Bandanna (MTP)", "H_Bandanna_mcamo", 10, "hat"],
	["Bandanna (Sage)", "H_Bandanna_sgg", 10, "hat"],
	["Bandanna (Surfer)", "H_Bandanna_surfer", 10, "hat"],
	["Beanie (Black)", "H_Watchcap_blk", 10, "hat"],
	["Beanie (Dark blue)", "H_Watchcap_sgg", 10, "hat"],
	["Beanie (Dark brown)", "H_Watchcap_cbr", 10, "hat"],
	["Beanie (Dark khaki)", "H_Watchcap_khk", 10, "hat"],
	["Beanie (Dark green)", "H_Watchcap_camo", 10, "hat"],
	["Beret (Black)", "H_Beret_blk", 10, "hat"],
	["Beret (Colonel)", "H_Beret_Colonel", 10, "hat"],
	["Beret (NATO)", "H_Beret_02", 10, "hat"],
	// ["Beret (Green)", "H_Beret_grn", 10, "hat"],
	// ["Beret (Police)", "H_Beret_blk_POLICE", 10, "hat"],
	["Booniehat (Khaki)", "H_Booniehat_khk", 10, "hat"],
	["Booniehat (Tan)", "H_Booniehat_tan", 10, "hat"],
	["Booniehat (MTP)", "H_Booniehat_mcamo", 10, "hat"],
	["Booniehat (Digi)", "H_Booniehat_dgtl", 10, "hat"],
	["Fedora (Blue)", "H_Hat_blue", 10, "hat"],
	["Cap (SAS)", "H_Cap_khaki_specops_UK", 10, "hat"],
	["Cap (SF)", "H_Cap_tan_specops_US", 10, "hat"],
	["Cap (SPECOPS)", "H_Cap_brn_SPECOPS", 10, "hat"],
	["Shemag (White)", "H_ShemagOpen_khk", 25, "hat"],
	["Shemag (Brown)", "H_ShemagOpen_tan", 25, "hat"],
	["Shemag mask (Khaki)", "H_Shemag_khk", 25, "hat"],
	["Shemag mask (Olive)", "H_Shemag_olive", 25, "hat"]
	// ["Shemag mask (Tan)", "H_Shemag_tan", 25, "hat"]
];

uniformArray = compileFinal str
[
	["Ghillie Suit (NATO)", "U_B_GhillieSuit", 500, "uni"],
	["Ghillie Suit (CSAT)", "U_O_GhillieSuit", 500, "uni"],
	["Ghillie Suit (AAF)", "U_I_GhillieSuit", 500, "uni"],
	["Wetsuit (NATO)", "U_B_Wetsuit", 400, "uni"],
	["Wetsuit (CSAT)", "U_O_Wetsuit", 400, "uni"],
	["Wetsuit (AAF)", "U_I_Wetsuit", 400, "uni"],
	["Default Uniform (NATO)", "U_B_CombatUniform_mcam", 150, "uni"],
	["Default Uniform (CSAT)", "U_O_CombatUniform_ocamo", 150, "uni"],
	["Default Uniform (AAF)", "U_I_CombatUniform", 150, "uni"],
	["Combat Fatigues (MTP) (Tee)", "U_B_CombatUniform_mcam_tshirt", 150, "uni"],
	["Recon Fatigues (MTP)", "U_B_CombatUniform_mcam_vest", 150, "uni"],
	["Recon Fatigues (Sage)", "U_B_SpecopsUniform_sgg", 150, "uni"],
	["CTRG Combat Uniform (UBACS)", "U_B_CTRG_1", 150, "uni"],
	["CTRG Combat Uniform (UBACS2)", "U_B_CTRG_2", 150, "uni"],
	["CTRG Combat Uniform (Tee)", "U_B_CTRG_3", 150, "uni"],
	["Recon Fatigues (Hex)", "U_O_SpecopsUniform_ocamo", 150, "uni"],
	["Fatigues (Urban)", "U_O_CombatUniform_oucamo", 150, "uni"],
	["Combat Fatigues Short (Digi)", "U_I_CombatUniform_shortsleeve", 150, "uni"],
	["Combat Fatigues Shirt (Digi)", "U_I_CombatUniform_tshirt", 150, "uni"],
	["Officer Fatigues (Hex)", "U_O_OfficerUniform_ocamo", 150, "uni"],
	["Officer Fatigues (Digi)", "U_I_OfficerUniform", 150, "uni"],
	["Pilot Coveralls (NATO)", "U_B_PilotCoveralls", 150, "uni"],
	["Pilot Coveralls (CSAT)", "U_O_PilotCoveralls", 150, "uni"],
	["Pilot Coveralls (AAF)", "U_I_pilotCoveralls", 150, "uni"],
	["Heli Pilot Coveralls (NATO)", "U_B_HeliPilotCoveralls", 250, "uni"],
	["Heli Pilot Coveralls (AAF)", "U_I_HeliPilotCoveralls", 250, "uni"],
	["Guerilla Smocks 1", "U_BG_Guerilla1_1", 125, "uni"], // BLUFOR
	["Guerilla Smocks 2", "U_BG_Guerilla2_1", 125, "uni"],
	["Guerilla Smocks 3", "U_BG_Guerilla2_2", 125, "uni"],
	["Guerilla Smocks 4", "U_BG_Guerilla2_3", 125, "uni"],
	["Guerilla Smocks 5", "U_BG_Guerilla3_1", 125, "uni"],
	["Guerilla Smocks 6", "U_BG_Guerilla3_2", 125, "uni"],
	["Guerilla Smocks 7", "U_BG_leader", 125, "uni"],
	["Guerilla Smocks 1", "U_OG_Guerilla1_1", 125, "uni"], // OPFOR
	["Guerilla Smocks 2", "U_OG_Guerilla2_1", 125, "uni"],
	["Guerilla Smocks 3", "U_OG_Guerilla2_2", 125, "uni"],
	["Guerilla Smocks 4", "U_OG_Guerilla2_3", 125, "uni"],
	["Guerilla Smocks 5", "U_OG_Guerilla3_1", 125, "uni"],
	["Guerilla Smocks 6", "U_OG_Guerilla3_2", 125, "uni"],
	["Guerilla Smocks 7", "U_OG_leader", 125, "uni"],
	["Guerilla Smocks 1", "U_IG_Guerilla1_1", 125, "uni"], // Independent
	["Guerilla Smocks 2", "U_IG_Guerilla2_1", 125, "uni"],
	["Guerilla Smocks 3", "U_IG_Guerilla2_2", 125, "uni"],
	["Guerilla Smocks 4", "U_IG_Guerilla2_3", 125, "uni"],
	["Guerilla Smocks 5", "U_IG_Guerilla3_1", 125, "uni"],
	["Guerilla Smocks 6", "U_IG_Guerilla3_2", 125, "uni"],
	["Guerilla Smocks 7", "U_IG_leader", 125, "uni"],
	["Polo (Competitor)", "U_Competitor", 125, "uni"],
	["Polo (Rangemaster)", "U_Rangemaster", 125, "uni"],
	["Full Ghillie (Arid) (NATO)", "U_B_FullGhillie_ard", 2500, "uni"], //DLC Uniform
	["Full Ghillie (Arid) (CSAT)", "U_O_FullGhillie_ard", 2500, "uni"], //DLC Uniform
	["Full Ghillie (Arid) (AAF)", "U_I_FullGhillie_ard", 2500, "uni"], //DLC Uniform
	["Full Ghillie (Lush) (NATO)", "U_B_FullGhillie_lsh", 2500, "uni"], //DLC Uniform
	["Full Ghillie (Lush) (CSAT)", "U_O_FullGhillie_lsh", 2500, "uni"], //DLC Uniform
	["Full Ghillie (Lush) (AAF)", "U_I_FullGhillie_lsh", 2500, "uni"], //DLC Uniform
	["Full Ghillie (Semi-Arid) (NATO)", "U_B_FullGhillie_sard", 2500, "uni"], //DLC Uniform
	["Full Ghillie (Semi-Arid) (CSAT)", "U_O_FullGhillie_sard", 2500, "uni"], //DLC Uniform
	["Full Ghillie (Semi-Arid) (AAF)", "U_I_FullGhillie_sard", 2500, "uni"], //DLC Uniform
	["Tron Light Suit (Blue)", "U_B_Protagonist_VR", 5000, "uni"],
	["Tron Light Suit (Red)", "U_O_Protagonist_VR", 5000, "uni"],
	["Tron Light Suit (Green)", "U_I_Protagonist_VR", 5000, "uni"]
];

vestArray = compileFinal str
[
	["Rebreather (NATO)", "V_RebreatherB", 200, "vest"],
	["Rebreather (CSAT)", "V_RebreatherIR", 200, "vest"],
	["Rebreather (AAF)", "V_RebreatherIA", 200, "vest"],
	["Carrier Lite (Green)", "V_PlateCarrier1_rgr", -1, "vest"],
	["Carrier Lite (Black)", "V_PlateCarrier1_blk", -1, "vest"],
	["Carrier Rig (Green)", "V_PlateCarrier3_rgr", -1, "vest"],
	["Carrier GL Rig (Green)", "V_PlateCarrierGL_rgr", -1, "vest"],
	["Carrier GL Rig (Black)", "V_PlateCarrierGL_blk", -1, "vest"],
	["Carrier GL Rig (MTP)", "V_PlateCarrierGL_mtp", -1, "vest"],
	["Carrier Special Rig (Green)", "V_PlateCarrierSpec_rgr", -1, "vest"],
	["Carrier Special Rig (Black)", "V_PlateCarrierSpec_blk", -1, "vest"],
	["Carrier Special Rig (MTP)", "V_PlateCarrierSpec_mtp", -1, "vest"],
	["GA Carrier Lite (Digi)", "V_PlateCarrierIA1_dgtl", -1, "vest"],
	["GA Carrier Rig (Digi)", "V_PlateCarrierIA2_dgtl", -1, "vest"],
	["GA Carrier GL Rig (Digi)", "V_PlateCarrierIAGL_dgtl", -1, "vest"],
	["GA Carrier GL Rig (Olive)", "V_PlateCarrierIAGL_oli", -1, "vest"],
	["LBV Harness", "V_HarnessO_brn", -1, "vest"],
	["LBV Harness (Gray)", "V_HarnessO_gry", -1, "vest"],
	["LBV Grenadier Harness", "V_HarnessOGL_brn", -1, "vest"],
	["LBV Grenadier Harness (Gray)", "V_HarnessOGL_gry", -1, "vest"],
	["ELBV Harness", "V_HarnessOSpec_brn", -1, "vest"],
	["ELBV Harness (Gray)", "V_HarnessOSpec_gry", -1, "vest"],
	["Slash Bandolier (Black)", "V_BandollierB_blk", -1, "vest"],
	["Slash Bandolier (Coyote)", "V_BandollierB_cbr", -1, "vest"],
	["Slash Bandolier (Green)", "V_BandollierB_rgr", -1, "vest"],
	["Slash Bandolier (Khaki)", "V_BandollierB_khk", -1, "vest"],
	["Slash Bandolier (Olive)", "V_BandollierB_oli", -1, "vest"],
	["Chest Rig (Khaki)", "V_Chestrig_khk", -1, "vest"],
	["Chest Rig (Green)", "V_Chestrig_rgr", -1, "vest"],
	["Fighter Chestrig (Black)", "V_Chestrig_blk", -1, "vest"],
	["Fighter Chestrig (Olive)", "V_Chestrig_oli", -1, "vest"],
	["Tactical Vest (Black)", "V_TacVest_blk", -1, "vest"],
	["Tactical Vest (Brown)", "V_TacVest_brn", -1, "vest"],
	["Tactical Vest (Camo)", "V_TacVest_camo", -1, "vest"],
	["Tactical Vest (Khaki)", "V_TacVest_khk", -1, "vest"],
	["Tactical Vest (Olive)", "V_TacVest_oli", -1, "vest"],
	["Tactical Vest (Police)", "V_TacVest_blk_POLICE", -1, "vest"],
	["Tactical Vest (Stavrou)", "V_I_G_resistanceLeader_F", -1, "vest"],
	["Raven Night Vest", "V_TacVestIR_blk", -1, "vest"],
	["CTRG Plate Carrier Rig Mk.1 (Light)", "V_PlateCarrierL_CTRG", -1, "vest"],
	["CTRG Plate Carrier Rig Mk.2 (Heavy)", "V_PlateCarrierH_CTRG", -1, "vest"],
	["Press Vest", "V_Press_F", -1, "vest"]
];

backpackArray = compileFinal str
[
	//["Parachute", "B_Parachute", 200, "backpack"],

	["Assault Pack (Black)", "B_AssaultPack_blk", 150, "backpack"],
	["Assault Pack (Green)", "B_AssaultPack_rgr", 150, "backpack"],
	["Assault Pack (MTP)", "B_AssaultPack_mcamo", 150, "backpack"],
	["Assault Pack (Hex)", "B_AssaultPack_ocamo", 150, "backpack"],

	["Field Pack (Black)", "B_FieldPack_blk", 250, "backpack"],
	["Field Pack (Coyote)", "B_FieldPack_cbr", 250, "backpack"],
	["Field Pack (Hex)", "B_FieldPack_ocamo", 250, "backpack"],
	["Field Pack (Khaki)", "B_FieldPack_khk", 250, "backpack"],
	["Field Pack (Olive)", "B_FieldPack_oli", 250, "backpack"],
	["Field Pack (Urban)", "B_FieldPack_oucamo", 250, "backpack"],

	["Kitbag (Coyote)", "B_Kitbag_cbr", 450, "backpack"],
	["Kitbag (Green)", "B_Kitbag_rgr", 450, "backpack"],
	["Kitbag (MTP)", "B_Kitbag_mcamo", 450, "backpack"],
	["Kitbag (Sage)", "B_Kitbag_sgg", 450, "backpack"],

	["Bergen (Black)", "B_Bergen_blk", 650, "backpack"],
	["Bergen (Green)", "B_Bergen_rgr", 650, "backpack"],
	["Bergen (MTP)", "B_Bergen_mcamo", 650, "backpack"],
	["Bergen (Sage)", "B_Bergen_sgg", 650, "backpack"],

	["Carryall (Coyote)", "B_Carryall_cbr", 850, "backpack"],
	["Carryall (Hex)", "B_Carryall_ocamo", 850, "backpack"],
	["Carryall (Khaki)", "B_Carryall_khk", 850, "backpack"],
	["Carryall (MTP)", "B_Carryall_mcamo", 850, "backpack"],
	["Carryall (Olive)", "B_Carryall_oli", 850, "backpack"],
	["Carryall (Urban)", "B_Carryall_oucamo", 850, "backpack"]
];

genItemArray = compileFinal str
[
	["UAV Terminal (NATO)", "B_UavTerminal", 750, "gps"],
	["UAV Terminal (CSAT)", "O_UavTerminal", 750, "gps"],
	["UAV Terminal (AAF)", "I_UavTerminal", 750, "gps"],
	["Quadrotor UAV (NATO)", "B_UAV_01_backpack_F", 7500, "backpack"],
	["Quadrotor UAV (CSAT)", "O_UAV_01_backpack_F", 7500, "backpack"],
	["Quadrotor UAV (AAF)", "I_UAV_01_backpack_F", 7500, "backpack"],
	["Remote Designator Bag (NATO)", "B_Static_Designator_01_weapon_F", 5500, "backpack"],
	["Remote Designator Bag (CSAT)", "O_Static_Designator_02_weapon_F", 5500, "backpack"],
	["GPS", "ItemGPS", 500, "gps"],
	["First Aid Kit", "FirstAidKit", 100, "item"],
	["Medikit", "Medikit", 500, "item"],
	["Toolkit", "ToolKit", 500, "item"],
	["Mine Detector", "MineDetector", 250, "item"],
	["NV Goggles Brown", "NVGoggles", 500, "nvg"],
	["NV Goggles Black", "NVGoggles_OPFOR", 500, "nvg"],
	["NV Goggles Green", "NVGoggles_INDEP", 500, "nvg"],
	["Binoculars", "Binocular", 500, "binoc"],
	["Rangefinder", "Rangefinder", 1000, "binoc"],
	["Laser Designator (NATO)", "Laserdesignator", 1500, "binoc", "WEST"],
	["Laser Designator (CSAT)", "Laserdesignator_02", 1500, "binoc", "EAST"],
	["Laser Designator (AAF)", "Laserdesignator_03", 1500, "binoc", "GUER"],
	["IR Grenade (NATO)", "B_IR_Grenade", 150, "mag", "WEST"],
	["IR Grenade (CSAT)", "O_IR_Grenade", 150, "mag", "EAST"],
	["IR Grenade (AAF)", "I_IR_Grenade", 150, "mag", "GUER"],
	["Chemlight (Blue)", "Chemlight_blue", 25, "mag"],
	["Chemlight (Green)", "Chemlight_green", 25, "mag"],
	["Chemlight (Yellow)", "Chemlight_yellow", 25, "mag"],
	["Chemlight (Red)", "Chemlight_red", 25, "mag"],
	["Aviator Glasses", "G_Aviator", 25, "gogg"],
	["Diving Goggles", "G_Diving", 100, "gogg"],
	["Balaclava (Black)", "G_Balaclava_blk", 100, "gogg"],
	["Balaclava (Olive)", "G_Balaclava_oli", 100, "gogg"],
	["Balaclava (Combat Goggles)", "G_Balaclava_combat", 100, "gogg"],
	["Balaclava (Low Profile Goggles)", "G_Balaclava_lowprofile", 100, "gogg"],
	["Bandanna (Aviator)", "G_Bandanna_aviator", 100, "gogg"],
	["Bandanna (Beast)", "G_Bandanna_beast", 100, "gogg"],
	["Bandanna (Black)", "G_Bandanna_blk", 100, "gogg"],
	["Bandanna (Khaki)", "G_Bandanna_khk", 100, "gogg"],
	["Bandanna (Olive)", "G_Bandanna_oli", 100, "gogg"],
	["Bandanna (Shades)", "G_Bandanna_shades", 100, "gogg"],
	["Bandanna (Sport)", "G_Bandanna_sport", 100, "gogg"],
	["Bandanna (Tan)", "G_Bandanna_tan", 100, "gogg"],
	["Combat Goggles", "G_Combat", 100, "gogg"],
	["VR Goggles", "G_Goggles_VR", 100, "gogg"],
	["Square Spectacles", "G_Squares", 100, "gogg"],
	["Square Shades", "G_Squares_Tinted", 100, "gogg"],
	["Tactical Shades", "G_Tactical_Black", 100, "gogg"],
	["Tactical Glasses", "G_Tactical_Clear", 100, "gogg"]
];

allStoreMagazines = compileFinal str (call ammoArray + call throwputArray + call genItemArray);
allRegularStoreItems = compileFinal str (call allGunStoreFirearms + call allStoreMagazines + call accessoriesArray);
allStoreGear = compileFinal str (call headArray + call uniformArray + call vestArray + call backpackArray);

genObjectsArray = compileFinal str
[
	//["Base Re-Locker", "Land_Portable_generator_F", 100000, "object"],  //Cael817, SNAFU,Used for base operations <-- Non destroyable
	["Base door (beta)", "Land_Canal_Wall_10m_F", 25000, "object"],  // LouD
	["Base door key (PIN: 0000) (beta)", "Land_InfoStand_V2_F", 10000, "object"],  // LouD
	["Base locker (PIN: 0000)", "Land_Device_assembled_F", 50000, "object"],  //Cael817, SNAFU,Used for base operations <-- Destroyable
	["Safe (PIN: 0000)", "Box_NATO_AmmoVeh_F", 50000, "ammocrate"],
	["Empty Ammo Crate", "Box_NATO_Ammo_F", 200, "ammocrate"],
	//["Metal Barrel", "Land_MetalBarrel_F", 25, "object"],
	//["Toilet Box", "Land_ToiletBox_F", 25, "object"],
	["Lamp Post (Harbour)", "Land_LampHarbour_F", 200, "object"],
	["Lamp Post (Shabby)", "Land_LampShabby_F", 200, "object"],
	["Boom Gate", "Land_BarGate_F", 300, "object"],
	["Pipes", "Land_Pipes_Large_F", 400, "object"],
	["Concrete Frame", "Land_CncShelter_F", 400, "object"],
	["Highway Guardrail", "Land_Crash_barrier_F", 400, "object"],
	["Concrete Barrier", "Land_CncBarrier_F", 400, "object"],
	["Concrete Barrier (Medium)", "Land_CncBarrierMedium_F", 700, "object"],
	["Concrete Barrier (Long)", "Land_CncBarrierMedium4_F", 1000, "object"],
	["HBarrier (1 block)", "Land_HBarrier_1_F", 300, "object"],
	["HBarrier (3 blocks)", "Land_HBarrier_3_F", 400, "object"],
	["HBarrier (5 blocks)", "Land_HBarrier_5_F", 500, "object"],
	["HBarrier Big", "Land_HBarrierBig_F", 1000, "object"],
	["HBarrier Wall (4 blocks)", "Land_HBarrierWall4_F", 800, "object"],
	["HBarrier Wall (6 blocks)", "Land_HBarrierWall6_F", 1000, "object"],
	["HBarrier Watchtower", "Land_HBarrierTower_F", 1200, "object"],
	["Concrete Wall", "Land_CncWall1_F", 800, "object"],
	["Concrete Military Wall", "Land_Mil_ConcreteWall_F", 800, "object"],
	["Concrete Wall (Long)", "Land_CncWall4_F", 1200, "object"],
	["Military Wall (Big)", "Land_Mil_WallBig_4m_F", 1200, "object"],
	//["Shoot House Wall", "Land_Shoot_House_Wall_F", 180, "object"],
	["Canal Wall (Small)", "Land_Canal_WallSmall_10m_F", 800, "object"],
	["Canal Stairs", "Land_Canal_Wall_Stairs_F", 1000, "object"],
	["Bag Fence (Corner)", "Land_BagFence_Corner_F", 300, "object"],
	["Bag Fence (End)", "Land_BagFence_End_F", 300, "object"],
	["Bag Fence (Long)", "Land_BagFence_Long_F", 400, "object"],
	["Bag Fence (Round)", "Land_BagFence_Round_F", 300, "object"],
	["Bag Fence (Short)", "Land_BagFence_Short_F", 300, "object"],
	["Bag Bunker (Small)", "Land_BagBunker_Small_F", 300, "object"],
	["Bag Bunker (Large)", "Land_BagBunker_Large_F", 1000, "object"],
	["Bag Bunker Tower", "Land_BagBunker_Tower_F", 2000, "object"],
	["Military Cargo Post", "Land_Cargo_Patrol_V1_F", 5000, "object"],
	["Military Cargo Tower", "Land_Cargo_Tower_V1_F", 7500, "object"],
	["Military Cargo HQ", "Land_Cargo_HQ_V1_F", 10000, "object"], // Added on player request
	["Concrete Ramp", "Land_RampConcrete_F", 1000, "object"],
	["Concrete Ramp (High)", "Land_RampConcreteHigh_F", 1500, "object"],
	["Concrete Block", "BlockConcrete_F", 5000, "object"],
	["Scaffolding", "Land_Scaffolding_F", 1000, "object"],
	["Food sacks", "Land_Sacks_goods_F", 5000, "object"], // Added on player request
	["Water Barrel", "Land_BarrelWater_F", 5000, "object"] // Added on player request
];

allGenStoreVanillaItems = compileFinal str (call genItemArray + call genObjectsArray + call allStoreGear);

//Text name, classname, buy cost, spawn type, sell price (selling not implemented) or spawning color
landArray = compileFinal str
[
	["Kart", "C_Kart_01_F", 2500, "vehicle"],

	["Quadbike (Civilian)", "C_Quadbike_01_F", 600, "vehicle"],
	["Quadbike (NATO)", "B_Quadbike_01_F", 650, "vehicle"],
	["Quadbike (CSAT)", "O_Quadbike_01_F", 650, "vehicle"],
	["Quadbike (AAF)", "I_Quadbike_01_F", 650, "vehicle"],
	["Quadbike (FIA)", "B_G_Quadbike_01_F", 650, "vehicle"],

	["Hatchback", "C_Hatchback_01_F", 800, "vehicle"],
	["Hatchback Sport", "C_Hatchback_01_sport_F", 1000, "vehicle"],
	["SUV", "C_SUV_01_F", 1100, "vehicle"],
	["Offroad", "C_Offroad_01_F", 1100, "vehicle"],
	["Offroad Camo", "B_G_Offroad_01_F", 1250, "vehicle"],
	["Offroad Repair", "C_Offroad_01_repair_F", 1500, "vehicle"],
	["Offroad HMG", "B_G_Offroad_01_armed_F", 2500, "vehicle"],

	["Truck", "C_Van_01_transport_F", 700, "vehicle"],
	["Truck (Camo)", "B_G_Van_01_transport_F", 800, "vehicle"],
	["Truck Box", "C_Van_01_box_F", 900, "vehicle"],
	["Fuel Truck", "C_Van_01_fuel_F", 2000, "vehicle"],
	["Fuel Truck (Camo)", "B_G_Van_01_fuel_F", 2100, "vehicle"],

	["HEMTT Tractor", "B_Truck_01_mover_F", 5000, "vehicle"],
	["HEMTT Box", "B_Truck_01_box_F", 6000, "vehicle"],
	["HEMTT Transport", "B_Truck_01_transport_F", 7000, "vehicle"],
	["HEMTT Covered", "B_Truck_01_covered_F", 8500, "vehicle"],
	["HEMTT Fuel", "B_Truck_01_fuel_F", 10000, "vehicle"],
	["HEMTT Medical", "B_Truck_01_medical_F", 11000, "vehicle"],
	["HEMTT Repair", "B_Truck_01_Repair_F", 12500, "vehicle"],
	["HEMTT Ammo", "B_Truck_01_ammo_F", 27500, "vehicle"],

	["Tempest Transport", "O_Truck_03_transport_F", 8000, "vehicle"],
	["Tempest Covered", "O_Truck_03_covered_F", 9500, "vehicle"],
	["Tempest Fuel", "O_Truck_03_fuel_F", 12000, "vehicle"],
	["Tempest Medical", "O_Truck_03_medical_F", 13000, "vehicle"],
	["Tempest Repair", "O_Truck_03_repair_F", 14500, "vehicle"],
	["Tempest Ammo", "O_Truck_03_ammo_F", 28000, "vehicle"],
	["Tempest Device", "O_Truck_03_device_F", 7000, "vehicle"],
	
	["Zamak Transport", "I_Truck_02_transport_F", 5000, "vehicle"],
	["Zamak Covered", "I_Truck_02_covered_F", 6000, "vehicle"],
	["Zamak Fuel", "I_Truck_02_fuel_F", 9000, "vehicle"],
	["Zamak Medical", "I_Truck_02_medical_F", 10000, "vehicle"],
	["Zamak Repair", "I_Truck_02_box_F", 11000, "vehicle"],
	["Zamak Ammo", "I_Truck_02_ammo_F", 25000, "vehicle"],

	["UGV Stomper (NATO)", "B_UGV_01_F", 5000, "vehicle"],
	["UGV Stomper RCWS (NATO)", "B_UGV_01_rcws_F", 50000, "vehicle"],
	["UGV Stomper (AAF)", "I_UGV_01_F", 5000, "vehicle"],
	["UGV Stomper RCWS (AAF)", "I_UGV_01_rcws_F", 50000, "vehicle"],
	["UGV Saif (CSAT)", "O_UGV_01_F", 5000, "vehicle"],
	["UGV Saif RCWS (CSAT)", "O_UGV_01_rcws_F", 50000, "vehicle"]
];

armoredArray = compileFinal str
[
	["Hunter", "B_MRAP_01_F", 5000, "vehicle"],
	["Hunter HMG", "B_MRAP_01_hmg_F", 15000, "vehicle"],
	["Hunter GMG", "B_MRAP_01_gmg_F", 17500, "vehicle"],
	["Ifrit", "O_MRAP_02_F", 5000, "vehicle"],
	["Ifrit HMG", "O_MRAP_02_hmg_F", 15000, "vehicle"],
	["Ifrit GMG", "O_MRAP_02_gmg_F", 17500, "vehicle"],
	["Strider", "I_MRAP_03_F", 5000, "vehicle"],
	["Strider HMG", "I_MRAP_03_hmg_F", 15000, "vehicle"],
	["Strider GMG", "I_MRAP_03_gmg_F", 17500, "vehicle"],
	["MSE-3 Marid", "O_APC_Wheeled_02_rcws_F", 22500, "vehicle"],
	["AMV-7 Marshall", "B_APC_Wheeled_01_cannon_F", 27500, "vehicle"],
	["AFV-4 Gorgon", "I_APC_Wheeled_03_cannon_F", 30000, "vehicle"]
];

tanksArray = compileFinal str
[
	["CRV-6e Bobcat", "B_APC_Tracked_01_CRV_F", 32500, "vehicle"],
	["IFV-6c Panther", "B_APC_Tracked_01_rcws_F", 35000, "vehicle"],
	["FV-720 Mora", "I_APC_tracked_03_cannon_F", 37500, "vehicle"],
	["BTR-K Kamysh", "O_APC_Tracked_02_cannon_F", 40000, "vehicle"],
	["IFV-6a Cheetah AA", "B_APC_Tracked_01_AA_F", 40000, "vehicle"],
	["ZSU-39 Tigris AA", "O_APC_Tracked_02_AA_F", 40000, "vehicle"],
	["M2A1 Slammer", "B_MBT_01_cannon_F", 45000, "vehicle"],
	["M2A4 Slammer HMG", "B_MBT_01_TUSK_F", 50000, "vehicle"], // Commander gun variant
	["T-100 Varsuk", "O_MBT_02_cannon_F", 55000, "vehicle"],
	["MBT-52 Kuma", "I_MBT_03_cannon_F", 60000, "vehicle"]
];


helicoptersArray = compileFinal str
[
	["M-900 Civilian", "C_Heli_Light_01_civil_F", 2500, "vehicle"], // MH-6, no flares
	["MH-9 Hummingbird", "B_Heli_Light_01_F", 4000, "vehicle"], // MH-6
	["PO-30 Orca (Black)", "O_Heli_Light_02_unarmed_F", 5000, "vehicle"], // Ka-60
	["WY-55 Hellcat (Green)", "I_Heli_light_03_unarmed_F", 6000, "vehicle"], // AW159

	["Mi-290 Taru (Crane) [DLC]", "O_Heli_Transport_04_F", 7500, "vehicle"], // CH-54
	["Mi-290 Taru (Box) [DLC]", "O_Heli_Transport_04_box_F", 8000, "vehicle"],
	["Mi-290 Taru (Fuel) [DLC]", "O_Heli_Transport_04_fuel_F", 8500, "vehicle"],
	["Mi-290 Taru (Bench) [DLC]", "O_Heli_Transport_04_bench_F", 9000, "vehicle"],
	["Mi-290 Taru (Transport) [DLC]", "O_Heli_Transport_04_covered_F", 9500, "vehicle"],
	["CH-67 Huron (Black) [DLC]", "B_Heli_Transport_03_unarmed_F", 10000, "vehicle"], // CH-47
	["CH-49 Mohawk", "I_Heli_Transport_02_F", 10000, "vehicle"], // AW101

	["Mi-290 Taru (Medical) [DLC]", "O_Heli_Transport_04_medevac_F",12500, "vehicle"],
	["Mi-290 Taru (Repair) [DLC]", "O_Heli_Transport_04_repair_F", 15000, "vehicle"],
	["Mi-290 Taru (Ammo) [DLC]", "O_Heli_Transport_04_ammo_F", 25000, "vehicle"],
	
	["UH-80 Ghost Hawk (Black)", "B_Heli_Transport_01_F", 30000, "vehicle"], // UH-60 Stealth with 2 side miniguns
	["UH-80 Ghost Hawk (Green)", "B_Heli_Transport_01_camo_F", 30000, "vehicle"], // UH-60 Stealth with 2 side miniguns (green camo)
	["CH-67 Huron (Armed) [DLC]", "B_Heli_Transport_03_F", 35000, "vehicle"], // CH-47 with 2 side miniguns
	["AH-9 Pawnee", "B_Heli_Light_01_armed_F", 20000, "vehicle"], // Armed AH-6
	["PO-30 Orca (Armed, Black)", "O_Heli_Light_02_v2_F", 35000, "vehicle"], // Armed Ka-60 with orca paintjob
	["WY-55 Hellcat (Armed)", "I_Heli_light_03_F", 45000, "vehicle"], // Armed AW159
	["PO-30 Orca (Armed, Hex)", "O_Heli_Light_02_F", 100000, "vehicle"], // Armed Ka-60
	["Mi-48 Kajman (Hex)", "O_Heli_Attack_02_F", 125000, "vehicle"], // Mi-28 with gunner
	["Mi-48 Kajman (Black)", "O_Heli_Attack_02_black_F", 125000, "vehicle"], // Mi-28 with gunner (black camo)
	["AH-99 Blackfoot", "B_Heli_Attack_01_F", 150000, "vehicle"] // RAH-66 with gunner
];

planesArray = compileFinal str
[
	["A-143 Buzzard AA", "I_Plane_Fighter_03_AA_F", 75000, "vehicle"],
	["A-143 Buzzard CAS", "I_Plane_Fighter_03_CAS_F", 125000, "vehicle"],
	["To-199 Neophron CAS", "O_Plane_CAS_02_F", 400000, "vehicle"],
	["A-164 Wipeout CAS", "B_Plane_CAS_01_F", 500000, "vehicle"],
	["MQ4A Greyhawk Missile UAV", "B_UAV_02_F", 400000, "vehicle"],
	["MQ4A Greyhawk Bomber UAV", "B_UAV_02_CAS_F", 300000, "vehicle"], // Bomber UAVs are a lot harder to use, hence why they are cheaper than ATGMs
	["K40 Ababil-3 Missile UAV (CSAT)", "O_UAV_02_F", 400000, "vehicle"],
	["K40 Ababil-3 Bomber UAV (CSAT)", "O_UAV_02_CAS_F", 300000, "vehicle"],
	["K40 Ababil-3 Missile UAV (AAF)", "I_UAV_02_F", 400000, "vehicle"],
	["K40 Ababil-3 Bomber UAV (AAF)", "I_UAV_02_CAS_F", 300000, "vehicle"]
];

boatsArray = compileFinal str
[
	["Rescue Boat", "C_Rubberboat", 500, "boat"],
	["Rescue Boat (NATO)", "B_Lifeboat", 500, "boat"],
	["Rescue Boat (CSAT)", "O_Lifeboat", 500, "boat"],
	["Assault Boat (NATO)", "B_Boat_Transport_01_F", 600, "boat"],
	["Assault Boat (CSAT)", "O_Boat_Transport_01_F", 600, "boat"],
	["Assault Boat (AAF)", "I_Boat_Transport_01_F", 600, "boat"],
	["Assault Boat (FIA)", "B_G_Boat_Transport_01_F", 600, "boat"],
	["Motorboat", "C_Boat_Civil_01_F", 1000, "boat"],
	["Motorboat Rescue", "C_Boat_Civil_01_rescue_F", 900, "boat"],
	["Motorboat Police", "C_Boat_Civil_01_police_F", 1250, "boat"],
	["Speedboat HMG (CSAT)", "O_Boat_Armed_01_hmg_F", 4000, "boat"],
	["Speedboat Minigun (NATO)", "B_Boat_Armed_01_minigun_F", 4000, "boat"],
	["Speedboat Minigun (AAF)", "I_Boat_Armed_01_minigun_F", 4000, "boat"],
	["SDV Submarine (NATO)", "B_SDV_01_F", 1000, "submarine"],
	["SDV Submarine (CSAT)", "O_SDV_01_F", 1000, "submarine"],
	["SDV Submarine (AAF)", "I_SDV_01_F", 1000, "submarine"]
];

allVehStoreVehicles = compileFinal str (call landArray + call armoredArray + call tanksArray + call helicoptersArray + call planesArray + call boatsArray);

uavArray = compileFinal str
[
	"UAV_02_base_F",
	"UGV_01_base_F"
];

noColorVehicles = compileFinal str
[
	// Deprecated
];

rgbOnlyVehicles = compileFinal str
[
	// Deprecated
];

_color = "#(rgb,1,1,1)color";
_texDir = "client\images\vehicleTextures\";
_kartDir = "\A3\soft_f_kart\Kart_01\Data\";
_mh9Dir = "\A3\air_f\Heli_Light_01\Data\";
_mohawkDir = "\A3\air_f_beta\Heli_Transport_02\Data\";
_taruDir = "\A3\air_f_heli\Heli_Transport_04\Data\";

colorsArray = compileFinal str
[
	[ // Main colors
		"All",
		[
			["Black", _color + "(0.01,0.01,0.01,1)"], // #(argb,8,8,3)color(0.1,0.1,0.1,0.1)
			["Gray", _color + "(0.15,0.151,0.152,1)"], // #(argb,8,8,3)color(0.5,0.51,0.512,0.3)
			["White", _color + "(0.75,0.75,0.75,1)"], // #(argb,8,8,3)color(1,1,1,0.5)
			["Dark Blue", _color + "(0,0.05,0.15,1)"], // #(argb,8,8,3)color(0,0.3,0.6,0.05)
			["Blue", _color + "(0,0.03,0.5,1)"], // #(argb,8,8,3)color(0,0.2,1,0.75)
			["Teal", _color + "(0,0.3,0.3,1)"], // #(argb,8,8,3)color(0,1,1,0.15)
			["Green", _color + "(0,0.5,0,1)"], // #(argb,8,8,3)color(0,1,0,0.15)
			["Yellow", _color + "(0.5,0.4,0,1)"], // #(argb,8,8,3)color(1,0.8,0,0.4)
			["Orange", _color + "(0.4,0.09,0,1)"], // #(argb,8,8,3)color(1,0.5,0,0.4)
			["Red", _color + "(0.45,0.005,0,1)"], // #(argb,8,8,3)color(1,0.1,0,0.3)
			["Pink", _color + "(0.5,0.03,0.3,1)"], // #(argb,8,8,3)color(1,0.06,0.6,0.5)
			["Purple", _color + "(0.1,0,0.3,1)"], // #(argb,8,8,3)color(0.8,0,1,0.1)
			["NATO Tan", _texDir + "nato.paa"], // #(argb,8,8,3)color(0.584,0.565,0.515,0.3)
			["CSAT Brown", _texDir + "csat.paa"], // #(argb,8,8,3)color(0.624,0.512,0.368,0.3)
			["AAF Green", _texDir + "aaf.paa"], // #(argb,8,8,3)color(0.546,0.59,0.363,0.2)
			["Bloodshot", _texDir + "bloodshot.paa"],
			["Carbon", _texDir + "carbon.paa"],
			["Digital", _texDir + "digi.paa"],
			["Digital Black", _texDir + "digi_black.paa"],
			["Digital Desert", _texDir + "digi_desert.paa"],
			["Digital Woodland", _texDir + "digi_wood.paa"],
			["Hippie", _texDir + "hippie.paa"],
			["Orange Camo", _texDir + "camo_orange.paa"],
			["Pink Camo", _texDir + "camo_pink.paa"],
			["Psych", _texDir + "psych.paa"],
			["Red Camo", _texDir + "camo_red.paa"],
			["Rusty", _texDir + "rusty.paa"],
			["Trippy", _texDir + "rainbow.paa"],
			["Urban", _texDir + "urban.paa"],
			["Weed", _texDir + "weed.paa"],
			["Woodland", _texDir + "woodland.paa"],
			["Woodland Dark", _texDir + "wooddark.paa"],
			["Woodland Tiger", _texDir + "woodtiger.paa"]
		]
	],
	[ // Kart colors
		"Kart_01_Base_F",
		[
			["Black (Kart)", [[0, _kartDir + "kart_01_base_black_co.paa"]]],
			["White (Kart)", [[0, _kartDir + "kart_01_base_white_co.paa"]]],
			["Blue (Kart)", [[0, _kartDir + "kart_01_base_blue_co.paa"]]],
			["Green (Kart)", [[0, _kartDir + "kart_01_base_green_co.paa"]]],
			["Yellow (Kart)", [[0, _kartDir + "kart_01_base_yellow_co.paa"]]],
			["Orange (Kart)", [[0, _kartDir + "kart_01_base_orange_co.paa"]]],
			["Red (Kart)", [[0, _kartDir + "kart_01_base_red_co.paa"]]]
		]
	],
	[ // MH-9 colors
		"Heli_Light_01_base_F",
		[
			["AAF Camo (MH-9)", [[0, _mh9Dir + "heli_light_01_ext_indp_co.paa"]]],
			["Blue 'n White (MH-9)", [[0, _mh9Dir + "heli_light_01_ext_blue_co.paa"]]],
			["Blueline (MH-9)", [[0, _mh9Dir + "Skins\heli_light_01_ext_blueline_co.paa"]]],
			["Cream Gravy (MH-9)", [[0, _mh9Dir + "heli_light_01_ext_co.paa"]]],
			["Digital (MH-9)", [[0, _mh9Dir + "Skins\heli_light_01_ext_digital_co.paa"]]],
			["Elliptical (MH-9)", [[0, _mh9Dir + "Skins\heli_light_01_ext_elliptical_co.paa"]]],
			["Furious (MH-9)", [[0, _mh9Dir + "Skins\heli_light_01_ext_furious_co.paa"]]],
			["Graywatcher (MH-9)", [[0, _mh9Dir + "Skins\heli_light_01_ext_graywatcher_co.paa"]]],
			["ION (MH-9)", [[0, _mh9Dir + "heli_light_01_ext_ion_co.paa"]]],
			["Jeans (MH-9)", [[0, _mh9Dir + "Skins\heli_light_01_ext_jeans_co.paa"]]],
			["Light (MH-9)", [[0, _mh9Dir + "Skins\heli_light_01_ext_light_co.paa"]]],
			["Shadow (MH-9)", [[0, _mh9Dir + "Skins\heli_light_01_ext_shadow_co.paa"]]],
			["Sheriff (MH-9)", [[0, _mh9Dir + "Skins\heli_light_01_ext_sheriff_co.paa"]]],
			["Speedy (MH-9)", [[0, _mh9Dir + "Skins\heli_light_01_ext_speedy_co.paa"]]],
			["Sunset (MH-9)", [[0, _mh9Dir + "Skins\heli_light_01_ext_sunset_co.paa"]]],
			["Vrana (MH-9)", [[0, _mh9Dir + "Skins\heli_light_01_ext_vrana_co.paa"]]],
			["Wasp (MH-9)", [[0, _mh9Dir + "Skins\heli_light_01_ext_wasp_co.paa"]]],
			["Wave (MH-9)", [[0, _mh9Dir + "Skins\heli_light_01_ext_wave_co.paa"]]]
		]
	],
	[ // Mohawk colors
		"Heli_Transport_02_base_F",
		[
			["Dahoman (Mohawk)", [
				[0, _mohawkDir + "Skins\heli_transport_02_1_dahoman_co.paa"],
				[1, _mohawkDir + "Skins\heli_transport_02_2_dahoman_co.paa"],
				[2, _mohawkDir + "Skins\heli_transport_02_3_dahoman_co.paa"]
			]],
			["ION (Mohawk)", [
				[0, _mohawkDir + "Skins\heli_transport_02_1_ion_co.paa"],
				[1, _mohawkDir + "Skins\heli_transport_02_2_ion_co.paa"],
				[2, _mohawkDir + "Skins\heli_transport_02_3_ion_co.paa"]
			]]
		]
	],
	[ // Taru base colors
		"Heli_Transport_04_base_F",
		[
			["Black (Taru)", [
				[0, _taruDir + "heli_transport_04_base_01_black_co.paa"],
				[1, _taruDir + "heli_transport_04_base_02_black_co.paa"],
				[2, _taruDir + "heli_transport_04_pod_ext01_black_co.paa"],
				[3, _taruDir + "heli_transport_04_pod_ext02_black_co.paa"]
			]]
		]
	],
	[ // Taru bench colors
		"O_Heli_Transport_04_bench_F",
		[
			["Black (Taru)", [[2, _taruDir + "heli_transport_04_bench_black_co.paa"]]]
		]
	],
	[ // Taru fuel colors
		"O_Heli_Transport_04_fuel_F",
		[
			["Black (Taru)", [[2, _taruDir + "heli_transport_04_fuel_black_co.paa"]]]
		]
	]
];

//General Store Item List
//Display Name, Class Name, Description, Picture, Buy Price, Sell Price.
// ["Medical Kit", "medkits", localize "STR_WL_ShopDescriptions_MedKit", "client\icons\medkit.paa", 400, 200],  // not needed since there are First Ait Kits
customPlayerItems = compileFinal str
[
	["Water Bottle", "water", localize "STR_WL_ShopDescriptions_Water", "client\icons\waterbottle.paa", 30, 15],
	["Canned Food", "cannedfood", localize "STR_WL_ShopDescriptions_CanFood", "client\icons\cannedfood.paa", 30, 15],

	["LSD", "lsd", localize "STR_WL_ShopDescriptions_LSD", "client\icons\lsd.paa", 12500, 6250],
	["Marijuana", "marijuana", localize "STR_WL_ShopDescriptions_Marijuana", "client\icons\marijuana.paa", 10000, 5000],
	["Cocaine", "cocaine", localize "STR_WL_ShopDescriptions_Cocaine", "client\icons\cocaine.paa", 14000, 7000],
	["Heroin", "heroin", localize "STR_WL_ShopDescriptions_Heroin", "client\icons\heroin.paa", 15000, 7500],

	["Vehicle Pinlock", "pinlock", localize "STR_WL_ShopDescriptions_Pinlock", "client\icons\keypad.paa", 1000, 500],
	["Repair Kit", "repairkit", localize "STR_WL_ShopDescriptions_RepairKit", "client\icons\briefcase.paa", 750, 375],
	["Jerry Can (Full)", "jerrycanfull", localize "STR_WL_ShopDescriptions_fuelFull", "client\icons\jerrycan.paa", 150, 75],
	["Jerry Can (Empty)", "jerrycanempty", localize "STR_WL_ShopDescriptions_fuelEmpty", "client\icons\jerrycan.paa", 50, 25],
	["Spawn Beacon", "spawnbeacon", localize "STR_WL_ShopDescriptions_spawnBeacon", "client\icons\spawnbeacon.paa", 5000, 2500],
	["Camo Net", "camonet", localize "STR_WL_ShopDescriptions_Camo", "client\icons\camonet.paa", 600, 300],
	["Syphon Hose", "syphonhose", localize "STR_WL_ShopDescriptions_SyphonHose", "client\icons\syphonhose.paa", 200, 100],
	["Energy Drink", "energydrink", localize "STR_WL_ShopDescriptions_Energy_Drink", "client\icons\energydrink.paa", 100, 50],
	["Warchest", "warchest", localize "STR_WL_ShopDescriptions_Warchest", "client\icons\warchest.paa", 1000, 500],

	["IP/Net Camera", "cctv_camera", localize "STR_WL_ShopDescriptions_CCTV_Camera", "addons\cctv\icons\camcorder.paa", 850, 500],
	["Camera Terminal", "cctv_base", localize "STR_WL_ShopDescriptions_CCTV_Base", "addons\cctv\icons\laptop.paa", 500, 300]
];

call compile preprocessFileLineNumbers "mapConfig\storeOwners.sqf";

storeConfigDone = compileFinal "true";
