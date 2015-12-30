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

call compile preprocessFile "addons\far_revive\FAR_revive_funcs.sqf";

FAR_isDragging = false;
FAR_isDragging_EH = [];
FAR_deathMessage = [];
FAR_gutMessage = [];
FAR_Debugging = false;

FAR_Reset_Unit =
{
	_this setVariable ["FAR_isUnconscious", 0, true];
	_this setVariable ["FAR_isStabilized", 0, true];
	_this setVariable ["FAR_iconBlink", nil, true];
	_this setVariable ["FAR_draggedBy", nil, true];
	_this setVariable ["FAR_treatedBy", nil, true];
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

FAR_Player_Init =
{
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
"FAR_gutMessage" addPublicVariableEventHandler FAR_public_EH;

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
	player addEventHandler ["Respawn", { [] spawn FAR_Player_Init }];
	player addEventHandler
	[
		"Killed",
		{
			if (!isNil "FAR_Player_Unconscious_thread" && {typeName FAR_Player_Unconscious_thread == "SCRIPT" && {!scriptDone FAR_Player_Unconscious_thread}}) then
			{
				terminate FAR_Player_Unconscious_thread;
				closeDialog ReviveBlankGUI_IDD;
				closeDialog ReviveGUI_IDD;
				FAR_cutTextLayer cutText ["", "PLAIN"];
				//(FAR_cutTextLayer + 1) cutText ["", "PLAIN"];
			};

			player call FAR_Reset_Unit;
			player allowDamage true;
		}
	];
};

////////////////////////////////////////////////
// [Debugging] Add revive to playable AI units
////////////////////////////////////////////////
if (!FAR_Debugging) exitWith {};

{
	if (!isPlayer _x) then
	{
		_x addEventHandler ["HandleDamage", FAR_HandleDamage_EH];
		_x setVariable ["FAR_isUnconscious", 0, true];
		_x setVariable ["FAR_isStabilized", 0, true];
		_x setVariable ["FAR_draggedBy", objNull, true];
	};
} forEach switchableUnits;
