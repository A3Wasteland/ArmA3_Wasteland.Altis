// ****************************************************************************************
// * This addon is licensed under the GNU Lesser GPL v3. Copyright © 2016 A3Wasteland.com *
// ****************************************************************************************
//	@file Name: killedCleanup.sqf
//	@file Author: AgentRev

#include "defines.sqf"

params [["_unit",objNull,[objNull]]];

if (isNull _unit) exitWith {};
private "_dummy";

{
	if (_x isKindOf "TimeBombCore") then
	{
		_dummy = attachedTo _x;

		if (_dummy isKindOf STICKY_CHARGE_DUMMY_OBJ && _dummy getVariable ["A3W_stickyCharges_isDummy", false]) then
		{
			if (_dummy getVariable ["A3W_stickyCharges_ownerUnit",objNull] isEqualTo _unit) then
			{
				deleteVehicle _x;
				deleteVehicle _dummy;
			};
		};
	};
} forEach detectedMines side group _unit;
