// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
#include "FAR_defines.sqf"

////////////////////////////////////////////////
// Player Actions
////////////////////////////////////////////////
FAR_Player_Actions =
{
	if (alive player && player isKindOf "Man") then
	{
		// addAction args: title, filename, (arguments, priority, showWindow, hideOnUse, shortcut, condition, positionInModel, radius, radiusView, showIn3D, available, textDefault, textToolTip)
		{ [player, _x] call fn_addManagedAction } forEach
		[
			["<t color='#00C900'>" + "Revive" + "</t>", "addons\FAR_revive\FAR_handleAction.sqf", ["action_revive"], 100, true, true, "", FAR_Check_Revive],
			["<t color='#00C900'>" + "Stabilize" + "</t>", "addons\FAR_revive\FAR_handleAction.sqf", ["action_stabilize"], 99, true, true, "", FAR_Check_Stabilize],
			["<t color='#C9C900'>" + "Drag" + "</t>", "addons\FAR_revive\FAR_handleAction.sqf", ["action_drag"], 98, true, true, "", FAR_Check_Dragging]
		];
	};
}
call mf_compile;

////////////////////////////////////////////////
// Handle Death
////////////////////////////////////////////////
FAR_HandleDamage_EH = "addons\far_revive\FAR_HandleDamage_EH.sqf" call mf_compile;

////////////////////////////////////////////////
// Make Player Unconscious
////////////////////////////////////////////////
FAR_Player_Unconscious = "addons\far_revive\FAR_Player_Unconscious.sqf" call mf_compile;

////////////////////////////////////////////////
// Suspect Tracking
////////////////////////////////////////////////
//FAR_setKillerInfo = "addons\far_revive\FAR_setKillerInfo.sqf" call mf_compile; // done from globalCompile.sqf instead, due to use by server

////////////////////////////////////////////////
// Revive Player
////////////////////////////////////////////////
FAR_HandleRevive =
{
	private ["_target", "_medicMove"];
	_target = _this select 0;

	if (alive _target) then
	{
		_target setVariable ["FAR_treatedBy", player, true];

		_medicMove = format ["AinvPknlMstpSlayW%1Dnon_medic", [_target, true] call getMoveWeapon];
		player playMove _medicMove;

		waitUntil {sleep 0.1; animationState player == _medicMove || !CAN_PERFORM};
		waitUntil {sleep 0.1; animationState player != _medicMove || !CAN_PERFORM};

		if (CAN_PERFORM) then
		{
			_target setVariable ["FAR_isUnconscious", 0, true];

			[player, "reviveCount", 1] call fn_addScore;

			// [Debugging] Code below is only relevant if revive script is enabled for AI
			if (!isPlayer _target) then
			{
				_target setDamage 0;
				_target setCaptive false;

				_target playMove format ["AmovPpneMstpSrasW%1Dnon", _target call getMoveWeapon];
			};
		};

		if (_target getVariable ["FAR_treatedBy", objNull] == player) then
		{
			_target setVariable ["FAR_treatedBy", nil, true];
		};
	};
}
call mf_compile;

////////////////////////////////////////////////
// Stabilize Player
////////////////////////////////////////////////
FAR_HandleStabilize =
{
	private ["_target", "_medicMove"];
	_target = _this select 0;

	if (alive _target) then
	{
		_target setVariable ["FAR_treatedBy", player, true];

		_medicMove = format ["AinvPknlMstpSlayW%1Dnon_medic", [_target, true] call getMoveWeapon];
		player playMove _medicMove;

		waitUntil {sleep 0.1; animationState player == _medicMove || !CAN_PERFORM};
		waitUntil {sleep 0.1; animationState player != _medicMove || !CAN_PERFORM};

		if (CAN_PERFORM) then
		{
			_target setVariable ["FAR_isStabilized", 1, true];

			if (isPlayer _target) then
			{
				_target setVariable ["FAR_handleStabilize", true, true];
			}
			else // [Debugging] Code below is only relevant if revive script is enabled for AI
			{
				_target setDamage 0.25;
			};

			if !("Medikit" in items player) then
			{
				player removeItem "FirstAidKit";
			};
		};

		if (_target getVariable ["FAR_treatedBy", objNull] == player) then
		{
			_target setVariable ["FAR_treatedBy", nil, true];
		};
	};
}
call mf_compile;

////////////////////////////////////////////////
// Drag Injured Player
////////////////////////////////////////////////
FAR_Drag =
{
	if (primaryWeapon player == "") exitWith
	{
		titleText ["You need a primary weapon to be able to drag,\notherwise your player will freeze.\n(Arma 3 bug)", "PLAIN DOWN", 0.5];
	};

	FAR_isDragging = true;

	private ["_target", "_id"];
	_target = _this select 0;

	player playMoveNow "AcinPknlMstpSrasWrflDnon";

	_target attachTo [player, [0, 1.1, 0.092]];
	_target setDir 180;
	_target setVariable ["FAR_draggedBy", player, true];

	// Rotation fix
	FAR_isDragging_EH = _target;
	publicVariable "FAR_isDragging_EH";

	// Add release action and save its id so it can be removed
	_id = player addAction ["<t color='#C90000'>" + "Release" + "</t>", "addons\FAR_revive\FAR_handleAction.sqf", ["action_release"], 10];

	player globalChat "Press ""C"" if you can't move.";
	player selectWeapon primaryWeapon player;

	// Drag & Carry animation fix
	[] spawn
	{
		while {FAR_isDragging} do
		{
			_animState = animationState player;

			if (_animState == "AcinPknlMstpSrasWrflDnon_AcinPercMrunSrasWrflDnon" || _animState == "helper_switchtocarryrfl") then
			{
				[player, "AcinPknlMstpSrasWrflDnon"] call switchMoveGlobal;
			};

			if (currentWeapon player != primaryWeapon player) then
			{
				player selectWeapon primaryWeapon player;
			};

			sleep 0.5;
		};
	};

	// Wait until release action is used
	waitUntil {!alive player || UNCONSCIOUS(player) || !alive _target || !UNCONSCIOUS(_target) || !FAR_isDragging || isNull DRAGGED_BY(_target)};

	if (!isNull _target) then
	{
		detach _target;
		_target setVariable ["FAR_draggedBy", nil, true];
	};

	FAR_isDragging = false;
	player playMove format ["AmovPknlMstpSrasW%1Dnon", player call getMoveWeapon];
	player removeAction _id;
}
call mf_compile;

FAR_Release =
{
	FAR_isDragging = false;
}
call mf_compile;

////////////////////////////////////////////////
// Event handler for public variables
////////////////////////////////////////////////
FAR_public_EH =
{
	if(count _this < 2) exitWith {};

	_EH  = _this select 0;
	_value = _this select 1;

	// FAR_isDragging
	if (_EH == "FAR_isDragging_EH") then
	{
		_value setDir 180;
	};

	// FAR_deathMessage
	if (_EH == "FAR_deathMessage") then
	{
		_names = _value select 0;
		_unitName = _names select 0;
		_killerName = _names param [1, nil];
		_unit = objectFromNetId (_value select 1);

		if (alive _unit) then
		{
			if (isNil "_killerName") then
			{
				systemChat format ["%1 was injured", toString _unitName];
			}
			else
			{
				systemChat format ["%1 was injured by %2", toString _unitName, toString _killerName];
			};
		};
	};
}
call mf_compile;

////////////////////////////////////////////////
// Suicide Action Check
////////////////////////////////////////////////
FAR_Check_Suicide =
{
	UNCONSCIOUS(player)
}
call mf_compile;

////////////////////////////////////////////////
// Dragging Action Check
////////////////////////////////////////////////
FAR_Check_Dragging =
{
	_target = cursorTarget;

	if (isNull _target) exitWith {false};

	// Make sure player is alive and target is an injured unit
	if (!alive player || UNCONSCIOUS(player) || FAR_isDragging || isNil "_target" ||
	   {!alive _target || (!isPlayer _target && !FAR_Debugging) || (_target distance player > 2) || !isNull (_target getVariable ["FAR_treatedBy", objNull])}) exitWith
	{
		false
	};

	// Make sure target is unconscious
	UNCONSCIOUS(_target) && !DRAGGED(_target)
}
call mf_compile;

////////////////////////////////////////////////
// Stabilize Action Check
////////////////////////////////////////////////
FAR_Check_Stabilize =
{
	call FAR_Check_Dragging && {!STABILIZED(cursorTarget) && ({_x in ["FirstAidKit","Medikit"]} count items player > 0)}
}
call mf_compile;

////////////////////////////////////////////////
// Revive Action Check
////////////////////////////////////////////////
FAR_Check_Revive =
{
	call FAR_Check_Dragging && IS_MEDIC(player)
}
call mf_compile;

////////////////////////////////////////////////
// Show Nearby Friendly Medics
////////////////////////////////////////////////
FAR_IsFriendlyMedic =
{
	IS_MEDIC(_this) && !UNCONSCIOUS(_this) && side _this == playerSide && {playerSide in [BLUFOR,OPFOR] || group _this == group player}
}
call mf_compile;

FAR_CheckFriendlies =
{
	scopeName "FAR_CheckFriendlies";
	private ["_units", "_msg", "_medics", "_medicsText", "_dir", "_cardinal"];

	_units = player nearEntities ["AllVehicles", 1000];
	_msg = "<t underline='true'>Nearby medics</t>"; // Non-breaking space (Alt+255) between "nearby" and "medics", otherwise the underline is split between the 2 words
	_medics = [];
	_medicsText = "";

	{
		{
			if (alive _x && (_x != player) && (isPlayer _x || FAR_Debugging) && {_x call FAR_IsFriendlyMedic}) then
			{
				_medics pushBack _x;

				if (count _medics >= 7) then
				{
					breakTo "FAR_CheckFriendlies";
				};
			};
		} forEach crew _x;
	} forEach _units;

	[_medics, [], {(vehicle _x) distance player}, "ASCEND"] call BIS_fnc_sortBy;

	{
		_dir = [player, _x] call BIS_fnc_dirTo;
		_cardinal = switch (true) do
		{
			case (_dir >= 337.5): { "N" };
			case (_dir >= 292.5): { "NW" };
			case (_dir >= 247.5): { "W" };
			case (_dir >= 202.5): { "SW" };
			case (_dir >= 157.5): { "S" };
			case (_dir >= 112.5): { "SE" };
			case (_dir >= 67.5):  { "E" };
			case (_dir >= 22.5):  { "NE" };
			default               { "N" };
		};

		_medicsText = _medicsText + format ["<br/>%1 - %2m %3", name _x, floor ((vehicle _x) distance player), _cardinal];
	} forEach _medics;

	_msg + (if (_medicsText == "") then { "<br/>- none -" } else { _medicsText })
}
call mf_compile;
