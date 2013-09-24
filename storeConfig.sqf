/*********************************************************#
# @@ScriptName: storeConfig.sqf
# @@Author: His_Shadow
# @@Create Date: 2013-09-16 20:40:58
# @@Modify Date: 2013-09-24 23:45:27
# @@Function:
#*********************************************************/

//
//Gunstore Weapon List - Gun Store Base List
// Text name, classname, buy cost, sell amount


// This tracks which store owner the client is interacting with
currentOwnerName = "";

pistolArray = compileFinal str
[
	//Handgun
    ["P07 9 mm","hgun_P07_F",50,25],
	["Rook-40 9 mm","hgun_Rook40_F",50,25],
	["ACP-C2 9 mm","hgun_ACPC2_F",75,25]
]; 

rifleArray = compileFinal str
[
    //Underwater Gun
	["SDAR UW Rifle","arifle_SDAR_F",100,50],

	//Assault Rifle
	["MX Carbine","arifle_MXC_F",150,75],
	["MX Rifle","arifle_MX_F",200,100],
	["MX 3GL Rifle","arifle_MX_GL_F",250,125],
	["MXM Marksman Rifle","arifle_MXM_F",300,150],

	//Light Machine Gun
	["MX SW LMG","arifle_MX_SW_F",300,150],
	["Mk200 LMG","LMG_Mk200_F",350,175],
	["Zafir LMG","LMG_Zafir_F",400,200],

	//Assault Rifle
	["Mk20C Carbine","arifle_Mk20C_F",150,75],
	["Mk20 Rifle","arifle_Mk20_F",200,100],	
	["Mk20 EGLM Rifle","arifle_Mk20_GL_F",250,125],

	["TRG-20 Carbine","arifle_TRG20_F",150,75],	
	["TRG-21 Rifle ","arifle_TRG21_F",200,100],
	["TRG-21 EGLM Rifle","arifle_TRG21_GL_F",250,125],

	["Katiba Carbine","arifle_Katiba_C_F",150,75],
	["Katiba Rifle","arifle_Katiba_F",200,100],
	["Katiba GL Rifle","arifle_Katiba_GL_F",250,125],

	//Sniper
	["Mk18 ABR 7.62 mm","srifle_EBR_F",400,200],
	["M320 LRR .408","srifle_LRR_F",1000,500],
	["GM6 Lynx 12.7 mm","srifle_GM6_F",1000,500]
];


smgArray = compileFinal str
[
	["Vermin SBR 9mm", "SMG_01_F", 125, 75],
	["Sting SMG", "SMG_02_F", 125, 75],
	["PDW 2000 (9mm)","hgun_PDW2000_F",100,50]
];

shotgunArray = compileFinal str
[
]; 

launcherArray = compileFinal str
[
    //Rocket
	["PCML","launch_NLAW_F",400,200],
	["RPG-42 Alamut","launch_RPG32_F",500,200],
	["Titan MPRL Compact","launch_Titan_short_F",600,530000],
	["Titan MPRL","launch_Titan_F",600,300]
];

staticGunsArray = compileFinal str
[
    //Rocket
	["Mk30 HMG .50 (Blue)","B_HMG_01_F",5000],
    ["Mk30 HMG .50 (Red)","O_HMG_01_F",5000],
	["Mk30 HMG .50 (Green)","I_HMG_01_F",5000],
	["Mk30A HMG .50 (Blue)","B_HMG_01_A_F",5300],
	["Mk30A HMG .50 (Red)","O_HMG_01_A_F",5300],
	["Mk30A HMG .50 (Green)","I_HMG_01_A_F",5300],
	["Mk30 HMG .50 High (Blue)","B_HMG_01_high_F",5500],
	["Mk30 HMG .50 High (Red)","O_HMG_01_high_F",5500],
	["Mk30 HMG .50 High (Green)","I_HMG_01_high_F",5500],
	["Mk32 GMG 20mm (Blue)","B_GMG_01_F",7500],
	["Mk32 GMG 20mm (Red)","O_GMG_01_F",7500],
	["Mk32 GMG 20mm (Green)","I_GMG_01_F",7500],
	["Mk32A GMG 20mm (Blue)","B_GMG_01_A_F",7700],
	["Mk32A GMG 20mm (Red)","O_GMG_01_A_F",7700],
	["Mk32A GMG 20mm (Green)","I_GMG_01_A_F",7700],
	["Mk32 GMG 20mm High (Blue)","B_GMG_01_high_F",8000],
	["Mk32 GMG 20mm High (Red)","O_GMG_01_high_F",8000],
	["Mk32 GMG 20mm High (Green)","I_GMG_01_high_F",8000],
	["Mk6 Mortar (Blue)","B_Mortar_01_F",10000],
	["Mk6 Mortar (Red)","O_Mortar_01_F",10000],
	["Mk6 Mortar (Green)","I_Mortar_01_F",12000],
	["Static Titan AT (Blue)","I_static_AT_F",11000],
	["Static Titan AT (Red)","I_static_AT_F",11000],
	["Static Titan AT (Green)","I_static_AT_F",11000],
	["Static Titan AA (Blue)","B_static_AA_F",12000],
	["Static Titan AA (Red)","O_static_AA_F",12000],
	["Static Titan AA (Green)","I_static_AA_F",12000]
]; 

throwputArray = compileFinal str
[
	["RGO Frag Grenade","HandGrenade",100,0],
	["Stone","HandGrenade_Stone",30,0],
	["Mini Grenade","MiniGrenade",25,0],
	["Smoke Grenade (White)", "SmokeShell", 50,0],
	["Smoke Grenade (Yellow)", "SmokeShellYellow", 50,0],
	["Smoke Grenade (Green)", "SmokeShellGreen", 50,0],
	["Smoke Grenade (Red)", "SmokeShellRed", 50,0],
	["Smoke Grenade (Purple)", "SmokeShellPurple", 50,0],
	["Smoke Grenade (Orange)", "SmokeShellPurple", 50,0],
	["Smoke Grenade (Blue)", "SmokeShellBlue", 50,0],
	["Chemlight (Green)", "Chemlight_green", 25,0],
	["Chemlight (Red)", "Chemlight_red", 25,0],
	["Chemlight (Yellow)", "Chemlight_yellow", 25,0],
	["Chemlight (Blue)", "Chemlight_blue", 25,0],
	["Explosive Charge","DemoCharge_Remote_Mag",500,0],
	["Explosive Satchel","SatchelCharge_Remote_Mag",600,0],
	["AT Mine","ATMine_Range_Mag",500,0],
	["M6 SLAM Mine","SLAMDirectionalMine_Wire_Mag",500,0],
	["Claymore Charge","ClaymoreDirectionalMine_Remote_Mag",300,0],
	["APERS Mine","APERSMine_Range_Mag",500,0],
	["APERS Bounding Mine","APERSBoundingMine_Range_Mag",500,0],
	["APERS Tripwire Mine","APERSTripMine_Wire_Mag",500,0]
];

//Gun Store Ammo List
//Text name, classname, buy cost
ammoArray = compileFinal str
[
	["9mm 16Rnd Mag","16Rnd_9x21_Mag",10],
	["9mm 30Rnd Mag","30Rnd_9x21_Mag",20],
	[".45 ACP 9Rnd Mag","9Rnd_45ACP_Mag",10],
	[".45 ACP 30Rnd Vermin Mag","30Rnd_45ACP_MAG_SMG_01",20],
	[".45 30Rnd VerminTracers (Green) Mag","30Rnd_45ACP_Mag_SMG_01_tracer_green",15],
	["5.56mm 20Rnd Dual Purpose Mag","20Rnd_556x45_UW_mag",10],
	["5.56mm 30Rnd STANAG Mag","30Rnd_556x45_Stanag",20],
	["5.56mm 30Rnd Tracer (Red) Mag","30Rnd_556x45_Stanag_Tracer_Red",15],
	["5.56mm 30Rnd Tracer (Yellow) Mag","30Rnd_556x45_Stanag_Tracer_Yellow",15],
	["5.56mm 30Rnd Tracer (Green) Mag","30Rnd_556x45_Stanag_Tracer_Green",15],
	["6.5mm 30Rnd STANAG Mag","30Rnd_65x39_caseless_mag",20],
	["6.5mm 30Rnd Tracer (Red) Mag","30Rnd_65x39_caseless_mag_Tracer",15],
	["6.5mm 30Rnd Caseless Mag","30Rnd_65x39_caseless_green",20],
	["6.5mm 30Rnd Tracer (Green) Mag","30Rnd_65x39_caseless_green_mag_Tracer",15],
	["6.5mm 100Rnd Belt Case","100Rnd_65x39_caseless_mag",75],
	["6.5mm 100Rnd Tracer (Red) Belt Case","100Rnd_65x39_caseless_mag_Tracer",60],
	["6.5mm 200Rnd Belt Case","200Rnd_65x39_cased_Box",150],
	["6.5mm 200Rnd Tracer (Green) Belt Case","200Rnd_65x39_cased_Box_Tracer",150],
	["7.62mm 20Rnd Mag","20Rnd_762x51_Mag",25],
	["7.62mm 150Rnd Box","150Rnd_762x51_Box",150],
	["7.62mm 150Rnd Tracer (Green) Box","150Rnd_762x51_Box_Tracer",120],
	[".408 7Rnd Cheetah Mag","7Rnd_408_Mag",50],
	["12.7mm 5Rnd Mag","5Rnd_127x108_Mag",50],
	["40mm HE Grenade Round","1Rnd_HE_Grenade_shell",125],
	["Flare Round (White)","UGL_FlareWhite_F",25],
	["Flare Round (Green)","UGL_FlareGreen_F",25],
	["Flare Round (Red)","UGL_FlareRed_F",25],
	["Flare Round (Yellow)","UGL_FlareYellow_F",25],
	["Flare Round (IR)","UGL_FlareCIR_F",25],
	["Smoke Round (White)","1Rnd_Smoke_Grenade_shell",25],
	["Smoke Round (Red)","1Rnd_SmokeRed_Grenade_shell",25],
	["Smoke Round (Green)","1Rnd_SmokeGreen_Grenade_shell",25],
	["Smoke Round (Yellow)","1Rnd_SmokeYellow_Grenade_shell",25],
	["Smoke Round (Purple)","1Rnd_SmokePurple_Grenade_shell",25],
	["Smoke Round (Blue)","1Rnd_SmokeBlue_Grenade_shell",25],
	["Smoke Round (Orange)","1Rnd_SmokeOrange_Grenade_shell",25],
	["40mm 3Rnd HE Grenade","3Rnd_HE_Grenade_shell",300],
	["3Rnd 3GL Flares (White)","3Rnd_UGL_FlareWhite_F",100],
	["3Rnd 3GL Flares (Green)","3Rnd_UGL_FlareGreen_F",100],
	["3Rnd 3GL Flares (Red)","3Rnd_UGL_FlareRed_F",100],
	["3Rnd 3GL Flares (Yellow)","3Rnd_UGL_FlareYellow_F",100],
	["3Rnd 3GL Flares (IR)","3Rnd_UGL_FlareCIR_F",100],
	["3Rnd 3GL Smoke Rounds (White)","3Rnd_Smoke_Grenade_shell",50],
	["3Rnd 3GL Smoke Rounds (Red)","3Rnd_SmokeRed_Grenade_shell",50],
	["3Rnd 3GL Smoke Rounds (Green)","3Rnd_SmokeGreen_Grenade_shell",50],
	["3Rnd 3GL Smoke Rounds (Yellow)","3Rnd_SmokeYellow_Grenade_shell",50],
	["3Rnd 3GL Smoke Rounds (Purple)","3Rnd_SmokePurple_Grenade_shell",50],
	["3Rnd 3GL Smoke Rounds (Blue)","3Rnd_SmokeBlue_Grenade_shell",50],
	["3Rnd 3GL Smoke Rounds (Orange)","3Rnd_SmokeOrange_Grenade_shell",50],
	["PCML Missile","NLAW_F",250],
	["RPG-42 Missile","RPG32_F",300],
	["RPG-42 HE Missile","RPG32_F",300],
	["Titan AA Missile","Titan_AA",350],
	["Titan AT Missile","Titan_AT",350],
	["Titan AP Missile","Titan_AP",350]
];

//Gun Store item List
//Text name, classname, buy cost, item class
accessoriesArray = compileFinal str
[
	["Suppressor 9mm","muzzle_snds_L", 50, "item"],
	["Suppressor ACP", "muzzle_snds_acp", 75, "item"],
	["Suppressor 5.56mm", "muzzle_snds_M", 100, "item"],
	["Suppressor 6.5mm","muzzle_snds_H", 100,"item"],
	["LMG Suppressor 6.5mm","muzzle_snds_H_MG", 125,"item"],
	["Suppressor 7.62mm","muzzle_snds_B", 125,"item"],
	["Flash Light","acc_flashlight", 50,"item"],
	["IR Light","acc_pointer_IR", 50,"item"],
	["Holosight","optic_Holosight", 75,"item"],
	["ACO Sight","optic_Aco", 75,"item"],
	["ACO Sight Green","optic_Aco_grn", 75,"item"],
	["RCO Sight","optic_Hamr", 100,"item"],
	["ARCO Sight","optic_Arco", 100,"item"],
	["MRCO Sight","optic_MRCO", 200,"item"],
	["SOS Sight","optic_SOS", 200,"item"],
	["Nightstalker","optic_Nightstalker", 500,"item"],
	["NVS","optic_NVS", 300,"item"],
	["TWS","optic_tws", 400,"item"],
	["TWS MG","optic_tws_mg", 400,"item"],
	["UAV Terminal Blue","b_uavterminal", 250,"item"],
	["UAV Terminal Red","o_uavterminal", 250,"item"],
	["UAV Terminal Green","i_uavterminal", 250,"item"],
	["Empty Crate","Box_NATO_Ammo_F", 250,"ammocrate"]
	//["Empty Weapon Crate","Box_NATO_Wps_F", 50,"weaponcrate"]
]; 

backpackArray = compileFinal str
[
	["Small (Green)","B_AssaultPack_Base",200,"backpack"],
	["Small (Black)","B_AssaultPack_blk",200,"backpack"],
	["Small (Brown)","B_AssaultPack_cbr",200,"backpack"],
	["Small (Digi)","B_AssaultPack_dgtl",200,"backpack"],
	["Small (Green)","B_AssaultPack_khk",200,"backpack"],
	["Small Guerilla","B_AssaultPack_khk",200,"backpack"],
	["Small (Camo)","B_AssaultPack_mcamo",200,"backpack"],
	["Small Green","B_AssaultPack_ocamo",200,"backpack"],
	["Small (Dark Brown)","B_AssaultPack_rgr",200,"backpack"],
	["Small (White)","B_AssaultPack_sgg",200,"backpack"],	
	["Small Diver (Black)","B_AssaultPack_blk_DiverExp",800,"backpack"],
	["Small Medic Drk Brn","B_AssaultPack_rgr_Medic",600,"backpack"],
	["Small Repair Drk Brn","B_AssaultPack_rgr_Repair",600,"backpack"],

	["Medium (Brown)","B_FieldPack_Base",350,"backpack"],
	["Medium (Black)","B_FieldPack_blk",350,"backpack"],
	["Medium (Camo)","B_FieldPack_ocamo",350,"backpack"],
	["Medium (Coyote)","B_FieldPack_cbr",350,"backpack"],
	["Medium (Khaki)","B_FieldPack_khk",350,"backpack"],
	["Medium (Hex)","B_FieldPack_ocamo",350,"backpack"],
	["Medium (Olive)","B_FieldPack_oli",350,"backpack"],
	["Medium (Urban)","B_FieldPack_oucamo",350,"backpack"],
	["Medium (Hunting)","B_HuntingBackpack",350,"backpack"],
	["Medium Diver (Black)","B_FieldPack_blk_DiverExp",1000,"backpack"],
	["Medium Medic Camo","B_FieldPack_ocamo_Medic",800,"backpack"],
	["Medium Repair Brn","B_FieldPack_cbr_Repair",800,"backpack"],

	["Large (Brown)","B_Bergen_Base",500,"backpack"],
	["Large (Brown 2)","B_Kitbag_Base",500,"backpack"],
	["Large (Coyote)","B_Kitbag_cbr",500,"backpack"],
	["Large (MTP)","B_Kitbag_mcamo",500,"backpack"],
	["Large (Sage)","B_Kitbag_sgg",500,"backpack"],

	["Bergen (Black)","B_Bergen_blk",600,"backpack"],
	["Bergen (MTP)","B_Bergen_mcamo",600,"backpack"],
	["Bergen (Green)","B_Bergen_rgr",600,"backpack"],
	["Bergen (Sage)","B_Bergen_sgg",600,"backpack"],
	["Bergen (Blue)","B_BergenC_blu",600,"backpack"],
	["Bergen (Green)","B_BergenC_grn",600,"backpack"],
	["Bergen (Red)","B_BergenC_red",600,"backpack"],
	["Bergen (Guerilla)","B_BergenG",600,"backpack"],

	["Outdoor Pack (Black)","B_OutdoorPack_blk",650,"backpack"],
	["Outdoor Pack (Blue)","B_OutdoorPack_blu",650,"backpack"],
	["Outdoor Pack (Tan)","B_OutdoorPack_tan",650,"backpack"],

	["3 Day Tactical (Black)","B_TacticalPack_blk",650,"backpack"],
	["3 Day Tactical (MTP)","B_TacticalPack_mcamo",650,"backpack"],
	["3 Day Tactical (Hex)","B_TacticalPack_ocamo",650,"backpack"],
	["3 Day Tactical (Olive)","B_TacticalPack_oli",650,"backpack"],
	["3 Day Tactical (Green)","B_TacticalPack_rgr",650,"backpack"],

	["Ex Large Brn","B_Carryall_Base",800,"backpack"],
	["Ex Large Camo (Hex)","B_Carryall_ocamo",800,"backpack"],
	["Ex Large Camo (Coyote)","B_Carryall_cbr",800,"backpack"],
	["Ex Large Camo (Khaki)","B_Carryall_khk",800,"backpack"],
	["Ex Large Camo (MTP)","B_Carryall_mcamo",800,"backpack"],
	["Ex Large Camo (Olive)","B_Carryall_oli",800,"backpack"],
	["Ex Large Camo (Urban)","B_Carryall_oucamo",800,"backpack"],
	["Steerable parachute","B_Parachute",250,"backpack"]
];

//Gun Store Apparel List
//Text name, classname, buy cost, item class
apparelArray = compileFinal str
[	
];

headArray= compileFinal str
[
	["Bandanna (Coyote)", "H_Bandanna_cbr", 10, "hat"],
	["Bandanna (Camo)", "H_Bandanna_camo", 10, "hat"],
	["Bandanna (Gray)", "H_Bandanna_gry", 10, "hat"],
	["Bandanna (Khaki)", "H_Bandanna_khk", 10, "hat"],
	["Bandanna (MTP)", "H_Bandanna_mcamo", 10, "hat"],
	["Bandanna (Sage)", "H_Bandanna_sgg", 10, "hat"],
	["Bandanna (Surfer)", "H_Bandanna_surfer", 15, "hat"],
	["Bandanna Mask (Black)", "H_BandMask_blk", 15, "hat"],
	["Bandanna Mask (Demon)", "H_BandMask_demon", 15, "hat"],
	["Bandanna Mask (Khaki)", "H_BandMask_khk", 15, "hat"],
	["Bandanna Mask (Reaper)", "H_BandMask_reaper", 15, "hat"],
	["Beanie", "H_Watchcap_blk", 10, "hat"],
	["Beanie (Camo)", "H_Watchcap_camo", 10, "hat"],
	["Beanie (Khaki)", "H_Watchcap_khk", 10, "hat"],
	["Beanie (Sage)", "H_Watchcap_sgg", 10, "hat"],
	["Beret (Black)", "H_Beret_blk", 25, "hat"],
	["Beret (Green)", "H_Beret_grn", 25, "hat"],
	["Beret (Police)", "H_Beret_blk_POLICE", 25, "hat"],
	["Beret (Red)", "H_Beret_red", 25, "hat"],
	["Beret (SAS)", "H_Beret_brn_SF", 25, "hat"],
	["Beret (SF)", "H_Beret_grn_SF", 25, "hat"],
	["Beret (RED)", "H_Beret_ocamo", 25, "hat"],
	["Black Turban", "H_TurbanO_blk", 30, "hat"],
	["Booniehat (Dirty)","H_Booniehat_dirty", 25,"hat"],
	["Booniehat (Green)","H_Booniehat_grn", 25,"hat"],
	["Booniehat (Khaki)","H_Booniehat_khk", 25,"hat"],
	["Booniehat (MTP)","H_Booniehat_mcamo", 25,"hat"],
	["Booniehat (Tan)","H_Booniehat_tan", 25,"hat"],
	["Booniehat (GREEN)","H_Booniehat_dgtl", 25,"hat"],
	["Booniehat (Indepen)", "H_Booniehat_indp", 25, "hat"],
	["Fedora (Blue)", "H_Hat_blue", 20, "hat"],
	["Fedora (Brown)", "H_Hat_brown", 20, "hat"],
	["Fedora (Camo)", "H_Hat_camo", 20, "hat"],
	["Fedora (Checker)", "H_Hat_checker", 20, "hat"],
	["Fedora (Gray)", "H_Hat_grey", 20, "hat"],
	["Fedora (Tan)", "H_Hat_tan", 20, "hat"],
	["Blue Cap", "H_MilCap_blue", 20, "hat"],
	["Cap (BI)","H_Cap_grn_BI", 20,"hat"],
	["Cap (Black)","H_Cap_blk", 20,"hat"],
	["Cap (Blue)","H_Cap_blu", 20,"hat"],
	["Cap (CMMG)","H_Cap_blk_CMMG", 20,"hat"],
	["Cap (Green)","H_Cap_grn", 20,"hat"],
	["Cap (Olive)","H_Cap_oli", 20,"hat"],
	["Cap (ION)","H_Cap_blk_ION", 20,"hat"],
	["Cap (Raven Security)","H_Cap_blk_Raven", 20,"hat"],
	["Cap (Red)","H_Cap_red", 20,"hat"],
	["Cap (SAS)","H_Cap_khaki_specops_UK", 20,"hat"],
	["Cap (SF)","H_Cap_tan_specops_US", 20,"hat"],
	["Cap (SPECOPS)","H_Cap_brn_SPECOPS", 20,"hat"],
	["Cap (Tan)","H_Cap_tan", 20,"hat"],
	["Shemag (Khaki)","H_ShemagOpen_khk", 20,"hat"],
	["Shemag (Tan)","H_ShemagOpen_tan", 20,"hat"],
	["Shemag mask (Khaki)","H_Shemag_khk", 20,"hat"],
	["Shemag mask (Olive)","H_Shemag_olive", 20,"hat"],
	["Shemag mask (Tan)","H_Shemag_tan", 20,"hat"],
	["Straw Hat","H_StrawHat", 20,"hat"],
	["Straw Hat (Dark)","H_StrawHat_dark", 20,"hat"],
	//["Checked Cap 1","H_MilCap_chck1", 20,"hat"],
	//["Checked Cap 2","H_MilCap_chck2", 20,"hat"],
	//["Checked Cap 3","H_MilCap_chck3", 20,"hat"],
	["Military Cap (Gray)","H_MilCap_gry", 20,"hat"],
	["Military Cap (Hex)","H_MilCap_ocamo", 20,"hat"],
	["Military Cap (MTP)","H_MilCap_mcamo", 20,"hat"],
	["Military Cap (Russia)","H_MilCap_rucamo", 20,"hat"],
	["Military Cap (Urban)","H_MilCap_oucamo", 20,"hat"],
	["Military Cap (Green)","H_MilCap_dgtl", 20,"hat"],
	["Rangemaster Cap", "H_Cap_headphones", 20, "hat"],
	["Combat Helmet (Black)", "H_HelmetB_plain_blk", 100, "hat"],
	["Combat Helmet (Camo)", "H_HelmetB_plain_blk", 100, "hat"],
	["Assassin Helmet (Black)", "H_HelmetSpecO_blk", 250, "hat"],
	["Assassin Helmet (Hex)", "H_HelmetSpecO_ocamo", 250, "hat"],
	["Crew Helmet","H_HelmetCrew_B", 120,"hat"],
	["Crew Helmet (Green)","H_HelmetCrew_I", 120,"hat"],
	["Crew Helmet (Red)","H_HelmetCrew_O", 120,"hat"],
	["MICH","H_HelmetIA", 120,"hat"],
	["MICH (Camo)","H_HelmetIA_net", 120,"hat"],
	["MICH 2 (Camo)","H_HelmetIA_camo", 120,"hat"],
	["ECH","H_HelmetB", 120,"hat"],
	["ECH (Camo)","H_HelmetB_camo", 120,"hat"],
	["ECH (Light)","H_HelmetB_light", 120,"hat"],
	["ECH (Spraypaint)","H_HelmetB_paint", 120,"hat"],
	["SF Helmet","H_HelmetSpecB", 120,"hat"],
	["SF Helmet (Black)","H_HelmetSpecB_blk", 120,"hat"],
	["SF Helmet (Dark Paint)","H_HelmetSpecB_paint2", 120,"hat"],
	["SF Helmet (Light Paint)","H_HelmetSpecB_paint1", 120,"hat"],
	["Defender Helmet (Hex)","H_HelmetLeaderO_ocamo", 120,"hat"],
	["Defender Helmet (Urban)","H_HelmetLeaderO_oucamo", 120,"hat"],
	["Protector Helmet (Hex)","H_HelmetO_ocamo", 100,"hat"],
	["Protector Helmet (Urban)","H_HelmetO_oucamo", 100,"hat"],
	["Heli Crew Helmet (Blue)","H_CrewHelmetHeli_B", 120,"hat"],
	["Heli Crew Helmet (Red)","H_CrewHelmetHeli_O", 120,"hat"],
	["Heli Crew Helmet (Green)","H_CrewHelmetHeli_I", 120,"hat"],
	["Heli Pilot Helmet (Blue)","H_PilotHelmetHeli_B", 120,"hat"],
	["Heli Pilot Helmet (Red)","H_PilotHelmetHeli_O", 120,"hat"],
	["Heli Pilot Helmet (Green)","H_PilotHelmetHeli_I", 120,"hat"],	
	["Pilot Helmet (Blue)","H_PilotHelmetFighter_B", 130,"hat"],
	["Pilot Helmet (Red)","H_PilotHelmetFighter_O", 130,"hat"],
	["Pilot Helmet (Green)","H_PilotHelmetFighter_I", 130,"hat"]
];

uniformArray= compileFinal str
[
	["Default Uniform", "U_B_CombatUniform_mcam", 100, "uni"],
	["Fatigues (Urban)","U_O_CombatUniform_oucamo", 100,"uni"],
	["Recon Fatigues (Black)","U_O_SpecopsUniform_blk", 100,"uni"],
	["Recon Fatigues (Hex)","U_O_SpecopsUniform_ocamo", 100,"uni"],
	["Recon Fatigues (MTP)","U_B_CombatUniform_wdl_vest", 100,"uni"],
	["Recon Fatigues (MTP)","U_B_CombatUniform_sgg_vest", 100,"uni"],
	["Recon Fatigues (MTP)","U_B_CombatUniform_mcam_vest", 100,"uni"],
	["Combat Fatigues (MTP)","U_B_CombatUniform_wdl", 100,"uni"],
	["Combat Fatigues (MTP)","U_B_CombatUniform_sgg", 100,"uni"],
	//["Combat Fatigues (MTP)(TEE)", "U_B_CombatUniform_mcam_tshirt", 100, "uni"],
	//["Combat Fatigues (MTP)(TEE)", "U_B_CombatUniform_wdl_tshirt", 100, "uni"],
	//["Combat Fatigues (MTP)(TEE)", "U_B_CombatUniform_sgg_tshirt", 100, "uni"],
	["Combat Fatigues Short", "U_I_CombatUniform_shortsleeve", 100, "uni"],
	["Combat Fatigues Shirt", "U_I_CombatUniform_tshirt", 100, "uni"],
	["Officer Fatigues (Hex)", "U_O_OfficerUniform_ocamo", 100, "uni"],
	["Officer Fatigues (Hex)", "U_I_OfficerUniform", 100, "uni"],
	["Worn Combat Fatigues (MTP)", "U_B_CombatUniform_mcam_worn", 100, "uni"],
	["SpecOps Fatigues", "U_B_SpecopsUniform_sgg", 100, "uni"],
	["Rangemaster Suit", "U_Rangemaster", 100, "uni"],
	["Wetsuit","U_B_Wetsuit", 200,"uni"],
	["Ghillie Suit","U_B_GhillieSuit", 450,"uni"],
	["Pilot Coveralls (Blue)", "U_B_PilotCoveralls", 100, "uni"],
	["Pilot Coveralls (Red)", "U_O_PilotCoveralls", 100, "uni"],
	["Pilot Coveralls (Green)", "U_I_pilotCoveralls", 100, "uni"],
	["Heli Pilot Coveralls Blue", "U_B_HeliPilotCoveralls", 100, "uni"],
	["Heli Pilot Coveralls Green", "U_I_HeliPilotCoveralls", 100, "uni"],
	["Guerilla Smocks 1", "U_IG_leader", 100, "uni"],
	["Guerilla Smocks 2", "U_IG_Guerilla1_1", 100, "uni"],
	//["Guerilla Smocks 3", "U_IG_Guerilla2_1", 100, "uni"],
	["Guerilla Smocks 4", "U_IG_Guerilla2_2", 100, "uni"],
	["Guerilla Smocks 5", "U_IG_Guerilla2_3", 100, "uni"],
	["Guerilla Smocks 6", "U_IG_Guerilla3_1", 100, "uni"],
	["Guerilla Smocks 7", "U_IG_Guerilla3_2", 100, "uni"],
	//["Common Clothes 1","U_C_Commoner1_1", 50,"uni"],
	//["Common Clothes 2","U_C_Commoner1_2", 50,"uni"],
	//["Common Clothes 3","U_C_Commoner1_3", 50,"uni"],
	//["Common Clothes 4","U_C_Commoner2_1", 50,"uni"],
	//["Common Clothes 5","U_C_Commoner2_2", 50,"uni"],
	//["Common Clothes 6","U_C_Commoner2_3", 50,"uni"],
	//["Common Shorts","U_C_Commoner_shorts", 50,"uni"],
	//["Surfer Outfit 1","U_C_ShirtSurfer_shorts", 50,"uni"],
	//["Surfer Outfit 2","U_C_TeeSurfer_shorts_1", 50,"uni"],
	//["Surfer Outfit 3","U_C_TeeSurfer_shorts_2", 50,"uni"],
	["Polo Red/White","U_C_Poloshirt_redwhite", 50,"uni"],
	["Polo Salmon","U_C_Poloshirt_salmon", 50,"uni"],
	["Polo tri-color","U_C_Poloshirt_tricolour", 50,"uni"],
	["Polo Blue","U_C_Poloshirt_blue", 50,"uni"],
	["Polo Burgundy","U_C_Poloshirt_burgundy", 50,"uni"],
	["Polo Stripped","U_C_Poloshirt_stripped", 50,"uni"],
	["Competitor Suit","U_Competitor", 50,"uni"],
	["Jacket and Shorts","U_OrestesBody", 50,"uni"],
	//["Kabeiroi Leader's Outfit","U_IG_Menelaos", 50,"uni"],
	//["Novak's Leisure Suit","U_C_Novak", 50,"uni"],
	//["Scientist Suit","U_OI_Scientist", 50,"uni"],
	//["Cleric's Robes","U_C_PriestBody", 50,"uni"],
	//["Farmer Clothes","U_C_Farmer", 50,"uni"],
	//["Hunting Clothes (Brown)","U_C_HunterBody_brn", 50,"uni"],
	["Hunting Clothes (Green)","U_C_HunterBody_grn", 50,"uni"],
	//["Fishing Overalls","U_C_FishermanOveralls", 50,"uni"],
	//["Fisherman Clothes","U_C_Fisherman", 50,"uni"],
	//["Scavenger Clothes (Light)","U_C_Scavenger_1", 50,"uni"],
	//["Scavenger Clothes (Dark)","U_C_Scavenger_2", 50,"uni"],
	//["Worker Clothes","U_C_WorkerOveralls", 50,"uni"],
	["Worker Coveralls","U_C_WorkerCoveralls", 50,"uni"],
	["Worn Clothes 1","U_C_Poor_1", 50,"uni"],
	["Worn Clothes 2","U_C_Poor_2", 50,"uni"]
	//["Worn Shorts 1","U_C_Poor_shorts_1", 50,"uni"],
	//["Worn Shorts 2","U_C_Poor_shorts_2", 50,"uni"]
	//["Underwear","U_BasicBody", 20,"uni"]
	//["Underwear 1","U_NikosBody", 20,"uni"],
	//["Underwear 2","U_MillerBody", 20,"uni"],
	//["Underwear 3","U_KerryBody", 20,"uni"],
	//["Underwear 4","U_AttisBody", 20,"uni"],
	//["Underwear 5","U_AntigonaBody", 20,"uni"]
];

vestArray= compileFinal str
[
	//["Carrier GL Rig (Black)","V_PlateCarrierGL_blk", 250,"vest"],
	//["Carrier GL Rig (Coyote)","V_PlateCarrierGL_cbr", 250,"vest"],
	["Carrier GL Rig (Green)","V_PlateCarrierGL_rgr", 250,"vest"],
	["Carrier Lite (Black)","V_PlateCarrier1_blk", 250,"vest"],
	//["Carrier Lite (Coyote)","V_PlateCarrier1_cbr", 250,"vest"],
	["Carrier Lite (Green)","V_PlateCarrier1_rgr", 250,"vest"],
	//["Carrier Rig (Black)","V_PlateCarrier2_blk", 250,"vest"],
	//["Carrier Rig (Coyote)","V_PlateCarrier2_cbr", 250,"vest"],
	["Carrier Rig (Green)","V_PlateCarrier2_rgr", 250,"vest"],
	["Carrier Rig (Green 2)","V_PlateCarrier3_rgr", 250,"vest"],
	//["Carrier Special Rig (Coyote)","V_PlateCarrierSpec_cbr", 275,"vest"],
	["Carrier Special Rig (Green)","V_PlateCarrierSpec_rgr", 275,"vest"],
	["Fighter Chestrig (Black)","V_Chestrig_blk", 275,"vest"],
	["Fighter Chestrig (Olive)","V_Chestrig_oli", 275,"vest"],
	["GA Carrier GL Rig","V_PlateCarrierIAGL_dgtl", 275,"vest"],
	["GA Carrier Lite (Digi)","V_PlateCarrierIA1_dgtl", 275,"vest"],
	["GA Carrier Rig (Digi)","V_PlateCarrierIA2_dgtl", 275,"vest"],
	["LBV Harness", "V_HarnessO_brn", 250, "vest"],
	["LBV Harness (Gray)", "V_HarnessO_gry", 250, "vest"],
	["LBV Gren Harness", "V_HarnessOGL_brn", 250, "vest"],
	["LBV Gren Harness (Gray)", "V_HarnessOGL_gry", 250, "vest"],
	["ELBV Harness", "V_HarnessOSpec_brn", 250, "vest"],
	["ELBV Harness (Gray)", "V_HarnessOSpec_gry", 250, "vest"],
	["Chest Rig (Khaki)","V_Chestrig_khk", 300,"vest"],
	["Chest Rig (Green)","V_Chestrig_rgr", 300,"vest"],
	["Slash Bandolier (Black)","V_BandollierB_blk", 100,"vest"],
	["Slash Bandolier (Coyote)","V_BandollierB_cbr", 100,"vest"],
	["Slash Bandolier (Green)","V_BandollierB_rgr", 100,"vest"],
	["Slash Bandolier (Khaki)","V_BandollierB_khk", 100,"vest"],
	["Slash Bandolier (Olive)","V_BandollierB_oli", 100,"vest"],
	["Tactical Vest (Black)","V_TacVest_blk", 100,"vest"],
	["Tactical Vest (Brown)","V_TacVest_brn", 100,"vest"],
	["Tactical Vest (Camo)","V_TacVest_camo", 100,"vest"],
	["Tactical Vest (Olive)","V_TacVest_oli", 100,"vest"],
	["Tactical Vest (Khaki)","V_TacVest_khk", 100,"vest"],
	["Tactical Vest (Police)","V_TacVest_blk_POLICE", 100,"vest"],
	["Rangemaster Belt", "V_Rangemaster_belt", 100, "vest"],
	["Rebreather","V_RebreatherB", 250,"vest"],
	["Camouflaged Vest","V_TacVestCamo_khk", 100,"vest"],
	["Raven Vest","V_TacVestIR_blk", 100,"vest"]
];

genItemArray= compileFinal str
[
	["GPS","ItemGPS", 100,"item"],
	["Binoculars","Binocular",50,"binoc"],
	["NV Goggles","NVGoggles",100,"binoc"],
	["Diving Goggles","G_Diving",100,"gogg"],
	["Rangefinder","Rangefinder",150,"binoc"],   
	["Laser Designator","Laserdesignator",200,"binoc"],
	//["Laser Batteries","Laserbatteries",20,"item"],
	["Mine Detector","MineDetector",100,"item"],
	["First Aid","FirstAidKit", 50,"item"],
	["Medkit","Medikit", 150,"item"],
	["Toolkit","ToolKit", 150,"item"],
	["UAV Terminal Blue","b_uavterminal", 150,"item"],
	["UAV Terminal Red","o_uavterminal", 150,"item"],
	["UAV Terminal Green","i_uavterminal", 150,"item"],
	["Empty Crate","Box_NATO_Ammo_F", 150,"ammocrate"]
	//["Empty Weapon Crate","Box_NATO_Wps_F", 250,"weaponcrate"]
];

genObjectsArray= compileFinal str
[
	["Barrier: Concrete","Land_CncBarrier_F",200,"object"],
	["Barrier: C Long","Land_CncBarrierMedium_F", 250,"object"],
	["Barrier: C Med","Land_CncBarrierMedium4_F", 175,"object"],
	["Barrier: H-1","Land_HBarrier_1_F", 50,"object"],
	["Barrier: H-3","Land_HBarrier_3_F", 100,"object"],
	["Barrier: H-4","Land_HBarrierBig_F", 175,"object"],
	["Barrier: H-5","Land_HBarrier_5_F", 250,"object"],
	["Barrier: Safety","Land_Crash_barrier_F",100,"object"],
	["Wall: H4","Land_HBarrierWall4_F", 200,"object"],
	["Wall: H6","Land_HBarrierWall6_F", 200,"object"],
	["Wall: Concrete","Land_CncWall1_F", 200,"object"],
	["Wall: Concrete Long","Land_CncWall4_F", 300,"object"],
	["Wall: Concrete Mil","Land_Mil_ConcreteWall_F", 200,"object"],
	["Wall: Mill Big","Land_Mil_WallBig_4m_F", 300,"object"],
	["Wall: Stone","Land_Stone_8m_F", 300,"object"],
	["Wall: Shoot House","Land_Shoot_House_Wall_F", 180,"object"],
	["Canal: Wall Small","Land_Canal_WallSmall_10m_F", 200,"object"],
	["Canal: Wall Stairs","Land_Canal_Wall_Stairs_F", 250,"object"],
	["Barrier: Razorwire","Land_Razorwire_F",100,"object"],
	["Bag Fence Corner","Land_BagFence_Corner_F", 50,"object"],
	["Bag Fence End","Land_BagFence_End_F",50,"object"],
	["Bag Fence Long","Land_BagFence_Long_F",50,"object"],
	["Bag Fence Round","Land_BagFence_Round_F",50,"object"],
	["Bag Fence Short","Land_BagFence_Short_F",50,"object"],   
	["Gate: Bar","Land_BarGate_F",50,"object"],  
	["Bunker: Bag Small","Land_BagBunker_Small_F",175,"object"],
	["Bunker: Bag Large","Land_BagBunker_Large_F",300,"object"],
	["Shelter: CNC","Land_CncShelter_F",400,"object"],
	["Nest: Patrol","Land_Cargo_Patrol_V1_F",350,"object"],
	["Tower: H","Land_HBarrierTower_F",350,"object"],
	["Tower: Bag","Land_BagBunker_Tower_F",350,"object"],
	["Mound","Land_Mound01_8m_F", 150,"object"],
	["Mound: Low","Land_Mound02_8m_F",100,"object"],
	["Ramp: Concrete","Land_RampConcrete_F",200,"object"],
	["Ramp: Concrete High","Land_RampConcrete_F",250,"object"],
	["Scaffolding","Land_Scaffolding_F",50,"object"],
	["Pipes","Land_Pipes_Large_F",100,"object"],
	["Barrel: Metal","Land_MetalBarrel_F",75,"object"],
	["Toilet Box","Land_ToiletBox_F",50,"object"],
	["Lamp: Decor","Land_LampDecor_F",20,"object"],
	["Lamp: Shabby","Land_LampShabby_F",15,"object"]
];

//Text name, classname, buy cost, spawn type, color
landArray = compileFinal str
[
	["Quadbike Blue","B_Quadbike_01_F",250,"vehicle",125],
	["Quadbike Red","O_Quadbike_01_F",250,"vehicle",125],
	["Quadbike Green","I_Quadbike_01_F",250,"vehicle",125],
	["Quadbike Civilian","C_Quadbike_01_F",250,"vehicle",125],

	["Hatchback","C_Hatchback_01_F",600,"vehicle",250],
	["Hatchback Sport","C_Hatchback_01_sport_F",700,"vehicle",250],
	["SUV","C_SUV_01_F",600,"vehicle",250],
	["Offroad Blue","B_G_Offroad_01_F",500,"vehicle",250],
	["Offroad Civilian","C_Offroad_01_F",500,"vehicle",250],
	["Offroad Armed","B_G_Offroad_01_armed_F",500,"vehicle",250],

	["Truck","B_G_Van_01_transport_F",500,"vehicle",250],
	["Truck Box","C_Van_01_box_F",500,"vehicle",250],
	["Truck Civilian","C_Van_01_transport_F",500,"vehicle",250],
	["Fuel Truck","B_G_Van_01_fuel_F",10000,"vehicle",250],
	["Fuel Truck Civilian","C_Van_01_fuel_F",10000,"vehicle",250],

	["HEMTT","B_Truck_01_mover_F",500,"vehicle",250],
	["HEMTT Open","B_Truck_01_transport_F",700,"vehicle",400],
	["HEMTT Covered","B_Truck_01_covered_F",900,"vehicle",400],
	["HEMTT Box","B_Truck_01_box_F",500,"vehicle",250],
	["HEMTT Ammo","B_Truck_01_ammo_F",20000,"vehicle",250],
	["HEMTT Fuel","B_Truck_01_fuel_F",15000,"vehicle",250],
	["HEMTT Medical","B_Truck_01_medical_F",8000,"vehicle",250],
	["HEMTT Repair","B_Truck_01_Repair_F",11000,"vehicle",250],

	["Zamak Open Red","O_Truck_02_transport_F",700,"vehicle",400],
	["Zamak Covered Red","O_Truck_02_covered_F",900,"vehicle",400],
	["Zamak Open Green","I_Truck_02_transport_F",700,"vehicle",400],
	["Zamak Covered Green","I_Truck_02_covered_F",900,"vehicle",400],
	["Zamak Ammo Red","O_Truck_02_Ammo_F",20000,"vehicle",250],
	["Zamak Ammo Green","I_Truck_02_ammo_F",20000,"vehicle",250],
	["Zamak Fuel Red","O_Truck_02_fuel_F",15000,"vehicle",250],
	["Zamak Fuel Green","I_Truck_02_fuel_F",15000,"vehicle",250],
	["Zamak Medical Red","O_Truck_02_medical_F",8000,"vehicle",250],
	["Zamak Medical Green","I_Truck_02_medical_F",8000,"vehicle",250],
	["Zamak Repair Red","I_Truck_02_box_F",11000,"vehicle",250],
	["Zamak Repair Green","O_Truck_02_box_F",11000,"vehicle",250],

	["UGV Stomper Blue","B_UGV_01_F",500,"vehicle",250],
	["UGV Saif Red","O_UGV_01_F",1000,"vehicle",250],
	["UGV Stomper Green","I_UGV_01_F",1000,"vehicle",250],
	["UGV Stomper RCWS Blue","B_UGV_01_rcws_F",4000,"vehicle",250],
	["UGV Saif RCWS Red","O_UGV_01_rcws_F",4000,"vehicle",250],
	["UGV Stomper RCWS Green","I_UGV_01_rcws_F",4000,"vehicle",250]
]; 

armoredArray = compileFinal str
[
	["Hunter","B_MRAP_01_F",2000,"vehicle",1000],
	["Hunter HMG","B_MRAP_01_hmg_F",7000,"vehicle",3500],
	["Hunter GMG","B_MRAP_01_gmg_F",8000,"vehicle",4000],
	["Ifrit","O_MRAP_02_F",3000,"vehicle",1500],
	["Ifrit HMG","O_MRAP_02_hmg_F",8000,"vehicle",4000],
	["Ifrit GMG","O_MRAP_02_gmg_F",9000,"vehicle",4500],
	["Strider","I_MRAP_03_F",3000,"vehicle",1500],
	["Strider HMG","I_MRAP_03_hmg_F",8000,"vehicle",4000],
	["Strider GMG","I_MRAP_03_gmg_F",9000,"vehicle",4500],
	["AMV-7 Marshall","B_APC_Wheeled_01_cannon_F",13000,"vehicle",""],
	["MSE-3 Marid","O_APC_Wheeled_02_rcws_F",13000,"vehicle",""],
	["AFV-4 Madrid","I_APC_Wheeled_03_cannon_F",13000,"vehicle",""]
];

tanksArray = compileFinal str
[
	// New vehicles in the dev branch
	["IFV-6c Panther","B_APC_Tracked_01_rcws_F",17000,"vehicle",""],
	["BTR-K Kamysh","O_APC_Tracked_02_cannon_F",17000,"vehicle",""],
	["259 Sochor", "O_MBT_02_arty_F", 20000,"vehicle", ""],
	["CRV-6e Bobcat", "B_APC_Tracked_01_CRV_F", 20000,"vehicle", ""],
	["IFV-6a Cheetah", "B_APC_Tracked_01_CRV_F", 20000,"vehicle", ""],
	["IFV-6c Panther", "B_APC_Tracked_01_rcws_F", 20000,"vehicle", ""],
	["M2A1 Slammer", "B_MBT_01_cannon_F", 20000,"vehicle", ""],
	["M4 Scorcher", "B_MBT_01_arty_F", 20000,"vehicle", ""],
	["M5 Sandstorm MLRS", "B_MBT_01_mlrs_F", 20000,"vehicle", ""],
	["T-100 Varsuk", "O_MBT_02_cannon_F", 20000,"vehicle", ""],
	["ZSU-39 Tigris", "O_APC_Tracked_02_AA_F", 20000,"vehicle", ""]
];


helicoptersArray = compileFinal str
[
	["AR-2 Darter Blue", "B_UAV_01_F", 5000, "vehicle", ""],
	["AR-2 Darter Green", "I_UAV_01_F", 5000, "vehicle", ""],
	["AR-2 Tayran Red", "O_UAV_01_F", 5000, "vehicle", ""],

	["MH-9 Hummingbird","B_Heli_Light_01_F",5000,"vehicle",""],//little bird
	["PO-30 Orca (Black)", "O_Heli_Light_02_unarmed_F", 6000, "vehicle", ""], //ka-60
	["CH-49 Mohawk", "I_Heli_Transport_02_F", 8000, "vehicle", ""],//big transport chopper
	
	["UH-80 Ghosthawk","B_Heli_Transport_01_F",10000,"vehicle",""],//stealth chopper 2 gunners
	["AH-9 Pawnee","B_Heli_Light_01_armed_F",12000,"vehicle",""],//little bird with guns
	["PO-30 Orca", "O_Heli_Light_02_F", 13000, "vehicle", ""],//armed ka-60
	["AH-99 Blackfoot","B_Heli_Attack_01_F",20000,"vehicle",""],//attack chopper
	["Mi-48 Kajman", "O_Heli_Attack_02_F", 25000, "vehicle", ""], //attack chopper with gunner
	["Mi-48 Kajman (Black)", "O_Heli_Attack_02_black_F", 25000, "vehicle", ""] //attack chopper with gunner
];

jetsArray = compileFinal str
[
	["A-143 Buzzard (AA)","I_Plane_Fighter_03_AA_F",40000,"vehicle",4500],
	["A-143 Buzzard (CAS)","I_Plane_Fighter_03_CAS_F",35000,"vehicle",4500],
	["K40 Ababil-3 Red","O_UAV_02_F",40000,"vehicle",4500],
	["K40 Ababil-3 Green","I_UAV_02_F",40000,"vehicle",4500],
	["K40 Ababil-3 (CAS)Red","O_UAV_02_CAS_F",40000,"vehicle",4500],
	["K40 Ababil-3 (CAS)Green","I_UAV_02_CAS_F",40000,"vehicle",4500],
	["MQ4A Greyhawk","B_UAV_02_F",40000,"vehicle",4500],
	["MQ4A Greyhawk (CAS)","B_UAV_02_CAS_F",40000,"vehicle",4500]
];

boatsArray = compileFinal str
[
	["Assault Boat Blue","B_Boat_Transport_01_F",750,"boat",500],
	["Assault Boat Red","O_Boat_Transport_01_F",750,"boat",500],
	["Assault Boat Green","I_Boat_Transport_01_F",750,"boat",500],
	["Rescue Blue","B_Lifeboat",500,"boat",500],
	["Rescue Red","O_Lifeboat",500,"boat",500],
	["Rescue Civilian", "C_Rubberboat", 500,"boat",500],
	["Speedboat Minigun Blue","B_Boat_Armed_01_minigun_F",6000,"boat",3000],
	["Speedboat HMG","O_Boat_Armed_01_hmg_F",7000,"boat",3500],
	["Speedboat Minigun Green","I_Boat_Armed_01_minigun_F",5000,"boat",500]
];

submarinesArray = compileFinal str
[
	["SDV Submarine Blue", "B_SDV_01_F", 1500, "submarine", 750],
	["SDV Submarine Red", "O_SDV_01_F", 1500, "submarine", 750],
	["SDV Submarine Green", "I_SDV_01_F", 1500, "submarine", 750]
];

uavArray = compileFinal str
[
	"O_UAV_02_F",
	"I_UAV_02_F",
	"O_UAV_02_CAS_F",
	"I_UAV_02_CAS_F",
	"B_UAV_02_F",
	"B_UAV_02_CAS_F",
	"B_UAV_01_F",
	"I_UAV_01_F",
	"O_UAV_01_F",
	"B_UGV_01_F",
	"O_UGV_01_F",
	"I_UGV_01_F",
	"B_UGV_01_rcws_F",
	"O_UGV_01_rcws_F",
	"I_UGV_01_rcws_F"
];

noColorVehs = compileFinal str
[
	"HEMTT Open",
	"HEMTT Covered",
	"Ifrit",
	"Ifrit HMG",
	"Ifrit GMG",
	"Strider",
	"Strider HMG",
	"Strider GMG",
	"MSE-3 Marid",
	"AH-99 Blackfoot",
	"Assault Boat Blue",
	"SDV Submarine Blue",
	"IFV-6c Panther",
	"BTR-K Kamysh",
	"Truck",
	"Truck Box",
	"Truck Civilian",
	"Fuel Truck",
	"Fuel Truck Civilian",
	"Hatchback",
	"Hatchback Sport",
	"SUV",
	"Offroad Blue",
	"Offroad Civilian",
	"Offroad Armed",
	"259 Sochor",
	"CRV-6e Bobcat",
	"IFV-6a Cheetah",
	"IFV-6c Panther",
	"T-100 Varsuk",
	"ZSU-39 Tigris"
];

RGBVehicles = compileFinal str 
[
	"Quadbike Blue",
	"Quadbike Red",
	"Quadbike Green",
	"Quadbike Civilian",
	"Zamak Open",
	"Zamak Covered",
	"Assault Boat Red",
	"Assault Boat Green",
	"Rescue Blue",
	"Rescue Red",
	"Rescue Civilian",
	"UH-80 Ghosthawk",
	"SDV Submarine Green",
	"SDV Submarine Red"
];

//color, isARGB
colorsArray = compileFinal str
[
	["Black", true],
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
// ["Medical Kit","medkits",localize "STR_WL_ShopDescriptions_MedKit","client\icons\medkit.paa",400,200],  this really isnt needed we got FaK's ingame now
generalStore = compileFinal str [
	["Bottled Water","water",localize "STR_WL_ShopDescriptions_Water","client\icons\water.paa",30,15],
	["Canned Food","canfood",localize "STR_WL_ShopDescriptions_CanFood","client\icons\cannedfood.paa",30,15],
	["Repair Kit","repairkits",localize "STR_WL_ShopDescriptions_RepairKit","client\icons\briefcase.paa",500,250],
	["Jerry Can (Full)","fuelFull",localize "STR_WL_ShopDescriptions_fuelFull","client\icons\jerrycan.paa",150,75],
    ["Jerry Can (Empty)","fuelEmpty",localize "STR_WL_ShopDescriptions_fuelEmpty","client\icons\jerrycan.paa",50,25],
    ["Spawn Beacon","Spawn Beacon",localize "STR_WL_ShopDescriptions_spawnBeacon","client\icons\briefcase.paa",1500,750],
    ["Camo Net","Camo Net",localize "STR_WL_ShopDescriptions_Camo","client\icons\briefcase.paa",200,100],
    ["Syphon Hose","Syphon Hose",localize "STR_WL_ShopDescriptions_SyphonHose","client\icons\jerrycan.paa",200,100],
    ["Energy Drink","Energy Drink",localize "STR_WL_ShopDescriptions_Energy_Drink","client\icons\briefcase.paa",100,50],
    ["Warchest","warchest",localize "STR_WL_ShopDescriptions_Warchest","client\icons\briefcase.paa",1000,500]
];


// Notes: Gun and general stores have position of spawned crate, vehicle stores have an extra air spawn direction
//
// Array contents are as follows:
//
// Name
// Building Position
// Desk Direction Modifier
// Excluded Buttons
storeOwnerConfig = compileFinal str
[
	["GunStore1", 1, 180, [],[3362.89,13205.5,2.9902]],
	["GunStore2", 1, -90, [],[16707.1,12783.8,19.0095]],
	["GunStore3", 6, -30, [],[25786.9,21364.7,24.1738]],
	["GunStore4", 4, 280, [],[9438.15,20269.8,126.081]],
	["GenStore1", 6, 60, [],[11532.4,9426.95,23.7564]],
	["GenStore2", 6, 75, [],[20785.1,6800.53,39.3656]],
	["GenStore3", 6, 220, [],[18081.5,15243.8,28.7699]],
	["GenStore4", 0, 90, [],[9266.39,15867.5,121.293]],
	["VehStore1", 1, 230, [], 50],
	["VehStore2", 6, 210, ["Boats", "Submarines"],185],
	["VehStore3", 4, 60, ["Boats","Submarines"],20],
	["VehStore4", 5, 0, ["Boats","Submarines"], 30]
];

// Outfits for store owners
storeOwnerConfigAppearance = compileFinal str
[
	['GunStore1', [['weapon', 'LMG_Mk200_MRCO_F'], ['uniform', 'U_I_Ghilliesuit'], ['switchMove', 'AmovPercMstpSrasWrflDnon']]],
	['GunStore2', [['weapon', 'LMG_Zafir_pointer_F'], ['uniform', 'U_I_HeliPilotCoveralls'], ['switchMove', 'AmovPercMstpSrasWrflDnon']]],
	['GunStore3', [['weapon', 'srifle_GM6_SOS_F'], ['uniform', 'U_I_CombatUniform_tshirt'], ['switchMove', 'AmovPercMstpSrasWrflDnon']]],
	['GunStore4', [['weapon', 'arifle_Mk20_GL_MRCO_pointer_F'], ['uniform', 'U_I_Wetsuit'], ['switchMove', 'AmovPercMstpSrasWrflDnon']]],
	['GenStore1', [['weapon', ''], ['uniform', 'U_B_SpecopsUniform_sgg']]],
	['GenStore2', [['weapon', ''], ['uniform', 'U_I_OfficerUniform']]],
	['GenStore3', [['weapon', ''], ['uniform', 'U_O_SpecopsUniform_ocamo']]],
	['GenStore4', [['weapon', ''], ['uniform', 'C_Orestes']]],
	['VehStore1', [['weapon', ''], ['uniform', '']]],
	['VehStore2', [['weapon', ''], ['uniform', '']]],
	['VehStore3', [['weapon', ''], ['uniform', '']]],
	['VehStore4', [['weapon', ''], ['uniform', '']]]
];
