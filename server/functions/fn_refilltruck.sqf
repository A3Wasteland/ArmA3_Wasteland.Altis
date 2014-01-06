//	@file Version: 1.0
//	@file Name: fn_refilltruck.sqf
//	@file Author: AgentRev
//	@file Created: 30/06/2013 15:28

if (!isServer) exitWith {};

private ["_truck", "_truckItems", "_item", "_qty", "_mag"];
_truck = _this;

// Clear prexisting cargo first
clearMagazineCargoGlobal _truck;
clearWeaponCargoGlobal _truck;
clearItemCargoGlobal _truck;

// Item type, Item, # of items, # of magazines per weapon
_truckItems =
[
	["itm", "FirstAidKit", 5],
	["itm", "Medikit", 3],
	["itm", "Toolkit", 1],
	["itm", ["optic_Aco", "optic_ACO_grn"], 3],
	["itm", ["optic_Hamr", "optic_Arco"], 3],
	["wep", ["SMG_01_F", "SMG_02_F", "hgun_PDW2000_F"], 3, 4],
	["wep", ["arifle_Mk20_GL_F", "arifle_TRG21_GL_F"], 2, 5],
	["wep", ["arifle_Katiba_GL_F", "arifle_MX_GL_F"], 2, 5],
	["mag", "1Rnd_HE_Grenade_shell", 8],
	["wep", ["srifle_GM6_SOS_F", "srifle_LRR_SOS_F"], 1, 5],
	["wep", "launch_Titan_short_F", 2, 3],
	["mag", "HandGrenade", 5],
	["mag", ["APERSTripMine_Wire_Mag", "APERSBoundingMine_Range_Mag"], 5],
	["mag", ["ATMine_Range_Mag", "SLAMDirectionalMine_Wire_Mag"], 5]
];

[_truck, _truckItems] call processItems;
