// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: fn_refillbox.sqf  "fn_refillbox"
//	@file Author: [404] Pulse , [404] Costlyy , [404] Deadbeat, AgentRev
//	@file Created: 22/1/2012 00:00
//	@file Args: [OBJECT (Weapons box that needs filling), STRING (Name of the fill to give to object)]

if (!isServer) exitWith {};

#define RANDOM_BETWEEN(START,END) (START + floor random ((END - START) + 1))

private ["_box", "_boxType", "_boxItems", "_item", "_qty", "_mag"];
_box = _this select 0;
_boxType = _this select 1;

_box allowDamage false; // No more fucking busted crates
_box setVariable ["allowDamage", false, true]; // No more fucking busted crates
_box setVariable ["A3W_inventoryLockR3F", true, true];

// Clear pre-existing cargo first
clearBackpackCargoGlobal _box;
clearMagazineCargoGlobal _box;
clearWeaponCargoGlobal _box;
clearItemCargoGlobal _box;

if (_boxType == "mission_USSpecial2") then { _boxType = "mission_USSpecial" };

switch (_boxType) do
{
	case "mission_USLaunchers":
	{
		_boxItems =
		[
			// Item type, Item class(es), # of items, # of magazines per weapon
			["wep", ["launch_RPG32_F", "launch_NLAW_F", "launch_Titan_short_F"], RANDOM_BETWEEN(3,5), RANDOM_BETWEEN(1,2)],
			["wep", "launch_Titan_F", RANDOM_BETWEEN(1,2), RANDOM_BETWEEN(1,2)],
			["bac", ["B_Carryall_mcamo", "B_Kitbag_mcamo"], RANDOM_BETWEEN(2,5)],
			["mag", ["ClaymoreDirectionalMine_Remote_Mag", "SLAMDirectionalMine_Wire_Mag", "ATMine_Range_Mag", "DemoCharge_Remote_Mag", "SatchelCharge_Remote_Mag", "IEDUrbanBig_Remote_Mag"], RANDOM_BETWEEN(3,8)]
		];
	};
	case "mission_USSpecial":
	{
		_boxItems =
		[
			// Item type, Item class(es), # of items, # of magazines per weapon
			//["itm", "NVGoggles", 5],
			["wep", ["Binocular", "Rangefinder"], RANDOM_BETWEEN(1,5)],
			["bac", ["B_Carryall_mcamo", "B_Kitbag_mcamo"], RANDOM_BETWEEN(2,5)],
			["itm", "Medikit", RANDOM_BETWEEN(1,3)],
			["itm", "Toolkit", RANDOM_BETWEEN(0,1)],
			["itm", "ItemGPS", RANDOM_BETWEEN(0,1)],
			["itm", ["optic_MRCO", "optic_Arco", "optic_Hamr", "optic_SOS"], RANDOM_BETWEEN(0,2)],
			["itm", ["muzzle_snds_M", "muzzle_snds_H", "muzzle_snds_H_MG", "muzzle_snds_B", "muzzle_snds_acp"], RANDOM_BETWEEN(0,3)],
			["itm", ["bipod_01_F_blk", "bipod_01_F_mtp", "bipod_03_F_oli" ,"bipod_02_F_tan"], RANDOM_BETWEEN(0,2)],
			["wep", ["hgun_Pistol_heavy_01_F", "hgun_Pistol_heavy_01_MRD_F", "hgun_Pistol_heavy_02_F", "hgun_Pistol_heavy_02_Yorris_F"], RANDOM_BETWEEN(1,3), RANDOM_BETWEEN(3,5)],
			["wep", ["arifle_MXM_F", "srifle_EBR_F", "srifle_DMR_01_DMS_F", "srifle_DMR_02_sniper_AMS_LP_S_F", "srifle_DMR_04_ARCO_F"], RANDOM_BETWEEN(1,3), RANDOM_BETWEEN(4,6)],
			["wep", ["LMG_Mk200_F", "LMG_Zafir_F", "MMG_01_hex_ARCO_LP_F"], RANDOM_BETWEEN(1,3), RANDOM_BETWEEN(2,4)],
			["mag", "30Rnd_556x45_Stanag", RANDOM_BETWEEN(4,8)],
			["mag", "30Rnd_65x39_caseless_mag", RANDOM_BETWEEN(4,8)],
			["mag", "30Rnd_65x39_caseless_green", RANDOM_BETWEEN(4,8)],
			["mag", "9Rnd_45ACP_Mag", RANDOM_BETWEEN(1,5)]
		];
	};
	case "mission_Main_A3snipers":
	{
		_boxItems =
		[
			// Item type, Item class(es), # of items, # of magazines per weapon
			["wep", ["srifle_LRR_LRPS_F", "srifle_LRR_camo_LRPS_F", "srifle_GM6_LRPS_F", "srifle_GM6_camo_LRPS_F"], RANDOM_BETWEEN(1,3), RANDOM_BETWEEN(4,6)],
			["wep", ["srifle_EBR_F", "srifle_DMR_01_F"], RANDOM_BETWEEN(1,3), RANDOM_BETWEEN(4,6)],
			["wep", ["Binocular", "Rangefinder"], RANDOM_BETWEEN(1,3)],
			["bac", ["B_Carryall_mcamo", "B_Kitbag_mcamo"], RANDOM_BETWEEN(2,5)],
			["itm", "ItemGPS", RANDOM_BETWEEN(0,1)],
			["itm", "optic_DMS", RANDOM_BETWEEN(1,2)]
		];
	};
	case "airdrop_DLC_Rifles":
	{
		_boxItems =
		[
			// Item type, Item class(es), # of items, # of magazines per weapon
			["wep", ["srifle_DMR_03_multicam_F", "srifle_DMR_02_sniper_F", "srifle_DMR_05_hex_F", "srifle_DMR_04_Tan_F"], 4,4],
			["bac", ["B_Carryall_mcamo", "B_Kitbag_mcamo"], RANDOM_BETWEEN(2,5)],
			["itm", ["V_PlateCarrierIAGL_dgtl", "V_TacVest_camo", "V_PlateCarrierGL_rgr"], RANDOM_BETWEEN(4,8)],
			["itm", ["bipod_01_F_blk", "bipod_02_F_hex"], 3],
			["itm", ["optic_DMS","optic_AMS","optic_tws","optic_KHS_blk"], RANDOM_BETWEEN(3,5)],
			["itm", "ItemGPS", RANDOM_BETWEEN(0,1)],
			["itm", ["muzzle_snds_B", "muzzle_snds_338_black", "muzzle_snds_338_sand", "muzzle_snds_93mmg"], RANDOM_BETWEEN(3,5)]
		];
	};
	case "airdrop_DLC_LMGs":
	{
		_boxItems =
		[
			// Item type, Item class(es), # of items, # of magazines per weapon
			["wep", ["MMG_02_black_F", "MMG_02_camo_F","MMG_02_sand_F","MMG_01_hex_F","MMG_01_tan_F"], 4,4],
			["bac", ["B_Carryall_mcamo", "B_Kitbag_mcamo"], RANDOM_BETWEEN(2,5)],
			["itm", ["V_PlateCarrierIAGL_dgtl", "V_TacVest_camo", "V_PlateCarrierGL_rgr"], RANDOM_BETWEEN(1,8)],
			["itm", ["bipod_01_F_blk", "bipod_02_F_hex"], 2],
			["itm", ["optic_DMS","optic_AMS","optic_tws","optic_KHS_blk"], RANDOM_BETWEEN(3,5)],
			["itm", "ItemGPS", RANDOM_BETWEEN(0,1)],
			["itm", ["muzzle_snds_338_black", "muzzle_snds_338_sand", "muzzle_snds_93mmg"], RANDOM_BETWEEN(3,5)]
		];
	};
	case "airdrop_Snipers":
	{
		_boxItems =
		[
			// Item type, Item class(es), # of items, # of magazines per weapon
			["wep", ["srifle_LRR_LRPS_F", "srifle_LRR_camo_LRPS_F", "srifle_GM6_LRPS_F", "srifle_GM6_camo_LRPS_F"], RANDOM_BETWEEN(3,4), RANDOM_BETWEEN(6,8)],
			["wep", ["srifle_EBR_F", "srifle_DMR_01_F"], RANDOM_BETWEEN(2,3), RANDOM_BETWEEN(6,8)],
			["wep", ["Binocular", "Rangefinder"], RANDOM_BETWEEN(1,3)],
			["bac", ["B_Carryall_mcamo", "B_Kitbag_mcamo"], RANDOM_BETWEEN(2,5)],	
			["itm", "ItemGPS", RANDOM_BETWEEN(0,1)],
			["itm", ["optic_DMS","optic_AMS","optic_tws","optic_KHS_blk"], RANDOM_BETWEEN(5,8)]
		];
	};
	case "Diving_Gear": //diving equipment for squad of 2
	{
		_boxItems =
		[
			// Item type, Item class(es), # of items, # of magazines per weapon
			["wep", "arifle_SDAR_F", 2, RANDOM_BETWEEN(4,6)],
			["itm", "V_RebreatherB", 2],
			["itm", "V_RebreatherIR", 2],
			["itm", "V_RebreatherIA", 2],
			["itm", "G_Diving", 2],
			["itm", "U_B_Wetsuit", 2],
			["itm", "U_O_Wetsuit", 2],
			["itm", "U_I_Wetsuit", 2],
			["itm", ["Chemlight_red", "Chemlight_green", "Chemlight_yellow", "Chemlight_blue"], RANDOM_BETWEEN(6,9)],
			["mag", ["SmokeShell", "SmokeShellRed", "SmokeShellgreen"], RANDOM_BETWEEN(5,9)]
			//["bac", ["B_Kitbag_mcamo", "B_Bergen_sgg", "B_FieldPack_khk", "B_Carryall_mcamo"], RANDOM_BETWEEN(3,5)],	
		];
	};	
	case "General_supplies":
	{
	_boxitems =
		[
			//first aid, medkit, tookit, gps, rangefinder, etc
			// Item type, Item class(es), # of items, # of magazines per weapon
			["itm", "FirstAidKit", RANDOM_BETWEEN(5,6)],
			["wep", ["Binocular", "Rangefinder", "Laserdesignator"], RANDOM_BETWEEN(3,5)],
			["wep", ["hgun_Pistol_heavy_01_F", "hgun_Pistol_heavy_01_MRD_F", "hgun_Pistol_heavy_02_F", "hgun_Pistol_heavy_02_Yorris_F"], RANDOM_BETWEEN(1,3), RANDOM_BETWEEN(3,5)],
			["itm", "Medikit", RANDOM_BETWEEN(2,3)],
			["itm", "Toolkit", RANDOM_BETWEEN(2,3)],
			["itm", "Laserbatteries", RANDOM_BETWEEN(2,4)],
			["itm", "MineDetector", 3],
			["itm", ["H_CrewHelmetHeli_B","H_CrewHelmetHeli_O", "H_CrewHelmetHeli_I"], RANDOM_BETWEEN(2,4)],
			["bac", ["B_Kitbag_mcamo", "B_Bergen_sgg", "B_FieldPack_khk", "B_Carryall_mcamo"], RANDOM_BETWEEN(3,5)],
			["itm", ["V_PlateCarrierIAGL_dgtl", "V_TacVest_camo", "V_PlateCarrierGL_rgr"], RANDOM_BETWEEN(2,4)],
			["itm", ["Chemlight_red", "Chemlight_green", "Chemlight_yellow", "Chemlight_blue"], RANDOM_BETWEEN(6,9)],
			//["itm", ["V_RebreatherB", "U_B_Wetsuit"], RANDOM_BETWEEN(3,6)],
			["mag", ["SmokeShell", "SmokeShellRed", "SmokeShellgreen"], RANDOM_BETWEEN(5,9)]
		];
	};	
		case "Ammo_Drop":
	{
	_boxitems =
		[
	// Item type, Item class(es), # of items, # of magazines per weapon
			["mag",["16Rnd_9x21_Mag", "30Rnd_9x21_Mag", "6Rnd_45ACP_Cylinder", "11Rnd_45ACP_Mag", "9Rnd_45ACP_Mag"], RANDOM_BETWEEN(15,20)],
			["mag",["30Rnd_45ACP_MAG_SMG_01", "30Rnd_45ACP_Mag_SMG_01_tracer_green"], RANDOM_BETWEEN(10,15)],
			["mag",["20Rnd_556x45_UW_mag","30Rnd_556x45_Stanag","30Rnd_556x45_Stanag_Tracer_Green"], RANDOM_BETWEEN(10,11)],
			["mag",["30Rnd_556x45_Stanag_Tracer_Yellow","30Rnd_556x45_Stanag_Tracer_Red"], RANDOM_BETWEEN(10,11)],
			["mag",["30Rnd_65x39_caseless_mag", "30Rnd_65x39_caseless_mag_Tracer"], RANDOM_BETWEEN(10,15)],
			["mag",["30Rnd_65x39_caseless_green", "30Rnd_65x39_caseless_green_mag_Tracer"], RANDOM_BETWEEN(10,15)],
			["mag",["100Rnd_65x39_caseless_mag", "100Rnd_65x39_caseless_mag_Tracer"], RANDOM_BETWEEN(7,10)],
			["mag",["200Rnd_65x39_cased_Box", "200Rnd_65x39_cased_Box_Tracer"], RANDOM_BETWEEN(7,10)],
			["mag","10Rnd_762x54_Mag", 10],
			["mag","20Rnd_762x51_Mag", 10],
			["mag",["150Rnd_762x54_Box","150Rnd_762x54_Box_Tracer"], 10],
			["mag","10Rnd_338_Mag", 10],
			["mag","130Rnd_338_Mag", 10], 
			["mag","7Rnd_408_Mag", 10],
			["mag","10Rnd_93x64_DMR_05_Mag", 10],
			["mag","150Rnd_93x64_Mag", 10], 
			["mag","10Rnd_127x54_Mag", 10], 
			["mag",["5Rnd_127x108_Mag","5Rnd_127x108_APDS_Mag"], RANDOM_BETWEEN(10,15)],
			["mag","SmokeShellyellow", RANDOM_BETWEEN(3,6)],
			["mag",["1Rnd_HE_Grenade_shell","1Rnd_Smoke_Grenade_shell","1Rnd_SmokePurple_Grenade_shell","1Rnd_SmokeBlue_Grenade_shell","1Rnd_SmokeGreen_Grenade_shell","1Rnd_SmokeYellow_Grenade_shell","1Rnd_SmokeOrange_Grenade_shell","1Rnd_SmokeRed_Grenade_shell"], RANDOM_BETWEEN(8,10)],
			["mag",["3Rnd_HE_Grenade_shell","3Rnd_Smoke_Grenade_shell","3Rnd_SmokePurple_Grenade_shell","3Rnd_SmokeBlue_Grenade_shell", "3Rnd_SmokeGreen_Grenade_shell", "3Rnd_SmokeYellow_Grenade_shell","3Rnd_SmokeOrange_Grenade_shell","3Rnd_SmokeRed_Grenade_shell"], RANDOM_BETWEEN(8,10)],
			["mag",["UGL_FlareWhite_F", "UGL_FlareGreen_F","UGL_FlareYellow_F","UGL_FlareRed_F","UGL_FlareCIR_F", "3Rnd_UGL_FlareWhite_F", "3Rnd_UGL_FlareGreen_F","3Rnd_UGL_FlareYellow_F", "3Rnd_UGL_FlareRed_F","3Rnd_UGL_FlareCIR_F"], RANDOM_BETWEEN(10,15)]
			
			];	
		};
};

[_box, _boxItems] call processItems;
