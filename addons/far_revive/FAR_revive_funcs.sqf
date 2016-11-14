// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
#include "FAR_defines.sqf"

#define FAR_Max_Distance 2.5

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
			["<t color='#FF0000'>" + "Finish off" + "</t>", "addons\FAR_revive\FAR_handleAction.sqf", ["action_slay"], 101, true, true, "", FAR_Check_Slay],
			["<t color='#00FF00'>" + "Revive" + "</t>", "addons\FAR_revive\FAR_handleAction.sqf", ["action_revive"], 100, true, true, "", FAR_Check_Revive],
			["<t color='#00FF00'>" + "Stabilize" + "</t>", "addons\FAR_revive\FAR_handleAction.sqf", ["action_stabilize"], 99, true, true, "", FAR_Check_Stabilize],
			["<t color='#FFFF00'>" + "Drag" + "</t>", "addons\FAR_revive\FAR_handleAction.sqf", ["action_drag"], 98, true, true, "", FAR_Check_Dragging],
			["<t color='#FFFF00'>" + "Eject injured units from vehicle" + "</t>", "addons\FAR_revive\FAR_handleAction.sqf", ["action_eject"], 5.2, false, true, "", FAR_Check_Eject_Injured]
		];
	};
}
call mf_compile;

////////////////////////////////////////////////
// Handle Death
////////////////////////////////////////////////
FAR_HandleDamage_EH = "addons\far_revive\FAR_HandleDamage_EH.sqf" call mf_compile;
//FAR_fnc_headshotHitPartEH = "addons\far_revive\FAR_headshotHitPartEH.sqf" call mf_compile;

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
	[_this select 0, true] call FAR_HandleTreating;
}
call mf_compile;

////////////////////////////////////////////////
// Stabilize Player
////////////////////////////////////////////////
FAR_HandleStabilize =
{
	[_this select 0, false] call FAR_HandleTreating;
}
call mf_compile;

////////////////////////////////////////////////
// Revive or Stabilize Player
////////////////////////////////////////////////
FAR_HandleTreating =
{
	private "_treatThread";
	_treatThread = _this spawn
	{
		params ["_target", ["_revive",false]]; // _revive false = stabilize
		private "_medicMove";

		if (alive _target) then
		{
			_target setVariable ["FAR_treatedBy", player, true];
			player setVariable ["FAR_isTreating", _target];

			_medicMove = format ["AinvPknlMstpSlayW%1Dnon_medic", [player, true] call getMoveWeapon];
			player playMove _medicMove;

			waitUntil {sleep 0.1; animationState player == _medicMove || !CAN_PERFORM};
			waitUntil {sleep 0.1; animationState player != _medicMove || !CAN_PERFORM};

			if (CAN_PERFORM) then
			{
				if (_revive) then
				{
					_target setVariable ["FAR_isUnconscious", 0, true];
					[player, "reviveCount", 1] call fn_addScore;
				}
				else
				{
					_target setVariable ["FAR_isStabilized", 1, true];
					_target setVariable ["FAR_handleStabilize", true, true];
				};

				if !("Medikit" in items player) then
				{
					player removeItem "FirstAidKit";
				};
			};

			if (TREATED_BY(_target) == player) then
			{
				_target setVariable ["FAR_treatedBy", nil, true];
			};
		};
	};

	waitUntil {scriptDone _treatThread};
	player setVariable ["FAR_isTreating", nil];
}
call mf_compile;


#define IS_DRAGGING_UNIT(UNIT) (alive player && |UNCONSCIOUS(player) && alive UNIT && UNCONSCIOUS(UNIT) && FAR_isDragging && DRAGGED_BY(UNIT) == player)

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

	private ["_target", "_actions"];
	_target = _this select 0;

	player playMoveNow "AcinPknlMstpSrasWrflDnon";

	_target attachTo [player, [0, 1.1, 0.092]];
	_target setVariable ["FAR_draggedBy", player, true];
	player setVariable ["FAR_isDragging", _target];

	// Rotation fix
	if (local _target) then
	{
		["FAR_isDragging_EH", _target] call FAR_public_EH;
	}
	else
	{
		["FAR_isDragging_EH", _target] remoteExecCall ["FAR_fnc_public_EH", _target];
	};

	// Add release action and save its id so it can be removed
	_actions =
	[
		[player, ["<t color='#FFFF00'>" + "Load unit in vehicle" + "</t>", "addons\FAR_revive\FAR_handleAction.sqf", ["action_load"], 103, true, true, "", FAR_Check_Load_Dragged]] call fn_addManagedAction,
		player addAction ["<t color='#FF0000'>" + "Release" + "</t>", "addons\FAR_revive\FAR_handleAction.sqf", ["action_release"], 102]
	];

	titleText [format ["Press %1 (%2) if you can't move back.", (actionKeysNamesArray "TactToggle") param [0,"<UNDEFINED>"], actionName "TactToggle"], "PLAIN DOWN", 0.5];
	player selectWeapon primaryWeapon player;

	// Drag & Carry animation fix
	[] spawn
	{
		while {FAR_isDragging} do
		{
			if (vehicle player == player) then
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
			};

			sleep 0.5;
		};
	};

	// Wait until release action is used
	waitUntil {!alive player || UNCONSCIOUS(player) || !alive _target || !UNCONSCIOUS(_target) || !FAR_isDragging || isNull DRAGGED_BY(_target)};

	if (!isNull _target) then
	{
		if (!isNull attachedTo _target) then { detach _target };;
		_target setVariable ["FAR_draggedBy", nil, true];
	};

	FAR_isDragging = false;
	player setVariable ["FAR_isDragging", objNull];
	if (vehicle player == player) then { player playMove "AmovPknlMstpSrasWrflDnon" };
	{ [player, _x] call fn_removeManagedAction } forEach _actions;
}
call mf_compile;

FAR_Release =
{
	FAR_isDragging = false;
}
call mf_compile;

FAR_Drag_Load_Vehicle =
{
	params [["_veh",cursorTarget]];
	private "_draggedUnit";
	_draggedUnit = player getVariable ["FAR_isDragging", objNull];

	if (alive player && alive _draggedUnit && attachedTo _draggedUnit == player) then
	{
		FAR_isDragging = false;

		if ([_draggedUnit, _veh, true] call fn_canGetIn) then
		{
			_draggedUnit setVariable ["FAR_cancelAutoEject", true, true];
			detach _draggedUnit;
			[_draggedUnit, _veh, true] call A3W_fnc_getInFast;
		};
	};
}
call mf_compile;

FAR_Eject_Injured =
{
	params [["_veh",cursorTarget]];

	{
		if (UNCONSCIOUS(_x) && [_x, player] call A3W_fnc_isFriendly) then
		{
			moveOut _x;
			unassignVehicle _x;
		};
	} forEach crew _veh;
}
call mf_compile;

FAR_Slay_Target =
{
	private "_target";
	_target = call FAR_FindTarget;

	if ([_target] call FAR_Check_Slay) then
	{
		["FAR_slayTarget", [_target, player]] remoteExecCall ["FAR_fnc_public_EH", _target];
	};
}
call mf_compile;

////////////////////////////////////////////////
// Event handler for public variables
////////////////////////////////////////////////
FAR_public_EH =
{
	params ["_EH", "_value"];

	switch (_EH) do
	{
		case "FAR_isDragging_EH":
		{
			if (local _value) then
			{
				_value setDir 180;
				_value spawn // fix for hovering on release
				{
					_unit = _this;
					waitUntil {sleep 0.1; !alive _unit || vehicle _unit != _unit || isNull attachedTo _unit};

					if (alive _unit && vehicle _unit == _unit && isNull attachedTo _unit) then
					{
						_unit setVelocity velocity _unit;
					};
				};
			};
		};

		case "FAR_deathMessage":
		{
			_value params [["_unit",objNull,[objNull]], ["_unitName",[],[[]]], ["_killerName",[],[[]]], ["_friendlyFire",false,[false]]];

			if (alive _unit && !(_unitName isEqualTo [])) then
			{
				if (_killerName isEqualTo []) then
				{
					systemChat format ["%1 was injured", toString _unitName];
				}
				else
				{
					systemChat format ["%1 injured %2%3", toString _killerName, toString _unitName, [""," (friendly fire)"] select _friendlyFire];
				};
			};
		};

		case "FAR_slayTarget":
		{
			_value params [["_victim",objNull,[objNull]], ["_killer",objNull,[objNull]]];

			if (local _victim) then
			{
				if (alive _victim && {!isNull _killer && _killer distance _victim <= FAR_Max_Distance}) then
				{
					_victim setVariable ["A3W_deathCause_local", ["slay",nil,_killer]];
					_victim setDamage 1;
				};
			}
			else
			{
				_this remoteExecCall ["FAR_fnc_public_EH", _victim];
			};
		};
	};
}
call mf_compile;

FAR_fnc_public_EH = FAR_public_EH;

////////////////////////////////////////////////
// Suicide Action Check
////////////////////////////////////////////////
FAR_Check_Suicide =
{
	UNCONSCIOUS(player)
}
call mf_compile;

#define ABDOMEN_ASL(UNIT) (AGLtoASL (UNIT modelToWorldVisual (UNIT selectionPosition "spine1")))
#define FAR_Target_INVALID(TARGET) (!alive TARGET || (!isPlayer TARGET && !FAR_Debugging) || TARGET distance player > FAR_Max_Distance || !UNCONSCIOUS(TARGET) || BEING_TREATED(TARGET) || DRAGGED(TARGET) || \
(TARGET != cursorTarget && {!(lineIntersectsObjs [ABDOMEN_ASL(player), ABDOMEN_ASL(TARGET), TARGET, player, false, 4] isEqualTo [])}))

// lineIntersectsObjs is to check whether or not there is a wall between an imaginary line that goes from the medic's abdomen to the target's abdomen, if the target is not being aimed at directly

////////////////////////////////////////////////
// Find target for actions
////////////////////////////////////////////////
FAR_FindTarget =
{
	private ["_target", "_unit"];
	_target = cursorTarget;

	if (FAR_Target_INVALID(_target)) then
	{
		_target = objNull;

		{
			_unit = _x;
			_relDir = player getRelDir _unit;
			if (_relDir > 180) then { _relDir = _relDir - 360 };

			if (abs _relDir < 45 && {!FAR_Target_INVALID(_unit)}) exitWith // medic must have target visible within a 90° horizontal FoV
			{
				_target = _unit;
			};
		} forEach ((player modelToWorldVisual [0,0,0]) nearEntities ["CAManBase", FAR_Max_Distance]);
	};

	_target
}
call mf_compile;

////////////////////////////////////////////////
// Dragging Action Check
////////////////////////////////////////////////
FAR_Check_Dragging =
{
	// Make sure player is alive and target is an injured unit
	(alive player && !UNCONSCIOUS(player) && !IS_TREATING(player) && !FAR_isDragging && !isNull call FAR_FindTarget)
}
call mf_compile;

////////////////////////////////////////////////
// Stabilize Action Check
////////////////////////////////////////////////
FAR_Check_Stabilize =
{
	private _target = call FAR_FindTarget;

	// do not show Stabilize if Revive is shown, unless target is enemy
	(!IS_MEDIC(player) || !([player, _target] call A3W_fnc_isFriendly)) && FAR_Check_Dragging && {!STABILIZED(_target) && !(["FirstAidKit","Medikit"] arrayIntersect items player isEqualTo [])}
}
call mf_compile;

////////////////////////////////////////////////
// Revive Action Check
////////////////////////////////////////////////
FAR_Check_Revive =
{
	private _target = call FAR_FindTarget;

	// do not show Revive if target is enemy
	IS_MEDIC(player) && [player, _target] call A3W_fnc_isFriendly && FAR_Check_Dragging
}
call mf_compile;

////////////////////////////////////////////////
// Slay Action Check
////////////////////////////////////////////////
FAR_Check_Slay =
{
	private _target = if (_this isEqualType []) then { param [0,objNull,[objNull]] } else { call FAR_FindTarget }; // if not array then it's an addAction condition check

	!([_target, player] call A3W_fnc_isFriendly) && FAR_Check_Dragging
}
call mf_compile;

////////////////////////////////////////////////
// Load Dragged Action Check
////////////////////////////////////////////////
FAR_Check_Load_Dragged =
{
	private ["_veh", "_draggedUnit"];
	_veh = cursorTarget;
	_draggedUnit = player getVariable ["FAR_isDragging", objNull];

	player distance _veh <= (sizeOf typeOf _veh / 3) max 2 && [_draggedUnit, _veh, true] call fn_canGetIn && [_draggedUnit, player] call A3W_fnc_isFriendly
}
call mf_compile;

////////////////////////////////////////////////
// Eject Injured Action Check
////////////////////////////////////////////////
FAR_Check_Eject_Injured =
{
	private "_veh";
	_veh = cursorTarget;

	player distance _veh <= (sizeOf typeOf _veh / 3) max 2 && !(_veh isKindOf "Man") && {{UNCONSCIOUS(_x) && [_x, player] call A3W_fnc_isFriendly} count crew _veh > 0}
}
call mf_compile;


////////////////////////////////////////////////
// Show Nearby Friendly Medics
////////////////////////////////////////////////
FAR_IsFriendlyMedic =
{
	IS_MEDIC(_this) && !UNCONSCIOUS(_this) && [_this, player] call A3W_fnc_isFriendly
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
