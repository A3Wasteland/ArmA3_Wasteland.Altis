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

_soldierTypes = ["B_CTRG_Soldier_AR_tna_F", "B_CTRG_Soldier_Exp_tna_F", "B_CTRG_Soldier_JTAC_tna_F", "OB_CTRG_Soldier_M_tna_F", "B_CTRG_Soldier_Medic_tna_F", "B_CTRG_Soldier_tna_F", "B_CTRG_Soldier_LAT_tna_F", "B_CTRG_Soldier_TL_tna_F"];
_uniformTypes = ["U_B_CTRG_Soldier_F"];
_vestTypes = ["V_TacVest_oli,", "V_PlateCarrierIAGL_oli"];
_weaponTypes = ["arifle_SPAR_01_blk_F"];

_group = _this select 0;
_position = _this select 1;
_rank = param [2, "", [""]];

_soldier = _group createUnit [_soldierTypes call BIS_fnc_selectRandom, _position, [], 0, "NONE"];
_soldier addUniform (_uniformTypes call BIS_fnc_selectRandom);
_soldier addVest (_vestTypes call BIS_fnc_selectRandom);
[_soldier, _weaponTypes call BIS_fnc_selectRandom, 3] call BIS_fnc_addWeapon;
_soldier addItemToUniform "FirstAidKit";
for "_i" from 1 to 3 do {_soldier addItemToUniform "30Rnd_556x45_Stanag_red";};
for "_i" from 1 to 2 do {_soldier addItemToVest "30Rnd_556x45_Stanag_red";};
for "_i" from 1 to 2 do {_soldier addItemToVest "16Rnd_9x21_Mag";};
for "_i" from 1 to 2 do {_soldier addItemToVest "MiniGrenade";};
for "_i" from 1 to 3 do {_soldier addItemToVest "APERSMine_Range_Mag";};
_soldier addItemToVest "SmokeShell";
_soldier addItemToVest "SmokeShellGreen";
for "_i" from 1 to 2 do {_soldier addItemToVest "Chemlight_green";};
_soldier addBackpack "B_Kitbag_rgr_CTRGExp_F";
for "_i" from 1 to 2 do {_soldier addItemToBackpack "MineDetector";};
_soldier addItemToBackpack "ToolKit";
for "_i" from 1 to 2 do {_soldier addItemToBackpack "ClaymoreDirectionalMine_Remote_Mag";};
for "_i" from 1 to 3 do {_soldier addItemToBackpack "APERSBoundingMine_Range_Mag";};
_soldier addItemToBackpack "DemoCharge_Remote_Mag";
for "_i" from 1 to 2 do {_soldier addItemToBackpack "SLAMDirectionalMine_Wire_Mag";};
_soldier addHeadgear "H_HelmetB_TI_tna_F";
_soldier addGoggles "G_Balaclava_TI_G_tna_F";
_soldier addPrimaryWeaponItem "acc_pointer_IR";
_soldier addPrimaryWeaponItem "optic_Aco";
_soldier addWeapon "hgun_P07_khk_F";
_soldier addHandgunItem "muzzle_snds_L";
_soldier linkItem "NVGogglesB_grn_F";
_soldier setFace "GreekHead_A3_06";
_soldier setSpeaker "Male09ENG";

if (_rank != "") then
{
	_soldier setRank _rank;
};

_soldier spawn refillPrimaryAmmo;
_soldier call setMissionSkill;

_soldier addEventHandler ["Killed", server_playerDied];

_soldier
