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
	["PM Pistol", "hgun_Pistol_01_F", 25],
	["P07 Pistol", "hgun_P07_F", 50],
	["P07 Pistol (Khaki)", "hgun_P07_khk_F", 50],
	["Rook-40 Pistol", "hgun_Rook40_F", 50],
	["ACP-C2 Pistol", "hgun_ACPC2_F", 75],
	["Zubr Revolver", "hgun_Pistol_heavy_02_F", 75],
	["4-Five Pistol", "hgun_Pistol_heavy_01_F", 100]
];

smgArray = compileFinal str
[
	["PDW2000 SMG", "hgun_PDW2000_F", 100],
	["Protector SMG", "SMG_05_F", 100],
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
	["MX Carbine (Black)", "arifle_MXC_Black_F", 150],
	["MX Carbine (Khaki)", "arifle_MXC_khk_F", 150, "noDLC"],
	["MX Rifle", "arifle_MX_F", 200],
	["MX Rifle (Black)", "arifle_MX_Black_F", 200],
	["MX Rifle (Khaki)", "arifle_MX_khk_F", 200, "noDLC"],
	["MX 3GL Rifle", "arifle_MX_GL_F", 250],
	["MX 3GL Rifle (Black)", "arifle_MX_GL_Black_F", 250],
	["MX 3GL Rifle (Khaki)", "arifle_MX_GL_khk_F", 250, "noDLC"],

	["SPAR-16 Rifle", "arifle_SPAR_01_blk_F", 200],
	["SPAR-16 Rifle (Khaki)", "arifle_SPAR_01_khk_F", 200],
	["SPAR-16 Rifle (Sand)", "arifle_SPAR_01_snd_F", 200],
	["SPAR-16 GL Rifle", "arifle_SPAR_01_GL_blk_F", 250],
	["SPAR-16 GL Rifle (Khaki)", "arifle_SPAR_01_GL_khk_F", 250],
	["SPAR-16 GL Rifle (Sand)", "arifle_SPAR_01_GL_snd_F", 250],

	["CAR-95 Rifle", "arifle_CTAR_blk_F", 200],
	["CAR-95 Rifle (Hex)", "arifle_CTAR_hex_F", 200],
	["CAR-95 Rifle (G Hex)", "arifle_CTAR_ghex_F", 200],
	["CAR-95 GL Rifle", "arifle_CTAR_GL_blk_F", 250],
	["CAR-95 GL Rifle (Hex)", "arifle_CTAR_GL_hex_F", 250],
	["CAR-95 GL Rifle (G Hex)", "arifle_CTAR_GL_ghex_F", 250],
	["Type 115 Rifle", "arifle_ARX_blk_F", 300],
	["Type 115 Rifle (Hex)", "arifle_ARX_hex_F", 300],
	["Type 115 Rifle (G Hex)", "arifle_ARX_ghex_F", 300],

	["AKS-74U Carbine", "arifle_AKS_F", 150],
	["AKM Rifle", "arifle_AKM_F", 200],
	["AK-12 Rifle", "arifle_AK12_F", 250],
	["AK-12 GL Rifle", "arifle_AK12_GL_F", 300],

	// Marksman Rifles
	["MXM Rifle", "arifle_MXM_F", 300],
	["MXM Rifle (Black)", "arifle_MXM_Black_F", 300],
	["MXM Rifle (Khaki)", "arifle_MXM_khk_F", 300, "noDLC"],
	["Rahim DMR Rifle", "srifle_DMR_01_F", 375],
	["Mk18 ABR Rifle", "srifle_EBR_F", 450],

	// DLC
	["CMR-76 Rifle", "srifle_DMR_07_blk_F", 400],
	["CMR-76 Rifle (Hex)", "srifle_DMR_07_hex_F", 400],
	["CMR-76 Rifle (G Hex)", "srifle_DMR_07_ghex_F", 400],
	["SPAR-17 Rifle", "arifle_SPAR_03_blk_F", 450],
	["SPAR-17 Rifle (Khaki)", "arifle_SPAR_03_khk_F", 450],
	["SPAR-17 Rifle (Sand)", "arifle_SPAR_03_snd_F", 450],

	["Mk14 Rifle (Camo)", "srifle_DMR_06_camo_F", 500],
	["Mk14 Rifle (Olive)", "srifle_DMR_06_olive_F", 500],
	["Mk-I EMR Rifle", "srifle_DMR_03_F", 500],
	["Mk-I EMR Rifle (Camo)", "srifle_DMR_03_multicam_F", 500],
	["Mk-I EMR Rifle (Khaki)", "srifle_DMR_03_khaki_F", 500],
	["Mk-I EMR Rifle (Sand)", "srifle_DMR_03_tan_F", 500],
	["Mk-I EMR Rifle (Woodland)", "srifle_DMR_03_woodland_F", 500],
	["MAR-10 Rifle", "srifle_DMR_02_F", 750],
	["MAR-10 Rifle (Camo)", "srifle_DMR_02_camo_F", 750],
	["MAR-10 Rifle (Sand)", "srifle_DMR_02_sniper_F", 750],
	["Cyrus Rifle", "srifle_DMR_05_blk_F", 750],
	["Cyrus Rifle (Hex)", "srifle_DMR_05_hex_F", 750],
	["Cyrus Rifle (Tan)", "srifle_DMR_05_tan_f", 750],

	// Sniper Rifles
	["M320 LRR Sniper", "srifle_LRR_LRPS_F", 1000],
	["M320 LRR Sniper (Camo)", "srifle_LRR_camo_LRPS_F", 1200],
	["M320 LRR Sniper (Tropic)", "srifle_LRR_tna_LRPS_F", 1200],
	["GM6 Lynx Sniper", "srifle_GM6_LRPS_F", 1250],
	["GM6 Lynx Sniper (Camo)", "srifle_GM6_camo_LRPS_F", 1500],
	["GM6 Lynx Sniper (G Hex)", "srifle_GM6_ghex_LRPS_F", 1500],

	["ASP-1 Kir Rifle", "srifle_DMR_04_F", 2000],
	["ASP-1 Kir Rifle (Tan)", "srifle_DMR_04_tan_F", 2000]
];

lmgArray = compileFinal str
[
	["MX SW LMG", "arifle_MX_SW_F", 300],
	["MX SW LMG (Black)", "arifle_MX_SW_Black_F", 325],
	["MX SW LMG (Khaki)", "arifle_MX_SW_khk_F", 325, "noDLC"],
	["Mk200 LMG", "LMG_Mk200_F", 400],
	["Zafir LMG", "LMG_Zafir_F", 500],

	["SPAR-16S LMG", "arifle_SPAR_02_blk_F", 300],
	["SPAR-16S LMG (Khaki)", "arifle_SPAR_02_khk_F", 300],
	["SPAR-16S LMG (Sand)", "arifle_SPAR_02_snd_F", 300],
	["CAR-95-1 LMG", "arifle_CTARS_blk_F", 300],
	["CAR-95-1 LMG (Hex)", "arifle_CTARS_hex_F", 300],
	["CAR-95-1 LMG (G Hex)", "arifle_CTARS_ghex_F", 300],
	["LIM-85 LMG", "LMG_03_F", 350],

	["SPMG MMG (Sand)", "MMG_02_sand_F", 750],
	["SPMG MMG (MTP)", "MMG_02_camo_F", 750],
	["SPMG MMG (Black)", "MMG_02_black_F", 750],
	["Navid MMG (Tan)", "MMG_01_tan_F", 1000],
	["Navid MMG (Hex)", "MMG_01_hex_F", 1000]
];

launcherArray = compileFinal str
[
	["RPG-7", "launch_RPG7_F", 350],
	["RPG-42 Alamut", "launch_RPG32_F", 400],
	["RPG-42 Alamut (G Hex)", "launch_RPG32_ghex_F", 400, "noDLC"],
	["PCML", "launch_NLAW_F", 600],
	["Titan MPRL Compact (Sand)", "launch_Titan_short_F", 500],
	["Titan MPRL Compact (Coyote)", "launch_O_Titan_short_F", 500],
	["Titan MPRL Compact (Olive)", "launch_I_Titan_short_F", 500],
	["Titan MPRL Compact (Tropic)", "launch_B_Titan_short_tna_F", 500, "noDLC"],
	["Titan MPRL Compact (G Hex)", "launch_O_Titan_short_ghex_F", 500, "noDLC"],
	["Titan MPRL AA (Sand)", "launch_Titan_F", 600],
	["Titan MPRL AA (Hex)", "launch_O_Titan_F", 600],
	["Titan MPRL AA (Digi)", "launch_I_Titan_F", 600],
	["Titan MPRL AA (Tropic)", "launch_B_Titan_tna_F", 600, "noDLC"],
	["Titan MPRL AA (G Hex)", "launch_O_Titan_ghex_F", 600, "noDLC"]
];

allGunStoreFirearms = compileFinal str (call pistolArray + call smgArray + call rifleArray + call lmgArray + call launcherArray);

staticGunsArray = compileFinal str
[
	// ["Vehicle Ammo Crate", "Box_NATO_AmmoVeh_F", 2500],
	["Static Titan AT 4Rnd", "B_static_AT_F", 2500], // Static launchers only have 4 ammo, hence the low price
	["Static Titan AT 4Rnd", "O_static_AT_F", 2500],
	["Static Titan AT 4Rnd", "I_static_AT_F", 2500],
	["Static Titan AA 4Rnd", "B_static_AA_F", 3000],
	["Static Titan AA 4Rnd", "O_static_AA_F", 3000],
	["Static Titan AA 4Rnd", "I_static_AA_F", 3000],
	["Mk30 HMG .50 Low tripod", "B_HMG_01_F", 2000],
	["Mk30 HMG .50 Low tripod", "O_HMG_01_F", 2000],
	["Mk30 HMG .50 Low tripod", "I_HMG_01_F", 2000],
	// ["Mk30A HMG .50 Sentry", "B_HMG_01_A_F", 5000], // "A" = Autonomous = Overpowered
	// ["Mk30A HMG .50 Sentry", "O_HMG_01_A_F", 5000],
	// ["Mk30A HMG .50 Sentry", "I_HMG_01_A_F", 5000],
	["Mk30 HMG .50 High tripod", "B_HMG_01_high_F", 3000],
	["Mk30 HMG .50 High tripod", "O_HMG_01_high_F", 3000],
	["Mk30 HMG .50 High tripod", "I_HMG_01_high_F", 3000],
	["Mk32 GMG 20mm Low tripod", "B_GMG_01_F", 5000],
	["Mk32 GMG 20mm Low tripod", "O_GMG_01_F", 5000],
	["Mk32 GMG 20mm Low tripod", "I_GMG_01_F", 5000],
	// ["Mk32A GMG 20mm Sentry", "B_GMG_01_A_F", 10000],
	// ["Mk32A GMG 20mm Sentry", "O_GMG_01_A_F", 10000],
	// ["Mk32A GMG 20mm Sentry", "I_GMG_01_A_F", 10000],
	["Mk32 GMG 20mm High tripod", "B_GMG_01_high_F", 6000],
	["Mk32 GMG 20mm High tripod", "O_GMG_01_high_F", 6000],
	["Mk32 GMG 20mm High tripod", "I_GMG_01_high_F", 6000],
	["Mk6 Mortar", "B_Mortar_01_F", 12500],
	["Mk6 Mortar", "O_Mortar_01_F", 12500],
	["Mk6 Mortar", "I_Mortar_01_F", 12500]
];

throwputArray = compileFinal str
[
	["RGN Mini Grenade", "MiniGrenade", 50],
	["RGO Frag Grenade", "HandGrenade", 100],
	["APERS Tripwire Mine", "APERSTripMine_Wire_Mag", 200],
	["APERS Bounding Mine", "APERSBoundingMine_Range_Mag", 250],
	["APERS Mine", "APERSMine_Range_Mag", 300],
	["Claymore Charge", "ClaymoreDirectionalMine_Remote_Mag", 350],
	["M6 SLAM Mine", "SLAMDirectionalMine_Wire_Mag", 350],
	["AT Mine", "ATMine_Range_Mag", 400],
	["Explosive Charge", "DemoCharge_Remote_Mag", 450],
	["Explosive Satchel", "SatchelCharge_Remote_Mag", 500],
	["Smoke Grenade (White)", "SmokeShell", 50],
	["Smoke Grenade (Purple)", "SmokeShellPurple", 50],
	["Smoke Grenade (Blue)", "SmokeShellBlue", 50],
	["Smoke Grenade (Green)", "SmokeShellGreen", 50],
	["Smoke Grenade (Yellow)", "SmokeShellYellow", 50],
	["Smoke Grenade (Orange)", "SmokeShellOrange", 50],
	["Smoke Grenade (Red)", "SmokeShellRed", 50]
];

//Gun Store Ammo List
//Text name, classname, buy cost
ammoArray = compileFinal str
[
	["9mm 10Rnd Mag", "10Rnd_9x21_Mag", 5],
	["9mm 16Rnd Mag", "16Rnd_9x21_Mag", 10],
	["9mm 30Rnd Mag", "30Rnd_9x21_Mag", 15],
	["9mm 30Rnd SMG Mag", "30Rnd_9x21_Mag_SMG_02", 15],
	[".45 ACP 6Rnd Cylinder", "6Rnd_45ACP_Cylinder", 5],
	[".45 ACP 9Rnd Mag", "9Rnd_45ACP_Mag", 10],
	[".45 ACP 11Rnd Mag", "11Rnd_45ACP_Mag", 15],
	[".45 ACP 30Rnd Vermin Mag", "30Rnd_45ACP_MAG_SMG_01", 20],
	[".45 ACP 30Rnd Tracer (Green) Mag", "30Rnd_45ACP_Mag_SMG_01_tracer_green", 15],
	["5.45mm 30Rnd Mag", "30Rnd_545x39_Mag_F", 20],
	["5.45mm 30Rnd Tracer (Yellow) Mag", "30Rnd_545x39_Mag_Tracer_F", 15],
	["5.45mm 30Rnd Tracer (Green) Mag", "30Rnd_545x39_Mag_Tracer_Green_F", 15],
	["5.56mm 20Rnd Underwater Mag", "20Rnd_556x45_UW_mag", 10],
	["5.56mm 30Rnd STANAG Mag", "30Rnd_556x45_Stanag", 20],
	["5.56mm 30Rnd Tracer (Green) Mag", "30Rnd_556x45_Stanag_Tracer_Green", 15],
	["5.56mm 30Rnd Tracer (Yellow) Mag", "30Rnd_556x45_Stanag_Tracer_Yellow", 15],
	["5.56mm 30Rnd Tracer (Red) Mag", "30Rnd_556x45_Stanag_Tracer_Red", 15],
	["5.56mm 150Rnd Mag", "150Rnd_556x45_Drum_Mag_F", 100],
	["5.56mm 150Rnd Tracer (Red) Mag", "150Rnd_556x45_Drum_Mag_Tracer_F", 75],
	["5.56mm 200Rnd Box", "200Rnd_556x45_Box_F", 125],
	["5.56mm 200Rnd Tracer (Yellow) Box", "200Rnd_556x45_Box_Tracer_F", 100],
	["5.56mm 200Rnd Tracer (Red) Box", "200Rnd_556x45_Box_Tracer_Red_F", 100],
	["5.8mm 30Rnd Mag", "30Rnd_580x42_Mag_F", 20],
	["5.8mm 30Rnd Tracer (Green) Mag", "30Rnd_580x42_Mag_Tracer_F", 15],
	["5.8mm 100Rnd Mag", "100Rnd_580x42_Mag_F", 100],
	["5.8mm 100Rnd Tracer (Green) Mag", "100Rnd_580x42_Mag_Tracer_F", 75],
	["6.5mm 20Rnd Mag", "20Rnd_650x39_Cased_Mag_F", 15],
	["6.5mm 30Rnd STANAG Mag", "30Rnd_65x39_caseless_mag", 20],
	["6.5mm 30Rnd Tracer (Red) Mag", "30Rnd_65x39_caseless_mag_Tracer", 15],
	["6.5mm 30Rnd Caseless Mag", "30Rnd_65x39_caseless_green", 20],
	["6.5mm 30Rnd Tracer (Green) Mag", "30Rnd_65x39_caseless_green_mag_Tracer", 15],
	["6.5mm 100Rnd Belt Case", "100Rnd_65x39_caseless_mag", 75],
	["6.5mm 100Rnd Tracer (Red) Belt Case", "100Rnd_65x39_caseless_mag_Tracer", 50],
	["6.5mm 200Rnd Belt Case", "200Rnd_65x39_cased_Box", 150],
	["6.5mm 200Rnd Tracer (Yellow) Belt Case", "200Rnd_65x39_cased_Box_Tracer", 125],
	//["7.62mm 10Rnd Mag", "10Rnd_762x51_Mag", 15],
	["7.62mm 10Rnd Mag", "10Rnd_762x54_Mag", 15],
	["7.62mm 20Rnd Mag", "20Rnd_762x51_Mag", 25],
	["7.62mm 30Rnd Mag", "30Rnd_762x39_Mag_F", 20],
	["7.62mm 30Rnd Tracer (Yellow) Mag", "30Rnd_762x39_Mag_Tracer_F", 15],
	["7.62mm 30Rnd Tracer (Green) Mag", "30Rnd_762x39_Mag_Tracer_Green_F", 15],
	//["7.62mm 150Rnd Box", "150Rnd_762x51_Box", 150],
	//["7.62mm 150Rnd Tracer (Green) Box", "150Rnd_762x51_Box_Tracer", 125],
	["7.62mm 150Rnd Box", "150Rnd_762x54_Box", 150],
	["7.62mm 150Rnd Tracer (Green) Box", "150Rnd_762x54_Box_Tracer", 125],
	[".338 LM 10Rnd Mag", "10Rnd_338_Mag", 50],
	[".338 NM 130Rnd Belt", "130Rnd_338_Mag", 150],
	["9.3mm 10Rnd Mag", "10Rnd_93x64_DMR_05_Mag", 50],
	["9.3mm 150Rnd Belt", "150Rnd_93x64_Mag", 150],
	[".408 7Rnd Cheetah Mag", "7Rnd_408_Mag", 50],
	["12.7mm 5Rnd Mag", "5Rnd_127x108_Mag", 50],
	["12.7mm 5Rnd Armor-Piercing Mag", "5Rnd_127x108_APDS_Mag", 60],
	["12.7mm 10Rnd Subsonic Mag", "10Rnd_127x54_Mag", 75],
	[".50 BW 10Rnd Mag", "10Rnd_50BW_Mag_F", 50],
	["PG-7VM HEAT Grenade", "RPG7_F", 200],                   // Direct damage: medium    | Splash damage: low    | Guidance: none
	["RPG-42 Anti-Tank Rocket", "RPG32_F", 250],              // Direct damage: high      | Splash damage: low    | Guidance: none
	["RPG-42 High-Explosive Rocket", "RPG32_HE_F", 250],      // Direct damage: medium    | Splash damage: medium | Guidance: none
	["PCML Anti-Tank Missile", "NLAW_F", 400],                // Direct damage: very high | Splash damage: low    | Guidance: laser, ground vehicles
	["Titan Anti-Tank Missile", "Titan_AT", 350],             // Direct damage: high      | Splash damage: low    | Guidance: mouse, laser, ground vehicles
	["Titan Anti-Personnel Missile", "Titan_AP", 350],        // Direct damage: low       | Splash damage: high   | Guidance: mouse, laser
	["Titan Anti-Air Missile", "Titan_AA", 350],              // Direct damage: low       | Splash damage: medium | Guidance: aircraft
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
	["Suppressor 9mm", "muzzle_snds_L", 50, "item"],
	["Suppressor .45 ACP", "muzzle_snds_acp", 75, "item"],
	["Suppressor 5.56mm", "muzzle_snds_M", 100, "item"],
	["Suppressor 5.56mm (Khaki)", "muzzle_snds_m_khk_F", 100, "item"],
	["Suppressor 5.56mm (Sand)", "muzzle_snds_m_snd_F", 100, "item"],
	["Suppressor 5.8mm", "muzzle_snds_58_blk_F", 100, "item"],
	["Suppressor 5.8mm (G Hex)", "muzzle_snds_58_wdm_F", 100, "item"],
	["Suppressor 6.5mm", "muzzle_snds_H", 100, "item"],
	["Suppressor 6.5mm (Khaki)", "muzzle_snds_H_khk_F", 100, "item"],
	["Suppressor 6.5mm (Sand)", "muzzle_snds_H_snd_F", 100, "item"],
	["Suppressor 6.5mm LMG", "muzzle_snds_H_MG", 125, "item"],
	["Suppressor 6.5mm LMG (Black)", "muzzle_snds_H_MG_blk_F", 125, "item"],
	["Suppressor 6.5mm LMG (Khaki)", "muzzle_snds_H_MG_khk_F", 125, "item"],
	["Suppressor Type 115", "muzzle_snds_65_TI_blk_F", 125, "item"],
	["Suppressor Type 115 (Hex)", "muzzle_snds_65_TI_hex_F", 125, "item"],
	["Suppressor Type 115 (G Hex)", "muzzle_snds_65_TI_ghex_F", 125, "item"],
	["Suppressor 7.62mm", "muzzle_snds_B", 125, "item"],
	["Suppressor 7.62mm (Khaki)", "muzzle_snds_B_khk_F", 125, "item"],
	["Suppressor 7.62mm (Sand)", "muzzle_snds_B_snd_F", 125, "item"],
	["Suppressor .338", "muzzle_snds_338_black", 150, "item"],
	["Suppressor .338 (Green)", "muzzle_snds_338_green", 150, "item"],
	["Suppressor .338 (Sand)", "muzzle_snds_338_sand", 175, "item"],
	["Suppressor 9.3mm", "muzzle_snds_93mmg", 175, "item"],
	["Suppressor 9.3mm (Tan)", "muzzle_snds_93mmg_tan", 175, "item"],
	["Bipod (NATO)", "bipod_01_F_blk", 100, "item", "noDLC"],
	["Bipod (CSAT)", "bipod_02_F_blk", 100, "item", "noDLC"],
	["Bipod (AAF)", "bipod_03_F_blk", 100, "item", "noDLC"],
	["Bipod (MTP)", "bipod_01_F_mtp", 100, "item", "noDLC"],
	["Bipod (Hex)", "bipod_02_F_hex", 100, "item", "noDLC"],
	["Bipod (Olive)", "bipod_03_F_oli", 100, "item", "noDLC"],
	["Bipod (Sand)", "bipod_01_F_snd", 100, "item", "noDLC"],
	["Bipod (Tan)", "bipod_02_F_tan", 100, "item", "noDLC"],
	["Bipod (Khaki)", "bipod_01_F_khk", 100, "item"],
	["Flashlight", "acc_flashlight", 25, "item"],
	["Pistol Flashlight" ,"acc_flashlight_pistol", 25, "item"],
	["IR Laser Pointer", "acc_pointer_IR", 25, "item"],
	["Yorris Sight (Zubr Revolver)", "optic_Yorris", 50, "item"],
	["MRD Sight (4-Five Pistol)", "optic_MRD", 50, "item"],
	["ACO SMG (Red)", "optic_aco_smg", 50, "item"],
	["ACO SMG (Green)", "optic_ACO_grn_smg", 50, "item"],
	["ACO (Red)", "optic_Aco", 75, "item"],
	["ACO (Green)", "optic_Aco_grn", 75, "item"],
	["Holosight SMG", "optic_Holosight_smg", 50, "item"],
	["Holosight", "optic_Holosight", 75, "item"],
	["MRCO", "optic_MRCO", 100, "item"],
	["ERCO", "optic_ERCO_blk_F", 100, "item"],
	["ERCO (Khaki)", "optic_ERCO_khk_F", 100, "item"],
	["ERCO (Sand)", "optic_ERCO_snd_F", 100, "item"],
	["ARCO", "optic_Arco", 125, "item"],
	["ARCO (Black)", "optic_Arco_blk_F", 125, "item"],
	["ARCO (G Hex)", "optic_Arco_ghex_F", 125, "item"],
	["RCO", "optic_Hamr", 150, "item"],
	["RCO (Khaki)", "optic_Hamr_khk_F", 150, "item"],
	["MOS", "optic_SOS", 150, "item"],
	["MOS (Khaki)", "optic_SOS_khk_F", 150, "item"],
	["DMS", "optic_DMS", 175, "item"],
	["DMS (G Hex)", "optic_DMS_ghex_F", 175, "item"],
	["Kahlia (Sightless)", "optic_KHS_old", 200, "item"],
	["Kahlia", "optic_KHS_blk", 225, "item"],
	["Kahlia (Hex)", "optic_KHS_hex", 225, "item"],
	["Kahlia (Tan)", "optic_KHS_tan", 225, "item"],
	["AMS", "optic_AMS", 250, "item"],
	["AMS (Khaki)", "optic_AMS_khk", 250, "item"],
	["AMS (Sand)", "optic_AMS_snd", 250, "item"],
	["LRPS", "optic_LRPS", 300, "item"],
	["LRPS (G Hex)", "optic_LRPS_ghex_F", 300, "item"],
	["LRPS (Tropic)", "optic_LRPS_tna_F", 300, "item"],
	["NVS", "optic_NVS", 500, "item"],
	["TWS", "optic_tws", 5000, "item", "HIDDEN"], // To hide from store list, add "HIDDEN" after "item", like "item", "HIDDEN"]
	["TWS MG", "optic_tws_mg", 6000, "item", "HIDDEN"],
	["Nightstalker", "optic_Nightstalker", 7500, "item", "HIDDEN"]
];

// If commented, means the color/camo isn't implemented or is a duplicate of another hat
headArray = compileFinal str
[
	["Modular Helmet (Digi)", "H_HelmetIA", 50, "hat"],
	// ["MICH (Camo)", "H_HelmetIA_net", 50, "hat"],
	// ["MICH 2 (Camo)", "H_HelmetIA_camo", 50, "hat"],
	["Combat Helmet", "H_HelmetB", 50, "hat"],
	["Combat Helmet (Black)", "H_HelmetB_black", 50, "hat"],
	["Combat Helmet (Camonet)", "H_HelmetB_camo", 50, "hat"],
	["Stealth Combat Helmet", "H_HelmetB_TI_tna_F", 75, "hat"],
	["Enhanced Combat Helmet", "H_HelmetSpecB", 75, "hat"],
	["Enhanced Combat Helmet (Black)", "H_HelmetSpecB_blk", 75, "hat"],
	["Enhanced Combat Helmet (Snakeskin)", "H_HelmetSpecB_snakeskin", 75, "hat"],
	["Enhanced Combat Helmet (Tropic)", "H_HelmetB_Enh_tna_F", 75, "hat", "noDLC"],
	["Protector Helmet (Hex)", "H_HelmetO_ocamo", 60, "hat"],
	["Protector Helmet (Urban)", "H_HelmetO_oucamo", 60, "hat"],
	["Assassin Helmet (Hex)", "H_HelmetSpecO_ocamo", 75, "hat"],
	["Assassin Helmet (Black)", "H_HelmetSpecO_blk", 75, "hat"],
	["Defender Helmet (Hex)", "H_HelmetLeaderO_ocamo", 100, "hat"],
	["Defender Helmet (Urban)", "H_HelmetLeaderO_oucamo", 100, "hat"],
	["Defender Helmet (G Hex)", "H_HelmetLeaderO_ghex_F", 100, "hat", "noDLC"],
	["Pilot Helmet (NATO)", "H_PilotHelmetFighter_B", 60, "hat"],
	["Pilot Helmet (CSAT)", "H_PilotHelmetFighter_O", 60, "hat"],
	["Pilot Helmet (AAF)", "H_PilotHelmetFighter_I", 60, "hat"],
	["Crew Helmet (NATO)", "H_HelmetCrew_B", 60, "hat"],
	["Crew Helmet (CSAT)", "H_HelmetCrew_O", 60, "hat"],
	["Crew Helmet (AAF)", "H_HelmetCrew_I", 60, "hat"],
	["Heli Pilot Helmet (NATO)", "H_PilotHelmetHeli_B", 50, "hat"],
	["Heli Pilot Helmet (CSAT)", "H_PilotHelmetHeli_O", 50, "hat"],
	["Heli Pilot Helmet (AAF)", "H_PilotHelmetHeli_I", 50, "hat"],
	["Heli Crew Helmet (NATO)", "H_CrewHelmetHeli_B", 50, "hat"],
	["Heli Crew Helmet (CSAT)", "H_CrewHelmetHeli_O", 50, "hat"],
	["Heli Crew Helmet (AAF)", "H_CrewHelmetHeli_I", 50, "hat"],
	["Military Cap (Blue)", "H_MilCap_blue", 25, "hat"],
	["Military Cap (Gray)", "H_MilCap_gry", 25, "hat"],
	["Military Cap (Urban)", "H_MilCap_oucamo", 25, "hat"],
	["Military Cap (Russia)", "H_MilCap_rucamo", 25, "hat"],
	["Military Cap (MTP)", "H_MilCap_mcamo", 25, "hat"],
	["Military Cap (Hex)", "H_MilCap_ocamo", 25, "hat"],
	["Military Cap (AAF)", "H_MilCap_dgtl", 25, "hat"],
	["Rangemaster Cap", "H_Cap_headphones", 25, "hat"],
	["Bandana (Black)", "H_Bandanna_gry", 10, "hat"],
	["Bandana (Blue)", "H_Bandanna_blu", 10, "hat"],
	["Bandana (Coyote)", "H_Bandanna_cbr", 10, "hat"],
	["Bandana (Headset)", "H_Bandanna_khk_hs", 10, "hat"],
	["Bandana (Khaki)", "H_Bandanna_khk", 10, "hat"],
	["Bandana (MTP)", "H_Bandanna_mcamo", 10, "hat"],
	["Bandana (Sage)", "H_Bandanna_sgg", 10, "hat"],
	["Bandana (Sand)", "H_Bandanna_sand", 10, "hat"],
	["Bandana (Surfer)", "H_Bandanna_surfer", 10, "hat"],
	["Bandana (Surfer, Black)", "H_Bandanna_surfer_blk", 10, "hat"],
	["Bandana (Surfer, Green)", "H_Bandanna_surfer_grn", 10, "hat"],
	["Bandana (Woodland)", "H_Bandanna_camo", 10, "hat"],
	// ["Bandanna Mask (Black)", "H_BandMask_blk", 10, "hat"],
	// ["Bandanna Mask (Demon)", "H_BandMask_demon", 10, "hat"],
	// ["Bandanna Mask (Khaki)", "H_BandMask_khk", 10, "hat"],
	// ["Bandanna Mask (Reaper)", "H_BandMask_reaper", 10, "hat"],
	["Beanie (Black)", "H_Watchcap_blk", 10, "hat"],
	["Beanie (Brown)", "H_Watchcap_cbr", 10, "hat"],
	["Beanie (Khaki)", "H_Watchcap_khk", 10, "hat"],
	["Beanie (Navy)", "H_Watchcap_sgg", 10, "hat"],
	["Beanie (Olive)", "H_Watchcap_camo", 10, "hat"],
	["Beret (Black)", "H_Beret_blk", 10, "hat"],
	["Beret (Colonel)", "H_Beret_Colonel", 10, "hat"],
	["Beret (NATO)", "H_Beret_02", 10, "hat"],
	// ["Beret (Green)", "H_Beret_grn", 10, "hat"],
	// ["Beret (Police)", "H_Beret_blk_POLICE", 10, "hat"],
	// ["Beret (Red)", "H_Beret_red", 10, "hat"],
	// ["Beret (SAS)", "H_Beret_brn_SF", 10, "hat"],
	// ["Beret (SF)", "H_Beret_grn_SF", 10, "hat"],
	// ["Beret (RED)", "H_Beret_ocamo", 10, "hat"],
	// ["Black Turban", "H_TurbanO_blk", 50, "hat"],
	// ["Booniehat (Dirty)", "H_Booniehat_dirty", 10, "hat"],
	// ["Booniehat (Green)", "H_Booniehat_grn", 10, "hat"],
	// ["Booniehat (Khaki)", "H_Booniehat_indp", 10, "hat"],
	["Booniehat (AAF)", "H_Booniehat_dgtl", 10, "hat"],
	["Booniehat (Headset)", "H_Booniehat_khk_hs", 10, "hat"],
	["Booniehat (Khaki)", "H_Booniehat_khk", 10, "hat"],
	["Booniehat (MTP)", "H_Booniehat_mcamo", 10, "hat"],
	["Booniehat (Olive)", "H_Booniehat_oli", 10, "hat"],
	["Booniehat (Sand)", "H_Booniehat_tan", 10, "hat"],
	["Fedora (Blue)", "H_Hat_blue", 10, "hat"],
	["Fedora (Brown)", "H_Hat_brown", 10, "hat"],
	["Fedora (Camo)", "H_Hat_camo", 10, "hat"],
	["Fedora (Checker)", "H_Hat_checker", 10, "hat"],
	["Fedora (Gray)", "H_Hat_grey", 10, "hat"],
	["Fedora (Tan)", "H_Hat_tan", 10, "hat"],
	["Cap (BI)", "H_Cap_grn_BI", 10, "hat"],
	["Cap (Black)", "H_Cap_blk", 10, "hat"],
	["Cap (Blue)", "H_Cap_blu", 10, "hat"],
	["Cap (CMMG)", "H_Cap_blk_CMMG", 10, "hat"],
	["Cap (Green)", "H_Cap_grn", 10, "hat"],
	["Cap (ION)", "H_Cap_blk_ION", 10, "hat"],
	["Cap (Olive)", "H_Cap_oli", 10, "hat"],
	["Cap (Olive, Headset)", "H_Cap_oli_hs", 10, "hat"],
	["Cap (Police)", "H_Cap_police", 10, "hat"],
	["Cap (Press)", "H_Cap_press", 10, "hat"],
	["Cap (Red)", "H_Cap_red", 10, "hat"],
	["Cap (Surfer)", "H_Cap_surfer", 10, "hat"],
	["Cap (Tan)", "H_Cap_tan", 10, "hat"],
	["Cap (UK)", "H_Cap_khaki_specops_UK", 10, "hat"],
	["Cap (US Black)", "H_Cap_usblack", 10, "hat"],
	["Cap (US MTP)", "H_Cap_tan_specops_US", 10, "hat"],
	["Cap (AAF)", "H_Cap_blk_Raven", 10, "hat"],
	["Cap (OPFOR)", "H_Cap_brn_SPECOPS", 10, "hat"],
	["Shemag (Olive)", "H_Shemag_olive", 25, "hat"],
	["Shemag (Olive, Headset)", "H_Shemag_olive_hs", 25, "hat"],
	["Shemag (Tan)", "H_ShemagOpen_tan", 25, "hat"],
	["Shemag (White)", "H_ShemagOpen_khk", 25, "hat"],
	// ["Shemag mask (Tan)", "H_Shemag_tan", 25, "hat"],
	["Racing Helmet (Black)", "H_RacingHelmet_1_black_F", 25, "hat"],
	["Racing Helmet (Blue)", "H_RacingHelmet_1_blue_F", 25, "hat"],
	["Racing Helmet (Green)", "H_RacingHelmet_1_green_F", 25, "hat"],
	["Racing Helmet (Yellow)", "H_RacingHelmet_1_yellow_F", 25, "hat"],
	["Racing Helmet (Orange)", "H_RacingHelmet_1_orange_F", 25, "hat"],
	["Racing Helmet (Red)", "H_RacingHelmet_1_red_F", 25, "hat"],
	["Racing Helmet (White)", "H_RacingHelmet_1_white_F", 25, "hat"],
	["Racing Helmet (Fuel)", "H_RacingHelmet_1_F", 25, "hat"],
	["Racing Helmet (Bluking)", "H_RacingHelmet_2_F", 25, "hat"],
	["Racing Helmet (Redstone)", "H_RacingHelmet_3_F", 25, "hat"],
	["Racing Helmet (Vrana)", "H_RacingHelmet_4_F", 25, "hat"]
];

uniformArray = compileFinal str
[
	["Wetsuit", "U_B_Wetsuit", 200, "uni"],
	["Wetsuit", "U_O_Wetsuit", 200, "uni"],
	["Wetsuit", "U_I_Wetsuit", 200, "uni"],
	["Light Ghillie", "U_B_GhillieSuit", 200, "uni"],
	["Light Ghillie", "U_O_GhillieSuit", 200, "uni"],
	["Light Ghillie", "U_I_GhillieSuit", 200, "uni"],
	["Light Ghillie (Jungle)", "U_B_T_Sniper_F", 200, "uni"],
	["Light Ghillie (Jungle)", "U_O_T_Sniper_F", 200, "uni"],
	["Full Ghillie (Arid)", "U_B_FullGhillie_ard", 2000, "uni"],
	["Full Ghillie (Arid)", "U_O_FullGhillie_ard", 2000, "uni"],
	["Full Ghillie (Arid)", "U_I_FullGhillie_ard", 2000, "uni"],
	["Full Ghillie (Lush)", "U_B_FullGhillie_lsh", 2000, "uni"],
	["Full Ghillie (Lush)", "U_O_FullGhillie_lsh", 2000, "uni"],
	["Full Ghillie (Lush)", "U_I_FullGhillie_lsh", 2000, "uni"],
	["Full Ghillie (Semi-Arid)", "U_B_FullGhillie_sard", 2000, "uni"],
	["Full Ghillie (Semi-Arid)", "U_O_FullGhillie_sard", 2000, "uni"],
	["Full Ghillie (Semi-Arid)", "U_I_FullGhillie_sard", 2000, "uni"],
	["Full Ghillie (Jungle)", "U_B_T_FullGhillie_tna_F", 2000, "uni"],
	["Full Ghillie (Jungle)", "U_O_T_FullGhillie_tna_F", 2000, "uni"],
	["CTRG Stealth Uniform", "U_B_CTRG_Soldier_F", 1000, "uni"],
	["Special Purpose Suit (Hex)", "U_O_V_Soldier_Viper_hex_F", 1000, "uni"],
	["Special Purpose Suit (G Hex)", "U_O_V_Soldier_Viper_F", 1000, "uni"],
	["Survival Fatigues (NATO)", "U_B_survival_uniform", 200, "uni"],
	["Default Uniform (NATO)", "U_B_CombatUniform_mcam", 25, "uni"],
	["Default Uniform (CSAT)", "U_O_OfficerUniform_ocamo", 25, "uni"],
	["Default Uniform (AAF)", "U_I_CombatUniform", 25, "uni"],
	["Recon Fatigues (MTP)", "U_B_CombatUniform_mcam_vest", 25, "uni"],
	["Combat Fatigues (Tropic)", "U_B_T_Soldier_F", 25, "uni", "noDLC"],
	["Combat Fatigues (Tee)", "U_B_CombatUniform_mcam_tshirt", 25, "uni"],
	["Combat Fatigues (Gangsta)", "U_I_G_resistanceLeader_F", 25, "uni"],
	["Combat Fatigues (Rolled-up)", "U_I_CombatUniform_shortsleeve", 25, "uni"],
	["CTRG Combat Uniform", "U_B_CTRG_1", 25, "uni"],
	["CTRG Combat Uniform (Tee)", "U_B_CTRG_2", 25, "uni"],
	["CTRG Combat Uniform (Rolled-up)", "U_B_CTRG_3", 25, "uni"],
	["Fatigues (Hex)", "U_O_CombatUniform_ocamo", 50, "uni"],
	["Fatigues (Urban)", "U_O_CombatUniform_oucamo", 50, "uni"],
	["Fatigues (G Hex)", "U_O_T_Soldier_F", 50, "uni", "noDLC"],
	["Officer Fatigues", "U_I_OfficerUniform", 25, "uni"],
	["Pilot Coveralls", "U_B_PilotCoveralls", 25, "uni"],
	["Pilot Coveralls", "U_O_PilotCoveralls", 25, "uni"],
	["Pilot Coveralls", "U_I_pilotCoveralls", 25, "uni"],
	["Heli Pilot Coveralls", "U_B_HeliPilotCoveralls", 25, "uni"],
	["Heli Pilot Coveralls", "U_I_HeliPilotCoveralls", 25, "uni"],
	["Guerilla Garment", "U_BG_Guerilla1_1", 25, "uni"],  // BLUFOR
	["Guerilla Outfit (Plain, Dark)", "U_BG_Guerilla2_1", 25, "uni"],
	["Guerilla Outfit (Pattern)", "U_BG_Guerilla2_2", 25, "uni"],
	["Guerilla Outfit (Plain, Light)", "U_BG_Guerilla2_3", 25, "uni"],
	["Guerilla Smocks", "U_BG_Guerilla3_1", 25, "uni"],
	["Guerilla Apparel", "U_BG_Guerrilla_6_1", 25, "uni"],
	["Guerilla Uniform", "U_BG_leader", 25, "uni"],
	["Guerilla Garment", "U_OG_Guerilla1_1", 25, "uni"], // OPFOR
	["Guerilla Outfit (Plain, Dark)", "U_OG_Guerilla2_1", 25, "uni"],
	["Guerilla Outfit (Pattern)", "U_OG_Guerilla2_2", 25, "uni"],
	["Guerilla Outfit (Plain, Light)", "U_OG_Guerilla2_3", 25, "uni"],
	["Guerilla Smocks", "U_OG_Guerilla3_1", 25, "uni"],
	["Guerilla Apparel", "U_OG_Guerrilla_6_1", 25, "uni"],
	["Guerilla Uniform", "U_OG_leader", 25, "uni"],
	["Guerilla Garment", "U_IG_Guerilla1_1", 25, "uni"], // Independent
	["Guerilla Outfit (Plain, Dark)", "U_IG_Guerilla2_1", 25, "uni"],
	["Guerilla Outfit (Pattern)", "U_IG_Guerilla2_2", 25, "uni"],
	["Guerilla Outfit (Plain, Light)", "U_IG_Guerilla2_3", 25, "uni"],
	["Guerilla Smocks", "U_IG_Guerilla3_1", 25, "uni"],
	["Guerilla Apparel", "U_IG_Guerrilla_6_1", 25, "uni"],
	["Guerilla Uniform", "U_IG_leader", 25, "uni"],
	/*["Worker Coveralls", "U_C_WorkerCoveralls", 25, "uni"], // can only be worn by civilian units
	["T-Shirt (Blue)", "U_C_Poor_1", 25, "uni"],
	["Polo (Red/white)", "U_C_Poloshirt_redwhite", 25, "uni"],
	["Polo (Salmon)", "U_C_Poloshirt_salmon", 25, "uni"],
	["Polo (Tri-color)", "U_C_Poloshirt_tricolour", 25, "uni"],
	["Polo (Navy)", "U_C_Poloshirt_blue", 25, "uni"],
	["Polo (Burgundy)", "U_C_Poloshirt_burgundy", 25, "uni"],
	["Polo (Blue/green)", "U_C_Poloshirt_stripped", 25, "uni"],*/
	["Polo (Competitor)", "U_Competitor", 25, "uni"],
	["Polo (Rangemaster)", "U_Rangemaster", 25, "uni"],
	/*["Racing Suit (Black)", "U_C_Driver_1_black", 25, "uni"], // can only be worn by civilian units
	["Racing Suit (Blue)", "U_C_Driver_1_blue", 25, "uni"],
	["Racing Suit (Green)", "U_C_Driver_1_green", 25, "uni"],
	["Racing Suit (Yellow)", "U_C_Driver_1_yellow", 25, "uni"],
	["Racing Suit (Orange)", "U_C_Driver_1_orange", 25, "uni"],
	["Racing Suit (Red)", "U_C_Driver_1_red", 25, "uni"],
	["Racing Suit (White)", "U_C_Driver_1_white", 25, "uni"],
	["Racing Suit (Fuel)", "U_C_Driver_1", 25, "uni"],
	["Racing Suit (Bluking)", "U_C_Driver_2", 25, "uni"],
	["Racing Suit (Redstone)", "U_C_Driver_3", 25, "uni"],
	["Racing Suit (Vrana)", "U_C_Driver_4", 25, "uni"],*/
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
	["Carrier Lite (CTRG)", "V_PlateCarrierL_CTRG", -1, "vest"],
	["Carrier Lite (Tropic)", "V_PlateCarrier1_tna_F", -1, "vest", "noDLC"],
	["Carrier Rig (Green)", "V_PlateCarrier2_rgr", -1, "vest"],
	["Carrier Rig (Black)", "V_PlateCarrier2_blk", -1, "vest"],
	["Carrier Rig (CTRG)", "V_PlateCarrierH_CTRG", -1, "vest"],
	["Carrier Rig (Tropic)", "V_PlateCarrier2_tna_F", -1, "vest", "noDLC"],
	["Carrier GL Rig (Green)", "V_PlateCarrierGL_rgr", -1, "vest"],
	["Carrier GL Rig (Black)", "V_PlateCarrierGL_blk", -1, "vest"],
	["Carrier GL Rig (MTP)", "V_PlateCarrierGL_mtp", -1, "vest"],
	["Carrier GL Rig (Tropic)", "V_PlateCarrierGL_tna_F", -1, "vest", "noDLC"],
	["Carrier Special Rig (Green)", "V_PlateCarrierSpec_rgr", -1, "vest"],
	["Carrier Special Rig (Black)", "V_PlateCarrierSpec_blk", -1, "vest"],
	["Carrier Special Rig (MTP)", "V_PlateCarrierSpec_mtp", -1, "vest"],
	["Carrier Special Rig (Tropic)", "V_PlateCarrierSpec_tna_F", -1, "vest", "noDLC"],
	["GA Carrier Lite (Digi)", "V_PlateCarrierIA1_dgtl", -1, "vest"],
	["GA Carrier Rig (Digi)", "V_PlateCarrierIA2_dgtl", -1, "vest"],
	["GA Carrier GL Rig (Digi)", "V_PlateCarrierIAGL_dgtl", -1, "vest"],
	["GA Carrier GL Rig (Olive)", "V_PlateCarrierIAGL_oli", -1, "vest"],
	["LBV Harness", "V_HarnessO_brn", -1, "vest"],
	["LBV Harness (Gray)", "V_HarnessO_gry", -1, "vest"],
	["LBV Grenadier Harness", "V_HarnessOGL_brn", -1, "vest"],
	["LBV Grenadier Harness (Gray)", "V_HarnessOGL_gry", -1, "vest"],
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
	["Raven Night Vest", "V_TacVestIR_blk", -1, "vest"],
	["Press Vest", "V_Press_F", -1, "vest"],
	["Deck Crew Vest (Blue)", "V_DeckCrew_blue_F", -1, "vest", "noDLC"],
	["Deck Crew Vest (Green)", "V_DeckCrew_green_F", -1, "vest", "noDLC"],
	["Deck Crew Vest (Yellow)", "V_DeckCrew_yellow_F", -1, "vest", "noDLC"],
	["Deck Crew Vest (Red)", "V_DeckCrew_red_F", -1, "vest", "noDLC"],
	["Deck Crew Vest (Brown)", "V_DeckCrew_brown_F", -1, "vest", "noDLC"],
	["Deck Crew Vest (Violet)", "V_DeckCrew_violet_F", -1, "vest", "noDLC"],
	["Deck Crew Vest (White)", "V_DeckCrew_white_F", -1, "vest", "noDLC"]
];

backpackArray = compileFinal str
[
	//["Parachute", "B_Parachute", 200, "backpack"],

	["Assault Pack (Black)", "B_AssaultPack_blk", 100, "backpack"],
	["Assault Pack (Green)", "B_AssaultPack_rgr", 100, "backpack"],
	["Assault Pack (MTP)", "B_AssaultPack_mcamo", 100, "backpack"],
	["Assault Pack (Hex)", "B_AssaultPack_ocamo", 100, "backpack"],
	["Assault Pack (Tropic)", "B_AssaultPack_tna_F", 100, "backpack", "noDLC"],

	["Field Pack (Black)", "B_FieldPack_blk", 200, "backpack"],
	["Field Pack (Coyote)", "B_FieldPack_cbr", 200, "backpack"],
	["Field Pack (Khaki)", "B_FieldPack_khk", 200, "backpack"],
	["Field Pack (Urban)", "B_FieldPack_oucamo", 200, "backpack"],
	["Field Pack (G Hex)", "B_FieldPack_ghex_F", 200, "backpack", "noDLC"],

	["Kitbag (Coyote)", "B_Kitbag_cbr", 350, "backpack"],
	["Kitbag (Green)", "B_Kitbag_rgr", 350, "backpack"],
	["Kitbag (MTP)", "B_Kitbag_mcamo", 350, "backpack"],
	["Kitbag (Sage)", "B_Kitbag_sgg", 350, "backpack"],

	["Viper Light Harness (Black)", "B_ViperLightHarness_blk_F", 350, "backpack", "noDLC"],
	["Viper Light Harness (Hex)", "B_ViperLightHarness_hex_F", 350, "backpack", "noDLC"],
	["Viper Light Harness (G Hex)", "B_ViperLightHarness_ghex_F", 350, "backpack", "noDLC"],
	["Viper Light Harness (Khaki)", "B_ViperLightHarness_khk_F", 350, "backpack", "noDLC"],
	["Viper Light Harness (Olive)", "B_ViperLightHarness_oli_F", 350, "backpack", "noDLC"],

	["Viper Harness (Black)", "B_ViperHarness_blk_F", 425, "backpack", "noDLC"],
	["Viper Harness (Hex)", "B_ViperHarness_hex_F", 425, "backpack", "noDLC"],
	["Viper Harness (G Hex)", "B_ViperHarness_ghex_F", 425, "backpack", "noDLC"],
	["Viper Harness (Khaki)", "B_ViperHarness_khk_F", 425, "backpack", "noDLC"],
	["Viper Harness (Olive)", "B_ViperHarness_oli_F", 425, "backpack", "noDLC"],

	["Carryall (Khaki)", "B_Carryall_khk", 500, "backpack"],
	["Carryall (MTP)", "B_Carryall_mcamo", 500, "backpack"],
	["Carryall (Olive)", "B_Carryall_oli", 500, "backpack"],
	["Carryall (Urban)", "B_Carryall_oucamo", 500, "backpack"],
	["Carryall (G Hex)", "B_Carryall_ghex_F", 500, "backpack", "noDLC"],

	["Bergen (Digital)", "B_Bergen_dgtl_F", 1000, "backpack", "noDLC"],
	["Bergen (Hex)", "B_Bergen_hex_F", 1000, "backpack", "noDLC"],
	["Bergen (MTP)", "B_Bergen_mcamo_F", 1000, "backpack", "noDLC"],
	["Bergen (Tropic)", "B_Bergen_tna_F", 1000, "backpack", "noDLC"]
];

genItemArray = compileFinal str
[
	["UAV Terminal (NATO)", "B_UavTerminal", 150, "gps"],
	["UAV Terminal (CSAT)", "O_UavTerminal", 150, "gps"],
	["UAV Terminal (AAF)", "I_UavTerminal", 150, "gps"],
	["Quadcopter UAV (NATO)", "B_UAV_01_backpack_F", 2500, "backpack"],
	["Quadcopter UAV (CSAT)", "O_UAV_01_backpack_F", 2500, "backpack"],
	["Quadcopter UAV (AAF)", "I_UAV_01_backpack_F", 2500, "backpack"],
	["Hexacopter UAV (NATO)", "B_UAV_06_backpack_F", 1000, "backpack"],
	["Hexacopter UAV (CSAT)", "O_UAV_06_backpack_F", 1000, "backpack"],
	["Hexacopter UAV (AAF)", "I_UAV_06_backpack_F", 1000, "backpack"],
	["Hexacopter Medical UAV (NATO)", "B_UAV_06_medical_backpack_F", 1500, "backpack"],
	["Hexacopter Medical UAV (CSAT)", "O_UAV_06_medical_backpack_F", 1500, "backpack"],
	["Hexacopter Medical UAV (AAF)", "I_UAV_06_medical_backpack_F", 1500, "backpack"],
	["Hexacopter Demining UAV", "C_IDAP_UAV_06_antimine_backpack_F", 10000, "backpack"],
	["Remote Designator (Sand)", "B_Static_Designator_01_weapon_F", 750, "backpack"],
	["Remote Designator (Hex)", "O_Static_Designator_02_weapon_F", 750, "backpack"],
	["GPS", "ItemGPS", 100, "gps"],
	["First Aid Kit", "FirstAidKit", 25, "item"],
	["Medikit", "Medikit", 150, "item"],
	["Toolkit", "ToolKit", 150, "item"],
	["Mine Detector", "MineDetector", 100, "item"],
	["Diving Goggles", "G_Diving", 100, "gogg"],
	["NV Goggles (Brown)", "NVGoggles", 100, "nvg"],
	["NV Goggles (Black)", "NVGoggles_OPFOR", 100, "nvg"],
	["NV Goggles (Green)", "NVGoggles_INDEP", 100, "nvg"],
	["NV Goggles (Tropic)", "NVGoggles_tna_F", 100, "nvg"],
	["Compact NVG (Hex)", "O_NVGoggles_hex_F", 150, "nvg"],
	["Compact NVG (G Hex)", "O_NVGoggles_ghex_F", 150, "nvg"],
	["Compact NVG (Urban)", "O_NVGoggles_urb_F", 150, "nvg"],
	["Binoculars", "Binocular", 50, "binoc"],
	["Rangefinder", "Rangefinder", 150, "binoc"],
	["Laser Designator (Sand)", "Laserdesignator", 250, "binoc", "noDLC"], // Increase price to 2500 if A3W_disableBuiltInThermal = 0
	["Laser Designator (Hex)", "Laserdesignator_02", 300, "binoc", "noDLC"],
	["Laser Designator (Olive)", "Laserdesignator_03", 250, "binoc", "noDLC"],
	["IR Designator Grenade", "B_IR_Grenade", 50, "mag", "WEST"],
	["IR Designator Grenade", "O_IR_Grenade", 50, "mag", "EAST"],
	["IR Designator Grenade", "I_IR_Grenade", 50, "mag", "GUER"],
	["Chemlight (Blue)", "Chemlight_blue", 25, "mag"],
	["Chemlight (Green)", "Chemlight_green", 25, "mag"],
	["Chemlight (Yellow)", "Chemlight_yellow", 25, "mag"],
	["Chemlight (Red)", "Chemlight_red", 25, "mag"],

	["Stealth Balaclava (Black)", "G_Balaclava_TI_blk_F", 200, "gogg"],
	["Stealth Balaclava (Black, Goggles)", "G_Balaclava_TI_G_blk_F", 250, "gogg"],
	["Stealth Balaclava (Green)", "G_Balaclava_TI_tna_F", 200, "gogg"],
	["Stealth Balaclava (Green, Goggles)", "G_Balaclava_TI_G_tna_F", 250, "gogg"],
	["Combat Goggles", "G_Combat", 25, "gogg"],
	["Combat Goggles (Green)", "G_Combat_Goggles_tna_F", 25, "gogg", "noDLC"],
	["VR Goggles", "G_Goggles_VR", 25, "gogg"],
	["Balaclava (Black)", "G_Balaclava_blk", 25, "gogg"],
	["Balaclava (Combat Goggles)", "G_Balaclava_combat", 25, "gogg"],
	["Balaclava (Low Profile Goggles)", "G_Balaclava_lowprofile", 25, "gogg"],
	["Balaclava (Olive)", "G_Balaclava_oli", 25, "gogg"],
	["Bandana (Aviator)", "G_Bandanna_aviator", 25, "gogg"],
	["Bandana (Beast)", "G_Bandanna_beast", 25, "gogg"],
	["Bandana (Black)", "G_Bandanna_blk", 25, "gogg"],
	["Bandana (Khaki)", "G_Bandanna_khk", 25, "gogg"],
	["Bandana (Olive)", "G_Bandanna_oli", 25, "gogg"],
	["Bandana (Shades)", "G_Bandanna_shades", 25, "gogg"],
	["Bandana (Sport)", "G_Bandanna_sport", 25, "gogg"],
	["Bandana (Tan)", "G_Bandanna_tan", 25, "gogg"],

	["Aviator Glasses", "G_Aviator", 10, "gogg"],
	["Ladies Shades", "G_Lady_Blue", 10, "gogg"],
	["Ladies Shades (Fire)", "G_Lady_Red", 10, "gogg"],
	["Ladies Shades (Iridium)", "G_Lady_Mirror", 10, "gogg"],
	["Ladies Shades (Sea)", "G_Lady_Dark", 10, "gogg"],
	["Low Profile Goggles", "G_Lowprofile", 10, "gogg"],
	["Shades (Black)", "G_Shades_Black", 10, "gogg"],
	["Shades (Blue)", "G_Shades_Blue", 10, "gogg"],
	["Shades (Green)", "G_Shades_Green", 10, "gogg"],
	["Shades (Red)", "G_Shades_Red", 10, "gogg"],
	["Spectacle Glasses", "G_Spectacles", 10, "gogg"],
	["Sport Shades (Fire)", "G_Sport_Red", 10, "gogg"],
	["Sport Shades (Poison)", "G_Sport_Blackyellow", 10, "gogg"],
	["Sport Shades (Shadow)", "G_Sport_BlackWhite", 10, "gogg"],
	["Sport Shades (Style)", "G_Sport_Checkered", 10, "gogg"],
	["Sport Shades (Vulcan)", "G_Sport_Blackred", 10, "gogg"],
	["Sport Shades (Yetti)", "G_Sport_Greenblack", 10, "gogg"],
	["Square Shades", "G_Squares_Tinted", 10, "gogg"],
	["Square Spectacles", "G_Squares", 10, "gogg"],
	["Tactical Glasses", "G_Tactical_Clear", 10, "gogg"],
	["Tactical Shades", "G_Tactical_Black", 10, "gogg"],
	["Tinted Spectacles", "G_Spectacles_Tinted", 10, "gogg"]
];

allStoreMagazines = compileFinal str (call ammoArray + call throwputArray + call genItemArray);
allRegularStoreItems = compileFinal str (call allGunStoreFirearms + call allStoreMagazines + call accessoriesArray);
allStoreGear = compileFinal str (call headArray + call uniformArray + call vestArray + call backpackArray);

genObjectsArray = compileFinal str
[
	["Camo Net", "CamoNet_INDP_open_F", 200, "object", "HIDDEN"], // unlisted, only for object saving

	["Pier Ladder", "Land_PierLadder_F", 250, "object"],
	["Ammo Cache", "Box_FIA_Support_F", 250, "ammocrate"],
	//["Metal Barrel", "Land_MetalBarrel_F", 25, "object"],
	//["Toilet Box", "Land_ToiletBox_F", 25, "object"],
	["Lamp Post (Harbour)", "Land_LampHarbour_F", 100, "object"],
	["Lamp Post (Shabby)", "Land_LampShabby_F", 100, "object"],
	["Boom Gate", "Land_BarGate_F", 150, "object"],
	["Pipes", "Land_Pipes_Large_F", 200, "object"],
	["Concrete Frame", "Land_CncShelter_F", 200, "object"],
	["Highway Guardrail", "Land_Crash_barrier_F", 200, "object"],
	["Concrete Barrier", "Land_CncBarrier_F", 200, "object"],
	["Concrete Barrier (Medium)", "Land_CncBarrierMedium_F", 350, "object"],
	["Concrete Barrier (Long)", "Land_CncBarrierMedium4_F", 500, "object"],
	["HBarrier (1 block)", "Land_HBarrier_1_F", 150, "object"],
	["HBarrier (3 blocks)", "Land_HBarrier_3_F", 200, "object"],
	["HBarrier (5 blocks)", "Land_HBarrier_5_F", 250, "object"],
	["HBarrier Big", "Land_HBarrierBig_F", 500, "object"],
	["HBarrier Wall (4 blocks)", "Land_HBarrierWall4_F", 400, "object"],
	["HBarrier Wall (6 blocks)", "Land_HBarrierWall6_F", 500, "object"],
	["HBarrier Watchtower", "Land_HBarrierTower_F", 600, "object"],
	["Concrete Wall", "Land_CncWall1_F", 400, "object"],
	["Concrete Military Wall", "Land_Mil_ConcreteWall_F", 400, "object"],
	["Concrete Wall (Long)", "Land_CncWall4_F", 600, "object"],
	["Military Wall (Big)", "Land_Mil_WallBig_4m_F", 600, "object"],
	//["Shoot House Wall", "Land_Shoot_House_Wall_F", 180, "object"],
	["Canal Wall (Small)", "Land_Canal_WallSmall_10m_F", 400, "object"],
	["Canal Stairs", "Land_Canal_Wall_Stairs_F", 500, "object"],
	["Bag Fence (Corner)", "Land_BagFence_Corner_F", 150, "object"],
	["Bag Fence (End)", "Land_BagFence_End_F", 150, "object"],
	["Bag Fence (Long)", "Land_BagFence_Long_F", 200, "object"],
	["Bag Fence (Round)", "Land_BagFence_Round_F", 150, "object"],
	["Bag Fence (Short)", "Land_BagFence_Short_F", 150, "object"],
	["Bag Bunker (Small)", "Land_BagBunker_Small_F", 250, "object"],
	["Bag Bunker (Large)", "Land_BagBunker_Large_F", 500, "object"],
	["Bag Bunker Tower", "Land_BagBunker_Tower_F", 1000, "object"],
	["Military Cargo Post", "Land_Cargo_Patrol_V1_F", 800, "object"],
	["Military Cargo Tower", "Land_Cargo_Tower_V1_F", 10000, "object"],
	["Concrete Ramp", "Land_RampConcrete_F", 350, "object"],
	["Concrete Ramp (High)", "Land_RampConcreteHigh_F", 500, "object"],
	["Scaffolding", "Land_Scaffolding_F", 250, "object"]
];

allGenStoreVanillaItems = compileFinal str (call genItemArray + call genObjectsArray + call allStoreGear);

//Text name, classname, buy cost, spawn type, sell price (selling not implemented) or spawning color
landArray = compileFinal str
[
	// SKIPSAVE = will not be autosaved until first manual force save, good for cheap vehicles that usually get abandoned

	["Kart", "C_Kart_01_F", 500, "vehicle", "SKIPSAVE"],

	["Quadbike (Civilian)", "C_Quadbike_01_F", 600, "vehicle", "SKIPSAVE"],
	["Quadbike (NATO)", "B_Quadbike_01_F", 650, "vehicle", "SKIPSAVE"],
	["Quadbike (CSAT)", "O_Quadbike_01_F", 650, "vehicle", "SKIPSAVE"],
	["Quadbike (AAF)", "I_Quadbike_01_F", 650, "vehicle", "SKIPSAVE"],
	["Quadbike (FIA)", "B_G_Quadbike_01_F", 650, "vehicle", "SKIPSAVE"],

	["Hatchback", "C_Hatchback_01_F", 800, "vehicle", "SKIPSAVE"],
	["Hatchback Sport", "C_Hatchback_01_sport_F", 1000, "vehicle", "SKIPSAVE"],
	["SUV", "C_SUV_01_F", 1100, "vehicle", "SKIPSAVE"],

	["MB 4WD", "C_Offroad_02_unarmed_F", 1000, "vehicle", "SKIPSAVE"],
	["MB 4WD (Guerilla)", "I_C_Offroad_02_unarmed_F", 900, "vehicle", "SKIPSAVE"],

	["Offroad", "C_Offroad_01_F", 1100, "vehicle", "SKIPSAVE"],
	["Offroad Camo", "B_G_Offroad_01_F", 1250, "vehicle", "SKIPSAVE"],
	["Offroad Police", "B_GEN_Offroad_01_gen_F", 1250, "vehicle", "SKIPSAVE"],
	["Offroad Repair", "C_Offroad_01_repair_F", 1500, "vehicle", "SKIPSAVE"],
	["Offroad HMG", "B_G_Offroad_01_armed_F", 2500, "vehicle", "SKIPSAVE"],

	["Truck", "C_Van_01_transport_F", 700, "vehicle", "SKIPSAVE"],
	["Truck Camo", "B_G_Van_01_transport_F", 800, "vehicle", "SKIPSAVE"],
	["Truck Box", "C_Van_01_box_F", 900, "vehicle", "SKIPSAVE"],
	["Fuel Truck", "C_Van_01_fuel_F", 2000, "vehicle", "SKIPSAVE"],
	["Fuel Truck Camo", "B_G_Van_01_fuel_F", 2100, "vehicle", "SKIPSAVE"],

	["Van Cargo", "C_Van_02_vehicle_F", 1000, "vehicle", "SKIPSAVE"],
	["Van Transport", "C_Van_02_transport_F", 1000, "vehicle", "SKIPSAVE"],
	["Van Police Cargo", "B_GEN_Van_02_vehicle_F", 1250, "vehicle", "SKIPSAVE"],
	["Van Police Transport", "B_GEN_Van_02_transport_F", 1250, "vehicle", "SKIPSAVE"],
	["Van Ambulance", "C_Van_02_medevac_F", 1500, "vehicle", "SKIPSAVE"],
	["Van Repair", "C_Van_02_service_F", 2000, "vehicle", "SKIPSAVE"],

	["HEMTT Tractor", "B_Truck_01_mover_F", 4000, "vehicle"],
	["HEMTT Resupply", "B_Truck_01_ammo_F", 5000, "vehicle"],
	//["HEMTT Box", "B_Truck_01_box_F", 5000, "vehicle"],
	["HEMTT Transport", "B_Truck_01_transport_F", 6000, "vehicle"],
	["HEMTT Covered", "B_Truck_01_covered_F", 7000, "vehicle"],
	["HEMTT Fuel", "B_Truck_01_fuel_F", 8000, "vehicle"],
	["HEMTT Medical", "B_Truck_01_medical_F", 9000, "vehicle"],
	["HEMTT Repair", "B_Truck_01_Repair_F", 10000, "vehicle"],

	["Tempest Device", "O_Truck_03_device_F", 4000, "vehicle"],
	["Tempest Resupply", "O_Truck_03_ammo_F", 5000, "vehicle"],
	["Tempest Transport", "O_Truck_03_transport_F", 6000, "vehicle"],
	["Tempest Covered", "O_Truck_03_covered_F", 7000, "vehicle"],
	["Tempest Fuel", "O_Truck_03_fuel_F", 8000, "vehicle"],
	["Tempest Medical", "O_Truck_03_medical_F", 9000, "vehicle"],
	["Tempest Repair", "O_Truck_03_repair_F", 10000, "vehicle"],

	["Zamak Resupply", "I_Truck_02_ammo_F", 4000, "vehicle"],
	["Zamak Transport", "I_Truck_02_transport_F", 4500, "vehicle"],
	["Zamak Covered", "I_Truck_02_covered_F", 5000, "vehicle"],
	["Zamak Fuel", "I_Truck_02_fuel_F", 6000, "vehicle"],
	["Zamak Medical", "I_Truck_02_medical_F", 7000, "vehicle"],
	["Zamak Repair", "I_Truck_02_box_F", 8000, "vehicle"],

	["UGV Stomper (NATO)", "B_UGV_01_F", 2500, "vehicle"],
	["UGV Stomper RCWS (NATO)", "B_UGV_01_rcws_F", 15000, "vehicle"],
	["UGV Stomper (AAF)", "I_UGV_01_F", 2500, "vehicle"],
	["UGV Stomper RCWS (AAF)", "I_UGV_01_rcws_F", 15000, "vehicle"],
	["UGV Saif (CSAT)", "O_UGV_01_F", 2500, "vehicle"],
	["UGV Saif RCWS (CSAT)", "O_UGV_01_rcws_F", 15000, "vehicle"]
];

armoredArray = compileFinal str
[
	["Prowler (Doorless)", "B_CTRG_LSV_01_light_F", 1500, "vehicle", "SKIPSAVE"],
	["Prowler", "B_T_LSV_01_unarmed_F", 2000, "vehicle", "SKIPSAVE"],
	["Prowler HMG", "B_T_LSV_01_armed_F", 6000, "vehicle", "SKIPSAVE"],
	["Qilin", "O_T_LSV_02_unarmed_F", 2000, "vehicle", "SKIPSAVE"],
	["Qilin Minigun", "O_T_LSV_02_armed_F", 6000, "vehicle", "SKIPSAVE"],

	["Hunter", "B_MRAP_01_F", 4000, "vehicle", "SKIPSAVE"],
	["Hunter HMG", "B_MRAP_01_hmg_F", 15000, "vehicle"],
	["Hunter GMG", "B_MRAP_01_gmg_F", 17500, "vehicle"],
	["Ifrit", "O_MRAP_02_F", 4000, "vehicle", "SKIPSAVE"],
	["Ifrit HMG", "O_MRAP_02_hmg_F", 15000, "vehicle"],
	["Ifrit GMG", "O_MRAP_02_gmg_F", 17500, "vehicle"],
	["Strider", "I_MRAP_03_F", 4000, "vehicle", "SKIPSAVE"],
	["Strider HMG", "I_MRAP_03_hmg_F", 15000, "vehicle"],
	["Strider GMG", "I_MRAP_03_gmg_F", 17500, "vehicle"],
	["MSE-3 Marid", "O_APC_Wheeled_02_rcws_F", 22500, "vehicle"],
	["AMV-7 Marshall", "B_APC_Wheeled_01_cannon_F", 27500, "vehicle"],
	["AFV-4 Gorgon", "I_APC_Wheeled_03_cannon_F", 30000, "vehicle"]
];

tanksArray = compileFinal str
[
	["CRV-6e Bobcat (Resupply)", "B_APC_Tracked_01_CRV_F", 32500, "vehicle"],
	["IFV-6c Panther", "B_APC_Tracked_01_rcws_F", 35000, "vehicle"],
	["FV-720 Mora", "I_APC_tracked_03_cannon_F", 37500, "vehicle"],
	["BTR-K Kamysh", "O_APC_Tracked_02_cannon_F", 40000, "vehicle"],
	["IFV-6a Cheetah AA", "B_APC_Tracked_01_AA_F", 40000, "vehicle"],
	["ZSU-39 Tigris AA", "O_APC_Tracked_02_AA_F", 40000, "vehicle"],
	["M2A1 Slammer", "B_MBT_01_cannon_F", 50000, "vehicle"],
	["M2A4 Slammer HMG", "B_MBT_01_TUSK_F", 50000, "vehicle"], // Commander gun variant
	["T-100 Varsuk", "O_MBT_02_cannon_F", 50000, "vehicle"],
	["MBT-52 Kuma", "I_MBT_03_cannon_F", 50000, "vehicle"]
];

helicoptersArray = compileFinal str
[
	["Hexacopter Demining UAV", "C_IDAP_UAV_06_antimine_F", (call genItemArray) select {_x select 1 == "C_IDAP_UAV_06_antimine_backpack_F"} select 0 select 2, "vehicle", "HIDDEN"], // for resupply price

	["M-900 Civilian", "C_Heli_Light_01_civil_F", 4000, "vehicle"], // MH-6, no flares
	["MH-9 Hummingbird", "B_Heli_Light_01_F", 5000, "vehicle"], // MH-6
	["PO-30 Orca (Unarmed)", "O_Heli_Light_02_unarmed_F", 6000, "vehicle"], // Ka-60
	["WY-55 Hellcat (Unarmed)", "I_Heli_light_03_unarmed_F", 7000, "vehicle"], // AW159
	["CH-49 Mohawk", "I_Heli_Transport_02_F", 8000, "vehicle"], // AW101

	["Mi-290 Taru (Resupply)", "O_Heli_Transport_04_ammo_F", 7500, "vehicle"],
	["Mi-290 Taru (Crane)", "O_Heli_Transport_04_F", 7500, "vehicle"], // CH-54
	["Mi-290 Taru (Box)", "O_Heli_Transport_04_box_F", 8000, "vehicle"],
	["Mi-290 Taru (Fuel)", "O_Heli_Transport_04_fuel_F", 8500, "vehicle"],
	["Mi-290 Taru (Bench)", "O_Heli_Transport_04_bench_F", 9000, "vehicle"],
	["Mi-290 Taru (Transport)", "O_Heli_Transport_04_covered_F", 9500, "vehicle"],
	["Mi-290 Taru (Medical)", "O_Heli_Transport_04_medevac_F", 12500, "vehicle"],
	["Mi-290 Taru (Repair)", "O_Heli_Transport_04_repair_F", 15000, "vehicle"],

	["CH-67 Huron (Unarmed)", "B_Heli_Transport_03_unarmed_F", 10000, "vehicle"], // CH-47
	["CH-67 Huron (Armed)", "B_Heli_Transport_03_F", 20000, "vehicle"], // CH-47 with 2 side miniguns

	["UH-80 Ghost Hawk", "B_Heli_Transport_01_F", 12500, "vehicle"], // UH-60 Stealth with 2 side miniguns
	["AH-9 Pawnee (Gun-Only)", "B_Heli_Light_01_dynamicLoadout_F", 15000, "vehicle", "variant_pawneeGun"], // Armed AH-6 (no missiles)
	["AH-9 Pawnee", "B_Heli_Light_01_dynamicLoadout_F", 35000, "vehicle", "variant_pawneeNormal"], // Armed AH-6
	["PO-30 Orca (DAR)", "O_Heli_Light_02_dynamicLoadout_F", 30000, "vehicle", "variant_orcaDAR"], // Armed Ka-60
	["PO-30 Orca (DAGR)", "O_Heli_Light_02_dynamicLoadout_F", 40000, "vehicle", "variant_orcaDAGR"], // Armed Ka-60, add "HIDDEN" if you don't want it, but don't remove the line!
	["WY-55 Hellcat (Armed)", "I_Heli_light_03_dynamicLoadout_F", 40000, "vehicle"], // Armed AW159
	["AH-99 Blackfoot", "B_Heli_Attack_01_dynamicLoadout_F", 50000, "vehicle"], // RAH-66 with gunner
	["Mi-48 Kajman", "O_Heli_Attack_02_dynamicLoadout_F", 60000, "vehicle"], // Mi-28 with gunner 

	["MQ-12 Falcon UAV", "B_T_UAV_03_F", 50000, "vehicle"] // Do NOT use "B_T_UAV_03_dynamicLoadout_F" (doesn't support ASRAAM pylons)
];

planesArray = compileFinal str
[
	["Caesar BTT", "C_Plane_Civil_01_F", 2500, "vehicle"],

	["A-143 Buzzard AA", "I_Plane_Fighter_03_dynamicLoadout_F", 40000, "vehicle", "variant_buzzardAA"],
	["A-143 Buzzard CAS", "I_Plane_Fighter_03_dynamicLoadout_F", 50000, "vehicle", "variant_buzzardCAS"],

	["A-149 Gryphon", "I_Plane_Fighter_04_F", 50000, "vehicle"],

	["F/A-181 Black Wasp (Gun-Only)", "B_Plane_Fighter_01_Stealth_F", 20000, "vehicle"], // no missiles or bombs
	["F/A-181 Black Wasp", "B_Plane_Fighter_01_F", 65000, "vehicle"],

	["To-201 Shikra (Gun-Only)", "O_Plane_Fighter_02_Stealth_F", 25000, "vehicle"], // no missiles or bombs
	["To-201 Shikra", "O_Plane_Fighter_02_F", 75000, "vehicle"],

	["A-164 Wipeout CAS", "B_Plane_CAS_01_dynamicLoadout_F", 75000, "vehicle"],
	["To-199 Neophron CAS", "O_Plane_CAS_02_dynamicLoadout_F", 75000, "vehicle"],

	["V-44 X Blackfish (Infantry)", "B_T_VTOL_01_infantry_F", 10000, "vehicle"],
	["V-44 X Blackfish (Gunship)", "B_T_VTOL_01_armed_F", 60000, "vehicle"],
	["Y-32 Xi'an", "O_T_VTOL_02_infantry_dynamicLoadout_F", 60000, "vehicle"],

	["KH-3A Fenghuang Missile UAV", "O_T_UAV_04_CAS_F", 30000, "vehicle"],

	["MQ4A Greyhawk Missile UAV", "B_UAV_02_dynamicLoadout_F", 30000, "vehicle", "variant_greyhawkMissile"],
	["K40 Ababil-3 Missile UAV", "O_UAV_02_dynamicLoadout_F", 30000, "vehicle", "variant_greyhawkMissile"],
	["K40 Ababil-3 Missile UAV", "I_UAV_02_dynamicLoadout_F", 30000, "vehicle", "variant_greyhawkMissile"],

	["MQ4A Greyhawk Bomber UAV", "B_UAV_02_dynamicLoadout_F", 15000, "vehicle", "variant_greyhawkBomber"], // Bomber UAVs are a lot harder to use, hence why they are cheaper than Missile ones
	["K40 Ababil-3 Bomber UAV", "O_UAV_02_dynamicLoadout_F", 15000, "vehicle", "variant_greyhawkBomber"],
	["K40 Ababil-3 Bomber UAV", "I_UAV_02_dynamicLoadout_F", 15000, "vehicle", "variant_greyhawkBomber"],

	["MQ4A Greyhawk Cluster UAV", "B_UAV_02_dynamicLoadout_F", 20000, "vehicle", "variant_greyhawkCluster"],
	["K40 Ababil-3 Cluster UAV", "O_UAV_02_dynamicLoadout_F", 20000, "vehicle", "variant_greyhawkCluster"],
	["K40 Ababil-3 Cluster UAV", "I_UAV_02_dynamicLoadout_F", 20000, "vehicle", "variant_greyhawkCluster"],

	["MQ4A Greyhawk DAGR UAV", "B_UAV_02_dynamicLoadout_F", 60000, "vehicle", "variant_greyhawkDAGR"],
	["K40 Ababil-3 DAGR UAV", "O_UAV_02_dynamicLoadout_F", 60000, "vehicle", "variant_greyhawkDAGR"],
	["K40 Ababil-3 DAGR UAV", "I_UAV_02_dynamicLoadout_F", 60000, "vehicle", "variant_greyhawkDAGR"],

	["UCAV Sentinel Missile", "B_UAV_05_F", 40000, "vehicle", "variant_sentinelMissile"],
	["UCAV Sentinel Bomber", "B_UAV_05_F", 20000, "vehicle", "variant_sentinelBomber"],
	["UCAV Sentinel Cluster", "B_UAV_05_F", 25000, "vehicle", "variant_sentinelCluster"]
];

boatsArray = compileFinal str
[
	["Water Scooter", "C_Scooter_Transport_01_F", 500, "boat", "SKIPSAVE"],

	["Rescue Boat", "C_Rubberboat", 500, "boat", "SKIPSAVE"],
	["Rescue Boat (NATO)", "B_Lifeboat", 500, "boat", "SKIPSAVE"],
	["Rescue Boat (CSAT)", "O_Lifeboat", 500, "boat", "SKIPSAVE"],
	["Assault Boat (NATO)", "B_Boat_Transport_01_F", 600, "boat", "SKIPSAVE"],
	["Assault Boat (CSAT)", "O_Boat_Transport_01_F", 600, "boat", "SKIPSAVE"],
	["Assault Boat (AAF)", "I_Boat_Transport_01_F", 600, "boat", "SKIPSAVE"],
	["Assault Boat (FIA)", "B_G_Boat_Transport_01_F", 600, "boat", "SKIPSAVE"],
	["Motorboat", "C_Boat_Civil_01_F", 1000, "boat", "SKIPSAVE"],
	["Motorboat Rescue", "C_Boat_Civil_01_rescue_F", 900, "boat", "SKIPSAVE"],
	["Motorboat Police", "C_Boat_Civil_01_police_F", 1100, "boat", "SKIPSAVE"],

	["RHIB", "I_C_Boat_Transport_02_F", 1250, "boat", "SKIPSAVE"],

	["Speedboat HMG (CSAT)", "O_Boat_Armed_01_hmg_F", 4000, "boat", "SKIPSAVE"],
	["Speedboat Minigun (NATO)", "B_Boat_Armed_01_minigun_F", 4000, "boat", "SKIPSAVE"],
	["Speedboat Minigun (AAF)", "I_Boat_Armed_01_minigun_F", 4000, "boat", "SKIPSAVE"],
	["SDV Submarine (NATO)", "B_SDV_01_F", 1000, "submarine", "SKIPSAVE"],
	["SDV Submarine (CSAT)", "O_SDV_01_F", 1000, "submarine", "SKIPSAVE"],
	["SDV Submarine (AAF)", "I_SDV_01_F", 1000, "submarine", "SKIPSAVE"]
];

allVehStoreVehicles = compileFinal str (call landArray + call armoredArray + call tanksArray + call helicoptersArray + call planesArray + call boatsArray);

uavArray = compileFinal str
[
	// Deprecated
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
_wreckDir = "\A3\structures_f\wrecks\data\";
_gorgonDir = "\A3\armor_f_gamma\APC_Wheeled_03\data\";

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
			["Confederate", _texDir + "confederate.paa"],
			["Denim", _texDir + "denim.paa"],
			["Digital", _texDir + "digi.paa"],
			["Digital Black", _texDir + "digi_black.paa"],
			["Digital Desert", _texDir + "digi_desert.paa"],
			["Digital Woodland", _texDir + "digi_wood.paa"],
			["Doritos", _texDir + "doritos.paa"],
			["Drylands", _texDir + "drylands.paa"],
			["Hello Kitty", _texDir + "hellokitty.paa"],
			["Hex", _texDir + "hex.paa"],
			["Hippie", _texDir + "hippie.paa"],
			["ISIS", _texDir + "isis.paa"],
			["Leopard", _texDir + "leopard.paa"],
			["Mountain Dew", _texDir + "mtndew.paa"],
			["'Murica", _texDir + "murica.paa"],
			["Nazi", _texDir + "nazi.paa"],
			["Orange Camo", _texDir + "camo_orange.paa"],
			["Pink Camo", _texDir + "camo_pink.paa"],
			["Pride", _texDir + "pride.paa"],
			["Psych", _texDir + "psych.paa"],
			["Red Camo", _texDir + "camo_red.paa"],
			["Rusty", _texDir + "rusty.paa"],
			["Sand", _texDir + "sand.paa"],
			["Snake", _texDir + "snake.paa"],
			["Stripes", _texDir + "stripes.paa"],
			["Stripes 2", _texDir + "stripes2.paa"],
			["Stripes 3", _texDir + "stripes3.paa"],
			["Swamp", _texDir + "swamp.paa"],
			["Tiger", _texDir + "tiger.paa"],
			["Trippy", _texDir + "rainbow.paa"],
			["Union Jack", _texDir + "unionjack.paa"],
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
			["Bluking (Kart)", ["Bluking"]],
			["Fuel (Kart)", ["Fuel"]],
			["Redstone (Kart)", ["Redstone"]],
			["Vrana (Kart)", ["Vrana"]],
			["Black (Kart)", ["Black"]], // ["Black (Kart)", [configName (configFile >> "CfgVehicles" >> "C_Kart_01_F" >> "TextureSources" >> "Black")]],
			["White (Kart)", ["White"]],
			["Blue (Kart)", ["Blue"]],
			["Green (Kart)", ["Green"]],
			["Yellow (Kart)", ["Yellow"]],
			["Orange (Kart)", ["Orange"]],
			["Red (Kart)", [[0, _kartDir + "kart_01_base_red_co.paa"]]] // no red TextureSource :(
		]
	],
	[ // Ambulance color
		"Van_02_medevac_base_F",
		[
			["IDAP Ambulance (Van)", ["IdapAmbulance"]]
		]
	],
	[ // Van colors
		"Van_02_base_F",
		[
			["AAN News (Van)", ["AAN"]],
			["Battle Bus (Van)", ["BattleBus"]],
			["Black (Van)", ["Black"]],
			["Blue (Van)", ["Blue"]],
			["Blue Pearl (Van)", ["BluePearl"]],
			["Daltgreen (Van)", ["Daltgreen"]],
			["Dazzle (Van)", ["Masked"]],
			["Guerilla 1 (Van)", ["FIA1"]],
			["Guerilla 2 (Van)", ["FIA2"]],
			["Guerilla 3 (Van)", ["FIA3"]],
			["Fuel (Van)", ["Fuel"]],
			["Green (Van)", ["Green"]],
			["IDAP (Van)", ["IDAP"]],
			["Orange (Van)", ["Orange"]],
			["Port Authority (Van)", ["CivService"]],
			["Red (Van)", ["Red"]],
			["Redstone (Van)", ["Redstone"]],
			["Swifd (Van)", ["Swifd"]],
			["Syndikat (Van)", ["Syndikat"]],
			["Vrana (Van)", ["Vrana"]],
			["White (Van)", ["White"]]
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
			]],
			["IDAP (Mohawk)", [
				[0, "\A3\air_f_orange\heli_transport_02\data\heli_transport_02_1_idap_co.paa"],
				[1, "\A3\air_f_orange\heli_transport_02\data\heli_transport_02_2_idap_co.paa"],
				[2, "\A3\air_f_orange\heli_transport_02\data\heli_transport_02_3_idap_co.paa"],
				[3, "\A3\air_f_orange\heli_transport_02\data\heli_transport_02_int_02_idap_co.paa"]
			]]
		]
	],
	[ // Armed Orca paintjob
		"Heli_Light_02_dynamicLoadout_base_F",
		[
			["Orca (Orca)", ["Blackcustom"]]
		]
	],
	[ // Orca paintjob
		"Heli_Light_02_base_F",
		[
			["Blue (Orca)", ["Blue"]]
		]
	],
	[ // Taru paintjob
		"Heli_Transport_04_base_F",
		[
			["Black (Taru)", ["Black"]]
		]
	],
	[ // Blackfoot paintjob
		"Heli_Attack_01_base_F",
		[
			["Rusty (Blackfoot)", [[0, _wreckDir + "wreck_heli_attack_01_co.paa"]]]
		]
	],
	[ // Kajman paintjobs
		"Heli_Attack_02_base_F",
		[
			["Black (Kajman)", ["Black"]],
			["Rusty (Kajman)", [
				[0, _wreckDir + "wreck_heli_attack_02_body1_co.paa"],
				[1, _wreckDir + "wreck_heli_attack_02_body2_co.paa"]
			]],
			["Mossy (Kajman)", [
				[0, _wreckDir + "uwreck_heli_attack_02_body1_co.paa"],
				[1, _wreckDir + "uwreck_heli_attack_02_body2_co.paa"]
			]]
		]
	],
	[ // Ghost Hawk camo
		"Heli_Transport_01_base_F",
		[
			//["Black (Ghost Hawk)", ["Black"]], // default
			["Olive (Ghost Hawk)", ["Green"]],
			["Dazzle Black (Ghost Hawk)", ["Olive"]],
			["Dazzle Tan (Ghost Hawk)", ["Sand"]]
		]
	],
	[ // Zamak paintjobs
		"Truck_02_base_F",
		[
			//["AAF (Zamak)", ["Indep"]], // default
			["Hex (Zamak)", ["Opfor"]],
			["Orange (Zamak)", ["Orange"]]
		]
	],
	[ // Strider NATO color
		"MRAP_03_base_F",
		[
			["Tan (Strider)", ["Blufor"]]
		]
	],
	[ // Gorgon paintjobs
		"APC_Wheeled_03_base_F",
		[
			["Guerilla 1 (Gorgon)", ["Guerilla_01"]],
			["Guerilla 2 (Gorgon)", ["Guerilla_02"]],
			["Guerilla 3 (Gorgon)", ["Guerilla_03"]],
			["Tan (Gorgon)", [
				[0, _gorgonDir + "apc_wheeled_03_ext_co.paa"],
				[1, _gorgonDir + "apc_wheeled_03_ext2_co.paa"],
				[2, _gorgonDir + "rcws30_co.paa"],
				[3, _gorgonDir + "apc_wheeled_03_ext_alpha_co.paa"]
			]]
		]
	],
	[ // Hatchback wreck paintjob
		"Hatchback_01_base_F",
		[
			["Rusty (Hatchback)", [[0, _wreckDir + "civilcar_extwreck_co.paa"]]]
		]
	],
	[ // GOD EMPEROR
		"B_MBT_01_cannon_F",
		[
			["Trump (Slammer)", [
				[0, _texDir + "slammer_trump_0.paa"],
				[1, _texDir + "slammer_trump_1.paa"]
			]]
		]
	],
	[
		"B_MBT_01_TUSK_F",
		[
			["Trump (Slammer)", [[2, _texDir + "slammer_trump_2.paa"]]]
		]
	],
	[ // RHIB paintjob
		"Boat_Transport_02_base_F",
		[
			["Civilian (RHIB)", ["Civilian"]]
		]
	],
	[ // Prowler paintjobs
		"LSV_01_base_F",
		[
			["Olive (Prowler)", ["Olive"]],
			["Dazzle (Prowler)", ["Dazzle"]],
			["Black (Prowler)", ["Black"]],
			["Tan (Prowler)", ["Sand"]]
		]
	],
	[ // Qilin paintjobs
		"LSV_02_base_F",
		[
			//["Green Hex (Qilin)", ["GreenHex"]], // default
			["Hex (Qilin)", ["Arid"]],
			["Black (Qilin)", ["Black"]]
		]
	],
	[ // Blackfish paintjobs
		"VTOL_01_base_F",
		[
			//["Olive (Blackfish)", ["Olive"]], // default
			["Blue (Blackfish)", ["Blue"]]
		]
	],
	[ // Xi'an paintjobs
		"VTOL_02_base_F",
		[
			//["Green Hex (Xi'an)", ["GreenHex"]], // default
			["Hex (Xi'an)", ["Hex"]],
			["Gray Hex (Xi'an)", ["Grey"]]
		]
	],
	[ // Black Wasp paintjob
		"Plane_Fighter_01_Base_F",
		[
			["Grey Camo (Black Wasp)", ["DarkGreyCamo"]]
		]
	],
	[ // Shikra paintjobs
		"Plane_Fighter_02_Base_F",
		[
			["Grey Hex (Shikra)", ["CamoGreyHex"]],
			["Russian Blue (Shikra)", ["CamoBlue"]]
		]
	],
	[ // Gryphon paintjobs
		"Plane_Fighter_04_Base_F",
		[
			["Grey (Gryphon)", ["CamoGrey"]],
			["Digital Grey (Gryphon)", ["DigitalCamoGrey"]]
		]
	],
	[ // Sentinel paintjob
		"UAV_05_Base_F",
		[
			["Grey Camo (Sentinel)", ["DarkGreyCamo"]]
		]
	],
	[ // UGV paintjobs
		"UGV_01_base_F",
		[
			["Tan (UGV)", ["Blufor"]],
			["Hex (UGV)", ["Opfor"]],
			["Digital (UGV)", ["Indep"]],
			["Green Hex (UGV)", ["GreenHex"]]
		]
	],
	[ // Ifrit GreenHex
		"MRAP_02_base_F",
		[
			["Green Hex (Ifrit)", ["GreenHex"]]
		]
	],
	[ // Tempest GreenHex
		"Truck_03_base_F",
		[
			["Green Hex (Tempest)", ["GreenHex"]]
		]
	],
	[ // Marid GreenHex
		"APC_Wheeled_02_base_F",
		[
			["Green Hex (Marid)", ["GreenHex"]]
		]
	],
	[ // Kamysh & Tigris GreenHex
		"APC_Tracked_02_base_F",
		[
			["Green Hex (Kamysh)", ["GreenHex"]]
		]
	],
	[ // Varsuk & Sochor GreenHex
		"MBT_02_base_F",
		[
			["Green Hex (Varsuk)", ["GreenHex"]]
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
	["Repair Kit", "repairkit", localize "STR_WL_ShopDescriptions_RepairKit", "client\icons\briefcase.paa", 500, 250],
	["Jerry Can (Full)", "jerrycanfull", localize "STR_WL_ShopDescriptions_fuelFull", "client\icons\jerrycan.paa", 150, 75],
	["Jerry Can (Empty)", "jerrycanempty", localize "STR_WL_ShopDescriptions_fuelEmpty", "client\icons\jerrycan.paa", 50, 25],
	["Spawn Beacon", "spawnbeacon", localize "STR_WL_ShopDescriptions_spawnBeacon", "client\icons\spawnbeacon.paa", 1500, 750],
	["Camo Net", "camonet", localize "STR_WL_ShopDescriptions_Camo", "client\icons\camonet.paa", 200, 100],
	["Syphon Hose", "syphonhose", localize "STR_WL_ShopDescriptions_SyphonHose", "client\icons\syphonhose.paa", 200, 100],
	["Energy Drink", "energydrink", localize "STR_WL_ShopDescriptions_Energy_Drink", "client\icons\energydrink.paa", 100, 50],
	["Warchest", "warchest", localize "STR_WL_ShopDescriptions_Warchest", "client\icons\warchest.paa", 1000, 500]
];

call compile preprocessFileLineNumbers "mapConfig\storeOwners.sqf";

storeConfigDone = compileFinal "true";
