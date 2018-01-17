// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2018 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: artilleryConfirm.sqf
//	@file Author: AgentRev

#include "artillery_defines.hpp"

(findDisplay A3W_artilleryMenu_IDD displayCtrl A3W_artilleryMenu_ConfirmButton_IDC) ctrlEnable false;

0 spawn
{
	call
	{
		if (call mf_items_artillery_checkCooldown != "") exitWith {};

		_pos = A3W_artilleryMenu_targetPos;
		if (isNil "_pos") exitWith {};

		_msg = format ["You are about to fire %1 artillery shells at Grid %2.<br/><br/>The strike will take about 30 seconds to begin, with an average rate of 1 shell every 2 seconds.<br/><br/>Your Artillery Strike item will be consumed. <br/><br/>Do you want to proceed?", A3W_artilleryMenu_shellCount, mapGridPosition _pos];

		if !([_msg, "Confirm", true, true] call BIS_fnc_guiMessage) exitWith {};
		if (call mf_items_artillery_checkCooldown != "") exitWith {};

		if (!isServer) then { missionNamespace setVariable ["A3W_artilleryLastUse_" + getPlayerUID player, diag_tickTime + (["A3W_serverTickTimeDiff", 0] call getPublicVar)] };
		["artillery", 1] call mf_inventory_remove;

		[player, _pos] remoteExecCall ["A3W_fnc_artilleryStrike", 2];
		["Strike request sent...", 5] call a3w_actions_notify;
		playSound "Orange_Access_FM";

		waitUntil {closeDialog 0; !dialog};
	};

	(findDisplay A3W_artilleryMenu_IDD displayCtrl A3W_artilleryMenu_ConfirmButton_IDC) ctrlEnable true;
};
