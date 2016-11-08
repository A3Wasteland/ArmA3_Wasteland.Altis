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

private ["_soldierTypes", "_uniformTypes", "_vestTypes", "_weaponTypes", "_group", "_position", "_rank", "_soldier", "_face", "_voice", "_Hat"];

_soldierTypes = ["I_C_Pilot_F", "I_C_Helipilot_F"];
_uniformTypes = ["U_I_C_Soldier_Bandit_1_F", "U_I_C_Soldier_Para_4_F", "U_I_C_Soldier_Para_2_F", "U_I_C_Soldier_Bandit_3_F", "U_I_C_Soldier_Bandit_2_F", "U_I_C_Soldier_Para_3_F","U_I_C_Soldier_Para_1_F", "U_I_C_Soldier_Bandit_5_F", "U_I_C_Soldier_Para_5_F", "U_I_C_Soldier_Bandit_4_F"];
_vestTypes = ["V_BandollierB_rgr", "V_Chestrig_khk", "V_Chestrig_blk", "V_Chestrig_oli", "V_BandollierB_blk"];
_weaponTypes = ["arifle_AKS_F", "arifle_AKM_F", "arifle_AK12_F", "arifle_AK12_GL_F"];
_face  = ["TanoanHead_A3_03", "TanoanHead_A3_07", "TanoanHead_A3_06", "TanoanHead_A3_05", "TanoanHead_A3_06", "TanoanHead_A3_02"];
_voice = ["Male02FRE", "Male01FRE"];
_Hat = ["H_Cap_marshal", "H_Cap_headphones"];

_group = _this select 0;
_position = _this select 1;
_rank = param [2, "", [""]];

_soldier = _group createUnit [_soldierTypes call BIS_fnc_selectRandom, _position, [], 0, "NONE"];
_soldier addUniform (_uniformTypes call BIS_fnc_selectRandom);
_soldier setFace (_face call BIS_fnc_selectRandom);
_soldier setSpeaker (_voice call BIS_fnc_selectRandom);
_soldier addVest (_vestTypes call BIS_fnc_selectRandom);
[_soldier, _weaponTypes call BIS_fnc_selectRandom, 3] call BIS_fnc_addWeapon;
_soldier addItemToUniform "FirstAidKit";
_soldier addHeadgear (_Hat call BIS_fnc_selectRandom);



if (_rank != "") then
{
	_soldier setRank _rank;
};

_soldier spawn refillPrimaryAmmo;
_soldier call setMissionSkill;

_soldier addEventHandler ["Killed", server_playerDied];

_soldier
