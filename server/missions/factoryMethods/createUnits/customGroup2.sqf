// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: customGroup2.sqf
//	@file Author: AgentRev, JoSchaap

if (!isServer) exitWith {};

private ["_group", "_pos", "_nbUnits", "_unitTypes", "_uPos", "_unit"];

_group = _this select 0;
_pos = _this select 1;
_nbUnits = [_this, 2, 7, [0]] call BIS_fnc_param;
_radius = [_this, 3, 10, [0]] call BIS_fnc_param;

_unitTypes =
[
	"C_man_hunter_1_F","C_man_p_beggar_F","C_man_p_beggar_F_afro",
	"C_man_p_fugitive_F","C_man_p_shorts_1_F","C_man_polo_1_F",
	"C_man_polo_2_F","C_man_polo_3_F","C_man_polo_4_F",
	"C_man_p_beggar_F","C_man_p_beggar_F_afro",
	"C_man_p_fugitive_F","C_journalist_F","C_Orestes",
	"C_man_polo_5_F","C_man_polo_6_F","C_man_shorts_1_F",
	"C_man_shorts_2_F","C_man_shorts_3_F","C_man_shorts_4_F",
	"C_man_w_worker_F","C_man_p_beggar_F","C_man_p_beggar_F_afro",
	"C_man_p_fugitive_F"
];

for "_i" from 1 to _nbUnits do
{
	_uPos = _pos vectorAdd ([[random _radius, 0, 0], random 360] call BIS_fnc_rotateVector2D);
	_unit = _group createUnit [_unitTypes call BIS_fnc_selectRandom, _uPos, [], 0, "Form"];
	_unit setPosATL _uPos;

	removeAllWeapons _unit;
	removeAllAssignedItems _unit;
	//removeUniform _unit;
	removeVest _unit;
	removeBackpack _unit;
	removeHeadgear _unit;
	removeGoggles _unit;

	_unit addVest "V_PlateCarrier1_rgr";
	_unit addItem "FirstAidKit";

	switch (true) do
	{
		// Grenadier every 3 units
		case (_i % 3 == 0):
		{
			_unit addMagazine "1Rnd_HE_Grenade_shell";
			_unit addMagazine "30Rnd_65x39_caseless_mag";
			_unit addWeapon "arifle_MX_GL_F";
			_unit addMagazine "30Rnd_65x39_caseless_mag";
			_unit addMagazine "30Rnd_65x39_caseless_mag";
			_unit addMagazine "1Rnd_HE_Grenade_shell";
			_unit addMagazine "1Rnd_HE_Grenade_shell";
		};
		// RPG every 7 units, starting from second one
		case ((_i + 5) % 7 == 0):
		{
			_unit addMagazine "30Rnd_65x39_caseless_green_mag_Tracer";
			_unit addMagazine "30Rnd_65x39_caseless_green_mag_Tracer";
			_unit addMagazine "30Rnd_65x39_caseless_green_mag_Tracer";
			_unit addMagazine "30Rnd_65x39_caseless_green_mag_Tracer";
			_unit addWeapon "arifle_Katiba_ARCO_F";
			_unit addBackpack "B_Carryall_oli";
			_unit addMagazine "Titan_AT";
			_unit addWeapon "launch_Titan_short_F";
			_unit addMagazine "Titan_AT";
		};
		// Rifleman
		default
		{
			if (_unit == leader _group) then
			{
				_unit addBackpack "B_AssaultPack_rgr";
				_unit addMagazine "30Rnd_45ACP_Mag_SMG_01";
				_unit addMagazine "30Rnd_45ACP_Mag_SMG_01";
				_unit addMagazine "30Rnd_45ACP_Mag_SMG_01";
				_unit addMagazine "30Rnd_45ACP_Mag_SMG_01";
				_unit addWeapon "SMG_01_Holo_pointer_snds_F";
				_unit addItem "ItemGps";
				_unit assignItem "ItemGps";
				_unit addItem "ItemCompass";
				_unit assignItem "ItemCompass";
				_unit setRank "SERGEANT";
			}
			else
			{
				_unit addMagazine "30Rnd_556x45_Stanag_Tracer_Red";
				_unit addWeapon "arifle_TRG20_Holo_F";
				_unit addMagazine "30Rnd_556x45_Stanag_Tracer_Red";
				_unit addMagazine "30Rnd_556x45_Stanag_Tracer_Red";
				_unit addMagazine "30Rnd_556x45_Stanag_Tracer_Red";
			};
		};
	};

_unit addPrimaryWeaponItem "acc_flashlight";
_unit enablegunlights "forceOn";					//set to "forceOn" to force use of lights (during day too default = AUTO)
	
	_unit addRating 1e11;
	_unit spawn refillPrimaryAmmo;
	_unit call setMissionSkill;
	_unit addEventHandler ["Killed", server_playerDied];
};
