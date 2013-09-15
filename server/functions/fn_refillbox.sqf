//	@file Version: 1.0
//	@file Name: fn_refillbox.sqf  "fn_refillbox"
//	@file Author: [404] Pulse , [404] Costlyy , [404] Deadbeat, AgentRev
//	@file Created: 22/1/2012 00:00
//	@file Args: [OBJECT (Weapons box that needs filling), STRING (Name of the fill to give to object)]

if (!isServer) exitWith {};

private ["_box", "_boxType", "_box", "_boxItems", "_mag"];
_box = _this select 0;
_boxType = _this select 1;

_box allowDamage false; // No more fucking busted crates

// Clear pre-existing cargo first
clearMagazineCargoGlobal _box;
clearWeaponCargoGlobal _box;
clearItemCargoGlobal _box;

switch (_boxType) do
{
    case "mission_USLaunchers":
	{
    	_boxItems =
		[
			// Item type, Item class, # of items, # of magazines per weapon
			["wep", "launch_NLAW_F", 2, 2],
			["wep", "launch_RPG32_F", 2, 2],
			["wep", "launch_Titan_F", 2, 2],
			["mag", "ClaymoreDirectionalMine_Remote_Mag", 3],
			["mag", "DemoCharge_Remote_Mag", 3]
		];
    };
    case "mission_USSpecial":
	{
    	_boxItems =
		[
			// Item type, Item class, # of items, # of magazines per weapon
			//["itm", "NVGoggles", 5],
			["wep", "Binocular", 5],
			["itm", "Medikit", 4],
			["itm", "Toolkit", 2],
			["wep", "arifle_MXM_F", 2, 5],
			["wep", "srifle_EBR_F", 2, 5],
			["wep", "arifle_MX_SW_F", 2, 4],
			["wep", "LMG_Mk200_F", 2, 4],
			["wep", "LMG_Zafir_F", 1, 4],
			["mag", "30Rnd_556x45_Stanag", 10],
			["mag", "30Rnd_65x39_caseless_mag", 10],
			["mag", "30Rnd_65x39_caseless_green", 10],
			["mag", "9Rnd_45ACP_Mag", 10]
		];
    };
    case "mission_USSpecial2":
	{
    	_boxItems =
		[
			// Item type, Item class, # of items, # of magazines per weapon
			["wep", "arifle_TRG21_GL_F", 3, 5],
			["wep", "arifle_Katiba_GL_F", 3, 5],
			["wep", "arifle_MX_GL_F", 3, 5],
			["mag", "1Rnd_HE_Grenade_shell", 10],
			["mag", "SmokeShell", 2],
			["mag", "SmokeShellPurple", 2],
			["mag", "SmokeShellBlue", 2],
			["mag", "SmokeShellGreen", 2],
			["mag", "SmokeShellYellow", 2],
			["mag", "SmokeShellOrange", 2],
			["mag", "SmokeShellRed", 2],
			["mag", "UGL_FlareWhite_F", 2],
			["mag", "UGL_FlareGreen_F", 2],
			["mag", "UGL_FlareYellow_F", 2],
			["mag", "UGL_FlareRed_F", 2],
			["mag", "UGL_FlareCIR_F", 2]
		];
    };
	case "mission_Main_A3snipers":
	{
    	_boxItems =
		[
			// Item type, Item class, # of items, # of magazines per weapon
			["wep", "srifle_LRR_SOS_F", 1, 5],
			["wep", "srifle_GM6_SOS_F", 1, 5],
			["wep", "srifle_EBR_F", 2, 6],
			["wep", "Rangefinder", 2]
		];
    };
};

// Add items
{
	switch (_x select 0) do
	{
		case "wep":
		{
			_box addWeaponCargoGlobal [_x select 1, _x select 2];
			
			if (count _x > 3 && {_x select 3 > 0}) then
			{
				_mag = ((getArray (configFile >> "CfgWeapons" >> (_x select 1) >> "magazines")) select 0) call getBallMagazine;
				_box addMagazineCargoGlobal [_mag, (_x select 2) * (_x select 3)];
			};
		};
		case "mag":
		{
			_box addMagazineCargoGlobal [_x select 1, _x select 2];
		};
		case "itm":
		{
			_box addItemCargoGlobal [_x select 1, _x select 2];
		};
	};
} forEach _boxItems;
