//	@file Version: 1.0
//	@file Name: config.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, [GoT] JoSchaap, AgentRev
//	@file Created: 20/11/2012 05:13
//	@file Description: Main config.

// For SERVER CONFIG, values are in server\init.sqf

// Towns and cities array
// Marker Name, Diameter, City Name
cityList = compileFinal str
[
	["Town_1", 400, "Kavala"],
	["Town_2", 300, "Agios Dionysios"],
	["Town_3", 150, "Abdera"],
	["Town_4", 250, "Athira"],
	["Town_5", 200, "Telos"],
	["Town_6", 200, "Sofia"],
	["Town_7", 200, "Paros"],
	["Town_8", 300, "Pyrgos"],
	["Town_9", 150, "Selakano"],
	["Town_10", 200, "Vikos"],
	["Town_11", 250, "Zaros"],
	["Town_12", 250, "Neochori"],
	["Town_13", 250, "Aggelochori"],
	["Town_14", 200, "Panochori"],
	["Town_15", 200, "Charkia"],
	["Town_16", 150, "Chalkeia"],
	["Town_17", 150, "Oreokastro"],
	["Town_18", 100, "Dump"],
	["Town_19", 125, "Negades"],
	["Town_20", 100, "Frini"]
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
	["Quadbike_01_base_F", 0.50],
	["Tank", 0.10],
	["Air", 0.10]
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

