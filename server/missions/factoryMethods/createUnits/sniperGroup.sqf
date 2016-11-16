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
_leader addUniform "U_I_Ghilliesuit";
_leader addVest "V_PlateCarrierIA1_dgtl";
_leader addMagazine "5Rnd_127x108_APDS_Mag";
_leader addWeapon "srifle_GM6_SOS_F";
_leader addPrimaryWeaponItem "optic_Nightstalker";
_leader addMagazine "5Rnd_127x108_APDS_Mag";
_leader addMagazine "5Rnd_127x108_APDS_Mag";

// Sniper
_man2 = _group createUnit ["C_man_polo_2_F", [(_pos select 0) - 30, _pos select 1, 0], [], 1, "Form"];
_man2 addUniform "U_I_Ghilliesuit";
_man2 addVest "V_PlateCarrierIA1_dgtl";
_man2 addMagazine "5Rnd_127x108_APDS_Mag";
_man2 addWeapon "srifle_GM6_SOS_F";
_man2 addMagazine "5Rnd_127x108_APDS_Mag";
_man2 addMagazine "5Rnd_127x108_APDS_Mag";

// Sniper
_man3 = _group createUnit ["C_man_polo_2_F", [(_pos select 0) - 30, _pos select 1, 0], [], 1, "Form"];
_man3 addUniform "U_I_Ghilliesuit";
_man3 addVest "V_PlateCarrierIA1_dgtl";
_man3 addMagazine "5Rnd_127x108_APDS_Mag";
_man3 addWeapon "srifle_GM6_SOS_F";
_man3 addMagazine "5Rnd_127x108_APDS_Mag";
_man3 addMagazine "5Rnd_127x108_APDS_Mag";

// Spotter
_man4 = _group createUnit ["C_man_polo_3_F", [_pos select 0, (_pos select 1) + 30, 0], [], 1, "Form"];
_man4 addUniform "U_I_Ghilliesuit";
_man4 addVest "V_PlateCarrierIA1_dgtl";
_man4 addMagazine "20Rnd_762x51_Mag";
_man4 addWeapon "srifle_EBR_SOS_F";
_man4 addMagazine "20Rnd_762x51_Mag";
_man4 addMagazine "20Rnd_762x51_Mag";
_man4 addItem "Rangefinder";

// Spotter
_man5 = _group createUnit ["C_man_polo_3_F", [_pos select 0, (_pos select 1) + 30, 0], [], 1, "Form"];
_man5 addUniform "U_I_Ghilliesuit";
_man5 addVest "V_PlateCarrierIA1_dgtl";
_man5 addMagazine "20Rnd_762x51_Mag";
_man5 addWeapon "srifle_EBR_SOS_F";
_man5 addMagazine "20Rnd_762x51_Mag";
_man5 addMagazine "20Rnd_762x51_Mag";
_man5 addItem "Rangefinder";

// Spotter
_man6 = _group createUnit ["C_man_polo_3_F", [_pos select 0, (_pos select 1) + 30, 0], [], 1, "Form"];
_man6 addUniform "U_I_Ghilliesuit";
_man6 addVest "V_PlateCarrierIA1_dgtl";
_man6 addMagazine "20Rnd_762x51_Mag";
_man6 addWeapon "srifle_EBR_SOS_F";
_man6 addMagazine "20Rnd_762x51_Mag";
_man6 addMagazine "20Rnd_762x51_Mag";
_man6 addItem "Rangefinder";

//AT Defender
_man7 = _group createUnit ["C_man_polo_3_F", [_pos select 0, (_pos select 1) + 30, 0], [], 1, "Form"];
_man7 addUniform "U_I_Ghilliesuit";
_man7 addVest "V_HarnessOSpec_brn";
_man7 addBackpack "B_Carryall_oli";
_man7 addMagazine "10Rnd_762x51_Mag";
_man7 addWeapon "srifle_DMR_01_F";
_man7 addPrimaryWeaponItem "optic_Holosight";
_man7 addMagazine "10Rnd_762x51_Mag";
_man7 addMagazine "10Rnd_762x51_Mag";
_man7 addMagazine "RPG32_F";
_man7 addWeapon "launch_RPG32_F";
_man7 addMagazine "RPG32_F";
_man7 addMagazine "RPG32_F";
_man7 addMagazine "RPG32_F";
_man7 selectWeapon "launch_RPG32_F";

//AA Defender
_man8 = _group createUnit ["C_man_polo_3_F", [_pos select 0, (_pos select 1) + 30, 0], [], 1, "Form"];
_man8 addUniform "U_I_Ghilliesuit";
_man8 addVest "V_HarnessOSpec_brn";
_man8 addBackpack "B_Carryall_oli";
_man8 addMagazine "10Rnd_762x51_Mag";
_man8 addWeapon "srifle_DMR_01_F";
_man8 addPrimaryWeaponItem "optic_Holosight";
_man8 addMagazine "10Rnd_762x51_Mag";
_man8 addMagazine "10Rnd_762x51_Mag";
_man8 addMagazine "Titan_AA";
_man8 addWeapon "launch_I_Titan_F";
_man8 addMagazine "Titan_AA";
_man8 addMagazine "Titan_AA";
_man8 selectWeapon "launch_I_Titan_F";

sleep 0.1; // Without this delay, headgear doesn't get removed properly

_leader = leader _group;

{
	_x call setMissionSkill;
	_x allowFleeing 0;
	_x addRating 9999999;
	_x addEventHandler ["Killed", server_playerDied];
} forEach units _group;

[_group, _pos] call defendArea;
