// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2017 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: vehicleLoadouts.sqf
//	@file Author: AgentRev

/*
	HOW TO CREATE A PYLON LOADOUT:
	 1. Create new scenario in Eden, add vehicle, adjust pylon loadout, and set Object Init to: copyToClipboard str getPylonMagazines this
	 3. Play scenario, wait until loaded, then pause game and return to Eden.
	 4. Your pylon array is now in the clipboard, which you can paste in this file, e.g. _pylons = ["PylonMissile_Missile_AA_R73_x1","","","","","","","","","","","","",""];

	Note: You can use any pylon type you want in the script, even if not shown in the editor, it should normally work! e.g. "PylonRack_12Rnd_missiles" for "B_Plane_Fighter_01_F"
*/

switch (true) do
{
	// AH-9 Pawnee
	case (_class isKindOf "B_Heli_Light_01_dynamicLoadout_F"):
	{
		switch (_variant) do
		{
			case "pawneeGun": { _pylons = ["",""] };
			default           { _pylons = ["PylonRack_12Rnd_missiles","PylonRack_12Rnd_missiles"] };
		};
	};

	// PO-30 Orca
	case (_class isKindOf "O_Heli_Light_02_dynamicLoadout_F"):
	{
		switch (_variant) do
		{
			case "orcaDAGR": { _pylons = ["PylonWeapon_2000Rnd_65x39_belt","PylonRack_12Rnd_PG_missiles"] };
			default          { _pylons = ["PylonWeapon_2000Rnd_65x39_belt","PylonRack_12Rnd_missiles"] };
		};
	};

	// AH-99 Blackfoot
	case (_class isKindOf "Heli_Attack_01_dynamicLoadout_base_F"):
	{
		_pylons = ["PylonMissile_1Rnd_AAA_missiles","PylonMissile_1Rnd_LG_scalpel","PylonRack_12Rnd_missiles","PylonRack_12Rnd_missiles","PylonMissile_1Rnd_LG_scalpel","PylonMissile_1Rnd_AAA_missiles"];
	};

	// Mi-48 Kajman
	case (_class isKindOf "Heli_Attack_02_dynamicLoadout_base_F"):
	{
		_pylons = ["PylonMissile_1Rnd_LG_scalpel","PylonRack_19Rnd_Rocket_Skyfire","PylonRack_19Rnd_Rocket_Skyfire","PylonMissile_1Rnd_LG_scalpel"];
	};

	// Y-32 Xi'an
	case ({_class isKindOf _x} count ["VTOL_02_infantry_dynamicLoadout_base_F", "VTOL_02_vehicle_dynamicLoadout_base_F"] > 0):
	{
		_pylons = ["PylonRack_1Rnd_Missile_AGM_01_F","PylonRack_19Rnd_Rocket_Skyfire","PylonRack_19Rnd_Rocket_Skyfire","PylonRack_1Rnd_Missile_AGM_01_F"];
	};

	// A-143 Buzzard
	case (_class isKindOf "Plane_Fighter_03_dynamicLoadout_base_F"):
	{
		_weapons =
		[
			["Laserdesignator_pilotCamera", [-1]],
			["CMFlareLauncher", [-1]]
		];
		_mags =
		[
			["Laserbatteries", [-1]],
			["120Rnd_CMFlare_Chaff_Magazine", [-1]]
		];
		switch (_variant) do
		{
			case "buzzardAA": { _pylons = ["PylonRack_1Rnd_Missile_AA_04_F","PylonRack_1Rnd_GAA_missiles","PylonRack_1Rnd_GAA_missiles","PylonWeapon_300Rnd_20mm_shells","PylonRack_1Rnd_GAA_missiles","PylonRack_1Rnd_GAA_missiles","PylonRack_1Rnd_Missile_AA_04_F"] };
			default           { _pylons = ["PylonRack_1Rnd_LG_scalpel","PylonRack_1Rnd_Missile_AA_04_F","PylonMissile_1Rnd_Bomb_04_F","PylonWeapon_300Rnd_20mm_shells","PylonMissile_1Rnd_Bomb_04_F","PylonRack_1Rnd_Missile_AA_04_F","PylonRack_1Rnd_LG_scalpel"] };
		};
		_customCode =
		{
			_veh setAmmoOnPylon [4, 500]; // 20mm gun
		};
	};

	// A-149 Gryphon
	case (_class isKindOf "Plane_Fighter_04_Base_F"):
	{
		_mags =
		[
			["magazine_Fighter04_Gun20mm_AA_x250", [-1]],
			["magazine_Fighter04_Gun20mm_AA_x250", [-1]],
			["magazine_Fighter04_Gun20mm_AA_x250", [-1]],
			["magazine_Fighter04_Gun20mm_AA_x250", [-1]], // extra gun mags (non-explosive ammo)
			["Laserbatteries", [-1]],
			["240Rnd_CMFlare_Chaff_Magazine", [-1]]
		];
		_pylons = ["PylonMissile_Missile_BIM9X_x1","PylonMissile_Missile_BIM9X_x1","PylonRack_Missile_AGM_02_x1","PylonRack_Missile_AGM_02_x1","PylonRack_Missile_AMRAAM_C_x1","PylonRack_Missile_AMRAAM_C_x1"];
	};

	// F/A-181 Black Wasp
	case (_class isKindOf "B_Plane_Fighter_01_F"):
	{
		_mags =
		[
			["magazine_Fighter01_Gun20mm_AA_x450", [-1]],
			["magazine_Fighter01_Gun20mm_AA_x450", [-1]], // extra gun mag (non-explosive ammo)
			["Laserbatteries", [-1]],
			["240Rnd_CMFlare_Chaff_Magazine", [-1]]
		];
		_pylons = ["PylonRack_Missile_AGM_02_x1","PylonRack_Missile_AGM_02_x1","PylonRack_7Rnd_Rocket_04_HE_F","PylonRack_7Rnd_Rocket_04_AP_F","PylonMissile_Missile_BIM9X_x1","PylonMissile_Missile_BIM9X_x1","PylonMissile_Missile_AMRAAM_D_INT_x1","PylonMissile_Missile_AMRAAM_D_INT_x1","PylonMissile_Missile_AMRAAM_D_INT_x1","PylonMissile_Missile_AMRAAM_D_INT_x1","PylonMissile_Bomb_GBU12_x1","PylonMissile_Bomb_GBU12_x1"];
	};

	// F/A-181 Black Wasp (Stealth)
	case (_class isKindOf "B_Plane_Fighter_01_Stealth_F"):
	{
		_mags =
		[
			["magazine_Fighter01_Gun20mm_AA_x450", [-1]],
			["magazine_Fighter01_Gun20mm_AA_x450", [-1]],
			["magazine_Fighter01_Gun20mm_AA_x450", [-1]],
			["magazine_Fighter01_Gun20mm_AA_x450", [-1]],
			["magazine_Fighter01_Gun20mm_AA_x450", [-1]], // extra gun mags to make up for lack of pylons (non-explosive ammo)
			["Laserbatteries", [-1]],
			["240Rnd_CMFlare_Chaff_Magazine", [-1]]
		];
		_pylons = ["","","","","","","","","","","",""];
	};

	// To-201 Shikra
	case (_class isKindOf "O_Plane_Fighter_02_F"):
	{
		_mags =
		[
			["magazine_Fighter02_Gun30mm_AA_x180", [-1]],
			["magazine_Fighter02_Gun30mm_AA_x180", [-1]], // extra gun mag (non-explosive ammo)
			["Laserbatteries", [-1]],
			["240Rnd_CMFlare_Chaff_Magazine", [-1]]
		];
		_pylons = ["PylonMissile_Missile_AGM_KH25_x1","PylonMissile_Missile_AGM_KH25_x1","PylonMissile_Bomb_KAB250_x1","PylonMissile_Bomb_KAB250_x1","PylonRack_20Rnd_Rocket_03_HE_F","PylonRack_20Rnd_Rocket_03_AP_F","PylonMissile_Missile_AA_R73_x1","PylonMissile_Missile_AA_R73_x1","PylonMissile_Missile_AA_R77_x1","PylonMissile_Missile_AA_R77_x1","PylonMissile_Missile_AA_R77_INT_x1","PylonMissile_Missile_AA_R77_INT_x1","PylonMissile_Bomb_KAB250_x1"];
	};

	// To-201 Shikra (Stealth)
	case (_class isKindOf "O_Plane_Fighter_02_Stealth_F"):
	{
		_mags =
		[
			["magazine_Fighter02_Gun30mm_AA_x180", [-1]],
			["magazine_Fighter02_Gun30mm_AA_x180", [-1]],
			["magazine_Fighter02_Gun30mm_AA_x180", [-1]],
			["magazine_Fighter02_Gun30mm_AA_x180", [-1]],
			["magazine_Fighter02_Gun30mm_AA_x180", [-1]], // extra gun mags to make up for lack of pylons (non-explosive ammo)
			["Laserbatteries", [-1]],
			["240Rnd_CMFlare_Chaff_Magazine", [-1]]
		];
		_pylons = ["","","","","","","","","","","","",""];
	};

	// A-164 Wipeout CAS
	case (_class isKindOf "Plane_CAS_01_dynamicLoadout_base_F"):
	{
		_pylons = ["PylonRack_1Rnd_Missile_AA_04_F","PylonRack_1Rnd_Missile_AGM_02_F","PylonMissile_1Rnd_BombCluster_01_F","PylonMissile_1Rnd_Bomb_04_F","PylonRack_7Rnd_Rocket_04_HE_F","PylonRack_7Rnd_Rocket_04_AP_F","PylonMissile_1Rnd_Bomb_04_F","PylonMissile_1Rnd_BombCluster_01_F","PylonRack_1Rnd_Missile_AGM_02_F","PylonRack_1Rnd_Missile_AA_04_F"];
	};

	// To-199 Neophron CAS
	case (_class isKindOf "Plane_CAS_02_dynamicLoadout_base_F"):
	{
		_pylons = ["PylonRack_1Rnd_Missile_AA_03_F","PylonRack_1Rnd_Missile_AGM_01_F","PylonMissile_1Rnd_BombCluster_01_F","PylonMissile_1Rnd_Bomb_03_F","PylonRack_20Rnd_Rocket_03_HE_F","PylonRack_20Rnd_Rocket_03_AP_F","PylonMissile_1Rnd_Bomb_03_F","PylonMissile_1Rnd_BombCluster_01_F","PylonRack_1Rnd_Missile_AGM_01_F","PylonRack_1Rnd_Missile_AA_03_F"];
	};

	// Greyhawk/Ababil UAVs
	case (_class isKindOf "UAV_02_dynamicLoadout_base_F"):
	{
		switch (_variant) do
		{
			case "greyhawkBomber": { _pylons = ["PylonMissile_1Rnd_Bomb_04_F","PylonMissile_1Rnd_Bomb_04_F"] };
			case "greyhawkCluster": { _pylons = ["PylonMissile_1Rnd_BombCluster_01_F","PylonMissile_1Rnd_BombCluster_01_F"] };
			case "greyhawkDAGR":    { _pylons = ["PylonRack_12Rnd_PG_missiles","PylonWeapon_2000Rnd_65x39_belt"] };
			default
			{
				_pylons = ["PylonRack_3Rnd_LG_scalpel","PylonRack_3Rnd_LG_scalpel"];
				_customCode =
				{
					_veh setAmmoOnPylon [1, 2]; // right wing
					_veh setAmmoOnPylon [2, 2]; // left wing
				};
			};
		};
	};

	// KH-3A Fenghuang UAV
	/*case (_class isKindOf "O_T_UAV_04_CAS_F"):
	{
		_customCode =
		{
			_veh setMagazineTurretAmmo ["4Rnd_LG_Jian", 2, [0]];
		};
	};*/

	// UCAV Sentinel
	case (_class isKindOf "B_UAV_05_F"):
	{
		_mags =
		[
			["120Rnd_CMFlare_Chaff_Magazine", [-1]],
			["magazine_Fighter04_Gun20mm_AA_x250", [-1]],
			["Laserbatteries", [0]]
		];
		_weapons =
		[
			["CMFlareLauncher", [-1]],
			["weapon_Fighter_Gun20mm_AA", [-1]],
			["Laserdesignator_mounted", [0]]
		];
		switch (_variant) do
		{
			case "sentinelBomber": { _pylons = ["PylonRack_Bomb_GBU12_x2","PylonRack_Bomb_GBU12_x2"] };
			case "sentinelCluster": { _pylons = ["PylonMissile_1Rnd_BombCluster_01_F","PylonMissile_1Rnd_BombCluster_01_F"] };
			default                { _pylons = ["PylonMissile_Missile_AGM_02_x2","PylonMissile_Missile_AGM_02_x2"] };
		};
	};

	// MQ-12 Falcon UAV (non-dynamicLoadout)
	case (_class isKindOf "B_T_UAV_03_F"):
	{
		_mags =
		[
			["120Rnd_CMFlare_Chaff_Magazine", [-1]],
			["1000Rnd_65x39_Belt_Green", [0]],
			["24Rnd_missiles", [0]],
			["2Rnd_LG_scalpel", [0]],
			["2Rnd_AAA_missiles", [0]],
			["Laserbatteries", [0]]
		];
		_weapons =
		[
			["CMFlareLauncher", [-1]],
			["LMG_M200", [0]],
			["missiles_DAR", [0]],
			["missiles_SCALPEL", [0]],
			["missiles_ASRAAM", [0]],
			["Laserdesignator_mounted", [0]]
		];
	};

	// SDV SDAR turret
	case (_class isKindOf "SDV_01_base_F"):
	{
		_mags =
		[
			["20Rnd_556x45_UW_mag", [0]],
			["20Rnd_556x45_UW_mag", [0]],
			["20Rnd_556x45_UW_mag", [0]],
			["20Rnd_556x45_UW_mag", [0]],
			["20Rnd_556x45_UW_mag", [0]],
			["20Rnd_556x45_UW_mag", [0]],
			["30Rnd_556x45_Stanag", [0]],
			["30Rnd_556x45_Stanag", [0]],
			["30Rnd_556x45_Stanag", [0]],
			["Laserbatteries", [0]]
		];
		_weapons =
		[
			["arifle_SDAR_F", [0]],
			["Laserdesignator_mounted", [0]]
		];
	};
};
