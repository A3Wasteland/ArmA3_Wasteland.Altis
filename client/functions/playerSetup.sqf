//	@file Name: playerSetup.sqf
//	@file Author: [GoT] JoSchaap

_player = _this;
_player setskill 0;
{_player disableAI _x} foreach ["move","anim","target","autotarget"];
_player setVariable ["BIS_noCoreConversations", true];
_player allowDamage false;

enableSentences false;

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
		switch (true) do
		{
			case (_player isKindOf "B_sniper_F"):
			{ 
				_player addUniform "U_B_Ghilliesuit"; 
				_player addVest "V_PlateCarrier1_rgr"; 
			};
			case (_player isKindOf "B_diver_F"):
			{ 
				_player addUniform "U_B_Wetsuit"; 
				_player addVest "V_RebreatherB";
				_player addGoggles "G_Diving";
			};
			default
			{ 
				_player addUniform "U_B_CombatUniform_mcam";
				_player addVest "V_PlateCarrier1_rgr";
				_player addHeadgear "H_HelmetB";
			};
		};
	};
	case OPFOR:
	{
		switch (true) do
		{
			case (_player isKindOf "O_sniper_F"):
			{ 
				_player addUniform "U_O_Ghilliesuit"; 
				_player addVest "V_HarnessO_brn";
			};
			case (_player isKindOf "O_diver_F"):
			{ 
				_player addUniform "U_O_Wetsuit"; 
				_player addVest "V_RebreatherIR";
				_player addGoggles "G_Diving";
			};
			default
			{ 
				_player addUniform "U_O_CombatUniform_ocamo";
				_player addVest "V_HarnessO_brn";
				_player addHeadgear "H_HelmetO_ocamo";
			};
		};
	};
	default
	{
		switch (true) do
		{
			case (_player isKindOf "I_sniper_F"):
			{ 
				_player addUniform "U_I_Ghilliesuit"; 
				_player addVest "V_PlateCarrierIA2_dgtl";
			};
			case (_player isKindOf "I_diver_F"):
			{ 
				_player addUniform "U_I_Wetsuit"; 
				_player addVest "V_RebreatherIA";
				_player addGoggles "G_Diving";
			};
			default
			{ 
				_player addUniform "U_I_CombatUniform";
				_player addVest "V_PlateCarrierIA2_dgtl";
				_player addHeadgear "H_HelmetIA";
			};
		};
	};
};

// remove GPS (GPS is found as loot in buildings)
sleep 0.1;
//_player unAssignItem "ItemRadio";
//_player removeItem "ItemRadio";
_player unassignItem "ItemGPS";
_player removeItem "ItemGPS";

private "_nvgClass";
switch (side _player) do
{
	// case OPFOR:       { _nvgClass = "NVGoggles_OPFOR" };
	// case INDEPENDENT: { _nvgClass = "NVGoggles_INDEP" };
	default           { _nvgClass = "NVGoggles" };
};

// # Remove NVGs #########
{
	if (["NVGoggles", _x] call fn_findString != -1) then
	{
		_player unassignItem _x;
		_player removeItem _x;
	};
} forEach assignedItems _player;
// #######################

// # Add NVGs ############
// _player linkItem _nvgClass;
// #######################

_player addBackpack "B_AssaultPack_rgr";  // TODO: make this configurable for server admins!
_player addMagazine "9Rnd_45ACP_Mag";
_player addWeapon "hgun_ACPC2_F";
_player addMagazine "9Rnd_45ACP_Mag";
_player addMagazine "9Rnd_45ACP_Mag";
_player addMagazine "9Rnd_45ACP_Mag";
_player addItem "FirstAidKit";
_player selectWeapon "hgun_ACPC2_F";

_player addrating 9999999;

thirstLevel = 100;
hungerLevel = 100;

[objNull, _player] call mf_player_actions_refresh;
[] execVM "client\functions\playerActions.sqf";

_player groupChat format["Wasteland - Initialization Complete"];
playerSetupComplete = true;
