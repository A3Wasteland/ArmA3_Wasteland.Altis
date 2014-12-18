// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: waitUntilBagTaken.sqf
//	@file Author: AgentRev

_unit = _this select 0;
_bag = _this select 1;

_time = time;
waitUntil {unitBackpack _unit == _bag || time - _time > 3};

if (unitBackpack _unit == _bag) then
{
	_unit setVariable ["waitUntilBagTaken", _bag, true];
};
