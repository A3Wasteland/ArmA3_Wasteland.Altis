//	@file Version: 1.1
//	@file Name: pickupMoney.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, AgentRev
//	@file Date modified: 07/12/2012 05:19
//	@file Args:

// Check if mutex lock is active.
if (mutexScriptInProgress) exitWith
{
	player globalChat "You are already performing another action.";
};

mutexScriptInProgress = true;

private ["_pickDistance", "_moneyObjects", "_moneyObj", "_money"];

_pickDistance = 5;

_moneyObjects = nearestObjects [player, ["Land_Money_F"], _pickDistance];

if (count _moneyObjects > 0) then
{
	_moneyObj = _moneyObjects select 0;
};

if (isNil "_moneyObj" || {player distance _moneyObj > _pickDistance}) exitWith
{
	titleText ["You are too far to pick the money up.", "PLAIN DOWN", 0.5];
	mutexScriptInProgress = false;
};

if (vehicle player != player) exitWith
{
	titleText ["You can't pick up money while in a vehicle", "PLAIN DOWN", 0.5];
	player action ["Eject", vehicle player];
	mutexScriptInProgress = false;
};

player playMove ([player, "AmovMstpDnon_AinvMstpDnon", "putdown"] call getFullMove);
sleep 0.5;

_money = _moneyObj getVariable ["cmoney", 0];
deleteVehicle _moneyObj;
if (_money < 0) then { _money = 0 };
player setVariable ["cmoney", (player getVariable ["cmoney", 0]) + _money, true];

if (_money > 0) then
{
	titleText [format ["You have picked up $%1", _money], "PLAIN DOWN", 0.5];
}
else
{
	titleText ["The money was counterfeit!", "PLAIN DOWN", 0.5];
};

sleep 0.5;
mutexScriptInProgress = false;
