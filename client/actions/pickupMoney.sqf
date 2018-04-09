// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.1
//	@file Name: pickupMoney.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, AgentRev
//	@file Date modified: 07/12/2012 05:19
//	@file Args:

#define PICK_DISTANCE 5

// Check if mutex lock is active.
if (mutexScriptInProgress) exitWith
{
	player globalChat "You are already performing another action.";
};

if (vehicle player != player) exitWith
{
	titleText ["You can't pick up money while in a vehicle", "PLAIN DOWN", 0.5];
};

mutexScriptInProgress = true;

private ["_moneyObjects", "_moneyObj", "_money"];

_moneyObjects = nearestObjects [player, ["Land_Money_F"], PICK_DISTANCE];

if (count _moneyObjects > 0) then
{
	_moneyObj = _moneyObjects select 0;
};

if (isNil "_moneyObj" || {player distance _moneyObj > PICK_DISTANCE}) exitWith
{
	titleText ["You are too far to pick the money up.", "PLAIN DOWN", 0.5];
	mutexScriptInProgress = false;
};

//player playMove ([player, "AmovMstpDnon_AinvMstpDnon", "putdown"] call getFullMove);
player playActionNow "PutDown";
sleep 0.25;

// pvar_processMoneyPickup = [player, netId _moneyObj];
// publicVariableServer "pvar_processMoneyPickup";
["pickupMoney", player, _moneyObj] call A3W_fnc_processTransaction;

sleep 0.75;
mutexScriptInProgress = false;
