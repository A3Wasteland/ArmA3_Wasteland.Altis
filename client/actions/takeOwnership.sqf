// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2016 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: takeOwnership.sqf
//	@file Author: MercyfulFate, AgentRev
//	@file Description: Acquire the nearest vehicle

#define DURATION 60
#define ANIMATION "AinvPknlMstpSlayWrflDnon_medic"

private _vehicle = ["LandVehicle", "Air", "Ship"] call mf_nearest_vehicle;
private _checks =
{
	params ["_progress", "_vehicle"];
	private _failed = true;
	private _text = _vehicle call fn_canTakeOwnership;

	if (_text isEqualTo "") then
	{
		_text = format ["Acquiring %1%2 complete", round (100 * _progress), "%"];
		_failed = false;
	};

	[_failed, _text]
};

private _success = [[DURATION, 5] select (_vehicle getVariable ["ownerUID","0"] isEqualTo getPlayerUID player), ANIMATION, _checks, [_vehicle]] call a3w_actions_start;

if (_success) then
{
	[_vehicle, player] call A3W_fnc_takeOwnership;
	["Acquiring complete!", 5] call mf_notify_client;
};

_success
