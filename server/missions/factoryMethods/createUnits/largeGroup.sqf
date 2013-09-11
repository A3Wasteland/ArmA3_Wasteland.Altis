//	@file Version: 1.0
//	@file Name: largeGroup.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy
//	@file Created: 08/12/2012 21:58
//	@file Args:

if (!isServer) exitWith {};

private ["_group","_pos","_leader","_man2","_man3","_man4","_man5","_man6","_man7","_man8","_man9","_man10"];

_group = _this select 0;
_pos = _this select 1;

//Anti Air no weapon
_leader = _group createunit ["C_man_polo_1_F", [(_pos select 0) + 30, _pos select 1, 0], [], 0.5, "Form"];
_leader addMagazine "Strela";
_leader addWeapon "Strela";
_leader addMagazine "30Rnd_545x39_AK";
_leader addMagazine "30Rnd_545x39_AK";
_leader addMagazine "30Rnd_545x39_AK";
_leader addWeapon "AKS_74_U";

//Support
_man2 = _group createunit ["C_man_polo_2_F", [(_pos select 0) - 30, _pos select 1, 0], [], 0.5, "Form"];
_man2 addMagazine "75Rnd_545x39_RPK";
_man2 addMagazine "75Rnd_545x39_RPK";
_man2 addWeapon "RPK_74";

//Rifle_man
_man3 = _group createunit ["C_man_polo_3_F", [_pos select 0, (_pos select 1) + 30, 0], [], 0.5, "Form"];
_man3 addMagazine "30Rnd_762x39_AK47";
_man3 addMagazine "30Rnd_762x39_AK47";
_man3 addMagazine "30Rnd_762x39_AK47";
_man3 addWeapon "AK_47_M";

//Rifle_man
_man4 = _group createunit ["C_man_polo_4_F", [_pos select 0, (_pos select 1) + 40, 0], [], 0.5, "Form"];
_man4 addMagazine "30Rnd_762x39_AK47";
_man4 addMagazine "30Rnd_762x39_AK47";
_man4 addMagazine "30Rnd_762x39_AK47";
_man4 addWeapon "AK_47_M";

//Sniper
_man5 = _group createunit ["C_man_polo_5_F", [_pos select 0, (_pos select 1) - 30, 0], [], 0.5, "Form"];
_man5 addMagazine "10Rnd_762x54_SVD";
_man5 addMagazine "10Rnd_762x54_SVD";
_man5 addMagazine "10Rnd_762x54_SVD";
_man5 addWeapon "SVD";

//Grenadier
_man6 = _group createunit ["C_man_polo_4_F", [_pos select 0, (_pos select 1) - 40, 0], [], 0.5, "Form"];
_man6 addMagazine "30Rnd_545x39_AK";
_man6 addMagazine "30Rnd_545x39_AK";
_man6 addMagazine "30Rnd_545x39_AK";
_man6 addMagazine "1Rnd_HE_GP25";
_man6 addMagazine "1Rnd_HE_GP25";
_man6 addMagazine "1Rnd_HE_GP25";
_man6 addWeapon "AK_74_GL";

//Support
_man7 = _group createunit ["C_man_polo_4_F", [(_pos select 0) - 40, _pos select 1, 0], [], 0.5, "Form"];
_man7 addMagazine "75Rnd_545x39_RPK";
_man7 addMagazine "75Rnd_545x39_RPK";
_man7 addWeapon "RPK_74";

//Grenadier
_man8 = _group createunit ["C_man_polo_4_F", [_pos select 0, (_pos select 1) + 50, 0], [], 0.5, "Form"];
_man8 addMagazine "30Rnd_545x39_AK";
_man8 addMagazine "30Rnd_545x39_AK";
_man8 addMagazine "30Rnd_545x39_AK";
_man8 addMagazine "1Rnd_HE_GP25";
_man8 addMagazine "1Rnd_HE_GP25";
_man8 addMagazine "1Rnd_HE_GP25";
_man8 addWeapon "AK_74_GL";

//Sniper
_man9 = _group createunit ["C_man_polo_4_F", [_pos select 0, (_pos select 1) - 50, 0], [], 0.5, "Form"];
_man9 addMagazine "10Rnd_762x54_SVD";
_man9 addMagazine "10Rnd_762x54_SVD";
_man9 addMagazine "10Rnd_762x54_SVD";
_man9 addWeapon "SVD";

//Rifle_man
_man10 = _group createunit ["C_man_polo_4_F", [_pos select 0, (_pos select 1) + 30, 0], [], 0.5, "Form"];
_man10 addMagazine "30Rnd_762x39_AK47";
_man10 addMagazine "30Rnd_762x39_AK47";
_man10 addMagazine "30Rnd_762x39_AK47";
_man10 addWeapon "AK_47_M";

_leader = leader _group;
[_group, _pos] call defendArea;