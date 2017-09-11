// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//
// Farooq's Revive 2.0
// Heavily modified for A3Wasteland by AgentRev
//
// Licensed under GPLv3 with permission from Farooq
//

if (isDedicated) exitWith {};

#include "FAR_defines.sqf"
#include "gui_defines.hpp"

call compile preprocessFileLineNumbers "addons\far_revive\FAR_revive_funcs.sqf";

FAR_isDragging = false;
FAR_isDragging_EH = [];
FAR_deathMessage = [];
FAR_Debugging = true;

FAR_Reset_Unit =
{
	_this setVariable ["FAR_isUnconscious", 0, true];
	_this setVariable ["FAR_isStabilized", 0, true];
	_this setVariable ["FAR_iconBlink", nil, true];
	_this setVariable ["FAR_draggedBy", nil, true];
	_this setVariable ["FAR_isDragging", nil, true];
	_this setVariable ["FAR_treatedBy", nil, true];
	_this setVariable ["FAR_isTreating", nil];
	_this setVariable ["FAR_cancelAutoEject", nil, true];
	_this setVariable ["FAR_handleStabilize", nil, true];
	_this setVariable ["FAR_reviveModeReady", nil];
	_this setVariable ["FAR_headshotHitTimeout", nil];
	_this setUnconscious false;
	_this setCaptive false;

	if (isPlayer _this) then
	{
		_this setVariable ["ace_sys_wounds_uncon", false];

		if (_this == player) then
		{
			FAR_isDragging = false;
		};
	};
}
call mf_compile;

FAR_Reset_Killer_Info =
{
	[
		_this,
		[
			["FAR_killerVehicle", nil],
			["FAR_killerVehicleClass", nil],
			["FAR_killerUnit", nil],
			["FAR_killerName", nil],
			["FAR_killerUID", nil],
			["FAR_killerGroup", nil],
			["FAR_killerSide", nil],
			["FAR_killerFriendly", nil],
			["FAR_killerAI", nil],
			["FAR_killerWeapon", nil],
			["FAR_killerAmmo", nil],
			["FAR_killerDistance", nil],
			["FAR_killerSuspects", nil]
		]
	] call A3W_fnc_setVarServer;
}
call mf_compile;

FAR_Player_Init =
{
	player call FAR_Reset_Killer_Info;
	player call FAR_Reset_Unit;
	call FAR_Player_Actions;
}
call mf_compile;

FAR_Mute_ACRE =
{
	waitUntil { time > 0 };

	waitUntil
	{
		if (alive player) then
		{
			// player getVariable ["ace_sys_wounds_uncon", true/false];
			if ((player getVariable["ace_sys_wounds_uncon", false])) then
			{
				private["_saveVolume"];

				_saveVolume = acre_sys_core_globalVolume;

				player setVariable ["acre_sys_core_isDisabled", true, true];

				waitUntil
				{
					acre_sys_core_globalVolume = 0;

					if (!(player getVariable["acre_sys_core_isDisabled", false])) then
					{
						player setVariable ["acre_sys_core_isDisabled", true, true];
						[true] call acre_api_fnc_setSpectator;
					};

					!(player getVariable["ace_sys_wounds_uncon", false]);
				};

				if ((player getVariable["acre_sys_core_isDisabled", false])) then
				{
					player setVariable ["acre_sys_core_isDisabled", false, true];
					[false] call acre_api_fnc_setSpectator;
				};

				acre_sys_core_globalVolume = _saveVolume;
			};
		}
		else
		{
			waitUntil { alive player };
		};

		sleep 0.25;

		false
	};
}
call mf_compile;

FAR_findKiller = "addons\far_revive\FAR_findKiller.sqf" call mf_compile;

////////////////////////////////////////////////
// Public event handlers
////////////////////////////////////////////////
"FAR_isDragging_EH" addPublicVariableEventHandler FAR_public_EH;
"FAR_deathMessage" addPublicVariableEventHandler FAR_public_EH;

////////////////////////////////////////////////
// Player Initialization
////////////////////////////////////////////////
[] spawn
{
	waitUntil {!isNull player};

	[] spawn FAR_Player_Init;

	if (FAR_MuteACRE) then
	{
		[] spawn FAR_Mute_ACRE;

		//hintSilent format["Farooq's Revive %1 is initialized.%2", SCRIPT_VERSION, "\n\n Note: Unconscious units will not be able to use radio, hear other people or use proximity chat"];
	};
	/*else
	{
		hintSilent format["Farooq's Revive %1 is initialized.", SCRIPT_VERSION];
	};*/

	// Event Handlers
	player addEventHandler ["Respawn", FAR_Player_Init];
	player addEventHandler
	[
		"Killed",
		{
			//terminate (player getVariable ["FAR_Player_Unconscious_thread", scriptNull]);
			(findDisplay ReviveBlankGUI_IDD) closeDisplay 0;
			//(findDisplay ReviveGUI_IDD) closeDisplay 0;
			(uiNamespace getVariable ["ReviveGUI", displayNull]) closeDisplay 0;
			FAR_cutTextLayer cutText ["", "PLAIN"];
			(FAR_cutTextLayer + 1) cutText ["", "PLAIN"];
			(ReviveGUI_IDD + 9) cutText ["", "PLAIN"];

			player call FAR_Reset_Unit;
			player allowDamage true;
		}
	];
};

////////////////////////////////////////////////
// [Debugging] Add revive to group AI units
////////////////////////////////////////////////
if (!FAR_Debugging) exitWith {};

FAR_Init_AI_Debug =
{
	_this addEventHandler ["HandleDamage", unitHandleDamage];
	_this addEventHandler ["Killed", { terminate ((_this select 0) getVariable ["FAR_Player_Unconscious_thread", scriptNull]) }];
	_this setVariable ["FAR_isUnconscious", 0, true];
	_this setVariable ["FAR_isStabilized", 0, true];
	_this setVariable ["FAR_draggedBy", objNull, true];
	_this setVariable ["playerSpawning", false, true];
	[_this] call fn_remotePlayerSetup;
	_this setVariable ["FAR_aiDebugSetup", true];
}
call mf_compile;

[] spawn
{
	while {true} do
	{
		{
			if (alive _x && local _x && !isPlayer _x && isNil {_x getVariable "FAR_aiDebugSetup"}) then
			{
				_x call FAR_Init_AI_Debug
			};
		} forEach units group player;
		uiSleep 5;
	};
};
