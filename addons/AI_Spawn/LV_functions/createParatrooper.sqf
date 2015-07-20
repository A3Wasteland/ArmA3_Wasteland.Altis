// Based on chunks from A3Wasteland createRandomSoldier.sqf and customGroup.sqf
// @Masher of Code : Apoc
// 
//	@file Name: createParatrooper.sqf
/*
 * Creates a civilian soldier unit for use by a paradrop script.
 *
 * Arguments: [index, position, group, init, skill, rank]: Array
 *	  index: Index of Jump Loop - What is the jumper number?	
 *    position: Position - Location unit is created at.
 *    group: Group - Existing group new unit will join.
 *    init: String - (optional, default "") Command to be executed upon creation of unit. Parameter this is set to the created unit and passed to the code.
 *    skill: Number - (optional, default 0.5)
 *    rank: String - (optional, default "PRIVATE")
 */

if (!isServer) exitWith {};

private ["_unitTypes", "_uniformTypes", "_vestTypes", "_weaponTypes", "_group", "_position", "_rank", "_soldier","_index"];

_unitTypes =
[
	"C_man_polo_1_F", "C_man_polo_1_F_euro", "C_man_polo_1_F_afro", "C_man_polo_1_F_asia",
	"C_man_polo_2_F", "C_man_polo_2_F_euro", "C_man_polo_2_F_afro", "C_man_polo_2_F_asia",
	"C_man_polo_3_F", "C_man_polo_3_F_euro", "C_man_polo_3_F_afro", "C_man_polo_3_F_asia",
	"C_man_polo_4_F", "C_man_polo_4_F_euro", "C_man_polo_4_F_afro", "C_man_polo_4_F_asia",
	"C_man_polo_5_F", "C_man_polo_5_F_euro", "C_man_polo_5_F_afro", "C_man_polo_5_F_asia",
	"C_man_polo_6_F", "C_man_polo_6_F_euro", "C_man_polo_6_F_afro", "C_man_polo_6_F_asia"
];


_uniformTypes = ["U_O_SpecopsUniform_ocamo"];
_vestTypes = ["V_PlateCarrier1_rgr","V_PlateCarrier2_rgr","V_PlateCarrier1_blk","V_TacVest_blk","V_PlateCarrierH_CTRG"];
_weaponTypes = ["arifle_TRG20_F","LMG_Mk200_F","arifle_MXM_F","arifle_MX_GL_F"];

_index 		= _this select 0;
_group 		= _this select 1;
_position 	= _this select 2;

_rank = [_this, 3, "", [""]] call BIS_fnc_param;

_soldier = _group createUnit [_unitTypes call BIS_fnc_selectRandom, _position, [], 0, "NONE"];
_soldier addUniform (_uniformTypes call BIS_fnc_selectRandom);
_soldier addVest (_vestTypes call BIS_fnc_selectRandom);

switch (true) do
{
	//Random Trooper
	
	case ((_index == 1) || (_index == 2) || (_index == 3) || (_index > 8)):
	{
		[_soldier, _weaponTypes call BIS_fnc_selectRandom, 3] call BIS_fnc_addWeapon;
	};
	
	//Grenadier
	case ((_index == 4) || (_index == 5)):
	{
		_soldier addMagazine	"1Rnd_HE_Grenade_shell";
		_soldier addWeapon "arifle_TRG21_GL_F";
		_soldier addMagazine "1Rnd_HE_Grenade_shell";
		_soldier addMagazine "1Rnd_HE_Grenade_shell";
	};
	//AT Unit
	case (_index == 6):
	{
		_soldier addBackpack "B_Kitbag_mcamo";
		_soldier addWeapon "arifle_TRG20_F";
		_soldier addMagazine "Titan_AT";
		_soldier addWeapon "launch_Titan_short_F";
		_soldier addMagazine "Titan_AT";
		_soldier addMagazine "Titan_AT";
	};
	//AA Unit
	case (_index == 7):
	{
		_soldier addBackpack "B_Kitbag_mcamo";
		_soldier addWeapon "arifle_TRG20_F";
		_soldier addMagazine "Titan_AA";
		_soldier addWeapon "launch_O_Titan_F";
		_soldier addMagazine "Titan_AA";
		_soldier addMagazine "Titan_AA";
	};
	//Designated Marksman
	case (_index == 8):
	{
		_soldier addWeapon "srifle_LRR_SOS_F";
	};
	//Random Trooper for default
	default
	{
	[_soldier, _weaponTypes call BIS_fnc_selectRandom, 3] call BIS_fnc_addWeapon;
	};
};

		
_soldier addPrimaryWeaponItem "acc_flashlight";
_soldier enablegunlights "forceOn";					//set to "forceOn" to force use of lights (during day too default = AUTO)

	

if (_rank != "") then
{
	_soldier setRank _rank;
};

_soldier spawn refillPrimaryAmmo;
_soldier spawn addMilCap;
_soldier call setMissionSkill;

_soldier addEventHandler ["Killed", server_playerDied];

_soldier
