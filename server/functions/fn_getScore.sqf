// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_getScore.sqf
//	@file Author: AgentRev, micovery

private ["_arg1", "_column", "_val", "_var", "_uid"];

_arg1 = _this select 0;
_column = _this select 1;
 _val = 0;

if (isNil "_arg1") exitWith {_val};

private["_type"];
_type =  typeName _arg1;

//arg1 could be either UID, or player object
if (_type == "STRING") then {
  _uid = _arg1;
}
else { if (_type == "OBJECT" && {isPlayer _arg1}) then {
  _uid = getPlayerUID _arg1;
};};

//exit if not a vlaid UID
if (isNil "_uid" || {typeName _uid != "STRING" || {_uid == ""}}) exitWith {_val};


_var = format ["A3W_playerScore_%1_%2", _column, _uid];
_val = missionNamespace getVariable [_var, 0];


_val
