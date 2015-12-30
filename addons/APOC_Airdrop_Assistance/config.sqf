//Configuration for Airdrop Assistance
//Author: Apoc

APOC_AA_VehOptions =
[
// ["Menu Text",        ItemClassname,                       Price,  "Drop type"]
["Quadbike (Civilian)", "C_Quadbike_01_F",                   1200,   "vehicle"],
["MH-9 Hummingbird",    "B_Heli_Light_01_F",                 10000,  "vehicle"],
["Strider",             "I_MRAP_03_F",                       10000,  "vehicle"],
["Strider HMG",         "I_MRAP_03_hmg_F",                   30000,  "vehicle"],
["MSE-3 Marid",         "O_APC_Wheeled_02_rcws_F",           50000,  "vehicle"],
["AH-9 Pawnee",         "B_Heli_Light_01_armed_F",           100000, "vehicle"],
["MBT-52 Kuma",         "I_MBT_03_cannon_F",                 200000, "vehicle"]
];

APOC_AA_SupOptions =
[
// ["stringItemName",   "fn_refillBox crate,                 Price,  "Drop type"]
["General Supplies",    "General_supplies",                  30000,  "supply"],
["Diving Gear",         "Diving_Gear",                       30000,  "supply"],
["Ammo Drop",           "Ammo_Drop",                         60000,  "supply"],
["Assault Rifles",      "mission_USSpecial",                 40000,  "supply"],
["DLC Rifles",          "airdrop_DLC_Rifles",                45000,  "supply"],
["DLC LMGs",            "airdrop_DLC_LMGs",                  50000,  "supply"],
["Sniper Rifles",       "airdrop_Snipers",                   55000,  "supply"],
["Launchers",           "mission_USLaunchers",               60000,  "supply"],

//"Menu Text",          "Food Type",                         Price,  "Drop type"]
["Food",                "Land_Sacks_goods_F",                10000,  "picnic"],
["Water",               "Land_BarrelWater_F",                10000,  "picnic"],

//"Menu Text",          "Base carrier",                      Price,  "Drop type"]
["Base Building Kit",   "Land_Pod_Heli_Transport_04_box_F",  150000, "base"]
];
