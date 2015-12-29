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
	"C_man_polo_1_F", "C_man_polo_1_F_euro", "C_man_polo_1_F_afro", "C_man_polo_1_F_asia",
	"C_man_polo_2_F", "C_man_polo_2_F_euro", "C_man_polo_2_F_afro", "C_man_polo_2_F_asia",
	"C_man_polo_3_F", "C_man_polo_3_F_euro", "C_man_polo_3_F_afro", "C_man_polo_3_F_asia",
	"C_man_polo_4_F", "C_man_polo_4_F_euro", "C_man_polo_4_F_afro", "C_man_polo_4_F_asia",
	"C_man_polo_5_F", "C_man_polo_5_F_euro", "C_man_polo_5_F_afro", "C_man_polo_5_F_asia",
	"C_man_polo_6_F", "C_man_polo_6_F_euro", "C_man_polo_6_F_afro", "C_man_polo_6_F_asia"
];

for "_i" from 1 to _nbUnits do
{
	_uPos = _pos vectorAdd ([[random _radius, random _radius, 0], random 360] call BIS_fnc_rotateVector2D);
	_unit = _group createUnit [_unitTypes call BIS_fnc_selectRandom, _uPos, [], 0, "Form"];
	_unit setPosATL _uPos;
	
	removeAllWeapons _unit;
	removeAllAssignedItems _unit;
	removeUniform _unit;
	removeVest _unit;
	removeBackpack _unit;
	removeHeadgear _unit;
	removeGoggles _unit;

	_unit addVest "V_TacVest_blk_POLICE";
	_unit addUniform "U_C_Driver_3";

	switch (true) do
	{
		// AT every 5 units
		case (_i % 5 == 0):
		{
			_unit addBackpack "B_Carryall_oli";
			_unit addMagazine "30Rnd_65x39_caseless_mag";
			_unit addWeapon "arifle_MXM_Black_F";
			_unit addMagazine "30Rnd_65x39_caseless_mag";
			_unit addMagazine "30Rnd_65x39_caseless_mag";
			_unit addMagazine "30Rnd_65x39_caseless_mag";
			_unit addPrimaryWeaponItem "optic_Hamr";
			_unit addMagazine "Titan_AT";
			_unit addWeapon "launch_Titan_short_F";
			_unit addMagazine "Titan_AT";
			_unit addMagazine "Titan_AT";
			_unit selectWeapon "launch_Titan_short_F";
		};
		// Sniper every 6 units
		case (_i % 6 == 0):
		{
			_unit addMagazine "7Rnd_408_Mag";
			_unit addWeapon "srifle_LRR_SOS_F";
			_unit addMagazine "7Rnd_408_Mag";
			_unit addMagazine "7Rnd_408_Mag";
			_unit addMagazine "7Rnd_408_Mag";
			_unit addPrimaryWeaponItem "optic_tws";
		};
		// AA every 7 units
		case (_i % 7 == 0):
		{
			_unit addBackpack "B_Carryall_oli";
			_unit addMagazine "30Rnd_65x39_caseless_mag";
			_unit addWeapon "arifle_MXM_Black_F";
			_unit addMagazine "30Rnd_65x39_caseless_mag";
			_unit addMagazine "30Rnd_65x39_caseless_mag";
			_unit addMagazine "30Rnd_65x39_caseless_mag";
			_unit addPrimaryWeaponItem "optic_Hamr";
			_unit addMagazine "Titan_AA";
			_unit addWeapon "launch_I_Titan_F";
			_unit addMagazine "Titan_AA";
			_unit addMagazine "Titan_AA";
			_unit selectWeapon "launch_I_Titan_F";
		};
		// Rifleman
		default
		{
			if (_unit == leader _group) then
			{
				_unit addMagazine "30Rnd_65x39_caseless_mag";
				_unit addWeapon "arifle_MXM_Black_F";
				_unit addMagazine "30Rnd_65x39_caseless_mag";
				_unit addMagazine "30Rnd_65x39_caseless_mag";
				_unit addMagazine "30Rnd_65x39_caseless_mag";
				_unit addPrimaryWeaponItem "optic_Hamr";
				_unit addMagazine "HandGrenade";
				_unit setRank "SERGEANT";
			}
			else
			{
				_unit addMagazine "30Rnd_65x39_caseless_mag";
				_unit addWeapon "arifle_MXM_Black_F";
				_unit addMagazine "30Rnd_65x39_caseless_mag";
				_unit addMagazine "30Rnd_65x39_caseless_mag";
				_unit addMagazine "30Rnd_65x39_caseless_mag";
				_unit addPrimaryWeaponItem "optic_Hamr";
				_unit addMagazine "HandGrenade";
			};
		};
	};

	_unit addPrimaryWeaponItem "acc_flashlight";
	_unit enablegunlights "forceOn";

	_unit addRating 1e11;
	_unit addHeadgear "H_Cap_press";
	_unit addGoggles "G_Balaclava_blk";
	_unit spawn refillPrimaryAmmo;
	_unit call setMissionSkill;
	_unit addEventHandler ["Killed", server_playerDied];
};

[_group, _pos, "LandVehicle"] call defendArea;
