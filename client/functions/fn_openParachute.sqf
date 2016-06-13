// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_openParachute.sqf
//	@file Author: AgentRev

// make sure no crewed helicopters are within 10m, otherwise some will explode on contact with the parachute
#define PARACHUTE_PRECHECK ({player distance _x < 10 max sizeOf typeOf _x && count crew _x > 0} count (player nearEntities ["Helicopter_Base_F", 20]) == 0)

// unschedule asap
if (canSuspend) exitWith
{
	[0, A3W_fnc_openParachute] execFSM "call.fsm";
};

if (!alive player || vehicle player != player) exitWith {};

if (PARACHUTE_PRECHECK) then A3W_fnc_forceOpenParachute
else
{
	if (!isNil "A3W_openParachute_frameCheck") then
	{
		removeMissionEventHandler ["EachFrame", A3W_openParachute_frameCheck];
		A3W_openParachute_frameCheck = nil;
	};

	A3W_openParachute_frameCheck = addMissionEventHandler ["EachFrame", 
	{
		if (!isNil "A3W_openParachute_frameCheck" && {PARACHUTE_PRECHECK}) then
		{
			call A3W_fnc_forceOpenParachute;
			removeMissionEventHandler ["EachFrame", A3W_openParachute_frameCheck];
			A3W_openParachute_frameCheck = nil;
		};
	}];
};
