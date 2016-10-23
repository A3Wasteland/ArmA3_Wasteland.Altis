//	@file Version: 1.0
//	@file Name: smallGroup.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, AgentRev
//	@file Created: 08/12/2012 21:58
//	@file Args:

if (!isServer) exitWith {};

private ["_group","_pos","_leader","_man2","_man3","_man4","_man5","_man6"];

_group = _this select 0;
_pos = _this select 1;

// Sniper
_leader = _group createUnit ["C_man_polo_1_F", [(_pos select 0) + 10, _pos select 1, 0], [], 1, "Form"];
removeAllWeapons _leader;
removeAllAssignedItems _leader;
removeUniform _leader;
removeVest _leader;
removeBackpack _leader;
removeHeadgear _leader;
removeGoggles _leader;
_leader addUniform "U_I_Ghilliesuit";
_leader addVest "V_PlateCarrierIA1_dgtl";
_leader addMagazine "5Rnd_127x108_APDS_Mag";
_leader addWeapon "srifle_GM6_F";
_leader addPrimaryWeaponItem "optic_NVS";
_leader addMagazine "5Rnd_127x108_APDS_Mag";
_leader addMagazine "5Rnd_127x108_APDS_Mag";
_leader addMagazine "HandGrenade";

// Sniper
_man2 = _group createUnit ["C_man_polo_2_F", [(_pos select 0) - 30, _pos select 1, 0], [], 1, "Form"];
removeAllWeapons _man2;
removeAllAssignedItems _man2;
removeUniform _man2;
removeVest _man2;
removeBackpack _man2;
removeHeadgear _man2;
removeGoggles _man2;
_man2 addUniform "U_I_Ghilliesuit";
_man2 addVest "V_PlateCarrierIA1_dgtl";
_man2 addMagazine "5Rnd_127x108_APDS_Mag";
_man2 addWeapon "srifle_GM6_F";
_man2 addPrimaryWeaponItem "optic_LRPS";
_man2 addMagazine "5Rnd_127x108_APDS_Mag";
_man2 addMagazine "5Rnd_127x108_APDS_Mag";
_man2 addMagazine "HandGrenade";

// Sniper
_man3 = _group createUnit ["C_man_polo_2_F", [(_pos select 0) - 30, _pos select 1, 0], [], 1, "Form"];
removeAllWeapons _man3;
removeAllAssignedItems _man3;
removeUniform _man3;
removeVest _man3;
removeBackpack _man3;
removeHeadgear _man3;
removeGoggles _man3;
_man3 addUniform "U_I_Ghilliesuit";
_man3 addVest "V_PlateCarrierIA1_dgtl";
_man3 addMagazine "5Rnd_127x108_APDS_Mag";
_man3 addWeapon "srifle_GM6_F";
_man3 addPrimaryWeaponItem "optic_LRPS";
_man3 addMagazine "5Rnd_127x108_APDS_Mag";
_man3 addMagazine "5Rnd_127x108_APDS_Mag";
_man3 addMagazine "HandGrenade";

// Spotter
_man4 = _group createUnit ["C_man_polo_3_F", [_pos select 0, (_pos select 1) + 30, 0], [], 1, "Form"];
removeAllWeapons _man4;
removeAllAssignedItems _man4;
removeUniform _man4;
removeVest _man4;
removeBackpack _man4;
removeHeadgear _man4;
removeGoggles _man4;
_man4 addUniform "U_I_Ghilliesuit";
_man4 addVest "V_PlateCarrierIA1_dgtl";
_man4 addMagazine "20Rnd_762x51_Mag";
_man4 addWeapon "srifle_EBR_F";
_man4 addPrimaryWeaponItem "optic_SOS";
_man4 addMagazine "20Rnd_762x51_Mag";
_man4 addMagazine "20Rnd_762x51_Mag";
_man4 addMagazine "HandGrenade";
_man4 addItem "Rangefinder";

// Spotter
_man5 = _group createUnit ["C_man_polo_3_F", [_pos select 0, (_pos select 1) + 30, 0], [], 1, "Form"];
removeAllWeapons _man5;
removeAllAssignedItems _man5;
removeUniform _man5;
removeVest _man5;
removeBackpack _man5;
removeHeadgear _man5;
removeGoggles _man5;
_man5 addUniform "U_I_Ghilliesuit";
_man5 addVest "V_PlateCarrierIA1_dgtl";
_man5 addMagazine "20Rnd_762x51_Mag";
_man5 addWeapon "srifle_EBR_F";
_man5 addPrimaryWeaponItem "optic_Arco";
_man5 addMagazine "20Rnd_762x51_Mag";
_man5 addMagazine "20Rnd_762x51_Mag";
_man5 addMagazine "HandGrenade";
_man5 addItem "Rangefinder";

// Spotter
_man6 = _group createUnit ["C_man_polo_3_F", [_pos select 0, (_pos select 1) + 30, 0], [], 1, "Form"];
removeAllWeapons _man6;
removeAllAssignedItems _man6;
removeUniform _man6;
removeVest _man6;
removeBackpack _man6;
removeHeadgear _man6;
removeGoggles _man6;
_man6 addUniform "U_I_Ghilliesuit";
_man6 addVest "V_PlateCarrierIA1_dgtl";
_man6 addMagazine "20Rnd_762x51_Mag";
_man6 addWeapon "srifle_EBR_F";
_man6 addPrimaryWeaponItem "optic_SOS";
_man6 addMagazine "20Rnd_762x51_Mag";
_man6 addMagazine "20Rnd_762x51_Mag";
_man6 addMagazine "HandGrenade";
_man6 addItem "Rangefinder";

//AT Defender
_man7 = _group createUnit ["C_man_polo_3_F", [_pos select 0, (_pos select 1) + 30, 0], [], 1, "Form"];
removeAllWeapons _man7;
removeAllAssignedItems _man7;
removeUniform _man7;
removeVest _man7;
removeBackpack _man7;
removeHeadgear _man7;
removeGoggles _man7;
_man7 addUniform "U_I_Ghilliesuit";
_man7 addVest "V_HarnessOSpec_brn";
_man7 addBackpack "B_Carryall_oli";
_man7 addMagazine "10Rnd_762x54_Mag";
_man7 addWeapon "srifle_DMR_01_F";
_man7 addPrimaryWeaponItem "optic_Holosight";
_man7 addMagazine "10Rnd_762x54_Mag";
_man7 addMagazine "10Rnd_762x54_Mag";
_man7 addMagazine "RPG32_F";
_man7 addWeapon "launch_RPG32_F";
_man7 addMagazine "RPG32_F";
_man7 addMagazine "RPG32_F";
_man7 addMagazine "RPG32_F";
_man7 addMagazine "HandGrenade";
_man7 selectWeapon "launch_RPG32_F";

//AA Defender
_man8 = _group createUnit ["C_man_polo_3_F", [_pos select 0, (_pos select 1) + 30, 0], [], 1, "Form"];
removeAllWeapons _man8;
removeAllAssignedItems _man8;
removeUniform _man8;
removeVest _man8;
removeBackpack _man8;
removeHeadgear _man8;
removeGoggles _man8;
_man8 addUniform "U_I_Ghilliesuit";
_man8 addVest "V_HarnessOSpec_brn";
_man8 addBackpack "B_Carryall_oli";
_man8 addMagazine "10Rnd_762x54_Mag";
_man8 addWeapon "srifle_DMR_01_F";
_man8 addPrimaryWeaponItem "optic_DMS";
_man8 addMagazine "10Rnd_762x54_Mag";
_man8 addMagazine "10Rnd_762x54_Mag";
_man8 addMagazine "Titan_AA";
_man8 addWeapon "launch_I_Titan_F";
_man8 addMagazine "Titan_AA";
_man8 addMagazine "Titan_AA";
_man8 addMagazine "HandGrenade";
_man8 selectWeapon "launch_I_Titan_F";

_leader = leader _group;

{
	_x spawn refillPrimaryAmmo;
	_x call setMissionSkill;
	_x addRating 9999999;
	_x addEventHandler ["Killed", server_playerDied];
} forEach units _group;

[_pos] call addDefensiveMines;

[_group, _pos] call defendArea;
