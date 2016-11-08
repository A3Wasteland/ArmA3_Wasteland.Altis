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

private ["_soldierTypes", "_uniformTypes", "_vestTypes", "_weaponTypes", "_group", "_position", "_rank", "_soldier", "_face", "_voice"];

_soldierTypes = ["B_GEN_Soldier_F"];
_uniformTypes = ["U_B_GEN_Soldier_F"];
_vestTypes = ["V_TacVest_gen_F"];
_weaponTypes = ["SMG_05_F"];
_face  = ["TanoanHead_A3_03", "TanoanHead_A3_07", "TanoanHead_A3_06", "TanoanHead_A3_05", "TanoanHead_A3_06", "TanoanHead_A3_02"];
_voice = ["Male02FRE", "Male01FRE", "Male02ENGFRE", "Male01ENGFRE"];

_group = _this select 0;
_position = _this select 1;
_rank = param [2, "", [""]];

_soldier = _group createUnit [_soldierTypes call BIS_fnc_selectRandom, _position, [], 0, "NONE"];
_soldier addUniform (_uniformTypes call BIS_fnc_selectRandom);
_soldier addVest (_vestTypes call BIS_fnc_selectRandom);
[_soldier, _weaponTypes call BIS_fnc_selectRandom, 3] call BIS_fnc_addWeapon;
_soldier addItemToUniform "FirstAidKit";
for "_i" from 1 to 2 do {_soldier addItemToUniform "30Rnd_9x21_Mag_SMG_02";};
for "_i" from 1 to 3 do {_soldier addItemToVest "30Rnd_9x21_Mag_SMG_02";};
for "_i" from 1 to 2 do {_soldier addItemToVest "16Rnd_9x21_Mag";};
_soldier addWeapon "hgun_P07_F";
_soldier addItemToVest "HandGrenade";
_soldier addItemToVest "SmokeShell";
_soldier addHeadgear "H_MilCap_gen_F";

if (_rank != "") then
{
	_soldier setRank _rank;
};


_soldier call setMissionSkill;

_soldier addEventHandler ["Killed", server_playerDied];

_soldier
