//	Lootspawner junction lists for classes to spawn-/lootable items
//	Author: Na_Palm (BIS forums)
//-------------------------------------------------------------------------------------
//here place Weapons an usable items (ex.: Binocular, ...)
//used with addWeaponCargoGlobal
//"lootWeapon_list" array of [class, [weaponlist]]
//								class		: 0-civil, 1-military, ... (add more as you wish)
//								weaponlist	: list of weapon class names
lootWeapon_list = [
[ 0, [							// CIVIL
"arifle_MK20C_F",
"arifle_MK20_F",
"arifle_TRG20_F",
"arifle_TRG21_F",
"Binocular",
"hgun_PDW2000_F",
"SMG_01_F",							// Vermin .45 ACP
"hlc_rifle_ak74",		 	//- AK74
"hlc_rifle_aks74",			//- AKS74
"hlc_rifle_aks74u",			//- AKS74U
"hlc_rifle_ak47",			//- AK47
"hlc_rifle_akm",			//-AKM
"hlc_rifle_rpk",			//-RPK
"hlc_rifle_ak12",			//-AK12
"hlc_rifle_akmgl",			//-AKM+GP25
"hlc_rifle_aks74_GL",		//-AKS74+GP30 (Export Variant)
"hlc_rifle_saiga12k",		//-Saiga12K Shotgun
"hlc_rifle_aek971",
"hlc_rifle_RU556",		 	//- AR15 Sanitied Carbine (Magpul AFG, MOE,P-Mag,BAD-lever. Novekse KX3)
"hlc_rifle_RU5562",		 	//- AR15 Magpul Carbine (Magpul AFG, UBR,P-Mag,BAD-lever. Novekse KX3)
"hlc_rifle_Colt727",		//- Colt Carbine (Colt Model 727 "Commando" - "M4" Barrel, M16A2 Upper, Full-Auto Lower)
"SMG_02_F"							// Sting 9mm
]],[ 1, [						// MILITARY
"arifle_Katiba_C_F",
"arifle_Katiba_F",
"arifle_Katiba_GL_F",
"hlc_rifle_STG58F",		 	//- Steyr STG.58
"arifle_Mk20C_F",
"arifle_Mk20_F",
"arifle_Mk20_GL_F",
"arifle_MXC_F",
"arifle_MXM_F",
"arifle_MX_F",
"arifle_MX_GL_F",
"arifle_MX_SW_F",
"hlc_rifle_g3sg1",		 	//- H&K G3SG1 (Designated marksman rifle)
"hlc_rifle_psg1",		 	//- H&K PSG1 (Sniper Weapon System. So dedcated to the role that the tripod that it mounts to is not integral to the weapon)
"hlc_rifle_g3a3",		 	//- H&K G3A3 (Infantry Rifle)
"hlc_rifle_g3ka4",		 	//- H&K G3KA4 (Modernised,slightly shorter Infantry rifle)
"HLC_Rifle_g3ka4_GL",		//- H&K G3KA4 + M203
"hlc_rifle_hk51",		 	//- FR Ordnance MC51 (G3 rifle made as compact as an MP5. A Specfic request made by the SAS, apparently 50 made, but none saw combat)
"hlc_rifle_hk53",			//- H&K HK53 (H&K's formalised solution to the SASR's dilemma, essentially an HK33 made to fit the same size package as the MP5)
"hlc_rifle_M14",		 	//- M14 (Infantry Rifle)
"hlc_rifle_M21",		 	//- M21 Marksman Rifle ( Removal of select fire, Addition of Fibreglass stock and Harris Bipod)
"hlc_rifle_M14DMR",		 	//- M14 DMR (USMC Designated Marksman Weapon. ArmA2 DMR)
"hlc_rifle_m14sopmod",	 	//- Troy M14 SOPMOD (Precursor to the EBR. Modernised M14 Chasis)
"arifle_SDAR_F",
"arifle_TRG20_F",
"arifle_TRG21_F",
"arifle_TRG21_GL_F",
"Binocular",
"hgun_PDW2000_F",
"LMG_Mk200_F",
"LMG_Zafir_F",
"Rangefinder",
"SMG_01_F",							// Vermin .45 ACP
"SMG_02_F",							// Sting 9mm
"hlc_rifle_Colt727_GL",		//- Same as above, add M203
"hlc_rifle_bcmjack", 		//- Bravo Company MFG/Haley Strategic Jack Carbine)
"hlc_rifle_Bushmaster300",	//- Busmaster .300 Carbine (M4A1-profile carbine chambered for .300 Blackout, instead of 5.56mm NATO)
"hlc_rifle_vendimus",		//- AR15 .300 Dissipator Carbine (Carbine-length heavy barrel covered by full-length rifle furniture)
"hlc_rifle_SAMR",			//- Rock River Arms LAR-15 AMR (Full-Auto-Capable full-length rifle, kitted out to be able to double as a marksman rifle, with accuracy to match)
"hlc_rifle_honeybase",		//- AAC 'Honey-Badger',Sans Suppressor
"hlc_rifle_honeybadger",	//- AAC 'Honey-Badger' (Suppressed Carbine-length defense weapon, created to show off the low-velocity suppressed capabilities of the .300 Blackout round)
"srifle_EBR_F",
"srifle_GM6_F",
"srifle_LRR_F"
]],[ 2, [						// INDUSTRIAL
"arifle_Mk20C_F",
"hlc_rifle_ak74",		 	//- AK74
"hlc_rifle_aks74",			//- AKS74
"hlc_rifle_aks74u",			//- AKS74U
"hlc_rifle_ak47",			//- AK47
"hlc_rifle_akm",			//-AKM
"hlc_rifle_rpk",			//-RPK
"hlc_rifle_ak12",			//-AK12
"hlc_rifle_akmgl",			//-AKM+GP25
"hlc_rifle_aks74_GL",		//-AKS74+GP30 (Export Variant)
"arifle_Mk20_F",
"arifle_TRG20_F",
"arifle_TRG21_F",
"arifle_Katiba_C_F",
"arifle_MXC_F",
"Binocular",
"SMG_01_F",							// Vermin .45 ACP
"SMG_02_F"							// Sting 9mm
]],[ 3, [						// RESEARCH
"arifle_Katiba_GL_F",
"hlc_rifle_FAL5061",		// - FN FAL 'Para' 
"hlc_rifle_c1A1",		 	//- FN C1A1 (Canadian SLR variant, manufactured by FN)
"hlc_rifle_LAR",		 	//- FN LAR (Light infantry rifle contracted to Israel, Differs from the Support variant by the omission of bipod and standard width barrel)
"hlc_rifle_SLRchopmod",		//- Lithgow SLR Chopmod ( Litghow SLR with the selector group from an L2A1  Barrel sawn down and flash suppressor omitted, additional pistol grip drilled to foregrip.
"hlc_rifle_falosw",			//- DSA Arms FAL OSW (Offensive Suppression Weapon. Or Offensively Short Weapon)
"hlc_rifle_osw_GL",			//-DSA Arms FAL OSW + M203 GL
"arifle_MXC_F",
"arifle_MXM_F",
"arifle_MX_GL_F",
"Rangefinder",
"srifle_GM6_F",
"srifle_LRR_F"
]]];

//here place magazines, weaponattachments and bodyitems(ex.: ItemGPS, ItemMap, Medikit, FirstAidKit, Binoculars, ...)
//used with addMagazineCargoGlobal
//"lootMagazine_list" array of [class, [magazinelist]]
//								class		: 0-civil, 1-military, ... (add more as you wish)
//								magazinelist: list of magazine class names
lootMagazine_list = [
[ 0, [							// CIVIL
//"16Rnd_9x21_Mag",
"9Rnd_45ACP_Mag",
"hlc_30Rnd_545x39_B_AK",	// - 30 Round magazine of 5.45x39mm Ball Rounds (i.e, standard bullets)
"hlc_30Rnd_545x39_T_AK",	// - 30 Round magazine of 5.45x39mm Tracer Rounds
"hlc_30Rnd_545x39_EP_AK",	// - 30 Round magazine of 5.45x39mm Enhanced Performance Rounds 
"hlc_45Rnd_545x39_t_rpk",	// - 45 Round magazine of 5.45x39mm Mixed
"hlc_30Rnd_762x39_b_ak",	// - 30 Round magazine of 7.62x39mm Ball Rounds (i.e, standard bullets)
"hlc_30Rnd_762x39_t_ak",	// - 30 Round magazine of 7.62x39mm Tracer Rounds
"hlc_45Rnd_762x39_t_rpk",	// - 45 Round magazine of 7.62x39mm Tracer Rounds
"hlc_45Rnd_762x39_m_rpk",	// - 45 Round magazine of 7.62x39mm Mixed
"hlc_75rnd_762x39_m_rpk",	//- 75 Round magazine of 7.62x39mm Mixed
"hlc_10rnd_12g_buck_S12",	//- 10 Round magazine of 12 Gauge 00-Buckshot rounds 
"hlc_10rnd_12g_slug_S12",	//- 10 Round magazine of 12 Gauge Solid Slug rounds
"30Rnd_9x21_Mag",
"30Rnd_45ACP_Mag_SMG_01_tracer_green",
"30Rnd_556x45_Stanag_Tracer_Yellow",
"30Rnd_65x39_caseless_mag_Tracer",
"30Rnd_65x39_caseless_green_mag_Tracer"/*,
"Chemlight_blue",
"Chemlight_green",
"Chemlight_red",
"Chemlight_yellow"*/
]],[ 1, [						// MILITARY
"100Rnd_65x39_caseless_mag",
"100Rnd_65x39_caseless_mag_Tracer",
"150Rnd_762x51_Box",
"150Rnd_762x51_Box_Tracer",
//"16Rnd_9x21_Mag",
"1Rnd_HE_Grenade_shell",
"1Rnd_Smoke_Grenade_shell",
"hlc_30Rnd_545x39_B_AK",	// - 30 Round magazine of 5.45x39mm Ball Rounds (i.e, standard bullets)
"hlc_30Rnd_545x39_T_AK",	// - 30 Round magazine of 5.45x39mm Tracer Rounds
"hlc_30Rnd_545x39_EP_AK",	// - 30 Round magazine of 5.45x39mm Enhanced Performance Rounds 
"hlc_45Rnd_545x39_t_rpk",	// - 45 Round magazine of 5.45x39mm Mixed
"hlc_30Rnd_762x39_b_ak",	// - 30 Round magazine of 7.62x39mm Ball Rounds (i.e, standard bullets)
"hlc_30Rnd_762x39_t_ak",	// - 30 Round magazine of 7.62x39mm Tracer Rounds
"hlc_45Rnd_762x39_t_rpk",	// - 45 Round magazine of 7.62x39mm Tracer Rounds
"hlc_45Rnd_762x39_m_rpk",	// - 45 Round magazine of 7.62x39mm Mixed
"hlc_75rnd_762x39_m_rpk",	//- 75 Round magazine of 7.62x39mm Mixed
"hlc_10rnd_12g_buck_S12",	//- 10 Round magazine of 12 Gauge 00-Buckshot rounds 
"hlc_10rnd_12g_slug_S12",	//- 10 Round magazine of 12 Gauge Solid Slug rounds
"29rnd_300BLK_STANAG",		//- 30 Round magazine of .300 Blackout FMJ (-1 to ensure smooth feeding)
"29rnd_300BLK_STANAG_T",	// - 30 Round magazine of .300 Blackout Tracer Rounds
"29rnd_300BLK_STANAG_S",	// - 30 Round magazine of .300 Blackout FMJ "cold" loads for optimum sound suppression.
"hlc_30rnd_556x45_EPR",		//- 30 Round magazine of 5.56x45mm NATO Enhanced Performance Rounds.
"hlc_30rnd_556x45_SOST",	//- 30 Round magazine of 5.56x45mm NATO Mk318 Rounds(designed for optimal performance with even SBR-length rifles).
"hlc_30rnd_556x45_SPR",		//- 30 Round magazine of 5.56x45mm NATO Mk262 Rounds(desgined for long range ballistic consistency).
"hlc_20Rnd_762x51_B_G3",	// - 20 Round magazine of 7.62x51mm Ball Rounds (i.e, standard bullets
"hlc_20rnd_762x51_T_G3",	// - 20 Round magazine of 7.62x51mm Tracer Rounds
"hlc_50rnd_762x51_M_G3",	// - 50 Round magazine of 7.62x51mm Mixed at a ratio of 1 Tracer for every 5 Standard Ball rounds (X-systems drum mag, so you can have the SAW be interoperable with the rest of the squad.
"hlc_20Rnd_762x51_B_M14",	//- 20 Round magazine of 7.62x51mm Ball Rounds (i.e, standard bullets)
"hlc_20rnd_762x51_T_M14",	//- 20 Round magazine of 7.62x51mm Tracer Rounds
"hlc_50rnd_762x51_M_M14",	//- 50 Round magazine of 7.62x51mm Mixed at a ratio of 1 Tracer for every 5 Standard Ball rounds (X-systems drum mag, so you can have the SAW be interoperable with the rest of the squad.)
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
]],[ 2, [						// INDUSTRIAL
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
"hlc_30Rnd_545x39_B_AK",	// - 30 Round magazine of 5.45x39mm Ball Rounds (i.e, standard bullets)
"hlc_30Rnd_545x39_T_AK",	// - 30 Round magazine of 5.45x39mm Tracer Rounds
"hlc_30Rnd_545x39_EP_AK",	// - 30 Round magazine of 5.45x39mm Enhanced Performance Rounds 
"hlc_45Rnd_545x39_t_rpk",	// - 45 Round magazine of 5.45x39mm Mixed
"hlc_30Rnd_762x39_b_ak",	// - 30 Round magazine of 7.62x39mm Ball Rounds (i.e, standard bullets)
"hlc_30Rnd_762x39_t_ak",	// - 30 Round magazine of 7.62x39mm Tracer Rounds
"hlc_45Rnd_762x39_t_rpk",	// - 45 Round magazine of 7.62x39mm Tracer Rounds
"hlc_45Rnd_762x39_m_rpk",	// - 45 Round magazine of 7.62x39mm Mixed
"hlc_75rnd_762x39_m_rpk",	//- 75 Round magazine of 7.62x39mm Mixed
"hlc_10rnd_12g_buck_S12",	//- 10 Round magazine of 12 Gauge 00-Buckshot rounds 
"hlc_10rnd_12g_slug_S12",	//- 10 Round magazine of 12 Gauge Solid Slug rounds
"Chemlight_red",
"Chemlight_yellow"*/
]],[ 3, [						// RESEARCH
"20Rnd_556x45_UW_mag",
"hlc_20Rnd_762x51_B_fal",	//- 20 Round magazine of 7.62x51mm Ball Rounds (i.e, standard bullets)
"hlc_20Rnd_762x51_t_fal",	//- 20 Round magazine of 7.62x51mm Tracer Rounds
"hlc_20Rnd_762x51_S_fal",	//- 20 Round magazine of 7.62x51mm cold-loaded ball (subsonic, for use with suppressor
"hlc_50rnd_762x51_M_FAL",	//- 50 Round magazine of 7.62x51mm Mixed at a ratio of 1 Tracer for every 5 Standard Ball rounds
"30Rnd_556x45_Stanag",
"30Rnd_556x45_Stanag",
"30Rnd_65x39_caseless_mag",
"30Rnd_65x39_caseless_mag",
"30Rnd_65x39_caseless_green",
"30Rnd_65x39_caseless_green",
"5Rnd_127x108_Mag",
"7Rnd_408_Mag"
]]];

//here place hats, glasses, clothes, uniforms, vests
//used with addItemCargoGlobal
//"lootItem_list" array of [class, [itemlist]]
//								class		: 0-civil, 1-military, ... (add more as you wish)
//								itemlist	: list of item class names
lootItem_list = [
[ 0, [							// CIVIL
"acc_flashlight",
"hlc_muzzle_545SUP_AK",		//- PBS4 Suppressor (5.45x39)
"hlc_muzzle_762SUP_AK",		//- PBS1 Suppressor (7.62x39)
"hlc_optic_kobra",			//- Kobra Collimator Sight
"FirstAidKit",
"FirstAidKit",
"FirstAidKit",
"muzzle_snds_acp", 					// .45 ACP
"muzzle_snds_L", 					// 9mm
"optic_Aco",
"optic_ACO_grn",
"optic_aco_smg",
"optic_Holosight",
"optic_Holosight_smg"
]],[ 1, [						// MILITARY
"acc_flashlight",
"HLC_Optic_PSO1",			//- PSO1 Sniper Optic
"HLC_Optic_1p29",			//- 1P29 Rifle Combat Optic
"hlc_optic_goshawk",		//- Goshawk Thermal Sight
"hlc_muzzle_556NATO_KAC",	//-Sound Suppressor 5.56MM NATO AR15s
"hlc_muzzle_300blk_KAC",	//- Sound Suppressor .300 Blackout AR15s
"hlc_optic_LRT_m14",		//- Leupold LR/T (Effectively the same as the LRPS that's already ingame)
"hlc_optic_PVS4FAL",		//- AN/PVS4 Night Optic (Exclusive to the FALs)
"hlc_optic_suit",			//- SUIT Optic (Single Unit, infantry, Trilux. Exclusive to the FALs)
"hlc_muzzle_snds_fal",		//- FAL Suppressor
"hlc_muzzle_snds_HK33",		//-  Sound Suppressor for the HK53 (and later, the HK33)
"hlc_muzzle_snds_G3",		//-Sound Suppressor for the G3 Rifles (PSG excluded)
"HLC_Optic_ZFSG1",			//- Zeiss Diavari 1.5-6x Rifle Optic in high-profile mount (Modern day as-equivelant to the ZFSG1. Altscope mode uses the Mount's peephole)
"hlc_optic_accupoint_g3",	//- Trijicon Accupoint TR20 Rifle optic in high-profile mount (3-9x, Illuminated post reticle.Altscope mode uses the Mount's peephole)
"hlc_muzzle_snds_M14",		//-Sound Suppressor for the M14 Rifles 
"hlc_optic_artel_m14",		//-  Redfield AR-TEL Optic (3-9x Scope. Sadly, it's impossible in the engine to replicate the locked zoom:zero function)
"FirstAidKit",
"ItemGPS",
"Medikit",
"muzzle_snds_acp", 					// .45 ACP
"muzzle_snds_B", 					// 7.62mm
"muzzle_snds_H", 					// 6.5mm
"muzzle_snds_H_MG", 				// 6.5mm LMG
"muzzle_snds_L", 					// 9mm
"muzzle_snds_M", 					// 5.56mm
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
]],[ 2, [						// INDUSTRIAL
"FirstAidKit",
"FirstAidKit",
"Medikit",
"ToolKit",
"ToolKit"
]],[ 3, [						// RESEARCH
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
]]];

//here place backpacks, parachutes and packed drones/stationary
//used with addBackpackCargoGlobal
//"lootBackpack_list" array of [class, [backpacklist]]
//								class		: 0-civil, 1-military, ... (add more as you wish)
//								backpacklist: list of backpack class names
lootBackpack_list = [
[ 0, [							// CIVIL
"B_FieldPack_blk",
"B_FieldPack_cbr",
"B_FieldPack_khk",
"B_FieldPack_oucamo"
]],[ 1, [						// MILITARY
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
]],[ 2, [						// INDUSTRIAL
"B_FieldPack_blk",
"B_FieldPack_cbr",
"B_FieldPack_khk",
"B_FieldPack_oucamo",
"B_Kitbag_cbr",
"B_Kitbag_rgr",
"B_Kitbag_mcamo",
"B_Kitbag_sgg"
]],[ 3, [						// RESEARCH
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
]]];

//here place any other objects(ex.: Land_Basket_F, Box_East_Wps_F, Land_Can_V3_F, ...)
//used with createVehicle directly
//"lootworldObject_list" array of [class, [objectlist]]
//								class		: 0-civil, 1-military, ... (add more as you wish)
//								objectlist	: list of worldobject class names
lootworldObject_list = [
[ 0, [							// CIVIL
"Land_BakedBeans_F",				// food
"Land_BakedBeans_F",				// food
"Land_BottlePlastic_V2_F",			// water
"Land_BottlePlastic_V2_F",			// water
"Land_Can_V3_F",					// energydrink
"Land_Suitcase_F",					// repairkit
"Land_CanisterOil_F",				// syphon hose
"Land_CanisterFuel_F"				// jerrycan
]],[ 1, [						// MILITARY
"Land_BakedBeans_F",				// food
"Land_BottlePlastic_V2_F",			// water
"Land_Can_V3_F",					// energydrink
"Land_Suitcase_F",					// repairkit
"Land_CanisterOil_F",				// syphon hose
"Land_CanisterFuel_F"				// jerrycan
]],[ 2, [						// INDUSTRIAL
"Land_BakedBeans_F",				// food
"Land_BottlePlastic_V2_F",			// water
"Land_Can_V3_F",					// energydrink
"Land_Suitcase_F",					// repairkit
"Land_Suitcase_F",					// repairkit
"Land_CanisterOil_F",				// syphon hose
"Land_CanisterOil_F",				// syphon hose
"Land_CanisterFuel_F",				// jerrycan
"Land_CanisterFuel_F"				// jerrycan
]],[ 3, [						// RESEARCH
"Land_BakedBeans_F",				// food
"Land_BottlePlastic_V2_F",			// water
"Land_Can_V3_F",					// energydrink
"Land_Suitcase_F",					// repairkit
"Land_CanisterOil_F",				// syphon hose
"Land_CanisterFuel_F"				// jerrycan
]]];