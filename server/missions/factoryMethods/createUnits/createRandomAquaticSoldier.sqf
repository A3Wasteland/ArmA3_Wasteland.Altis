/*
 * Creates a random civilian soldier.
 *
 * Arguments: [ position, group, init, skill, rank]: Array
 *    position: Position - Location unit is created at.
 *    group: Group - Existing group new unit will join.
 *    init: String - (optional, default "") Command to be executed upon creation of unit. Parameter this is set to the created unit and passed to the code.
 *    skill: Number - (optional, default 0.5)
 *    rank: String - (optional, default "PRIVATE")
 */

private ["_soldierTypes","_uniformTypes","_vestTypes","_weaponTypes","_group","_position","_soldier"];

_soldierTypes = ["C_man_1","C_man_1_2_F","C_man_1_3_F","C_man_polo_1_F","C_man_polo_2_F","C_man_polo_3_F","C_man_polo_4_F","C_man_polo_5_F","C_man_polo_6_F"];
_uniformTypes = ["U_B_Wetsuit","U_O_Wetsuit"];
_vestTypes = ["V_RebreatherB","V_RebreatherIR"];
//_pistolTypes = [];
_weaponTypes = ["arifle_SDAR_F"];
//_launcherType = ["launch_RPG32_F"];

_group = _this select 0;
_position = _this select 1;

_soldier = _group createUnit [_soldierTypes call BIS_fnc_selectRandom, _position, [], 0, "NONE"];
_soldier addUniform (_uniformTypes call BIS_fnc_selectRandom);
_soldier addVest (_vestTypes call BIS_fnc_selectRandom);
_soldier addGoggles "G_Diving";
[_soldier, _weaponTypes call BIS_fnc_selectRandom, 3] call BIS_fnc_addWeapon;

_soldier spawn refillPrimaryAmmo;
_soldier call setMissionSkill;

_soldier addEventHandler ["Killed", {_this call server_playerDied; (_this select 1) call removeNegativeScore}];

_soldier