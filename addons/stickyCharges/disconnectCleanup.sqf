// ****************************************************************************************
// * This addon is licensed under the GNU Lesser GPL v3. Copyright © 2016 A3Wasteland.com *
// ****************************************************************************************
//	@file Name: disconnectCleanup.sqf
//	@file Author: AgentRev

#include "defines.sqf"

// A player's bomb timers and detonators are cleared on disconnect, so we can delete all its "PipeBombBase" explosives since they are now useless

params [["_uid","",[""]]];
if (_uid isEqualTo "") exitWith {};

private "_linkedBomb";

{
	_linkedBomb = _x getVariable ["A3W_stickyCharges_linkedBomb",0];

	if (_linkedBomb isEqualType objNull && {_linkedBomb isKindOf "PipeBombBase"}) then
	{
		if (mineActive _linkedBomb) then
		{
			deleteVehicle _linkedBomb;
		};

		deleteVehicle _x;
	};
} forEach ((allMissionObjects STICKY_CHARGE_DUMMY_OBJ) select {_x getVariable ["A3W_stickyCharges_ownerUID",0] isEqualTo _uid});
