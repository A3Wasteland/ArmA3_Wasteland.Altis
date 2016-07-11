// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2016 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_selectRandomNested.sqf
//	@file Author: AgentRev

private _arr = _this;

while {!isNil "_arr" && {_arr isEqualType []}} do
{
	_arr = selectRandom _arr;
};

if (isNil "_arr") then [{nil},{_arr}]
