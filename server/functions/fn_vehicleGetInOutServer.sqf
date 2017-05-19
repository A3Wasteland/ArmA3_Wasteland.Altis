// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2017 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_vehicleGetInOutServer.sqf
//	@file Author: AgentRev

params ["_vehicle", "_seat", "_unit"];

_unit setVariable ["lastVehicleRidden", netId _vehicle, true];

if (isPlayer _unit && owner _vehicle == owner _unit) then
{
	_vehicle setVariable ["lastVehicleOwnerUID", getPlayerUID _unit, true];
};

_vehicle setVariable ["vehSaving_hoursUnused", 0];
_vehicle setVariable ["vehSaving_lastUse", diag_tickTime];

{
	if (isAgent teamMember _x) then
	{
		_assistOwner = _x getVariable ["A3W_driverAssistOwner", objNull];

		if (isNull _assistOwner || _unit == _assistOwner) then
		{
			if (driver _vehicle == _x && lockedDriver _vehicle) then
			{
				[_vehicle, false] remoteExecCall ["lockDriver", _vehicle];
			};

			deleteVehicle _x;
		};
	};
} forEach crew _vehicle;
