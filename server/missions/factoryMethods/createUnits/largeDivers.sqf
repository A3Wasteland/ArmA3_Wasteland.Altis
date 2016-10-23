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
removeAllWeapons _leader;
removeAllAssignedItems _leader;
removeUniform _leader;
removeVest _leader;
removeBackpack _leader;
removeHeadgear _leader;
removeGoggles _leader;
_leader addVest "V_RebreatherIA"; 
_leader addUniform "U_I_Wetsuit";
_leader addGoggles "G_Diving";
_leader addMagazine "20Rnd_556x45_UW_Mag";
_leader addWeapon "arifle_SDAR_F";
_leader addMagazine "20Rnd_556x45_UW_Mag";
_leader addMagazine "20Rnd_556x45_UW_Mag";
_leader addItem "NVGoggles";
_leader assignItem "NVGoggles";
_leader addItem "FirstAidKit";

// Rifleman
_man2 = _group createUnit ["C_man_polo_2_F", [(_pos select 0) + 10, _pos select 1, 0], [], 1, "Form"];
removeAllWeapons _man2;
removeAllAssignedItems _man2;
removeUniform _man2;
removeVest _man2;
removeBackpack _man2;
removeHeadgear _man2;
removeGoggles _man2;
_man2 addVest "V_RebreatherIA"; 
_man2 addUniform "U_I_Wetsuit";
_man2 addGoggles "G_Diving";
_man2 addMagazine "20Rnd_556x45_UW_Mag";
_man2 addWeapon "arifle_SDAR_F";
_man2 addMagazine "20Rnd_556x45_UW_Mag";
_man2 addMagazine "20Rnd_556x45_UW_Mag";
_man2 addItem "NVGoggles";
_man2 assignItem "NVGoggles";
_man2 addItem "FirstAidKit";

// Rifleman
_man3 = _group createUnit ["C_man_polo_3_F", [(_pos select 0) + 10, _pos select 1, 0], [], 1, "Form"];
removeAllWeapons _man3;
removeAllAssignedItems _man3;
removeUniform _man3;
removeVest _man3;
removeBackpack _man3;
removeHeadgear _man3;
removeGoggles _man3;
_man3 addVest "V_RebreatherIA"; 
_man3 addUniform "U_I_Wetsuit";
_man3 addGoggles "G_Diving";
_man3 addMagazine "20Rnd_556x45_UW_Mag";
_man3 addWeapon "arifle_SDAR_F";
_man3 addMagazine "20Rnd_556x45_UW_Mag";
_man3 addMagazine "20Rnd_556x45_UW_Mag";
_man3 addItem "NVGoggles";
_man3 assignItem "NVGoggles";
_man3 addItem "FirstAidKit";

// Rifleman
_man4 = _group createUnit ["C_man_polo_4_F", [(_pos select 0) + 10, _pos select 1, 0], [], 1, "Form"];
removeAllWeapons _man4;
removeAllAssignedItems _man4;
removeUniform _man4;
removeVest _man4;
removeBackpack _man4;
removeHeadgear _man4;
removeGoggles _man4;
_man4 addVest "V_RebreatherIA"; 
_man4 addUniform "U_I_Wetsuit";
_man4 addGoggles "G_Diving";
_man4 addMagazine "20Rnd_556x45_UW_Mag";
_man4 addWeapon "arifle_SDAR_F";
_man4 addMagazine "20Rnd_556x45_UW_Mag";
_man4 addMagazine "20Rnd_556x45_UW_Mag";
_man4 addItem "NVGoggles";
_man4 assignItem "NVGoggles";
_man4 addItem "FirstAidKit";

// Rifleman
_man5 = _group createUnit ["C_man_polo_5_F", [(_pos select 0) + 10, _pos select 1, 0], [], 1, "Form"];
removeAllWeapons _man5;
removeAllAssignedItems _man5;
removeUniform _man5;
removeVest _man5;
removeBackpack _man5;
removeHeadgear _man5;
removeGoggles _man5;
_man5 addVest "V_RebreatherIA"; 
_man5 addUniform "U_I_Wetsuit";
_man5 addGoggles "G_Diving";
_man5 addMagazine "20Rnd_556x45_UW_Mag";
_man5 addWeapon "arifle_SDAR_F";
_man5 addMagazine "20Rnd_556x45_UW_Mag";
_man5 addMagazine "20Rnd_556x45_UW_Mag";
_man5 addItem "NVGoggles";
_man5 assignItem "NVGoggles";
_man5 addItem "FirstAidKit";

// Rifleman
_man6 = _group createUnit ["C_man_polo_4_F", [(_pos select 0) + 10, _pos select 1, 0], [], 1, "Form"];
removeAllWeapons _man6;
removeAllAssignedItems _man6;
removeUniform _man6;
removeVest _man6;
removeBackpack _man6;
removeHeadgear _man6;
removeGoggles _man6;
_man6 addVest "V_RebreatherIA"; 
_man6 addUniform "U_I_Wetsuit";
_man6 addGoggles "G_Diving";
_man6 addMagazine "20Rnd_556x45_UW_Mag";
_man6 addWeapon "arifle_SDAR_F";
_man6 addMagazine "20Rnd_556x45_UW_Mag";
_man6 addMagazine "20Rnd_556x45_UW_Mag";
_man6 addItem "NVGoggles";
_man6 assignItem "NVGoggles";
_man6 addItem "FirstAidKit";

_leader = leader _group;

{
	_x spawn refillPrimaryAmmo;
	_x call setMissionSkill;
	_x addRating 9999999;
	_x addEventHandler ["Killed", server_playerDied];
} forEach units _group;

[_group, _pos, "Ship"] call defendArea;
