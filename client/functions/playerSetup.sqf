//	@file Name: playerSetup.sqf
//	@file Author: [GoT] JoSchaap

_player = _this;
_player setskill 0;
{_player disableAI _x} foreach ["move","anim","target","autotarget"];
_player setVariable ["BIS_noCoreConversations", true];
_player addEventHandler ["HandleDamage", {false}];

enableSentences false;
_player unassignItem "NVGoggles";
_player removeItem "NVGoggles";
removeAllWeapons _player;
removeUniform _player;
removeVest _player;
removeBackpack _player;
removeHeadgear _player;
removeGoggles _player;


switch (playerSide) do
{
	case BLUFOR: 
		{
			if (typeof _player == "B_sniper_F") then { 
				_player addUniform "U_B_Ghilliesuit"; 
				_player addVest "V_PlateCarrier2_rgr"; 
			};
			if (typeof _player == "B_diver_F") then { 
				_player addUniform "U_B_Wetsuit"; 
				_player addVest "V_RebreatherB";
				_player addGoggles "G_Diving";
			};
			if (typeof _player != "B_diver_F" && typeof _player != "B_sniper_F") then { 
				_player addUniform "U_B_CombatUniform_mcam";
				_player addVest "V_PlateCarrier2_rgr";
				_player addHeadgear "H_HelmetB";
			};
		};
	case OPFOR:
		{
			if (typeof _player == "O_sniper_F") then { 
				_player addUniform "U_O_Ghilliesuit"; 
				_player addVest "V_PlateCarrier2_rgr"; 
			};
			if (typeof _player == "O_diver_F") then { 
				_player addUniform "U_O_Wetsuit"; 
				_player addVest "V_RebreatherIR";
				_player addGoggles "G_Diving";
			};
			if (typeof _player != "O_diver_F" && typeof _player != "O_sniper_F") then { 
				_player addUniform "U_O_CombatUniform_ocamo";
				_player addVest "V_PlateCarrier2_rgr";
				_player addHeadgear "H_HelmetO_ocamo";
			};
		};
	default
		{
			if (typeof _player == "I_sniper_F") then { 
				_player addUniform "U_I_Ghilliesuit"; 
				_player addVest "V_PlateCarrier2_rgr"; 
			};
			if (typeof _player == "I_diver_F") then { 
				_player addUniform "U_I_Wetsuit"; 
				_player addVest "V_RebreatherIA";
				_player addGoggles "G_Diving";
			};
			if (typeof _player != "I_diver_F" && typeof _player != "I_sniper_F") then { 
				_player addUniform "U_I_CombatUniform";
				_player addVest "V_PlateCarrier2_rgr";
				_player addHeadgear "H_MilCap_ocamo";
			};
		};
};

// seems ghillysuit comes with a GPS so moved this here:
_player removeWeapon "ItemRadio";
_player removeWeapon "ItemGPS";

_player addItem "NVGoggles";
_player assignItem "NVGoggles";
_player addBackpack "B_Kitbag_Base";
_player addMagazine "9Rnd_45ACP_Mag";
_player addMagazine "9Rnd_45ACP_Mag";
_player addMagazine "9Rnd_45ACP_Mag";
_player addWeapon "hgun_ACPC2_F";
_player selectWeapon "hgun_ACPC2_F";
_player addItem "FirstAidKit";
_player addrating 9999999;


thirstLevel = 100;
hungerLevel = 100;

[objNull, _player] call mf_player_actions_refresh;
[] execVM "client\functions\playerActions.sqf";

_player groupChat format["Wasteland - Initialization Complete"];
playerSetupComplete = true;
