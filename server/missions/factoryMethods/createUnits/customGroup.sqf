// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: customGroup.sqf
//	@file Author: AgentRev, micovery

if (!isServer) exitWith {};

private ["_group", "_pos", "_nbUnits", "_unitTypes", "_uPos", "_unit"];

_group = _this select 0;
_pos = _this select 1;
_nbUnits = [_this, 2, 7, [0]] call BIS_fnc_param;
_radius = [_this, 3, 10, [0]] call BIS_fnc_param;

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
};
  
support_loadout = {
  private["_unit"];
  _unit = _this;

  _unit addUniform "U_IG_Guerilla1_1";
  _unit addBackpack "B_Carryall_oli";
  _unit addMagazine "200Rnd_65x39_cased_Box";
  _unit addMagazine "200Rnd_65x39_cased_Box";
  _unit addWeapon "LMG_Mk200_MRCO_F";
  _unit addUniform "U_IG_Guerilla1_1";
  _unit addMagazine "200Rnd_65x39_cased_Box";
  _unit addItem "FirstAidKit";
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
  _unit addWeapon "arifle_MXM_Hamr_pointer_F";
  _unit addPrimaryWeaponItem "muzzle_snds_H";
  _unit addMagazine "30Rnd_65x39_caseless_mag";
  _unit addItem "Rangefinder";
  _unit assignItem "Rangefinder";
  _unit addItem "ItemGps";
  _unit assignItem "ItemGps";
  _unit addItem "ItemCompass";
  _unit assignItem "ItemCompass";  
};

aa_loadout = {
  private["_unit"];
  _unit = _this;
  
  _unit addUniform "U_IG_Guerilla1_1";
  _unit addMagazine "30Rnd_9x21_Mag";
  _unit addMagazine "30Rnd_9x21_Mag";
  _unit addMagazine "30Rnd_9x21_Mag";
  _unit addMagazine "30Rnd_9x21_Mag";
  _unit addWeapon "SMG_02_ARCO_pointg_F";
  _unit addBackpack "B_Carryall_oli";
  _unit addMagazine "Titan_AA";
  _unit addWeapon "launch_Titan_F";
  _unit addMagazine "Titan_AA";
};

at_loadout = {
  private["_unit"];
  _unit = _this;

  _unit addUniform "U_IG_Guerilla2_1";
  _unit addMagazine "30Rnd_45ACP_Mag_SMG_01";
  _unit addMagazine "30Rnd_45ACP_Mag_SMG_01";
  _unit addMagazine "30Rnd_45ACP_Mag_SMG_01";
  _unit addMagazine "30Rnd_45ACP_Mag_SMG_01";
  _unit addWeapon "SMG_01_Holo_pointer_snds_F";
  _unit addBackpack "B_Carryall_oli";
  _unit addMagazine "Titan_AT";
  _unit addWeapon "launch_Titan_short_F";
  _unit addMagazine "Titan_AT";
  _unit addMagazine "Titan_AT";
};

leader_loadout = {
  private["_unit"];
  _unit = _this;
  
  _unit addUniform "U_IG_leader";
  _unit addMagazine "30Rnd_65x39_caseless_green_mag_Tracer";
  _unit addMagazine "30Rnd_65x39_caseless_green_mag_Tracer";
  _unit addMagazine "30Rnd_65x39_caseless_green_mag_Tracer";
  _unit addMagazine "30Rnd_65x39_caseless_green_mag_Tracer";
  _unit addWeapon "arifle_Katiba_ARCO_pointer_F";
  _unit addBackpack "B_Carryall_oli";
  _unit addMagazine "Titan_AT";
  _unit addWeapon "launch_Titan_short_F";
  _unit addMagazine "Titan_AT";
  _unit addItem "ItemGps";
  _unit assignItem "ItemGps";
  _unit addItem "ItemCompass";
  _unit assignItem "ItemCompass";
};

rifleman_loadout = {
  private["_unit"];
  _unit = _this;
  
  _unit addUniform "U_IG_Guerilla2_3";
  _unit addMagazine "20Rnd_762x51_Mag";
  _unit addMagazine "20Rnd_762x51_Mag";
  _unit addBackpack "B_AssaultPack_rgr";
  _unit addMagazine "20Rnd_762x51_Mag";
  _unit addMagazine "20Rnd_762x51_Mag";
  _unit addWeapon "srifle_EBR_ARCO_pointer_snds_F";
  _unit addMagazine "20Rnd_762x51_Mag";
};

weighted_list = 
[
  [1, sniper_loadout],
  [1.1, aa_loadout],
  [1, at_loadout],
  [1.2, support_loadout],
  [1, rifleman_loadout],
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
  _unit addItem "NVGoggles";
  _unit assignItem "NVGoggles";
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

[_group, _pos] call defendArea;
