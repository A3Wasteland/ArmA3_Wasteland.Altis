// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: largeDivers.sqf
//	@file Author: [GoT] JoSchaap, AgentRev

if (!isServer) exitWith {};

private ["_group", "_pos", "_leader", "_man2", "_man3", "_man4", "_man5", "_man6"];

_group = _this select 0;
_pos = _this select 1;

// Rifleman
_leader = _group createUnit ["C_man_polo_1_F", [(_pos select 0) + 10, _pos select 1, 0], [], 1, "Form"];
removeAllAssignedItems _leader;
_leader addVest "V_RebreatherB";
_leader addUniform "U_B_Wetsuit";
_leader addGoggles "G_Diving";
_leader addMagazine "20Rnd_556x45_UW_Mag";
_leader addWeapon "arifle_SDAR_F";
_leader addMagazine "20Rnd_556x45_UW_Mag";
_leader addMagazine "20Rnd_556x45_UW_Mag";

// Rifleman
_man2 = _group createUnit ["C_man_polo_2_F", [(_pos select 0) + 10, _pos select 1, 0], [], 1, "Form"];
removeAllAssignedItems _man2;
_man2 addUniform "U_B_Wetsuit";
_man2 addVest "V_RebreatherB";
_man2 addGoggles "G_Diving";
_man2 addMagazine "20Rnd_556x45_UW_Mag";
_man2 addWeapon "arifle_SDAR_F";
_man2 addMagazine "20Rnd_556x45_UW_Mag";
_man2 addMagazine "20Rnd_556x45_UW_Mag";

// Rifleman
_man3 = _group createUnit ["C_man_polo_3_F", [(_pos select 0) + 10, _pos select 1, 0], [], 1, "Form"];
removeAllAssignedItems _man3;
_man3 addUniform "U_B_Wetsuit";
_man3 addVest "V_RebreatherB";
_man3 addGoggles "G_Diving";
_man3 addMagazine "20Rnd_556x45_UW_Mag";
_man3 addWeapon "arifle_SDAR_F";
_man3 addMagazine "20Rnd_556x45_UW_Mag";
_man3 addMagazine "20Rnd_556x45_UW_Mag";

// Rifleman
_man4 = _group createUnit ["C_man_polo_4_F", [(_pos select 0) + 10, _pos select 1, 0], [], 1, "Form"];
removeAllAssignedItems _man4;
_man4 addUniform "U_B_Wetsuit";
_man4 addVest "V_RebreatherB";
_man4 addGoggles "G_Diving";
_man4 addMagazine "20Rnd_556x45_UW_Mag";
_man4 addWeapon "arifle_SDAR_F";
_man4 addMagazine "20Rnd_556x45_UW_Mag";
_man4 addMagazine "20Rnd_556x45_UW_Mag";

// Rifleman
_man5 = _group createUnit ["C_man_polo_5_F", [(_pos select 0) + 10, _pos select 1, 0], [], 1, "Form"];
removeAllAssignedItems _man5;
_man5 addUniform "U_B_Wetsuit";
_man5 addVest "V_RebreatherB";
_man5 addGoggles "G_Diving";
_man5 addMagazine "20Rnd_556x45_UW_Mag";
_man5 addWeapon "arifle_SDAR_F";
_man5 addMagazine "20Rnd_556x45_UW_Mag";
_man5 addMagazine "20Rnd_556x45_UW_Mag";

// Rifleman
_man6 = _group createUnit ["C_man_polo_4_F", [(_pos select 0) + 10, _pos select 1, 0], [], 1, "Form"];
removeAllAssignedItems _man6;
_man6 addUniform "U_B_Wetsuit";
_man6 addVest "V_RebreatherB";
_man6 addGoggles "G_Diving";
_man6 addMagazine "20Rnd_556x45_UW_Mag";
_man6 addWeapon "arifle_SDAR_F";
_man6 addMagazine "20Rnd_556x45_UW_Mag";
_man6 addMagazine "20Rnd_556x45_UW_Mag";

_leader = leader _group;

{
	_x spawn refillPrimaryAmmo;
	_x call setMissionSkill;
	_x addRating 9999999;
	_x addEventHandler ["Killed", server_playerDied];
} forEach units _group;

[_group, _pos, "Ship"] call defendArea;
