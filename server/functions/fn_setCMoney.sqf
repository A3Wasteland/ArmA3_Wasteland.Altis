// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2018 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_setCMoney.sqf
//	@file Author: AgentRev

// only use this function from the server or the player's own computer - if player A attempts to use it directly on player B, player A will get banned by antihack.
// BE VERY CAREFUL - remoteExecutedOwner propagates across calls, so if player A remoteExecs function X to the server, and X calls setCMoney on player B, player A is banned.

// if _absolute is false, _amount will be added/subtracted to the current cmoney value
// if _absolute is true, cmoney will be set directly to _amount

params [["_player",objNull,[objNull]], ["_amount",0,[0]], ["_absolute",false,[false]]];

if (isNull _player) exitWith {};

private _newAmount = (([_player getVariable ["cmoney",0], 0] select _absolute) + _amount) max 0;

if (isServer) then
{
	if (isRemoteExecuted && remoteExecutedOwner != clientOwner && (remoteExecutedOwner != owner _player || !(_player isKindOf "Man"))) exitWith
	{
		["forged setCMoney", _this] call A3W_fnc_remoteExecIntruder;
	};

	if (alive _player) then
	{
		_player setVariable ["cmoney", _newAmount, true];
	}
	else // we cannot setVariable true if player is dead otherwise it will cause a BattlEye setvariable kick on respawn if "cmoney" is blacklisted
	{
		_player setVariable ["cmoney", _newAmount, false];
		[_player, ["cmoney", _newAmount, false]] remoteExecCall ["setVariable", - clientOwner]; // -2
	};
}
else
{
	// only do a local (false) update if amount is absolute or negative (debit);
	// if amount is positive (credit), we don't want lagswitchers to gain local money while disconnected,
	// which they could spend in stores since those are mostly client-sided
	if (_absolute || _amount < 0) then
	{
		_player setVariable ["cmoney", _newAmount, false];
	};

	_this remoteExecCall ["A3W_fnc_setCMoney", 2];
};
