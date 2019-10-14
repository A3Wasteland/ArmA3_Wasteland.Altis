//	@file Name: functions.sqf
//	@file Author: IvanMMM, micovery, AgentRev

private ["_perm", "_uav", "_currUav"];
_perm = ["A3W_uavControl", "side"] call getPublicVar;

if (_perm == "side" && !(playerSide in [BLUFOR,OPFOR])) then
{
	_perm = "group"; // always enforce group-only for indies if A3W_uavControl is side
};

while {true} do
{
	waitUntil {_uav = getConnectedUAV player; !isNull _uav};

	// ignore remote designators and autoturrets unless indie
	if (!(_uav isKindOf "StaticWeapon") || !(playerSide in [BLUFOR,OPFOR])) then
	{
		_ownerUID = _uav getVariable ["ownerUID", "0"];

		if (_ownerUID in ["","0"]) exitWith {}; // UAV not owned by anyone

		_ownerGroup = _uav getVariable ["ownerGroupUAV", grpNull];

		if (getPlayerUID player isEqualTo _ownerUID) exitWith
		{
			if (_ownerGroup != group player) then
			{
				_ownerGroup = group player;
				_uav setVariable ["ownerGroupUAV", _ownerGroup, true]; // not currently used
			};
		};

		if (_perm == "group" && {_ownerUID in ((units player) apply {getPlayerUID _x})}) exitWith {};

		_uav = objNull;
		player connectTerminalToUAV objNull;
		playSound "FD_CP_Not_Clear_F";
		["You are not allowed to connect to this unmanned vehicle.", 5] call mf_notify_client;
	};

	if (alive _uav && _uav == getConnectedUAV player) then
	{
		/*if (group _currUav != group player) then
		{
			(crew _currUav) joinSilent group player;
		};*/

		[_uav, true] call getInVehicle;

		if !(_uav getVariable ["A3W_skipAutoSave", false]) then
		{
			if (_uav isKindOf "AllVehicles" && !(_uav isKindOf "StaticWeapon")) then
			{
				if (!isNil "fn_forceSaveVehicle") then { _uav call fn_forceSaveVehicle };
			}
			else
			{
				if (!isNil "fn_forceSaveObject") then { _uav call fn_forceSaveObject };
			};
		};

		// medical UAV setup
		if (isNil {_uav getVariable "FAR_uavReviveAction"}) then
		{
			if (round getNumber (configFile >> "CfgVehicles" >> typeOf _uav >> "attendant") > 0 && !isNil "FAR_Check_Revive") then
			{
				_uav setVariable ["FAR_uavReviveAction", _uav addAction ["<t color='#00FF00'>" + "Revive" + "</t>", "addons\FAR_revive\FAR_handleAction.sqf", ["action_revive"], 100, true, true, "", "_target == vehicle _this && FAR_Check_Revive"]]; // _target = UAV, _this = UAV_AI
			}
			else
			{
				_uav setVariable ["FAR_uavReviveAction", -1];
			};
		};
	};

	waitUntil {_uav != getConnectedUAV player};

	if (!isNull _uav) then
	{
		_uav call getOutVehicle;
		_uav removeAction (_uav getVariable ["FAR_uavReviveAction", -1]);
	};
};
