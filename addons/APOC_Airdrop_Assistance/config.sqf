//Configuration for Airdrop Assistance
//Author: Apoc

APOC_AA_coolDownTime = 60; //Expressed in sec

APOC_AA_VehOptions =
[ // ["Menu Text",		ItemClassname,				Price,	"Drop Type"]
["Quadbike (Civilian)", "C_Quadbike_01_F", 			4000, 	"vehicle"],
["Offroad HMG", 		"B_G_Offroad_01_armed_F",	20000, 	"vehicle"],
["Strider HMG", 		"I_MRAP_03_hmg_F", 			30000, 	"vehicle"]
];

APOC_AA_SupOptions =
[// ["stringItemName", 	"Crate Type for fn_refillBox 	,Price," drop type"]
["Launchers", 			"mission_USLaunchers", 			25000, "supply"],
["Assault Rifle", 		"mission_USSpecial", 			15000, "supply"],
["Sniper Rifles", 		"airdrop_Snipers", 				30000, "supply"],
["DLC Rifles", 			"airdrop_DLC_Rifles", 			35000, "supply"],
["DLC LMGs", 			"airdrop_DLC_LMGs", 			35000, "supply"],

//"Menu Text",			"Crate Type", 			"Cost", "drop type"
["Food",				"Land_Sacks_goods_F",	5000, 	"picnic"],
["Water",				"Land_BarrelWater_F",	5000, 	"picnic"]
];