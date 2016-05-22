// ****************************************************************************************
// * This addon is licensed under the GNU Lesser GPL v3. Copyright © 2016 A3Wasteland.com *
// ****************************************************************************************
//	@file Name: dummyCleanup.sqf
//	@file Author: AgentRev

#include "defines.sqf"
#define SLEEP_REALTIME(SECS) if (hasInterface) then { sleep (SECS) } else { uiSleep (SECS) }

while {true} do
{
	SLEEP_REALTIME(5*60);

	{
		_linkedBomb = _x getVariable ["A3W_stickyCharges_linkedBomb",0];

		if (_linkedBomb isEqualType objNull && {!mineActive _linkedBomb}) then
		{
			deleteVehicle _x;
		};

		sleep 0.01;
	} forEach allMissionObjects STICKY_CHARGE_DUMMY_OBJ;
};
