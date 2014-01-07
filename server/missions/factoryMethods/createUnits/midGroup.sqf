//	@file Version: 1.0
//	@file Name: midGroup.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, AgentRev
//	@file Created: 08/12/2012 21:58
//	@file Args:

if (!isServer) exitWith {};

private ["_group", "_pos", "_leader", "_man2", "_man3", "_man4", "_man5", "_man6", "_man7", "_man8", "_man9", "_man10"];

_group = _this select 0;
_pos = _this select 1;

// Leader
_leader = _group createUnit ["C_man_polo_1_F", [(_pos select 0) + 10, _pos select 1, 0], [], 1, "Form"];
removeAllAssignedItems _leader;
_leader addUniform "U_B_CombatUniform_mcam";
_leader addVest "V_PlateCarrier1_rgr";
_leader addMagazine "30Rnd_556x45_Stanag";
_leader addWeapon "arifle_TRG21_F";
_leader addMagazine "30Rnd_556x45_Stanag";
_leader addMagazine "30Rnd_556x45_Stanag";
_leader addMagazine "RPG32_HE_F";
_leader addWeapon "launch_RPG32_F";
_leader addMagazine "RPG32_HE_F";

// Rifleman
_man2 = _group createUnit ["C_man_polo_2_F", [(_pos select 0) - 30, _pos select 1, 0], [], 1, "Form"];
removeAllAssignedItems _man2;
_man2 addUniform "U_B_CombatUniform_mcam_vest";
_man2 addVest "V_PlateCarrier1_rgr";
_man2 addMagazine "30Rnd_556x45_Stanag";
_man2 addWeapon "arifle_TRG20_F";
_man2 addMagazine "30Rnd_556x45_Stanag";
_man2 addMagazine "30Rnd_556x45_Stanag";

// Rifleman
_man3 = _group createUnit ["C_man_polo_3_F", [_pos select 0, (_pos select 1) + 30, 0], [], 1, "Form"];
removeAllAssignedItems _man3;
_man3 addUniform "U_B_CombatUniform_mcam_vest";
_man3 addVest "V_PlateCarrier1_rgr";
_man3 addMagazine "30Rnd_556x45_Stanag";
_man3 addWeapon "arifle_TRG20_F";
_man3 addMagazine "30Rnd_556x45_Stanag";
_man3 addMagazine "30Rnd_556x45_Stanag";

// Rifleman
_man4 = _group createUnit ["C_man_polo_4_F", [_pos select 0, (_pos select 1) + 40, 0], [], 1, "Form"];
removeAllAssignedItems _man4;
_man4 addUniform "U_B_CombatUniform_mcam_vest";
_man4 addVest "V_PlateCarrier1_rgr";
_man4 addMagazine "30Rnd_556x45_Stanag";
_man4 addWeapon "arifle_TRG20_F";
_man4 addMagazine "30Rnd_556x45_Stanag";
_man4 addMagazine "30Rnd_556x45_Stanag";

// Rifleman
_man5 = _group createUnit ["C_man_polo_5_F", [_pos select 0, (_pos select 1) + 40, 0], [], 1, "Form"];
removeAllAssignedItems _man5;
_man5 addUniform "U_B_CombatUniform_mcam_vest";
_man5 addVest "V_PlateCarrier1_rgr";
_man5 addMagazine "30Rnd_556x45_Stanag";
_man5 addWeapon "arifle_TRG20_F";
_man5 addMagazine "30Rnd_556x45_Stanag";
_man5 addMagazine "30Rnd_556x45_Stanag";

// Rifleman
_man6 = _group createUnit ["C_man_polo_4_F", [_pos select 0, (_pos select 1) - 30, 0], [], 1, "Form"];
removeAllAssignedItems _man6;
_man6 addUniform "U_B_CombatUniform_mcam_vest";
_man6 addVest "V_PlateCarrier1_rgr";
_man6 addMagazine "30Rnd_556x45_Stanag";
_man6 addWeapon "arifle_TRG20_F";
_man6 addMagazine "30Rnd_556x45_Stanag";
_man6 addMagazine "30Rnd_556x45_Stanag";

// Grenadier
_man7 = _group createUnit ["C_man_polo_3_F", [_pos select 0, (_pos select 1) - 40, 0], [], 1, "Form"];
removeAllAssignedItems _man7;
_man7 addUniform "U_B_CombatUniform_mcam_tshirt";
_man7 addVest "V_PlateCarrier1_rgr";
_man7 addMagazine "30Rnd_556x45_Stanag";
_man7 addWeapon "arifle_TRG21_GL_F";
_man7 addMagazine "30Rnd_556x45_Stanag";
_man7 addMagazine "30Rnd_556x45_Stanag";
_man7 addMagazine "1Rnd_HE_Grenade_shell";
_man7 addMagazine "1Rnd_HE_Grenade_shell";
_man7 addMagazine "1Rnd_HE_Grenade_shell";

_ranman = floor (random 100);

if (_ranman < 75) then {
    //Support
    _man8 = _group createunit ["C_man_polo_2_F", [(_pos select 0) - 30, (_pos select 1) - 30, 0], [], 0.5, "Form"];
    removeAllAssignedItems _man8;
    _man8 addUniform "U_B_CombatUniform_mcam_tshirt";
    _man8 addVest "V_PlateCarrier1_rgr";
    _man8 addWeapon "arifle_MK20C_F";
    _man8 addMagazine "20Rnd_762x51_Mag";
    _man8 addMagazine "20Rnd_762x51_Mag";
    _man8 addMagazine "20Rnd_762x51_Mag";
};


if (_ranman < 50) then {
    //Support
    _man9 = _group createunit ["C_man_polo_2_F", [(_pos select 0) - 30, (_pos select 1) + 30, 0], [], 0.5, "Form"];
    removeAllAssignedItems _man9;
    _man9 addUniform "U_B_CombatUniform_mcam_tshirt";
    _man9 addVest "V_PlateCarrier1_rgr";
    _man9 addMagazine "30Rnd_556x45_Stanag";
    _man9 addMagazine "30Rnd_556x45_Stanag";
    _man9 addMagazine "30Rnd_556x45_Stanag";
    _man9 addMagazine "30Rnd_556x45_Stanag";
    _man9 addWeapon "arifle_MK20C_F";
};

if (_ranman < 25) then {
    //Support
    _man10 = _group createunit ["C_man_polo_2_F", [(_pos select 0) + 30, (_pos select 1) + 30, 0], [], 0.5, "Form"];
    removeAllAssignedItems _man10;
    _man10 addUniform "U_B_CombatUniform_mcam_tshirt";
    _man10 addVest "V_PlateCarrier1_rgr";
    _man10 addMagazine "30Rnd_556x45_Stanag";
    _man10 addMagazine "30Rnd_556x45_Stanag";
    _man10 addMagazine "30Rnd_556x45_Stanag";
    _man10 addMagazine "30Rnd_556x45_Stanag";
    _man10 addWeapon "arifle_MK20C_F";
};
_leader = leader _group;

{
	_x spawn refillPrimaryAmmo;
	_x spawn addMilCap;
	_x call setMissionSkill;
	_x addRating 9999999;
	_x addEventHandler ["Killed", {_this call server_playerDied; (_this select 1) call removeNegativeScore}];
} forEach units _group;

[_group, _pos] call defendArea;
