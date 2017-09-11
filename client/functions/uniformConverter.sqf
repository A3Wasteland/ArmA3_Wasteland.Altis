// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: uniformConverter.sqf
//	@file Author: AgentRev
//	@file Created: 23/12/2013 01:10

// The purpose of this script is to convert a uniform class to a side-equivalent one that is compatible with the player
// Example: "U_O_GhillieSuit" becomes "U_I_GhillieSuit" if the player is on Independent side

// if the current incompatible uniform is present in an array, all the uniforms from that same array are checked left-right to find the first compatible match
// arrays at the top take precedence over bottom ones

private ["_uniform", "_side", "_uniforms", "_uniArray", "_uniX"];

_unit = _this select 0;
_uniform = _this select 1;

if !(_unit isUniformAllowed _uniform) then
{
	_uniforms =
	[
		["U_B_CombatUniform_mcam", "U_O_OfficerUniform_ocamo", "U_O_CombatUniform_ocamo", "U_I_CombatUniform"], // opfor officer uniform takes precedence on combat uniform to maintain balance

		["U_B_T_Soldier_F", "U_O_T_Officer_F", "U_O_T_Soldier_F", "U_I_CombatUniform"], // jungle fatigues converts to default uniform for indies

		["U_B_GhillieSuit", "U_O_GhillieSuit", "U_I_GhillieSuit"],
		["U_B_T_Sniper_F", "U_O_T_Sniper_F", "U_I_GhillieSuit"],  // jungle light ghillie converts to normal light ghillie for indies

		["U_B_FullGhillie_ard", "U_O_FullGhillie_ard", "U_I_FullGhillie_ard"],
		["U_B_FullGhillie_lsh", "U_O_FullGhillie_lsh", "U_I_FullGhillie_lsh"],
		["U_B_FullGhillie_sard", "U_O_FullGhillie_sard", "U_I_FullGhillie_sard"],
		["U_B_T_FullGhillie_tna_F", "U_O_T_FullGhillie_tna_F"/*, "U_I_FullGhillie_lsh"*/], // (inactive) jungle full ghillie converts to lush full ghillie for indies

		["U_B_CTRG_Soldier_F", "U_B_CTRG_Soldier_3_F", "U_O_V_Soldier_Viper_F", "U_O_V_Soldier_Viper_hex_F"/*, "U_I_GhillieSuit"*/], // (inactive) thermal suit converts to light ghillie for indies

		["U_B_Wetsuit", "U_B_survival_uniform", "U_O_Wetsuit", "U_I_Wetsuit"],

		["U_B_PilotCoveralls", "U_O_PilotCoveralls", "U_I_PilotCoveralls"],
		["U_BG_Guerilla1_1", "U_OG_Guerilla1_1", "U_IG_Guerilla1_1"],
		["U_BG_Guerilla2_1", "U_OG_Guerilla2_1", "U_IG_Guerilla2_1"],
		["U_BG_Guerilla2_2", "U_OG_Guerilla2_2", "U_IG_Guerilla2_2"],
		["U_BG_Guerilla2_3", "U_OG_Guerilla2_3", "U_IG_Guerilla2_3"],
		["U_BG_Guerilla3_1", "U_OG_Guerilla3_1", "U_IG_Guerilla3_1"],
		["U_BG_Guerilla3_2", "U_OG_Guerilla3_2", "U_IG_Guerilla3_2"],
		["U_BG_leader", "U_OG_leader", "U_IG_leader"],
		//["U_O_OfficerUniform_ocamo", "U_I_OfficerUniform"],
		["U_B_HeliPilotCoveralls", "U_I_HeliPilotCoveralls"],

		["U_O_Protagonist_VR", "U_B_Protagonist_VR", "U_I_Protagonist_VR"]
	];

	{
		_uniArray = _x;

		if ({_uniform == _x} count _uniArray > 0) exitWith
		{
			{
				_uniX = _x;

				if (_unit isUniformAllowed _uniX || // indie exception for NATO jungle ghillie & thermal suit due to BIS not giving a damn
				    (side group _unit == INDEPENDENT && {{_uniX == _x} count ["U_B_CTRG_Soldier_F","U_B_T_FullGhillie_tna_F"] > 0})) exitWith
				{
					_uniform = _uniX;
				};
			} forEach _uniArray;
		};
	} forEach _uniforms;
};

_uniform
