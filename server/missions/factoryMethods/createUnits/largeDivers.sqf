//	@file Version: 1.0
//	@file Name: LargeDivers.sqf
//	@file Author: [GoT] JoSchaap

if(!X_Server) exitWith {};

private ["_group","_pos","_leader","_man1","_man2","_man3","_man4","_man5"];

_group = _this select 0;
_pos = _this select 1;

//diver lead
_leader = _group createunit ["C_man_polo_1_F", [(_pos select 0) + 10, _pos select 1, 0], [], 0.5, "Form"];
_leader addVest "V_RebreatherB"; 
_leader addUniform "U_B_Wetsuit"; 
_leader addBackpack "B_FieldPack_blk";
_leader addGoggles "G_Diving";
backpa = unitBackpack _leader;  
	clearMagazineCargo backpa;  
	backpa addmagazineCargoGlobal ["30Rnd_556x45_Stanag",2];  
	backpa addmagazineCargoGlobal ["20Rnd_556x45_UW_Mag",2];
_leader addmagazine "20Rnd_556x45_UW_Mag";
_leader addmagazine "20Rnd_556x45_UW_Mag";
_leader addmagazine "20Rnd_556x45_UW_Mag";
_leader addweapon "arifle_SDAR_F";

//Support
_man1 = _group createunit ["C_man_polo_3_F", [(_pos select 0) + 10, _pos select 1, 0], [], 0.5, "Form"];
_man1 addUniform "U_B_Wetsuit"; 
_man1 addVest "V_RebreatherB"; 
_man1 addGoggles "G_Diving";
_man1 addmagazine "20Rnd_556x45_UW_Mag";
_man1 addmagazine "20Rnd_556x45_UW_Mag";
_man1 addmagazine "20Rnd_556x45_UW_Mag";
_man1 addweapon "arifle_SDAR_F";

//Support
_man2 = _group createunit ["C_man_polo_2_F", [(_pos select 0) + 10, _pos select 1, 0], [], 0.5, "Form"];
_man2 addUniform "U_B_Wetsuit"; 
_man2 addVest "V_RebreatherB"; 
_man2 addGoggles "G_Diving";
_man2 addmagazine "20Rnd_556x45_UW_Mag";
_man2 addmagazine "20Rnd_556x45_UW_Mag";
_man2 addmagazine "20Rnd_556x45_UW_Mag";
_man2 addweapon "arifle_SDAR_F";

//Rifleman
_man3 = _group createunit ["C_man_polo_3_F", [(_pos select 0) + 10, _pos select 1, 0], [], 0.5, "Form"];
_man3 addUniform "U_B_Wetsuit"; 
_man3 addVest "V_RebreatherB"; 
_man3 addGoggles "G_Diving";
_man3 addmagazine "20Rnd_556x45_UW_Mag";
_man3 addmagazine "20Rnd_556x45_UW_Mag";
_man3 addmagazine "20Rnd_556x45_UW_Mag";
_man3 addweapon "arifle_SDAR_F";

//Rifleman
_man4 = _group createunit ["C_man_polo_3_F", [(_pos select 0) + 10, _pos select 1, 0], [], 0.5, "Form"];
_man4 addUniform "U_B_Wetsuit"; 
_man4 addVest "V_RebreatherB"; 
_man4 addGoggles "G_Diving";
_man4 addmagazine "20Rnd_556x45_UW_Mag";
_man4 addmagazine "20Rnd_556x45_UW_Mag";
_man4 addmagazine "20Rnd_556x45_UW_Mag";
_man4 addweapon "arifle_SDAR_F";

//Rifleman
_man5 = _group createunit ["C_man_polo_3_F", [(_pos select 0) + 10, _pos select 1, 0], [], 0.5, "Form"];
_man5 addUniform "U_B_Wetsuit"; 
_man5 addVest "V_RebreatherB"; 
_man5 addGoggles "G_Diving";
_man5 addmagazine "20Rnd_556x45_UW_Mag";
_man5 addmagazine "20Rnd_556x45_UW_Mag";
_man5 addmagazine "20Rnd_556x45_UW_Mag";
_man5 addweapon "arifle_SDAR_F";

{
	_x addrating 9999999;
	_x addEventHandler ["Killed",
	{
		(_this select 1) call removeNegativeScore;
	}];
} forEach units _group;

_leader = leader _group;
[_group, _pos] call defendArea3;
