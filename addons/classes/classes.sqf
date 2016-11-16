// Kit Loadouts Start here 

	switch (true) do
		{
		case (["_sniper_", typeOf _player] call fn_findString != -1):
			{
			removeBackpack _player;
			removeAllWeapons _player;
			_player addBackpack "B_FieldPack_oucamo";
			_player addMagazine "10Rnd_762x54_Mag";
			_player addMagazine "10Rnd_762x54_Mag";
			_player addMagazine "10Rnd_762x54_Mag";
			_player addWeapon "srifle_DMR_01_F";
			_player addPrimaryWeaponItem "optic_DMS";
			_player addItemtoBackpack "ClaymoreDirectionalMine_Remote_Mag";
			_player addItemtoBackpack "ClaymoreDirectionalMine_Remote_Mag";
			_player addWeapon "hgun_Rook40_F";
			_player addMagazine "16Rnd_9x21_Mag";
			_player addMagazine "16Rnd_9x21_Mag";
			_player addWeapon "Rangefinder";
			_player addItem "FirstAidKit";
			_player addItem"FirstAidKit";
						};
			
		case (["_diver_", typeOf _player] call fn_findString != -1):
			{
			removeBackpack _player;
			removeAllWeapons _player;
			_player addBackpack "B_FieldPack_blk";
			_player addMagazine "1Rnd_HE_Grenade_shell";
			_player addMagazine "1Rnd_HE_Grenade_shell";
			//_player addMagazine "20Rnd_556x45_UW_mag";
			//_player addMagazine "20Rnd_556x45_UW_mag";
			//_player addMagazine "20Rnd_556x45_UW_mag";
			//_player addMagazine "20Rnd_556x45_UW_mag";
			//_player addWeapon "arifle_SDAR_F";
			_player addMagazine "30Rnd_65x39_caseless_green";
			_player addMagazine "30Rnd_65x39_caseless_green";
			_player addWeapon "arifle_Katiba_C_F";	
			_player addMagazine "9Rnd_45ACP_Mag";
			_player addMagazine "9Rnd_45ACP_Mag";
			_player addWeapon "hgun_ACPC2_F";
			_player addWeapon "Binoculars";
			_player addItem "FirstAidKit";
			_player addItem "FirstAidKit";
			};
			
		case (["_medic_", typeOf _player] call fn_findString != -1):
			{
			removeBackpack _player;
			removeAllWeapons _player;
			_player addBackpack "B_FieldPack_ocamo";
			_player forceAddUniform "U_B_CombatUniform_mcam";
			_player addVest "V_TacVest_camo";
			//_player addMagazine "100Rnd_65x39_caseless_mag";
			//_player addMagazine "100Rnd_65x39_caseless_mag";
			_player addMagazine "30Rnd_65x39_caseless_green";
			_player addMagazine "30Rnd_65x39_caseless_green";				
			//_player addWeapon "arifle_MX_SW_F";
			_player addWeapon "arifle_Katiba_C_F";			
			//_player addPrimaryWeaponItem "optic_Hamr";
			_player addPrimaryWeaponItem "optic_Aco_grn";			
			_player addItem "HandGrenade";
			_player addItem "SmokeShell";
			_player addItem "SmokeShell";
			_player addItem "SmokeShell";
			_player addWeapon "hgun_Pistol_heavy_01_MRD_F";
			_player addMagazine "11Rnd_45ACP_Mag";
			_player addMagazine "11Rnd_45ACP_Mag";
			_player addItem "Medikit";
			_player addWeapon "Binoculars";
			_player addHeadgear "H_Watchcap_sgg";
			};
			
		case (["_engineer_", typeOf _player] call fn_findString != -1):
			{
			removeBackpack _player;
			removeAllWeapons _player;
			_player addBackpack "B_Carryall_oli";
			_player forceAddUniform "U_BG_Guerilla2_1";
			//_player addMagazine "30Rnd_556x45_Stanag";
			//_player addMagazine "30Rnd_556x45_Stanag";
			//_player addWeapon "arifle_Mk20_F";
			_player addWeapon "arifle_Katiba_C_F";	
			_player addMagazine "30Rnd_65x39_caseless_green";
			_player addMagazine "30Rnd_65x39_caseless_green";
			_player addPrimaryWeaponItem "optic_aco_smg";
			_player addItem "HandGrenade";
			_player addItem "HandGrenade";
			_player addWeapon "launch_RPG32_F";
			_player addMagazine "RPG32_F";
			_player addMagazine "RPG32_F";
			_player addMagazine "6Rnd_45ACP_Cylinder";
			_player addMagazine "6Rnd_45ACP_Cylinder";
			_player addWeapon "hgun_Pistol_heavy_02_F";
			_player addItem "Toolkit";
			_player addItem "MineDetector";
			_player addWeapon "Binoculars";
			_player addItem "FirstAidKit";
			_player addItem "FirstAidKit";
			_player addHeadgear "H_Watchcap_blk";
			_player addGoggles "G_Balaclava_blk";
			};
			
		case (["_crew_", typeOf _player] call fn_findString != -1):
			{
			removeBackpack _player;
			removeAllWeapons _player;
			_player addVest "V_HarnessOGL_gry";
			_player forceAddUniform "U_I_G_resistanceLeader_F";
			_player addBackpack "B_AssaultPack_cbr";
			_player addItemToVest "MineDetector";
			_player addItemtoBackpack "SatchelCharge_Remote_Mag";
			_player addItemtoBackpack "SatchelCharge_Remote_Mag";
			_player addItemtoBackpack "SatchelCharge_Remote_Mag";
			_player addMagazine "6Rnd_45ACP_Cylinder";
			_player addMagazine "6Rnd_45ACP_Cylinder";
			_player addMagazine "6Rnd_45ACP_Cylinder";
			_player addWeapon "hgun_Pistol_heavy_02_F";
			_player addHeadgear "H_ShemagOpen_tan";
			};
			
			
			case (["_soldier_", typeOf _player] call fn_findString != -1):
			{
			removeBackpack _player;
			removeAllWeapons _player;
			_player addVest "V_Chestrig_khk";
			_player addBackpack "B_Kitbag_cbr";
			_player forceAddUniform "U_OrestesBody";
			_player addItemtoBackpack "DemoCharge_Remote_Mag";
			_player addItemtoBackpack "DemoCharge_Remote_Mag";
			_player addItem "MiniGrenade";
			_player addItem "MiniGrenade";
			_player addItem "FirstAidKit";
			_player addItem "FirstAidKit";
			_player addItemtoBackpack "APERSMine_Range_Mag";
			_player addItemtoBackpack "APERSMine_Range_Mag";
			_player addItemtoBackpack "ATMine_Range_Mag";
			_player addItemtoBackpack "SLAMDirectionalMine_Wire_Mag";
			_player addItemtoBackpack "SLAMDirectionalMine_Wire_Mag";
			_player addMagazine "30Rnd_65x39_caseless_mag";
			_player addMagazine "30Rnd_65x39_caseless_mag";
			_player addMagazine "30Rnd_65x39_caseless_mag";
			_player addWeapon "arifle_MXC_F";
			_player addPrimaryWeaponItem "optic_Holosight";
			};
			
			
			case (["_officer_", typeOf _player] call fn_findString != -1):
			{
			removeBackpack _player;
			removeAllWeapons _player;
			_player addVest "V_PlateCarrier1_blk";
			_player addBackpack "B_AssaultPack_blk";
			_player forceAddUniform "U_B_PilotCoveralls";
			_player addItem "SmokeShellYellow";
			_player addItem "SmokeShellYellow";
			_player addItem "SmokeShellYellow";
			_player addItem "SmokeShellYellow";
			_player addItem "FirstAidKit";
			_player addItem "FirstAidKit";
			_player addMagazine "130Rnd_338_Mag";
			_player addWeapon "MMG_02_black_F";
			_player addPrimaryWeaponItem "optic_aco_smg";
			_player addPrimaryWeaponItem "bipod_01_F_blk";
			_player addHeadgear "H_PilotHelmetFighter_B";
			};
			
			default
			{};
		};


		
