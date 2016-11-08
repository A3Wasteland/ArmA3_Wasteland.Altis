// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: customGroup.sqf
//	@file Author: AgentRev

if (!isServer) exitWith {};

private ["_group", "_pos", "_nbUnits", "_unitTypes", "_uPos", "_unit"];

_group = _this select 0;
_pos = _this select 1;
_nbUnits = param [2, 7, [0]];
_radius = param [3, 10, [0]];

_unitTypes =
[
	"I_C_Soldier_Bandit_7_F", "I_C_Soldier_Para_7_F", "I_C_Soldier_Para_2_F", 
	"I_C_Soldier_Bandit_3_F", "I_C_Soldier_Bandit_2_F", "I_C_Soldier_Para_3_F", 
	"I_C_Soldier_Para_4_F", "I_C_Soldier_Para_6_F", "I_C_Soldier_Para_8_F", 
	"I_C_Soldier_Bandit_5_F", "I_C_Soldier_Bandit_6_F", "I_C_Soldier_Bandit_1_F", 
	"I_C_Soldier_Para_1_F", "I_C_Soldier_Para_5_F", "I_C_Soldier_Bandit_8_F", 
	"I_C_Soldier_Bandit_4_F"
];

for "_i" from 1 to 32 do
{
	_uPos = _pos vectorAdd ([[random _radius, 0, 0], random 360] call BIS_fnc_rotateVector2D);
	_unit = _group createUnit [_unitTypes call BIS_fnc_selectRandom, _uPos, [], 0, "Form"];
	_unit setPosATL _uPos;

	removeAllWeapons _unit;
	removeAllAssignedItems _unit;
	removeUniform _unit;
	removeVest _unit;
	removeBackpack _unit;
	removeHeadgear _unit;
	removeGoggles _unit;

	_unit addVest ["V_BandollierB_rgr", "V_Chestrig_khk", "V_Chestrig_blk", "V_Chestrig_oli", "V_BandollierB_blk"] call BIS_fnc_selectRandom;
	_unit addMagazine "30Rnd_762x39_Mag_F";
	_unit addMagazine "30Rnd_762x39_Mag_F";
	_unit addMagazine "30Rnd_762x39_Mag_F";

	switch (true) do
	{
		// Grenadier every 3 units
		case (_i % 3 == 0):
		{
			_unit addUniform ["U_I_C_Soldier_Bandit_1_F", "U_I_C_Soldier_Para_4_F", "U_I_C_Soldier_Para_2_F", "U_I_C_Soldier_Bandit_3_F", "U_I_C_Soldier_Bandit_2_F", "U_I_C_Soldier_Para_3_F","U_I_C_Soldier_Para_1_F", "U_I_C_Soldier_Bandit_5_F", "U_I_C_Soldier_Para_5_F", "U_I_C_Soldier_Bandit_4_F"]  call BIS_fnc_selectRandom;
			_unit addMagazine "1Rnd_HE_Grenade_shell";
			_unit addWeapon "arifle_AK12_GL_F";
			_unit addMagazine "1Rnd_HE_Grenade_shell";
			_unit addMagazine "1Rnd_HE_Grenade_shell";
		};
		// RPG every 7 units, starting from second one
		case ((_i + 5) % 7 == 0):
		{
			_unit addUniform ["U_I_C_Soldier_Bandit_1_F", "U_I_C_Soldier_Para_4_F", "U_I_C_Soldier_Para_2_F", "U_I_C_Soldier_Bandit_3_F", "U_I_C_Soldier_Bandit_2_F", "U_I_C_Soldier_Para_3_F","U_I_C_Soldier_Para_1_F", "U_I_C_Soldier_Bandit_5_F", "U_I_C_Soldier_Para_5_F", "U_I_C_Soldier_Bandit_4_F"]  call BIS_fnc_selectRandom;
			_unit addBackpack "B_Kitbag_mcamo";
			_unit addWeapon [["arifle_AKS_F", "arifle_AKM_F", "arifle_AK12_F"]call BIS_fnc_selectRandom];
			_unit addMagazine "RPG7_F";
			_unit addWeapon "launch_RPG7_F";
			_unit addMagazine "RPG7_F";
			_unit addMagazine "RPG7_F";
		};
		// Rifleman
		default
		{
			_unit addUniform ["U_I_C_Soldier_Bandit_1_F", "U_I_C_Soldier_Para_4_F", "U_I_C_Soldier_Para_2_F", "U_I_C_Soldier_Bandit_3_F", "U_I_C_Soldier_Bandit_2_F", "U_I_C_Soldier_Para_3_F","U_I_C_Soldier_Para_1_F", "U_I_C_Soldier_Bandit_5_F", "U_I_C_Soldier_Para_5_F", "U_I_C_Soldier_Bandit_4_F"]  call BIS_fnc_selectRandom;

			if (_unit == leader _group) then
			{
				_unit addWeapon ["arifle_AKS_F", "arifle_AKM_F", "arifle_AK12_F"]call BIS_fnc_selectRandom;
				_unit setRank "SERGEANT";
			}
			else
			{
				_unit addWeapon  ["arifle_AKS_F", "arifle_AKM_F", "arifle_AK12_F"]call BIS_fnc_selectRandom];
			};
		};
	};

	_unit addPrimaryWeaponItem "acc_flashlight";
	_unit enablegunlights "forceOn";

	_unit addRating 1e11;
	_unit spawn refillPrimaryAmmo;
	_unit call setMissionSkill;
	_unit addEventHandler ["Killed", server_playerDied];
};

[_group, _pos] call defendArea;
