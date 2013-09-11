//	@file Version: 1.0
//	@file Name: fn_refilltruck.sqf
//	@file Author: AgentRev
//	@file Created: 30/06/2013 15:28

if (!isServer) exitWith {};

private ["_truck", "_truckItems", "_mag"];
_truck = _this;

// Clear prexisting cargo first
clearMagazineCargoGlobal _truck;
clearWeaponCargoGlobal _truck;
clearItemCargoGlobal _truck;

// Item type, Item, # of items, # of magazines per weapon
_truckItems =
[
	["itm", "FirstAidKit", 10],
	["itm", "Medikit", 5],
	["itm", "Toolkit", 3],
	["itm", ["optic_Aco", "optic_ACO_grn"] call BIS_fnc_selectRandom, 5],
	["itm", ["optic_Hamr", "optic_Arco"] call BIS_fnc_selectRandom, 5],
	["wep", ["SMG_01_F", "SMG_02_F"] call BIS_fnc_selectRandom, 5, 4],
	["wep", ["arifle_Mk20_GL_F", "arifle_TRG21_GL_F"] call BIS_fnc_selectRandom, 5, 4],
	["wep", ["arifle_Katiba_GL_F", "arifle_MX_GL_F"] call BIS_fnc_selectRandom, 5, 4],
	["mag", "1Rnd_HE_Grenade_shell", 10],
	["wep", ["srifle_GM6_SOS_F", "srifle_LRR_SOS_F"] call BIS_fnc_selectRandom, 1, 5],
	["wep", "launch_Titan_short_F", 2, 0],
	["mag", "Titan_AT", 8],
	["mag", "HandGrenade", 5],
	["mag", ["APERSTripMine_Wire_Mag", "APERSBoundingMine_Range_Mag"] call BIS_fnc_selectRandom, 5],
	["mag", ["ATMine_Range_Mag", "SLAMDirectionalMine_Wire_Mag"] call BIS_fnc_selectRandom, 5]
];

// Add items
{
	switch (_x select 0) do
	{
		case "wep":
		{
			_truck addWeaponCargoGlobal [_x select 1, _x select 2];
			
			if (count _x > 3 && {_x select 3 > 0}) then
			{
				_mag = ((getArray (configFile >> "CfgWeapons" >> (_x select 1) >> "magazines")) select 0) call getBallMagazine;
				_truck addMagazineCargoGlobal [_mag, (_x select 2) * (_x select 3)];
			};
		};
		case "mag":
		{
			_truck addMagazineCargoGlobal [_x select 1, _x select 2];
		};
		case "itm":
		{
			_truck addItemCargoGlobal [_x select 1, _x select 2];
		};
	};
} forEach _truckItems;
