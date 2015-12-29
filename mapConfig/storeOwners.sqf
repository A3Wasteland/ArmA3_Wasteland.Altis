// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: storeOwners.sqf
//	@file Author: AgentRev, JoSchaap, His_Shadow

// Notes: Gun and general stores have position of spawned crate, vehicle stores have an extra air spawn direction
//
// Array contents are as follows:
// Name, Building Position, Desk Direction (or [Desk Direction, Front Offset]), Excluded Buttons
storeOwnerConfig = compileFinal str
[
	["GenStore1", 6, 240, []],
	["GenStore2", 6, 250, []],
	["GenStore3", 6, 45, []],
	["GenStore4", 0, 265, []],
	["GenStore5", 5, 350, []],
	["GenStore6", 5, -444, []],
	["GenStore7", 1, 270, []],
	["GenStore8", 3, 140, []],

	["GunStore1", 1, 0, []],
	["GunStore2", 1, 75, []],
	["GunStore3", 6, 135, []],
	["GunStore4", 1, 65, []],
	["GunStore5", 5, -488, []],
	["GunStore6", 1, 110, []],

	// Buttons you can disable: "Land", "Armored", "Tanks", "Helicopters", "Boats", "Planes"
	["VehStore1", 1, 75, ["Planes"]], // Planes removed
	["VehStore2", 6, 45, ["Boats"]], // Planes removed
	["VehStore3", 4, 250, ["Planes","Boats"]], // Planes removed
	["VehStore4", 5, 155, ["Boats"]], // Planes removed
	["VehStore5", 0, 190, ["Planes"]],
	["VehStore6", 5, -261, ["Planes"]],
	["VehStore7", 1, 125, ["Planes","Boats"]]
];

// Outfits for store owners
storeOwnerConfigAppearance = compileFinal str
[
	["GenStore1", [["weapon", ""], ["uniform", "U_B_Protagonist_VR"]]],
	["GenStore2", [["weapon", ""], ["uniform", "U_O_Protagonist_VR"]]],
	["GenStore3", [["weapon", ""], ["uniform", "U_I_Protagonist_VR"]]],
	["GenStore4", [["weapon", ""], ["uniform", "U_O_Protagonist_VR"]]],
	["GenStore5", [["weapon", ""], ["uniform", "U_I_Protagonist_VR"]]],
	["GenStore6", [['weapon', ""], ["uniform", "U_I_Protagonist_VR"]]],
	["GenStore7", [['weapon', ""], ["uniform", "U_B_Protagonist_VR"]]],
	["GenStore8", [['weapon', ""], ["uniform", "U_B_Protagonist_VR"]]],

	["GunStore1", [["weapon", "LMG_Zafir_F"], ["uniform", "U_B_SpecopsUniform_sgg"]]],
	["GunStore2", [["weapon", "srifle_DMR_01_F"], ["uniform", "U_O_SpecopsUniform_blk"]]],
	["GunStore3", [["weapon", "srifle_GM6_camo_SOS_F"], ["uniform", "U_I_CombatUniform_tshirt"]]],
	["GunStore4", [["weapon", "arifle_Katiba_GL_F"], ["uniform", "U_IG_Guerilla1_1"]]],
	["GunStore5", [["weapon", "srifle_GM6_camo_SOS_F"], ["uniform", "U_IG_Guerilla1_1"]]],
	["GunStore6", [["weapon", "arifle_Katiba_GL_F"], ["uniform", "U_IG_Guerilla1_1"]]],

	["VehStore1", [["weapon", ""], ["uniform", "U_IG_leader"]]],
	["VehStore2", [["weapon", ""], ["uniform", "U_Rangemaster"]]],
	["VehStore3", [["weapon", ""], ["uniform", "U_Competitor"]]],
	["VehStore4", [["weapon", ""], ["uniform", "U_IG_leader"]]],
	["VehStore5", [["weapon", ""], ["uniform", "U_Rangemaster"]]],
	["VehStore6", [["weapon", ""], ["uniform", "U_IG_leader"]]],
	["VehStore7", [["weapon", ""], ["uniform", "U_Competitor"]]]
];
