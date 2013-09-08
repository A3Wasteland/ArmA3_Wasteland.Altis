//	@file Version: 1.0
//	@file Name: smallGroup.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy
//	@file Created: 08/12/2012 21:58
//	@file Args:

if(!X_Server) exitWith {};

private ["_group","_pos","_leader","_man2","_man3","_man4"];

_group = _this select 0;
_pos = _this select 1;

//Anti Vehicle
_leader = _group createunit ["C_man_polo_1_F", [(_pos select 0) + 10, _pos select 1, 0], [], 0.5, "Form"];
_leader addUniform "U_B_CombatUniform_mcam_vest";
_leader addVest "V_PlateCarrier1_cbr";
_leader addMagazine "RPG32_HE_F";
_leader addMagazine "RPG32_HE_F";
_leader addWeapon "launch_RPG32_F";
_leader addMagazine "30Rnd_556x45_Stanag_Tracer_Red";
_leader addMagazine "30Rnd_556x45_Stanag_Tracer_Red";
_leader addMagazine "30Rnd_556x45_Stanag_Tracer_Red";
_leader addWeapon "arifle_TRG20_F";

//Support
_man2 = _group createunit ["C_man_polo_2_F", [(_pos select 0) - 30, _pos select 1, 0], [], 0.5, "Form"];
_man2 addUniform "U_B_CombatUniform_mcam_tshirt";
_man2 addVest "V_PlateCarrier1_rgr";
_man2 addMagazine "30Rnd_556x45_Stanag";
_man2 addMagazine "30Rnd_556x45_Stanag";
_man2 addMagazine "30Rnd_556x45_Stanag";
_man2 addMagazine "30Rnd_556x45_Stanag";
_man2 addWeapon "arifle_MK20C_F";

//Rifleman
_man3 = _group createunit ["C_man_polo_3_F", [_pos select 0, (_pos select 1) + 30, 0], [], 0.5, "Form"];
_man3 addUniform "U_B_CombatUniform_mcam";
_man3 addVest "V_PlateCarrier1_cbr";
_man3 addMagazine "30Rnd_556x45_Stanag_Tracer_Red";
_man3 addMagazine "30Rnd_556x45_Stanag_Tracer_Red";
_man3 addMagazine "30Rnd_556x45_Stanag_Tracer_Red";
_man3 addWeapon "arifle_TRG20_F";

//Sniper
_man4 = _group createunit ["C_man_polo_4_F", [_pos select 0, (_pos select 1) - 30, 0], [], 0.5, "Form"];
_man4 addUniform "U_B_CombatUniform_mcam_vest";
_man4 addVest "V_PlateCarrier1_rgr";
_man4 addMagazine "20Rnd_762x51_Mag";
_man4 addMagazine "20Rnd_762x51_Mag";
_man4 addWeapon "srifle_EBR_F";

{
	_x addrating 9999999;
	_x addEventHandler ["Killed",
	{
		(_this select 1) call removeNegativeScore;
	}];
} forEach units _group;


_leader = leader _group;
[_group, _pos] call defendArea;
