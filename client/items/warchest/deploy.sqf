// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
#define DURATION MF_ITEMS_WARCHEST_DEPLOY_DURATION
#define ANIMATION "AinvPknlMstpSlayWrflDnon_medic"
#define ERR_IN_VEHICLE "Deploying Warchest Failed! You can't do that in a vehicle."
#define ERR_CANCELLED "Deploying Warchest Cancelled!"
#define ERR_TOO_FAR_AWAY "Deploying Warchest Failed! You are too far way."
#define ERR_NOT_EAST_WEST "Deploying Warchest Failed! Independants don't have access to warchests yet."

private "_checks";
_checks = {
	private ["_progress","_position","_failed", "_text"];
	_progress = _this select 0;
	_position = _this select 1;
	_text = "";
	_failed = true;
	switch (true) do {
		case (!alive player): {}; //player dead, not need to notify them
		case !(playerSide in [EAST,WEST]) : {_text = ERR_NOT_EAST_WEST};
		case (vehicle player != player): {_text = ERR_IN_VEHICLE};
		case (player distance _position > 3): {_text = ERR_TOO_FAR_AWAY};
		case (doCancelAction): {_text = ERR_CANCELLED; doCancelAction = false;};
		default {
			_text = format["Warchest %1%2 Deployed", round(100 * _progress), "%"];
			_failed = false;
		};
	};
	[_failed, _text];
};

private ["_success", "_warchest", "_hackAction", "_accessAction"];
_success = [DURATION, ANIMATION, _checks, [getPosATL player]] call a3w_actions_start;
if (_success) then {
	_warchest = createVehicle [MF_ITEMS_WARCHEST_OBJECT_TYPE, [player, [0,1.5,0]] call relativePos, [], 0, "CAN_COLLIDE"];
	_warchest setDir (getDir player + 180);
	_warchest setVariable ['side', playerSide, true];
	_warchest setVariable ["R3F_LOG_disabled", true];
	_warchest setVariable ["a3w_warchest", true, true];
	pvar_manualObjectSave = netId _warchest;
	publicVariableServer "pvar_manualObjectSave";
	["Warchest Deployed!", 5] call mf_notify_client;
};
_success;
