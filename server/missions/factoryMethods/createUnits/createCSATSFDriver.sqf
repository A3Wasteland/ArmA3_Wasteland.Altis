// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: createRandomSoldier.sqf
/*
 * Creates a random civilian soldier.
 *
 * Arguments: [ position, group, init, skill, rank]: Array
 *    position: Position - Location unit is created at.
 *    group: Group - Existing group new unit will join.
 *    init: String - (optional, default "") Command to be executed upon creation of unit. Parameter this is set to the created unit and passed to the code.
 *    skill: Number - (optional, default 0.5)
 *    rank: String - (optional, default "PRIVATE")
 */

if (!isServer) exitWith {};

private ["_soldierTypes", "_uniformTypes", "_vestTypes", "_weaponTypes", "_group", "_position", "_rank", "_soldier"];

_soldierTypes = ["O_V_Soldier_JTAC_ghex_F", "CO_T_Soldier_F", "O_V_Soldier_Exp_ghex_F", "O_V_Soldier_Medic_ghex_F", "O_V_Soldier_LAT_ghex_F", "O_V_Soldier_TL_ghex_F"];
_uniformTypes = ["U_O_V_Soldier_Viper_F"];
_vestTypes = ["V_HarnessO_ghex_F"];
_weaponTypes = ["arifle_CTAR_blk_F","arifle_ARX_ghex_F"];

_group = _this select 0;
_position = _this select 1;
_rank = param [2, "", [""]];

_soldier = _group createUnit [_soldierTypes call BIS_fnc_selectRandom, _position, [], 0, "NONE"];
_soldier addUniform (_uniformTypes call BIS_fnc_selectRandom);
_soldier addVest (_vestTypes call BIS_fnc_selectRandom);
[_soldier, _weaponTypes call BIS_fnc_selectRandom, 3] call BIS_fnc_addWeapon;
_soldier addItemToUniform "FirstAidKit";
_soldier addGoggles "G_Sport_Blackyellow";
_soldier addWeapon "hgun_Rook40_F";
_soldier addPrimaryWeaponItem "acc_pointer_IR";
_soldier addPrimaryWeaponItem "optic_ACO_grn";
_soldier addItemToVest "SmokeShell";
_soldier addItemToVest "SmokeShellRed";
_soldier linkItem "O_NVGoggles_ghex_F";
_soldier addHeadgear "H_HelmetO_ghex_F";
_soldier setFace "AsianHead_A3_02";
_soldier setSpeaker "Male02CHI";
for "_i" from 1 to 2 do {_soldier addItemToVest "HandGrenade";};
for "_i" from 1 to 3 do {_soldier addItemToUniform "30Rnd_580x42_Mag_F";};
for "_i" from 1 to 6 do {_soldier addItemToVest "30Rnd_580x42_Mag_F";};
for "_i" from 1 to 2 do {_soldier addItemToVest "16Rnd_9x21_Mag";};

if (_rank != "") then
{
	_soldier setRank _rank;
};


_soldier call setMissionSkill;

_soldier addEventHandler ["Killed", server_playerDied];

_soldier
