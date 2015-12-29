// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: can_access.sqf
//	@file Author: AgentRev, MercifulFate
//	@file Function: mf_items_cratemoney_can_access

#define ERR_IN_VEHICLE "Can't do that while in a vehicle"
#define ERR_TOO_FAR "You are too far away"
#define ERR_LOCKED "This safe is locked" // Added for safe locking

private ["_crate", "_error"];

_crate = call mf_items_cratemoney_nearest;
_error = "failed";

switch (true) do
{
	case (isNull _crate): {};
	case (!alive player): {};
	case (_crate getVariable ["A3W_storeSellBox", false]): {};

	case (player distance _crate > 3): {_error = ERR_TOO_FAR};
	case (vehicle player != player): {_error = ERR_IN_VEHICLE};
	case (_crate getVariable ["lockedSafe", false]): {_error = ERR_LOCKED}; // Added for safe locking

	default {_error = ""};
};

_error
