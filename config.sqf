//	@file Version: 1.0
//	@file Name: config.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, [GoT] JoSchaap, AgentRev
//	@file Created: 20/11/2012 05:13
//	@file Description: Main config.

// To calculate price for vests
_getCapacity = 
{
	private ["_item", "_capacity", "_containerClass"];
	_item = _this select 0;
	
	if (_item isKindOf "Bag_Base") then
	{
		_capacity = getNumber (configFile >> "CfgVehicles" >> _item >> "maximumLoad");
	}
	else
	{
		_containerClass = getText (configFile >> "CfgWeapons" >> _item >> "ItemInfo" >> "containerClass");
		_capacity = getNumber (configFile >> "CfgVehicles" >> _containerClass >> "maximumLoad");
	};
	
	_capacity
};

//Gunstore Weapon List - Gun Store Base List
// Text name, classname, buy cost, sell amount
weaponsArray = compileFinal str
[
		// Handguns
	["P07 Pistol","hgun_P07_F",50,25],
	["Rook-40 Pistol","hgun_Rook40_F",50,25],
	["ACP-C2 Pistol","hgun_ACPC2_F",75,25],
	
		// Underwater Gun
	["SDAR UW Rifle","arifle_SDAR_F",100,50],
	
		// Submachine Guns
	["PDW 2000 SMG","hgun_PDW2000_F",100,50],
	["Sting SMG","SMG_02_F",125,75],
	["Vermin SBR SMG","SMG_01_F",125,75],
	
		// Assault Rifles
	["TRG-20 Carabine","arifle_TRG20_F",150,50],
	["TRG-21 Rifle","arifle_TRG21_F",200,100],
	["TRG-21 EGLM Rifle","arifle_TRG21_GL_F",250,125],
	["Mk20 Carabine","arifle_Mk20C_F",150,75],
	["Mk20 Rifle","arifle_Mk20_F",200,100],
	["Mk20 EGLM Rifle","arifle_Mk20_GL_F",250,125],
	["Katiba Carabine","arifle_Katiba_C_F",150,75],
	["Katiba Rifle","arifle_Katiba_F",200,100],
	["Katiba GL Rifle","arifle_Katiba_GL_F",250,125],
	["MX Carabine","arifle_MXC_F",150,75],
	["MX Rifle","arifle_MX_F",200,100],
	["MX 3GL Rifle","arifle_MX_GL_F",250,125],
	
		// Light Machine Guns
	["MX SW LMG","arifle_MX_SW_F",300,150],
	["Mk200 LMG","LMG_Mk200_F",350,175],
	["Zafir LMG","LMG_Zafir_F",400,200],
	
		// Marksman Rifles
	["MXM Rifle","arifle_MXM_F",300,150],
	["Mk18 ABR Rifle","srifle_EBR_F",400,200],
	
		// Sniper Rifles
	["M320 LRR Sniper","srifle_LRR_SOS_F",1000,500],
	["GM6 Lynx Sniper","srifle_GM6_SOS_F",1000,500],
	
		//Rocket Launchers
	["PCML Rocket Launcher","launch_NLAW_F",400,200],
	["RPG-42 Alamut Launcher","launch_RPG32_F",500,250],
	["Titan MPRL Compact","launch_Titan_short_F",600,300],
	["Titan MPRL AA Launcher","launch_Titan_F",600,300]
];

//Gun Store Ammo List
//Text name, classname, buy cost
ammoArray = compileFinal str
[
	["9mm 16Rnd Mag","16Rnd_9x21_Mag",10],                          // P07, Rook-40
	["9mm 30Rnd Mag","30Rnd_9x21_Mag",20],                          // Scorpion
	[".45 ACP 9Rnd Mag","9Rnd_45ACP_Mag",10],                       // ACP-C2
	[".45 ACP 30Rnd Vermin Mag","30Rnd_45ACP_Mag_SMG_01",20],       // Vermin
	
	["5.56mm 20Rnd UW Mag","20Rnd_556x45_UW_mag",10],               // SDAR (junk ammo)
	["5.56mm 30Rnd STANAG Mag","30Rnd_556x45_Stanag",20],           // SDAR, TRG-2x, Mk20
	["6.5mm 30Rnd Caseless Mag","30Rnd_65x39_caseless_green",20],   // Katiba
	["6.5mm 30Rnd STANAG Mag","30Rnd_65x39_caseless_mag",20],       // MX
	["6.5mm 100Rnd Belt Case","100Rnd_65x39_caseless_mag",75],      // MX
	["6.5mm 200Rnd Belt Case","200Rnd_65x39_cased_Box",150],        // Mk200
	
	["7.62mm 20Rnd Mag","20Rnd_762x51_Mag",25],                     // EBR
	["7.62mm 150Rnd Belt Case","150Rnd_762x51_Box",150],            // Zafir
	
	[".408 7Rnd Mag","7Rnd_408_Mag",50],                            // M320 LRR
	["12.7mm 5Rnd Mag","5Rnd_127x108_Mag",50],                      // GM6 Lynx
	
	["40mm HE Grenade","1Rnd_HE_Grenade_shell",125],
	["Frag Grenade","HandGrenade",100],
	
	["PCML Missile","NLAW_F",250],      	// Direct damage: high   | Splash damage: low  | Guidance: none
	["RPG-42 Missile","RPG32_HE_F",300],	// Direct damage: high   | Splash damage: high | Guidance: none
	["Titan AT Missile","Titan_AT",350],	// Direct damage: high   | Splash damage: low  | Guidance: mouse, laser, ground vehicles
	["Titan AP Missile","Titan_AP",350],	// Direct damage: medium | Splash damage: high | Guidance: mouse, laser
	["Titan AA Missile","Titan_AA",350],	// Direct damage: medium | Splash damage: high | Guidance: aircraft
	
	["APERS Tripwire Mine","APERSTripMine_Wire_Mag",150],
	["APERS Bounding Mine","APERSBoundingMine_Range_Mag",200],
	["APERS Mine","APERSMine_Range_Mag",200],
	["Claymore Charge","ClaymoreDirectionalMine_Remote_Mag",250],
	["M6 SLAM Mine","SLAMDirectionalMine_Wire_Mag",250],
	["AT Mine","ATMine_Range_Mag",250],
	["Explosive Charge","DemoCharge_Remote_Mag",250],
	["Explosive Satchel","SatchelCharge_Remote_Mag",250],
	
	["40mm GL Flare (White)","UGL_FlareWhite_F",25],
	["40mm GL Flare (Green)","UGL_FlareGreen_F",25],
	["40mm GL Flare (Yellow)","UGL_FlareYellow_F",25],
	["40mm GL Flare (Red)","UGL_FlareRed_F",25],
	
	["Chemlight (Blue)","Chemlight_blue", 25],
	["Chemlight (Green)","Chemlight_green", 25],
	["Chemlight (Yellow)","Chemlight_yellow", 25],
	["Chemlight (Red)","Chemlight_red", 25]
];

//Gun Store Equipment List
//Text name, classname, buy cost
accessoriesArray = compileFinal str
[
	["Quadrotor UAV", "B_UAV_01_backpack_F", 500, "bpack"],
	["UAV Terminal", "B_UavTerminal", 200, "item"],
	["GPS","ItemGPS", 100,"item"],
	["Binoculars","Binocular",50,"binoc"],
	["Rangefinder","Rangefinder", 100,"binoc"],
	["Laser Designator","Laserdesignator", 150,"binoc"],
	["Laser Batteries","Laserbatteries", 25,"mag"],
	
	["First Aid Kit","FirstAidKit", 25,"item"],
	["Medikit","Medikit", 150,"item"],
	["Toolkit","ToolKit", 150,"item"],
	["Mine Detector","MineDetector", 100,"item"],
	
  	["Suppressor 9mm","muzzle_snds_L", 50,"item"],
	["Suppressor .45 ACP","muzzle_snds_acp", 75,"item"],
	["Suppressor 5.56mm","muzzle_snds_M", 100,"item"],
	["Suppressor 6.5mm","muzzle_snds_H", 100,"item"],
	["Suppressor 6.5mm LMG","muzzle_snds_H_MG", 125,"item"],
	["Suppressor 7.62mm","muzzle_snds_B", 125,"item"],
	
	["Flashlight","acc_flashlight", 50,"item"],
	["IR Laser Pointer","acc_pointer_IR", 50,"item"],
	
	["MRCO Sight","optic_MRCO", 50,"item"],
	["ACO Sight (Red)","optic_Aco", 75,"item"],
	["ACO Sight (Green)","optic_ACO_grn", 75,"item"],
	["ACO Sight SMG","optic_aco_smg", 75,"item"],
	["Holosight","optic_Holosight", 75,"item"],
	["Holosight SMG","optic_Holosight_smg", 75,"item"],
	["RCO Sight","optic_Hamr", 100,"item"],
	["ARCO Sight","optic_Arco", 100,"item"],
	["SOS Sight","optic_SOS", 200,"item"],
	["Nightvision Sight","optic_NVS", 300,"item"],
	["Thermal Sight","optic_tws", 400,"item"],
	["Thermal Sight LMG","optic_tws_mg", 400,"item"],
	["Nightstalker Sight","optic_Nightstalker", 500,"item"]
];

//Gun Store Gear List
//Text name, classname, buy cost
gearArray = compileFinal str
[
	["Field Pack (Coyote)","B_FieldPack_cbr", 200, "bpack"],
	["Field Pack (Khaki)","B_FieldPack_khk", 200, "bpack"],
	["Field Pack (Black)","B_FieldPack_blk", 200, "bpack"],
	["Bergen Pack (MTP)","B_Bergen_mcamo", 350, "bpack"],
	["Bergen Pack (Sage)","B_Bergen_sgg", 350, "bpack"],
	["Bergen Pack (Black)","B_Bergen_blk", 350, "bpack"],
	["Carryall Pack (MTP)","B_Carryall_mcamo", 500, "bpack"],
	["Carryall Pack (Khaki)","B_Carryall_khk", 500, "bpack"],
	["Carryall Pack (Olive)","B_Carryall_oli", 500, "bpack"],
	
	["Parachute","B_Parachute", 250,"bpack"],
	
	["Ghillie Suit","U_I_GhillieSuit", 250,"uni"],
	
	["Wetsuit","U_B_Wetsuit", 100,"uni"],
	["Rebreather","V_RebreatherB", 100,"vest"],
	["Diving Goggles","G_Diving", 50,"gogg"],
	
	["Default Uniform","U_B_CombatUniform_mcam", 25,"uni"],
	
	// Most vest camos are not implemented yet
	
	["Carrier GL Rig (Green)","V_PlateCarrierGL_rgr", ["V_PlateCarrierGL_rgr"] call _getCapacity, "vest"],
	["LBV Harness","V_HarnessO_brn", ["V_HarnessO_brn"] call _getCapacity, "vest"],
	["GA Carrier Rig (Digi)","V_PlateCarrierIA2_dgtl", ["V_PlateCarrierIA2_dgtl"] call _getCapacity, "vest"],
	
	["Booniehat (MTP)","H_Booniehat_mcamo", 10,"hat"],
	["Booniehat (Hex)","H_Booniehat_ocamo", 10,"hat"],
	["Booniehat (Digital)","H_Booniehat_dgtl", 10,"hat"],
	["Booniehat (Khaki)","H_Booniehat_khk", 10,"hat"],
	["Booniehat (Green)","H_Booniehat_grn", 10,"hat"],
	["Cap (Blue)","H_Cap_blu", 10,"hat"],
	["Cap (Red)","H_Cap_red", 10,"hat"],
	["Cap (Green)","H_Cap_grn", 10,"hat"],
	["Cap (Tan)","H_Cap_tan", 10,"hat"],
	["Cap (Black)","H_Cap_blk", 10,"hat"],
	["Rangemaster Cap","H_Cap_headphones", 10,"hat"],
	["Military Cap (MTP)","H_MilCap_mcamo", 10,"hat"],
	["Military Cap (Hex)","H_MilCap_ocamo", 10,"hat"],
	["Military Cap (Urban)","H_MilCap_oucamo", 10,"hat"],
	["Pilot Helmet (NATO)","H_PilotHelmetFighter_B", 50,"hat"],
	["Pilot Helmet (CSAT)","H_PilotHelmetFighter_O", 50,"hat"],
	["Pilot Helmet (AAF)","H_PilotHelmetFighter_I", 50,"hat"]
];

allGunStoreItems = compileFinal str ((call weaponsArray) + (call ammoArray) + (call accessoriesArray) + (call gearArray));

//General Store Item List
//Display Name, Class Name, Description, Picture, Buy Price, Sell Price.
generalStore = compileFinal str
[
	["Drinking Water","water",localize "STR_WL_ShopDescriptions_Water","client\icons\water.paa",30,15],
	["Snack Food","canfood",localize "STR_WL_ShopDescriptions_CanFood","client\icons\cannedfood.paa",30,15],
	["Repair Kit","repairkits",localize "STR_WL_ShopDescriptions_RepairKit","client\icons\briefcase.paa",250,125],
	["Jerry Can (Full)","fuelfull",localize "STR_WL_ShopDescriptions_fuelFull","client\icons\jerrycan.paa",150,75],
	["Jerry Can (Empty)","fuelempty",localize "STR_WL_ShopDescriptions_fuelEmpty","client\icons\jerrycan.paa",50,25],
	["Spawn Beacon","spawnbeacon",localize "STR_WL_ShopDescriptions_spawnBeacon","client\icons\briefcase.paa",1500,750],
	["Camo Net","camonet",localize "STR_WL_ShopDescriptions_Camo","client\icons\briefcase.paa",200,100],
	["Syphon Hose","syphonhose",localize "STR_WL_ShopDescriptions_SyphonHose","client\icons\jerrycan.paa",200,100],
	["Energy Drink","energydrink",localize "STR_WL_ShopDescriptions_Energy_Drink","client\icons\briefcase.paa",100,50],
	["Warchest","warchest",localize "STR_WL_ShopDescriptions_Warchest","client\icons\briefcase.paa",1000,500]
];

// Towns and cities array
// Marker Name, Diameter, City Name
cityList = compileFinal str
[
	["Town_1",400,"Kavala"],
	["Town_2",300,"Agios Dionysios"],
	["Town_3",150,"Abdera"],
	["Town_4",300,"Athira"],
	["Town_5",200,"Telos"],
	["Town_6",250,"Sofia"],
	["Town_7",250,"Paros"],
	["Town_8",300,"Pyrgos"],
	["Town_9",150,"Selakano"],
	["Town_10",200,"Vikos"],
	["Town_11",250,"Zaros"],
	["Town_12",300,"Neochori"],
	["Town_13",200,"Aggelochori"],
	["Town_14",200,"Panochori"],
	["Town_15",200,"Charkia"],
	["Town_16",150,"Chalkeia"]
];

militarylist = compileFinal str
[
	["milSpawn_1"],
	["milSpawn_2"],
	["milSpawn_3"],
	["milSpawn_4"],
	["milSpawn_5"],
	["milSpawn_6"],
	["milSpawn_7"],
	["milSpawn_8"],
	["milSpawn_9"],
	["milSpawn_10"],
	["milSpawn_11"],
	["milSpawn_12"],
	["milSpawn_13"],
	["milSpawn_14"]
];

cityLocations = [];

config_items_jerrycans_max = compileFinal "1";
config_items_syphon_hose_max = compileFinal "1";

config_refuel_amount_default = compileFinal "0.25";
config_refuel_amounts = compileFinal str
[
	["Quadbike_01_base_F", 0.75],
	["Tank", 0.10],
	["Air", 0.10],
	["Vehicle", 0.25]
];

// Is player saving enabled?
config_player_saving_enabled = compileFinal "0";

// Can players get extra in-game cash at spawn by donating?
config_player_donations_enabled = compileFinal "0";

// How much do players spawn with?
config_initial_spawn_money = compileFinal "100";

// Territory system definitions. See territory/README.md for more details.
//
// Format is:
// 1 - Territory marker name. Must begin with 'TERRITORY_'
// 2 - Descriptive name
// 3 - Monetary value
// 4 - Territory category, currently unused. See territory/README.md for details.
config_territory_markers = compileFinal str
[
	//["TERRITORY_AIRPORT_TEST", "Main Airport", 500, "AIRFIELD"] // Also add to the map to test
];

