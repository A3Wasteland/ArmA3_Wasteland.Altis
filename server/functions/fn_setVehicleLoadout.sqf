// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2016 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_setVehicleLoadout.sqf
//	@file Author: AgentRev

params [["_veh",objNull,[objNull,""]], ["_brandNew",false,[false]], ["_redoWeapons",false,[false]], ["_resupply",false,[false]]];

if (_veh isEqualType "") then {	_veh = objectFromNetId _veh };

if (!alive _veh) exitWith {};
if (!local _veh) exitWith
{
	if !(_this isEqualType []) then { _this = [_this] };

	_this remoteExec ["A3W_fnc_setVehicleLoadout", _veh];
};

private _class = typeOf _veh;
private ["_mags", "_weapons", "_customCode"];

/*switch (true) do
{
	case (_class isKindOf "UAV_02_base_F" && !(_class isKindOf "UAV_02_CAS_base_F")):
	{
		_mags =
		[
			["120Rnd_CMFlare_Chaff_Magazine", [-1]],
			["Laserbatteries", [0]],
			["2Rnd_LG_scalpel", [0]]
		];
		_weapons =
		[
			["CMFlareLauncher", [-1]],
			["Laserdesignator_mounted", [0]],
			["missiles_SCALPEL", [0]]
		];
	};

	case (_class isKindOf "O_T_UAV_04_CAS_F"):
	{
		_customCode =
		{
			_veh setMagazineTurretAmmo ["4Rnd_LG_Jian", 2, [0]];
		};
	};

	case (_class isKindOf "B_Plane_CAS_01_F"):
	{
		_mags =
		[
			["1000Rnd_Gatling_30mm_Plane_CAS_01_F", [-1]],
			["2Rnd_Missile_AA_04_F", [-1]],
			["4Rnd_Bomb_04_F", [-1]],
			["240Rnd_CMFlare_Chaff_Magazine", [-1]]
		];
		_weapons =
		[
			["Gatling_30mm_Plane_CAS_01_F", [-1]],
			["Missile_AA_04_Plane_CAS_01_F", [-1]],
			["Bomb_04_Plane_CAS_01_F", [-1]],
			["CMFlareLauncher", [-1]]
		];
	};

	case (_class isKindOf "O_Plane_CAS_02_F"):
	{
		_mags =
		[
			["500Rnd_Cannon_30mm_Plane_CAS_02_F", [-1]],
			["20Rnd_Rocket_03_HE_F", [-1]],
			["2Rnd_Missile_AA_03_F", [-1]],
			["2Rnd_Bomb_03_F", [-1]],
			["240Rnd_CMFlare_Chaff_Magazine", [-1]]
		];
		_weapons =
		[
			["Cannon_30mm_Plane_CAS_02_F", [-1]],
			["Missile_AA_03_Plane_CAS_02_F", [-1]],
			["Rocket_03_HE_Plane_CAS_02_F", [-1]],
			["Bomb_03_Plane_CAS_02_F", [-1]],
			["CMFlareLauncher", [-1]]
		];
	};

	case (_class isKindOf "I_Plane_Fighter_03_CAS_F"):
	{
		_mags =
		[
			["300Rnd_20mm_shells", [-1]],
			//["300Rnd_20mm_shells", [-1]],
			["2Rnd_AAA_missiles", [-1]],
			["2Rnd_GBU12_LGB_MI10", [-1]],
			["240Rnd_CMFlare_Chaff_Magazine", [-1]]
		];
		_weapons =
		[
			["Twin_Cannon_20mm", [-1]],
			["missiles_ASRAAM", [-1]],
			["GBU12BombLauncher", [-1]],
			["CMFlareLauncher", [-1]]
		];
	};

	case (_class isKindOf "O_Heli_Light_02_F"):
	{
		_mags =
		[
			["2000Rnd_65x39_Belt_Tracer_Green_Splash", [-1]],
			["12Rnd_missiles", [-1]],
			["168Rnd_CMFlare_Chaff_Magazine", [-1]]
		];
		_weapons =
		[
			["LMG_Minigun_heli", [-1]],
			["missiles_DAR", [-1]],
			["CMFlareLauncher", [-1]]
		];
	};

	case (_class isKindOf "Heli_Attack_01_base_F"):
	{
		_mags =
		[
			["240Rnd_CMFlare_Chaff_Magazine", [-1]],
			["120Rnd_CMFlare_Chaff_Magazine", [0]],
			["1000Rnd_20mm_shells", [0]],
			["12Rnd_PG_missiles", [0]],
			["4Rnd_AAA_missiles", [0]]
		];
		_weapons =
		[
			["CMFlareLauncher", [-1]],
			["CMFlareLauncher", [0]],
			["gatling_20mm", [0]],
			["missiles_DAGR", [0]],
			["missiles_ASRAAM", [0]]
		];
	};

	case ({_class isKindOf _x} count ["Heli_Attack_02_base_F", "VTOL_02_base_F"] > 0):
	{
		_mags =
		[
			["192Rnd_CMFlare_Chaff_Magazine", [-1]],
			["96Rnd_CMFlare_Chaff_Magazine", [0]],
			["250Rnd_30mm_HE_shells", [0]],
			["250Rnd_30mm_APDS_shells", [0]],
			["6Rnd_LG_scalpel", [0]],
			["14Rnd_80mm_rockets", [0]]
		];
		_weapons =
		[
			["CMFlareLauncher", [-1]],
			["CMFlareLauncher", [0]],
			["gatling_30mm", [0]],
			["missiles_SCALPEL", [0]],
			["rockets_Skyfire", [0]]
		];
	};

	case (_class isKindOf "Mortar_01_base_F"):
	{
		_mags =
		[
			["8Rnd_82mm_Mo_shells", [0]],
			["8Rnd_82mm_Mo_Flare_white", [0]],
			["8Rnd_82mm_Mo_LG", [0]]
		];
		_weapons =
		[
			["mortar_82mm", [0]]
		];
	};
};*/

if (isNil "_mags" && isNil "_weapons" && isNil "_customCode") exitWith {};

private "_oldWeapons";

if (isServer && (_redoWeapons || !isNil "_weapons")) then
{
	_oldWeapons = _veh call fn_removeTurretWeapons;
};

if (_brandNew && !isNil "_mags") then
{
	{ _veh removeMagazineTurret (_x select [0,2]) } forEach magazinesAllTurrets _veh;
	{ _veh addMagazineTurret _x } forEach _mags;
};

if (isServer && !isNil "_oldWeapons") then
{
	[_veh, if (_redoWeapons || isNil "_weapons") then [{_oldWeapons},{_weapons}]] call fn_addTurretWeapons;
};

if ((_brandNew || _resupply) && !isNil "_customCode") then
{
	call _customCode;
};
