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
_box setVariable ["A3W_inventoryLockR3F", true, true];

// Clear pre-existing cargo first
//clearBackpackCargoGlobal _box;
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
			["mag", ["ClaymoreDirectionalMine_Remote_Mag", "SLAMDirectionalMine_Wire_Mag", "ATMine_Range_Mag", "DemoCharge_Remote_Mag", "SatchelCharge_Remote_Mag"], RANDOM_BETWEEN(3,8)]
		];
	};
	case "mission_USSpecial":
	{
		_boxItems =
		[
			// Item type, Item class(es), # of items, # of magazines per weapon
			//["itm", "NVGoggles", 5],
			["wep", ["Binocular", "Rangefinder"], RANDOM_BETWEEN(1,5)],
			["itm", "Medikit", RANDOM_BETWEEN(1,3)],
			["itm", "Toolkit", RANDOM_BETWEEN(0,1)],
			["itm", ["optic_MRCO", "optic_Arco", "optic_Hamr", "optic_SOS"], RANDOM_BETWEEN(0,2)],
			["itm", ["muzzle_snds_M", "muzzle_snds_H", "muzzle_snds_H_MG", "muzzle_snds_B", "muzzle_snds_acp"], RANDOM_BETWEEN(0,3)],
			["wep", ["hgun_Pistol_heavy_01_F", "hgun_Pistol_heavy_01_MRD_F", "hgun_Pistol_heavy_02_F", "hgun_Pistol_heavy_02_Yorris_F"], RANDOM_BETWEEN(1,3), RANDOM_BETWEEN(3,5)],
			["wep", ["arifle_MXM_F", "srifle_EBR_F", "srifle_DMR_01_DMS_F"], RANDOM_BETWEEN(1,3), RANDOM_BETWEEN(4,6)],
			["wep", ["LMG_Mk200_F", "LMG_Zafir_F"], RANDOM_BETWEEN(1,3), RANDOM_BETWEEN(2,4)],
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
			["itm", "optic_DMS", RANDOM_BETWEEN(1,2)]
		];
	};
	case "mission_TOP_Sniper":
	{
		_boxItems =
		[
			// Item type, Item class(es), # of items, # of magazines per weapon
			["wep", ["srifle_LRR_SOS_F", "srifle_LRR_camo_SOS_F", "srifle_GM6_SOS_F", "srifle_GM6_camo_SOS_F"], RANDOM_BETWEEN(1,5), RANDOM_BETWEEN(4,6)],
			["wep", ["srifle_EBR_F", "srifle_DMR_01_F"], RANDOM_BETWEEN(1,3), RANDOM_BETWEEN(4,6)],
			
			["wep", "Rangefinder", RANDOM_BETWEEN(1,3)],
			["itm", ["optic_DMS","optic_Nightstalker","optic_tws"], RANDOM_BETWEEN(1,5)]
		];
	};
	case "mission_TOP_Gear1":
	{
		_boxItems =
		[
			// Item type, Item class(es), # of items, # of magazines per weapon
			["itm", ["V_RebreatherB", "V_PlateCarrierIAGL_dgtl", "V_TacVest_camo", "V_PlateCarrierGL_rgr"], RANDOM_BETWEEN(1,8)],
			["itm", ["B_Carryall_mcamo", "B_Kitbag_mcamo"], RANDOM_BETWEEN(1,5)],
			["itm", ["U_B_HeliPilotCoveralls","U_B_Wetsuit","U_B_CombatUniform_mcam_vest"], RANDOM_BETWEEN(1,4)],
			["itm", ["H_HelmetCrew_B","H_CrewHelmetHeli_B","H_HelmetB_plain_blk","H_HelmetSpecB"], RANDOM_BETWEEN(1,5)]
		];
	};
	case "airdrop_DLC_Rifles":
	{
		_boxItems =
		[
			// Item type, Item class(es), # of items, # of magazines per weapon
			["wep", ["srifle_DMR_03_multicam_F", "srifle_DMR_02_sniper_F", "srifle_DMR_05_hex_F", "srifle_DMR_04_Tan_F"], 4,4],
			["itm", ["V_PlateCarrierIAGL_dgtl", "V_TacVest_camo", "V_PlateCarrierGL_rgr"], RANDOM_BETWEEN(4,8)],
			["itm", ["B_Carryall_mcamo", "B_Kitbag_mcamo"], RANDOM_BETWEEN(2,5)],
			["itm", ["bipod_01_F_blk", "bipod_02_F_hex"], 3],
			["itm", ["optic_DMS","optic_AMS","optic_tws","optic_KHS_blk"], RANDOM_BETWEEN(3,5)],
			["itm", ["muzzle_snds_B", "muzzle_snds_338_black", "muzzle_snds_338_sand", "muzzle_snds_93mmg"], RANDOM_BETWEEN(3,5)]
		];
	};
	case "airdrop_DLC_LMGs":
	{
		_boxItems =
		[
			// Item type, Item class(es), # of items, # of magazines per weapon
			["wep", ["MMG_02_black_F", "MMG_02_camo_F","MMG_02_sand_F","MMG_01_hex_F","MMG_01_tan_F"], 4,4],
			["itm", ["V_PlateCarrierIAGL_dgtl", "V_TacVest_camo", "V_PlateCarrierGL_rgr"], RANDOM_BETWEEN(1,8)],
			["itm", ["B_Carryall_mcamo", "B_Kitbag_mcamo"], RANDOM_BETWEEN(2,5)],
			["itm", ["bipod_01_F_blk", "bipod_02_F_hex"], 2],
			["itm", ["optic_DMS","optic_AMS","optic_tws","optic_KHS_blk"], RANDOM_BETWEEN(3,5)],
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
			["itm", ["B_Carryall_mcamo", "B_Kitbag_mcamo"], RANDOM_BETWEEN(2,5)],			
			["itm", ["optic_DMS","optic_AMS","optic_tws","optic_KHS_blk"], RANDOM_BETWEEN(5,8)]
		];
	};	

	
	case "Launcers_Tier_2":
	{
		_boxItems = 
		[
			["wep", "launch_RPG32_F", RANDOM_BETWEEN(1,2), RANDOM_BETWEEN(3,4)], 
			["wep", "launch_NLAW_F", RANDOM_BETWEEN(1,2), RANDOM_BETWEEN(3,4)],
			["wep", "launch_Titan_short_F", RANDOM_BETWEEN(2,3), RANDOM_BETWEEN(3,4)],
			["wep", "launch_Titan_F", RANDOM_BETWEEN(1,2), RANDOM_BETWEEN(3,4)],
			["bac", ["B_Carryall_cbr", "B_Carryall_khk", "B_Carryall_oli", "B_Carryall_mcamo", "B_Carryall_oucamo"], RANDOM_BETWEEN(3,4)]
		
		];
	
	};

	Case "GroupEliteVenturePack":
	{
	
		_boxItems = 
		[
			["wep", ["srifle_EBR_ARCO_pointer_F"], RANDOM_BETWEEN(1,2), RANDOM_BETWEEN(10,12)],
			["wep", ["srifle_DMR_03_ARCO_F", "srifle_DMR_03_SOS_F"], RANDOM_BETWEEN(1,2), RANDOM_BETWEEN(10,12)],
			["wep", ["srifle_DMR_06_camo_khs_F", "srifle_DMR_06_olive_F", "srifle_DMR_06_camo_F"], RANDOM_BETWEEN(1,2), RANDOM_BETWEEN(10,12)],
            ["wep", ["MMG_01_hex_ARCO_LP_F", "MMG_01_tan_F", "MMG_01_hex_F"], RANDOM_BETWEEN(1,1), RANDOM_BETWEEN(2,4)],
			["wep", ["MMG_02_camo_F", "MMG_02_black_F", "MMG_02_sand_F", "MMG_02_sand_RCO_LP_F", "MMG_02_black_RCO_BI_F"], RANDOM_BETWEEN(1,1), RANDOM_BETWEEN(2,4)],
			["wep", ["LMG_Mk200_MRCO_F"], RANDOM_BETWEEN(1,2), RANDOM_BETWEEN(2,5)],
            ["wep", ["srifle_DMR_05_DMS_snds_F", "srifle_DMR_05_KHS_LP_F", "srifle_DMR_05_DMS_F", "srifle_DMR_05_SOS_F", "srifle_DMR_05_MRCO_F"], RANDOM_BETWEEN(1,2), RANDOM_BETWEEN(6,10)],
			["wep", ["LMG_Zafir_ARCO_F"], RANDOM_BETWEEN(1,2), RANDOM_BETWEEN(2,5)],
			["wep", ["srifle_DMR_01_SOS_F"], RANDOM_BETWEEN(1,2), RANDOM_BETWEEN(5,10)],
			["wep", ["Launch_NLAW_F"], RANDOM_BETWEEN(2,2), RANDOM_BETWEEN(4,6)],
			["wep", ["launch_B_Titan_short_F", "launch_I_Titan_short_F", "launch_O_Titan_short_F", "launch_Titan_short_F"], RANDOM_BETWEEN(2,3), RANDOM_BETWEEN(2,6)],
            ["wep", ["launch_B_Titan_F", "launch_I_Titan_F", "launch_O_Titan_F", "launch_Titan_F"], RANDOM_BETWEEN(2,2), RANDOM_BETWEEN(2,4)],
            ["wep", ["srifle_LRR_SOS_F"], RANDOM_BETWEEN(2,3), RANDOM_BETWEEN(8,14)],
            ["itm", ["H_HelmetB_light_sand", "H_HelmetB_light_desert", "H_HelmetB_light_grass"], RANDOM_BETWEEN(3,5)],
            ["itm", ["H_HelmetB_camo", "H_HelmetB"], RANDOM_BETWEEN(4,6)],
			["itm", ["H_Shemag_khk", "H_Shemag_olive_hs"], RANDOM_BETWEEN(0,1)],
            ["bac", ["B_Carryall_cbr", "B_Carryall_khk", "B_Carryall_oli", "B_Carryall_mcamo", "B_Carryall_oucamo"], RANDOM_BETWEEN(3,4)],
			["bac", ["B_FieldPack_ocamo", "B_FieldPack_ocamo"], RANDOM_BETWEEN(2,4)],
			["itm",	["V_PlateCarrierIAGL_dgtl", "V_PlateCarrierIA2_dgtl", "V_PlateCarrierGL_rgr"], RANDOM_BETWEEN(4,4)],
			["itm", ["V_TacVest_brn", "V_TacVest_blk_POLICE", "V_TacVest_blk", "V_TacVest_brn", "V_TacVest_brn", "V_TacVest_khk", "V_TacVest_oli"], RANDOM_BETWEEN(3,6)],
			["itm", ["optic_LRPS", "optic_SOS"], RANDOM_BETWEEN(2,3)],
			["itm", ["optic_Nightstalker", "optic_tws"], RANDOM_BETWEEN(3,5)],
			["itm", ["muzzle_snds_H_MG"], RANDOM_BETWEEN(1,2)],
			["itm", ["muzzle_snds_B"], RANDOM_BETWEEN(1,3)],
			["itm", ["bipod_01_F_snd", "bipod_01_F_blk", "bipod_01_F_mtp"], RANDOM_BETWEEN(2,4)],
			["itm", ["bipod_02_F_blk", "bipod_02_F_tan", "bipod_02_F_hex"], RANDOM_BETWEEN(2,4)],
			["itm", ["bipod_03_F_blk", "bipod_03_F_oli"], RANDOM_BETWEEN(3,4)],
			["itm", ["muzzle_snds_93mmg", "muzzle_snds_93mmg_tan"], RANDOM_BETWEEN(1,2)],
			["itm", ["muzzle_snds_338_sand", "muzzle_snds_338_green", "muzzle_snds_338_black"], RANDOM_BETWEEN(1,2)]
		
		];
	};
};


[_box, _boxItems] call processItems;
