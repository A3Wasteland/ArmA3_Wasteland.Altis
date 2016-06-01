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
	["GenStore6", 1, 270, []],
	["GenStore7", 3, 140, []],

	["GunStore1", 1, 0, []],
	["GunStore2", 1, 75, []],
	["GunStore3", 6, 135, []],
	["GunStore4", 1, 65, []],
	["GunStore5", 1, 110, []],
	["GunStore6", 1, 73, []],

	// Buttons you can disable: "Land", "Armored", "Tanks", "Helicopters", "Boats", "Planes"
	["VehStore1", 1, 75, []],
	["VehStore2", 6, 45, ["Boats"]],
	["VehStore3", 4, 250, ["Boats"]],
	["VehStore4", 5, 155, ["Boats"]],
	["VehStore5", 0, 190, ["Planes"]],
	["VehStore6", 1, 125, ["Planes","Boats"]],
	["VehStore7", 0, 80, ["Boats"]]
];

// Outfits for store owners
storeOwnerConfigAppearance = compileFinal str
[
	["GenStore1", [["weapon", ""], ["uniform", ""]]],
	["GenStore2", [["weapon", ""], ["uniform", ""]]],
	["GenStore3", [["weapon", ""], ["uniform", ""]]],
	["GenStore4", [["weapon", ""], ["uniform", ""]]],
	["GenStore5", [["weapon", ""], ["uniform", ""]]],
	["GenStore6", [['weapon', ""], ["uniform", ""]]],
	["GenStore7", [['weapon', ""], ["uniform", ""]]],

	["GunStore1", [["weapon", ""], ["uniform", ""]]],
	["GunStore2", [["weapon", ""], ["uniform", ""]]],
	["GunStore3", [["weapon", ""], ["uniform", ""]]],
	["GunStore4", [["weapon", ""], ["uniform", ""]]],
	["GunStore5", [["weapon", ""], ["uniform", ""]]],
	["GunStore6", [["weapon", ""], ["uniform", ""]]],

	["VehStore1", [["weapon", ""], ["uniform", ""]]],
	["VehStore2", [["weapon", ""], ["uniform", ""]]],
	["VehStore3", [["weapon", ""], ["uniform", ""]]],
	["VehStore4", [["weapon", ""], ["uniform", ""]]],
	["VehStore5", [["weapon", ""], ["uniform", ""]]],
	["VehStore6", [["weapon", ""], ["uniform", ""]]],
	["VehStore7", [["weapon", ""], ["uniform", ""]]]
];
