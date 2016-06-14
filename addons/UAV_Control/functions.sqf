//	@file Name: functions.sqf
//	@file Author: IvanMMM, micovery, AgentRev

private ["_perm", "_uav"];
_perm = ["A3W_uavControl", "side"] call getPublicVar;

if (_perm == "side") exitWith {};


while {true} do
{
	waitUntil {sleep 0.1; _uav = getConnectedUAV player; !isNull _uav};

	// ignore remote designators
	if !(_uav isKindOf "StaticWeapon") then
	{
		_ownerUID = _uav getVariable ["ownerUID", "0"];

		if (_ownerUID in ["","0"]) exitWith {}; // UAV not owned by anyone

		_ownerGroup = _uav getVariable ["ownerGroupUAV", grpNull];

		if (getPlayerUID player == _ownerUID) exitWith
		{
			if (_ownerGroup != group player) then
			{
				_ownerGroup = group player;
				_uav setVariable ["ownerGroupUAV", _ownerGroup, true]; // not currently used
			};
		};

		if (_perm == "group" && {_ownerUID in ((units player) apply {getPlayerUID _x})}) exitWith {};

		player connectTerminalToUAV objNull;
		playSound "FD_CP_Not_Clear_F";
		["You are not allowed to connect to this unmanned vehicle.", 5] call mf_notify_client;
	};

	waitUntil {sleep 0.1; _uav != getConnectedUAV player};
};
