// ****************************************************************************************
// * This addon is licensed under the GNU Lesser GPL v3. Copyright © 2016 A3Wasteland.com *
// ****************************************************************************************
//	@file Name: initVecDirUp.sqf
//	@file Author: AgentRev

#include "defines.sqf"

{
	_vecDirUp = _x getVariable ["A3W_stickyCharges_vecDirUp",0];

	if (_vecDirUp isEqualType [] && {_vecDirUp isEqualTypeAll []}) then
	{
		_linkedBomb = _x getVariable ["A3W_stickyCharges_linkedBomb",0];

		if (_linkedBomb isEqualType objNull && {_linkedBomb isKindOf "TimeBombCore"}) then
		{
			_linkedBomb setVectorDirAndUp _vecDirUp;
			_linkedBomb setVectorUp (_vecDirUp select 1); // vectorUp must be set again for the bomb to be oriented correctly when attached
		};
	};

	sleep 0.01;
} forEach allMissionObjects STICKY_CHARGE_DUMMY_OBJ;
