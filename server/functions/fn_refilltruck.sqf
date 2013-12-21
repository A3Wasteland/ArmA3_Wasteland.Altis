//	@file Version: 1.0
//	@file Name: fn_refilltruck.sqf
//	@file Author: AgentRev
//	@file Created: 30/06/2013 15:28

if (!isServer) exitWith {};

private ["_truck", "_truckItems", "_item", "_qty", "_mag"];
_truck = _this;

// Clear prexisting cargo first
clearMagazineCargoGlobal _truck;
clearWeaponCargoGlobal _truck;
clearItemCargoGlobal _truck;

// Item type, Item, # of items, # of magazines per weapon
_truckItems =
[
	["itm", "FirstAidKit", 10],
	["itm", "Medikit", 4],
	["itm", "Toolkit", 2],
	["itm", ["optic_Aco", "optic_ACO_grn"], 4],
	["itm", ["optic_Hamr", "optic_Arco"], 4],
	["wep", ["SMG_01_F", "SMG_02_F"], 3, 4],
	["wep", ["arifle_Mk20_GL_F", "arifle_TRG21_GL_F"], 3, 4],
	["wep", ["arifle_Katiba_GL_F", "arifle_MX_GL_F"], 3, 4],
	["mag", "1Rnd_HE_Grenade_shell", 10],
	["wep", ["srifle_GM6_SOS_F", "srifle_LRR_SOS_F"], 1, 5],
	["wep", "launch_Titan_short_F", 2, 0],
	["mag", "Titan_AT", 8],
	["mag", "HandGrenade", 5],
	["mag", ["APERSTripMine_Wire_Mag", "APERSBoundingMine_Range_Mag"], 5],
	["mag", ["ATMine_Range_Mag", "SLAMDirectionalMine_Wire_Mag"], 5]
];

// Add items
{
	_item = if (typename (_x select 1) == "ARRAY") then { (_x select 1) call BIS_fnc_selectRandom } else { _x select 1 };
	_qty = _x select 2;
	
	switch (_x select 0) do
	{
		case "wep":
		{
			_truck addWeaponCargoGlobal [_item, _qty];
			
			if (count _x > 3 && {_x select 3 > 0}) then
			{
				_mag = ((getArray (configFile >> "CfgWeapons" >> _item >> "magazines")) select 0) call getBallMagazine;
				_truck addMagazineCargoGlobal [_mag, _qty * (_x select 3)];
			};
		};
		case "mag":
		{
			_truck addMagazineCargoGlobal [_item, _qty];
		};
		case "itm":
		{
			_truck addItemCargoGlobal [_item, _qty];
		};
	};
} forEach _truckItems;
