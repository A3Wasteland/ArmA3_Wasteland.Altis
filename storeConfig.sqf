/*********************************************************#
# @@ScriptName: storeConfig.sqf
# @@Author: His_Shadow, AgentRev
# @@Create Date: 2013-09-16 20:40:58
#*********************************************************/

// This tracks which store owner the client is interacting with
currentOwnerName = "";

// Gunstore Weapon List - Gun Store Base List
// Text name, classname, buy cost

pistolArray = compileFinal str
[
	// Handguns
	["P07 Pistol", "hgun_P07_F", 50],
	["Rook-40 Pistol", "hgun_Rook40_F", 50],
	["ACP-C2 Pistol", "hgun_ACPC2_F", 75],
	["Zubr Revolver", "hgun_Pistol_heavy_02_F", 75],
	["4-Five Pistol", "hgun_Pistol_heavy_01_F", 100]
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
	["Mk20 Carbine", "arifle_Mk20C_F", 150],
	["Mk20 Carbine (Tan)", "arifle_Mk20C_plain_F", 150],
	["Mk20 Rifle", "arifle_Mk20_F", 200],
	["Mk20 Rifle (Tan)", "arifle_Mk20_plain_F", 200],
	["Mk20 EGLM Rifle", "arifle_Mk20_GL_F", 250],
	["Mk20 EGLM Rifle (Tan)", "arifle_Mk20_GL_plain_F", 250],

	["TRG-20 Carbine", "arifle_TRG20_F", 150],
	["TRG-21 Rifle ", "arifle_TRG21_F", 200],
	["TRG-21 EGLM Rifle", "arifle_TRG21_GL_F", 250],

	["Katiba Carbine", "arifle_Katiba_C_F", 150],
	["Katiba Rifle", "arifle_Katiba_F", 200],
	["Katiba GL Rifle", "arifle_Katiba_GL_F", 250],

	["MX Carbine", "arifle_MXC_F", 150],
	["MX Carbine (Black)", "arifle_MXC_Black_F", 150],
	["MX Rifle", "arifle_MX_F", 200],
	["MX Rifle (Black)", "arifle_MX_Black_F", 200],
	["MX 3GL Rifle", "arifle_MX_GL_F", 250],
	["MX 3GL Rifle (Black)", "arifle_MX_GL_Black_F", 250],

	// Markman Rifles
	["MXM Rifle", "arifle_MXM_F", 300],
	["MXM Rifle (Black)", "arifle_MXM_Black_F", 300],
	["DMR Rifle", "srifle_DMR_01_F", 350],
	["Mk18 ABR Rifle", "srifle_EBR_F", 400],

	// Sniper Rifles
	["M320 LRR Sniper", "srifle_LRR_SOS_F", 1000],
	["GM6 Lynx Sniper", "srifle_GM6_SOS_F", 1000]
];

lmgArray = compileFinal str
[
	["MX SW LMG", "arifle_MX_SW_F", 300],
	["MX SW LMG (Black)", "arifle_MX_SW_Black_F", 300],
	["Mk200 LMG", "LMG_Mk200_F", 350],
	["Zafir LMG", "LMG_Zafir_F", 400]
];

shotgunArray = compileFinal str
[
	// Currently unused
];

launcherArray = compileFinal str
[
	["RPG-42 Alamut", "launch_RPG32_F", 400],
	["PCML", "launch_NLAW_F", 500],
	["Titan MPRL Compact", "launch_Titan_short_F", 600],
	["Titan MPRL AA", "launch_Titan_F", 600]
];

allGunStoreFirearms = compileFinal str (call pistolArray + call smgArray + call rifleArray + call lmgArray + call shotgunArray + call launcherArray);

staticGunsArray = compileFinal str
[
	["Vehicle Ammo Crate", "Box_NATO_AmmoVeh_F", 2500],
	["Static Titan AT 4Rnd (NATO)", "B_static_AT_F", 4000], // Static launchers only have 4 ammo, hence the lower price
	["Static Titan AT 4Rnd (CSAT)", "O_static_AT_F", 4000],
	["Static Titan AT 4Rnd (AAF)", "I_static_AT_F", 4000],
	["Static Titan AA 4Rnd (NATO)", "B_static_AA_F", 4500],
	["Static Titan AA 4Rnd (CSAT)", "O_static_AA_F", 4500],
	["Static Titan AA 4Rnd (AAF)", "I_static_AA_F", 4500],
	["Mk30 HMG .50 Low tripod (NATO)", "B_HMG_01_F", 5000],
	["Mk30 HMG .50 Low tripod (CSAT)", "O_HMG_01_F", 5000],
	["Mk30 HMG .50 Low tripod (AAF)", "I_HMG_01_F", 5000],
	// ["Mk30A HMG .50 (NATO)", "B_HMG_01_A_F", 5300], // "A" = Autonomous = Overpowered
	// ["Mk30A HMG .50 (CSAT)", "O_HMG_01_A_F", 5300],
	// ["Mk30A HMG .50 (AAF)", "I_HMG_01_A_F", 5300],
	["Mk30 HMG .50 High tripod (NATO)", "B_HMG_01_high_F", 5500],
	["Mk30 HMG .50 High tripod (CSAT)", "O_HMG_01_high_F", 5500],
	["Mk30 HMG .50 High tripod (AAF)", "I_HMG_01_high_F", 5500],
	["Mk32 GMG 20mm Low tripod (NATO)", "B_GMG_01_F", 7500],
	["Mk32 GMG 20mm Low tripod (CSAT)", "O_GMG_01_F", 7500],
	["Mk32 GMG 20mm Low tripod (AAF)", "I_GMG_01_F", 7500],
	// ["Mk32A GMG 20mm (NATO)", "B_GMG_01_A_F", 7700],
	// ["Mk32A GMG 20mm (CSAT)", "O_GMG_01_A_F", 7700],
	// ["Mk32A GMG 20mm (AAF)", "I_GMG_01_A_F", 7700],
	["Mk32 GMG 20mm High tripod (NATO)", "B_GMG_01_high_F", 8000],
	["Mk32 GMG 20mm High tripod (CSAT)", "O_GMG_01_high_F", 8000],
	["Mk32 GMG 20mm High tripod (AAF)", "I_GMG_01_high_F", 8000],
	["Mk6 Mortar (NATO)", "B_Mortar_01_F", 12500],
	["Mk6 Mortar (CSAT)", "O_Mortar_01_F", 12500],
	["Mk6 Mortar (AAF)", "I_Mortar_01_F", 12500]
];

throwputArray = compileFinal str
[
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
	["9mm 16Rnd Mag", "16Rnd_9x21_Mag", 10],
	["9mm 30Rnd Mag", "30Rnd_9x21_Mag", 20],
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
	["6.5mm 200Rnd Tracer (Green) Belt Case", "200Rnd_65x39_cased_Box_Tracer", 125],
	["7.62mm 10Rnd Mag", "10Rnd_762x51_Mag", 15],
	["7.62mm 20Rnd Mag", "20Rnd_762x51_Mag", 25],
	["7.62mm 150Rnd Box", "150Rnd_762x51_Box", 150],
	["7.62mm 150Rnd Tracer (Green) Box", "150Rnd_762x51_Box_Tracer", 125],
	[".408 7Rnd Cheetah Mag", "7Rnd_408_Mag", 50],
	["12.7mm 5Rnd Mag", "5Rnd_127x108_Mag", 50],
	["12.7mm 5Rnd APDS Mag", "5Rnd_127x108_APDS_Mag", 60],
	["RPG-42 AT Rocket", "RPG32_F", 250],              // Direct damage: high   | Splash damage: low    | Guidance: none
	["RPG-42 HE Rocket", "RPG32_HE_F", 250],           // Direct damage: medium | Splash damage: medium | Guidance: none
	["PCML Missile", "NLAW_F", 350],                   // Direct damage: high   | Splash damage: low    | Guidance: laser, land vehicles
	["Titan AT Missile", "Titan_AT", 350],             // Direct damage: high   | Splash damage: low    | Guidance: mouse, laser, land vehicles
	["Titan Antipersonnel Missile", "Titan_AP", 350],  // Direct damage: low    | Splash damage: high   | Guidance: mouse, laser
	["Titan AA Missile", "Titan_AA", 350],             // Direct damage: low    | Splash damage: high   | Guidance: aircraft
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
	["Suppressor 6.5mm", "muzzle_snds_H", 100, "item"],
	["Suppressor 6.5mm LMG", "muzzle_snds_H_MG", 125, "item"],
	["Suppressor 7.62mm", "muzzle_snds_B", 125, "item"],
	["Flashlight", "acc_flashlight", 25, "item"],
	["IR Laser Pointer", "acc_pointer_IR", 25, "item"],
	["Yorris Sight (Zubr Revolver)", "optic_Yorris", 50, "item"],
	["MRD Sight (4-Five Pistol)", "optic_MRD", 50, "item"],
	["ACO (CQB)", "optic_aco_smg", 50, "item"],
	["Holosight (CQB)", "optic_Holosight_smg", 50, "item"],
	["ACO (Red)", "optic_Aco", 75, "item"],
	["ACO (Green)", "optic_Aco_grn", 75, "item"],
	["Holosight", "optic_Holosight", 75, "item"],
	["MRCO", "optic_MRCO", 100, "item"],
	["ARCO", "optic_Arco", 125, "item"],
	["RCO", "optic_Hamr", 150, "item"],
	["DMS", "optic_DMS", 175, "item"],
	["LRPS", "optic_LRPS", 175, "item"],
	["SOS", "optic_SOS", 200, "item"],
	["NVS", "optic_NVS", 500, "item"],
	["TWS", "optic_tws", 1500, "item"],
	["TWS MG", "optic_tws_mg", 2000, "item"],
	["Nightstalker", "optic_Nightstalker", 2500, "item"]
];

// If commented, means the color/camo isn't implemented or is a duplicate of another hat
headArray = compileFinal str
[
	["ECH", "H_HelmetB", 50, "hat"],
	["ECH (Camo net)", "H_HelmetB_camo", 50, "hat"],
	["ECH (Light)", "H_HelmetB_light", 50, "hat"],
	// ["ECH (Spraypaint)", "H_HelmetB_paint", 50, "hat"],
	["SF Helmet", "H_HelmetSpecB", 50, "hat"],
	// ["SF Helmet (Black)", "H_HelmetSpecB_blk", 50, "hat"],
	// ["SF Helmet (Light Paint)", "H_HelmetSpecB_paint1", 50, "hat"],
	// ["SF Helmet (Dark Paint)", "H_HelmetSpecB_paint2", 50, "hat"],
	// ["Combat Helmet (Black)", "H_HelmetB_plain_blk", 50, "hat"],
	["Protector Helmet (Hex)", "H_HelmetO_ocamo", 50, "hat"],
	["Protector Helmet (Urban)", "H_HelmetO_oucamo", 50, "hat"],
	// ["Assassin Helmet (Hex)", "H_HelmetSpecO_ocamo", 50, "hat"],
	["Assassin Helmet (Black)", "H_HelmetSpecO_blk", 50, "hat"],
	// ["Defender Helmet (Hex)", "H_HelmetLeaderO_ocamo", 50, "hat"],
	// ["Defender Helmet (Urban)", "H_HelmetLeaderO_oucamo", 50, "hat"],
	["MICH", "H_HelmetIA", 50, "hat"],
	// ["MICH (Camo)", "H_HelmetIA_net", 50, "hat"],
	// ["MICH 2 (Camo)", "H_HelmetIA_camo", 50, "hat"],
	["Heli Crew Helmet (NATO)", "H_CrewHelmetHeli_B", 50, "hat"],
	["Heli Crew Helmet (CSAT)", "H_CrewHelmetHeli_O", 50, "hat"],
	["Heli Crew Helmet (AAF)", "H_CrewHelmetHeli_I", 50, "hat"],
	["Heli Pilot Helmet (NATO)", "H_PilotHelmetHeli_B", 50, "hat"],
	["Heli Pilot Helmet (CSAT)", "H_PilotHelmetHeli_O", 50, "hat"],
	["Heli Pilot Helmet (AAF)", "H_PilotHelmetHeli_I", 50, "hat"],
	["Crew Helmet (NATO)", "H_HelmetCrew_B", 50, "hat"],
	["Crew Helmet (CSAT)", "H_HelmetCrew_O", 50, "hat"],
	["Crew Helmet (AAF)", "H_HelmetCrew_I", 50, "hat"],
	["Pilot Helmet (NATO)", "H_PilotHelmetFighter_B", 50, "hat"],
	["Pilot Helmet (CSAT)", "H_PilotHelmetFighter_O", 50, "hat"],
	["Pilot Helmet (AAF)", "H_PilotHelmetFighter_I", 50, "hat"],
	["Military Cap (Blue)", "H_MilCap_blue", 25, "hat"],
	["Military Cap (Gray)", "H_MilCap_gry", 25, "hat"],
	["Military Cap (Urban)", "H_MilCap_oucamo", 25, "hat"],
	["Military Cap (Russia)", "H_MilCap_rucamo", 25, "hat"],
	["Military Cap (MTP)", "H_MilCap_mcamo", 25, "hat"],
	["Military Cap (Hex)", "H_MilCap_ocamo", 25, "hat"],
	["Military Cap (AAF)", "H_MilCap_dgtl", 25, "hat"],
	["Rangemaster Cap", "H_Cap_headphones", 25, "hat"],
	["Bandanna (Coyote)", "H_Bandanna_cbr", 10, "hat"],
	["Bandanna (Camo)", "H_Bandanna_camo", 10, "hat"],
	["Bandanna (Gray)", "H_Bandanna_gry", 10, "hat"],
	["Bandanna (Khaki)", "H_Bandanna_khk", 10, "hat"],
	["Bandanna (MTP)", "H_Bandanna_mcamo", 10, "hat"],
	["Bandanna (Sage)", "H_Bandanna_sgg", 10, "hat"],
	["Bandanna (Surfer)", "H_Bandanna_surfer", 10, "hat"],
	// ["Bandanna Mask (Black)", "H_BandMask_blk", 10, "hat"],
	// ["Bandanna Mask (Demon)", "H_BandMask_demon", 10, "hat"],
	// ["Bandanna Mask (Khaki)", "H_BandMask_khk", 10, "hat"],
	// ["Bandanna Mask (Reaper)", "H_BandMask_reaper", 10, "hat"],
	["Beanie (Black)", "H_Watchcap_blk", 10, "hat"],
	// ["Beanie (Camo)", "H_Watchcap_camo", 10, "hat"],
	// ["Beanie (Khaki)", "H_Watchcap_khk", 10, "hat"],
	// ["Beanie (Sage)", "H_Watchcap_sgg", 10, "hat"],
	["Beret (Black)", "H_Beret_blk", 10, "hat"],
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
	["Booniehat (Tan)", "H_Booniehat_tan", 10, "hat"],
	["Booniehat (MTP)", "H_Booniehat_mcamo", 10, "hat"],
	// ["Booniehat (Hex)", "H_Booniehat_khk", 10, "hat"],
	["Booniehat (Digi)", "H_Booniehat_dgtl", 10, "hat"],
	["Fedora (Blue)", "H_Hat_blue", 10, "hat"],
	["Fedora (Brown)", "H_Hat_brown", 10, "hat"],
	["Fedora (Camo)", "H_Hat_camo", 10, "hat"],
	["Fedora (Checker)", "H_Hat_checker", 10, "hat"],
	["Fedora (Gray)", "H_Hat_grey", 10, "hat"],
	["Fedora (Tan)", "H_Hat_tan", 10, "hat"],
	["Cap (Black)", "H_Cap_blk", 10, "hat"],
	["Cap (Blue)", "H_Cap_blu", 10, "hat"],
	["Cap (Green)", "H_Cap_grn", 10, "hat"],
	["Cap (Olive)", "H_Cap_oli", 10, "hat"],
	["Cap (Red)", "H_Cap_red", 10, "hat"],
	["Cap (Tan)", "H_Cap_tan", 10, "hat"],
	["Cap (BI)", "H_Cap_grn_BI", 10, "hat"],
	["Cap (CMMG)", "H_Cap_blk_CMMG", 10, "hat"],
	["Cap (ION)", "H_Cap_blk_ION", 10, "hat"],
	["Cap (Raven Security)", "H_Cap_blk_Raven", 10, "hat"],
	["Cap (SAS)", "H_Cap_khaki_specops_UK", 10, "hat"],
	["Cap (SF)", "H_Cap_tan_specops_US", 10, "hat"],
	["Cap (SPECOPS)", "H_Cap_brn_SPECOPS", 10, "hat"],
	// ["Shemag (Khaki)", "H_ShemagOpen_khk", 25, "hat"],
	["Shemag (Tan)", "H_ShemagOpen_tan", 25, "hat"],
	["Shemag mask (Khaki)", "H_Shemag_khk", 25, "hat"],
	["Shemag mask (Olive)", "H_Shemag_olive", 25, "hat"],
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
	["Ghillie Suit (NATO)", "U_B_GhillieSuit", 300, "uni"],
	["Ghillie Suit (CSAT)", "U_O_GhillieSuit", 300, "uni"],
	["Ghillie Suit (AAF)", "U_I_GhillieSuit", 300, "uni"],
	["Wetsuit (NATO)", "U_B_Wetsuit", 200, "uni"],
	["Wetsuit (CSAT)", "U_O_Wetsuit", 200, "uni"],
	["Wetsuit (AAF)", "U_I_Wetsuit", 200, "uni"],
	["Default Uniform (NATO)", "U_B_CombatUniform_mcam", 50, "uni"],
	["Default Uniform (CSAT)", "U_O_CombatUniform_ocamo", 50, "uni"],
	["Default Uniform (AAF)", "U_I_CombatUniform", 50, "uni"],
	["Combat Fatigues (MTP) (Tee)", "U_B_CombatUniform_mcam_tshirt", 50, "uni"],
	["Recon Fatigues (MTP)", "U_B_CombatUniform_mcam_vest", 50, "uni"],
	["Recon Fatigues (Sage)", "U_B_SpecopsUniform_sgg", 50, "uni"],
	["CTRG Combat Uniform (UBACS)", "U_B_CTRG_1", 50, "uni"],
	["CTRG Combat Uniform (UBACS2)", "U_B_CTRG_2", 50, "uni"],
	["CTRG Combat Uniform (Tee)", "U_B_CTRG_3", 50, "uni"],
	["Recon Fatigues (Hex)", "U_O_SpecopsUniform_ocamo", 50, "uni"],
	["Fatigues (Urban)", "U_O_CombatUniform_oucamo", 50, "uni"],
	["Combat Fatigues Short (Digi)", "U_I_CombatUniform_shortsleeve", 50, "uni"],
	["Combat Fatigues Shirt (Digi)", "U_I_CombatUniform_tshirt", 50, "uni"],
	["Officer Fatigues (Hex)", "U_O_OfficerUniform_ocamo", 50, "uni"],
	["Officer Fatigues (Digi)", "U_I_OfficerUniform", 50, "uni"],
	["Pilot Coveralls (NATO)", "U_B_PilotCoveralls", 50, "uni"],
	["Pilot Coveralls (CSAT)", "U_O_PilotCoveralls", 50, "uni"],
	["Pilot Coveralls (AAF)", "U_I_pilotCoveralls", 50, "uni"],
	["Heli Pilot Coveralls (NATO)", "U_B_HeliPilotCoveralls", 50, "uni"],
	["Heli Pilot Coveralls (AAF)", "U_I_HeliPilotCoveralls", 50, "uni"],
	["Guerilla Smocks 1", "U_BG_Guerilla1_1", 25, "uni"], // BLUFOR
	["Guerilla Smocks 2", "U_BG_Guerilla2_1", 25, "uni"],
	["Guerilla Smocks 3", "U_BG_Guerilla2_2", 25, "uni"],
	["Guerilla Smocks 4", "U_BG_Guerilla2_3", 25, "uni"],
	["Guerilla Smocks 5", "U_BG_Guerilla3_1", 25, "uni"],
	["Guerilla Smocks 6", "U_BG_Guerilla3_2", 25, "uni"],
	["Guerilla Smocks 7", "U_BG_leader", 25, "uni"],
	["Guerilla Smocks 1", "U_OG_Guerilla1_1", 25, "uni"], // OPFOR
	["Guerilla Smocks 2", "U_OG_Guerilla2_1", 25, "uni"],
	["Guerilla Smocks 3", "U_OG_Guerilla2_2", 25, "uni"],
	["Guerilla Smocks 4", "U_OG_Guerilla2_3", 25, "uni"],
	["Guerilla Smocks 5", "U_OG_Guerilla3_1", 25, "uni"],
	["Guerilla Smocks 6", "U_OG_Guerilla3_2", 25, "uni"],
	["Guerilla Smocks 7", "U_OG_leader", 25, "uni"],
	["Guerilla Smocks 1", "U_IG_Guerilla1_1", 25, "uni"], // Independent
	["Guerilla Smocks 2", "U_IG_Guerilla2_1", 25, "uni"],
	["Guerilla Smocks 3", "U_IG_Guerilla2_2", 25, "uni"],
	["Guerilla Smocks 4", "U_IG_Guerilla2_3", 25, "uni"],
	["Guerilla Smocks 5", "U_IG_Guerilla3_1", 25, "uni"],
	["Guerilla Smocks 6", "U_IG_Guerilla3_2", 25, "uni"],
	["Guerilla Smocks 7", "U_IG_leader", 25, "uni"],
	["Worker Coveralls", "U_C_WorkerCoveralls", 25, "uni"],
	["T-Shirt (Blue)", "U_C_Poor_1", 25, "uni"],
	["Polo (Red/white)", "U_C_Poloshirt_redwhite", 25, "uni"],
	["Polo (Salmon)", "U_C_Poloshirt_salmon", 25, "uni"],
	["Polo (Tri-color)", "U_C_Poloshirt_tricolour", 25, "uni"],
	["Polo (Navy)", "U_C_Poloshirt_blue", 25, "uni"],
	["Polo (Burgundy)", "U_C_Poloshirt_burgundy", 25, "uni"],
	["Polo (Blue/green)", "U_C_Poloshirt_stripped", 25, "uni"],
	["Polo (Competitor)", "U_Competitor", 25, "uni"],
	["Polo (Rangemaster)", "U_Rangemaster", 25, "uni"],
	["Racing Suit (Black)", "U_C_Driver_1_black", 25, "uni"],
	["Racing Suit (Blue)", "U_C_Driver_1_blue", 25, "uni"],
	["Racing Suit (Green)", "U_C_Driver_1_green", 25, "uni"],
	["Racing Suit (Yellow)", "U_C_Driver_1_yellow", 25, "uni"],
	["Racing Suit (Orange)", "U_C_Driver_1_orange", 25, "uni"],
	["Racing Suit (Red)", "U_C_Driver_1_red", 25, "uni"],
	["Racing Suit (White)", "U_C_Driver_1_white", 25, "uni"],
	["Racing Suit (Fuel)", "U_C_Driver_1", 25, "uni"],
	["Racing Suit (Bluking)", "U_C_Driver_2", 25, "uni"],
	["Racing Suit (Redstone)", "U_C_Driver_3", 25, "uni"],
	["Racing Suit (Vrana)", "U_C_Driver_4", 25, "uni"]
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
	["GA Carrier Lite (Digi)", "V_PlateCarrierIA1_dgtl", -1, "vest"],
	["GA Carrier Rig (Digi)", "V_PlateCarrierIA2_dgtl", -1, "vest"],
	["GA Carrier GL Rig (Digi)", "V_PlateCarrierIAGL_dgtl", -1, "vest"],
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
	["Raven Night Vest", "V_TacVestIR_blk", -1, "vest"]
];

backpackArray = compileFinal str
[
	["Parachute", "B_Parachute", 200, "backpack"],

	["Assault Pack (Black)", "B_AssaultPack_blk", 150, "backpack"],
	["Assault Pack (Green)", "B_AssaultPack_rgr", 150, "backpack"],
	["Assault Pack (MTP)", "B_AssaultPack_mcamo", 150, "backpack"],
	["Assault Pack (Hex)", "B_AssaultPack_ocamo", 150, "backpack"],

	["Field Pack (Black)", "B_FieldPack_blk", 200, "backpack"],
	["Field Pack (Coyote)", "B_FieldPack_cbr", 200, "backpack"],
	["Field Pack (Khaki)", "B_FieldPack_khk", 200, "backpack"],
	["Field Pack (Urban)", "B_FieldPack_oucamo", 200, "backpack"],

	["Kitbag (Coyote)", "B_Kitbag_cbr", 350, "backpack"],
	["Kitbag (Green)", "B_Kitbag_rgr", 350, "backpack"],
	["Kitbag (MTP)", "B_Kitbag_mcamo", 350, "backpack"],
	["Kitbag (Sage)", "B_Kitbag_sgg", 350, "backpack"],

	["Bergen (Black)", "B_Bergen_blk", 350, "backpack"],
	["Bergen (Green)", "B_Bergen_rgr", 350, "backpack"],
	["Bergen (MTP)", "B_Bergen_mcamo", 350, "backpack"],
	["Bergen (Sage)", "B_Bergen_sgg", 350, "backpack"],

	["Carryall (Khaki)", "B_Carryall_khk", 500, "backpack"],
	["Carryall (MTP)", "B_Carryall_mcamo", 500, "backpack"],
	["Carryall (Olive)", "B_Carryall_oli", 500, "backpack"],
	["Carryall (Urban)", "B_Carryall_oucamo", 500, "backpack"]
];

genItemArray = compileFinal str
[
	["Quadrotor UAV (NATO)", "B_UAV_01_backpack_F", 500, "backpack"],
	["Quadrotor UAV (CSAT)", "O_UAV_01_backpack_F", 500, "backpack"],
	["Quadrotor UAV (AAF)", "I_UAV_01_backpack_F", 500, "backpack"],
	["UAV Terminal (NATO)", "B_UavTerminal", 150, "item"],
	["UAV Terminal (CSAT)", "O_UavTerminal", 150, "item"],
	["UAV Terminal (AAF)", "I_UavTerminal", 150, "item"],
	["GPS", "ItemGPS", 100, "item"],
	["First Aid Kit", "FirstAidKit", 25, "item"],
	["Medikit", "Medikit", 150, "item"],
	["Toolkit", "ToolKit", 150, "item"],
	["Mine Detector", "MineDetector", 100, "item"],
	["NV Goggles", "NVGoggles", 100, "nvg"],
	["Diving Goggles", "G_Diving", 100, "gogg"],
	["Binoculars", "Binocular", 50, "binoc"],
	["Rangefinder", "Rangefinder", 150, "binoc"],
	["Laser Designator", "Laserdesignator", 975, "binoc"],
	["Laser Batteries", "Laserbatteries", 25, "mag"],
	["Chemlight (Blue)", "Chemlight_blue", 25, "mag"],
	["Chemlight (Green)", "Chemlight_green", 25, "mag"],
	["Chemlight (Yellow)", "Chemlight_yellow", 25, "mag"],
	["Chemlight (Red)", "Chemlight_red", 25, "mag"]
];

allRegularStoreItems = compileFinal str (call allGunStoreFirearms + call throwputArray + call ammoArray + call accessoriesArray + call genItemArray);

genObjectsArray = compileFinal str
[
	["Empty Ammo Crate", "Box_NATO_Ammo_F", 100, "ammocrate"],
	["Metal Barrel", "Land_MetalBarrel_F", 25, "object"],
	["Toilet Box", "Land_ToiletBox_F", 25, "object"],
	["Lamp Post (Harbour)", "Land_LampHarbour_F", 25, "object"],
	["Lamp Post (Shabby)", "Land_LampShabby_F", 25, "object"],
	["Barrier Gate", "Land_BarGate_F", 50, "object"],
	["Pipes", "Land_Pipes_Large_F", 100, "object"],
	["Concrete Frame", "Land_CncShelter_F", 100, "object"],
	["Safety Barrier", "Land_Crash_barrier_F", 100, "object"],
	["Concrete Barrier", "Land_CncBarrier_F", 200, "object"],
	["Concrete Barrier (Medium)", "Land_CncBarrierMedium_F", 175, "object"],
	["Concrete Barrier (Long)", "Land_CncBarrierMedium4_F", 250, "object"],
	["HBarrier 1", "Land_HBarrier_1_F", 50, "object"],
	["HBarrier 3", "Land_HBarrier_3_F", 100, "object"],
	["HBarrier 5", "Land_HBarrier_5_F", 175, "object"],
	["HBarrier Big", "Land_HBarrierBig_F", 250, "object"],
	["HBarrier Wall 4", "Land_HBarrierWall4_F", 200, "object"],
	["HBarrier Wall 6", "Land_HBarrierWall6_F", 200, "object"],
	["HBarrier Watchtower", "Land_HBarrierTower_F", 350, "object"],
	["Concrete Wall", "Land_CncWall1_F", 200, "object"],
	["Concrete Military Wall", "Land_Mil_ConcreteWall_F", 200, "object"],
	["Concrete Wall (Long)", "Land_CncWall4_F", 300, "object"],
	["Military Wall (Big)", "Land_Mil_WallBig_4m_F", 300, "object"],
	["Shoot House Wall", "Land_Shoot_House_Wall_F", 180, "object"],
	["Canal Wall (Small)", "Land_Canal_WallSmall_10m_F", 200, "object"],
	["Canal Stairs", "Land_Canal_Wall_Stairs_F", 250, "object"],
	["Bag Fence (Corner)", "Land_BagFence_Corner_F", 75, "object"],
	["Bag Fence (End)", "Land_BagFence_End_F", 75, "object"],
	["Bag Fence (Long)", "Land_BagFence_Long_F", 100, "object"],
	["Bag Fence (Round)", "Land_BagFence_Round_F", 75, "object"],
	["Bag Fence (Short)", "Land_BagFence_Short_F", 75, "object"],
	["Bag Bunker (Small)", "Land_BagBunker_Small_F", 175, "object"],
	["Bag Bunker (Large)", "Land_BagBunker_Large_F", 300, "object"],
	["Bag Bunker Tower", "Land_BagBunker_Tower_F", 500, "object"],
	["Military Cargo Post", "Land_Cargo_Patrol_V1_F", 400, "object"],
	["Military Cargo Tower", "Land_Cargo_Tower_V1_F", 2500, "object"],
	["Concrete Ramp", "Land_RampConcrete_F", 200, "object"],
	["Concrete Ramp (High)", "Land_RampConcreteHigh_F", 250, "object"],
	["Scaffolding", "Land_Scaffolding_F", 200, "object"]
];

allGenStoreVanillaItems = compileFinal str (call genItemArray + call genObjectsArray + call headArray + call uniformArray + call vestArray + call backpackArray);

//Text name, classname, buy cost, spawn type, sell price (selling not implemented) or spawning color
landArray = compileFinal str
[
	["Kart", "C_Kart_01_F", 100, "vehicle"],

	["Quadbike (Civilian)", "C_Quadbike_01_F", 150, "vehicle"],
	["Quadbike (NATO)", "B_Quadbike_01_F", 200, "vehicle"],
	["Quadbike (CSAT)", "O_Quadbike_01_F", 200, "vehicle"],
	["Quadbike (AAF)", "I_Quadbike_01_F", 200, "vehicle"],
	["Quadbike (FIA)", "B_G_Quadbike_01_F", 200, "vehicle"],

	["Hatchback", "C_Hatchback_01_F", 400, "vehicle"],
	["Hatchback Sport", "C_Hatchback_01_sport_F", 700, "vehicle"],
	["SUV", "C_SUV_01_F", 750, "vehicle"],
	["Offroad", "C_Offroad_01_F", 750, "vehicle"],
	["Offroad Camo", "B_G_Offroad_01_F", 800, "vehicle",550],
	["Offroad HMG", "B_G_Offroad_01_armed_F", 2500, "vehicle"],

	["Truck", "C_Van_01_transport_F", 250, "vehicle"],
	["Truck (Camo)", "B_G_Van_01_transport_F", 300, "vehicle"],
	["Truck Box", "C_Van_01_box_F", 300, "vehicle"],
	["Fuel Truck", "C_Van_01_fuel_F", 2000, "vehicle"],
	["Fuel Truck (Camo)", "B_G_Van_01_fuel_F", 2100, "vehicle"],

	["HEMTT Tractor", "B_Truck_01_mover_F", 2000, "vehicle"],
	["HEMTT Box", "B_Truck_01_box_F", 3000, "vehicle"],
	["HEMTT Transport", "B_Truck_01_transport_F", 3000, "vehicle"],
	["HEMTT Covered", "B_Truck_01_covered_F", 4000, "vehicle"],
	["HEMTT Fuel", "B_Truck_01_fuel_F", 5000, "vehicle"],
	["HEMTT Medical", "B_Truck_01_medical_F", 6000, "vehicle"],
	["HEMTT Repair", "B_Truck_01_Repair_F", 7500, "vehicle"],
	["HEMTT Ammo", "B_Truck_01_ammo_F", 15000, "vehicle"],

	["Tempest Device", "O_Truck_03_device_F", 2500, "vehicle"],
	["Tempest Transport", "O_Truck_03_transport_F", 3000, "vehicle"],
	["Tempest Covered", "O_Truck_03_covered_F", 4000, "vehicle"],
	["Tempest Fuel", "O_Truck_03_fuel_F", 5000, "vehicle"],
	["Tempest Medical", "O_Truck_03_medical_F", 6000, "vehicle"],
	["Tempest Repair", "O_Truck_03_repair_F", 7500, "vehicle"],
	["Tempest Ammo", "O_Truck_03_ammo_F", 15000, "vehicle"],

	["Zamak Transport", "I_Truck_02_transport_F", 2000, "vehicle"],
	["Zamak Covered", "I_Truck_02_covered_F", 3000, "vehicle"],
	["Zamak Fuel", "I_Truck_02_fuel_F", 4000, "vehicle"],
	["Zamak Medical", "I_Truck_02_medical_F", 6000, "vehicle"],
	["Zamak Repair", "I_Truck_02_box_F", 7000, "vehicle"],
	["Zamak Ammo", "I_Truck_02_ammo_F", 14000, "vehicle"],

	["UGV Stomper (NATO)", "B_UGV_01_F", 2000, "vehicle"],
	["UGV Stomper RCWS (NATO)", "B_UGV_01_rcws_F", 10000, "vehicle"],
	["UGV Stomper (AAF)", "I_UGV_01_F", 2000, "vehicle"],
	["UGV Stomper RCWS (AAF)", "I_UGV_01_rcws_F", 10000, "vehicle"],
	["UGV Saif (CSAT)", "O_UGV_01_F", 2000, "vehicle"],
	["UGV Saif RCWS (CSAT)", "O_UGV_01_rcws_F", 10000, "vehicle"]
];

armoredArray = compileFinal str
[
	["Hunter", "B_MRAP_01_F", 2000, "vehicle"],
	["Hunter HMG", "B_MRAP_01_hmg_F", 8000, "vehicle"],
	["Hunter GMG", "B_MRAP_01_gmg_F", 10000, "vehicle"],
	["Ifrit", "O_MRAP_02_F", 2000, "vehicle"],
	["Ifrit HMG", "O_MRAP_02_hmg_F", 8000, "vehicle"],
	["Ifrit GMG", "O_MRAP_02_gmg_F", 10000, "vehicle"],
	["Strider", "I_MRAP_03_F", 2000, "vehicle"],
	["Strider HMG", "I_MRAP_03_hmg_F", 8000, "vehicle"],
	["Strider GMG", "I_MRAP_03_gmg_F", 10000, "vehicle"],
	["MSE-3 Marid", "O_APC_Wheeled_02_rcws_F", 12500, "vehicle"],
	["AMV-7 Marshall", "B_APC_Wheeled_01_cannon_F", 15000, "vehicle"],
	["AFV-4 Gorgon", "I_APC_Wheeled_03_cannon_F", 17500, "vehicle"]
];

tanksArray = compileFinal str
[
	["CRV-6e Bobcat", "B_APC_Tracked_01_CRV_F", 16000, "vehicle"],
	["IFV-6c Panther", "B_APC_Tracked_01_rcws_F", 18000, "vehicle"],
	["FV-720 Mora", "I_APC_tracked_03_cannon_F", 19000, "vehicle"],
	["BTR-K Kamysh", "O_APC_Tracked_02_cannon_F", 20000, "vehicle"],
	["IFV-6a Cheetah AA", "B_APC_Tracked_01_AA_F", 20000, "vehicle"],
	["ZSU-39 Tigris AA", "O_APC_Tracked_02_AA_F", 20000, "vehicle"],
	["M2A1 Slammer", "B_MBT_01_cannon_F", 25000, "vehicle"],
	["M2A4 Slammer HMG", "B_MBT_01_TUSK_F", 25000, "vehicle"], // Commander gun variant
	["T-100 Varsuk", "O_MBT_02_cannon_F", 25000, "vehicle"],
	["MBT-52 Kuma", "I_MBT_03_cannon_F", 25000, "vehicle"]
];


helicoptersArray = compileFinal str
[
	["MH-9 Hummingbird", "B_Heli_Light_01_F", 3000, "vehicle"], // MH-6
	["PO-30 Orca (Black)", "O_Heli_Light_02_unarmed_F", 4500, "vehicle"], // Ka-60
	["WY-55 Hellcat (Green)", "I_Heli_light_03_unarmed_F", 4500, "vehicle"], // AW159
	["CH-49 Mohawk", "I_Heli_Transport_02_F", 7500, "vehicle"], // AW101

	["UH-80 Ghost Hawk (Black)", "B_Heli_Transport_01_F", 15000, "vehicle"], // UH-60 Stealth with 2 side miniguns
	["UH-80 Ghost Hawk (Green)", "B_Heli_Transport_01_camo_F", 16000, "vehicle"], // UH-60 Stealth with 2 side miniguns (green camo)
	["AH-9 Pawnee", "B_Heli_Light_01_armed_F", 20000, "vehicle"], // Armed AH-6
	["PO-30 Orca (Armed)", "O_Heli_Light_02_F", 20000, "vehicle"], // Armed Ka-60
	["WY-55 Hellcat (Armed)", "I_Heli_light_03_F", 22500, "vehicle"], // Armed AW159
	["AH-99 Blackfoot", "B_Heli_Attack_01_F", 27500, "vehicle"], // RAH-66 with gunner
	["Mi-48 Kajman (Hex)", "O_Heli_Attack_02_F", 30000, "vehicle"], // Mi-28 with gunner
	["Mi-48 Kajman (Black)", "O_Heli_Attack_02_black_F", 30000, "vehicle"] // Mi-28 with gunner (black camo)
];

planesArray = compileFinal str
[
	["A-143 Buzzard AA", "I_Plane_Fighter_03_AA_F", 20000, "vehicle"],
	["A-143 Buzzard CAS", "I_Plane_Fighter_03_CAS_F", 25000, "vehicle"],
	["A-164 Wipeout CAS", "B_Plane_CAS_01_F", 30000, "vehicle"],
	["To-199 Neophron CAS", "O_Plane_CAS_02_F", 30000, "vehicle"],
	["MQ4A Greyhawk ATGM UAV", "B_UAV_02_F", 10000, "vehicle"],
	["MQ4A Greyhawk Bomber UAV", "B_UAV_02_CAS_F", 10000, "vehicle"],
	["K40 Ababil-3 ATGM UAV (CSAT)", "O_UAV_02_F", 10000, "vehicle"],
	["K40 Ababil-3 Bomber UAV (CSAT)", "O_UAV_02_CAS_F", 10000, "vehicle"],
	["K40 Ababil-3 ATGM UAV (AAF)", "I_UAV_02_F", 10000, "vehicle"],
	["K40 Ababil-3 Bomber UAV (AAF)", "I_UAV_02_CAS_F", 10000, "vehicle"]
];

boatsArray = compileFinal str
[
	["Rescue Boat", "C_Rubberboat", 100, "boat"],
	["Rescue Boat (NATO)", "B_Lifeboat", 100, "boat"],
	["Rescue Boat (CSAT)", "O_Lifeboat", 100, "boat"],
	["Assault Boat (NATO)", "B_Boat_Transport_01_F", 150, "boat"],
	["Assault Boat (CSAT)", "O_Boat_Transport_01_F", 150, "boat"],
	["Assault Boat (AAF)", "I_Boat_Transport_01_F", 150, "boat"],
	["Assault Boat (FIA)", "B_G_Boat_Transport_01_F", 150, "boat"],
	["Motorboat", "C_Boat_Civil_01_F", 400, "boat"],
	["Motorboat Rescue", "C_Boat_Civil_rescue_01_F", 400, "boat"],
	["Motorboat Police", "C_Boat_Civil_police_01_F", 450, "boat"],
	["Speedboat HMG (CSAT)", "O_Boat_Armed_01_hmg_F", 4000, "boat"],
	["Speedboat Minigun (NATO)", "B_Boat_Armed_01_minigun_F", 4000, "boat"],
	["Speedboat Minigun (AAF)", "I_Boat_Armed_01_minigun_F", 4000, "boat"],
	["SDV Submarine (NATO)", "B_SDV_01_F", 500, "submarine"],
	["SDV Submarine (CSAT)", "O_SDV_01_F", 500, "submarine"],
	["SDV Submarine (AAF)", "I_SDV_01_F", 500, "submarine"]
];

allVehStoreVehicles = compileFinal str (call landArray + call armoredArray + call tanksArray + call helicoptersArray + call planesArray + call boatsArray);

uavArray = compileFinal str
[
	"B_UAV_02_F",
	"O_UAV_02_F",
	"I_UAV_02_F",
	"B_UAV_02_CAS_F",
	"O_UAV_02_CAS_F",
	"I_UAV_02_CAS_F",
	"B_UGV_01_F",
	"O_UGV_01_F",
	"I_UGV_01_F",
	"B_UGV_01_rcws_F",
	"O_UGV_01_rcws_F",
	"I_UGV_01_rcws_F"
];

noColorVehicles = compileFinal str
[
	/*
	"Hatchback_01_base_F",
	"Van_01_base_F",
	"SUV_01_base_F",
	"Offroad_01_base_F",
	"Truck_01_base_F",
	"MRAP_02_base_F",
	"MRAP_03_base_F",
	"Heli_Attack_01_base_F",
	"B_Boat_Transport_01_F",
	"B_SDV_01_F",
	"O_APC_Wheeled_02_rcws_F",
	"APC_Tracked_01_base_F",
	"O_APC_Tracked_02_cannon_F",
	"MBT_01_base_F",
	"MBT_02_base_F"
	*/
];

rgbOnlyVehicles = compileFinal str
[
	/*
	"Quadbike_01_base_F",
	"Truck_02_base_F",
	"Heli_Transport_01_base_F",
	"O_Boat_Transport_01_F",
	"I_Boat_Transport_01_F",
	"B_G_Boat_Transport_01_F",
	"Rescue_duck_base_F",
	"O_SDV_01_F",
	"I_SDV_01_F"
	*/
];

//color, isARGB
colorsArray = compileFinal str
[
	["Black", true],
	["Grey", true],
	["White", true],
	["Orange", true],
	["Red", true],
	["Pink", true],
	["Yellow", true],
	["Purple", true],
	["Blue", true],
	["Dark Blue", true],
	["Teal", true],
	["Green", true],
	["Orange Camo", false],
	["Red Camo", false],
	["Yellow Camo", false],
	["Pink Camo", false]
];

//General Store Item List
//Display Name, Class Name, Description, Picture, Buy Price, Sell Price.
// ["Medical Kit", "medkits", localize "STR_WL_ShopDescriptions_MedKit", "client\icons\medkit.paa", 400, 200],  // not needed since there are First Ait Kits
customPlayerItems = compileFinal str
[
	["Water Bottle", "water", localize "STR_WL_ShopDescriptions_Water", "client\icons\water.paa", 30, 15],
	["Canned Food", "cannedfood", localize "STR_WL_ShopDescriptions_CanFood", "client\icons\cannedfood.paa", 30, 15],
	["Repair Kit", "repairkit", localize "STR_WL_ShopDescriptions_RepairKit", "client\icons\briefcase.paa", 500, 250],
	["Jerry Can (Full)", "jerrycanfull", localize "STR_WL_ShopDescriptions_fuelFull", "client\icons\jerrycan.paa", 150, 75],
	["Jerry Can (Empty)", "jerrycanempty", localize "STR_WL_ShopDescriptions_fuelEmpty", "client\icons\jerrycan.paa", 50, 25],
	["Spawn Beacon", "spawnbeacon", localize "STR_WL_ShopDescriptions_spawnBeacon", "client\icons\briefcase.paa", 1500, 750],
	["Camo Net", "camonet", localize "STR_WL_ShopDescriptions_Camo", "client\icons\briefcase.paa", 200, 100],
	["Syphon Hose", "syphonhose", localize "STR_WL_ShopDescriptions_SyphonHose", "client\icons\jerrycan.paa", 200, 100],
	["Energy Drink", "energydrink", localize "STR_WL_ShopDescriptions_Energy_Drink", "client\icons\water.paa", 100, 50],
	["Warchest", "warchest", localize "STR_WL_ShopDescriptions_Warchest", "client\icons\briefcase.paa", 1000, 500]
];


// Notes: Gun and general stores have position of spawned crate, vehicle stores have an extra air spawn direction
//
// Array contents are as follows:
// Name, Building Position, Desk Direction Modifier, Excluded Buttons
storeOwnerConfig = compileFinal str
[
	["GenStore1", 6, 240, []],
	["GenStore2", 6, 250, []],
	["GenStore3", 6, 45, []],
	["GenStore4", 0, 265, []],
	["GenStore5", 5, 350, []],

	["GunStore1", 1, 0, []],
	["GunStore2", 1, 75, []],
	["GunStore3", 6, 135, []],
	["GunStore4", 1, 65, []],

	// Boats = disable Boats button
	// Planes = disable Planes button
	// NoBuzzard = remove A-143 Buzzard from planes list due to short runway, other planes seem fine
	["VehStore1", 1, 75, ["NoBuzzard"]],
	["VehStore2", 6, 45, ["Boats"]],
	["VehStore3", 4, 250, ["Boats", "NoBuzzard"]],
	["VehStore4", 5, 155, ["Boats"]]
];

// Outfits for store owners
storeOwnerConfigAppearance = compileFinal str
[
	['GenStore1', [['weapon', ''], ['uniform', 'U_IG_Guerilla2_2']]],
	['GenStore2', [['weapon', ''], ['uniform', 'U_IG_Guerilla2_3']]],
	['GenStore3', [['weapon', ''], ['uniform', 'U_IG_Guerilla3_1']]],
	['GenStore4', [['weapon', ''], ['uniform', 'U_IG_Guerilla2_1']]],
	['GenStore5', [['weapon', ''], ['uniform', 'U_IG_Guerilla3_2']]],

	['GunStore1', [['weapon', ''], ['uniform', 'U_B_SpecopsUniform_sgg']]],
	['GunStore2', [['weapon', ''], ['uniform', 'U_O_SpecopsUniform_blk']]],
	['GunStore3', [['weapon', ''], ['uniform', 'U_I_CombatUniform_tshirt']]],
	['GunStore4', [['weapon', ''], ['uniform', 'U_IG_Guerilla1_1']]],

	['VehStore1', [['weapon', ''], ['uniform', 'U_Competitor']]],
	['VehStore2', [['weapon', ''], ['uniform', 'U_Competitor']]],
	['VehStore3', [['weapon', ''], ['uniform', 'U_Competitor']]],
	['VehStore4', [['weapon', ''], ['uniform', 'U_Competitor']]]
];

storeConfigDone = compileFinal "true";
