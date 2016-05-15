// ****************************************************************************************
// * This addon is licensed under the GNU Lesser GPL v3. Copyright © 2016 A3Wasteland.com *
// ****************************************************************************************
//	@file Name: disconnectCleanup.sqf
//	@file Author: AgentRev

#include "defines.sqf"

params [["_uid","",[""]]];

if (_uid isEqualTo "") exitWith {};
private "_dummy";

{
	if (_x isKindOf "TimeBombCore") then
	{
		_dummy = attachedTo _x;

		if (_dummy isKindOf STICKY_CHARGE_DUMMY_OBJ && _dummy getVariable ["A3W_stickyCharges_isDummy", false]) then
		{
			if (_dummy getVariable ["A3W_stickyCharges_ownerUID",""] isEqualTo _uid) then
			{
				deleteVehicle _x;
				deleteVehicle _dummy;
			};
		};
	};
} forEach allMines;
