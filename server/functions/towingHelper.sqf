// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: towingHelper.sqf
//	@file Author: AgentRev

private ["_type", "_veh", "_pos"];

_type = param [0, "", [""]];
_veh = param [1, objNull, ["",objNull]];

if (typeName _veh == "STRING") then
{
	_veh = objectFromNetId _veh;
};

if (!local _veh) exitWith {};

switch (_type) do
{
	case "detach":
	{
		_veh enableSimulation true;
		(attachedTo _veh) enableSimulation true;

		sleep 0.3;
		detach _veh;

		_veh lockDriver false;
		_veh enableCopilot true;

		_pos = getPosATL _veh;

		if (_pos select 2 < 0) then
		{
			_pos set [2, 1];
			_veh setPosATL _pos;
		};
	};
	case "lockDriver":
	{
		_veh lockDriver true;
	};
	case "disableDriving":
	{
		_veh lockDriver true;
		_veh enableCopilot false;
		_veh engineOn false;
	};
};
