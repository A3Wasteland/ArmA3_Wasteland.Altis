// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	Lootspawner junction lists for classes to spawn-/lootable items
//	Author: Na_Palm (BIS forums)
//-------------------------------------------------------------------------------------
//here place Weapons an usable items (ex.: Binocular, ...)
//used with addWeaponCargoGlobal
//"lootWeapon_list" array of [class, [weaponlist]]
//                              class       : 0-civil, 1-military, ... (add more as you wish)
//                              weaponlist  : list of weapon class names
lootWeapon_list =
[
	[ // CIVIL
		0,
		[
			"arifle_MK20C_F",
			"arifle_MK20_F",
			"arifle_TRG20_F",
			"arifle_TRG21_F",
			"Binocular",
			"hgun_PDW2000_F",
			"SMG_01_F",                         // Vermin .45 ACP
			"SMG_02_F"                          // Sting 9mm
		]
	],
	[ // MILITARY
		1,
		[
			"arifle_Katiba_C_F",
			"arifle_Katiba_F",
			"arifle_Katiba_GL_F",
			"arifle_Mk20C_F",
			"arifle_Mk20_F",
			"arifle_Mk20_GL_F",
			"arifle_MXC_F",
			"arifle_MXM_F",
			"arifle_MX_F",
			"arifle_MX_GL_F",
			"arifle_MX_SW_F",
			"arifle_SDAR_F",
			"arifle_TRG20_F",
			"arifle_TRG21_F",
			"arifle_TRG21_GL_F",
			"Binocular",
			"hgun_PDW2000_F",
			"LMG_Mk200_F",
			"LMG_Zafir_F",
			"Rangefinder",
			"SMG_01_F",                         // Vermin .45 ACP
			"SMG_02_F",                         // Sting 9mm
			"srifle_EBR_F",
			"srifle_GM6_F",
			"srifle_LRR_F"
		]
	],
	[ // INDUSTRIAL
		2,
		[
			"arifle_Mk20C_F",
			"arifle_Mk20_F",
			"arifle_TRG20_F",
			"arifle_TRG21_F",
			"arifle_Katiba_C_F",
			"arifle_MXC_F",
			"Binocular",
			"SMG_01_F",                         // Vermin .45 ACP
			"SMG_02_F"                          // Sting 9mm
		]
	],
	[ // RESEARCH
		3,
		[
			"arifle_Katiba_GL_F",
			"arifle_MXC_F",
			"arifle_MXM_F",
			"arifle_MX_GL_F",
			"Rangefinder",
			"srifle_GM6_F",
			"srifle_LRR_F"
		]
	]
];

//here place magazines, weaponattachments and bodyitems(ex.: ItemGPS, ItemMap, Medikit, FirstAidKit, Binoculars, ...)
//used with addMagazineCargoGlobal
//"lootMagazine_list" array of [class, [magazinelist]]
//                              class       : 0-civil, 1-military, ... (add more as you wish)
//                              magazinelist: list of magazine class names
lootMagazine_list =
[
	[ // CIVIL
		0,
		[
			//"16Rnd_9x21_Mag",
			"9Rnd_45ACP_Mag",
			"30Rnd_9x21_Mag",
			"30Rnd_45ACP_Mag_SMG_01_tracer_green",
			"30Rnd_556x45_Stanag_Tracer_Yellow",
			"30Rnd_65x39_caseless_mag_Tracer",
			"30Rnd_65x39_caseless_green_mag_Tracer"/*,
			"Chemlight_blue",
			"Chemlight_green",
			"Chemlight_red",
			"Chemlight_yellow"*/
		]
	],
	[ // MILITARY
		1,
		[
			"100Rnd_65x39_caseless_mag",
			"100Rnd_65x39_caseless_mag_Tracer",
			"150Rnd_762x51_Box",
			"150Rnd_762x51_Box_Tracer",
			//"16Rnd_9x21_Mag",
			"1Rnd_HE_Grenade_shell",
			"1Rnd_Smoke_Grenade_shell",
			"SmokeShell",
			"SmokeShellPurple",
			"SmokeShellBlue",
			"SmokeShellGreen",
			"SmokeShellYellow",
			"SmokeShellOrange",
			"SmokeShellRed",
			"200Rnd_65x39_cased_Box",
			"200Rnd_65x39_cased_Box_Tracer",
			"20Rnd_556x45_UW_mag",
			"20Rnd_762x51_Mag",
			"20Rnd_762x51_Mag",
			"30Rnd_45ACP_Mag_SMG_01",
			"30Rnd_45ACP_Mag_SMG_01",
			"30Rnd_556x45_Stanag",
			"30Rnd_556x45_Stanag_Tracer_Yellow",
			"30Rnd_65x39_caseless_green",
			"30Rnd_65x39_caseless_green_mag_Tracer",
			"30Rnd_65x39_caseless_mag",
			"30Rnd_65x39_caseless_mag_Tracer",
			"30Rnd_9x21_Mag",
			"30Rnd_9x21_Mag",
			/*"3Rnd_HE_Grenade_shell",
			"3Rnd_SmokeBlue_Grenade_shell",
			"3Rnd_SmokeGreen_Grenade_shell",
			"3Rnd_SmokeOrange_Grenade_shell",
			"3Rnd_SmokePurple_Grenade_shell",
			"3Rnd_SmokeRed_Grenade_shell",
			"3Rnd_SmokeYellow_Grenade_shell",
			"3Rnd_Smoke_Grenade_shell",*/
			"5Rnd_127x108_Mag",
			"7Rnd_408_Mag",
			"9Rnd_45ACP_Mag",
			"9Rnd_45ACP_Mag",
			"APERSBoundingMine_Range_Mag",
			"APERSMine_Range_Mag",
			"APERSTripMine_Wire_Mag",
			"ATMine_Range_Mag",
			/*"Chemlight_blue",
			"Chemlight_green",
			"Chemlight_red",
			"Chemlight_yellow",*/
			"ClaymoreDirectionalMine_Remote_Mag",
			"HandGrenade",
			"MiniGrenade",
			"SatchelCharge_Remote_Mag",
			"SLAMDirectionalMine_Wire_Mag"
		]
	],
	[ // INDUSTRIAL
		2,
		[
			"30Rnd_9x21_Mag",
			"30Rnd_45ACP_Mag_SMG_01",
			"30Rnd_556x45_Stanag",
			"30Rnd_556x45_Stanag_Tracer_Yellow",
			"30Rnd_65x39_caseless_green",
			"30Rnd_65x39_caseless_green_mag_Tracer",
			"30Rnd_65x39_caseless_mag",
			"30Rnd_65x39_caseless_mag_Tracer"/*,
			"Chemlight_blue",
			"Chemlight_green",
			"Chemlight_red",
			"Chemlight_yellow"*/
		]
	],
	[ // RESEARCH
		3,
		[
			"20Rnd_556x45_UW_mag",
			"30Rnd_556x45_Stanag",
			"30Rnd_556x45_Stanag",
			"30Rnd_65x39_caseless_mag",
			"30Rnd_65x39_caseless_mag",
			"30Rnd_65x39_caseless_green",
			"30Rnd_65x39_caseless_green",
			"5Rnd_127x108_Mag",
			"7Rnd_408_Mag"
		]
	]
];

//here place hats, glasses, clothes, uniforms, vests
//used with addItemCargoGlobal
//"lootItem_list" array of [class, [itemlist]]
//                              class       : 0-civil, 1-military, ... (add more as you wish)
//                              itemlist    : list of item class names
lootItem_list =
[
	[ // CIVIL
		0,
		[
			"acc_flashlight",
			"FirstAidKit",
			"FirstAidKit",
			"FirstAidKit",
			"muzzle_snds_acp",                  // .45 ACP
			"muzzle_snds_L",                    // 9mm
			"optic_Aco",
			"optic_ACO_grn",
			"optic_aco_smg",
			"optic_Holosight",
			"optic_Holosight_smg"
		]
	],
	[ // MILITARY
		1,
		[
			"acc_flashlight",
			"acc_pointer_IR",
			"FirstAidKit",
			"ItemGPS",
			"Medikit",
			"muzzle_snds_acp",                  // .45 ACP
			"muzzle_snds_B",                    // 7.62mm
			"muzzle_snds_H",                    // 6.5mm
			"muzzle_snds_H_MG",                 // 6.5mm LMG
			"muzzle_snds_L",                    // 9mm
			"muzzle_snds_M",                    // 5.56mm
			"NVGoggles",
			//"NVGoggles_INDEP",
			//"NVGoggles_OPFOR",
			"optic_Aco",
			"optic_ACO_grn",
			"optic_aco_smg",
			"optic_Arco",
			"optic_Hamr",
			"optic_Holosight",
			"optic_Holosight_smg",
			"optic_SOS",
			"ToolKit",
			"H_HelmetB",
			"H_HelmetIA",
			"H_HelmetO_ocamo",
			"V_PlateCarrier1_rgr",
			"V_PlateCarrierIA1_dgtl",
			"V_HarnessO_brn"
		]
	],
	[ // INDUSTRIAL
		2,
		[
			"FirstAidKit",
			"FirstAidKit",
			"Medikit",
			"ToolKit",
			"ToolKit"
		]
	],
	[ // RESEARCH
		3,
		[
			"FirstAidKit",
			"FirstAidKit",
			"FirstAidKit",
			"ItemGPS",
			"Medikit",
			"NVGoggles",
			//"NVGoggles_INDEP",
			//"NVGoggles_OPFOR",
			"optic_Nightstalker",
			"optic_NVS",
			"optic_SOS",
			"V_RebreatherB"
		]
	]
];

//here place backpacks, parachutes and packed drones/stationary
//used with addBackpackCargoGlobal
//"lootBackpack_list" array of [class, [backpacklist]]
//                              class       : 0-civil, 1-military, ... (add more as you wish)
//                              backpacklist: list of backpack class names
lootBackpack_list =
[
	[ // CIVIL
		0,
		[
			"B_FieldPack_blk",
			"B_FieldPack_cbr",
			"B_FieldPack_khk",
			"B_FieldPack_oucamo"
		]
	],
	[ // MILITARY
		1,
		[
			"B_FieldPack_blk",
			"B_FieldPack_cbr",
			"B_FieldPack_khk",
			"B_FieldPack_oucamo",
			"B_Kitbag_cbr",
			"B_Kitbag_rgr",
			"B_Kitbag_mcamo",
			"B_Kitbag_sgg",
			"B_Bergen_blk",
			"B_Bergen_rgr",
			"B_Bergen_mcamo",
			"B_Bergen_sgg",
			"B_Carryall_khk",
			"B_Carryall_mcamo",
			"B_Carryall_oli",
			"B_Carryall_oucamo"
		]
	],
	[ // INDUSTRIAL
		2,
		[
			"B_FieldPack_blk",
			"B_FieldPack_cbr",
			"B_FieldPack_khk",
			"B_FieldPack_oucamo",
			"B_Kitbag_cbr",
			"B_Kitbag_rgr",
			"B_Kitbag_mcamo",
			"B_Kitbag_sgg"
		]
	],
	[ // RESEARCH
		3,
		[
			"B_FieldPack_blk",
			"B_FieldPack_cbr",
			"B_FieldPack_khk",
			"B_FieldPack_oucamo",
			"B_Kitbag_cbr",
			"B_Kitbag_rgr",
			"B_Kitbag_mcamo",
			"B_Kitbag_sgg",
			"B_Bergen_blk",
			"B_Bergen_rgr",
			"B_Bergen_mcamo",
			"B_Bergen_sgg",
			"B_Carryall_khk",
			"B_Carryall_mcamo",
			"B_Carryall_oli",
			"B_Carryall_oucamo"
		]
	]
];

//here place any other objects(ex.: Land_Basket_F, Box_East_Wps_F, Land_Can_V3_F, ...)
//used with createVehicle directly
//"lootworldObject_list" array of [class, [objectlist]]
//                              class       : 0-civil, 1-military, ... (add more as you wish)
//                              objectlist  : list of worldobject class names
lootworldObject_list =
[
	[ // CIVIL
		0,
		[
			"Land_BakedBeans_F",                // food
			"Land_BakedBeans_F",                // food
			"Land_BottlePlastic_V2_F",          // water
			"Land_BottlePlastic_V2_F",          // water
			"Land_Can_V3_F",                    // energydrink
			"Land_Suitcase_F",                  // repairkit
			"Land_CanisterOil_F",               // syphon hose
			"Land_CanisterFuel_F"               // jerrycan
		]
	],
	[ // MILITARY
		1,
		[
			"Land_BakedBeans_F",                // food
			"Land_BottlePlastic_V2_F",          // water
			"Land_Can_V3_F",                    // energydrink
			"Land_Suitcase_F",                  // repairkit
			"Land_CanisterOil_F",               // syphon hose
			"Land_CanisterFuel_F"               // jerrycan
		]
	],
	[ // INDUSTRIAL
		2,
		[
			"Land_BakedBeans_F",                // food
			"Land_BottlePlastic_V2_F",          // water
			"Land_Can_V3_F",                    // energydrink
			"Land_Suitcase_F",                  // repairkit
			"Land_Suitcase_F",                  // repairkit
			"Land_CanisterOil_F",               // syphon hose
			"Land_CanisterOil_F",               // syphon hose
			"Land_CanisterFuel_F",              // jerrycan
			"Land_CanisterFuel_F"               // jerrycan
		]
	],
	[ // RESEARCH
		3,
		[
			"Land_BakedBeans_F",                // food
			"Land_BottlePlastic_V2_F",          // water
			"Land_Can_V3_F",                    // energydrink
			"Land_Suitcase_F",                  // repairkit
			"Land_CanisterOil_F",               // syphon hose
			"Land_CanisterFuel_F"               // jerrycan
		]
	]
];
