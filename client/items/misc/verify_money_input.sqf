// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2015 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: verify_money_input.sqf
//	@file Author: AgentRev
//	@file Function: mf_verify_money_input

#define ERR_LESS_THAN_ONE "The amount must be at least $1"

disableSerialization;
private ["_input", "_amount"];
_input = _this;
_amount = 0 max floor parseNumber ctrlText _input;

if (_amount < 1) then
{
	_input ctrlSetText "";
	[ERR_LESS_THAN_ONE, 5] call mf_notify_client;
	playSound "FD_CP_Not_Clear_F";
	ctrlSetFocus _input;
}
else
{
	_input ctrlSetText (_amount call fn_numToStr);
};

_amount
