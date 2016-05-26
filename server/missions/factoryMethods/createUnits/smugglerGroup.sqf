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
_leader addUniform "U_IG_leader";
_leader addVest "V_TacVestIR_blk";
_leader addBackpack "B_AssaultPack_blk";
_leader addMagazine "30Rnd_556x45_Stanag";
_leader addWeapon "arifle_TRG21_F";
_leader addPrimaryWeaponItem "optic_Holosight";
_leader addMagazine "30Rnd_556x45_Stanag";
_leader addMagazine "30Rnd_556x45_Stanag";
_leader addMagazine "Titan_AA";
_leader addWeapon "launch_Titan_F";
_leader addMagazine "Titan_AA";
_leader addMagazine "HandGrenade";
_leader selectWeapon "launch_Titan_F";

// Rifleman - AT Rockets
_man2 = _group createUnit ["C_man_polo_2_F", [(_pos select 0) - 30, _pos select 1, 0], [], 1, "Form"];
_man2 addUniform "U_IG_leader";
_man2 addVest "V_TacVestIR_blk";
_man2 addBackpack "B_AssaultPack_blk";
_man2 addMagazine "30Rnd_556x45_Stanag";
_man2 addWeapon "arifle_TRG20_F";
_man2 addPrimaryWeaponItem "optic_Holosight";
_man2 addMagazine "30Rnd_556x45_Stanag";
_man2 addMagazine "30Rnd_556x45_Stanag";
_man2 addMagazine "Titan_AT";
_man2 addWeapon "launch_B_Titan_short_F";
_man2 addMagazine "Titan_AT";
_man2 addMagazine "HandGrenade";
_man2 selectWeapon "launch_B_Titan_short_F";

// Rifleman
_man3 = _group createUnit ["C_man_polo_3_F", [_pos select 0, (_pos select 1) + 30, 0], [], 1, "Form"];
_man3 addUniform "U_IG_leader";
_man3 addVest "V_TacVestIR_blk";
_man3 addMagazine "30Rnd_556x45_Stanag";
_man3 addWeapon "arifle_TRG20_F";
_man3 addPrimaryWeaponItem "optic_Holosight";
_man3 addMagazine "30Rnd_556x45_Stanag";
_man3 addMagazine "30Rnd_556x45_Stanag";
_man3 addMagazine "HandGrenade";

// Rifleman
_man4 = _group createUnit ["C_man_polo_4_F", [_pos select 0, (_pos select 1) + 40, 0], [], 1, "Form"];
_man4 addUniform "U_IG_Guerilla1_1";
_man4 addVest "V_TacVestIR_blk";
_man4 addMagazine "30Rnd_556x45_Stanag";
_man4 addWeapon "arifle_TRG20_F";
_man4 addPrimaryWeaponItem "optic_Holosight";
_man4 addMagazine "30Rnd_556x45_Stanag";
_man4 addMagazine "30Rnd_556x45_Stanag";
_man4 addMagazine "HandGrenade";

// Rifleman
_man5 = _group createUnit ["C_man_polo_5_F", [_pos select 0, (_pos select 1) + 40, 0], [], 1, "Form"];
_man5 addUniform "U_IG_Guerilla1_1";
_man5 addVest "V_TacVestIR_blk";
_man5 addMagazine "30Rnd_556x45_Stanag";
_man5 addWeapon "arifle_TRG20_F";
_man5 addPrimaryWeaponItem "optic_Holosight";
_man5 addMagazine "30Rnd_556x45_Stanag";
_man5 addMagazine "30Rnd_556x45_Stanag";
_man5 addMagazine "HandGrenade";

// Rifleman
_man6 = _group createUnit ["C_man_polo_4_F", [_pos select 0, (_pos select 1) - 30, 0], [], 1, "Form"];
_man6 addUniform "U_IG_Guerilla1_1";
_man6 addVest "V_TacVestIR_blk";
_man6 addMagazine "30Rnd_556x45_Stanag";
_man6 addWeapon "arifle_TRG20_F";
_man6 addPrimaryWeaponItem "optic_Holosight";
_man6 addMagazine "30Rnd_556x45_Stanag";
_man6 addMagazine "30Rnd_556x45_Stanag";
_man6 addMagazine "HandGrenade";

// Grenadier
_man7 = _group createUnit ["C_man_polo_3_F", [_pos select 0, (_pos select 1) - 40, 0], [], 1, "Form"];
_man7 addUniform "U_IG_leader";
_man7 addVest "V_TacVestIR_blk";
_man7 addMagazine "30Rnd_556x45_Stanag";
_man7 addMagazine "1Rnd_HE_Grenade_shell";
_man7 addWeapon "arifle_TRG21_GL_F";
_man7 addPrimaryWeaponItem "optic_Holosight";
_man7 addMagazine "30Rnd_556x45_Stanag";
_man7 addMagazine "30Rnd_556x45_Stanag";
_man7 addMagazine "1Rnd_HE_Grenade_shell";
_man7 addMagazine "1Rnd_HE_Grenade_shell";
_man7 addMagazine "HandGrenade";

// Rifleman
_man8 = _group createUnit ["C_man_polo_5_F", [_pos select 0, (_pos select 1) + 40, 0], [], 1, "Form"];
_man8 addUniform "U_IG_Guerilla1_1";
_man8 addVest "V_TacVestIR_blk";
_man8 addMagazine "30Rnd_556x45_Stanag";
_man8 addWeapon "arifle_TRG20_F";
_man8 addPrimaryWeaponItem "optic_Holosight";
_man8 addMagazine "30Rnd_556x45_Stanag";
_man8 addMagazine "30Rnd_556x45_Stanag";
_man8 addMagazine "HandGrenade";

// Rifleman
_man9 = _group createUnit ["C_man_polo_4_F", [_pos select 0, (_pos select 1) - 30, 0], [], 1, "Form"];
_man9 addUniform "U_IG_Guerilla1_1";
_man9 addVest "V_TacVestIR_blk";
_man9 addMagazine "30Rnd_556x45_Stanag";
_man9 addWeapon "arifle_TRG20_F";
_man9 addPrimaryWeaponItem "optic_Holosight";
_man9 addMagazine "30Rnd_556x45_Stanag";
_man9 addMagazine "30Rnd_556x45_Stanag";
_man9 addMagazine "HandGrenade";

// Grenadier
_man10 = _group createUnit ["C_man_polo_3_F", [_pos select 0, (_pos select 1) - 40, 0], [], 1, "Form"];
_man10 addUniform "U_IG_leader";
_man10 addVest "V_TacVestIR_blk";
_man10 addMagazine "30Rnd_556x45_Stanag";
_man10 addMagazine "1Rnd_HE_Grenade_shell";
_man10 addWeapon "arifle_TRG21_GL_F";
_man10 addPrimaryWeaponItem "optic_Holosight";
_man10 addMagazine "30Rnd_556x45_Stanag";
_man10 addMagazine "30Rnd_556x45_Stanag";
_man10 addMagazine "1Rnd_HE_Grenade_shell";
_man10 addMagazine "1Rnd_HE_Grenade_shell";
_man10 addMagazine "HandGrenade";

sleep 0.1; // Without this delay, headgear doesn't get removed properly

_leader = leader _group;

{
	removeAllAssignedItems _x;
	if (_x == _leader) then { _x addHeadgear "H_Shemag_khk" }
	                   else { _x addHeadgear "H_Shemag_khk" };
	_x addPrimaryWeaponItem "acc_flashlight";
	_x enablegunlights "forceOn";
	_x call setMissionSkill;
	_x allowFleeing 0;
	_x addRating 9999999;
	_x addEventHandler ["Killed", server_playerDied];
} forEach units _group;

[_group, _pos, "LandVehicle"] call defendArea;