//	@file Version: 1.0
//	@file Name: smallGroup.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, AgentRev
//	@file Created: 08/12/2012 21:58
//	@file Args:

if (!isServer) exitWith {};

private ["_group", "_pos", "_leader", "_man2", "_man3", "_man4", "_man5", "_man6"];

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
_man4 = _group createUnit ["C_man_polo_4_F", [_pos select 0, (_pos select 1) - 30, 0], [], 1, "Form"];
removeAllAssignedItems _man4;
_man4 addUniform "U_B_CombatUniform_mcam_vest";
_man4 addVest "V_PlateCarrier1_rgr";
_man4 addMagazine "30Rnd_556x45_Stanag";
_man4 addWeapon "arifle_TRG20_F";
_man4 addMagazine "30Rnd_556x45_Stanag";
_man4 addMagazine "30Rnd_556x45_Stanag";

_ranman = floor (random 100);

if (_ranman < 67) then {
    //Support
    _man5 = _group createunit ["C_man_polo_2_F", [(_pos select 0) - 30, (_pos select 1) - 30, 0], [], 0.5, "Form"];
    removeAllAssignedItems _man5;
    _man5 addUniform "U_B_CombatUniform_mcam_vest";
    _man5 addVest "V_PlateCarrier1_rgr";
    _man5 addMagazine "20Rnd_762x51_Mag";
    _man5 addMagazine "20Rnd_762x51_Mag";
    _man5 addWeapon "srifle_EBR_F";
};


if (_ranman < 33) then {
    //Support
    _man6 = _group createunit ["C_man_polo_2_F", [(_pos select 0) - 30, (_pos select 1) + 30, 0], [], 0.5, "Form"];
    removeAllAssignedItems _man6;
    _man6 addUniform "U_B_CombatUniform_mcam_vest";
    _man6 addVest "V_PlateCarrier1_rgr";
    _man6 addMagazine "30Rnd_556x45_Stanag";
    _man6 addWeapon "arifle_TRG20_F";
    _man6 addMagazine "30Rnd_556x45_Stanag";
    _man6 addMagazine "30Rnd_556x45_Stanag";
};


_leader = leader _group;

{
	_x spawn refillPrimaryAmmo;
	_x spawn addMilCap;
	_x call setMissionSkill;
	_x addRating 9999999;
	_x addEventHandler ["Killed", {_this call server_playerDied; (_this select 1) call removeNegativeScore}];
} forEach units _group;

_unitsAlivesp = ({alive _x} count units _group);
diag_log format["WASTELAND SERVER - Mission spawned: %1 enemy", _unitsAlivesp];

[_group, _pos] call defendArea;
