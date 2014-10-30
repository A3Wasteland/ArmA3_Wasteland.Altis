// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: removeDisabledMissions.sqf
//	@file Author: AgentRev

private ["_missionsArray", "_missionTypes", "_publicVar", "_disabledMissions", "_i", "_mission"];

_missionsArray = _this select 0;
_missionTypes = _this select 1;

/* _missionTypes array example:
[
	[
		"A3W_heliPatrolMissions", // Name of the public variable which determines if the following missions are to be disabled (must evaluate to 0 or 1)
		[
			// List of missions to disable
			"mission_Coastal_Convoy",
			"mission_HostileHeliFormation"
		]
	],
	[
		"A3W_underWaterMissions",
		[
			"mission_ArmedDiversquad"
		]
	]
]
*/

{
	_publicVar = _x select 0;
	_disabledMissions = _x select 1;

	// Reverse scan of missions array to remove types disabled according to public var
	for "_i" from (count _missionsArray - 1) to 0 step -1 do
	{
		_mission = _missionsArray select _i;
		if (typeName _mission == "ARRAY") then { _mission = _mission select 0 };

		if ({_mission == _x} count _disabledMissions > 0 && {!([_publicVar] call isConfigOn)}) then
		{
			_missionsArray deleteAt _i;
		};
	};
} forEach _missionTypes;

_missionsArray
