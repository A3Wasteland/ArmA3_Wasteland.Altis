// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2016 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: lockPick.sqf
//	@file Author: MercyfulFate, AgentRev, Gigatek
//	@file Description: Lockpick the nearest vehicle

#define DURATION 150
#define ANIMATION "AinvPknlMstpSlayWrflDnon_medic"

#define FORMAT2(STR1,STR2) format ["%1 %2", STR1, STR2]
#define ERR_FAILED "Lockpicking failed!"
#define ERR_IN_VEHICLE "You can't do that in a vehicle."
#define ERR_DISTANCE "You are too far away from the vehicle."
#define ERR_MOVED "Somebody moved the vehicle."
#define ERR_TOWED "Somebody towed or lifted the vehicle."
#define ERR_UNLOCKED "The vehicle is unlocked."
#define ERR_CREW "Somebody is inside the vehicle."
#define ERR_DESTROYED "The vehicle is destroyed."
#define ERR_CANCELLED "Lockpicking cancelled!"

private _vehicle = ["LandVehicle", "Air", "Ship"] call mf_nearest_vehicle;
private _checks =
{
	params ["_progress", "_vehicle"];
	private _failed = true;
	private _text = "";

	switch (true) do
	{
		case (!alive player): {}; // player is dead, no need for a notification
		case (vehicle player != player): { _text = FORMAT2(ERR_FAILED, ERR_IN_VEHICLE) };
		case (!alive _vehicle): { _text = FORMAT2(ERR_FAILED, ERR_DESTROYED) };
		case (locked _vehicle < 2): { _text = FORMAT2(ERR_FAILED, ERR_UNLOCKED) };
		case ({alive _x} count crew _vehicle > 0): { _text = FORMAT2(ERR_FAILED, ERR_CREW) };
		//case (!isNull (_vehicle getVariable ["R3F_LOG_est_deplace_par", objNull])): { _text = FORMAT2(ERR_FAILED, ERR_MOVED) };
		//case (!isNull (_vehicle getVariable ["R3F_LOG_est_transporte_par", objNull])): { _text = FORMAT2(ERR_FAILED, ERR_TOWED) };
		case (player distance _vehicle > (sizeOf typeOf _vehicle / 3) max 3): { _text = FORMAT2(ERR_FAILED, ERR_DISTANCE) };
		case (doCancelAction): { _text = ERR_CANCELLED; doCancelAction = false };
		default
		{
			_text = format ["Lockpicking %1%2 complete", round(100 * _progress), "%"];
			_failed = false;
		};
	};

	[_failed, _text]
};

private _success = [DURATION, ANIMATION, _checks, [_vehicle]] call a3w_actions_start;

if (_success) then
{
	[_vehicle, 1] call A3W_fnc_setLockState; // Unlock
	_vehicle call fn_forceSaveVehicle;
	["Lockpicking complete!", 5] call mf_notify_client;
};

_success
