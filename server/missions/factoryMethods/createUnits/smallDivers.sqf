// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: largeDivers.sqf
//	@file Author: [GoT] JoSchaap, AgentRev

if (!isServer) exitWith {};

private ["_group", "_pos", "_leader", "_man2", "_man3"];

_group = _this select 0;
_pos = _this select 1;

// Leader
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

_leader = leader _group;

{
	_x spawn refillPrimaryAmmo;
	_x call setMissionSkill;
	_x addRating 9999999;
	_x addEventHandler ["Killed", server_playerDied];
} forEach units _group;

[_group, _pos, "Ship"] call defendArea;
