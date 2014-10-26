// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: canPushPlaneBack.sqf
//	@file Author: AgentRev

private ["_isDriver", "_veh", "_uav", "_uavCtrl"];
_isDriver = false;
_veh = objNull;

switch (_this select 0) do
{
	case 0:
	{
		_veh = vehicle player;

		if (driver _veh == player) then
		{
			_isDriver = true;
		};

		_uav = getConnectedUav player;

		if (!isNull _uav && {_uav isKindOf "Plane" && isNil {_uav getVariable "uavAction_pushPlane"}}) then
		{
			_uav setVariable ["uavAction_pushPlane", [_uav, ["[1, _target]"] call getPushPlaneAction] call fn_addManagedAction];
		};
	};
	case 1:
	{
		_uav = _this select 1;
		_uavCtrl = uavControl _uav;

		if (_uavCtrl select 0 == player && {_uavCtrl select 1 == "DRIVER"}) then
		{
			_veh = _uav;
			_isDriver = true;
		};
	};
};

(
	_veh != player &&
	_isDriver &&
	isEngineOn _veh &&
	{isTouchingGround _veh} &&
	{_veh isKindOf "Plane"} &&
	{vectorMagnitude velocity _veh <= 10} &&
	{_veh call getFwdVelocity < 0.1}
)
