// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2015 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_resupplyTruck.sqf
//	@file Author: Cael187, Lodac

// Check if mutex lock is active.
if (mutexScriptInProgress) exitWith
{
	["You are already performing another action.", 5] call mf_notify_client;
};

private ["_vehicle", "_vehClass", "_checks", "_firstCheck", "_time", "_success", "_break"];
_vehicle = cursorTarget;
_vehClass = typeOf _vehicle;
_break = floor (random 100);

if (_break < 1) then
{
	hint "Your ToolKit broke";	
	player removeItem "ToolKit";
};

if (isNull _vehicle) exitWith {};

_checks =
{
	private ["_progress", "_object", "_failed", "_text"];
	_progress = _this select 0;
	_object = _this select 1;
	_failed = true;
	
	switch (true) do
	{
		case (!alive player): { _text = "" };
		case (vehicle player != player): { _text = "Action failed! You can't do this in a vehicle" };
		case (player distance _object > (sizeOf typeOf _object / 3) max 2): { _text = "Action failed! You are too far away from the object" };
		case (isNull _object): { _text = "The object no longer exists" };
		//case (alive _object || {alive _x} count crew _object > 0): { _text = "Action failed! You are not allowed to break into this object" };
		case (!isNull (_object getVariable ["R3F_LOG_est_deplace_par", objNull])): { _text = "Action failed! Somebody moved the object" };
		case (!isNull (_object getVariable ["R3F_LOG_est_transporte_par", objNull])): { _text = "Action failed! Somebody loaded or towed the object" };
		case (doCancelAction): { doCancelAction = false; _text = "break in cancelled" };
		default
		{
			_failed = false;
			_text = format ["Breaking in %1%2 complete", floor (_progress * 100), "%"];
		};
	};

	[_failed, _text];
};

_firstCheck = [0, _vehicle] call _checks;

if (_firstCheck select 0) exitWith
{
	[_firstCheck select 1, 5] call mf_notify_client;
};

mutexScriptInProgress = true;

switch (true) do
{
	case (_vehClass isKindOf "Plane_Base_F"): // Planes (UAV_02 is not in Plane_Base_F)
	{
		_time = 60;
	};
	case (_vehClass isKindOf "Tank"): // Tanks & IFVs
	{
		_time = 60;
	};
	case (_vehClass isKindOf "Helicopter_Base_F" && !(_vehClass isKindOf "UAV_01_base_F")): // Helicopters (except UAV_01)
	{
		_time = 55;
	};
	case (_vehClass isKindOf "Wheeled_APC_F"): // Wheeled APCs
	{
		_time = 50;
	};
	case (_vehClass isKindOf "Truck_F" && !(_vehClass isKindOf "Van_01_base_F")): // Trucks (except Vans)
	{
		_time = 50;
	};
	case ({_vehClass isKindOf _x} count ["MRAP_01_base_F", "MRAP_02_base_F", "MRAP_03_base_F", "UAV_02_base_F"] > 0): // MRAPs and UAV_02
	{
		_time = 45;
	};
	case (_vehClass isKindOf "Boat_Armed_01_base_F"): // Speedboats
	{
		_time = 40;
	};
	case ({_vehClass isKindOf _x} count ["Quadbike_01_base_F", "Kart_01_Base_F", "Rubber_duck_base_F", "UAV_01_base_F"] > 0): // Quadbikes, karts, rubber boats, UAV_01
	{
		_time = 35;
	};
	default // Everything else
	{
		_time = 25;
	};
};

_success = [_time, format ["AinvPknlMstpSlayW%1Dnon_medic", [player, true] call getMoveWeapon], _checks, [_vehicle]] call a3w_actions_start;

mutexScriptInProgress = false;

if (_success) then
{
	if (local _vehicle) then
	{
		_vehicle lock 1;
	}
	else
	{
		[[netId _vehicle, 1], "A3W_fnc_setLockState", _vehicle] call A3W_fnc_MP; // Unlock
	};

	_vehicle setVariable ["objectLocked", false, true]; 
	_vehicle setVariable ["R3F_LOG_disabled",false,true];
	_vehicle setVariable ["ownerUID", getPlayerUID player, true];
	_vehicle engineOn true;
	["You have broke in and hot-wired successfully", 5] call mf_notify_client;
};