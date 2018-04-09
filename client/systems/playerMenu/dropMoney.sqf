// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: dropMoney.sqf

#include "dialog\player_sys.sqf";
#define GET_DISPLAY (findDisplay playersys_DIALOG)
#define GET_CTRL(a) (GET_DISPLAY displayCtrl ##a)
#define GET_SELECTED_DATA(a) ([##a] call {_idc = _this select 0;_selection = (lbSelection GET_CTRL(_idc) select 0);if (isNil {_selection}) then {_selection = 0};(GET_CTRL(_idc) lbData _selection)})
if(isNil {dropActive}) then {dropActive = false};
if(isNil {MoneyInUse}) then {MoneyInUse = false};
//if(isnil {player getVariable "cmoney"}) then {player setVariable["cmoney",0,true];};
disableSerialization;

// Check if mutex lock is active.
if(mutexScriptInProgress) exitWith {
	player globalChat "You are already performing another action!";
};

private["_money","_pos","_cash"];
_money = parsenumber(GET_SELECTED_DATA(money_value));

if((player getVariable "cmoney" < _money) OR (player getVariable "cmoney" < 0)) exitwith {hint format["You don't have $%1 to drop", [_money] call fn_numbersText];};

mutexScriptInProgress = true;
//player playMove ([player, "AmovMstpDnon_AinvMstpDnon", "putdown"] call getFullMove);
player playActionNow "PutDown";
sleep 0.25;

// _cash = createVehicle ["Land_Money_F", [player, [0,1,0]] call relativePos, [], 0, "CAN_COLLIDE"];
// _cash setVariable ["cmoney", _money, true];
// _cash setVariable ["owner", "world", true];
// player setVariable ["cmoney", (player getVariable "cmoney") - _money, true];
// [_cash] remoteExec ["A3W_fnc_setItemCleanup", 2];
["dropMoney", player, _money] call A3W_fnc_processTransaction;

if (["A3W_playerSaving"] call isConfigOn) then
{
	[] spawn fn_savePlayerData;
};

sleep 0.75;
mutexScriptInProgress = false;
