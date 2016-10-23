// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: customGroup.sqf
//	@file Author: AgentRev, micovery

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

grenadier_loadout =  {
  private["_unit"];
  _unit = _this;
  _unit addUniform "U_IG_Guerilla1_1";
  _unit addMagazine "1Rnd_HE_Grenade_shell";
  _unit addMagazine "30Rnd_65x39_caseless_mag";
  _unit addWeapon "arifle_MX_GL_F";
  _unit addMagazine "30Rnd_65x39_caseless_mag";
  _unit addMagazine "30Rnd_65x39_caseless_mag";
  _unit addMagazine "1Rnd_HE_Grenade_shell";
  _unit addMagazine "1Rnd_HE_Grenade_shell";
  _unit addItem "NVGoggles";
  _unit assignItem "NVGoggles";
};

support_loadout = {
  private["_unit"];
  _unit = _this;

  _unit addUniform "U_IG_Guerilla1_1";
  _unit addBackpack "B_Carryall_oli";
  _unit addMagazine "200Rnd_65x39_cased_Box";
  _unit addMagazine "200Rnd_65x39_cased_Box";
  _unit addWeapon "LMG_Mk200_F";
  _unit addPrimaryWeaponItem "optic_MRCO";
  _unit addUniform "U_IG_Guerilla1_1";
  _unit addMagazine "200Rnd_65x39_cased_Box";
  _unit addItem "FirstAidKit";
  _unit addItem "NVGoggles";
  _unit assignItem "NVGoggles";
};

sniper_loadout = {
  private["_unit"];
  _unit = _this;

  _unit addUniform "U_I_GhillieSuit";
  _unit addBackpack "B_AssaultPack_rgr";
  _unit addMagazine "30Rnd_65x39_caseless_mag";
  _unit addMagazine "30Rnd_65x39_caseless_mag";
  _unit addMagazine "30Rnd_65x39_caseless_mag";
  _unit addMagazine "30Rnd_65x39_caseless_mag";
  _unit addWeapon "arifle_MXM_F";
  _unit addPrimaryWeaponItem "optic_Hamr";
  _unit addPrimaryWeaponItem "acc_pointer_IR";
  _unit addPrimaryWeaponItem "muzzle_snds_H";
  _unit addMagazine "30Rnd_65x39_caseless_mag";
  _unit addItem "Rangefinder";
  _unit assignItem "Rangefinder";
  _unit addItem "ItemGps";
  _unit assignItem "ItemGps";
  _unit addItem "ItemCompass";
  _unit assignItem "ItemCompass";
  _unit addItem "NVGoggles";
  _unit assignItem "NVGoggles";
};

aa_loadout = {
  private["_unit"];
  _unit = _this;

  _unit addUniform "U_IG_Guerilla1_1";
  _unit addMagazine "30Rnd_9x21_Mag";
  _unit addMagazine "30Rnd_9x21_Mag";
  _unit addMagazine "30Rnd_9x21_Mag";
  _unit addMagazine "30Rnd_9x21_Mag";
  _unit addWeapon "SMG_02_F";
  _unit addPrimaryWeaponItem "optic_Arco";
  _unit addPrimaryWeaponItem "acc_pointer_IR";
  _unit addBackpack "B_Carryall_oli";
  _unit addMagazine "Titan_AA";
  _unit addWeapon "launch_Titan_F";
  _unit addMagazine "Titan_AA";
  _unit addItem "NVGoggles";
  _unit assignItem "NVGoggles";
};

at_loadout = {
  private["_unit"];
  _unit = _this;

  _unit addUniform "U_IG_Guerilla2_1";
  _unit addMagazine "30Rnd_45ACP_Mag_SMG_01";
  _unit addMagazine "30Rnd_45ACP_Mag_SMG_01";
  _unit addMagazine "30Rnd_45ACP_Mag_SMG_01";
  _unit addMagazine "30Rnd_45ACP_Mag_SMG_01";
  _unit addWeapon "SMG_01_F";
  _unit addPrimaryWeaponItem "optic_Holosight_smg";
  _unit addPrimaryWeaponItem "muzzle_snds_acp";
  _unit addBackpack "B_Carryall_oli";
  _unit addMagazine "NLAW_F";
  _unit addWeapon "launch_NLAW_F";
  _unit addMagazine "NLAW_F";
  _unit addMagazine "NLAW_F";
  _unit addItem "NVGoggles";
  _unit assignItem "NVGoggles";
};

leader_loadout = {
  private["_unit"];
  _unit = _this;

  _unit addUniform "U_IG_leader";
  _unit addMagazine "30Rnd_65x39_caseless_green_mag_Tracer";
  _unit addMagazine "30Rnd_65x39_caseless_green_mag_Tracer";
  _unit addMagazine "30Rnd_65x39_caseless_green_mag_Tracer";
  _unit addMagazine "30Rnd_65x39_caseless_green_mag_Tracer";
  _unit addWeapon "arifle_Katiba_F";
  _unit addPrimaryWeaponItem "optic_Arco";
  _unit addPrimaryWeaponItem "acc_pointer_IR";
  _unit addBackpack "B_Carryall_oli";
  _unit addMagazine "NLAW_F";
  _unit addWeapon "launch_NLAW_F";
  _unit addMagazine "NLAW_F";
  _unit addItem "ItemGps";
  _unit assignItem "ItemGps";
  _unit addItem "ItemCompass";
  _unit assignItem "ItemCompass";
  _unit addItem "NVGoggles";
  _unit assignItem "NVGoggles";
};

rifleman_loadout = {
  private["_unit"];
  _unit = _this;

  _unit addUniform "U_IG_Guerilla2_3";
  _unit addMagazine "30Rnd_65x39_caseless_mag_Tracer";
  _unit addBackpack "B_AssaultPack_rgr";
  _unit addMagazine "30Rnd_65x39_caseless_mag_Tracer";
  _unit addMagazine "30Rnd_65x39_caseless_mag_Tracer";
  _unit addWeapon "arifle_MX_F";
  _unit addPrimaryWeaponItem "optic_Aco";
  _unit addMagazine "30Rnd_65x39_caseless_mag_Tracer";
  _unit addPrimaryWeaponItem "acc_flashlight";
  _unit enablegunlights "forceOn";
};

weighted_list =
[
  [0.5, sniper_loadout],
  [1, aa_loadout],
  [1.3, at_loadout],
  [1.1, support_loadout],
  [0.8, rifleman_loadout],
  [1, grenadier_loadout]
];

get_weighted_loadout = {
  private["_items"];
  _items = weighted_list;

  //calculate the total weight
  private["_totalSum", "_weight"];
  _totalSum = 0;
  {
    _weight = _x select 0;
    _totalSum = _weight + _totalSum;
  } forEach _items;

  //pick at random from the distribution
  private["_index", "_i", "_item", "_sum"];
  _index = random _totalSum;
  _sum = 0;
  _i = 0;

  while {_sum < _index} do {
    _item = _items select _i;
    _weight = _item select 0;
    _sum = _sum + _weight;
    _i = _i + 1;
  };

  ((_items select (_i - 1)) select 1)
};

for "_i" from 1 to _nbUnits do
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

  _unit addVest "V_PlateCarrier1_rgr";
  _unit addItem "FirstAidKit";

  if (_unit == leader _group) then {
    _unit call leader_loadout;
    _unit setRank "SERGEANT";
  }
  else {
    private["_loadout"];
    _loadout = call get_weighted_loadout;
    _unit call _loadout;
  };

  _unit addRating 1e11;
  _unit spawn addMilCap;
  _unit spawn refillPrimaryAmmo;
  _unit call setMissionSkill;
  _unit addEventHandler ["Killed", server_playerDied];
};

[_pos] call addDefensiveMines;

[_group, _pos] call defendArea;
