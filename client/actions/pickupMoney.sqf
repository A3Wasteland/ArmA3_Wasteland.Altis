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

private ["_bagDistance", "_lockDuration", "_originalState", "_moneyBags", "_moneyBag", "_money"];

_bagDistance = 5;
_lockDuration = 3;
_originalState = animationState player;

_moneyBags = nearestObjects [player, ["Land_Sack_F"], _bagDistance];

if (count _moneyBags > 0) then
{
	_moneyBag = _moneyBags select 0;
};

if (isNil "_moneyBag") exitWith
{
	player globalChat "You are too far to pick the money up.";
	mutexScriptInProgress = false;
};

if (!((toLower (_moneyBag getVariable ["owner", ""])) in ["world", getPlayerUID player])) exitWith
{
	player globalChat "This object is already in use.";
	mutexScriptInProgress = false;
};

_moneyBag setVariable ["owner", getPlayerUID player, true];

for "_i" from 1 to _lockDuration do 
{
	if (vehicle player != player) exitWith
	{
		player globalChat "You can't pick up money while in a vehicle.";
		player action ["eject", vehicle player];
		sleep 1;
		_moneyBag setVariable ["owner", "world", true];
		mutexScriptInProgress = false;
	};
	
	if (animationState player != "AinvPknlMstpSlayWrflDnon_medic") then 
	{
		player switchMove "AinvPknlMstpSlayWrflDnon_medic";
	};
	
	sleep 1;
	
	if (player distance _moneyBag > _bagDistance) exitWith
	{
		_moneyBag setVariable ["owner", "world", true];
		player switchMove _originalState;
		mutexScriptInProgress = false;
		player globalChat "You are too far to pick the money up.";
	};
	
	if (_i >= _lockDuration) exitWith
	{
		_money = _moneyBag getVariable ["money", 0];
		deleteVehicle _moneyBag;
		if (_money < 0) then { _money = 0 };
		player setVariable ["cmoney", (player getVariable ["cmoney", 0]) + _money, true];
		player switchMove _originalState;
		mutexScriptInProgress = false;
		
		if (_money > 0) then
		{
			player globalChat format ["You have picked up $%1", _money];
		}
		else
		{
			player globalChat "The money bag is empty.";
		};
	};
};
